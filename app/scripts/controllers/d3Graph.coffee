'use strict'

clickcancel = ->
  cc = (selection) ->

    # euclidean distance
    dist = (a, b) ->
      Math.sqrt Math.pow(a[0] - b[0], 2), Math.pow(a[1] - b[1], 2)
    down = undefined
    tolerance = 5
    last = undefined
    wait = null
    selection.on "mousedown", ->
      d3.event.target.__data__.fixed = yes
      down = d3.mouse(document.body)
      last = +new Date()

    selection.on "mouseup", ->
      if dist(down, d3.mouse(document.body)) > tolerance
        return
      else
        if wait
          window.clearTimeout wait
          wait = null
          event.dblclick d3.event.target.__data__
        else
          wait = window.setTimeout(((e) ->
            ->
              event.click e.target.__data__
              wait = null
          )(d3.event), 250)

  event = d3.dispatch("click", "dblclick")
  d3.rebind cc, event, "on"

angular.module('neo4jApp.controllers')
  .controller('D3GraphCtrl', [
    '$element'
    '$rootScope'
    '$scope'
    'GraphExplorer'
    'GraphRenderer'
    'GraphStyle'
    'GraphGeometry'
    ($element, $rootScope, $scope, GraphExplorer, GraphRenderer, GraphStyle, GraphGeometry) ->
      #
      # Local variables
      #
      el = d3.select($element[0])
      el.append('defs')
      graph = null

      selectedNode = null

      $scope.style = GraphStyle.rules
      $scope.$watch 'style', (val) =>
        return unless val
        @update()
      , true

      #
      # Local methods
      #

      naturalViewBox = (width, height) ->
        [
          0
          0
          width
          height
        ].join(" ")

      resize = ->
        height = $element.height()
        width  = $element.width()
        force.size([width, height])
        el.attr("viewBox", naturalViewBox(width, height))

      fit = ->
        height = $element.height()
        width  = $element.width()
        box = graph.boundingBox()

        el.transition().attr("viewBox",
          if (box.x.min > 0 && box.x.max < width && box.y.min > 0 && box.y.max < height)
            naturalViewBox(width, height)
          else [
            box.x.min
            box.y.min
            box.x.max - box.x.min
            box.y.max - box.y.min
          ].join(" ")
        )

      selectItem = (item) ->
        $rootScope.selectedGraphItem = item
        $rootScope.$apply() unless $rootScope.$$phase

      onDblClick = (d) =>
        #$rootScope.selectedGraphItem = d
        return if d.expanded
        GraphExplorer.exploreNeighbours(d.id).then (result) =>
          graph.merge(result, d)
          d.expanded = yes
          @update()
        # New in Angular 1.1.5
        # https://github.com/angular/angular.js/issues/2371
        $rootScope.$apply() unless $rootScope.$$phase

      onClick = (d) =>
        d.fixed = yes
        if d is selectedNode
          d.selected = no
          selectedNode = null
        else
          selectedNode?.selected = no
          d.selected = yes
          selectedNode = d

        @update()
        selectItem(selectedNode)

      clickHandler = clickcancel()
      clickHandler.on 'click', onClick
      clickHandler.on 'dblclick', onDblClick

      tick = ->

        GraphGeometry.onTick(graph)

        # Only translate nodeGroups, because this simplifies node renderers;
        # relationship renderers always take account of both node positions
        nodeGroups = el.selectAll("g.node")
        .attr("transform", (node) -> "translate(" + node.x + "," + node.y + ")")

        for renderer in GraphRenderer.nodeRenderers
          nodeGroups.call(renderer.onTick)

        relationshipGroups = el.selectAll("g.relationship")

        for renderer in GraphRenderer.relationshipRenderers
          relationshipGroups.call(renderer.onTick)

      force = d3.layout.force()
        .linkDistance(60)
        .charge(-1000)
        .on('tick', tick)

      resize()

      addMarkers = (selection) ->
        # Markers
        selection.select("defs")
        .selectAll("marker")
        .data(["arrow-start", "arrow-end"])
        .enter().append("marker")
        .attr("id", String)
        .attr("viewBox", "0 -5 10 10")
        .attr("refX", 10)
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
      @update = ->
        return unless graph
        nodes         = graph.nodes.all()
        relationships = graph.relationships.all()

        force
          .nodes(nodes)
          .links(relationships)
          .on('end', fit)
          .start()

        el.call(addMarkers);

        layers = el.selectAll("g.layer").data(["relationships", "nodes"])

        layers.enter().append("g")
        .attr("class", (d) -> "layer " + d )

        relationshipGroups = el.select("g.layer.relationships")
        .selectAll("g.relationship").data(relationships, (d) -> d.id)

        relationshipGroups.enter().append("g")
        .attr("class", "relationship")

        GraphGeometry.onGraphChange(graph)

        for renderer in GraphRenderer.relationshipRenderers
          relationshipGroups.call(renderer.onGraphChange)

        relationshipGroups.exit().remove();

        nodeGroups = el.select("g.layer.nodes")
        .selectAll("g.node").data(nodes, (d) -> d.id)

        nodeGroups.enter().append("g")
        .attr("class", "node")
        .call(force.drag)
        .call(clickHandler)

        for renderer in GraphRenderer.nodeRenderers
          nodeGroups.call(renderer.onGraphChange);

        nodeGroups.exit().remove();

      @render = (result) ->
        return unless result
        graph = result
        return if graph.nodes.length is 0
        GraphExplorer.internalRelationships(graph.nodes.pluck('id'))
        .then (result) =>
          graph.merge(result)
          @update()
  ])
