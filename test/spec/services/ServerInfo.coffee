'use strict'

describe 'Service: ServerInfo', () ->

  # load the service's module
  beforeEach module 'neo4jApp.services'

  # instantiate service
  ServerInfo = {}
  beforeEach inject (_ServerInfo_) ->
    ServerInfo = _ServerInfo_

  it 'should do something', () ->
    expect(!!ServerInfo).toBe true;
