angular.module("neo4jApp.animations", [])
  .animation("frame-out", ["$window", ($window) ->
    start: (element, done) ->
      TweenMax.to element, 0.4,
        ease: Power2.easeInOut
        top: -50
        opacity: 0
        maxHeight: 0
        onComplete: done

  ]).animation "frame-in", ["$window", ($window) ->
    setup: (element) ->
      TweenMax.set element,
        position: "relative"
        top: -100
        opacity: 0
        maxHeight: 0
        scale: 0.95

    start: (element, done) ->
      TweenMax.to element, 0.8,
        ease: Power2.easeInOut
        top: 0
        opacity: 1
        maxHeight: 420
        scale: 1
        onComplete: done
  ]
