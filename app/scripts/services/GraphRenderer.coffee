'use strict';

angular.module('neo4jApp.services')
  .provider 'GraphRenderer', [->
    class @Renderer
      constructor: (opts = {})->
        angular.extend(@, opts)
        @onGraphChange ?= ->
        @onTick ?= ->

    @nodeRenderers         = []
    @relationshipRenderers = []

    @$get = ->
      return {
        nodeRenderers: @nodeRenderers
        relationshipRenderers: @relationshipRenderers
        Renderer: @Renderer
      }
    @
  ]

