'use strict'

angular.module('neo4jApp.controllers')
  .controller 'MainCtrl', [
    '$scope',
    'ServerInfo'
    'Settings'
    ($scope, ServerInfo, Settings) ->
      refresh = ->
        $scope.labels = ServerInfo.labels()
        $scope.relationships = ServerInfo.relationships()
        $scope.server = ServerInfo.rest()
        $scope.host = Settings.host
      refresh()

      $scope.$on 'db:result:containsUpdates', refresh
  ]

