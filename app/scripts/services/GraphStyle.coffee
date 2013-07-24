'use strict';

angular.module('neo4jApp.services')
  .factory 'GraphStyle', ['$rootScope', ($rootScope) ->

    class Selector
      constructor: (selector) ->
        [@tag, @klass] = if selector.indexOf('.') > 0
          selector.split('.')
        else
          [selector, undefined]

      toString: ->
        str = @tag
        str += ".#{@klass}" if @klass?
        str

    class StyleRule
      constructor: (selector, @props) ->
        @selector = new Selector(selector)

      matches: (selector) ->
        if @selector.tag is selector.tag
          if @selector.klass is selector.klass or not @selector.klass
            return yes
        return no

      matchesExact: (selector) ->
        @selector.tag is selector.tag and @selector.klass is selector.klass

    class StyleElement
      constructor: (selector, @data) ->
        @selector = new Selector(selector)
        @props = {}

      applyRules: (rules) ->
        for rule in rules
          angular.extend(@props, rule.props) if rule.matches(@selector)

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
      select: (selector, data) -> new StyleElement(selector, data).applyRules(@rules)

      changeForNode: (node, data) ->
        sel = new Selector(@nodeSelector(node))
        rule = r for r in @rules when r.matchesExact(sel)
        if not rule?
          rule = new StyleRule(sel, {})
          @rules.push(rule)

        angular.extend(rule, data)
        $rootScope.$broadcast 'GraphStyle:changed'
        rule

      forNode: (node = {}) ->
        @select(@nodeSelector(node), node)

      forRelationship: (rel) ->
        selector = 'relationship'
        selector += ".#{rel.type}" if rel.type?
        @select(selector, rel)

      nodeSelector: (node) ->
        selector = 'node'
        selector += ".#{node.type}" if node.type?
        selector

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

      toString: ->
        str = ""
        for r in @rules
          str += "\n" + r.selector.toString() + "{\n"
          for k, v of r.props
            str += "  #{k}: #{v}\n"
          str += "}"
        str

    new GraphStyle().loadSheet(styledata)
  ]


