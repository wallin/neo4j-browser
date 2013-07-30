'use strict';

angular.module('neo4jApp.services')
.provider 'viewService', [
  ->
    viewStore = null

    class IdAble
      constructor: (data = {})->
        if angular.isObject(data)
          angular.extend(@, data)
        @id ?= UUID.genV1().toString()


    class Folder extends IdAble
      constructor: (data) ->
        @expanded = yes
        super data
        @name ?= 'Unnamed folder'

      toJSON: ->
        {@id, @name, @expanded}

    self = @
    @defaultQueries = []
    @defaultFolders = []

    @interpretors = []

    @$get = [
      '$injector',
      '$q',
      '$rootScope'
      'Collection'
      'Cypher'
      'localStorageService'
      'Timer'
      'Utils'
      ($injector, $q, $rootScope, Collection, Cypher, localStorageService, Timer, Utils) ->
        class View extends IdAble
          constructor: (data = {})->
            @starred = no
            @folder = no
            super data

            if angular.isString(data)
              @input = data

          toJSON: ->
            {@id, @starred, @folder, @input}

          exec: ->
            # Find correct interpretator
            intr = i for i in self.interpretors when i.type is 'cypher'
            # TODO: default interpretator
            return unless intr
            intrFn = $injector.invoke(intr.exec)

            query = Utils.stripComments(@input.trim())

            #query = query + ";" unless query.endsWith(';')
            @errorText = no
            @hasErrors = no
            @isLoading = yes
            @response  = null
            timer = Timer.start()
            @startTime = timer.started()
            viewStore.persist()


            $q.when(intrFn(query, $q.defer())).then(
              (result) =>
                @isLoading = no
                if result.isTooLarge
                  @hasErrors = yes
                  @errorText = "Resultset is too large"
                else
                  @response = result
                  @savedInput = @input
                @runTime = timer.stop().time()
                $rootScope.$broadcast 'viewService:changed', @
              ,
              (result = {}) =>
                @isLoading = no
                @hasErrors = yes
                if result.exception and result.message
                  @errorText = result.exception + ": " + result.message.split("\n")[0]
                else
                  @errorText = "Empty response"
                @runTime = timer.stop().time()
            )

          revertCode: ->
            @input = @savedInput


        # TODO: Make better API for views
        class ViewStore
          constructor: ->

          # Clear stored content
          clear: (types = ['views', 'folders']) ->
            types = [types] if angular.isString types
            for t in types
              localStorageService.remove t

          # Return default content
          default: (type = 'views') ->
            switch type
              when 'views'
                for example in self.defaultQueries
                  view = new View(input: example[1].trim(), id: example[0])
                  view.starred = yes
                  view.folder = 'tutorials'
                  view
              when 'folders'
                new Folder(id: f[0], name: f[1]) for f in self.defaultFolders

          # Persist content
          persist: (type = 'views', data) ->
            localStorageService.add(type, JSON.stringify(data))

          # Return persisted content
          persisted: (type = 'views') ->
            persisted = JSON.parse(localStorageService.get(type))
            return [] unless angular.isArray(persisted)
            for p in persisted
              switch type
                when 'views' then new View(p)
                when 'folders'  then new Folder(p)

          View: View
          Folder: Folder

        viewStore = new ViewStore
        viewStore
    ]
    @
]
