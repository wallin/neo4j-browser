'use strict'

angular.module('neo4jApp.controllers')
  .controller 'CypherResultCtrl', ['$scope', ($scope) ->

    $scope.$watch 'frame.response', ->
      $scope.showGraph = $scope.frame.response?.table.nodes.length
      $scope.tab = if $scope.showGraph then 'graph' else 'table'

    $scope.setActive = (tab) -> $scope.tab = tab
    $scope.isActive = (tab) -> tab is $scope.tab

    $scope.resultDetails = (frame) ->
      if frame?.response
        stats = frame.response.table.stats
        "
          Constraints added: #{stats.constraints_added}<br>
          Constraints removed: #{stats.constraints_removed}<br>
          Indexes added: #{stats.indexes_added}<br>
          Indexes removed: #{stats.indexes_removed}<br>
          Labels added: #{stats.labels_added}<br>
          Labels removed: #{stats.labels_removed}<br>
          Nodes created: #{stats.nodes_created}<br>
          Nodes deleted: #{stats.nodes_deleted}<br>
          Properties set: #{stats.properties_set}<br>
          Relationship deleted: #{stats.relationship_deleted}<br>
          Relationships created: #{stats.relationships_created}<br>
          "
  ]
