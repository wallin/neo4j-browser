'use strict';

angular.module('neo4jApp.directives')
  .directive 'href', ['Editor', (Editor) ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      element.attr("target", "_blank") if attrs.href.match /^http/
  ]
