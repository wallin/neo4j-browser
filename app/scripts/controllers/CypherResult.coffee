'use strict'

angular.module('neo4jApp.controllers')
  .controller 'CypherResultCtrl', ['$scope', ($scope) ->

    $scope.$watch 'view.response', ->
      $scope.showGraph = $scope.view.response?.nodes.length
      $scope.tab = if $scope.showGraph then 'graph' else 'table'

    $scope.setActive = (tab) -> $scope.tab = tab
    $scope.isActive = (tab) -> tab is $scope.tab
  ]
