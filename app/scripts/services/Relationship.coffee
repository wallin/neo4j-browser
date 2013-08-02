'use strict';

angular.module('neo4jApp.services')
  .factory 'Relationship', ['Utils', (Utils) ->
    class Relationship
      constructor: (@$raw = {}) ->
        @attrs = @$raw.data or {}
        @id = Utils.parseId(@$raw.self)
        @start = Utils.parseId(@$raw.start)
        @end = Utils.parseId(@$raw.end)
        @type = @$raw.type

      toJSON: ->
        @$raw.data

    Relationship
  ]
