angular.module('neo4jApp')
.run([
  '$rootScope'
  'Document'
  'Folder'
  ($rootScope, Document, Folder) ->
    general_scripts = [
      {
        folder: 'general'
        content: """
// Get some data
MATCH (n) RETURN n LIMIT 100
        """
      }
      {
        folder: 'general'
        content: """
// Count nodes
MATCH (n)
RETURN count(n)
        """
      }
      {
        folder: 'general'
        content: """
// What is related, and how
MATCH (a)-[r]->(b)
RETURN DISTINCT head(labels(a)) AS This, type(r) as To, head(labels(b)) AS That
LIMIT 100
        """
      }
    ]

    node_scripts = [
      {
        folder: 'nodes'
        content: """
// Count nodes
MATCH (n{{':'+label-name}})
RETURN count(n)
        """
      }
      {
        folder: 'nodes'
        content: """
// Create index
CREATE INDEX ON :{{label-name}}({{property-name}})
        """
      }
      {
        folder: 'nodes'
        content: """
// Create indexed node
CREATE (n{{':'+label-name}} { {{property-name}}:"{{property-value}}" }) RETURN n
        """
      }
      {
        folder: 'nodes'
        content: """
// Create node
CREATE (n{{':'+label-name}}) RETURN n
        """
      }
      {
        folder: 'nodes'
        content: """
// Delete a node
START n=node(*) MATCH (n{{':'+label-name}})-[r?]-()
WHERE {{property-name}} = "{{property-name}}"
DELETE n,r
        """
      }
      {
        folder: 'nodes'
        content: """
// Drop index
DROP INDEX ON :{{label-name}}({{property-name}})
        """
      }
      {
        folder: 'nodes'
        content: """
// Find a node
MATCH (n{{':'+label-name}})
WHERE n.{{property-name}} = "{{property-value}}" RETURN n
        """
      }
      {
        folder: 'nodes'
        content: """
// Get all nodes
MATCH (n{{':'+label-name}})
RETURN n LIMIT 100
        """
      }
    ]

    relationship_scripts = [
      {
        folder: 'relationships'
        content: """
// Isolate node
MATCH (a)-[r{{':'+type-name}}]-()
WHERE a.{{property-name}} = "{{property-value}}"
DELETE r
        """
      }
      {
        folder: 'relationships'
        content: """
// Relate nodes
MATCH (a),(b)
WHERE a.{{property-name}} = "{{property-value-a}}"
AND b.{{property-name}} = "{{property-value-b}}"
CREATE (a)-[r{{':'+type-name}}]->(b)
RETURN a,r,b
        """
      }
      {
        folder: 'relationships'
        content: """
// Shortest path
MATCH p = shortestPath( (a)-[{{':'+type-name}}*..4]->(b) )
WHERE a.{{propert-name}}={property-value-a} AND b.{{property-name}}={{property-value-b}}
RETURN p
        """
      }
      {
        folder: 'relationships'
        content: """
// Whats related
MATCH (a)-[r{{':'+type-name}}]-(b)
RETURN DISTINCT head(labels(a)), type(r), head(labels(b))
        """
      }
    ]

    system_scripts = [
      {
        folder: 'system'
        content: """
// Is master
:GET /db/manage/server/ha/master
        """
      }
      {
        folder: 'system'
        content: """
// Is slave
:GET /db/manage/server/ha/slave
        """
      }
      {
        folder: 'system'
        content: """
// System info
:GET /db/manage/server/jmx/domain/org.neo4j
        """
      }
    ]

    folders = [
      {
        id: "general"
        name: "General"
        expanded: yes
      }
      # {
      #   id: "nodes"
      #   name: "Nodes"
      #   expanded: no
      # }
      # {
      #   id: "relationships"
      #   name: "Relationships"
      #   expanded: no
      # }
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
      Document.save(general_scripts.concat(system_scripts))
      Folder.save(folders)
])
