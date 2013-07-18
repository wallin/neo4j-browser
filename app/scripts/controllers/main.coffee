'use strict'

angular.module('neo4jApp.controllers')
.controller 'MainCtrl', [
  '$location'
  '$route'
  '$scope'
  'Collection'
  'viewService'
  ($location, $route, $scope, Collection, viewService) ->

    ###*
     * Local methods
    ###

    persistViews = ->
      viewService.persist('views', $scope.views.where(starred: yes))

    persistFolders = ->
      viewService.persist('folders', $scope.folders.all())

    scopeApply = (fn)->
      return ->
        fn.apply($scope, arguments)
        $scope.$apply()

    ###*
     * Scope methods
    ###

    $scope.createFolder = ->
      folder = new viewService.Folder()
      $scope.folders.add(folder)
      persistFolders()
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

    $scope.skipViews = (count) ->
      orderedViews = []
      for folder in $scope.folders.all()
        orderedViews = orderedViews.concat $scope.views.where({folder: folder.id})
      orderedViews = orderedViews.concat $scope.views.where({starred: false})
      for view, i in orderedViews
        if $scope.currentView.id == view.id
          newIndex = (i + count)
          newIndex = orderedViews.length + newIndex if newIndex < 0
          $scope.currentView = orderedViews[newIndex % orderedViews.length]
          break

    $scope.removeFolder = (folder) ->
      $scope.folders.remove(folder)
      viewsToRemove = $scope.views.where(folder: folder.id)
      $scope.views.remove(viewsToRemove)
      persistFolders()
      persistViews() if viewsToRemove.length

    $scope.toggleFolder = (folder) ->
      folder.expanded = !folder.expanded
      persistFolders()

    $scope.toggleStar = (view) ->
      view.starred = !view.starred
      view.folder = false unless view.starred
      persistViews()

    $scope.viewUrl = (id) -> "##{$scope.viewPath(id)}"
    $scope.viewPath = (id = '') -> "/views/#{id}"


    ###*
     * Event listeners
    ###

    $scope.$on '$routeChangeSuccess', ->
      viewId = $route.current.params.viewId
      if not viewId?
        viewId = $scope.views.last().id
        $location.path($scope.viewPath(viewId))

      $scope.currentView = $scope.views.get(viewId)
      if not $scope.currentView
        return $location.path('/views')

    $scope.$on 'fileUpload:success', (evt, data) ->
      $scope.createView(input: data)

    $scope.$on 'views:next', ->
      $scope.skipViews(1)

    $scope.$on 'views:previous', ->
      $scope.skipViews(-1)

    $scope.$on 'views:create', ->
      $scope.createView()


    ###*
     * Initialization
    ###

    # Handlers for drag n drop
    $scope.sortableOptions =
      stop: scopeApply (e, ui) ->
        view = ui.item.scope().view

        folder = if ui.item.folder? then ui.item.folder else view.folder
        offsetLeft = Math.abs(ui.position.left - ui.originalPosition.left)

        if ui.item.relocate
          view.folder = folder
          view.starred = !!folder
        # XXX: FIXME
        else if offsetLeft > 200
          view = ui.item.scope().view
          $scope.views.remove(view)

        if ui.item.resort
          idxOffset = ui.item.index()
          # Get insertion index offset
          first = $scope.views.where(folder: folder)[0]
          idx = $scope.views.indexOf(first)
          idx = 0 if idx < 0
          $scope.views.remove(view)
          $scope.views.add(view, {at: idx + idxOffset})

        persistViews()

      update: (e, ui) ->
        ui.item.resort = yes

      receive: (e, ui) ->
        ui.item.relocate = yes
        folder = angular.element(e.target).scope().folder
        ui.item.folder = if folder? then folder.id else false

      cursor: "move"
      dropOnEmpty: yes
      connectWith: '.droppable'
      items: 'li'

    # Initialize from default content and persisted views/folders
    $scope.folders = new Collection(viewService.default('folders'))
    $scope.views   = new Collection(viewService.default('views'))

    $scope.folders.add(viewService.persisted('folders'))
    $scope.views.add(viewService.persisted('views'))

    $scope.currentView = null
    $scope.$watch 'currentView', (val) ->
      $scope.$emit('currentView:changed', val)
    $scope.$watch 'currentView.response', ->
      $scope.$emit('currentView:changed', $scope.currentView)

    if $scope.views.where(starred: no).length is 0
      $scope.createView(undefined, no) # Create new view with default name
  ]
