'use strict';

app = angular.module('neo4jApp')

app
  .factory 'viewService', [
    '$http',
    '$rootScope'
    ($http, $rootScope) ->
      class ViewStore
        constructor: ->
          @history = []
          @current = null

        select: (idx) ->
          @current = @history[idx] if @history[idx]

        run: (input)->
          @input = input if input?
          @current =
            input: @input
            output: null
          @history.push @current
          $rootScope.$broadcast 'views:changed'
          $http.post('http://localhost:7474/db/manage/server/console',
            command: @input
            engine: 'shell'
          ).success((data) =>
            @input = ""
            @current.output = data[0]
          )

      new ViewStore
  ]
