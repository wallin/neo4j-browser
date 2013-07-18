'use strict'

angular.module('neo4jApp.controllers')
  .controller 'MainCtrl', [
    '$scope',
    'ServerInfo'
    ($scope, ServerInfo) ->
      refresh = ->
        $scope.labels = ServerInfo.labels()
        $scope.relationships = ServerInfo.relationships()
        $scope.server = ServerInfo.rest()
      refresh()
  ]

