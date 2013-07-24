'use strict';

angular.module('neo4jApp.services')
  .factory 'Relationship', [() ->
    parseId = (resource = "") ->
      id = resource.substr(resource.lastIndexOf("/")+1)
      return parseInt(id, 10)

    class Relationship
      constructor: (@$raw = {}) ->
        @attrs = @$raw.data or {}
        @id = parseId(@$raw.self)
        @start = parseId(@$raw.start)
        @end = parseId(@$raw.end)
        @type = @$raw.type

      toJSON: ->
        @$raw.data

    Relationship
  ]
