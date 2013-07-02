'use strict'

angular.module('neo4jApp')
.controller 'MainCtrl', [
  '$scope'
  ($scope) ->
    $scope.circles = []
    $scope.graph = dummy
    $scope.circleRenderer = (el, data) ->
      # Set the data for some circles
      d = el.selectAll("circle").data($scope.circles)
      d.enter().append("circle")
      .attr("cx", 1024 / 2)
      .attr("cy", 768 / 2)
      .style("fill", ->
        "rgb(" + parseInt(Math.random() * 255) + "," + parseInt(Math.random() * 255) + "," + parseInt(Math.random() * 255) + ")"
      )
      .transition().duration(1000)
      .attr("cx", (d) ->
        d.cx
      ).attr("cy", (d) ->
        d.cy
      ).attr "r", (d) ->
        d.r

      d.exit()
      .transition()
      .duration(1000)
      .attr("cx", 1024 / 2)
      .attr("cy", 768 / 2)
      .attr("r", 0)
      .remove()

    $scope.execute = () ->
      for i in [0..10]
        $scope.circles.push
          cx: Math.random() * 1024
          cy: Math.random() * 768
          r: Math.random() * 50


    $scope.graphRenderer = (el, data)->
      w = 800
      h = 400
      vis = el
        .attr("style","pointer-events:fill;");


      force = d3.layout.force()
        .nodes(data.nodes)
        .links(data.links)
        .size([w, h])
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
]

dummy = {
  "links": [
      {
          "end": 6,
          "id": 0,
          "source": 0,
          "start": 0,
          "target": 6,
          "type": "ROOT"
      },
      {
          "end": 5,
          "id": 1,
          "selected": "r",
          "source": 6,
          "start": 6,
          "target": 5,
          "type": "KNOWS"
      },
      {
          "end": 4,
          "id": 2,
          "source": 6,
          "start": 6,
          "target": 4,
          "type": "LOVES"
      },
      {
          "end": 4,
          "id": 3,
          "selected": "r",
          "source": 5,
          "start": 5,
          "target": 4,
          "type": "KNOWS"
      },
      {
          "end": 3,
          "id": 4,
          "selected": "r",
          "source": 5,
          "start": 5,
          "target": 3,
          "type": "KNOWS"
      },
      {
          "end": 2,
          "id": 5,
          "selected": "r",
          "source": 3,
          "start": 3,
          "target": 2,
          "type": "KNOWS"
      },
      {
          "end": 1,
          "id": 6,
          "source": 2,
          "start": 2,
          "target": 1,
          "type": "CODED_BY"
      }
  ],
  "nodes": [
      {
          "id": 0
      },
      {
          "id": 1,
          "name": "The Architect"
      },
      {
          "id": 2,
          "name": "Agent Smith",
          "selected": "m"
      },
      {
          "id": 3,
          "name": "Cypher",
          "selected": "m"
      },
      {
          "id": 4,
          "name": "Trinity",
          "selected": "m"
      },
      {
          "id": 5,
          "name": "Morpheus",
          "selected": "m"
      },
      {
          "id": 6,
          "name": "Neo",
          "selected": "Neo"
      }
  ]
}
