'use strict';

angular.module('neo4jApp.filters')
  .filter 'humanReadableBytes', [() ->
    (input) ->
      number = +input
      return '-' unless isFinite(number)

      if number < 1024
        return "#{number} B"

      number /= 1024
      units = ['KiB', 'MiB', 'GiB', 'TiB']

      for unit in units
        if number < 1024 then return "#{number.toFixed(2)} #{unit}"
        number /= 1024

      "#{number.toFixed(2)} PiB"
  ]
