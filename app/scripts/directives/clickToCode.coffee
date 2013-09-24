'use strict';

angular.module('neo4jApp.directives')
  .directive 'clickToCode', ['Editor', (Editor) ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      element.click (e) ->
        code = e.currentTarget.textContent or e.currentTarget.innerText
        return unless code?.length > 0
        Editor.setContent(code.trim())
        scope.$apply()

  ]
