'use strict';

# Requires jQuery
angular.module('neo4jApp.directives')
  .directive('helpTopic', ['$rootScope', 'Editor', 'Frame', ($rootScope,Editor, Frame) ->
    restrict: 'A'
    link: (scope, element, attrs) ->

      topic = attrs.helpTopic
      command = "help"

      if topic
        element.on 'click', (e) ->
          e.preventDefault()

          topic = topic.toLowerCase().trim().replace('-', ' ')
          Frame.create(input: ":#{command} #{topic}")

          $rootScope.$apply() unless $rootScope.$$phase

  ])
