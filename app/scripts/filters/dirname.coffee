'use strict';

angular.module('neo4jApp.filters')
  .filter 'dirname', () ->
    (input) ->
      return '' unless input?
      input.replace(/\\/g, "/").replace(/\/[^\/]*$/, "")