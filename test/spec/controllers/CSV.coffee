'use strict'

describe 'Controller: CSVCtrl', () ->

  # load the controller's module
  beforeEach module 'neo4jApp.controllers', 'neo4jApp.services'

  CSVCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    CSVCtrl = $controller 'CSVCtrl', {
      $scope: scope
    }

