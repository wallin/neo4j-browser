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
          html  = "<table class='json-object'><tbody>"
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
              html += '<td>'
              if angular.isString(cell)
                html += cell
              else if angular.isArray(cell)
                html += json2html(el) + "<hr>" for el in cell
              else if angular.isObject(cell)
                html += json2html(cell)
              else
                html += JSON.stringify(cell)
              html += '</td>'
            html += "</tr>"
          html += "</tbody>"
          html += "</table>"
          html

  ])
