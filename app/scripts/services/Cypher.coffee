'use strict';

angular.module('neo4jApp.services')
  .factory 'Cypher', [
    '$q'
    '$rootScope'
    'Node'
    'Relationship'
    'Server'
    ($q, $rootScope, Node, Relationship, Server) ->
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
        constructor: (@_response = {}) ->
          @nodes = []
          @other = []
          @relationships = []
          @size = 0

          @size = @_response.data?.length or 0

          @_setStats @_response.stats

          # TODO: determine max result size
          @isTooLarge = !(@size? and @size < 1000)
          return if @isTooLarge
          @_response.data ?= []
          return @_response unless @_response.data?
          for row in @_response.data
            for cell in row
              type = resultType(cell)
              switch type
                when NODE         then @nodes.push new Node(cell)
                when RELATIONSHIP then @relationships.push new Relationship(cell)
                else
                  @other.push cell

          @_response

        response: -> @_response

        rows: ->
          # TODO: Maybe cache rows
          for row in @_response.data
            for cell in row
              if not (cell?)
                null
              else if cell.self?
                angular.copy(cell.data)
              else
                angular.copy(cell)

        columns: ->
          @_response.columns

        # Tell wether the result is pure text (ie. no nodes or relations)
        isTextOnly: ->
          @nodes.length is 0 and @relationships.length is 0

        _setStats: (@stats) ->
          $rootScope.$broadcast 'db:result:containsUpdates', angular.copy(@stats) if @stats?.containsUpdates

      class CypherService
        constructor: ->

        send: (query) ->
          q = $q.defer()
          Server.cypher('?includeStats=true', {query: query})
            .success((result)-> q.resolve(new CypherResult(result)))
            .error((r) -> q.reject(r))
          q.promise

      Cypher = new CypherService()
]
