'use strict'

angular.module('neo4jApp')
.controller 'MainCtrl', [
  '$scope'
  'viewService'
  ($scope, viewService) ->
    $scope.views = viewService
    viewService.run("START n=node(0)\nRETURN n;")
    $scope.execute = ->
      viewService.run("START n=node(0)\nRETURN n;")
      #viewService.run(@query)
      @query = ""

]
