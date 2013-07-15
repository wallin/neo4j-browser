'use strict'

describe 'Service: viewService', () ->
  [backend, view] = [null, null]

  # load the service's module
  beforeEach module 'neo4jApp.services'

  beforeEach inject ($httpBackend) ->
    backend = $httpBackend

  afterEach ->
    backend.verifyNoOutstandingRequest()

  # instantiate service
  viewService = {}
  beforeEach inject (_viewService_) ->
    viewService = _viewService_

  describe 'create: ', ->
    it 'should return the created view', ->
      view = viewService.create('//Query')
      expect(view.input).toBe '//Query'

    it 'should add a the created view to history', ->
      len = viewService.history.all().length
      view = viewService.create('//Query')
      expect(viewService.history.all().length).toBe len+1
      expect(viewService.history.get(view.id)).toBe view

  describe 'View', ->
    beforeEach -> view = viewService.create('start n=node(*) return n')

    it 'should send a Cypher request when executed', ->
      backend.expectPOST(/db\/data\/cypher/).respond()
      view.exec()
      backend.flush()