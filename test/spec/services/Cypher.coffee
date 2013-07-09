'use strict'

describe 'Service: Cypher', () ->
  backend = null

  # load the service's module
  beforeEach module 'neo4jApp.services'

  beforeEach inject ($httpBackend) ->
    backend = $httpBackend

  afterEach ->
    backend.verifyNoOutstandingRequest()

  # instantiate service
  cypher = {}
  beforeEach inject (_Cypher_) ->
    cypher = _Cypher_


  describe "send:", ->
    it 'should send POST request when invoked', () ->
      backend.expectPOST(/db\/data\/cypher/).respond()
      cypher.send('START n=node(*) RETURN n;')
      backend.flush()
