'use strict';

app = angular.module('neo4jApp')

app
  .factory 'terminalService', [
    '$http',
    ($http) ->
      class Terminal
        constructor: (@name = 'default')->
          @buffer  = []
          @history = []
          @prompt  = '> '
          @input   = ''

        run: (input)->
          @input = input if input?
          @buffer.push @prompt + @input
          @history.push @input
          $http.post('http://localhost:7474/db/manage/server/console',
            command: @input
            engine: 'shell'
          ).success((data) =>
            @input = ""
            @buffer.push(data[0])
          )

      new Terminal
  ]
