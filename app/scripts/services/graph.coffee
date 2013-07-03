'use strict';

angular.module('neo4jApp.services')
  .factory 'graphService', [
    '$http'
    '$q'
    ($http, $q)->

      createNodesFromResult = (data) ->
        rv = []
        for row in data
          for cell in row
            rv.push new Node(cell)
        rv

      class Node
        constructor: (@$raw) ->
          angular.extend @, @$raw.data
          @id = +@$raw.self.substr(@$raw.self.lastIndexOf("/")+1)
          @$neighbors = null

        $traverse: ->
          return unless @$raw.self
          q = $q.defer()
          $http.get(@$raw.self + '/traverse')
            .success((result) =>
              @$neighbors = createNodesFromResult(result)
              q.resolve(@)
            )
            .error(=> q.reject(@))
          return q.promise

      class GraphService

        constructor : () ->
          @_clear()
          @query = "// Enter query "

        executeQuery : (query = "START n=node(*) RETURN n;") ->
          @_clear()
          @query     = query
          @isLoading = true

          q = $q.defer()
          $http.post("http://localhost:7474/db/data/cypher", { query : query })
            .success((result) =>
              @_clear()
              @nodes = createNodesFromResult(result.data)
              @links = []
              @rows    = result.data.map @_cleanResultRow
              @columns = result.columns
              q.resolve(@)
            )
            .error((error) =>
              @_clear()
              @error = error
              q.reject(@)
            )
          return q.promise

        _cleanResultRow : (row) ->
          for cell in row
            if not (cell?)
              null
            else if cell.self?
              cell.data
            else
              cell

        _clear : ->
          @rows    = []
          @columns = []
          @error   = null
          @isLoading = false

      new GraphService
  ]

