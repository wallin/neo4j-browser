'use strict';

angular.module('neo4jApp')
  .service 'GraphGeometry', [
    'GraphStyle',
    (GraphStyle) ->

      square = (distance) -> distance * distance

      setNodeRadii = (nodes) ->
        for node in nodes
          node.radius = parseFloat(GraphStyle.forNode(node).get("diameter")) / 2

      formatNodeCaptions = (nodes) ->
        for node in nodes
          template = GraphStyle.forNode(node).get("caption")
          captionText = GraphStyle.interpolate(template, node.id, node.propertyMap)
          words = captionText.split(" ")
          lines = []
          for i in [0..words.length - 1]
            lines.push(
              node: node
              text: words[i]
              baseline: (1 + i - words.length / 2) * 10
            )
          node.caption = lines

      layoutRelationships = (relationships) ->
        for relationship in relationships
          dx = relationship.target.x - relationship.source.x
          dy = relationship.target.y - relationship.source.y
          length = Math.sqrt(square(dx) + square(dy))
          alongPath = (from, distance) ->
            x: from.x + dx * distance / length
            y: from.y + dy * distance / length

          relationship.startPoint = alongPath(relationship.source, relationship.source.radius)
          relationship.endPoint = alongPath(relationship.target, -relationship.target.radius)
          relationship.midShaftPoint = alongPath(relationship.startPoint,
            (length - relationship.source.radius - relationship.target.radius - 10) / 2)
          relationship.angle = Math.atan2(dy, dx) / Math.PI * 180
          if relationship.angle < -90 or relationship.angle > 90
            relationship.angle += 180

      @onGraphChange = (graph) ->
        setNodeRadii(graph.nodes.all())
        formatNodeCaptions(graph.nodes.all())

      @onTick = (graph) ->
        layoutRelationships(graph.relationships.all())
  ]