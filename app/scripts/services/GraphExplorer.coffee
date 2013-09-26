'use strict';

angular.module('neo4jApp.services')
  .factory 'GraphExplorer', ['$q', 'Cypher', 'Settings', ($q, Cypher, Settings) ->
    return  {
      exploreNeighboursWithInternalRelationships: (node, graph) ->
        q = $q.defer()
        @exploreNeighbours(node).then (neighboursResult) =>
          if neighboursResult.nodes.length > Settings.maxNeighbours
            return q.reject('Sorry! Too many neighbours')
          graph.merge(neighboursResult)
          @internalRelationships(graph.nodes()).then (result) =>
            graph.addRelationships(result.relationships)
            q.resolve()
        q.promise

      exploreNeighbours: (node) ->
        q = $q.defer()
        Cypher.transaction()
        .commit("START a = node(#{node.id}) MATCH (a)-[r]-() RETURN r;")
        .then(q.resolve)
        q.promise

      internalRelationships: (nodes) ->
        q = $q.defer()
        if nodes.length is 0
          q.resolve()
          return q.promise
        ids = nodes.map((node) -> node.id)
        Cypher.transaction()
        .commit("""
          START a = node(#{ids.join(',')}), b = node(#{ids.join(',')})
          MATCH a -[r]-> b RETURN r;"""
        )
        .then(q.resolve)
        q.promise
    }
  ]
