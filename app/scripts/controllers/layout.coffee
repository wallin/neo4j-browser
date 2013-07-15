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
      #$scope.isEditorHidden = if $scope.isHistoryShown then true else $scope._isEditorHidden

    $scope.globalKey = (e) ->

      if (e.metaKey or e.ctrlKey) and e.keyCode is 13 # Cmd-Enter
        currentView?.exec()
      else if e.ctrlKey and e.keyCode is 38 # Ctrl-Up
        alert "TBD: goto previous view"
      else if e.ctrlKey and e.keyCode is 40 # Ctrl-Down
        alert "TBD: goto next view"
      else if e.keyCode is 27 # Esc
        $scope.toggleEditor()


    $scope.$on 'viewService:changed', (evt, view) ->
      currentView = view
      return unless view?
      layout = view.suggestedLayout()
      $scope.isGraphExpanded = layout.graph
      $scope.isTableExpanded = layout.table
