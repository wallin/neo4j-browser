'use strict';

angular.module('neo4jApp')
  .factory 'terminalService', [
    '$http',
    ($http) ->
      {
        query: ''
        result: ''
        results: []
        run: (query)->
          @query = query if query?
          $http.post('http://localhost:7474/db/manage/server/console',
            command: @query
            engine: 'shell'
          ).success((data) =>
            @query = ""
            @result = data[0]
            @results.push(@result)
          )
      }
  ]
