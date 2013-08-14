'use strict'

describe 'Service: Relationship', () ->

  relationshipData = (id, type, attrs) ->
    {
      id: id
      type: type
      properties: attrs
      startNode: "1234"
      endNode: "4321"
    }

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
