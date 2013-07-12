'use strict'

angular.module('neo4jApp')
  .controller 'LayoutCtrl', ($scope) ->
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
      if e.metaKey and e.keyCode is 13 # Cmd-Enter
        alert "Not implemented yet. In the meantime, click the play button."
      else if e.keyCode is 27 # Esc
        $scope.toggleEditor()
      #else if e.keyCode is 72 # h
      #  $scope.toggleHistory()


    $scope.$on 'viewService:changed', (evt, view) ->
      return unless view?
      layout = view.layout()
      $scope.isGraphExpanded = layout.graph
      $scope.isTableExpanded = layout.table
