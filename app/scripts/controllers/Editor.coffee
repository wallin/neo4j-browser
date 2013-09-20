'use strict'

angular.module('neo4jApp')
  .controller 'EditorCtrl', [
    '$scope'
    'Frame'
    ($scope, Frame) ->

      # Configure codemirror
      CodeMirror.commands.handleEnter = (cm) ->
        if cm.lineCount() == 1
          $scope.$broadcast 'editor:exec'
        else
          CodeMirror.commands.newlineAndIndent(cm)

      CodeMirror.commands.handleUp = (cm) ->
        if cm.lineCount() == 1
          $scope.$broadcast 'editor:prev'
        else
          CodeMirror.commands.goLineUp(cm)

      CodeMirror.commands.handleDown = (cm) ->
        if cm.lineCount() == 1
          $scope.$broadcast 'editor:next'
        else
          CodeMirror.commands.goLineDown(cm)

      CodeMirror.keyMap["default"]["Enter"] = "handleEnter"
      CodeMirror.keyMap["default"]["Shift-Enter"] = "newlineAndIndent"
      CodeMirror.keyMap["default"]["Up"] = "handleUp"
      CodeMirror.keyMap["default"]["Down"] = "handleDown"


      $scope.execScript = (input) ->
        frame = Frame.create(input: input)
        #return unless frame
        if input?.length > 0 and $scope.editorHistory[0] isnt input
          $scope.editorHistory.unshift(input)
        $scope.historySet(-1)

      $scope.setEditorContent = (content) ->
        $scope.editor.content = content

      $scope.historyNext = ->
        idx = $scope.editor.cursor
        idx ?= $scope.editorHistory.length
        idx--
        $scope.historySet(idx)

      $scope.historyPrev = ->
        idx = $scope.editor.cursor
        idx ?= -1
        idx++
        $scope.historySet(idx)

      $scope.historySet = (idx)->
        idx = -1 if idx < 0
        idx = $scope.editorHistory.length - 1 if idx >= $scope.editorHistory.length
        $scope.editor.cursor = idx
        $scope.editor.prev = $scope.editorHistory[idx+1]
        $scope.editor.next = $scope.editorHistory[idx-1]
        item = $scope.editorHistory[idx] or ''
        $scope.setEditorContent(item)

      ###*
       * Event listeners
      ###
      $scope.$on 'editor:content', (ev, content) ->
        $scope.editor.content = content

      $scope.$on 'editor:exec', ->
        $scope.execScript($scope.editor.content)

      $scope.$on 'editor:next', $scope.historyNext

      $scope.$on 'editor:prev', $scope.historyPrev

      $scope.editorHistory = []
      $scope.editor =
        content: ''
        cursor: null
        next: null
        prev: null
  ]
