'use strict'

angular.module('neo4jApp.controllers')
  .controller 'InspectorCtrl', [
    '$scope',
    'GraphStyle'
    ($scope, GraphStyle) ->
      $scope.colors = ['#BDC3C7', '#1ABC9C', '#3498DB', '#E74C3C']
      $scope.style = {fill: $scope.colors[0]}
      $scope.$watch 'selectedGraphItem', (item) ->
        $scope.item = angular.copy(item)

      $scope.selectFill = (color) ->
        $scope.style.fill = color
        $scope.saveStyle()

      $scope.selectCaption  = (caption) ->
        $scope.selectedCaption = caption
        $scope.style.caption = '{' + caption + '}'
        $scope.saveStyle()

      $scope.saveStyle = ->
        GraphStyle.changeForNode($scope.item, $scope.style)

  ]
