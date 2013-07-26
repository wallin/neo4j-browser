'use strict'

angular.module('neo4jApp')
  .controller 'GrassCtrl', [
    '$scope'
    '$window'
    'GraphStyle'
    ($scope, $window, graphStyle) ->
      $scope.code = graphStyle.toString()

      $scope.export = ->
        blob = new Blob([$scope.code], {type: "text/css;charset=utf-8"});
        $window.saveAs(blob, "graphstyle.grass");

      $scope.import = (content) ->
        # TODO: import

  ]
