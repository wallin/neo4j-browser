'use strict';

# Requires jQuery
angular.module('neo4jApp.directives')
  .directive('article', ['$rootScope', 'Editor', 'Frame', ($rootScope,Editor, Frame) ->
    restrict: 'E'
    link: (scope, element, attrs) ->
      element.on 'click', '.code', (e) ->
        code = e.currentTarget.textContent or e.currentTarget.innerText
        return unless code?.length > 0
        Editor.setContent(code.trim())
        $rootScope.$apply() unless $rootScope.$$phase

  ])
