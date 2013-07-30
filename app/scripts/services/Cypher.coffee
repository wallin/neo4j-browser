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

      parseId = (resource = "") ->
        id = resource.split('/').slice(-2, -1)
        return parseInt(id, 10)

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

      class CypherTransaction
        constructor: (query) ->
          @_reset()

        _onSuccess: (r) ->

        _onError: (r) ->

        _reset: ->
          @statements = []
          @id = null

        begin: (query) ->
          q = $q.defer()
          # Begin and commit a transaction if query provided
          if query?
            return Server.transaction(
              path: '/commit'
              statements: [
                statement: query
              ]
            )

          Server.transaction(
            statements: @statements
          ).then(
            (r) =>
              @id = parseId(r.data.commit)
              q.resolve(@)
          )
          q.promise

        execute: (statements) ->
          return unless @id
          statements = [statements] if angular.isString statements
          for s in statements
            @statements.push
              statement: s

          Server.transaction(
            path: '/' + @id
            statements: @statements
          )
          @statements = []

        commit: ->
          return unless @id
          Server.transaction(
            path: "/#{@id}/commit"
          )

        reset: ->
          return unless @id
          Server.transaction(
            path: '/' + @id
            statements: []
          )

        # FIXME: What is wrong?
        # DELETE http://localhost:7474/db/data/transaction/14 415 (Unsupported Media Type)
        rollback: ->
          return unless @id
          Server.transaction(
            method: 'DELETE'
            path: '/' + @id
          ).success(=> @_reset())

      class CypherService
        constructor: ->
          @filters = []

        send: (query, processFilters = yes) ->
          mainQ = $q.defer()
          Server.cypher('?includeStats=true', {query: query})
            .success((result)=>
              result = new CypherResult(result)
              if processFilters and @filters.length > 0
                promises = for filter in @filters
                  q = $q.defer()
                  filter(result, q)
                  q.promise
                $q.all(promises).then(
                  -> mainQ.resolve(result)
                  -> mainQ.reject(result)
                )
              else
                mainQ.resolve(result)
            )
            .error((r) -> mainQ.reject(r))
          mainQ.promise

        transaction: ->
          new CypherTransaction()

      window.Cypher = new CypherService()
]

