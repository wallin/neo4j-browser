'use strict';

angular.module('neo4jApp')
  .service 'TextMeasurement', () ->

    measureUsingCanvas = (text, font) ->
      canvasSelection = d3.select('canvas#textMeasurementCanvas').data([this])
      canvasSelection.enter().append('canvas')
        .attr('id', 'textMeasuringCanvas')
        .style('display', 'none')

      canvas = canvasSelection.node()
      context = canvas.getContext('2d')
      context.font = font
      context.measureText(text).width

    cache = (
      () ->
        cacheSize = 10000
        map = {}
        list = []
        (key, calc) ->
          cached = map[key]
          if cached
            cached
          else
            result = calc()
            if (list.length > cacheSize)
              delete map[list.splice(0, 1)]
              list.push(key)
            map[key] = result
    )()

    @measure = (text, fontFamily, fontSize) ->
      font = 'normal normal normal ' + fontSize + 'px/normal ' + fontFamily;
      cache(text + font, () ->
        measureUsingCanvas(text, font)
      )
