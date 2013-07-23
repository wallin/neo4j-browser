'use strict'

angular.module('neo4jApp.controllers', [])
angular.module('neo4jApp.directives', [])
angular.module('neo4jApp.filters', [])
angular.module('neo4jApp.services', ['LocalStorageModule', 'neo4jApp.settings'])

app = angular.module('neo4jApp', [
  'neo4jApp.controllers'
  'neo4jApp.directives'
  'neo4jApp.filters'
  'neo4jApp.services'
  'ui.bootstrap.dialog'
  'ui.bootstrap.dropdownToggle'
  'ui.bootstrap.position'
  'ui.bootstrap.tooltip'
  'ui.codemirror'
  'ui.sortable'
  'angularMoment'
])
