'use strict'

angular.module('neo4jApp.controllers')
  .controller 'JMXCtrl', [
    '$scope'
    'Server'
    ($scope, Server) ->

      parseName = (str) ->
        str.substr(str.lastIndexOf("name=")+5)


      Server.jmx(["org.neo4j:*"]).success((response) ->
        r.name = parseName(r.name) for r in response
      )
  ]
