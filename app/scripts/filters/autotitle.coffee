'use strict';

angular.module('neo4jApp.filters')
  .filter 'autotitle', () ->
    (input) ->
      return '' unless input?
      firstRow = input.split('\n')[0]
      if firstRow.beginsWith('//')
        firstRow[2..-1]
      else
        input
