'use strict'

angular.module('neo4jApp')
.controller 'MainCtrl', [
  '$scope'
  'viewService'
  ($scope, viewService) ->
    $scope.views = viewService
    len = viewService.history.all().length + 1
    viewService.run("//Query no. #{len}\nSTART n=node(0)\nRETURN n;")
]
