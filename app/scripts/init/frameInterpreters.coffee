angular.module('neo4jApp')
.config([
  'FrameProvider'
  (FrameProvider) ->

    # character used to designate client-side commands (non-cypher)
    # TODO - define this in settings? to be available globally
    cmdchar = ':'

    # convert a string into a topical keyword
    topicalize = (input) ->
      if input?
        input.toLowerCase().trim().replace(' ', '-')
      else
        null

    argv = (input) ->
      rv = input.toLowerCase().split(' ')
      rv or []

    error = (msg, exception = "Error", data) ->
      message: msg
      exception: exception
      data: data

    FrameProvider.interpreters.push
      type: 'clear'
      matches: "#{cmdchar}clear"
      exec: ['$rootScope', ($rootScope) ->
        (input) ->
          $rootScope.$broadcast 'frames:clear'
      ]

    FrameProvider.interpreters.push
      type: 'keys'
      templateUrl: 'views/frame-keys.html'
      matches: "#{cmdchar}keys"
      exec: ['$rootScope', ($rootScope) ->
        (input) -> true
      ]

    # Generic shell commands
    FrameProvider.interpreters.push
      type: 'shell'
      templateUrl: 'views/frame-rest.html'
      matches: "#{cmdchar}schema"
      exec: ['Server', (Server) ->
        (input, q) ->
          Server.console(input.substr(1))
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
      matches: "#{cmdchar}play"
      exec: ->
        step_number = 1
        (input, q) ->
          page: "content/guides/learn_#{step_number}.html"

    # Help/man handler
    FrameProvider.interpreters.push
      type: 'help'
      templateUrl: 'views/frame-help.html'
      matches: ["#{cmdchar}help", "#{cmdchar}man", "help"]
      exec: ['$http', ($http) ->
        (input, q) ->
          section = topicalize(input[('help'.length+1)..]) or 'help'
          url = "content/help/#{section}.html"
          $http.get(url)
          .success(->q.resolve(page: url))
          .error(->q.reject(error("No such help section")))
          q.promise
      ]

    # about handler
    FrameProvider.interpreters.push
      type: 'info'
      templateUrl: 'views/frame-info.html'
      matches: "#{cmdchar}about"
      exec: ->
        (input, q) ->
          page: "content/guides/about.html"

    # sysinfo handler
    FrameProvider.interpreters.push
      type: 'info'
      templateUrl: 'views/frame-info.html'
      matches: "#{cmdchar}sysinfo"
      exec: ->
        (input, q) ->
          page: "content/guides/sysinfo.html"

    # HTTP Handler
    FrameProvider.interpreters.push
      type: 'http'
      templateUrl: 'views/frame-rest.html'
      matches: ["#{cmdchar}get", "#{cmdchar}post", "#{cmdchar}delete", "#{cmdchar}put"]
      exec: ['Server', (Server) ->
        (input, q) ->
          regex = /^[^\w]*(get|GET|put|PUT|post|POST|delete|DELETE)\s+(\S+)\s*([\S\s]+)?$/i
          result = regex.exec(input)

          try 
            [verb, url, data] = [result[1], result[2], result[3]]
          catch e
            q.reject(error("Unparseable http request"))
            return q.promise

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

          # insist that data is parseable JSON
          try
            data = JSON.parse(data)
          catch e
            q.reject(error("Payload does not seem to be valid data."))
            return q.promise

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

    # Profile a cypher command
    FrameProvider.interpreters.push
      type: 'cypher'
      matches: "#{cmdchar}profile"
      templateUrl: 'views/frame-rest.html'
      exec: ['Cypher', (Cypher) ->
        (input, q) ->
          input = input.substr(8)
          if input.length is 0
            q.reject(error("missing query"))
          else
            Cypher.profile(input).then(q.resolve, q.reject)
          q.promise
      ]


    # Cypher handler
    FrameProvider.interpreters.push
      type: 'cypher'
      matches: ['cypher', 'start', 'match', 'create', 'drop', 'return', 'set', 'remove', 'delete']
      templateUrl: 'views/frame-cypher.html'
      exec: ['Cypher', (Cypher) ->
        # Return the function that handles the input
        (input) ->
          Cypher.send(input)
      ]

    # Fallback interpretor
    # Cypher handler
    FrameProvider.interpreters.push
      type: 'help'
      matches: -> true
      templateUrl: 'views/frame-help.html'
      exec: ['$http', ($http) ->
        (input, q) ->
          url = "content/help/unknown.html"
          $http.get(url)
          .success(->q.resolve(page: url))
          .error(->q.reject(error("No such help section")))
          q.promise
      ]

])
