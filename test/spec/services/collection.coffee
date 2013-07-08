'use strict'

describe 'Service: Collection', () ->

  # load the service's module
  beforeEach module 'neo4jApp.services'

  # instantiate service
  Collection = {}
  beforeEach inject (_Collection_) ->
    Collection = new _Collection_

  describe 'add:', ->
    it 'should be able to add single item', () ->
      Collection.add(1)
      expect(Collection.all().length).toBe 1

    it 'should be able to add an array of items', () ->
      Collection.add([1, 2, 3])
      expect(Collection.all().length).toBe 3

    it "should return the item being added", ->
      item = {id: 1}
      expect(Collection.add(item)).toBe item

  describe 'get:', ->
    beforeEach ->
      Collection.add({id: 1, name: 'shoe'}, {id: 2, name: 'tie'})

    it 'should be able to retrieve item by id', ->
      item = Collection.get(1)
      expect(item.name).toBe 'shoe'
