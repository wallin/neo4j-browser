'use strict'

describe 'Controller: LeftbarCtrl', () ->

  # load the controller's module
  beforeEach module 'neo4jApp.controllers', 'neo4jApp.services'

  LeftbarCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    LeftbarCtrl = $controller 'LeftbarCtrl', {
      $scope: scope
    }

  describe 'createFolder:', ->

  describe 'removeDocument', ->
