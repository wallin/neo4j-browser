angular.module('neo4jApp.services')
.run([
  'Collection',
  'Cypher',
  (Collection, Cypher) ->
    # Modify result by appending labels to nodes
    nodeLabels = (result, q) ->
      ids = (n.id for n in result.nodes)
      return q.resolve() if ids.length is 0

      Cypher.send("""
          START n=node(#{ids.join(',')})
          RETURN id(n), labels(n)"""
      , no).then((labels)->
        nodes = new Collection(result.nodes)
        for row in labels.rows()
          nodes.get(row[0])?.labels = row[1]
        q.resolve()
      , q.reject)

    Cypher.filters.push nodeLabels
])
