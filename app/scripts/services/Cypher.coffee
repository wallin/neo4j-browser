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
        constructor: (@$raw = {}) ->
          angular.extend @, @$raw.data
          @id = parseId(@$raw.self)
          @start = parseId(@$raw.start)
          @end = parseId(@$raw.end)
          @type = @$raw.type

        toString: ->
          JSON.stringify(@$raw.data)

      class CypherNode
        constructor: (@$raw = {}) ->
          angular.extend @, @$raw.data
          @id = parseId(@$raw.self)

        toString: ->
          JSON.stringify(@$raw.data)

      class CypherResult
        constructor: (@_response = {}) ->
          @nodes = []
          @other = []
          @relationships = []
          @size = 0

          @size = @_response.data?.length or 0

          # TODO: determine max result size
          @isTooLarge = !(@size and @size < 1000)
          return if @isTooLarge
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

          @_response

        response: -> @_response

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
          $http.post("http://localhost:7474/db/data/cypher", { query : query })
            .success((result)-> q.resolve(new CypherResult(result)))
            .error((r) -> q.reject(r))
          q.promise

        Node: CypherNode

        Relationship: CypherRelationship

      Cypher = new CypherService()
]
