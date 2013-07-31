'use strict';

angular.module('neo4jApp.directives')
  .directive('exportable', [() ->
    restrict: 'A'
    controller: [
      '$scope',
      '$window',
      'CSV',
      ($scope, $window, CSV) ->

        saveAs = (data, filename, mime = "text/csv;charset=utf-8") ->
          blob = new Blob([data], {type: mime});
          $window.saveAs(blob, filename);

        $scope.exportJSON = (data) ->
          return unless data
          saveAs(JSON.stringify(data), 'result.json')

        $scope.exportCSV = (data) ->
          return unless data
          csv = new CSV.Serializer()
          csv.columns(data.columns())
          for row in data.rows()
            csv.append(row)

          saveAs(csv.output(), 'export.csv')

    ]
  ])
