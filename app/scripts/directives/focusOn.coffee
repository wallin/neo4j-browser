'use strict';

angular.module('neo4jApp.directives')
  .directive('focusOn', ['$timeout', ($timeout) ->
    (scope, element, attrs) ->
      scope.$watch attrs.focusOn, (val) ->
        $timeout(->
          element[0].focus()
        , 0, no) if val
  ])
