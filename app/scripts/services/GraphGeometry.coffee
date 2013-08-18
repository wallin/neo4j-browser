'use strict';

angular.module('neo4jApp')
  .service 'GraphGeometry', [() ->

    square = (distance) -> distance * distance

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
        relationship.midShaftPoint = alongPath(relationship.startPoint, (length - relationship.source.radius - relationship.target.radius - 10) / 2)
        relationship.angle = Math.atan2(dy, dx) / Math.PI * 180
        if relationship.angle < -90 or relationship.angle > 90
          relationship.angle += 180

    @onTick = (graph) ->
      layoutRelationships(graph.relationships.all())
  ]