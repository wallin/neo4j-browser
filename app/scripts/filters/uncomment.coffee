'use strict';

angular.module('neo4jApp.filters')
  .filter 'uncomment', () ->
    (input) ->
      return '' unless input?
      (row for row in input.split('\n') when row.indexOf('//') isnt 0).join(' ')
