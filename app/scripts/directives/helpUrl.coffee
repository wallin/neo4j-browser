'use strict';

# Requires jQuery
angular.module('neo4jApp.directives')
  .directive('article', ['$rootScope', ($rootScope) ->
    restrict: 'E'
    link: (scope, element, attrs) ->
      element.on 'click', 'a', (e) ->
        url = e.currentTarget.getAttribute('href')
        if url.match(/^http/)
          e.currentTarget.target = '_blank'
          return true

        e.preventDefault()
        parts = url.replace('.html', '').split('/')
        return unless angular.isArray(parts)

        $rootScope.$broadcast 'frames:create', "help #{parts[3]}"
        $rootScope.$apply() unless $rootScope.$$phase

      element.on 'click', '.code', (e) ->
        code = e.currentTarget.textContent or e.currentTarget.innerText
        return unless code?.length > 0
        $rootScope.$broadcast 'editor:content', code.trim()
        $rootScope.$apply() unless $rootScope.$$phase

  ])
