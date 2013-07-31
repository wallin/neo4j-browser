'use strict'

describe 'Service: Frame', () ->
  [backend, view] = [null, null]

  # load the service's module
  beforeEach module 'neo4jApp.services'

  beforeEach inject ($httpBackend) ->
    backend = $httpBackend

  afterEach ->
    backend.verifyNoOutstandingRequest()

  # instantiate service
  Frame = {}
  beforeEach inject (_Frame_) ->
    Frame = _Frame_

