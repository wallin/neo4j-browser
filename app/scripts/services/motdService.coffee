'use strict';

angular.module('neo4jApp.services')
  .factory 'motdService', [
    ->
      class Motd

        choices =
          quotes: [
            { 'text':'When you label me, you negate me', 'author':'Soren Kierkegaard' }
            { 'text':'In the beginning was the command line', 'author':'Neal Stephenson' }
            { 'text':'Remember, all I\'m offering is the truth – nothing more', 'author':'Morpheus'}
            { 'text':'Testing can show the presence of bugs, but never their absence.', 'author':'Edsger W. Dijkstra'}
            { 'text':'We think you\'re a special snowflake', 'author':'Neo4j'}
            { 'text':'Still he\'d see the matrix in his sleep, bright lattices of logic unfolding across that colorless void', 'author':'William Gibson'}
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
