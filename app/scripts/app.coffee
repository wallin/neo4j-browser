'use strict'

angular.module('neo4jApp.directives', [])
angular.module('neo4jApp.filters', [])
angular.module('neo4jApp.services', ['LocalStorageModule'])

app = angular.module('neo4jApp', [
  'neo4jApp.directives'
  'neo4jApp.filters'
  'neo4jApp.services'
  'ui.codemirror'
  'angularMoment'
])

app
  .config ['$routeProvider', ($routeProvider) ->
    $routeProvider
      .when('/:viewId')
      .otherwise
        redirectTo: '/'
  ]

app.config([
  '$httpProvider'
  ($httpProvider) ->
    $httpProvider.defaults.headers.common['X-stream'] = true
    $httpProvider.defaults.headers.common['Content-Type'] = 'application/json'
])

app.run(['$rootScope', '$http', '$timeout', ($scope, $http, $timeout) ->
  timer = null
  check = ->
    $timeout.cancel(timer)
    $http.get('http://localhost:7474/db/manage/server/monitor/fetch')
    .success(->
      $scope.offline = no
    )
    .error(->
      $scope.offline = yes
    )
    .then(-> timer = $timeout(check, 5000))

  check()
])


app.run(['$rootScope', ($rootScope) ->
  $rootScope.viewPath = (id) -> "#/#{id}"
])
