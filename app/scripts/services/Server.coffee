'use strict';

angular.module('neo4jApp.services')
  .factory 'Server', [
    '$http'
    '$q'
    'Settings'
    ($http, $q, Settings) ->

      returnAndUpdate = (Type, promise) ->
        rv = new Type()
        promise.success(
          (r) ->
            if angular.isArray(rv)
              rv.push.apply(rv, r)
            else
              angular.extend(rv, r)
        )
        rv

      returnAndUpdateArray = (promise) -> returnAndUpdate(Array, promise)

      returnAndUpdateObject = (promise) -> returnAndUpdate(Object, promise)

      class Server
        constructor: ->

        #
        # Basic HTTP methods
        #
        delete: (path = '') ->
          path = Settings.host + path unless path.indexOf(Settings.host) is 0
          $http.delete(path)

        get: (path = '') ->
          path = Settings.host + path unless path.indexOf(Settings.host) is 0
          $http.get(path)

        post: (path = '', data) ->
          path = Settings.host + path unless path.indexOf(Settings.host) is 0
          $http.post(path, data)

        cypher: (path = '', data) ->
          @post("#{Settings.endpoint.cypher}" + path, data)

        transaction: (opts) ->
          opts = angular.extend(
            path: '',
            statements: [],
            method: 'post'
          , opts)
          {path, statements, method} = opts
          path = Settings.endpoint.transaction + path
          method = method.toLowerCase()

          @[method]?(path, {statements: statements})

        #
        # Convenience methods
        #
        labels: ->
          returnAndUpdateArray @get Settings.endpoint.rest + '/labels'

        relationships: ->
          returnAndUpdateArray @get Settings.endpoint.rest + '/relationship/types'

        rest: ->
          returnAndUpdateObject @get Settings.endpoint.rest + '/'

        status: ->
          @get '/db/manage/server/monitor/fetch'

        log: (path) ->
          @get(path).then((r)-> console.log (r))

      window.server = new Server
  ]
