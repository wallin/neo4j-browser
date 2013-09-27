'use strict';

angular.module('neo4jApp.services')
  .service 'Editor', [
    'Document'
    'Frame'
    'Settings'
    'localStorageService'
    (Document, Frame, Settings, localStorageService) ->
      storageKey = 'history'
      class Editor
        constructor: ->
          @history = localStorageService.get(storageKey)
          @history = [] unless angular.isArray(@history)
          @content = ''
          @cursor = null
          @document = null
          @next = null
          @prev = null
          @setMessage('Welcome to the Neo4j Browser.')

        execScript: (input) ->
          @showMessage = no
          frame = Frame.create(input: input)
          if input?.length > 0 and @history[0] isnt input
            @history.unshift(input)
            @history.pop() until @history.length <= Settings.maxHistory
            localStorageService.add(storageKey, JSON.stringify(@history))
          @historySet(-1)
          if !frame and input != ''
            @setMessage("You screamed <b>#{input}</b> but nobody replied.", 'error')

        execCurrent: ->
          @execScript(@content)

        focusEditor: ->
          $('#editor textarea').focus()

        hasChanged:->
          @document?.content and @document.content.trim() isnt @content.trim()

        historyNext: ->
          idx = @cursor
          idx ?= @history.length
          idx--
          @historySet(idx)

        historyPrev: ->
          idx = @cursor
          idx ?= -1
          idx++
          @historySet(idx)

        historySet: (idx) ->
          idx = -1 if idx < 0
          idx = @history.length - 1 if idx >= @history.length
          @cursor = idx
          @prev = @history[idx+1]
          @next = @history[idx-1]
          item = @history[idx] or ''
          @content = item
          @document = null

        loadDocument: (id) ->
          doc = Document.get(id)
          return unless doc
          @content = doc.content
          @focusEditor()
          @document = doc

        saveDocument: ->
          input = @content.trim()
          return unless input
          # re-fetch document from collection
          @document = Document.get(@document.id) if @document?.id
          if @document?.id
            @document.content = input
            Document.save()
          else
            @document = Document.create(content: @content)

        setContent: (content = '')->
          @content = content
          @focusEditor()
          @document = null

        setMessage: (message, type = 'info')
          @showMessage = yes
          @errorCode = type
          @errorMessage = message

      editor = new Editor()

      # Configure codemirror
      CodeMirror.commands.handleEnter = (cm) ->
        if cm.lineCount() == 1
          editor.execCurrent()
        else
          CodeMirror.commands.newlineAndIndent(cm)

      CodeMirror.commands.handleUp = (cm) ->
        if cm.lineCount() == 1
          editor.historyPrev()
        else
          CodeMirror.commands.goLineUp(cm)

      CodeMirror.commands.handleDown = (cm) ->
        if cm.lineCount() == 1
          editor.historyNext()
        else
          CodeMirror.commands.goLineDown(cm)

      CodeMirror.keyMap["default"]["Enter"] = "handleEnter"
      CodeMirror.keyMap["default"]["Shift-Enter"] = "newlineAndIndent"
      CodeMirror.keyMap["default"]["Up"] = "handleUp"
      CodeMirror.keyMap["default"]["Down"] = "handleDown"

      editor
  ]
