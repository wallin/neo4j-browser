'use strict'

describe 'Service: viewService', () ->
  [backend, view] = [null, null]

  # load the service's module
  beforeEach module 'neo4jApp.services'

  beforeEach inject ($httpBackend) ->
    backend = $httpBackend

  afterEach ->
    backend.verifyNoOutstandingRequest()

  # instantiate service
  viewService = {}
  beforeEach inject (_viewService_) ->
    viewService = _viewService_

