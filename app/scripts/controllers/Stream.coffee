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

    # TODO: fix timeout problem
    $timeout(->
      $('.intro').addClass('visible')
      #Frame.create(input: ':help welcome')
    , 800)
  ]
