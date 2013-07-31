'use strict'

angular.module('neo4jApp.controllers', ['neo4jApp.utils'])
angular.module('neo4jApp.directives', ['ui.bootstrap.dialog'])
angular.module('neo4jApp.filters', [])
angular.module('neo4jApp.services', ['LocalStorageModule', 'neo4jApp.settings'])

app = angular.module('neo4jApp', [
  'neo4jApp.controllers'
  'neo4jApp.directives'
  'neo4jApp.filters'
  'neo4jApp.services'
  'neo4jApp.animations'
  'ui.bootstrap.dropdownToggle'
  'ui.bootstrap.position'
  'ui.bootstrap.tooltip'
  'ui.bootstrap.popover'
  'ui.bootstrap.tabs'
  'ui.codemirror'
  'ui.sortable'
  'angularMoment'
])
