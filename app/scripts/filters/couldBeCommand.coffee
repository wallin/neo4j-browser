'use strict';

angular.module('neo4jApp.filters')
  .filter 'couldBeCommand', () ->
    (input) ->
      return false unless input?
      return true if input.charAt(0) is ':'
      return false