'use strict';

angular.module('neo4jApp.services')
  .factory 'GraphModel', [
    'Node', 'Relationship'
    (Node, Relationship) ->

      class GraphModel
        constructor: (cypher) ->
          @nodeMap = {}
          @relationshipMap = {}

          for node in cypher.nodes
            @addNode(node)
          for relationship in cypher.relationships
            @addRelationship(relationship)

        nodes: ->
          value for own key, value of @nodeMap

        relationships: ->
          value for own key, value of @relationshipMap

        addNode: (raw) ->
          @nodeMap[raw.id] ||= new Node(raw.id, raw.labels, raw.properties)

        addRelationship: (raw) ->
          source = @nodeMap[raw.startNode] or throw malformed()
          target = @nodeMap[raw.endNode] or throw malformed()
          @relationshipMap[raw.id] = new Relationship(raw.id, source, target, raw.type, raw.properties)

        merge: (result) ->
          @addNode(n) for n in result.nodes
          @addRelationships(result.relationships)

        addRelationships: (relationships) ->
          @addRelationship(r) for r in relationships

        boundingBox: ->
          axes =
            x: (node) -> node.x
            y: (node) -> node.y

          bounds = {}

          for key,accessor of axes
            bounds[key] =
              min: Math.min.apply(null, @nodes().map((node) ->
                accessor(node) - node.radius))
              max: Math.max.apply(null, @nodes().map((node) ->
                accessor(node) + node.radius))

          bounds

      malformed = ->
        new Error('Malformed graph: must add nodes before relationships that connect them')

      GraphModel
]
