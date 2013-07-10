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

      parseId = (resource = "") ->
        id = resource.substr(resource.lastIndexOf("/")+1)
        return parseInt(id, 10)

      class CypherRelationship
        constructor: (data = {}) ->
          @id = parseId(data.self)
          @start = parseId(data.start)
          @end = parseId(data.end)
          @type = data.type

      class CypherNode
        constructor: (@$raw = {}) ->
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

        toString: ->
          JSON.stringify(@$raw.data)

      class CypherResult
        constructor: (@_response = {}) ->
          @queryTime = (new Date()).getTime()
          @clear()

        clear: ->
          @nodes = []
          @relationships = []
          @other = []

        response: (r) ->
          return @_response unless r?
          @_response = r
          @_response.data ?= []
          return @_response unless @_response.data?
          for row in @_response.data
            for cell in row
              type = resultType(cell)
              switch type
                when NODE         then @nodes.push new CypherNode(cell)
                when RELATIONSHIP then @relationships.push new CypherRelationship(cell)
                else
                  @other.push cell
          @queryTime = (new Date()).getTime() - @queryTime
          @_response

        rows: ->
          for row in @_response.data
            for cell in row
              if not (cell?)
                null
              else if cell.self?
                cell.data
              else
                cell

        columns: ->
          @_response.columns

        # Tell wether the result is pure text (ie. no nodes or relations)
        isTextOnly: ->
          @nodes.length is 0 and @relationships.length is 0


      class CypherService
        constructor: ->

        send: (query) ->
          q = $q.defer()
          res = new CypherResult()
          $http.post("http://localhost:7474/db/data/cypher", { query : query })
            .success((result)->
              res.response(result)
              q.resolve(res)
            )
            .error(-> q.reject())
          q.promise

        Node: CypherNode

        Relationship: CypherRelationship

      Cypher = new CypherService()
]
