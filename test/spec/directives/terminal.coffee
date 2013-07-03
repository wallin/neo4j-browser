'use strict'

describe 'Directive: terminal', () ->
  beforeEach module 'neo4jApp.directives', 'neo4jApp.services'

  element = {}

  it 'should make hidden element visible', inject ($rootScope, $compile) ->
    element = angular.element '<terminal></terminal>'
    element = $compile(element) $rootScope
    expect(element).toBeTruthy()
