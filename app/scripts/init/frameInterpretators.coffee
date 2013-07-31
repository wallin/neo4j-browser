angular.module('neo4jApp')
.config([
  'FrameProvider'
  (FrameProvider) ->

    argv = (input) ->
      rv = input.toLowerCase().split(' ')
      rv or []

    error = (msg, exception = "Error", data) ->
      message: msg
      exception: exception
      data: data

    FrameProvider.interpretors.push
      type: 'clear'
      matches: (input) ->
        argv(input)[0] is 'clear'
      exec: ['$rootScope', ($rootScope) ->
        (input) ->
          $rootScope.$broadcast 'frames:clear'
      ]


    # Generic shell commands
    FrameProvider.interpretors.push
      type: 'shell'
      templateUrl: 'views/frame-rest.html'
      matches: (input) ->
        switch argv(input)[0]
          when 'schema' then yes
          else no

      exec: ['Server', (Server) ->
        (input, q) ->
          Server.console(input)
          .then(
            (r) ->
              response = r.data[0]
              if response.match('Unknown')
                q.reject(error("Unknown action", null, response))
              else
                q.resolve(response)
          )
          q.promise
      ]


    # play handler
    FrameProvider.interpretors.push
      type: 'play'
      templateUrl: 'views/frame-help.html'
      matches: (input) ->
        [cmd] = input.split(' ')
        cmd = cmd.toLowerCase()
        return cmd is 'play'

      exec: ->
        step_number = 1
        (input, q) ->
          page: "content/help/guides/learn_#{step_number}.html"

    # Help/man handler
    FrameProvider.interpretors.push
      type: 'help'
      templateUrl: 'views/frame-help.html'
      matches: (input) ->
        switch argv(input)[0]
          when 'help', 'man' then yes
          else no

      exec: ->
        (input, q) ->
          console.log(input)
          topic = input[4..]
          if (topic.length > 1)
            topic = topic.toLowerCase().trim()
            page: "content/help/cypher/#{topic}.html"
          else
            page: "content/help/help.html"

    # HTTP Handler
    FrameProvider.interpretors.push
      type: 'http'
      templateUrl: 'views/frame-rest.html'
      matches: (input) ->
        [verb] = input.split(' ')
        return false unless verb
        verbs = ['get', 'post', 'delete', 'put']
        verbs.indexOf(verb.toLowerCase()) >= 0

      exec: ['Server', (Server) ->
        verbs = ['get', 'post', 'delete', 'put']
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
    FrameProvider.interpretors.push
      type: 'cypher'
      matches: -> true
      templateUrl: 'views/frame-cypher.html'
      exec: ['Cypher', (Cypher) ->
        # Return the function that handles the input
        (input) ->
          Cypher.send(input)
      ]

])
