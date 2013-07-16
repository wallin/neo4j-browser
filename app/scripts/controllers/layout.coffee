'use strict'

angular.module('neo4jApp')
  .controller 'LayoutCtrl', ($scope) ->
    currentView = null

    $scope._isEditorHidden = $scope.isEditorHidden = false
    $scope.toggleEditor = ->
      #unless $scope.isHistoryShown
      $scope._isEditorHidden = $scope.isEditorHidden ^= true

    $scope.isGraphExpanded = false
    $scope.toggleGraph = ->
      $scope.isGraphExpanded ^= true

    $scope.isTableExpanded = false
    $scope.toggleTable = ->
      $scope.isTableExpanded ^= true

    $scope.isHistoryShown = true
    $scope.toggleHistory = ->
      $scope.isHistoryShown ^= true

    $scope.isShortcutsShown = false
    $scope.toggleShortcuts = ->
      $scope.isShortcutsShown ^= true

    $scope.globalKey = (e) ->

      # Don't toggle anything when shortcut popup is open
      return if $scope.isShortcutsShown and e.keyCode != 191

      if (e.metaKey or e.ctrlKey) and e.keyCode is 13 # Cmd-Enter
        currentView?.exec()
      else if e.ctrlKey and e.keyCode is 38 # Ctrl-Up
        alert "TBD: goto previous view"
      else if e.ctrlKey and e.keyCode is 40 # Ctrl-Down
        alert "TBD: goto next view"
      else if e.keyCode is 27 # Esc
        $scope.toggleEditor()
      else if $scope.isEditorHidden
        if e.keyCode is 72 # h
          $scope.toggleHistory()
        else if e.keyCode is 84 # t
          $scope.toggleGraph()
        else if e.keyCode is 191 # ?
          $scope.toggleShortcuts()
        else if e.keyCode is 78 # n
          alert "create a new view"
        else if e.keyCode is 68 # d
          alert "duplicate current view"

    $scope.$on 'viewService:changed', (evt, view) ->
      currentView = view
      return unless view?
      layout = view.suggestedLayout()
      $scope.isGraphExpanded = layout.graph
      $scope.isTableExpanded = layout.table
