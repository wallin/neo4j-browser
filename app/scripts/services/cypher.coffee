'use strict';

angular.module('neo4jApp.services')
  .factory 'cypher', [
    '$http',
    ($http) ->
      class CypherService
        constructor: ->

        send: (query) ->
          $http.post("http://localhost:7474/db/data/cypher", { query : query })

      new CypherService()
]
