'use strict';

angular.module('neo4jApp')
  .filter 'autotitle', () ->
    (input) ->
      return '' unless input?
      firstRow = input.split('\n')[0]
      if firstRow.indexOf('//') is 0
        firstRow[2..-1]
      else
        input
