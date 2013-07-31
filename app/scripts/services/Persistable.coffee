'use strict';

angular.module('neo4jApp.services')
  .factory 'Persistable', [
    'localStorageService'
    (localStorageService) ->
      class Persistable
        # Set all properties and generate an ID if missing
        constructor: (data = {})->
          if angular.isObject(data)
            angular.extend(@, data)
          @id ?= UUID.genV1().toString()

        #
        # Class methods
        #

        # Retrieve all items
        @fetch: ->
          persisted = try
            (localStorageService.get(@storageKey))
          catch
            null

          return [] unless angular.isArray(persisted)
          new @(p) for p in persisted

        # Save all items
        @save: (data) ->
          localStorageService.add(@storageKey, JSON.stringify(data))

      Persistable
  ]
