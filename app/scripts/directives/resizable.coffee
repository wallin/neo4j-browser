'use strict';

angular.module('neo4jApp')
  .directive('resizable', () ->
    controller: ($scope) ->
      startCallbacks = []
      stopCallbacks = []
      @onStart = (func) ->
        startCallbacks.push(func)
      @onStop = (func) ->
        stopCallbacks.push(func)
      @start = (amount) ->
        callback.call(undefined, amount) for callback in startCallbacks
      @stop = () ->
        callback.call(undefined) for callback in stopCallbacks
  )

  .directive('resize', () ->
    require: '^resizable'
    link: (scope, element, attrs, resizableCtrl) ->
      console.log element
      property = attrs.resize
      initialValue = +element.css(property)[0..-3] ## requires jQuery
      resizableCtrl.onStart (amount) ->
        element[0].style[property] = "#{initialValue + amount}px"
      resizableCtrl.onStop () ->
        initialValue = +element[0].style[property][0..-3]
  )

  # Used for resizing stuff that appears by magic
  .directive('resizeChild', () ->
    require: '^resizable'
    link: (scope, element, attrs, resizableCtrl) ->
      attrs = scope.$eval(attrs.resizeChild)
      child = Object.keys(attrs)[0]
      property = attrs[child]
      initialValue = null

      resizableCtrl.onStart (amount) ->
        initialValue = +$(child, element).css(property)[0..-3] unless initialValue
        $(child, element).css(property, "#{initialValue + amount}px")
      resizableCtrl.onStop () ->
        initialValue = +element[0].style[property][0..-3]
  )

  .directive('handle', () ->
    require: '^resizable'
    link: (scope, element, attrs, resizableCtrl) ->
      element.bind "mousedown", (e) ->
        e.preventDefault() # prevent text selection
        initialValue = lastValue = e.clientY

        angular.element(document).bind "mousemove", (e) ->
          mousePos = e.clientY
          newValue = (element[0].clientHeight - (lastValue - mousePos))
          lastValue = mousePos
          resizableCtrl.start(lastValue - initialValue)

        angular.element(document).bind "mouseup", ->
          angular.element(document).unbind "mousemove"
          angular.element(document).unbind "mouseup"
          resizableCtrl.stop()
  )

