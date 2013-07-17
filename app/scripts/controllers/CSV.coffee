'use strict'
angular.module('neo4jApp.controllers')
  .controller('CSVCtrl', [
    '$scope'
    '$window'
    'CSV'
    ($scope, $window, CSV) ->
      $scope.export = (result) ->
        return unless result
        csv = new CSV.Serializer()

        csv.columns(result.columns())
        for row in result.rows()
          csv.append(row)

        blob = new Blob([csv.output()], {type: "text/csv;charset=utf-8"});
        $window.saveAs(blob, "export.csv");
  ])
