'use strict';

angular.module('neo4jApp')
  .controller('directive.TerminalCtrl', [
    '$scope',
    'viewService',
    ($scope, viewService) ->
      term = $scope.terminal = viewService

      # TODO: improve
      idx = 1
      $scope.keyHandler = (e) ->
        switch e.keyCode
          when 38
            term.input = term.history[term.history.length-idx++]
            e.preventDefault()
          when 40
            term.input = term.history[term.history.length-idx--]
            e.preventDefault()
          when 13
            idx = 1
  ])

angular.module('neo4jApp')
  .directive('terminal', [
    'viewService',
    (viewService) ->
      controller: 'directive.TerminalCtrl'
      restrict: 'EA'
      replace: yes
      scope: {}
      template: """
        <div class="terminal">
          <div class="terminal-output">
            <div ng-repeat="output in terminal.buffer">
              <pre>{{output}}</pre>
            </div>
          </div>
          <form class="cmd" ng-submit="terminal.run()">
            {{terminal.prompt}}<input ng-model="terminal.input" keydown="keyHandler($event)"></input>
          </form>
        </div>
      """
  ])
