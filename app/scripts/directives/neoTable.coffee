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
          elm.html(render(result))
          unbind()

        json2html = (obj) ->
          html  = "<table class='unstyled'><tbody>"
          html += "<tr><th>#{k}</th><td>#{v}</td></tr>" for own k, v of obj
          html += "</tbody></table>"
          html


        # Manual rendering function due to performance reasons
        # (repeat watchers are expensive)
        render = (result) ->
          rows = result.rows()
          return "" unless rows.length
          html  = "<table class='table data'>"
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
              else if angular.isObject(cell)
                html += "<td>#{json2html(cell)}</td>"
              else
                html += "<td>#{JSON.stringify(cell)}</td>"
            html += "</tr>"
          html += "</tbody>"
          html += "</table>"
          html

  ])
