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

      $scope.neo4j = {}

      $scope.neo4j.license = {
        type: "GPLv3"
        url: "http://www.gnu.org/licenses/gpl.html"
      }

      $scope.neo4j.edition = "Enterprise"

      $scope.$on 'db:result:containsUpdates', refresh

      $scope.today = Date.now()

      $scope.cmdchar = ':'

      parseName = (str) ->
        str.substr(str.lastIndexOf("name=")+5)

      # summarizeNeo4jServer = ->
        # gather info from jmx
      Server.jmx(
        [
          "org.neo4j:instance=kernel#0,name=Configuration",
          "org.neo4j:instance=kernel#0,name=Kernel"
        ]
      ).success((response) ->
        $scope.kernel = {}
        for r in response
          for a in r.attributes
            $scope.kernel[a.name] = a.value
      )

      # XXX: Temporary for now having to change all help files
      $scope.$watch 'server', (val) ->
        $scope.neo4j.version = val.neo4j_version
      , true

      refresh()
  ]

