'use strict'

angular.module('neo4jApp')
.controller 'MainCtrl', [
  '$scope',
  '$http'
  'terminal'
  ($scope, $http, terminal) ->
    $scope.console = terminal
]
