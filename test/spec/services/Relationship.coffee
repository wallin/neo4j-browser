'use strict'

describe 'Service: Relationship', () ->

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

  # load the service's module
  beforeEach module 'neo4jApp.services'

  # instantiate service
  relationship = {}
  beforeEach inject (_Relationship_) ->
    relationship = new _Relationship_(relationshipData(123, "ROOT"))

  it 'should set id-attribute from response', ->
    expect(relationship.id).toBe 123

  it 'should set type from response data', ->
    expect(relationship.type).toBe 'ROOT'
