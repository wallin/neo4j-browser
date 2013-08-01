'use strict'

angular.module('neo4jApp.controllers')
  .controller 'MainCtrl', [
    '$rootScope',
    '$window'
    'Server'
    'Settings'
    ($scope, $window, Server, Settings) ->
      refresh = ->
        $scope.labels = Server.labels()
        $scope.relationships = Server.relationships()
        $scope.server = Server.info()
        $scope.host = $window.location.host
      $scope.$on 'db:result:containsUpdates', refresh

      parseName = (str) ->
        str.substr(str.lastIndexOf("name=")+5)

      Server.jmx(
        [
          "org.neo4j:instance=kernel#0,name=Configuration"
          "org.neo4j:instance=kernel#0,name=Kernel"
        ]
      ).success((response) ->
        $scope.kernel = {}
        for r in response
          for a in r.attributes
            $scope.kernel[a.name] = a.value
      )

      $scope.today = Date.now()

      # XXX: Temporary for now having to change all help files
      $scope.$watch 'server', (val) ->
        $scope.neo4jVersion = val.neo4j_version
      , true
      refresh()
  ]

