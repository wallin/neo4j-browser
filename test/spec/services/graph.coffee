'use strict'

describe 'Service: graphService', () ->

  # load the service's module
  beforeEach module 'neo4jApp.services'

  # instantiate service
  graphService = {}
  beforeEach inject (_graphService_) ->
    graphService = _graphService_

  it 'should do something', () ->
    expect(!!graphService).toBe true;
