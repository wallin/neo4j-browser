'use strict';

angular.module('neo4jApp')
  .directive('editInPlace', ['$timeout', ($timeout) ->
    restrict: "A"
    scope:
      value: "=editInPlace"
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
        console.log "saved"

      inputElement.bind "blur", (e) ->
        scope.save()
        scope.$apply()
  ])
