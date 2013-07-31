'use strict';
angular.module('neo4jApp.directives')
  .directive('neoGraph', [
    'GraphModel'
    (GraphModel)->
      require: 'ngController'
      restrict: 'A'
      link: (scope, elm, attr, ngCtrl) ->
        unbind = scope.$watch attr.graphData, (result) ->
          return unless result
          # TODO: show something if result is too large
          return if result.isTooLarge
          graph = new GraphModel(result)
          ngCtrl.render(graph)
          unbind()
  ])
