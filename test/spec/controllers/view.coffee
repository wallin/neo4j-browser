'use strict'

describe 'Controller: ViewCtrl', () ->

  # load the controller's module
  beforeEach module 'neo4jApp.services', 'neo4jApp.controllers'

  viewService = {}
  ViewCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope, _viewService_) ->
    scope = $rootScope.$new()
    viewService = _viewService_
    viewService.clear()
    ViewCtrl = $controller 'ViewCtrl', { $scope: scope }
    scope.$digest()

  it 'should change location to the next view on "views:next" event', inject ($location)->
    scope.createView()
    previousLocation = $location.path()
    previousView = scope.currentView
    scope.$broadcast 'views:next'
    expect(scope.currentView).not.toBe previousView
    expect($location.path()).not.toBe previousLocation

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

  describe 'removeFolder:', ->
    it 'should remove a folder from folders', ->
      len = scope.folders.length
      folder = scope.createFolder()
      scope.removeFolder(folder)
      len2 = scope.folders.length
      expect(len2).toEqual(len)

    it 'should remove all view in the folder being deleted', ->
      folder = scope.createFolder()
      scope.createView(folder: folder.id)
      scope.removeFolder(folder)
      expect(scope.views.where(folder: folder.id).length).toBe 0

  describe 'toggleStar', ->
    it 'should clear the folder for a view when unstarred', ->
      view = scope.createView(starred: yes, folder: 'folder')
      scope.toggleStar(view)
      expect(view.folder).toBeFalsy()
