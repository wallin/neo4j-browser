'use strict';

angular.module('neo4jApp.directives')
  .directive('visualization', [
    'graphService'
    'd3Renderer'
    (graphService, d3Renderer) ->
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
      <svg d3 d3-data="result" d3-renderer="renderer">
      </svg>
      """
      link: (scope, elm, attr) ->
        scope.renderer = d3Renderer.dynamic
        scope.$watch(attr.query, (val, oldVal)->
          return unless val
          graphService.executeQuery(scope.$eval(attr.query)).then(
            (g) ->
              #scope.rows = g.rows
              #scope.columns = g.columns
              scope.result =
                nodes: g.nodes
                links: []
            ,
            ->
              scope.rows = []
              scope.columns = []
              scope.result = null
          )
        , true)
  ])
