'use strict';

angular.module('neo4jApp.services')
.provider 'Frame', [
  ->
    self = @
    @interpreters = []

    @$get = [
      '$injector',
      '$q',
      '$rootScope'
      'Timer'
      'Utils'
      ($injector, $q, $rootScope, Timer, Utils) ->
        class Frame
          constructor: (data = {})->
            @templateUrl = null
            if angular.isString(data)
              @input = data
            else
              angular.extend(@, data)
            @id ?= UUID.genV1().toString()

          toJSON: ->
            {@id, @starred, @folder, @input}

          exec: ->
            query = Utils.stripComments(@input.trim())
            return unless query
            # Find first matching input interpretator
            intr = Frame.interpreterFor(query)
            return unless intr
            @type = intr.type
            intrFn = $injector.invoke(intr.exec)

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
                if result.exception and result.message
                  @errorText = result.exception + ": " + result.message.split("\n")[0]
                else
                  @errorText = "Unknown error"
                @runTime = timer.stop().time()
            )

          @create: (data) ->
            intr = @interpreterFor(data.input)
            return undefined unless intr
            if intr.templateUrl
              new Frame(data)
            else
              $injector.invoke(intr.exec)()


          @interpreterFor: (input) ->
            intr = null
            for i in self.interpreters
              if i.matches(input)
                intr = i
                break;
            intr


        Frame
    ]
    @
]
