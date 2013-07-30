angular.module('neo4jApp')
.config([
  'viewServiceProvider'
  (viewServiceProvider) ->

    viewServiceProvider.defaultQueries = [
      ["example_1", """
// Example table data
start user=node(*)
match user-[:FRIEND]-friend-[r:RATED]->movie
where r.stars > 3
return friend.name, movie.title, r.stars, r.comment?
      """]
      ["example_2", """
// Example node data
start n=node(0,343)
return n
      """]
    ]

    viewServiceProvider.defaultFolders = [
      ["tutorials", "Tutorials"]
    ]
])
