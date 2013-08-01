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

    $scope.createFolder = (id)->
      folder = new Folder(id: id)
      $scope.folders.add(folder)
      $scope.folders.save()
      folder

    # Creates and executes a new frame
    $scope.createFrame = (data = {}) ->
      return undefined unless data.input
      $scope.currentFrame = frame = Frame.create(data)
      $scope.frames.add(frame.exec()) if frame
      frame

    $scope.createDocument = (data = {}) ->
      $scope.documents.add(new Document(data)).save()

    $scope.destroyFrame = (frame) ->
      $scope.frames.remove(frame)

    $scope.setEditorContent = (content) ->
      $scope.editor.content = content

    $scope.execScript = (input) ->
      frame = $scope.createFrame(input: input)
      return unless frame
      $scope.editorHistory.add(input)
      $scope.historySet(input)
      $scope.editor.content = ""

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
      $scope.toggleSidebar()

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
    $scope.$on 'editor:content', (ev, content) ->
      $scope.editor.content = content

    $scope.$on 'editor:exec', ->
      $scope.execScript($scope.editor.content)

    $scope.$on 'editor:next', $scope.historyNext

    $scope.$on 'editor:prev', $scope.historyPrev

    $scope.$on 'frames:clear', ->
      $scope.frames.reset()

    $scope.$on 'frames:create', (evt, input) ->
      $scope.createFrame(input: input)

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

    # Find and restore orphan folders
    for doc in $scope.documents.all()
      continue unless doc.folder?
      if not $scope.folders.get(doc.folder)
        $scope.createFolder(doc.folder)

    $scope.frames = new Collection()
    $scope.createFrame(input: 'help welcome')
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
