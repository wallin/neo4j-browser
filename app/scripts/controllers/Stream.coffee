'use strict'

angular.module('neo4jApp.controllers')
.controller 'StreamCtrl', [
  '$scope'
  '$timeout'
  'Collection'
  'Document'
  'Folder'
  'Frame'
  'motdService'
  ($scope, $timeout, Collection, Document, Folder, Frame, motdService) ->

    ###*
     * Local methods
    ###

    scopeApply = (fn)->
      return ->
        fn.apply($scope, arguments)
        $scope.$apply()

    ###*
     * Scope methods
    ###

    $scope.showingSidebar = (named) ->
      $scope.isSidebarShown and ($scope.whichSidebar == named)

    $scope.createFolder = (id)->
      Folder.create(id)

    $scope.createDocument = (data = {}) ->
      Document.create(data)

    $scope.destroyFrame = (frame) ->
      Frame.remove(frame)

    $scope.couldBeCommand = (input) ->
      return false unless input?
      return true if input.charAt(0) is ':'
      return false

    $scope.importDocument = (content) ->
      $scope.createDocument(content: content)

    $scope.removeFolder = (folder) ->
      okToRemove = confirm("Are you sure you want to delete the folder?")
      return unless okToRemove
      Folder.remove(folder)

    $scope.toggleFolder = (folder) ->
      Folder.expand(folder)

    $scope.toggleStar = (doc) ->
      Document.remove(doc)


    ###*
     * Initialization
    ###

    # Handlers for drag n drop
    $scope.sortableOptions =
      stop: scopeApply (e, ui) ->
        doc = ui.item.scope().document

        folder = if ui.item.folder? then ui.item.folder else doc.folder
        offsetLeft = Math.abs(ui.position.left - ui.originalPosition.left)

        if ui.item.relocate
          doc.folder = folder
          doc.starred = !!folder
        # XXX: FIXME
        else if offsetLeft > 200
          $scope.documents.remove(doc)

        if ui.item.resort
          idxOffset = ui.item.index()
          # Get insertion index offset
          first = $scope.documents.where(folder: folder)[0]
          idx = $scope.documents.indexOf(first)
          idx = 0 if idx < 0
          $scope.documents.remove(doc)
          $scope.documents.add(doc, {at: idx + idxOffset})

        $scope.documents.save()

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

    # Expose documents and folders to views
    $scope.folders = Folder
    $scope.documents   = Document

    $scope.frames = Frame

    # TODO: fix timeout problem
    $timeout(->
      Frame.create(input: ':help welcome')
    , 800)
    $scope.motd = motdService

  ]
