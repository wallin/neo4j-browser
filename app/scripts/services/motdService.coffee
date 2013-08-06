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
          ],
          unrecognizable: [
            "Interesting. How does this make you feel?"
            "Even if I squint, I can't make out what this is. Is it an elephant?"
            "This one time, at bandcamp..."
            "Ineffable, enigmatic, possibly transcendent. Also quite good looking."
            "I'm not (yet) smart enough to understand this."
            "Oh I agree. Kaaviot ovat suuria!"
          ]

        quote: ""

        tip: ""

        unrecognized: ""

        constructor: ->
          @refresh()

        refresh: ->
          @quote = @pickRandomlyFrom(choices.quotes)
          @tip = @pickRandomlyFrom(choices.tips)
          @unrecognized = @pickRandomlyFrom(choices.unrecognizable)

        pickRandomlyFrom: (fromThis) ->
          return fromThis[Math.floor(Math.random() * fromThis.length)]

      new Motd
]
