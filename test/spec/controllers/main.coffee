'use strict'

describe 'Controller: MainCtrl', () ->

  # load the controller's module
  beforeEach module 'neo4jApp.services', 'neo4jApp.controllers'

  viewService = {}
  MainCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope, _viewService_) ->
    scope = $rootScope.$new()
    viewService = _viewService_
    MainCtrl = $controller 'MainCtrl', { $scope: scope }
    scope.$digest()

  describe 'createFolder:', ->
    it 'should return the created folder', ->
      folder = scope.createFolder()
      expect(folder instanceof viewService.Folder).toBeTruthy()

    it 'should add the created folder the folders', ->
      len = scope.folders.length
      scope.createFolder()
      expect(scope.folders.length).toBe len+1

    it 'should create a folder that is expanded by default', ->
      folder = scope.createFolder()
      expect(folder.expanded).toBeTruthy()

  describe 'createView:', ->
    it 'should return the created view', ->
      view = scope.createView()
      expect(view instanceof viewService.View).toBeTruthy()

    it 'should create a new view and add it to the views', ->
      len = scope.views.length
      scope.createView()
      expect(scope.views.length).toBe len+1

    it 'should create a view without a folder', ->
      view = scope.createView()
      expect(view.folder).toBeFalsy()

  describe 'copyView:', ->
    it 'should duplicate a view with a new id', ->
      view = scope.createView()
      view2 = scope.copyView(view)
      expect(view2.id).not.toBe view.id

  describe 'removeFolder:', ->
    it 'should remove a folder from folders', ->
      len = scope.folders.length
      folder = scope.createFolder()
      scope.removeFolder(folder)
      len2 = scope.folders.length
      expect(len2).toEqual(len)

  describe 'toggleStar', ->
    it 'should clear the folder for a view when unstarred', ->
      view = scope.createView(starred: yes, folder: 'folder')
      scope.toggleStar(view)
      expect(view.folder).toBeFalsy()

