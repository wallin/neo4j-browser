'use strict';
angular.module('neo4jApp.directives')
  .directive('neoGraph', [
    'GraphModel'
    (GraphModel)->
      replace: yes
      require: ['ngModel', 'ngController']
      restrict: 'E'
      template: """
      <svg style="pointer-events:fill;" viewbox="0 0 1024 768" preserveAspectRatio="xMidyMid">
        <defs></defs>
      </svg>
      """
      link: (scope, elm, attr, ctrls) ->
        [ngModel, ngCtrl] = ctrls
        return unless ngCtrl and ngModel
        ngModel.$render = ->
          result = ngModel.$modelValue
          return unless result
          # TODO: show something if result is too large
          return if result.isTooLarge
          graph = new GraphModel(result)
          graph.expandAll().then(->ngCtrl.render(graph))
  ])
