angular.module("neo4jApp.animations", [])
  .animation("frame-out", ["$window", ($window) ->
    start: (element, done) ->
      TweenMax.to element, 0.4,
        ease: Power2.easeInOut
        top: -50
        opacity: 0
        maxHeight: 0
        onComplete: done

  ]).animation("frame-in", ["$window", ($window) ->
    setup: (element) ->
      TweenMax.set element,
        position: "absolute"
        top: -100
        opacity: 0

    start: (element, done) ->
      tl = new TimelineLite()

      tl.to(element, 0.1, {}) # render object to get a size
      tl.call((e)->
        tl.to(element, 0.1, {maxHeight: 0})
        tl.to element, 0.4,
          maxHeight: Math.max(element.height(), 420)
          top: 0
          opacity: 1
          position: "relative"
          ease: Power3.easeInOut
        tl.call(done)
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

  .animation("pop-out", ["$window", ($window) ->
    start: (element, done) ->
      TweenMax.to element, 0.4,
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
      TweenMax.to element, 0.4,
        ease: Power2.easeInOut
        bottom: 0
        opacity: 1
        maxHeight: 70
        onComplete: done
  ])
