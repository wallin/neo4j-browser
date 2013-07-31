'use strict';

angular.module('neo4jApp.services')
  .factory 'Document', [
    'Persistable'
    (Persistable) ->
      class Document extends Persistable
        @storageKey = 'documents'

        constructor: (data) ->
          super data
          @name ?= 'Unnamed document'
          @folder ?= no

        toJSON: ->
          {@id, @name, @folder, @content}

      Document
  ]
