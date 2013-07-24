'use strict'
angular.module('neo4jApp.controllers')
  .controller('D3GraphCtrl', [
    '$element'
    '$rootScope'
    'GraphExplorer'
    'GraphRenderer'
    ($element, $rootScope, GraphExplorer, GraphRenderer) ->
      #
      # Local variables
      #
      el = d3.select($element[0])
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
        # New in Angular 1.1.5
        # https://github.com/angular/angular.js/issues/2371
        $rootScope.selectedGraphItem = d
        $rootScope.$apply() unless $rootScope.$$phase

      tick = ->
        relationshipGroups = el.selectAll("g.relationship")

        # Only translate nodeGroups, because this simplifies node renderers;
        # relationship renderers always take account of both node positions
        nodeGroups = el.selectAll("g.node")
        .attr("transform", (node) -> "translate(" + node.x + "," + node.y + ")")

        for renderer in GraphRenderer.nodeRenderers
          nodeGroups.call(renderer.onTick)

        for renderer in GraphRenderer.relationshipRenderers
          relationshipGroups.call(renderer.onTick)

      force = d3.layout.force()
        .size([640, 480])
        .linkDistance(80)
        .charge(-1000)
        .on('tick', tick)


      addMarkers = (selection) ->
        # Markers
        selection.select("defs")
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

      #
      # Public methods
      #
      @update = =>
        nodes         = graph.nodes.all()
        relationships = graph.relationships.all()

        for node in nodes
          sizes = for renderer in GraphRenderer.nodeRenderers
            renderer.requiredSize()
          node.radius = Math.max.apply(null, sizes)

        force
          .nodes(nodes)
          .links(relationships)
          .start()

        el.call(addMarkers);

        layers = el.selectAll("g.layer").data(["relationships", "nodes"])

        layers.enter().append("g")
        .attr("class", (d) -> "layer " + d )

        relationshipGroups = el.select("g.layer.relationships")
        .selectAll("g.relationship").data(relationships, (d) -> d.id)

        relationshipGroups.enter().append("g")
        .attr("class", "relationship")

        for renderer in GraphRenderer.relationshipRenderers
          relationshipGroups.call(renderer.onGraphChange)

        relationshipGroups.exit().remove();

        nodeGroups = el.select("g.layer.nodes")
        .selectAll("g.node").data(nodes, (d) -> d.id)

        nodeGroups.enter().append("g")
        .attr("class", "node")
        .on("click", click)
        .call(force.drag)

        for renderer in GraphRenderer.nodeRenderers
          nodeGroups.call(renderer.onGraphChange);

        nodeGroups.exit().remove();


      @render = (result) ->
        return unless result
        graph = result
        GraphExplorer.internalRelationships(graph.nodes.pluck('id'))
        .then (result) =>
          graph.merge(result)
          @update()

  ])
