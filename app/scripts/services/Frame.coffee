'use strict';

angular.module('neo4jApp.services')
.provider 'Frame', [
  ->
    self = @
    @interpreters = []

    @$get = [
      '$injector'
      '$q'
      'Collection'
      'Settings'
      'Timer'
      'Utils'
      ($injector, $q, Collection, Settings, Timer, Utils) ->
        class Frame
          constructor: (data = {})->
            @templateUrl = null
            if angular.isString(data)
              @input = data
            else
              angular.extend(@, data)
            @id ?= UUID.genV1().toString()

          toJSON: ->
            {@id, @input}

          exec: ->
            query = Utils.stripComments(@input.trim())
            return unless query
            # Find first matching input interpretator
            intr = frames.interpreterFor(query)
            return unless intr
            @type = intr.type
            intrFn = $injector.invoke(intr.exec)

            @setProperties()

            @errorText = no
            @hasErrors = no
            @isLoading = yes
            @response  = null
            @templateUrl = intr.templateUrl
            timer = Timer.start()
            @startTime = timer.started()
            $q.when(intrFn(query, $q.defer())).then(
              (result) =>
                @isLoading = no
                if result.isTooLarge
                  @hasErrors = yes
                  @errorText = "Resultset is too large"
                else
                  @response = result
                  @savedInput = @input
                @runTime = timer.stop().time()
              ,
              (result = {}) =>
                @isLoading = no
                @hasErrors = yes
                @response = result.data
                @errorText = "Unknown error"
                if result.length > 0 and result[0].status
                  @errorText = result[0].status
                  if result[0].message
                    @errorText += ": " + result[0].message.split("\n")[0]
                @runTime = timer.stop().time()
            )
            @
          setProperties: ->
            # FIXME: this should maybe be defined by the interpreters
            @exportable     = @type in ['cypher', 'http']
            @fullscreenable = yes


        class Frames extends Collection
          create: (data = {})  ->
            return unless data.input
            intr = @interpreterFor(data.input)
            return undefined unless intr
            if intr.templateUrl
              frame = new Frame(data)
            else
              rv = $injector.invoke(intr.exec)()

            if frame
              # Make sure we don't create more frames than allowed
              @remove(@first()) while @length >= Settings.maxFrames
              @add(frame.exec())
            frame or rv

          interpreterFor: (input = '') ->
            intr = null
            input = Utils.stripComments(input.trim())
            args = Utils.argv(input)
            for i in self.interpreters
              if angular.isFunction(i.matches)
                if i.matches(input)
                  return i
              else
                cmds = i.matches
                cmds = [cmds] if angular.isString(i.matches)
                if angular.isArray(cmds)
                  if cmds.indexOf(args[0]) >= 0
                    return i
            intr

          klass: Frame

        frames = new Frames(null, Frame)
    ]
    @
]
