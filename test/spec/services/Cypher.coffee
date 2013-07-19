'use strict'

describe 'Service: Cypher', () ->
  [backend, node, rel] = [null, null, null]

  # load the service's module
  beforeEach module 'neo4jApp.services'

  beforeEach inject ($httpBackend) ->
    backend = $httpBackend

  afterEach ->
    backend.verifyNoOutstandingRequest()

  # instantiate service
  Cypher = {}
  beforeEach inject (_Cypher_) ->
    Cypher = _Cypher_


  cypherData = (type = "node", id = 0, attrs = {}) ->
    {
      self: "http://localhost:7474/db/data/#{type}/#{id}"
      data: attrs
    }

  nodeData = (id, attrs) -> cypherData("node", id, attrs)
  relationshipData = (id, type, attrs) ->
    rel = cypherData("relationship", id, attrs)
    rel.type = type if type?
    rel

  describe "send:", ->
    it 'should send POST request when invoked', ->
      backend.expectPOST(/db\/data\/cypher/).respond()
      Cypher.send('START n=node(*) RETURN n;')
      backend.flush()

