'use strict';

angular.module('neo4jApp.services')
  .factory 'motdService', [
    'Settings'
    'Server'
    (Settings, Server) ->

      class Motd

        choices =
          editor: [
            '"When you label me, you negate me" -- Soren Kierkegaard'
            '"In the beginning was the command line" -- Neal Stephenson'
            '"Remember, all I\'m offering is the truth – nothing more" -- Morpheus'
            '"When you label me, you negate me" -- Soren Kierkegaard MOTD 4'
            '"When you label me, you negate me" -- Soren Kierkegaard MOTD 5'
            '"When you label me, you negate me" -- Soren Kierkegaard MOTD 6'
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
