'use strict'

angular.module('neo4jApp.controllers')
.controller 'ViewCtrl', [
  '$location'
  '$route'
  '$scope'
  'Collection'
  'viewService'
  'motdService'
  ($location, $route, $scope, Collection, viewService, motdService) ->

    ###*
     * Local methods
    ###

    handleRoute = ->
      return unless $route.current?.page is 'views'
      viewId = $route.current.params.viewId
      if not viewId?
        viewId = $scope.views.last().id
        $location.path($scope.viewPath(viewId))

      view = $scope.views.get(viewId)
      if not view
        return $location.path('/views')
      else
        $scope.loadView(view)

    persistViews = ->
      viewService.persist('views', $scope.views.where(starred: yes))

    persistFolders = $scope.persistFolders = ->
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
      data.input ?= "// New view ##{len}"
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

    $scope.setEditorContent = (content) ->
      $scope.editor.content = content

    # Executes a script and pushes it to history
    $scope.execScript = (input) ->
      $scope.createView(input: input).exec()

    $scope.importView = (content) ->
      $scope.createView(input: content, starred: yes)

    $scope.loadView = (view) ->
      $scope.currentView = view
      $scope.editor =
        content: view.input

    $scope.destroyView = (view) ->
      $scope.views.remove(view)

    $scope.skipViews = (count) ->
      orderedViews = []
      for folder in $scope.folders.all()
        orderedViews = orderedViews.concat $scope.views.where({folder: folder.id})
      orderedViews = orderedViews.concat $scope.views.where({starred: false})
      for view, i in orderedViews
        if $scope.currentView.id is view.id
          newIndex = (i + count)
          newIndex = orderedViews.length + newIndex if newIndex < 0
          newView = orderedViews[newIndex % orderedViews.length]
          $location.path($scope.viewPath(newView.id))
          break

    $scope.removeFolder = (folder) ->
      okToRemove = confirm("Are you sure you want to delete the folder?")
      return unless okToRemove
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

    $scope.$on '$routeChangeSuccess', handleRoute

    $scope.$on 'views:next', ->
      $scope.skipViews(1)

    $scope.$on 'views:previous', ->
      $scope.skipViews(-1)

    $scope.$on 'views:create', ->
      $scope.createView()

    $scope.$on 'views:exec', ->
      $scope.execScript($scope.editor.content)

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

    $scope.$watch 'currentView', (val) ->
      $scope.$emit('currentView:changed', val)
    $scope.$watch 'currentView.response', ->
      $scope.$emit('currentView:changed', $scope.currentView)

    $scope.motd = motdService # '"When you label me, you negate me" -- Soren Kierkegaard III'

    handleRoute()
  ]
