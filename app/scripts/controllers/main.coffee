'use strict'

angular.module('neo4jApp')
.controller 'MainCtrl', [
  '$location'
  '$route'
  '$scope'
  'viewService'
  ($location, $route, $scope, viewService) ->
    $scope.views = viewService

    $scope.createView = (query) ->
      len = viewService.history.all().length + 1
      query ?= "//Query no. #{len}"
      view = viewService.push(query)
      $location.path("/#{view.id}")


    if viewService.history.where(starred: no).length is 0
      $scope.createView()

    $scope.$on '$routeChangeSuccess', ->
      viewId = parseInt($route.current.params.viewId, 10)
      if isNaN(viewId)
        viewId = viewService.history.last().id
      else if not viewService.history.get(viewId)
        $location.path('/')

      viewService.select(viewId)
]
