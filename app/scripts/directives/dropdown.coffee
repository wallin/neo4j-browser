'use strict';

angular.module('neo4jApp.directives')
  .directive('hasDropdown', () ->
    controller: ['$element', '$scope', ($element, $scope) ->
      @dropdown = null
      @hide = ->
        $element.removeClass('hover')
        @dropdown?.hide()
      @show = ->
        $element.addClass('hover')
        @dropdown?.show()
    ]
    restrict: 'C'
    link: (scope, element, attrs, ctrl) ->
      #ctrl.hide()
      element.bind 'mouseover', -> ctrl.show()
  )

angular.module('neo4jApp.directives')
  .directive('dropdown', () ->
    restrict: 'C'
    require: '^hasDropdown'
    link: (scope, element, attrs, ctrl) ->
      ctrl.dropdown = element
      element.bind 'mouseout', -> ctrl.hide()
  )
