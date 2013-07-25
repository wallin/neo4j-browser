angular.module('neo4jApp.services')
.run([
  'GraphRenderer',
  'GraphStyle',
  (GraphRenderer, GraphStyle) ->

    formatCaption = (node) ->
      tmpl = GraphStyle.forNode(node).get("caption")
      GraphStyle.interpolate(tmpl, node)

    noop = ->

    nodeOutline = new GraphRenderer.Renderer(
      requiredSize: (node) -> 15
      onGraphChange: (selection) ->
        circles = selection.selectAll("circle.outline").data(
          (node) -> [node]
        )

        circles.enter()
        .append("circle")
        .classed('outline', true)
        .attr
          cx: (d, i) -> 0
          cy: (d, i) -> 0

        circles
        .attr
          r: (node) -> node.radius
          fill: (node) -> GraphStyle.forNode(node).get("fill")
          stroke: (node) -> GraphStyle.forNode(node).get("stroke")
          "stroke-width": (node) -> GraphStyle.forNode(node).get("stroke-width")

        circles.exit().remove()
      onTick: noop
    )

    nodeCaption = new GraphRenderer.Renderer(
      requiredSize: (node) -> 15
      onGraphChange: (selection) ->
        text = selection.selectAll("text").data((node) -> [node])

        text.enter().append("text")
        .attr
          "alignment-baseline": "middle"
          "text-anchor": "middle"

        text
        .text((node) -> formatCaption(node))
        .attr
          "fill": (node) ->
            GraphStyle.forNode(node).get('color')

        text.exit().remove()

      onTick: noop
    )

    nodeOverlay = new GraphRenderer.Renderer(
      requiredSize: (node) -> 15
      onGraphChange: (selection) ->
        circles = selection.selectAll("circle.overlay").data((node) ->
          if node.selected then [node] else []
        )

        circles.enter()
        .append("circle")
        .classed('overlay', true)
        .attr
          cx: (d, i) -> 0
          cy: (d, i) -> 0
          r: (node) -> node.radius
          fill: 'rgba(0,0,0,0.3)'
          stroke: 'none'

        circles.exit().remove()
      onTick: noop
    )

    arrowPath = new GraphRenderer.Renderer(
      requiredSize: noop
      onGraphChange: (selection) ->
        lines = selection.selectAll("line").data((rel) -> [rel])

        lines.enter().append("line")
        .attr('marker-start', (d) -> 'url(#arrow-start)' if d.incoming)
        .attr('marker-end', (d) -> 'url(#arrow-end)' unless d.incoming)

        lines
        .attr('fill', (rel) -> GraphStyle.forRelationship(rel).get('fill'))
        .attr('stroke', (rel) -> GraphStyle.forRelationship(rel).get('stroke'))
        .attr('stroke-width', (rel) -> GraphStyle.forRelationship(rel).get('stroke-width'))

        lines.exit().remove()

      onTick: (selection) ->
        selection.selectAll("line")
        .attr("x1", (d) -> d.source.x)
        .attr("y1", (d) -> d.source.y)
        .attr("x2", (d) -> d.target.x)
        .attr("y2", (d) -> d.target.y)
    )

    GraphRenderer.nodeRenderers.push(nodeOutline)
    GraphRenderer.nodeRenderers.push(nodeCaption)
    GraphRenderer.nodeRenderers.push(nodeOverlay)
    GraphRenderer.relationshipRenderers.push(arrowPath)
])
