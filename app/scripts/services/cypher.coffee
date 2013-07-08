'use strict';

angular.module('neo4jApp.services')
  .factory 'cypher', [
    '$http',
    '$q'
    ($http, $q) ->

      class CypherResult
        constructor: (@response = []) ->

        nodes: ->
          rv = []
          for row in @response.data
            for cell in row
              rv.push cell
          rv

        rows: ->
          @response.data.map (row) ->
            for cell in row
              if not (cell?)
                null
              else if cell.self?
                cell.data
              else
                cell

        columns: ->
          @response.columns


      class CypherService
        constructor: ->

        send: (query) ->
          q = $q.defer()
          $http.post("http://localhost:7474/db/data/cypher", { query : query })
            .success((result)-> q.resolve(new CypherResult(result)))
            .error(-> q.reject())
          q.promise

      new CypherService()
]
