'use strict'

describe 'Service: terminalService', () ->

  # load the service's module
  beforeEach module 'neo4jApp'

  # instantiate service
  terminal = {}
  beforeEach inject (_terminalService_) ->
    terminal = _terminalService_

  it 'should do something', () ->
    expect(!!terminal).toBe true;
