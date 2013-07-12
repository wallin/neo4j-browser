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

      class View
        constructor: (data = {})->
          @starred = no
          @response = null
          @input = null
          if angular.isObject(data)
            angular.extend(@, data)
          else if angular.isString(data)
            @input = data
          @id ?= UUID.genV1().toString()

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

        toggleStar: ->
          @starred = !@starred
          viewStore.persist()

      # TODO: Make better API for views
      class ViewStore
        constructor: ->
          @history = new Collection()
          @current = null

          for example in defaultQueries
            view = @create(example[1].trim(), example[0])
            view.starred = yes

          savedScripts = @persisted()

          if angular.isArray(savedScripts)
            for v in savedScripts
              view = new View(input: v.input, id: v.id)
              view.starred = yes
              @add(view)

        add: (view) ->
          @history.add view unless @history.get(view.id)

        persist: ->
          localStorageService.add('saved', JSON.stringify(@history.where(starred: true)))

        persisted: ->
          JSON.parse(localStorageService.get('saved'))

        create: (input, id)->
          view = new View(input: input, id: id)
          @add view

        select: (id) ->
          @current = @history.get id
          $rootScope.$broadcast 'viewService:changed', @current


      viewStore = new ViewStore


      viewStore
  ]
