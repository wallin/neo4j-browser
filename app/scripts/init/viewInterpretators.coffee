angular.module('neo4jApp')
.config([
  'viewServiceProvider'
  (viewServiceProvider) ->
    # play handler
    viewServiceProvider.interpretors.push
      type: 'play'
      templateUrl: 'views/views-help.html'
      matches: (input) ->
        [cmd] = input.split(' ')
        cmd = cmd.toLowerCase()
        return cmd is 'play'

      exec: [->
        step_number = 1
        (input, q) ->
          q.resolve(
            page: "content/help/guides/learn_#{step_number}.html"
          )
          q.promise
      ]

    # Help/man handler
    viewServiceProvider.interpretors.push
      type: 'help'
      templateUrl: 'views/views-help.html'
      matches: (input) ->
        [cmd] = input.split(' ')
        cmd = cmd.toLowerCase()
        return cmd is 'help' or cmd is 'man'

      exec: [->
        (input, q) ->
          q.resolve(
            page: 'content/help/help.html'
          )
          q.promise
      ]


    # HTTP Handler
    viewServiceProvider.interpretors.push
      type: 'http'
      templateUrl: 'views/views-rest.html'
      matches: (input) ->
        [verb] = input.split(' ')
        return false unless verb
        verbs = ['get', 'post', 'delete', 'put']
        verbs.indexOf(verb.toLowerCase()) >= 0

      exec: ['Server', (Server) ->
        verbs = ['get', 'post', 'delete', 'put']
        error = (msg) ->
          message: msg
          exception: 'HTTP Error'

        (input, q) ->
          regex = /^((GET)|(PUT)|(POST)|(DELETE)) ([^ ]+)( (.+))?$/i
          result = regex.exec(input)
          [verb, url, data] = [result[1], result[6], result[8]]

          verb = verb?.toLowerCase()
          if not verb
            q.reject(error("Invalid verb, expected 'GET, PUT, POST or DELETE'"))
            return q.promise

          if not url?.length > 0
            q.reject(error("Missing path"))
            return q.promise

          if (verb is 'post' or verb is 'put') and not data
            q.reject(error("Method needs data"))
            return q.promise

          # Try to parse JSON
          data = try
            JSON.parse(data)
          catch e
            "\"#{data}\""

          Server[verb]?(url, data)
          .then(
            (r) ->
              q.resolve(r.data)
            ,
            (r) ->
              q.reject(error("Server responded #{r.status}"))
          )

          q.promise
      ]

    # Fallback interpretor
    # Cypher handler
    viewServiceProvider.interpretors.push
      type: 'cypher'
      matches: -> true
      templateUrl: 'views/views-cypher.html'
      exec: ['Cypher', (Cypher) ->
        # Return the function that handles the input
        (input) ->
          Cypher.send(input)
      ]

])
