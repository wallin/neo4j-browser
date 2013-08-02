'use strict'

angular.module('neo4jApp')
  .controller 'GrassCtrl', [
    '$scope'
    '$window'
    'GraphStyle'
    ($scope, $window, GraphStyle) ->
      serialize = ->
        $scope.code = GraphStyle.toString()

      $scope.rules = GraphStyle.rules

      $scope.$watch 'rules', serialize, true

      $scope.import = (content) ->
        GraphStyle.import(content)

      serialize()
  ]
