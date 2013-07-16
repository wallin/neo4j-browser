'use strict';

#
# A generic collection data type with ID awareness
#

angular.module('neo4jApp.services')
  .factory 'Collection', [
    () ->
      class Collection
        constructor: (items) ->
          @_reset()
          @add(items) if items?

        #
        # Instance methods
        #
        add: (items, opts = {}) ->
          return unless items?
          items = if angular.isArray(items) then items else [items]
          itemsToAdd = []
          for i in items
            continue if not i? or @get(i)
            @_byId[if i.id? then i.id else i] = i
            itemsToAdd.push(i)

          if itemsToAdd.length
            if angular.isNumber(opts.at)
              [].splice.apply(@items, [opts.at, 0].concat(itemsToAdd));
            else
              [].push.apply(@items, itemsToAdd)
            @length += itemsToAdd.length
          @

        all: ->
          @items

        first: ->
          @items.sort((a, b) -> a.id-b.id)[0]

        get: (id) ->
          id = id.id if angular.isObject(id)
          return undefined unless id?

          @_byId[id]

        indexOf: (item) ->
          @items.indexOf item

        last: ->
          @items.sort((a, b) -> b.id-a.id)[0]

        remove: (items) ->
          itemsToRemove = if angular.isArray(items) then items else [items]
          for item in itemsToRemove
            item = @get(item);
            continue unless item
            delete @_byId[item.id];
            index = @items.indexOf(item);
            @items.splice(index, 1);
            @length--
          items

        reset: (items) ->
          @_reset()
          @add(items)

        pluck: (attr) ->
          return undefined unless angular.isString(attr)
          i[attr] for i in @items

        where: (attrs) ->
          rv = []
          return rv unless angular.isObject(attrs)

          numAttrs = Object.keys(attrs).length

          for item in @items
            matches = 0
            for key, val of attrs
              matches++ if item[key] is val

            rv.push item if numAttrs is matches

          rv

        #
        # Internal methods
        #

        _reset: ->
          @items = []
          @_byId = {}
          @length = 0

      Collection
]
