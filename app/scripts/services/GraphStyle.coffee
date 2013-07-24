'use strict';

angular.module('neo4jApp.services')
  .factory 'GraphStyle', [() ->

    class Selector
      constructor: (selector) ->
        [@tag, @klass] = if selector.indexOf('.') > 0
          selector.split('.')
        else
          [selector, undefined]

    class StyleRule
      constructor: (selector, @props) ->
        @selector = new Selector(selector)

      matches: (element) ->
        if @selector.tag is element.selector.tag
          if @selector.klass is element.selector.klass or not @selector.klass
            return yes
        return no

    class StyleElement
      constructor: (selector, @data) ->
        @selector = new Selector(selector)
        @props = {}

      applyRules: (rules) ->
        for rule in rules
          angular.extend(@props, rule.props) if rule.matches(@)

        @

      get: (attr) ->
        @props[attr] or ''

    styledata =
      'node':
        'fill': '#1ABC9C'
        'stroke': '#fff'
        'stroke-width': '2px'
        'color': '#000'
        'caption': 'Node {id}'
      'node.Actor':
        'fill': '#000'
        'caption': 'Actor'
      'node.Movie':
        'fill': '#00f'
        'caption': 'Movie'
      'relationship':
        'fill': 'none'
        'stroke': '#BDC3C7'
        'stroke-width': '1.5px'
      'relationship.FRIEND':
        'stroke': '#00f'

    class GraphStyle
      constructor: -> @rules = []
      forNode: (node = {}) ->
        selector = 'node'
        selector += ".#{node.type}" if node.type?
        @select(selector, node)
      forRelationship: (rel) ->
        selector = 'relationship'
        selector += ".#{rel.type}" if rel.type?
        @select(selector, rel)
      select: (selector, data) -> new StyleElement(selector, data).applyRules(@rules)
      loadSheet: (data) ->
        @rules = for rule, props of data
          new StyleRule(rule, props)
        @
      interpolate: (str, data) ->
        # Supplant
        # http://javascript.crockford.com/remedial.html
        str.replace(
          /\{([^{}]*)\}/g,
          (a, b) ->
            r = data[b]
            return typeof r is 'string' or if typeof r is 'number' then r else a
        )

    new GraphStyle().loadSheet(styledata)
  ]


