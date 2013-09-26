'use strict';
angular.module('neo4jApp.directives')
  .directive('neoGraph', [
    ()->
      require: 'ngController'
      restrict: 'A'
      link: (scope, elm, attr, ngCtrl) ->
        unbind = scope.$watch attr.graphData, (graph) ->
          return unless graph
          ngCtrl.render(graph)
          unbind()
  ])
