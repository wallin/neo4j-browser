'use strict';

angular.module('neo4jApp.services')
  .factory 'ServerInfo', [
    '$http'
    '$q'
    'Settings'
    ($http, $q, Settings) ->

      returnAndUpdate = (Type, promise) ->
        rv = new Type()
        promise.then(
          (r) ->
            if angular.isArray(rv)
              rv.push.apply(rv, r)
            else
              angular.extend(rv, r)
        )
        rv

      returnAndUpdateArray = (promise) -> returnAndUpdate(Array, promise)

      returnAndUpdateObject = (promise) -> returnAndUpdate(Object, promise)

      class ServerInfo
        constructor: ->

        get: (path) ->
          q = $q.defer()
          path = Settings.host + path unless path.indexOf(Settings.host) is 0
          $http.get(path)
          .success(q.resolve)
          .error(q.reject)
          q.promise

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

      window.server = new ServerInfo
  ]
