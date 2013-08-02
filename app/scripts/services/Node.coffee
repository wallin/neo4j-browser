'use strict';

angular.module('neo4jApp.services')
  .factory 'Node', ['Utils', (Utils) ->
    class Node
      constructor: (@$raw = {}) ->
        @attrs = @$raw.data or {}
        angular.extend(@, @attrs)
        @id = Utils.parseId(@$raw.self)
        @labels = []

      toJSON: ->
        @$raw.data

    Node
  ]
