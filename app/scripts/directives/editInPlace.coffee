'use strict';

angular.module('neo4jApp')
  .directive('editInPlace', ['$parse', '$timeout', ($parse, $timeout) ->
    restrict: "A"
    scope:
      value: "=editInPlace"
      callback: "&onBlur"
    replace: true
    template: '<div ng-class=" {editing: editing} " class="edit-in-place"><form ng-submit="save()"><span ng-bind="value" ng-hide="editing"></span><input ng-show="editing" ng-model="value" class="edit-in-place-input"><div ng-click="edit($event)" ng-hide="editing" class="edit-in-place-trigger"></div></form></div>'
    link: (scope, element, attrs) ->
      scope.editing = false
      inputElement = element.find('input')

      scope.edit = (e) ->
        e.preventDefault()
        e.stopPropagation()
        scope.editing = true

        $timeout(->
          inputElement.focus()
        , 0, false)

      scope.save  = ->
        scope.editing = false
        # invoke onBlur callback if any
        if scope.callback
          exp = $parse(scope.callback)
          exp(scope)

      inputElement.bind "blur", (e) ->
        scope.save()
        scope.$apply() unless scope.$$phase
  ])
