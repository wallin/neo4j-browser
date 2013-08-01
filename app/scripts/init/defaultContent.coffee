angular.module('neo4jApp')
.run([
  '$rootScope'
  'Document'
  'Folder'
  ($rootScope, Document, Folder) ->
    node_scripts = [
      {
        folder: 'nodes'
        content: """
// Count nodes
MATCH (n{{':'+selected_label}})
RETURN count(n)
        """
      }
      {
        folder: 'nodes'
        content: """
// Create index
CREATE INDEX ON :{{selected-label}}(propertyName)
        """
      }
      {
        folder: 'nodes'
        content: """
// Create indexed node
CREATE (n{{':'+selected_label}} { {{indexed_property}}:"{property_value}" }) RETURN n
        """
      }
      {
        folder: 'nodes'
        content: """
// Create node
CREATE (n{{':'+selected_label}}) RETURN n
        """
      }
      {
        folder: 'nodes'
        content: """
// Delete a node
START n=node(*) MATCH (n{{':'+selected_label}})-[r?]-()
WHERE {{indexed_property}} = "{expected_value}"
DELETE n,r
        """
      }
      {
        folder: 'nodes'
        content: """
// Drop index
DROP INDEX ON :{{selected-label}}(propertyName)
        """
      }
      {
        folder: 'nodes'
        content: """
// Find a node
MATCH (n{{':'+selected_label}})
WHERE n.{{indexed_property}} = "{expected_value}" RETURN n
        """
      }
      {
        folder: 'nodes'
        content: """
// Get all nodes
MATCH (n{{':'+selected_label}})
RETURN n LIMIT 100
        """
      }
    ]

    relationship_scripts = [
      {
        folder: 'relationships'
        content: """
// Isolate node
MATCH (a)-[r{{':'+selected_type}}]-()
WHERE a.{property} = "{expected_a_value}"
DELETE r
        """
      }
      {
        folder: 'relationships'
        content: """
// Relate nodes
MATCH (a),(b)
WHERE a.{property} = "{expected_a_value}"
AND b.{property} = "{expected_b_value}"
CREATE (a)-[r{{':'+selected_type}}]->(b)
RETURN a,r,b
        """
      }
      {
        folder: 'relationships'
        content: """
// Shortest path
MATCH p = shortestPath( (a)-[{{':'+selected_type}}*..4]->(b) )
WHERE a.name={a_name} AND b.name={b_name}
RETURN p
        """
      }
      {
        folder: 'relationships'
        content: """
// Whats related
MATCH (a)-[r{{':'+selected_type}}]-(b)
RETURN DISTINCT head(labels(a)), type(r), head(labels(b))
        """
      }
    ]

    system_scripts = [
      {
        folder: 'system'
        content: """
// Is master
GET /db/manage/server/ha/master
        """
      }
      {
        folder: 'system'
        content: """
// Is slave
GET /db/manage/server/ha/slave
        """
      }
      {
        folder: 'system'
        content: """
// System info
GET /db/manage/server/jmx/domain/org.neo4j
        """
      }
    ]

    folders = [
      {
        id: "nodes"
        name: "Nodes"
        expanded: no
      }
      {
        id: "relationships"
        name: "Relationships"
        expanded: no
      }
      {
        id: "system"
        name: "System"
        expanded: no
      }
    ]

    currentDocuments = Document.fetch()
    currentFolders = Folder.fetch()

    if currentDocuments?.length is 0
      Document.fetch()
      Document.save(node_scripts.concat(relationship_scripts, system_scripts))
      Folder.save(folders)
])
