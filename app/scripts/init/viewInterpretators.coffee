angular.module('neo4jApp')
.config([
  'viewServiceProvider'
  (viewServiceProvider) ->
    # Cypher handler
    viewServiceProvider.interpretors.push
      type: 'cypher'
      exec: ['Cypher', (Cypher) ->
        # Return the function that handles the input
        (input) ->
          Cypher.send(input)
      ]

    # HTTP Handler
    viewServiceProvider.interpretors.push
      type: 'http'
      exec: ['Server', (Server) ->
        verbs = ['get', 'post', 'delete', 'put']
        error = (msg) ->
          message: msg
          exception: 'HTTP Syntax error'

        (input, q) ->
          [verb, url] = input.split(' ')

          if not verb?
            q.reject(error('Missing verb'))
            return q.promise

          verb = verb.toLowerCase()
          if verbs.indexOf(verb) < 0
            q.reject(error("Invalid verb, expected '#{verbs.join(', ')}"))
            return q.promise

          if not url?.length > 0
            q.reject(error("Missing path"))
            return q.promise


          Server[verb]?(url)
      ]
])
