'use strict'

describe 'Controller: ServerInfoCtrl', () ->

  # load the controller's module
  beforeEach module 'neo4jApp.controllers'

  ServerInfoCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    ServerInfoCtrl = $controller 'ServerInfoCtrl', {
      $scope: scope
    }

