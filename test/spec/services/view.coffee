'use strict'

describe 'Service: viewService', () ->

  # load the service's module
  beforeEach module 'neo4jApp'

  # instantiate service
  view = {}
  beforeEach inject (_viewService_) ->
    view = _viewService_

  it 'should do something', () ->
    expect(!!view).toBe true;
