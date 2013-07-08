'use strict';

#
# A generic collection data type with ID awareness
#

angular.module('neo4jApp.services')
  .factory 'Collection', [
    () ->
      class Collection
        constructor: (items) ->
          @items = []
          @_byId = {}
          @add(items) if items?

        add: (items) ->
          itemsToAdd = if angular.isArray(items) then items else [items]
          for i in itemsToAdd
            if i.id?
              if not @_byId[i.id]
                @_byId[i.id] = i
                @items.push i
            else
              @items.push i
          return items

        all: ->
          @items

        get: (id) ->
          id = parseInt(id, 10)
          return null unless id?
          @_byId[id]

        reset: (items) ->
          @_reset()
          @add(items)

        _reset: ->
          @items = []
          @_byId = {}

      Collection
]
