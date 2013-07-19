'use strict'

angular.module('neo4jApp.controllers')
  .controller 'LayoutCtrl', [
    '$rootScope'
    '$dialog'
    ($scope, $dialog) ->
      currentView = null

      dialog = null
      dialogOptions =
        backdrop: yes
        backdropClick: yes
        backdropFade: yes
        dialogFade: yes
        keyboard: yes

      $scope.isEditorHidden = false
      $scope.toggleEditor = ->
        $scope.isEditorHidden ^= true

      $scope.isGraphExpanded = false
      $scope.toggleGraph = ->
        $scope.isGraphExpanded ^= true

      $scope.isTableExpanded = false
      $scope.toggleTable = ->
        $scope.isTableExpanded ^= true

      $scope.isHistoryShown = false
      $scope.toggleHistory = ->
        $scope.isHistoryShown ^= true

      $scope.isPopupShown = false
      $scope.togglePopup = (content) ->
        if content?
          if not dialog?.isOpen()
            dialogOptions.templateUrl = 'popup-' + content
            dialog = $dialog.dialog(dialogOptions)
            dialog.open()
        else
          dialog.close()

        # Add unique classes so that we can style popups individually
        dialog.modalEl.removeClass('modal-' + $scope.popupContent) if $scope.popupContent
        dialog.modalEl.addClass('modal-' + content) if content

        $scope.popupContent = content
        $scope.isPopupShown = !!content

      $scope.globalKey = (e) ->

        # Don't toggle anything when shortcut popup is open
        return if $scope.isPopupShown and e.keyCode != 191

        if (e.metaKey or e.ctrlKey) and e.keyCode is 13 # Cmd-Enter
          currentView?.exec()
        else if e.ctrlKey and e.keyCode is 38 # Ctrl-Up
          $scope.$broadcast 'views:previous'
        else if e.ctrlKey and e.keyCode is 40 # Ctrl-Down
          $scope.$broadcast 'views:next'
        else if e.keyCode is 27 # Esc
          if $scope.isPopupShown
            $scope.togglePopup()
          else
            $scope.toggleEditor()

        else if $scope.isEditorHidden
          if e.keyCode is 72 # h
            $scope.toggleHistory()
          else if e.keyCode is 84 # t
            $scope.toggleGraph()
          else if e.keyCode is 191 # ?
            $scope.togglePopup('keys')
          else if e.keyCode is 78 # n
            $scope.$broadcast 'views:create'
          else if e.keyCode is 68 # d
            alert "duplicate current view"

      $scope.$on 'currentView:changed', (evt, view) ->
        currentView = view
        return unless view?
        layout = view.suggestedLayout()
        $scope.isGraphExpanded = layout.graph
        $scope.isTableExpanded = layout.table
  ]
