'use strict';

angular.module('neo4jApp.services')
  .factory 'Node', [ ->
    class Node
      constructor: (@$raw = {}) ->
        @id = @$raw.id
        @labels = @$raw.labels or []
        @propertyMap = @$raw.properties or {}
        @propertyList = for key,value of @propertyMap
            { key: key, value: value }

      toJSON: ->
        @propertyMap

    Node
  ]
