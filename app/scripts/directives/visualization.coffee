'use strict';

angular.module('neo4jApp.directives')
  .directive('visualization', [
    'graphService'
    (graphService) ->
      restrict: 'EA'
      template: """
      <table class="visualization">
        <thead>
          <tr>
            <th ng-repeat='column in columns'> {{ column }}</th>
          </tr>
        </thead>
        <tbody>
          <tr ng-repeat='row in rows'>
            <td ng-repeat='cell in row'> {{ cell }} </td>
          </tr>
        </tbody>
      </table>
      """
      link: (scope, elm, attr) ->
        scope.$watch(attr.query, (val, oldVal)->
          return unless val
          graphService.executeQuery(scope.$eval(attr.query)).then(
            (g) ->
              scope.rows = g.rows
              scope.columns = g.columns
            ,
            ->
              scope.rows = []
              scope.columns = []
          )
        , true)
  ])
