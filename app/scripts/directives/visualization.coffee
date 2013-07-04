'use strict';

angular.module('neo4jApp.directives')
  .controller('visualizationCtrl', [
    ->
      force = null

      root = null
      el = null

      link = null
      node = null

      click = (d) =>
        if not d.children
          d.$traverse().then(@update)
          d._children = null
        else
          d._children = d.children
          d.children = null
          d.relations = null
          @update();


      getNodes = ->
        return [] unless root
        nodes = {}
        recurse = (node) ->
          if nodes[node.id]
            angular.extend(nodes[node.id], node)
          else
            nodes[node.id] = node

          if node.children
            recurse(n) for n in node.children when not nodes[n.id]


        recurse(n) for n in root
        n for i, n of nodes
        #nodes

      getLinks = ->
        return [] unless root
        links = {}
        recurse = (node) ->
          if node.relations
            for rel in node.relations
              if links[rel.id]
                angular.extend(links[rel.id], rel)
              else
                links[rel.id] = rel
          if node.children
            recurse(n) for n in node.children

        recurse(n) for n in root
        n for i, n of links

      tick = ->
        link.attr("x1", (d) ->
          d.source.x
        ).attr("y1", (d) ->
          d.source.y
        ).attr("x2", (d) ->
          d.target.x
        ).attr "y2", (d) ->
          d.target.y

        node.attr("cx", (d) ->
          d.x
        ).attr "cy", (d) ->
          d.y
        return
        link.attr("d", (d) ->
            #dx = d.target.x - d.source.x
            #dy = d.target.y - d.source.y
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

      force = d3.layout.force()
        .size([640, 480])
        .linkDistance(200)
        .charge(-1000)
        .on('tick', tick)

      color = (d) ->
        (if d._children then "#3182bd" else (if d.children then "#c6dbef" else "#fd8d3c"))

      @update = =>
        nodes = getNodes()
        links = getLinks(nodes)
        force
          .nodes(nodes)
          .links(links)
          .start()


        link = el.selectAll("line.link").data(links, (d) ->
          d.target.id
        )

        # Enter any new links.
        link.enter().insert("svg:line", ".node").attr("class", "link").attr("x1", (d) ->
          d.source.x
        ).attr("y1", (d) ->
          d.source.y
        ).attr("x2", (d) ->
          d.target.x
        ).attr "y2", (d) ->
          d.target.y


        # Exit any old links.
        link.exit().remove()

        # Update the nodes…
        node = el.selectAll("circle.node").data(nodes, (d) ->
          d.id
        ).style("fill", color)

        # Enter any new nodes.
        node.enter()
        .append("svg:circle")
        .attr("class", "node")
        .attr("cx", (d) ->
          d.x
        ).attr("cy", (d) ->
          d.y
        ).attr("r", 15).style("fill", color).on("click", click).call force.drag

        # Exit any old nodes.
        node.exit().remove()


        return
        markers = el.select('defs')
        markers = markers.selectAll("marker")
          .data(["end"])
        markers.exit().remove()
        markers.enter().append("svg:marker")
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
        link = paths.selectAll("path")
            .data(force.links(), (d) -> d.target.id )
        link.exit().remove()
        link.enter().append("svg:path")
            .attr("class", "link")
            .attr("id", (d) -> "path#{d.target.id}")
            .attr("marker-end", "url(#end)")

        path_texts = el.select('#path_texts').selectAll('text')
          .data(force.links(), keyFunc)
        path_texts.exit().remove()
        path_texts.enter()
          .append('text')
          .attr('font-size', '42.5')
          .append('textPath').text((d)->
            d.type
          )
          .attr('startOffset', '50%')
          .attr('text-anchor', 'middle')
          .attr('xlink:href', (d) -> "#path#{d.id}")


        node = el.selectAll(".node")
          .data(force.nodes(), keyFunc)
        node.exit().remove()
        node = node.enter().append("g")
          .attr("class", "node")
          .on("click", click)
        node.append("circle")
          .attr("r", 15)
        node.append("text")
          .attr("x", 0)
          .attr('text-anchor', 'middle')
          .attr("dy", ".35em")
          .text((d) -> d.id )
        node.call(force.drag)

      @render = (elm, data) ->
        return unless data
        el = elm
        root = data.nodes
        @update()

  ])

angular.module('neo4jApp.directives')
  .directive('visualization', [
    'graphService'
    (graphService) ->
      restrict: 'EA'
      controller: 'visualizationCtrl'
      scope: "@"
      replace: yes
      template: """
      <svg style="pointer-events:fill;" viewbox="0 0 640 480" preserveAspectRatio="xMidyMid">

      </svg>
      """
      link: (scope, elm, attr, ctrl) ->
        scope.$watch(attr.query, (val, oldVal)->
          return unless val
          graphService.executeQuery(scope.$eval(attr.query)).then(
            (g) ->
              return ctrl.render(d3.select(elm[0]), g)
            ,
            ->
          )
        , true)
  ])
