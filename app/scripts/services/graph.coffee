'use strict';

angular.module('neo4jApp.services')
  .factory 'graphService', [
    '$http'
    '$q'
    ($http, $q)->
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
