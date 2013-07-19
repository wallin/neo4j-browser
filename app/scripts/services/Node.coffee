'use strict';

angular.module('neo4jApp.services')
  .factory 'Node', [() ->

    parseId = (resource = "") ->
      id = resource.substr(resource.lastIndexOf("/")+1)
      return parseInt(id, 10)

    class Node
      constructor: (@$raw = {}) ->
        angular.extend @, @$raw.data
        @id = parseId(@$raw.self)

      toJSON: ->
        @$raw.data

    Node
  ]
