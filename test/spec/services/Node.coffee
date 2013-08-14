'use strict'

describe 'Service: Node', () ->
  nodeData = (id, attrs) ->
    {
      id: id
      properties: attrs
      labels: []
    }

  # load the service's module
  beforeEach module 'neo4jApp.services'

  # instantiate service
  node = {}

  beforeEach inject (_Node_) ->
    node = new _Node_(nodeData(123, {name: 'John Doe'}))

  it 'should set id-attribute from response', ->
    expect(node.id).toBe 123

  it 'should inherit attributes from response data-attribute', ->
    expect(node.attrs.name).toBe 'John Doe'
