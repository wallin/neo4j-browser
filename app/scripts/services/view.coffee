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
    'localStorageService'
    ($http, $rootScope, Collection, localStorageService) ->
      class View
        constructor: (@input, @id)->
          @starred = false
          @response = null

        toggleStar: ->
          @starred = !@starred

        exec: ->
          @isLoading = yes
          $http.post('http://localhost:7474/db/manage/server/console',
            command: @input
            engine: 'shell'
          ).success((data) =>
            @isLoading  = no
            @response =
              input: @input
              text: data[0]
              hasErrors: data[0].indexOf('SyntaxException') is 0 or
                data[0].indexOf('Unknown command') is 0
            if @response.hasErrors
              @response.errorText = data[0].split("\n\n")[0]
          ).error(->
            @hasErrors = yes
            @errorText = "Sorry, something went wrong"
            @isLoading   = no
          )


      class ViewStore
        constructor: ->
          @history = new Collection()
          @current = null

        push: (input)->
          view = new View(input, @history.all().length)
          @history.add view

        select: (id) ->
          # id is reversed index
          @current = @history.get id

        star: (id) ->


        run: (input)->
          return unless input
          view = @push(input)
          @select(view.id)
          @current.exec()

      ViewStore = new ViewStore

      for example in defaultQueries
        view = ViewStore.push(example.trim())
        view.toggleStar()

      ViewStore
  ]
