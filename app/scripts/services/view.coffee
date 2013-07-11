'use strict';

defaultQueries = [
  """
// Example table data
start user=node(*)
match user-[:FRIEND]-friend-[r:RATED]->movie
where r.stars > 3
return friend.name, movie.title, r.stars, r.comment?
  """
  """
// Example node data
start n=node(0,343)
return n
  """
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
        constructor: (@input = '', @id)->
          @starred = no
          @response = null

        toggleStar: ->
          @starred = !@starred
          viewStore.persist()

        exec: ->
          query = stripComments(@input.trim())
          return if query.length is 0

          query = query + ";" unless query.endsWith(';')
          @isLoading = yes
          @response  = null
          timer = Timer.start()
          @startTime = timer.started()
          viewStore.persist()

          Cypher.send(query).then(
            (cypherResult) =>
              @isLoading = no
              @errorText = no
              if cypherResult.isTooLarge
                @hasErrors = yes
                @errorText = "Resultset is too large"
              else
                @hasErrors = no
                @response = cypherResult
              @runTime = timer.stop().time()
            ,
            (result) =>
              @isLoading = no
              @hasErrors = yes
              @errorText = result.exception + ": " + result.message.split("\n")[0]
              @runTime = timer.stop().time()
          )

      # TODO: Make better API for views
      class ViewStore
        constructor: ->
          @history = new Collection()
          @current = null

          for example in defaultQueries
            view = @push(example.trim())
            view.starred = yes

          savedScripts = @persisted()

          if angular.isArray(savedScripts)
            for v in savedScripts
              view = new View(v.input, v.id)
              view.starred = yes
              @add(view)

        add: (view) ->
          @history.add view unless @history.get(view.id)

        persist: ->
          localStorageService.add('saved', JSON.stringify(@history.where(starred: true)))

        persisted: ->
          JSON.parse(localStorageService.get('saved'))

        push: (input)->
          view = new View(input, @history.all().length)
          @add view

        select: (id) ->
          @current = @history.get id


      viewStore = new ViewStore


      viewStore
  ]
