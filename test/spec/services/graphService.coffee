'use strict'

describe 'Service: graphService', () ->
  [backend, Graph] = [null, null]

  # load the service's module
  beforeEach module 'neo4jApp.services'

  beforeEach inject ($httpBackend, GraphModel) ->
    backend = $httpBackend
    Graph = GraphModel

  # instantiate service
  graphService = {}
  beforeEach inject (_graphService_) ->
    graphService = _graphService_

  it 'should do something', () ->
    expect(!!graphService).toBe true;
