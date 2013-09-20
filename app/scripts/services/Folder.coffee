'use strict';

angular.module('neo4jApp.services')
  .factory 'Folder', [
    'Collection'
    'Document'
    'Persistable'
    (Collection, Document, Persistable) ->
      class Folder extends Persistable
        @storageKey = 'folders'

        constructor: (data) ->
          @expanded = yes
          super data
          @name ?= 'Unnamed folder'

        toJSON: ->
          {@id, @name, @expanded}

      class Folders extends Collection
        create: (data) ->
          folder = new Folder(data)
          @add(folder)
          @save()
          folder
        expand: (folder) ->
          folder.expanded = !folder.expanded
          @save()
        klass: Folder
        new: (args) -> new Folder(args)
        remove: (folder) ->
          super(folder)
          documentsToRemove = Document.where(folder: folder.id)
          Document.remove(documentsToRemove)
          @save()

      new Folders(null, Folder).fetch()
  ]
