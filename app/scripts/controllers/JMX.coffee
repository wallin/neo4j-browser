'use strict'

angular.module('neo4jApp.controllers')
  .controller 'JMXCtrl', [
    '$scope'
    'Server'
    ($scope, Server) ->

      parseName = (str) ->
        str.split('=').pop()

      parseSection = (str) ->
        str.split('/')[0]

      Server.jmx(["*:*"]).success((response) ->
        sections = {}
        for r in response
          r.name = parseName(r.name)
          section = parseSection(r.url)
          sections[section] ?= {}
          sections[section][r.name] = r
        $scope.sections = sections
        $scope.currentItem = sections[section][r.name]
      )

      $scope.selectItem = (section, name) ->
        $scope.currentItem = $scope.sections[section][name]

      # Filters
      $scope.simpleValues = (item) -> !$scope.objectValues(item)

      $scope.objectValues = (item) -> angular.isObject(item.value)
  ]
