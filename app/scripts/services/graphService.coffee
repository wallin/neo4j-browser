'use strict';

angular.module('neo4jApp.services')
  .factory 'graphService', [
    '$q'
    'Cypher'
    'GraphModel'
    ($q, Cypher, GraphModel)->
      class GraphService
        constructor : () ->
          @nodes = []
          @_clear()

        byCypher : (query) ->
          return unless query
          @_clear()
          @isLoading = true

          q = $q.defer()
          Cypher.send(query).then(
            (result) =>
              @_clear()
              q.resolve(new GraphModel(result))
          ,
            (error) =>
              @_clear()
              @error = error
              q.reject(@)
          )
          return q.promise

        _clear : ->
          @error   = null
          @isLoading = false

      new GraphService
  ]

