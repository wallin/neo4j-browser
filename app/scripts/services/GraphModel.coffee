'use strict';

angular.module('neo4jApp.services')
  .factory 'GraphModel', [
    'Collection'
    (Collection) ->
      class GraphModel
        constructor: (cypher = {}) ->
          @nodes = new Collection(cypher.nodes)
          @relationships = new Collection(cypher.relationships)

        addNode: (node) ->
          return false unless node?.id?
          # TODO: merge nodes if already existing
          @nodes.add(node) unless @nodes.get(node.id)
          node

        addRelationship: (rel) ->
          return false unless rel?.id?
          @relationships.add(rel) unless @relationships.get(rel.id)
          node = @nodes.get(rel.start) or @nodes.get(rel.end)

          # Connect children if they are missing
          if node and not (node.source and source.target)
            rel.source = @nodes.get(rel.start)
            rel.target = @nodes.get(rel.end)
            rel.incoming = rel.end is node.id

          rel

        merge: (result = {}, localNode = {}) ->
          # Add result to current graph
          if result.nodes?
            # Set initial location based on existing node, if supplied
            if localNode.x? && localNode.y?
              nodeCount = result.nodes.length
              linkDistance = 60
              for i in [0..nodeCount-1]
                n = result.nodes[i]
                n.x = localNode.x + linkDistance * Math.sin(2 * Math.PI * i / nodeCount)
                n.y = localNode.y + linkDistance * Math.cos(2 * Math.PI * i / nodeCount)
            @addNode(n) for n in result.nodes
          if result.relationships?
            @addRelationship(r) for r in result.relationships

        boundingBox: ->
          axes =
            x: (node) -> node.x
            y: (node) -> node.y

          bounds = {}

          for key,accessor of axes
            bounds[key] =
              min: Math.min.apply(null, @nodes.all().map((node) ->
                accessor(node) - node.radius))
              max: Math.max.apply(null, @nodes.all().map((node) ->
                accessor(node) + node.radius))

          bounds

      GraphModel
]
