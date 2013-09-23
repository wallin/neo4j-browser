'use strict'

angular.module('neo4jApp.controllers')
.controller 'StreamCtrl', [
  '$scope'
  '$timeout'
  'Document'
  'Frame'
  ($scope, $timeout, Document, Frame) ->

    ###*
     * Local methods
    ###

    ###*
     * Scope methods
    ###

    $scope.destroyFrame = (frame) ->
      Frame.remove(frame)

    $scope.couldBeCommand = (input) ->
      return false unless input?
      return true if input.charAt(0) is ':'
      return false

    $scope.createDocument = (data = {}) ->
      Document.create(data)

    $scope.importDocument = (content) ->
      $scope.createDocument(content: content)

    ###*
     * Initialization
    ###

    $scope.frames = Frame

    # TODO: fix timeout problem
    $timeout(->
      Frame.create(input: ':help welcome')
    , 800)
  ]
