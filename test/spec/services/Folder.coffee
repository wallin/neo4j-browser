'use strict'

describe 'Service: Folder', () ->

  # load the service's module
  beforeEach module 'neo4jApp.services'

  # instantiate service
  Folder = {}
  beforeEach inject (_Folder_) ->
    Folder = _Folder_

  it 'should do something', () ->
    expect(!!Folder).toBe true;