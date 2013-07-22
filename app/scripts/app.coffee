'use strict'

angular.module('neo4jApp.controllers', [])
angular.module('neo4jApp.directives', [])
angular.module('neo4jApp.filters', [])
angular.module('neo4jApp.services', ['LocalStorageModule', 'neo4jApp.settings'])

app = angular.module('neo4jApp', [
  'neo4jApp.controllers'
  'neo4jApp.directives'
  'neo4jApp.filters'
  'neo4jApp.services'
  'ui.bootstrap.dialog'
  'ui.bootstrap.dropdownToggle'
  'ui.bootstrap.position'
  'ui.bootstrap.tooltip'
  'ui.codemirror'
  'ui.sortable'
  'angularMoment'
])

app
  .config ['$routeProvider', ($routeProvider) ->
    $routeProvider
      .when('/')
      .when('/views/:viewId')
      .otherwise
        redirectTo: '/'
  ]

app.config([
  '$httpProvider'
  '$tooltipProvider'
  ($httpProvider, $tooltipProvider) ->
    $httpProvider.defaults.headers.common['X-stream'] = true
    $httpProvider.defaults.headers.common['Content-Type'] = 'application/json'

    $tooltipProvider.options popupDelay: 1000
])

app.run([
  '$rootScope'
  '$http'
  '$timeout'
  'Server'
  ($scope, $http, $timeout, Server) ->
    timer = null
    check = ->
      $timeout.cancel(timer)
      Server.status().then(
        ->
          $scope.offline = no
          timer = $timeout(check, 5000)
      ,
        ->
          $scope.offline = yes
          timer = $timeout(check, 5000)
      )
    check()
])
