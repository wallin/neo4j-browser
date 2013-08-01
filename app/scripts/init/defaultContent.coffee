angular.module('neo4jApp')
.run([
  '$rootScope'
  'Document'
  'Folder'
  ($rootScope, Document, Folder) ->

    documents = [
      {
        id: "example_1"
        folder: 'tutorials'
        content: """
  // Example table data
  start user=node(*)
  match user-[:FRIEND]-friend-[r:RATED]->movie
  where r.stars > 3
  return friend.name, movie.title, r.stars, r.comment?"""
      },
      {
        id: "example_2"
        folder: 'tutorials'
        content: """
// Example node data
start n=node(0,343)
return n"""
      }
    ]

    folders = [{
      id: "tutorials"
      name: "Tutorials"
    }]

    currentDocuments = Document.fetch()
    currentFolders = Folder.fetch()

    if not currentDocuments?.length > 0
      Document.save(documents)
      Folder.save(folders)
])
