'use strict'

angular.module('neo4jApp.controllers')
.controller 'ViewCtrl', [
  '$location'
  '$route'
  '$scope'
  'Collection'
  'Document'
  'Folder'
  'Frame'
  'motdService'
  ($location, $route, $scope, Collection, Document, Folder, Frame, motdService) ->

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

    $scope.createFolder = ->
      folder = new Folder()
      $scope.folders.add(folder)
      $scope.folders.save()
      folder

    # Create a new frame
    $scope.createFrame = (data = {}) ->
      return undefined unless data.input
      $scope.editorHistory.add(data.input)
      $scope.historySet(data.input)
      frame = new Frame(data)
      $scope.frames.add(frame)
      frame

    $scope.createDocument = (data = {}) ->
      $scope.documents.add(new Document(data)).save()

    $scope.destroyFrame = (frame) ->
      $scope.frames.remove(frame)

    $scope.setEditorContent = (content) ->
      $scope.editor.content = content

    # Executes a script and pushes it to history
    $scope.execScript = (input) ->
      frame = $scope.createFrame(input: input)
      frame?.exec()

    $scope.historyNext = ->
      newItem =
        $scope.editorHistory.next($scope.editor.cursor) or
        $scope.editorHistory.last()
      $scope.historySet(newItem)
      if $scope.editor.cursor
        $scope.setEditorContent($scope.editor.cursor)

    $scope.historyPrev = ->
      newItem =
        $scope.editorHistory.prev($scope.editor.cursor) or
        $scope.editorHistory.first()
      $scope.historySet(newItem)
      if $scope.editor.cursor
        $scope.setEditorContent($scope.editor.cursor)

    $scope.historySet = (item)->
      $scope.editor.cursor = item
      $scope.editor.prev = $scope.editorHistory.prev(item)
      $scope.editor.next = $scope.editorHistory.next(item)

    $scope.importDocument = (content) ->
      $scope.createDocument(content: content)

    $scope.loadFrame = (frame) ->
      $scope.currentFrame = frame
      $scope.editor =
        content: frame.input

    $scope.persistFolders = ->
      $scope.folders.save()

    $scope.removeFolder = (folder) ->
      okToRemove = confirm("Are you sure you want to delete the folder?")
      return unless okToRemove
      $scope.folders.remove(folder)
      documentsToRemove = $scope.documents.where(folder: folder.id)
      $scope.documents.remove(documentsToRemove)
      $scope.folders.save()
      $scope.documents.save()

    $scope.toggleFolder = (folder) ->
      folder.expanded = !folder.expanded
      $scope.documents.save()

    $scope.toggleStar = (doc) ->
      $scope.documents.remove(doc)
      $scope.documents.save()


    ###*
     * Event listeners
    ###

    $scope.$on 'editor:exec', ->
      $scope.execScript($scope.editor.content)

    $scope.$on 'editor:next', $scope.historyNext

    $scope.$on 'editor:prev', $scope.historyPrev

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

    # Initialize from persisted documents/folders
    $scope.folders = new Collection(null, Folder).fetch()
    $scope.documents   = new Collection(null, Document).fetch()

    $scope.frames = new Collection()
    $scope.editorHistory = new Collection()
    $scope.editor =
      cursor: null
      content: ''

    $scope.$watch 'currentFrame', (val) ->
      $scope.$emit('currentFrame:changed', val)
    $scope.$watch 'currentFrame.response', ->
      $scope.$emit('currentFrame:changed', $scope.currentFrame)

    $scope.motd = motdService # '"When you label me, you negate me" -- Soren Kierkegaard III'
  ]
