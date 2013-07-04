'use strict'

describe 'Controller: LayoutCtrl', () ->

  # load the controller's module
  beforeEach module 'neo4jApp'

  LayoutCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    LayoutCtrl = $controller 'LayoutCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', () ->
    expect(scope.awesomeThings.length).toBe 3;
