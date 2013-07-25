'use strict';
angular.module('neo4jApp.directives')
  .directive('inspector', [
    '$dialog'
    ($dialog) ->
      restrict: 'EA'
      terminal: yes
      link: (scope, element, attrs) ->
        opts =
          backdrop: no
          dialogClass: 'inspector'
          dialogFade: yes
          keyboard: no
          template: element.html()
          resolve: { $scope: -> scope }

        dialog = $dialog.dialog(opts)
        dialog.backdropEl.remove()
        element.remove()

        shownExpr = attrs.inspector or attrs.show
        scope.$watch shownExpr, (val) ->
          if val
            dialog.open()
          else
            dialog.close() if dialog.isOpen()
  ])
