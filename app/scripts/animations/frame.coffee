###!
Copyright (c) 2002-2013 "Neo Technology,"
Network Engine for Objects in Lund AB [http://neotechnology.com]

This file is part of Neo4j.

Neo4j is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
###

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

  # Animation for message bar below editor
  #
  .animation("intro-out", ["$window", ($window) ->
    start: (element, done) ->
      TweenMax.to element, 0.4,
        ease: Power2.easeInOut
        opacity: 0
        top: 40
        onComplete: done

  ]).animation("intro-in", ["$window", ($window) ->
    setup: (element) ->
      TweenMax.set element,
        opacity: 0
        top: 30
        scale: 0.8
        display: 'block'

    start: (element, done) ->
      TweenMax.to element, 1.6,
        ease: Power2.easeInOut
        opacity: 1
        top: 0
        scale: 1
        onComplete: done
  ])

  # Animation for message bar below editor
  #
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
        display: 'block'

    start: (element, done) ->
      TweenMax.to element, 0.4,
        ease: Power2.easeInOut
        height: 49
        onComplete: done
  ])

  # Animation for saved scripts list elements
  #
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
