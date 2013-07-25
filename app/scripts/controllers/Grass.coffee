'use strict'

angular.module('neo4jApp')
  .controller 'GrassCtrl', ['$scope', 'GraphStyle', ($scope, graphStyle) ->
    $scope.code = graphStyle.toString()
  ]
