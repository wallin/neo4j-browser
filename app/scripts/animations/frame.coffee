angular.module("neo4jApp.animations", [])

  # Animation for creating and removing result frames
  #
  .animation("frame-out", ["$window", ($window) ->
    setup: (element) ->
      TweenMax.set element,
        height: element.height()

    start: (element, done) ->
      TweenMax.to element, 0.4,
        ease: Power2.easeInOut
        opacity: 0
        height: 0
        onComplete: done

  ]).animation("frame-in", ["$window", ($window) ->
    setup: (element) ->
      TweenMax.set element,
        position: "absolute"
        top: -100
        opacity: 0

    start: (element, done) ->
      beforeDone = () ->
        # remove max-height to be able to resize the frame when interacting
        TweenMax.set element, maxHeight: 'initial'
        done()

      tl = new TimelineLite()

      tl.to(element, 0.2, {}) # render object to get a size
      tl.call((e)->
        tl.to(element, 0.01, {maxHeight: 0})
        tl.to element, 0.4,
          maxHeight: element.height()
          top: 0
          opacity: 1
          position: "relative"
          ease: Power3.easeInOut
        tl.call(beforeDone)
      )
  ])

  .animation("fade-down-out", ["$window", ($window) ->
    start: (element, done) ->
      TweenMax.to element, 0.4,
        ease: Power2.easeInOut
        bottom: -element.height()
        opacity: 0
        onComplete: done

  ]).animation("fade-down-in", ["$window", ($window) ->
    setup: (element) ->
      TweenMax.set element,
        bottom: -element.height()
        opacity: 0

    start: (element, done) ->
      TweenMax.to element, 0.4,
        ease: Power2.easeInOut
        bottom: 0
        opacity: 1
        onComplete: done
  ])

  .animation("slide-down-out", ["$window", ($window) ->
    start: (element, done) ->
      TweenMax.to element, 0.4,
        ease: Power2.easeInOut
        height: 0
        onComplete: done

  ]).animation("slide-down-in", ["$window", ($window) ->
    setup: (element) ->
      TweenMax.set element,
        height: 0

    start: (element, done) ->
      TweenMax.to element, 0.4,
        ease: Power2.easeInOut
        height: 49
        onComplete: done
  ])

  .animation("pop-out", ["$window", ($window) ->
    start: (element, done) ->
      TweenMax.to element, 0.25,
        ease: Power2.easeInOut
        opacity: 0
        height: 0
        onComplete: done

  ]).animation("pop-in", ["$window", ($window) ->
    setup: (element) ->
      TweenMax.set element,
        bottom: -element.height()
        opacity: 0
        maxHeight: 0

    start: (element, done) ->
      TweenMax.to element, 0.25,
        ease: Power2.easeInOut
        bottom: 0
        opacity: 1
        maxHeight: 70
        onComplete: done
  ])
