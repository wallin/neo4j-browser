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

        expandAll: ->
          q = $q.defer()
          ids = (n.id for n in @nodes.all())
          Cypher.send("START a = node(#{ids.join(',')}) MATCH a -[r]- b RETURN r, b").then((result) =>
            for n in result.nodes
              n = new Node(n)
              @nodes.add(n) unless @nodes.get(n.id)

            for r in result.relationships
              r = new Relationship(r)
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
          @children = []
          @relationships = []
          @expanded = false;

        $traverse: ->
          return unless @id?
          q = $q.defer()
          Cypher.send("START a = node(#{@id}) MATCH a -[r]- b RETURN r, b;").then((result) =>
            @children = (new Node(n) for n in result.nodes)
            @relationships = (new Relationship(r) for r in result.relationships)
            @expanded = true
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

