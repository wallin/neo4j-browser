'use strict'

angular.module('neo4jApp')
.controller 'MainCtrl', [
  '$location'
  '$route'
  '$scope'
  'viewService'
  ($location, $route, $scope, viewService) ->
    $scope.views = viewService

    $scope.createView = (query, navigate = yes) ->
      len = viewService.history.all().length + 1
      query ?= "// Query no. #{len}"
      view = viewService.create(query)
      $location.path($scope.viewPath(view.id)) if navigate

    $scope.copyView = (view) ->
      return unless view?.id?
      query = view.input
      # Modify comment if any
      if query.beginsWith('//')
        query = query.replace(/\/\/\s?(.)/, "// Copy of $1")

      $scope.createView(query)

    if viewService.history.where(starred: no).length is 0
      $scope.createView(undefined, no) # Create new view with default name

    $scope.$on '$routeChangeSuccess', ->
      viewId = $route.current.params.viewId
      if not viewId?
        viewId = viewService.history.last().id
        $location.path($scope.viewPath(viewId))

      if not viewService.history.get(viewId)
        return $location.path('/views')

      viewService.select(viewId)
]
