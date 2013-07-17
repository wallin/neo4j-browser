'use strict';
angular.module('neo4jApp.directives')
  .directive('neoTable', [
    ->
      replace: yes
      restrict: 'E'
      require: 'ngModel'
      templateUrl: 'views/neo-table.html'
      link: (scope, elm, attr, ngModel) ->
        predicate = null
        scope.reverse = no
        ngModel.$render = (result) ->
          result = ngModel.$modelValue
          return unless result
          # TODO: show something if result is too large
          return if result.isTooLarge
          scope.rows = result.rows()
          scope.columns = result.columns()

        scope.orderBy = (col) ->
          if col is predicate
            scope.reverse = !scope.reverse
          else
            scope.reverse = no
          predicate = col

        scope.sortOrder = (item) ->
          if predicate? then item[predicate] else null

  ])
