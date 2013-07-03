'use strict';

angular.module('neo4jApp.services')
  .factory 'viewService', [
    '$http',
    '$rootScope'
    ($http, $rootScope) ->
      class View
        constructor: (@input)->
          @response = null

        exec: ->
          $http.post('http://localhost:7474/db/manage/server/console',
            command: @input
            engine: 'shell'
          ).success((data) =>
            @response =
              input: @input
              text: data[0]
              isError: data[0].indexOf('SyntaxException') == 0 ||
                data[0].indexOf('Unknown command') == 0
              #visualization: angular.copy(dummy)
          )


      class ViewStore
        constructor: ->
          @history = []
          @current = null

        select: (idx) ->
          @current = @history[idx] if @history[idx]
          @currentIdx = idx

        run: (input)->
          return unless input
          @current = new View(input)
          @current.exec()
          @currentIdx = 0
          @history.unshift @current

      new ViewStore
  ]
