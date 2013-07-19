'use strict'

angular.module('neo4jApp.controllers')
  .controller 'MainCtrl', [
    '$scope',
    'Server'
    'Settings'
    ($scope, Server, Settings) ->
      refresh = ->
        $scope.labels = Server.labels()
        $scope.relationships = Server.relationships()
        $scope.server = Server.rest()
        $scope.host = Settings.host
      refresh()

      $scope.$on 'db:result:containsUpdates', refresh
  ]

