'use strict';

angular.module('neo4jApp.services')
  .factory 'graphService', [
    '$http'
    '$q'
    'cypher'
    'Collection'
    ($http, $q, cypher, Collection)->

      parseId = (resource) ->
        +resource.substr(resource.lastIndexOf("/")+1)

      class GraphModel
        constructor: (cypher) ->
          nodes = (new Node(n) for n in cypher.nodes())
          @nodes = new Collection(nodes)
          @links = new Collection()

        expand: (nodeId) ->
          node = @nodes.get(nodeId)
          q = $q.defer()
          if not node?
            q.reject()
            return q.promise

          node.$traverse().then((result)=>
            for n in result[0].children
              @nodes.add(n) unless @nodes.get(n.id)
            for n in result[0].relations
              @links.add(n) unless @links.get(n.id)
            q.resolve()
          )

          q.promise

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
          cypher.send(query).then(
            (result) =>
              @_clear()
              @graph   = new GraphModel(result)
              @rows    = result.rows()
              @columns = result.columns()
              q.resolve(@)
          ,
            (error) =>
              @_clear()
              @error = error
              q.reject(@)
          )
          return q.promise

        _clear : ->
          @rows    = []
          @columns = []
          @graph   = null
          @error   = null
          @isLoading = false

      new GraphService
  ]

