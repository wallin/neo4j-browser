'use strict';

angular.module('neo4jApp.services')
  .service 'Editor', [
    'Document'
    'Frame'
    (Document, Frame) ->

      class Editor
        constructor: ->
          @history = []
          @content = ''
          @cursor = null
          @documentId = null
          @next = null
          @prev = null

        execScript: (input) ->
          frame = Frame.create(input: input)
          #return unless frame
          if input?.length > 0 and @history[0] isnt input
            @history.unshift(input)
          @historySet(-1)

        execCurrent: ->
          @execScript(@content)

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
          @documentId = null

        loadDocument: (id) ->
          doc = Document.get(id)
          return unless doc
          @content = doc.content
          @documentId = doc.id

        saveDocument: ->
          input = @content.trim()
          return unless input
          doc = Document.get(@documentId) if @documentId
          if doc
            doc.content = input
            Document.save()
          else
            doc = Document.create(content: @content)
            @documentId = doc.id

      editor = new Editor()

      # Configure codemirror
      CodeMirror.commands.handleEnter = (cm) ->
        if cm.lineCount() == 1
          editor.execCurrent()
          $('.intro').removeClass('visible')
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
