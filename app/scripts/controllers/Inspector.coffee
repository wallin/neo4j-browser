'use strict'

angular.module('neo4jApp.controllers')
  .controller 'InspectorCtrl', [
    '$scope',
    'GraphStyle'
    ($scope, GraphStyle) ->
      $scope.colors = [
        ['#C3C6C6', '#B7B7B7']
        ['#30B6AF', '#46A39E']
        ['#AD62CE', '#9453B1']
        ['#FF6C7C', '#EB5D6C']
        ['#F25A29', '#DC4717']
        ['#FCC940', '#F3BA25']
        ['#4356C0', '#3445A2']
      ]
      $scope.style = {fill: $scope.colors[0][0]}
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
        $scope.style.fill = color[0]
        $scope.style.stroke = color[1]
        $scope.saveStyle()

      $scope.selectCaption  = (caption) ->
        $scope.selectedCaption = caption
        $scope.style.caption = '{' + caption + '}'
        $scope.saveStyle()

      $scope.saveStyle = ->
        GraphStyle.changeForNode($scope.item, $scope.style)

  ]
