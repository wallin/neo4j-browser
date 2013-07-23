'use strict'
angular.module('neo4jApp.controllers')
  .controller('D3GraphCtrl', [
    '$element'
    'GraphExplorer'
    ($element, GraphExplorer) ->
      #
      # Local variables
      #
      el = d3.select($element[0])

      d3link = null
      d3node = null

      graph = null

      #
      # Local methods
      #
      click = (d) =>
        d.fixed = yes
        return if d.expanded
        GraphExplorer.exploreNeighbours(d.id).then (result) =>
          graph.merge(result)
          @update()
#        graph.expand(d.id).then(@update) unless d.expanded

      tick = ->
        d3link.attr("x1", (d) ->
          d.source.x
        ).attr("y1", (d) ->
          d.source.y
        ).attr("x2", (d) ->
          d.target.x
        ).attr "y2", (d) ->
          d.target.y

        d3node.attr "transform", (d) ->
          "translate(" + d.x + "," + d.y + ")"

      force = d3.layout.force()
        .size([640, 480])
        .linkDistance(80)
        .charge(-1000)
        .on('tick', tick)

      color = (d) ->
        if d.expanded then "#c6dbef" else "#fd8d3c"

      nodeClass = (d) ->
        if d.expanded then 'node' else 'node faded'

      linkClass = (d) ->
        if (d.source.expanded and d.target.expanded) then 'link' else 'link faded'

      #
      # Public methods
      #
      @update = =>
        nodes = graph.nodes.all()
        links = graph.links.all()
        force
          .nodes(nodes)
          .links(links)
          .start()

        # Markers
        el.select("defs")
        .selectAll("marker")
        .data(["arrow-start", "arrow-end"])
        .enter().append("marker")
        .attr("id", String)
        .attr("viewBox", "0 -5 10 10")
        .attr("refX", (m) ->
          if m == 'arrow-start'
            -20
          else
            18 + 12
        )
        .attr("refY", 0)
        .attr("markerWidth", 6)
        .attr("markerHeight", 6).attr("orient", "auto")
        .append("path")
        .attr("d", (m) ->
          if m == 'arrow-start'
            'M10,-5L10,5L0,0'
          else
            "M0,-5L10,0L0,5"
        )

        d3link = el.selectAll("line.link").data(links, (d) ->
          d.id
        ).attr('class', linkClass)

        # Enter any new links.
        d3link.enter().insert("line", ".node").attr("x1", (d) ->
          d.source.x
        ).attr("y1", (d) ->
          d.source.y
        ).attr("x2", (d) ->
          d.target.x
        ).attr("y2", (d) ->
          d.target.y
        ).attr('marker-start', (d) -> 'url(#arrow-start)' if d.incoming)
        .attr('marker-end', (d) -> 'url(#arrow-end)' unless d.incoming)
        .attr('class', linkClass )
        .attr "xlink:href", (d) ->
          "#path" + d.source.index + "_" + d.target.index

        # Exit any old links.
        d3link.exit().remove()

        # Update the nodes…
        d3node = el.selectAll("g").data(nodes, (d) ->
          d.id
        ).attr("class", nodeClass )

        # Enter any new nodes.
        d3node.enter()
        .append("g")
        .each ->
          g = d3.select(@)
          g.append("circle").attr
            cx: (d, i) -> 0
            cy: (d, i) -> 0
            r: 18
            fill: "#BADBDA"
            stroke: "#2F3550"
            "stroke-width": 2.4192
          g.append("text").text((d) ->
            d.id
          ).attr(
            "alignment-baseline": "middle"
            "text-anchor": "middle"
          )
        .attr("class", nodeClass )
        .style("fill", color)
        .on("click", click)
        .call force.drag

        # Exit any old nodes.
        d3node.exit().remove()

      @render = (result) ->
        return unless result
        graph = result
        GraphExplorer.internalRelationships(graph.nodes.pluck('id'))
        .then (result) =>
          graph.merge(result)
          @update()

  ])
