'use strict'

angular.module('neo4jApp.controllers')
  .controller 'MainCtrl', [
    '$rootScope',
    'Server'
    'Settings'
    ($scope, Server, Settings) ->
      refresh = ->
        $scope.labels = Server.labels()
        $scope.relationships = Server.relationships()
        $scope.server = Server.rest()
        $scope.host = Settings.host
      $scope.$on 'db:result:containsUpdates', refresh

      parseName = (str) ->
        str.substr(str.lastIndexOf("name=")+5)

      Server.jmx(["org.neo4j:instance=kernel#0,name=Configuration"]).success((response) ->
        $scope.kernel = {}
        for r in response
          for a in r.attributes
            $scope.kernel[a.name] = a.value
      )
      refresh()
  ]

