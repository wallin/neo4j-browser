'use strict';

angular.module('neo4jApp.services')
  .factory 'Timer', () ->

    currentTime = -> (new Date).getTime()

    class Timer
      constructor: ->
        @_start = null
        @_end = null

      isRunning: ->
        return @_start?

      start: ->
        @_start ?= currentTime()
        @

      started: -> @_start

      stop: ->
        @_end ?= currentTime()
        @

      stopped: -> @_end

      time: ->
        return 0 unless @_start?
        end = @_end or currentTime()
        end - @_start

    class TimerService
      timers = {}

      constructor: ->

      new: (name = 'default') ->
        timers[name] = new Timer()

      start: (name = 'default') ->
        timer = @new(name)
        timer.start()

      stop: (name = 'default') ->
        return undefined unless timers[name]?
        timers[name].stop()

      currentTime: currentTime


    new TimerService
