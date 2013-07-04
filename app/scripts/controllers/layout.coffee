'use strict'

angular.module('neo4jApp')
  .controller 'LayoutCtrl', ($scope) ->
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
