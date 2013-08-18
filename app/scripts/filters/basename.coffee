'use strict';

angular.module('neo4jApp.filters')
  .filter 'basename', () ->
    (input) ->
      return '' unless input?
      input.replace(/\\/g, "/").replace /.*\//, ""