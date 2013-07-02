'use strict'

app = angular.module('neo4jApp', ['ui.codemirror', 'd3.directives'])

app
  .config ['$routeProvider', ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .otherwise
        redirectTo: '/'
  ]

app.config([
  '$httpProvider'
  ($httpProvider) ->
    $httpProvider.defaults.headers.common['X-stream'] = true
    $httpProvider.defaults.headers.common['Content-Type'] = 'application/json'
])

app.run(['$rootScope', '$http', ($rootScope, $http) ->
  timer = null
  check = ->
    clearTimeout timer
    $http.get('http://localhost:7474/db/manage/server/monitor/fetch')
    .success(->
      $rootScope.offline = no
    )
    .error(->
      $rootScope.offline = yes
    )
    .then(-> timer = setTimeout(check, 5000))

  check()
])
