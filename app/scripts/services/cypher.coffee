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

      parseId = (resource) ->
        id = resource.substr(resource.lastIndexOf("/")+1)
        return parseInt(id, 10)

      class Relationship
        constructor: (data) ->
          @id = parseId(data.self)
          @start = parseId(data.start)
          @end = parseId(data.end)
          @type = data.type


      class Node
        constructor: (@$raw) ->
          angular.extend @, @$raw.data
          @id = parseId(@$raw.self)
          @children = []
          @relationships = []

        $traverse: ->
          return unless @id?
          q = $q.defer()
          Cypher.send("START a = node(#{@id}) MATCH a -[r]- b RETURN r, b;").then((result) =>
            @children = result.nodes
            @relationships = result.relationships
            q.resolve(@)
          )
          return q.promise

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
                when NODE         then @nodes.push new Node(cell)
                when RELATIONSHIP then @relationships.push new Relationship(cell)
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

      Cypher = new CypherService()
]
