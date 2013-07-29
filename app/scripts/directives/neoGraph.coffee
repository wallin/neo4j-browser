'use strict';
angular.module('neo4jApp.directives')
  .directive('neoGraph', [
    'GraphModel'
    (GraphModel)->
      require: ['ngModel', 'ngController']
      restrict: 'A'
      link: (scope, elm, attr, ctrls) ->
        [ngModel, ngCtrl] = ctrls
        return unless ngCtrl and ngModel
        ngModel.$render = ->
          result = ngModel.$modelValue
          return unless result
          # TODO: show something if result is too large
          return if result.isTooLarge
          graph = new GraphModel(result)
          ngCtrl.render(graph)
  ])
