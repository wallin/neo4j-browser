'use strict';

angular.module('neo4jApp.services')
  .factory 'Cypher', [
    '$http',
    '$q'
    ($http, $q) ->
      [NODE, RELATIONSHIP, OTHER] = [1, 2, 3]
      resultType = (data) ->
        if angular.isObject(data) and data.self
          type = if data.self.match('/node/')
            NODE
          else if data.self.match('/relationship/')
            RELATIONSHIP
        else
          type = OTHER
        type

      class CypherResult
        constructor: (@response = {}) ->
          @nodes = []
          @relationships = []
          @other = []
          return unless @response.data?
          for row in @response.data
            for cell in row
              type = resultType(cell)
              switch type
                when NODE         then @nodes.push cell
                when RELATIONSHIP then @relationships.push cell
                else
                  @other.push cell


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
