'use strict';

angular.module('neo4jApp.directives')
  .controller('visualizationCtrl', [
    '$scope'
    '$window'
    'CSV'
    ($scope, $window, CSV) ->
      currentQuery = null
      $scope.export = ->
        return unless $scope.result
        csv = new CSV.Serializer()

        csv.columns($scope.result.columns())
        for row in $scope.result.rows()
          csv.append(row)

        blob = new Blob([csv.output()], {type: "text/csv;charset=utf-8"});
        $window.saveAs(blob, "export.csv");
  ])

angular.module('neo4jApp.directives')
  .directive('visualization', [
    ->
      controller: 'visualizationCtrl'
      restrict: 'EA'
      scope: "@"
      link: (scope, elm, attr, ctrl) ->
        currentQuery = null
        scope.$watch(attr.result, (val, oldVal)->
          return if not val
          scope.result = val
        )
  ])
