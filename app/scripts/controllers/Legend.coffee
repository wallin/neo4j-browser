'use strict'

angular.module('neo4jApp')
  .controller 'LegendCtrl', ['$scope', 'GraphStyle', ($scope, graphStyle) ->

    $scope.rules = graphStyle.rules

    $scope.isNode = (rule) ->
      rule.selector.tag == 'node'

    $scope.remove = (rule) ->
      graphStyle.destroyRule(rule)

  ]
