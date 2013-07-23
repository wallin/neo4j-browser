'use strict';

angular.module('neo4jApp.services')
  .factory 'GraphExplorer', ['$q', 'Cypher', ($q, Cypher) ->
    return  {
      exploreNeighbours: (ids) ->
        q = $q.defer()
        ids = [ids] unless angular.isArray(ids)
        if ids.length is 0
          q.resolve()
          return q.promise

        Cypher
        .send("START a = node(#{ids.join(',')}) MATCH a -[r]- b RETURN r, b;")
        .then(q.resolve)
        q.promise

      internalRelationships: (ids) ->
        q = $q.defer()
        ids = [ids] unless angular.isArray(ids)
        if ids.length is 0
          q.resolve()
          return q.promise
        Cypher
        .send("""
          START a = node(#{ids.join(',')}), b = node(#{ids.join(',')})
          MATCH a -[r]-> b RETURN r;"""
        )
        .then(q.resolve)
        q.promise
    }
  ]
