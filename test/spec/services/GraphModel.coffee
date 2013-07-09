'use strict'

describe 'Service: GraphModel', () ->
  graph = null
  # load the service's module
  beforeEach module 'neo4jApp.services'

  # instantiate service
  GraphModel = {}
  Cypher = {}
  beforeEach inject (_GraphModel_, _Cypher_) ->
    GraphModel = _GraphModel_
    Cypher     = _Cypher_

  createNode = (id) ->
    data = {
      "all_relationships": "http://localhost:7474/db/data/node/#{id}/relationships/all",
      "all_typed_relationships": "http://localhost:7474/db/data/node/#{id}/relationships/all/{-list|&|types}",
      "create_relationship": "http://localhost:7474/db/data/node/#{id}/relationships",
      "data": {},
      "extensions": {},
      "incoming_relationships": "http://localhost:7474/db/data/node/#{id}/relationships/in",
      "incoming_typed_relationships": "http://localhost:7474/db/data/node/#{id}/relationships/in/{-list|&|types}",
      "outgoing_relationships": "http://localhost:7474/db/data/node/#{id}/relationships/out",
      "outgoing_typed_relationships": "http://localhost:7474/db/data/node/#{id}/relationships/out/{-list|&|types}",
      "paged_traverse": "http://localhost:7474/db/data/node/#{id}/paged/traverse/{returnType}{?pageSize,leaseTime}",
      "properties": "http://localhost:7474/db/data/node/#{id}/properties",
      "property": "http://localhost:7474/db/data/node/#{id}/properties/{key}",
      "self": "http://localhost:7474/db/data/node/#{id}",
      "traverse": "http://localhost:7474/db/data/node/#{id}/traverse/{returnType}"
    }
    new Cypher.Node(data)

  describe 'addNode:', ->
    beforeEach ->
      graph = new GraphModel
    it 'should add a node to collection', ->
      node = createNode(1)
      graph.addNode(node)
      expect(graph.nodes.all().length).toBe 1

    it 'should not add new node with existing id', ->
      node1 = createNode(1)
      node2 = createNode(1)
      graph.addNode(node1)
      graph.addNode(node2)
      expect(graph.nodes.all().length).toBe 1

    it 'should be able to add a node with id 0', ->
      node = createNode(0)
      graph.addNode(node)
      expect(graph.nodes.all().length).toBe 1
