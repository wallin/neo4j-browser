'use strict';

angular.module('neo4jApp.services')
  .factory 'Folder', [
    'Persistable'
    (Persistable) ->
      class Folder extends Persistable
        @storageKey = 'folders'

        constructor: (data) ->
          @expanded = yes
          super data
          @name ?= 'Unnamed folder'

        toJSON: ->
          {@id, @name, @expanded}

      Folder
  ]
