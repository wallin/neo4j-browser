'use strict'

angular.module('neo4jApp')
.controller 'MainCtrl', [
  '$scope'
  'd3Renderer'
  'viewService'
  ($scope, d3Renderer, viewService) ->
    $scope.views = viewService
    $scope.renderer = d3Renderer
    $scope.graph = dummy

    $scope.execute = ->
      viewService.run(@query)
      @query = ""

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
