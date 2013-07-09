'use strict';

angular.module('neo4jApp.services')
  .factory 'graphService', [
    '$http'
    '$q'
    'Cypher'
    'Collection'
    ($http, $q, Cypher, Collection)->

      class GraphModel
        constructor: (cypher) ->
          @nodes = new Collection(cypher.nodes)
          @links = new Collection(cypher.relationships)

        expandAll: ->
          q = $q.defer()
          ids = @nodes.pluck('id')
          return if ids.length is 0
          Cypher.send("START a = node(#{ids.join(',')}) MATCH a -[r]- b RETURN r, b").then((result) =>
            for id in ids
              n = @nodes.get(id)
              n.expanded = yes if n

            for n in result.nodes
              @nodes.add(n) unless @nodes.get(n.id)

            for r in result.relationships
              @links.add(r) unless @links.get(r.id)
              # Connect children
              node = @nodes.get(r.start) or @nodes.get(r.end)
              if node
                r.source = @nodes.get(r.start)
                r.target = @nodes.get(r.end)
                r.incoming = r.end is node.id
                node.relationships.push r
                node.children.push(if r.source.id is node.id then r.target else r.source)

            q.resolve(@)
          )
          q.promise


        expand: (nodeId) ->
          node = @nodes.get(nodeId)
          q = $q.defer()
          if not node?
            q.reject()
            return q.promise

          node.$traverse().then((node)=>
            node.expanded = yes
            for n in node.children
              @nodes.add(n) unless @nodes.get(n.id)
            for n in node.relationships
              if not @links.get(n.id)
                n.source = @nodes.get(n.start)
                n.target = @nodes.get(n.end)
                n.incoming = n.end is node.id
                @links.add(n)

            q.resolve()
          )

          q.promise

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
              @graph.expandAll().then(=> q.resolve(@))
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

