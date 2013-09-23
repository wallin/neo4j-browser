'use strict'
# TODO: maybe skip this controller and provide global access somewhere?
angular.module('neo4jApp.controllers')
  .controller 'EditorCtrl', [
    '$scope'
    'Editor'
    'motdService'
    ($scope, Editor, motdService) ->
      $scope.editor = Editor
      $scope.motd = motdService

      $scope.star = ->
        Editor.saveDocument()
        $scope.toggleSidebar("scripts", true)
  ]
