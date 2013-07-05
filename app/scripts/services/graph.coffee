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

      parseId = (resource) ->
        +resource.substr(resource.lastIndexOf("/")+1)

      class Relationship
        constructor: (data) ->
          @id = parseId(data.self)
          @start = parseId(data.start)
          @source = @start
          @target = parseId(data.end)
          @type = data.type


      class Node
        constructor: (@$raw) ->
          angular.extend @, @$raw.data
          @id = parseId(@$raw.self)
          @children = null
          @relations = null

        $traverse: ->
          return unless @$raw.self
          q = $q.defer()
          q2 = $q.defer()
          $http.post(@$raw.self + '/traverse/node')
            .success((result) =>
              @children = (new Node(n) for n in result)
              q.resolve(@)
            )
            .error(=> q.reject(@))

          $http.get(@$raw.self + '/relationships/all')
            .success((result) =>
              @relations = (new Relationship(r) for r in result)
              q2.resolve(@)
            )
            .error(=> q2.reject(@))
          return $q.all([q.promise, q2.promise])

      class GraphService

        constructor : () ->
          @nodes = []
          @_clear()

        executeQuery : (query) ->
          return unless query
          @_clear()
          @isLoading = true

          q = $q.defer()
          $http.post("http://localhost:7474/db/data/cypher", { query : query })
            .success((result) =>
              @_clear()
              @nodes = createNodesFromResult(result.data)
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

