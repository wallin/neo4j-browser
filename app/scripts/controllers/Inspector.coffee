'use strict'

angular.module('neo4jApp.controllers')
  .controller 'InspectorCtrl', [
    '$scope',
    'GraphStyle'
    ($scope, GraphStyle) ->
      $scope.sizes = GraphStyle.defaultSizes()
      $scope.arrowWidths = GraphStyle.defaultArrayWidths()
      $scope.colors = GraphStyle.defaultColors()
      $scope.style =
        fill: $scope.colors[0].fill
        stroke: $scope.colors[0].stroke
        diameter: $scope.sizes[0].diameter

      $scope.$watch 'selectedGraphItem', (item) ->
        return unless item
        $scope.item = item
        $scope.style = GraphStyle.forEntity(item).props
        if $scope.style.caption
          $scope.selectedCaption = $scope.style.caption.replace(/\{([^{}]*)\}/, "$1")

      $scope.selectSize = (size) ->
        $scope.style.diameter = size.diameter
        $scope.saveStyle()

      $scope.selectArrowWidth = (arrowWidth) ->
        $scope.style['shaft-width'] = arrowWidth.shaftWidth
        $scope.saveStyle()

      $scope.selectScheme = (color) ->
        $scope.style.fill = color.fill
        $scope.style.stroke = color.stroke
        $scope.saveStyle()

      $scope.selectCaption  = (caption) ->
        $scope.selectedCaption = caption
        $scope.style.caption = '{' + caption + '}'
        $scope.saveStyle()

      $scope.saveStyle = ->
        GraphStyle.change($scope.item, $scope.style)

  ]
