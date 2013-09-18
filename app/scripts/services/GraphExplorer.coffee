'use strict';

angular.module('neo4jApp.services')
  .factory 'GraphExplorer', ['$q', 'Cypher', ($q, Cypher) ->
    return  {
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
