'use strict';

angular.module('neo4jApp.filters')
  .filter 'commandError', [() ->
    (input) ->
      if input?.charAt(0) is ':'
        "Not-a-command"
      else
        "Unrecognized"
  ]
