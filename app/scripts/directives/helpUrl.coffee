'use strict';

# Requires jQuery
angular.module('neo4jApp.directives')
  .directive('article', ['$rootScope', ($rootScope) ->
    restrict: 'E'
    link: (scope, element, attrs) ->
      element.on 'click', 'a', (e) ->
        e.preventDefault()

        topic = e.currentTarget.getAttribute('help-topic')

        console.log("topic attr: #{topic}")

        if not topic
          url = e.currentTarget.getAttribute('href')
          if url.match(/^http/)
            e.currentTarget.target = '_blank'
            return true

          parts = url.replace('.html', '').split('/')
          return unless angular.isArray(parts)
          topic = parts[parts.length-1]
          console.log("topic from url: #{topic}")

        topic = topic.toLowerCase().trim().replace('-', ' ')
        $rootScope.$broadcast 'frames:create', "help #{topic}"
        $rootScope.$apply() unless $rootScope.$$phase

      element.on 'click', '.code', (e) ->
        code = e.currentTarget.textContent or e.currentTarget.innerText
        return unless code?.length > 0
        $rootScope.$broadcast 'editor:content', code.trim()
        $rootScope.$apply() unless $rootScope.$$phase

  ])
