'use strict'

describe 'Service: d3Renderer', () ->

  # load the service's module
  beforeEach module 'neo4jApp'

  # instantiate service
  d3Renderer = {}
  beforeEach inject (_d3Renderer_) ->
    d3Renderer = _d3Renderer_

  it 'should do something', () ->
    expect(!!d3Renderer).toBe true;
