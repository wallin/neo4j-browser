'use strict'

describe 'Service: Editor', () ->

  # load the service's module
  beforeEach module 'neo4jApp.services'

  # instantiate service
  Editor = {}
  beforeEach inject (_Editor_) ->
    Editor = _Editor_
