'use strict';

angular.module('neo4jApp.filters')
  .filter 'uncomment', () ->
    (input) ->
      return '' unless input?
      (row for row in input.split('\n') when not row.beginsWith('//')).join(' ')
