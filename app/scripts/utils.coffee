'use strict';

angular.module('neo4jApp.utils', [])
  .service('Utils', ['$timeout', ($timeout)->
    debounce: (func, wait, immediate) ->
      result = undefined
      timeout = null
      ->
        context = @
        args = arguments
        later = ->
          timeout = null
          result = func.apply(context, args) unless immediate

        callNow = immediate and not timeout
        $timeout.cancel(timeout)
        timeout = $timeout(later, wait)
        result = func.apply(context, args) if callNow
        result
    stripComments: (input) ->
      rows = input.split("\n")
      rv = []
      rv.push row for row in rows when row.indexOf('//') isnt 0
      rv.join("\n")
  ])
