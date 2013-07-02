'use strict';

angular.module('neo4jApp')
  .factory 'd3Renderer', () ->
    dynamic = (el, data)->
      return unless data
      el.attr("style","pointer-events:fill;")
        .attr("viewBox", "0 0 640 480")
        .attr("preserveAspectRatio", "xMidyMid")

      force = d3.layout.force()
        .nodes(data.nodes)
        .links(data.links)
        .size([640, 480])
        .linkDistance(200)
        .charge(-1000)
        .start();

      markers = el.select('defs')
      markers.selectAll("marker")
        .data(["end"])
        .enter().append("svg:marker")
          .attr("id", String)
          .attr("viewBox", "0 -5 10 10")
          .attr("refX", 22)
          .attr("refY", -0.5)
          .attr("markerWidth", 5)
          .attr("markerHeight", 5)
          .attr("orient", "auto")
        .append("svg:path")
        .attr("d", "M0,-5L10,0L0,5");


      paths = el.select("#paths")
      path = paths.selectAll("path")
          .data(force.links())
        .enter().append("svg:path")
          .attr("class", "link")
          .attr("id", (d) -> "path#{d.id}")
          .attr("marker-end", "url(#end)");

      path_texts = el.select('#path_texts').selectAll('text')
        .data(force.links())
        .enter()
        .append('text')
        .attr('font-size', '42.5')
        .append('textPath').text((d)->
          d.type
        )
        .attr('startOffset', '50%')
        .attr('text-anchor', 'middle')
        .attr('xlink:href', (d) -> "#path#{d.id}")

      node = el.selectAll(".node")
          .data(force.nodes())
        .enter().append("g")
          .attr("class", "node")
          .call(force.drag);
      node.append("circle")
        .attr("r", 15);

      node.append("text")
        .attr("x", 15)
        .attr("dy", ".35em")
        .text((d) -> d.name );

      force.on "tick", ->
        path.attr("d", (d) ->
            dx = d.target.x - d.source.x
            dy = d.target.y - d.source.y
            return "M" +
                d.source.x + ", " +
                d.source.y + " L" +
                d.target.x + ", " +
                d.target.y;
        );

        node
          .attr("transform", (d) ->
            return "translate(" + d.x + "," + d.y + ")";
          );

    return {
      dynamic: dynamic
    }
