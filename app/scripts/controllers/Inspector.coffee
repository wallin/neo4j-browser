'use strict'

angular.module('neo4jApp.controllers')
  .controller 'InspectorCtrl', [
    '$scope',
    'GraphStyle'
    ($scope, GraphStyle) ->
      $scope.colors = ['#BDC3C7', '#1ABC9C', '#3498DB', '#E74C3C', '#9B59B6', '#E67E22', '#2ECC71']
      $scope.style = {fill: $scope.colors[0]}
      $scope.$watch 'selectedGraphItem', (item) ->
        return unless item
        $scope.item = angular.copy(item)
        rule = GraphStyle.findNodeRule(item)
        $scope.style = {}
        if rule
          angular.extend($scope.style, rule.props)
        if $scope.style.caption
          $scope.selectedCaption = $scope.style.caption.replace(/\{([^{}]*)\}/, "$1")

      $scope.hasNoProps = ->
        Object.keys($scope.item.attrs).length == 0

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
