'use strict'

describe 'Directive: fileUpload', () ->
  beforeEach module 'neo4jApp.directives'

  element = {}

  it 'should make hidden element visible', inject ($rootScope, $compile) ->
    element = angular.element '<file-upload></file-upload>'
    element = $compile(element) $rootScope
