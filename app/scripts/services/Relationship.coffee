'use strict';

angular.module('neo4jApp.services')
  .factory 'Relationship', [ ->
    class Relationship
      constructor: (@id, @source, @target, @type, properties) ->
        @propertyMap = properties
        @propertyList = for own key,value of @propertyMap
          { key: key, value: value }

      toJSON: ->
        @propertyMap

      isNode: false
      isRelationship: true

    Relationship
  ]
