'use strict';

angular.module('neo4jApp.services')
  .factory 'motdService', [
    ->
      class Motd

        choices =
          editor: [
            '"When you label me, you negate me" -- Soren Kierkegaard'
            '"In the beginning was the command line" -- Neal Stephenson'
            '"Remember, all I\'m offering is the truth – nothing more" -- Morpheus'
            '"Testing can show the presence of bugs, but never their absence." -- Edsger W. Dijkstra'
          ]

        constructor: ->
          @refresh()

        refresh: ->
          @editor = @pickRandomlyFrom(choices.editor)

        pickRandomlyFrom: (fromThis) ->
          return fromThis[Math.floor(Math.random() * fromThis.length)]

        editor: ""


      new Motd
]
