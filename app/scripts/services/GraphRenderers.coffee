'use strict';

angular.module('neo4jApp.services')
  .provider 'GraphRenderer', [->
    class @Renderer
      constructor: (opts = {})->
        angular.extend(@, opts)
        @requiredSize ?= ->
        @onGraphChange ?= ->
        @onTick ?= ->

    @nodeRenderers         = []
    @relationshipRenderers = []

    @$get = ->
      return {
        nodeRenderers: @nodeRenderers
        relationshipRenderers: @relationshipRenderers
        Renderer: @Renderer
      }
    @
  ]

angular.module('neo4jApp.services')
.run([
  'GraphRenderer',
  'GraphStyle',
  (GraphRenderer, GraphStyle) ->

    linkClass = (d) ->
      if (d.source.expanded and d.target.expanded) then 'link' else 'link faded'
    color = (d) ->
      if d.expanded then "#c6dbef" else "#fd8d3c"

    nodeClass = (d) ->
      if d.expanded then 'node' else 'node faded'

    formatCaption = (node) ->
      GraphStyle.forNode(node).get("caption")

    nodeOutline = new GraphRenderer.Renderer(
      requiredSize: (node) -> 15
      onGraphChange: (selection) ->
        circles = selection.selectAll("circle").data((node) -> [node])

        circles.enter()
        .append("circle")
        .attr
          cx: (d, i) -> 0
          cy: (d, i) -> 0
          r: (node) -> node.radius
          fill: (node) -> GraphStyle.forNode(node).get("fill")
          stroke: (node) -> GraphStyle.forNode(node).get("stroke")
          "stroke-width": (node) -> GraphStyle.forNode(node).get("stroke-width")

        circles.exit().remove()
      onTick: (selection) ->
    )

    nodeCaption = new GraphRenderer.Renderer(
      requiredSize: (node) -> 15
      onGraphChange: (selection) ->
        text = selection.selectAll("text").data((node) -> [node])

        text.enter().append("text")
        .text((node) -> formatCaption(node))
        .attr
          "alignment-baseline": "middle"
          "text-anchor": "middle"

        text.exit().remove()

      onTick: (selection) ->
    )

    arrowPath = new GraphRenderer.Renderer(
      requiredSize: ->
      onTick: (selection) ->
        selection.selectAll("line")
        .attr("x1", (d) -> d.source.x)
        .attr("y1", (d) -> d.source.y)
        .attr("x2", (d) -> d.target.x)
        .attr("y2", (d) -> d.target.y)

      onGraphChange: (selection) ->
        lines = selection.selectAll("line").data((rel) -> [rel])

        lines.enter()
        .append("line")
        .attr('marker-start', (d) -> 'url(#arrow-start)' if d.incoming)
        .attr('marker-end', (d) -> 'url(#arrow-end)' unless d.incoming)
        .attr('fill', (rel) -> GraphStyle.forRelationship(rel).get('fill'))
        .attr('stroke', (rel) -> GraphStyle.forRelationship(rel).get('stroke'))
        .attr('stroke-width', (rel) -> GraphStyle.forRelationship(rel).get('stroke-width'))
        .attr("xlink:href", (d) ->
          "#path" + d.source.index + "_" + d.target.index
         )

         lines.exit().remove()
    )
    GraphRenderer.nodeRenderers.push(nodeOutline)
    GraphRenderer.nodeRenderers.push(nodeCaption)
    GraphRenderer.relationshipRenderers.push(arrowPath)
])
