angular.module('neo4jApp').config([
  '$httpProvider'
  ($httpProvider, $tooltipProvider) ->
    $httpProvider.defaults.headers.common['X-stream'] = true
    $httpProvider.defaults.headers.common['Content-Type'] = 'application/json'
])
