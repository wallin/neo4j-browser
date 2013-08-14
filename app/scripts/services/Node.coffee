'use strict';

angular.module('neo4jApp.services')
  .factory 'Node', [ ->
    class Node
      constructor: (@$raw = {}) ->
        @id = @$raw.id
        @labels = @$raw.labels or []
        @attrs = @$raw.properties or {}
        angular.extend(@, @attrs)

      toJSON: ->
        @attrs

    Node
  ]
