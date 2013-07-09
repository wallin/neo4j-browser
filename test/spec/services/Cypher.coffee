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

  describe 'Node type:', ->
    beforeEach ->
      node = new Cypher.Node(nodeData(123, {name: 'John Doe'}))

    it 'should set id-attribute from response', ->
      expect(node.id).toBe 123

    it 'should inherit attributes from response data-attribute', ->
      expect(node.name).toBe 'John Doe'

  describe 'Relationship type:', ->
    beforeEach ->
      rel = new Cypher.Relationship(relationshipData(123, "ROOT"))

    it 'should set id-attribute from response', ->
      expect(rel.id).toBe 123

    it 'should set type from response data', ->
      expect(rel.type).toBe 'ROOT'
