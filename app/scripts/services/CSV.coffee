'use strict';

angular.module('neo4jApp.services')
  .factory 'CSV', [
    () ->
      class Serializer
        constructor: (opts = {}) ->
          @options = angular.extend(opts,
            delimiter: ','
          )

          @_output = ""
          @_columns = null

        append: (row) ->
          if not angular.isArray(row) and row.length is @_columns?.length
            throw 'CSV: Row must an Array of column size'

          @_output += "\n"
          @_output += (@_escape(cell) for cell in row).join(@options.delimiter)

        columns: (cols) ->
          return @_columns unless cols?
          throw 'CSV: Columns must an Array' unless angular.isArray(cols)
          @_columns = (@_escape(c) for c in cols)
          @_output = @_columns.join(@options.delimiter);

        output: -> @_output

        _escape: (string) ->
          string = JSON.stringify(string) unless angular.isString(string)
          d = @options.delimiter
          if string.indexOf(d) > 0 or string.indexOf('"') >= 0
            string = '"' + string.replace(/"/g, '""') + '"'

          string

      return {
        Serializer: Serializer
      }
  ]
