'use strict'

angular.module('neo4jApp.controllers')
  .controller 'InspectorCtrl', [
    '$scope',
    'GraphStyle'
    ($scope, GraphStyle) ->
      console.log 'hej'
  ]
