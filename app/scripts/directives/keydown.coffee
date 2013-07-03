'use strict';

angular.module('neo4jApp.directives')
  .directive('keydown', [
    '$parse',
    ($parse) ->
      restrict: 'A',
      link: (scope, elem, attr, ctrl) ->
        elem.bind('keydown', (e)->
          exp = $parse(attr.keydown)
          scope.$apply(->exp(scope, {'$event': e}))
        )
  ])
