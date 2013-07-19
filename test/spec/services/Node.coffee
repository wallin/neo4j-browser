'use strict'

describe 'Service: Node', () ->
  cypherData = (type = "node", id = 0, attrs = {}) ->
    {
      self: "http://localhost:7474/db/data/#{type}/#{id}"
      data: attrs
    }

  nodeData = (id, attrs) -> cypherData("node", id, attrs)

  # load the service's module
  beforeEach module 'neo4jApp.services'

  # instantiate service
  node = {}

  beforeEach inject (_Node_) ->
    node = new _Node_(nodeData(123, {name: 'John Doe'}))

  it 'should set id-attribute from response', ->
    expect(node.id).toBe 123

  it 'should inherit attributes from response data-attribute', ->
    expect(node.name).toBe 'John Doe'
