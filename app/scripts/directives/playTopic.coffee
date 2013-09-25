'use strict';

# Requires jQuery
angular.module('neo4jApp.directives')
  .directive('playTopic', ['$rootScope', 'Editor', 'Frame', ($rootScope,Editor, Frame) ->
    restrict: 'A'
    link: (scope, element, attrs) ->

      topic = attrs.playTopic
      command = "play"

      if topic
        element.on 'click', (e) ->
          e.preventDefault()

          topic = topic.toLowerCase().trim().replace('-', ' ')
          Frame.create(input: ":#{command} #{topic}")

          $rootScope.$apply() unless $rootScope.$$phase

  ])
