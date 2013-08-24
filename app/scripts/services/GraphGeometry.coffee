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
          relationship.arrowLength =
            length - relationship.source.radius - relationship.target.radius
          alongPath = (from, distance) ->
            x: from.x + dx * distance / length
            y: from.y + dy * distance / length

          relationship.startPoint = alongPath(relationship.source, relationship.source.radius)
          relationship.endPoint = alongPath(relationship.target, -relationship.target.radius)
          relationship.midShaftPoint = alongPath(relationship.startPoint,
            (relationship.arrowLength - 10) / 2)
          relationship.angle = Math.atan2(dy, dx) / Math.PI * 180
          relationship.textAngle = relationship.angle
          if relationship.angle < -90 or relationship.angle > 90
            relationship.textAngle += 180

      calculateArrowOutlines = (relationships) ->
        for relationship in relationships
          shaftRadius = parseFloat(GraphStyle.forRelationship(relationship).get("shaft-width")) / 2
          headRadius = shaftRadius + 3
          headHeight = headRadius * 2
          neckHeight = relationship.arrowLength - headHeight

          relationship.arrowOutline = [
            "M", 0, shaftRadius,
            "L", neckHeight, shaftRadius,
            "L", neckHeight, headRadius,
            "L", relationship.arrowLength, 0,
            "L", neckHeight, -headRadius,
            "L", neckHeight, -shaftRadius,
            "L", 0, -shaftRadius,
            "Z"
          ].join(" ")

      @onGraphChange = (graph) ->
        setNodeRadii(graph.nodes.all())
        formatNodeCaptions(graph.nodes.all())

      @onTick = (graph) ->
        layoutRelationships(graph.relationships.all())
        calculateArrowOutlines(graph.relationships.all())
  ]