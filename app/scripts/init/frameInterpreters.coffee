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

    FrameProvider.interpreters.push
      type: 'clear'
      matches: "clear"
      exec: ['$rootScope', ($rootScope) ->
        (input) ->
          $rootScope.$broadcast 'frames:clear'
      ]

    # Generic shell commands
    FrameProvider.interpreters.push
      type: 'shell'
      templateUrl: 'views/frame-rest.html'
      matches: "schema"
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
    FrameProvider.interpreters.push
      type: 'play'
      templateUrl: 'views/frame-help.html'
      matches: "play"
      exec: ->
        step_number = 1
        (input, q) ->
          page: "content/guides/learn_#{step_number}.html"

    # Help/man handler
    FrameProvider.interpreters.push
      type: 'help'
      templateUrl: 'views/frame-help.html'
      matches: ["help", "man"]
      exec: ['$http', ($http) ->
        (input, q) ->
          section = argv(input)[1] or 'help'
          section = section.toLowerCase().trim().replace(' ', '-')
          url = "content/help/#{section}.html"
          $http.get(url)
          .success(->q.resolve(page: url))
          .error(->q.reject(error("No such help section")))
          q.promise
      ]

    # HTTP Handler
    FrameProvider.interpreters.push
      type: 'http'
      templateUrl: 'views/frame-rest.html'
      matches: ['get', 'post', 'delete', 'put']
      exec: ['Server', (Server) ->
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
    FrameProvider.interpreters.push
      type: 'cypher'
      matches: -> true
      templateUrl: 'views/frame-cypher.html'
      exec: ['Cypher', (Cypher) ->
        # Return the function that handles the input
        (input) ->
          Cypher.send(input)
      ]

])
