'use strict'

describe 'Service: cypher', () ->
  backend = null

  # load the service's module
  beforeEach module 'neo4jApp.services'

  beforeEach inject ($httpBackend) ->
    backend = $httpBackend

  afterEach ->
    backend.verifyNoOutstandingRequest()

  # instantiate service
  cypher = {}
  beforeEach inject (_cypher_) ->
    cypher = _cypher_


  describe "send:", ->
    it 'should send POST request when invoked', () ->
      backend.expectPOST(/db\/data\/cypher/).respond()
      cypher.send('START n=node(*) RETURN n;')
      backend.flush()
