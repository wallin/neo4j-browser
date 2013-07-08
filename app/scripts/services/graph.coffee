'use strict';

angular.module('neo4jApp.services')
  .factory 'graphService', [
    '$http'
    '$q'
    'Cypher'
    'Collection'
    ($http, $q, Cypher, Collection)->

      parseId = (resource) ->
        id = resource.substr(resource.lastIndexOf("/")+1)
        return parseInt(id, 10)

      class GraphModel
        constructor: (cypher) ->
          nodes = (new Node(n) for n in cypher.nodes)
          links = (new Relationship(n) for n in cypher.relationships)
          @nodes = new Collection(nodes)
          @links = new Collection(links)

        expand: (nodeId) ->
          node = @nodes.get(nodeId)
          q = $q.defer()
          if not node?
            q.reject()
            return q.promise

          node.$traverse().then((result)=>
            for n in result.children
              @nodes.add(n) unless @nodes.get(n.id)
            for n in result.relations
              unless @links.get(n.id)
                # XXX
                n.source = @nodes.get(n.start)
                n.target = @nodes.get(n.end)
                # TODO: mark relation as either incoming or outgoing
                if n.end is node.id
                  [n.source, n.target] = [n.target, n.source]
                # Inherit position from parent
                n.target.x = node.x
                n.target.y = node.y
                @links.add(n)

            q.resolve()
          )

          q.promise

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
          @children = null
          @relations = null

        $traverse: ->
          return unless @$raw.self
          q = $q.defer()
          Cypher.send("START a = node(#{@id}) MATCH a -[r]- b RETURN r, b;").then((result) =>
            @children = (new Node(n) for n in result.nodes)
            @relations = (new Relationship(r) for r in result.relationships)
            q.resolve(@)
          )
          return q.promise

      class GraphService

        constructor : () ->
          @nodes = []
          @_clear()

        executeQuery : (query) ->
          return unless query
          @_clear()
          @isLoading = true

          q = $q.defer()
          Cypher.send(query).then(
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

