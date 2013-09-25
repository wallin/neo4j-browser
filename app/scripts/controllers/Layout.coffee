'use strict'
#
# Handles UI state and current page
#
angular.module('neo4jApp.controllers')
  .controller 'LayoutCtrl', [
    '$rootScope'
    '$timeout'
    '$dialog'
    '$route'
    'Editor'
    'Frame'
    'GraphStyle'
    'Utils'
    ($scope, $timeout, $dialog, $route, Editor, Frame, GraphStyle, Utils) ->

      dialog = null
      dialogOptions =
        backdrop: yes
        backdropClick: yes
        backdropFade: yes
        dialogFade: yes
        keyboard: yes

      $scope.showDoc = () ->
        Frame.create(input: ':play')

      $scope.showStats = () ->
        Frame.create(input: ':schema')

      $scope.focusEditor = () ->
        event.preventDefault()
        $('#editor textarea').focus()

      $scope.editorOneLine = true
      $scope.editorChanged = (codeMirror) ->
        $scope.editorOneLine = codeMirror.lineCount() == 1

      $scope.isDrawerShown = false
      $scope.whichDrawer = ""
      $scope.toggleDrawer = (selectedDrawer = "", state) ->
        state ?= !$scope.isDrawerShown or (selectedDrawer != $scope.whichDrawer)
        $scope.isDrawerShown = state
        $scope.whichDrawer = selectedDrawer

      $scope.$watch 'isDrawerShown', () ->
        $timeout(() -> $scope.$emit 'layout.changed', 0)

      $scope.isInspectorShown = no
      $scope.toggleInspector = ->
        $scope.isInspectorShown ^= true

      $scope.$watch 'selectedGraphItem', Utils.debounce((val) ->
        $scope.isInspectorShown = !!val
      ,200)
      $scope.isPopupShown = false
      $scope.togglePopup = (content) ->
        if content?
          if not dialog?.isOpen()
            dialogOptions.templateUrl = 'popup-' + content
            dialog = $dialog.dialog(dialogOptions)
            dialog.open().then(->
              $scope.popupContent = null
              $scope.isPopupShown = no
            )
        else
          dialog.close() if dialog?

        # Add unique classes so that we can style popups individually
        dialog.modalEl.removeClass('modal-' + $scope.popupContent) if $scope.popupContent
        dialog.modalEl.addClass('modal-' + content) if content

        $scope.popupContent = content
        $scope.isPopupShown = !!content

      $scope.globalKey = (e) ->
        # Don't toggle anything when shortcut popup is open
        return if $scope.isPopupShown and e.keyCode != 191

        if (e.metaKey or e.ctrlKey) and e.keyCode is 13 # Cmd-Enter
          Editor.execCurrent()
        else if e.ctrlKey and e.keyCode is 38 # Ctrl-Up
          e.preventDefault()
          Editor.historyPrev()
        else if e.ctrlKey and e.keyCode is 40 # Ctrl-Down
          e.preventDefault()
          Editor.historyNext()
        else if e.keyCode is 27 # Esc
          if $scope.isPopupShown
            $scope.togglePopup()
          else
            $scope.toggleEditor()

      # we need set a max-height to make the stream scrollable, but since it's
      # position:relative the max-height needs to be calculated.
      timer = null
      resize = ->
        $('#stream').css
          'max-height': $(window).height() - $('#editor').height() - 40
        $scope.$emit 'layout.changed'
      $(window).resize(resize)
      check = ->
        resize()
        $timeout.cancel(timer)
        timer = $timeout(check, 500, false)
      check()
  ]
