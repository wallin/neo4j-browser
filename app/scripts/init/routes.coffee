angular.module('neo4jApp')
  .config ['$routeProvider', ($routeProvider) ->
    $routeProvider
      .when('/')
      .when('/views/:viewId')
      .otherwise
        redirectTo: '/'
  ]
