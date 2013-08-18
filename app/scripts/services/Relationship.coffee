'use strict';

angular.module('neo4jApp.services')
  .factory 'Relationship', [ ->
    class Relationship
      constructor: (@$raw = {}) ->
        @id = @$raw.id
        @start = @$raw.startNode
        @end = @$raw.endNode
        @type = @$raw.type
        @propertyMap = @$raw.properties or {}
        @propertyList = for own key,value of @propertyMap
          { key: key, value: value }

      toJSON: ->
        @propertyMap

    Relationship
  ]
