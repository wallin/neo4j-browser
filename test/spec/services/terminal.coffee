'use strict'

describe 'Service: terminal', () ->

  # load the service's module
  beforeEach module 'neo4jApp'

  # instantiate service
  terminal = {}
  beforeEach inject (_terminal_) ->
    terminal = _terminal_

  it 'should do something', () ->
    expect(!!terminal).toBe true;
