'use strict'

describe 'Service: Document', () ->

  # load the service's module
  beforeEach module 'neo4jApp.services'

  # instantiate service
  Document = {}
  beforeEach inject (_Document_) ->
    Document = _Document_
