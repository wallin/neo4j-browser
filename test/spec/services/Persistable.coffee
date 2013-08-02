'use strict'

describe 'Service: Persistable', () ->

  # load the service's module
  beforeEach module 'neo4jApp.services'

  # instantiate service
  Persistable = {}
  beforeEach inject (_Persistable_) ->
    Persistable = _Persistable_

  it 'should generate an id when not specified', ->
    doc = new Persistable()
    expect(doc.id).toBeTruthy()

  it 'should set the provided id', ->
    doc = new Persistable(id: 1)
    expect(doc.id).toBe 1
