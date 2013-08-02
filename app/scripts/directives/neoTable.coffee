'use strict';
angular.module('neo4jApp.directives')
  .directive('neoTable', [
    ->
      replace: yes
      restrict: 'E'
      link: (scope, elm, attr) ->
        predicate = null

        unbind = scope.$watch attr.tableData, (result) ->
          return unless result
          # TODO: show something if result is too large
          return if result.isTooLarge
          elm.html(render(result))
          unbind()

        # Manual rendering function due to performance reasons
        # (repeat watchers are expensive)
        render = (result) ->
          rows = result.rows()
          return "" unless rows.length
          html  = "<table class='table-striped'>"
          html += "<thead><tr>"
          for col in result.columns()
            html += "<th>#{col}</th>"
          html += "</tr></thead>"
          html += "<tbody>"
          for row in result.rows()
            html += "<tr>"
            for cell in row
              if angular.isString(cell)
                html += "<td>#{cell}</td>"
              else
                html += "<td>#{JSON.stringify(cell)}</td>"
            html += "</tr>"
          html += "</tbody>"
          html += "</table>"
          html

  ])
