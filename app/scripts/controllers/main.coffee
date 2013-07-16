'use strict'

angular.module('neo4jApp.controllers')
.controller 'MainCtrl', [
  '$location'
  '$route'
  '$scope'
  'Collection'
  'viewService'
  ($location, $route, $scope, Collection, viewService) ->

    scopeApply = (fn)->
      return ->
        fn.apply($scope, arguments)
        $scope.$apply()

    $scope.sortableOptions =
      stop: scopeApply (e, ui) ->
        if ui.item.resort
          true
        if ui.item.relocate
          view = ui.item.scope().view
          folder = ui.item.folder
          view.folder = folder
          view.starred = !!folder
        else if not ui.item.resort
          view = ui.item.scope().view
          $scope.views.remove(view)

        viewService.persist('views', $scope.views.where(starred: yes))

      update: (e, ui) ->
        ui.item.resort = yes

      receive: (e, ui) ->
        ui.item.relocate = yes
        ui.item.folder = angular.element(e.target).scope().folder?.id

      connectWith: '.droppable'

    $scope.currentView = null

    # Initialize from default content and persisted views/folders
    $scope.folders = new Collection(viewService.default('folders'))
    $scope.views   = new Collection(viewService.default('views'))

    $scope.folders.add(viewService.persisted('folders'))
    $scope.views.add(viewService.persisted('views'))

    $scope.createFolder = ->
      folder = new viewService.Folder()
      $scope.folders.add(folder)
      viewService.persist('folders', $scope.folders.all())
      folder

    # Create an unsaved view
    $scope.createView = (data = {}, navigate = yes) ->
      len = $scope.views.length + 1
      data.input ?= "// Query no. #{len}"
      data.starred ?= no
      view = new viewService.View(data)
      $scope.views.add(view)
      $location.path($scope.viewPath(view.id)) if navigate
      view

    # Create an unsaved copy of a view
    $scope.copyView = (view) ->
      return unless view?.id?
      query = view.input
      # Modify comment if any
      if query.beginsWith('//')
        query = query.replace(/\/\/\s?(.)/, "// Copy of $1")

      $scope.createView(input: query)

    $scope.removeFolder = (folder) ->
      $scope.folders.remove(folder)
      viewService.persist('folders', $scope.folders.all())

    $scope.toggleFolder = (folder) ->
      folder.expanded = !folder.expanded
      viewService.persist('folders', $scope.folders.all())

    $scope.toggleStar = (view) ->
      view.starred = !view.starred
      viewService.persist('views', $scope.views.where(starred: yes))

    $scope.viewUrl = (id) -> "##{$scope.viewPath(id)}"
    $scope.viewPath = (id = '') -> "/views/#{id}"

    if $scope.views.where(starred: no).length is 0
      $scope.createView(undefined, no) # Create new view with default name

    $scope.$on '$routeChangeSuccess', ->
      viewId = $route.current.params.viewId
      if not viewId?
        viewId = $scope.views.last().id
        $location.path($scope.viewPath(viewId))

      $scope.currentView = $scope.views.get(viewId)
      if not $scope.currentView
        return $location.path('/views')


]
