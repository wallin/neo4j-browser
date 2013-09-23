'use strict'

angular.module('neo4jApp.controllers')
  .controller 'LeftbarCtrl', [
    '$scope'
    'Document'
    'Editor'
    'Folder'
    ($scope, Document, Editor, Folder) ->
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

      $scope.toggleFolder = (folder) ->
        Folder.expand(folder)

      $scope.removeFolder = (folder) ->
        return unless confirm("Are you sure you want to delete the folder?")
        Folder.remove(folder)

      $scope.removeDocument = (doc) ->
        Document.remove(doc)

      $scope.importDocument = (content) ->
        Document.create(content: content)

      ###*
       * Initialization
      ###

      # Handlers for drag n drop (for angular-ui-sortable)
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

      # Expose editor service to be able to play saved scripts
      $scope.editor = Editor
      # Expose documents and folders to views
      $scope.folders = Folder
      $scope.documents   = Document
  ]
