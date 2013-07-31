'use strict';

angular.module('neo4jApp.directives')
  .directive('outputRaw', [() ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      unbind = scope.$watch attrs.outputRaw, (val) ->
        return unless val
        val = JSON.stringify(val) unless angular.isString(val)
        element.text(val)
        unbind()
  ])
