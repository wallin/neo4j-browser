'use strict';

angular.module('neo4jApp.services')
  .factory 'Node', [ ->
    class Node
      constructor: (@id, @labels, properties) ->
        @propertyMap = properties
        @propertyList = for own key,value of properties
            { key: key, value: value }

      toJSON: ->
        @propertyMap

      isNode: true
      isRelationship: false

    Node
  ]
