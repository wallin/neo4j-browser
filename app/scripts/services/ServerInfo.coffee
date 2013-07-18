'use strict';

angular.module('neo4jApp.services')
  .factory 'ServerInfo', [
    '$http'
    '$q'
    'Settings'
    ($http, $q, Settings) ->

      returnAndUpdate = (promise) ->
        rv = []
        promise.then(
          (r) -> rv.push.apply(rv, r)
        )
        rv

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
          returnAndUpdate @get Settings.endpoint.rest + '/labels'

        relationships: ->
          returnAndUpdate @get Settings.endpoint.rest + '/relationship/types'

        status: ->
          @get '/db/manage/server/monitor/fetch'

        log: (path) ->
          @get(path).then((r)-> console.log (r))

      window.server = new ServerInfo
  ]
