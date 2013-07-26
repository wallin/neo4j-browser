'use strict'

describe 'Service: GraphStyle', () ->

  # load the service's module
  beforeEach module 'neo4jApp.services'

  styledata =
    'node':
      'fill': '#1ABC9C'
      'stroke': '#aaa'
      'stroke-width': '2px'
      'caption': 'Node'
    'node.Actor':
      'stroke': '#fff'
    'relationship':
      'fill': '#BDC3C7'

  grass = """
relationship {
  fill: none;
  stroke: #e3e3e3;
  stroke-width: 1.5px;
}

node.User {
  fill: #FF6C7C;
  stroke: #EB5D6C;
  caption: '{name}';
}

node {
  fill: #FCC940;
  stroke: #F3BA25;
}
"""

  # instantiate service
  GraphStyle = {}
  beforeEach inject (_GraphStyle_) ->
    GraphStyle = _GraphStyle_
    GraphStyle.loadRules(styledata)

  describe 'forNode: ', ->
    it 'should be able to get parameters for "node" rules', ->
      expect(GraphStyle.forNode().get('fill')).toBe('#1ABC9C')

    it 'should inherit rules from base node rule', ->
      expect(GraphStyle.forNode(labels: ['Movie']).get('stroke')).toBe('#aaa')

    it 'should not match "node with type1" rule when no type2 is specified', ->
      expect(GraphStyle.forNode(labels: ['Movie']).get('stroke')).not.toBe('#fff')

    it 'should be able to get parameters for "node with type" rules', ->
      expect(GraphStyle.forNode(labels: ['Actor']).get('stroke')).toBe('#fff')

  describe 'parse:', ->
    it 'should parse rules from grass text', ->
      expect(GraphStyle.parse(grass).node).toEqual(jasmine.any(Object))
