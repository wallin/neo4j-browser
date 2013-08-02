'use strict'

describe 'Service: Document', () ->

  # load the service's module
  beforeEach module 'neo4jApp.services'

  # instantiate service
  Document = {}
  beforeEach inject (_Document_) ->
    Document = _Document_

  it 'should not belong to any folder when created with default options', ->
    doc = new Document()
    expect(doc.folder).toBeFalsy()

  it 'should set the specified folder when created', ->
    doc = new Document(folder: 'examples')
    expect(doc.folder).toBe 'examples'

  it 'should get an id even if not specified', ->
    doc = new Document()
    expect(doc.id).toBeTruthy()
