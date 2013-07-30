'use strict';

angular.module('neo4jApp.services')
  .factory 'motdService', [
    'Settings'
    'Server'
    (Settings, Server) ->

      class Motd

        choices =
          editor: [
            '"When you label me, you negate me" -- Soren Kierkegaard MOTD 1'
            '"When you label me, you negate me" -- Soren Kierkegaard MOTD 2'
            '"When you label me, you negate me" -- Soren Kierkegaard MOTD 3'
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

        # editor: choices.editor[4] # @pickRandomlyFrom(choices.editor)
        editor: "" 
        

      new Motd
]
