angular.module('neo4jApp').run([
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
