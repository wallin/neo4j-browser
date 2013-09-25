'use strict';

angular.module('neo4jApp.directives')
  .directive 'clickToCode', ['Editor', (Editor) ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      element.click (e) ->
        code = scope.$eval(attrs.clickToCode)
        return unless code?.length > 0
        Editor.setContent(code.trim())
        scope.$apply()

  ]
