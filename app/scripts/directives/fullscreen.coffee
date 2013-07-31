'use strict';

angular.module('neo4jApp.directives')
  .factory('fullscreenService', [->
    root = angular.element('body')
    container = angular.element('<div class="fullscreen-container"></div>')
    container.hide().appendTo(root)
    return {
      display: (element) ->
        container.append(element).show()
      hide: -> container.hide()
    }
  ])


angular.module('neo4jApp.directives')
.directive('fullscreen', ['fullscreenService',
  (fullscreenService) ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      parent = element.parent()
      scope.$watch attrs.fullscreen, (val) ->
        if val
          fullscreenService.display(element)
        else if parent[0].innerHTML is ""
          parent.append(element)
          fullscreenService.hide()
])
