'use strict'

angular.module('neo4jApp.controllers')
  .controller 'ServerInfoCtrl', [
    '$scope',
    'ServerInfo'
    ($scope, ServerInfo) ->
      refresh = ->
        $scope.labels = ServerInfo.labels()
        $scope.relationships = ServerInfo.relationships()

      refresh()
  ]

