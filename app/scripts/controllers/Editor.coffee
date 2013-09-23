'use strict'
# TODO: maybe skip this controller and provide global access somewhere?
angular.module('neo4jApp.controllers')
  .controller 'EditorCtrl', [
    '$scope'
    'Editor'
    ($scope, Editor) ->
      $scope.editor = Editor
  ]
