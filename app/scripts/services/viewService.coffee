'use strict';

defaultQueries = [
  ["example_1", """
// Example table data
start user=node(*)
match user-[:FRIEND]-friend-[r:RATED]->movie
where r.stars > 3
return friend.name, movie.title, r.stars, r.comment?
  """]
  ["example_2", """
// Example node data
start n=node(0,343)
return n
  """]
]

defaultFolders = [
  ["tutorials", "Tutorials"]
]

angular.module('neo4jApp.services')
  .factory 'viewService', [
    '$http',
    '$rootScope'
    'Collection'
    'Cypher'
    'localStorageService'
    'Timer'
    ($http, $rootScope, Collection, Cypher, localStorageService, Timer) ->
      viewStore = null
      stripComments = (input) ->
        rows = input.split("\n")
        rv = []
        rv.push row for row in rows when row.indexOf('//') isnt 0
        rv.join("\n")

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

        toggle: ->
          @expanded = !@expanded
          viewStore.persist('folders')

      class View extends IdAble
        constructor: (data = {})->
          @starred = no
          @folder = no
          super data

          if angular.isString(data)
            @input = data

        exec: ->
          query = stripComments(@input.trim())
          return if query.length is 0

          query = query + ";" unless query.endsWith(';')
          @errorText = no
          @hasErrors = no
          @isLoading = yes
          @response  = null
          timer = Timer.start()
          @startTime = timer.started()
          viewStore.persist()

          Cypher.send(query).then(
            (cypherResult) =>
              @isLoading = no
              if cypherResult.isTooLarge
                @hasErrors = yes
                @errorText = "Resultset is too large"
              else
                @response = cypherResult
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

        suggestedLayout: ->
          return {
            table: @response?.other.length > 0
            graph: !@response?.isTextOnly()
          }

        revertCode: ->
          @input = @savedInput

      # TODO: Make better API for views
      class ViewStore
        constructor: ->

        # Return default content
        default: (type = 'views') ->
          switch type
            when 'views'
              for example in defaultQueries
                view = new View(input: example[1].trim(), id: example[0])
                view.starred = yes
                view.folder = 'tutorials'
                view
            when 'folders'
              new Folder(id: f[0], name: f[1]) for f in defaultFolders

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
              when 'folder'  then new Folder(p)

        View: View
        Folder: Folder

      viewStore = new ViewStore


      viewStore
  ]
