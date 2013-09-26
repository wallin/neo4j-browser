'use strict'

angular.module('neo4jApp.controllers')
  .controller 'CypherResultCtrl', ['$scope', ($scope) ->

    $scope.$watch 'frame.response', ->
      $scope.showGraph = $scope.frame.response?.table.nodes.length
      $scope.tab = if $scope.showGraph then 'graph' else 'table'

    $scope.setActive = (tab) -> $scope.tab = tab
    $scope.isActive = (tab) -> tab is $scope.tab

    $scope.resultStatistics = (frame) ->
      if frame?.response
        stats = frame.response.table.stats
        fields = [
          {plural: 'constraints', singular: 'constraint', verb: 'added', field: 'constraints_added' }
          {plural: 'constraints', singular: 'constraint', verb: 'removed', field: 'constraints_removed' }
          {plural: 'indexes', singular: 'index', verb: 'added', field: 'indexes_added' }
          {plural: 'indexes', singular: 'index', verb: 'removed', field: 'indexes_removed' }
          {plural: 'labels', singular: 'label', verb: 'added', field: 'labels_added' }
          {plural: 'labels', singular: 'label', verb: 'removed', field: 'labels_removed' }
          {plural: 'nodes', singular: 'node', verb: 'created', field: 'nodes_created' }
          {plural: 'nodes', singular: 'node', verb: 'deleted', field: 'nodes_deleted' }
          {plural: 'properties', singular: 'property', verb: 'set', field: 'properties_set' }
          {plural: 'relationships', singular: 'relationship', verb: 'deleted', field: 'relationship_deleted' }
          {plural: 'relationships', singular: 'relationship', verb: 'created', field: 'relationships_created' }
        ]
        nonZeroFields = fields.filter((field) -> stats[field.field] > 0)
        messages = ("#{field.verb} #{stats[field.field]} #{if stats[field.field] is 1 then field.singular else field.plural}" for field in nonZeroFields)
        messages.push "returned #{frame.response.table.size} #{if frame.response.table.size is 1 then 'row' else 'rows'}"
        joinedMessages = messages.join(', ')
        "#{joinedMessages.substring(0, 1).toUpperCase()}#{joinedMessages.substring(1)}"
  ]
