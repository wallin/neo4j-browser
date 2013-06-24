'use strict';

angular.module('neo4jApp')
  .factory 'terminal', [
    '$http',
    ($http) ->
      {
        query: ''
        results: []
        run: ->
          $http.post('http://localhost:7474/db/manage/server/console',
            command: @query
            engine: 'shell'
          ).success((data) =>
            @query = ""
            @results.push(data[0])
          )
      }
  ]
