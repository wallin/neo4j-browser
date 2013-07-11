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

        exec: ->
          query = stripComments(@input.trim())
          return if query.length is 0
          query = query + ";" unless query.endsWith(';')
          @isLoading = yes
          @hasErrors = no
          @response  = null
          timer = Timer.start()
          @startTime = timer.started()
          Cypher.send(query).then(
            (cypherResult) =>
              @isLoading = no
              @errorText = no
              @response = cypherResult
              @runTime = timer.stop().time()
            ,
            (result) =>
              @isLoading = no
              @hasErrors = yes
              @errorText = result.exception + ": " + result.message
              @runTime = timer.stop().time()
          )

      # TODO: Make better API for views
      class ViewStore
        constructor: ->
          @history = new Collection()
          @current = null

        add: (view) ->
          @history.add view unless @history.get(view.id)

        push: (input)->
          view = new View(input, @history.all().length)
          @add view

        select: (id) ->
          @current = @history.get id

        toggleStar: (id) ->
          view = @history.get(id)
          return unless view?
          view.toggleStar()
          localStorageService.add('saved', JSON.stringify(@history.where(starred: true)))

        run: (input)->
          return unless input
          view = @push(input)
          @select(view.id)
          @current.exec()

      ViewStore = new ViewStore

      for example in defaultQueries
        view = ViewStore.push(example.trim())
        view.toggleStar()

      savedScripts = JSON.parse(localStorageService.get('saved'))

      if angular.isArray(savedScripts)
        for v in savedScripts
          view = new View(v.input, v.id)
          view.toggleStar()
          ViewStore.add(view)


      ViewStore
  ]
