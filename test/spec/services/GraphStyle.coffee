'use strict'

describe 'Service: GraphStyle', () ->

  # load the service's module
  beforeEach module 'neo4jApp.services'

  styledata =
    'node':
      'color': '#1ABC9C'
      'border-color': '#aaa'
      'border-width': '2px'
      'caption': 'Node'
    'node.Actor':
      'border-color': '#fff'
    'relationship':
      'color': '#BDC3C7'

  grass = """
relationship {
  color: none;
  border-color: #e3e3e3;
  border-width: 1.5px;
}

node.User {
  color: #FF6C7C;
  border-color: #EB5D6C;
  caption: '{name}';
}

node {
  diameter: 40px;
  color: #FCC940;
  border-color: #F3BA25;
}
"""

  # instantiate service
  GraphStyle = {}
  beforeEach inject (_GraphStyle_) ->
    GraphStyle = _GraphStyle_
    GraphStyle.loadRules(styledata)

  describe 'forNode: ', ->
    it 'should be able to get parameters for "node" rules', ->
      expect(GraphStyle.forNode().get('color')).toBe('#1ABC9C')
      expect(GraphStyle.forNode().get('diameter')).toBe('40px')

    it 'should inherit rules from base node rule', ->
      expect(GraphStyle.forNode(labels: ['Movie']).get('border-color')).toBe('#aaa')

    it 'should not match "node with type1" rule when no type2 is specified', ->
      expect(GraphStyle.forNode(labels: ['Movie']).get('border-color')).not.toBe('#fff')

    it 'should be able to get parameters for "node with type" rules', ->
      expect(GraphStyle.forNode(labels: ['Actor']).get('border-color')).toBe('#fff')

  describe 'parse:', ->
    it 'should parse rules from grass text', ->
      expect(GraphStyle.parse(grass).node).toEqual(jasmine.any(Object))
