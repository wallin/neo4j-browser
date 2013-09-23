'use strict'

describe 'Service: Editor', ->

  # load the service's module
  beforeEach module 'neo4jApp.services'

  # instantiate service
  Document = {}
  Editor = {}
  beforeEach inject (_Document_, _Editor_) ->
    Document = _Document_
    Editor = _Editor_
    Document.reset([{
      id: 1
      content: 'test content'
    }])

  describe '#loadDocument', ->
    beforeEach ->
      Editor.loadDocument(1)

    it 'should load content from a document into editor', ->
      expect(Editor.content).toBe 'test content'

    it 'should load document ID from a document', ->
      expect(Editor.documentId).toBe 1

  describe '#saveDocument', ->
    it 'should not create a new document with blank input', ->
      len = Document.length
      Editor.content = '    '
      Editor.saveDocument()
      expect(Document.length).toBe 1

    it 'should create a new document if no document was loaded', ->
      len = Document.length
      Editor.content = 'second document'
      Editor.saveDocument()
      expect(Document.length).toBe len+1

    it 'should set document ID after a new document was created', ->
      Editor.content = "new document"
      Editor.saveDocument()
      expect(Editor.documentId).toBeTruthy()

    it 'should update an existing document if it was loaded', ->
      len = Document.length
      Editor.loadDocument 1
      Editor.content = "updated document"
      Editor.saveDocument()
      expect(Document.length).toBe 1
      expect(Document.get(1).content).toBe('updated document')

  describe '#historySet', ->
    it 'should clear the current document id', ->
      Editor.history = ['first', 'second']
      Editor.loadDocument 1
      expect(Editor.documentId).toBeTruthy()
      Editor.historySet(0)
      expect(Editor.documentId).toBeFalsy()
