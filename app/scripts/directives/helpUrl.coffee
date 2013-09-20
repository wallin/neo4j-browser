'use strict';

# Requires jQuery
angular.module('neo4jApp.directives')
  .directive('article', ['$rootScope', 'Frame', ($rootScope, Frame) ->
    restrict: 'E'
    link: (scope, element, attrs) ->
      element.on 'click', 'a', (e) ->

        if (e.currentTarget.hasAttribute('help-topic'))
          topic = e.currentTarget.getAttribute('help-topic')
          command = "help"
        else if (e.currentTarget.hasAttribute('play-topic'))
          topic = e.currentTarget.getAttribute('play-topic')
          command = "play"

        if not topic
          command = "help"
          url = e.currentTarget.getAttribute('href')
          if url
            if url.match(/^http/)
              e.currentTarget.target = '_blank'
              return true
            parts = url.replace('.html', '').split('/')
            return unless angular.isArray(parts)
            topic = parts[parts.length-1]

        e.preventDefault()

        topic = topic.toLowerCase().trim().replace('-', ' ')
        Frame.create(input: ":#{command} #{topic}")
        $rootScope.$apply() unless $rootScope.$$phase

      element.on 'click', '.code', (e) ->
        code = e.currentTarget.textContent or e.currentTarget.innerText
        return unless code?.length > 0
        $rootScope.$broadcast 'editor:content', code.trim()
        $rootScope.$apply() unless $rootScope.$$phase

  ])
