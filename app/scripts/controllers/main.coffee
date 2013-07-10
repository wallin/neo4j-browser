'use strict'

angular.module('neo4jApp')
.controller 'MainCtrl', [
  '$scope'
  'viewService'
  ($scope, viewService) ->
    $scope.views = viewService

    $scope.createView = (query) ->
      len = viewService.history.all().length + 1
      query ?= "//Query no. #{len}"
      viewService.run(query)

    $scope.createView()
]
