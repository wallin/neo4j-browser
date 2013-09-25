'use strict';

angular.module('neo4jApp.services')
  .factory 'Document', [
    'Collection'
    'Persistable'
    (Collection, Persistable) ->
      class Document extends Persistable
        @storageKey = 'documents'

        constructor: (data) ->
          super data
          @name ?= 'Unnamed document'
          @folder ?= no

        toJSON: ->
          {@id, @name, @folder, @content}

      class Documents extends Collection
        create: (data) ->
          d = new Document(data)
          @add(d)
          @save()
          d
        klass: Document
        new: (args) -> new Document(args)
        remove: (doc) ->
          super
          @save()
          # clear the document data
          doc[k] = null for own k, v of doc

      new Documents(null, Document).fetch()
  ]
