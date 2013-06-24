'use strict';

angular.module('neo4jApp')
  .directive('terminal', [
    'terminalService',
    (terminalService) ->
      restrict: 'EA'
      link: (scope, element, attrs) ->
        $(element).terminal((command, term) ->
          terminalService.run(command).success(->
            term.echo(terminalService.result)
          )
          return
        , {greetings: ''})
  ])
