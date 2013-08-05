'use strict';

angular.module('neo4jApp.services')
  .factory 'motdService', [
    ->
      class Motd

        choices =
          quotes: [
            '"When you label me, you negate me" -- Soren Kierkegaard'
            '"In the beginning was the command line" -- Neal Stephenson'
            '"Remember, all I\'m offering is the truth – nothing more" -- Morpheus'
            '"Testing can show the presence of bugs, but never their absence." -- Edsger W. Dijkstra'
            '"We think you\'re a special snowflake" -- Neo4j'
          ],
          tips: [
            'Type here! Use <shift-return> for multi-line, <cmd-return> to evaluate command'
          ]
        quote: ""

        tip: ""

        constructor: ->
          @refresh()

        refresh: ->
          @quote = @pickRandomlyFrom(choices.quotes)
          @tip = @pickRandomlyFrom(choices.tips)

        pickRandomlyFrom: (fromThis) ->
          return fromThis[Math.floor(Math.random() * fromThis.length)]

      new Motd
]
