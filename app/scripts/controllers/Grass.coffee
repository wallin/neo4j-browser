'use strict'

angular.module('neo4jApp')
  .controller 'GrassCtrl', [
    '$scope'
    '$window'
    'GraphStyle'
    ($scope, $window, GraphStyle) ->
      serialize = (rules) ->
        $scope.code = GraphStyle.toString()

      $scope.rules = GraphStyle.rules

      $scope.$watch 'rules', serialize, true

      $scope.export = ->
        blob = new Blob([$scope.code], {type: "text/css;charset=utf-8"});
        $window.saveAs(blob, "graphstyle.grass");

      $scope.import = (content) ->
        GraphStyle.import(content)

      serialize(true)
  ]
