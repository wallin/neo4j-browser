'use strict'

angular.module('neo4jApp')
  .controller 'LayoutCtrl', ($scope) ->
    $scope._isEditorHidden = $scope.isEditorHidden = false
    $scope.toggleEditor = ->
      unless $scope.isHistoryShown
        $scope._isEditorHidden = $scope.isEditorHidden ^= true

    $scope.isGraphExpanded = false
    $scope.toggleGraph = ->
      $scope.isGraphExpanded ^= true

    $scope.isTableExpanded = false
    $scope.toggleTable = ->
      $scope.isTableExpanded ^= true

    $scope.isHistoryShown = false
    $scope.toggleHistory = ->
      $scope.isHistoryShown ^= true
      $scope.isEditorHidden = if $scope.isHistoryShown then true else $scope._isEditorHidden

    $scope.globalKey = (e) ->
      if e.metaKey and e.keyCode is 13 # Cmd-Enter
        alert "TBD: Execute"
      else if e.keyCode is 27 # Esc
        $scope.toggleEditor()
      else if e.keyCode is 72 # h
        $scope.toggleHistory()
