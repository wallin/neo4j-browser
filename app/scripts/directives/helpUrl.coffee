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

        console.log parts[2]
        $rootScope.$broadcast 'frames:create', "help #{parts[3]}"
        $rootScope.$apply() unless $rootScope.$$phase


  ])
