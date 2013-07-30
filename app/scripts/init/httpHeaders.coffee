angular.module('neo4jApp').config([
  '$httpProvider'
  ($httpProvider) ->
    $httpProvider.defaults.headers.common['X-stream'] = true
    $httpProvider.defaults.headers.common['Content-Type'] = 'application/json'
])
