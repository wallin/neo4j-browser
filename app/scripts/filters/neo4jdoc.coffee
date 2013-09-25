'use strict';

angular.module('neo4jApp.filters')
  .filter 'neo4jdoc', () ->
    (input) ->
      return '' unless input?
      if input.indexOf('SNAPSHOT') > 0
        'snapshot'
      else
        input
