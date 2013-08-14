'use strict';

angular.module('neo4jApp.services')
  .factory 'Relationship', [ ->
    class Relationship
      constructor: (@$raw = {}) ->
        @attrs = @$raw.data or {}
        @id = @$raw.id
        @start = @$raw.startNode
        @end = @$raw.endNode
        @type = @$raw.type

      toJSON: ->
        @attrs

    Relationship
  ]
