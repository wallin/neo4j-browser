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
.config(['GraphRendererProvider', (GraphRenderer) ->

  linkClass = (d) ->
    if (d.source.expanded and d.target.expanded) then 'link' else 'link faded'
  color = (d) ->
    if d.expanded then "#c6dbef" else "#fd8d3c"

  nodeClass = (d) ->
    if d.expanded then 'node' else 'node faded'

  nodeId = new GraphRenderer.Renderer(
    requiredSize: (node) -> 15
    onTick: (selection) ->
    onGraphChange: (selection) ->
      circles = selection.selectAll("circle").data((node) -> [node])

      circles.enter()
      .append("circle")
      .attr
        cx: (d, i) -> 0
        cy: (d, i) -> 0
        r: 18
        fill: "#BADBDA"
        stroke: "#2F3550"
        "stroke-width": 2.4192

      circles.exit().remove()

      text = selection.selectAll("text").data((node) -> [node])

      text.enter().append("text");

      text
      .text((node) -> node.id)
      .attr
        "alignment-baseline": "middle"
        "text-anchor": "middle"

      text.exit().remove()
  )

  arrowPath = new GraphRenderer.Renderer(
    requiredSize: (node) -> 15
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
      .attr('class', linkClass )
      .attr("xlink:href", (d) ->
        "#path" + d.source.index + "_" + d.target.index
       )

       lines.exit().remove()
  )
  GraphRenderer.nodeRenderers.push(nodeId)
  GraphRenderer.relationshipRenderers.push(arrowPath)
])
