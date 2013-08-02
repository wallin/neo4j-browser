'use strict'

describe 'Service: Folder', () ->

  # load the service's module
  beforeEach module 'neo4jApp.services'

  # instantiate service
  Folder = {}
  beforeEach inject (_Folder_) ->
    Folder = _Folder_

  it 'should be expanded by default', ->
    folder = new Folder()
    expect(folder.expanded).toBeTruthy()

  it 'should get an id even if not specified', ->
    folder = new Folder()
    expect(folder.id).toBeTruthy()
