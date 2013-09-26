'use strict'

angular.module('neo4jApp.controllers')
.controller 'StreamCtrl', [
  '$scope'
  '$timeout'
  'Document'
  'Frame'
  'motdService'
  ($scope, $timeout, Document, Frame, motdService) ->
    ###*
     * Initialization
    ###
    $scope.frames = Frame
    $scope.motd = motdService
  ]
