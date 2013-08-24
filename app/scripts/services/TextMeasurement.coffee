'use strict';

angular.module('neo4jApp')
  .service 'TextMeasurement', () ->
    
    @measure = ( text, fontFamily, fontSize ) ->
      canvasSelection = d3.select('canvas#textMeasurementCanvas').data([this])
      canvasSelection.enter().append('canvas')
        .attr('id', 'textMeasuringCanvas')
        .style('display', 'none');

      canvas = canvasSelection.node();
      context = canvas.getContext('2d');
      context.font = 'normal normal normal ' + fontSize + 'px/normal ' + fontFamily;
      context.measureText(text).width;