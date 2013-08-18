angular.module('neo4jApp.services')
.run([
  'GraphRenderer',
  'GraphStyle',
  (GraphRenderer, GraphStyle) ->

    radius = (node) ->
      parseFloat(GraphStyle.forNode(node).get("diameter")) / 2

    formatCaption = (node) ->
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
      lines

    noop = ->

    nodeOutline = new GraphRenderer.Renderer(
      onGraphChange: (selection) ->
        circles = selection.selectAll("circle.outline").data(
          (node) -> [node]
        )

        circles.enter()
        .append("circle")
        .classed('outline', true)
        .attr
          cx: 0
          cy: 0

        circles
        .attr
          r: (node) -> radius(node)
          fill: (node) -> GraphStyle.forNode(node).get("fill")
          stroke: (node) -> GraphStyle.forNode(node).get("stroke")
          "stroke-width": (node) -> GraphStyle.forNode(node).get("stroke-width")

        circles.exit().remove()
      onTick: noop
    )

    nodeCaption = new GraphRenderer.Renderer(
      onGraphChange: (selection) ->
        text = selection.selectAll("text").data(formatCaption)

        text.enter().append("text")
        .attr
          "text-anchor": "middle"

        text
        .text((line) -> line.text)
        .attr("y", (line) -> line.baseline)
        .attr
          "fill": (line) ->
            GraphStyle.forNode(line.node).get('color')

        text.exit().remove()

      onTick: noop
    )

    nodeOverlay = new GraphRenderer.Renderer(
      onGraphChange: (selection) ->
        circles = selection.selectAll("circle.overlay").data((node) ->
          if node.selected then [node] else []
        )

        circles.enter()
        .insert("circle", ".outline")
        .classed('ring', true)
        .classed('overlay', true)
        .attr
          cx: 0
          cy: 0
          fill: '#f5F6F6'
          stroke: 'rgba(151, 151, 151, 0.2)'
          'stroke-width': '3px'

        circles
        .attr
          r: (node) -> radius(node) + 6

        circles.exit().remove()
      onTick: noop
    )

    arrowPath = new GraphRenderer.Renderer(
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
