'use strict'

describe 'Service: Frame', () ->
  [backend, view] = [null, null]

  # load the service's module
  beforeEach module 'neo4jApp.services'

  # instantiate service
  Frame = {}
  beforeEach inject (_Frame_) ->
    Frame = _Frame_

