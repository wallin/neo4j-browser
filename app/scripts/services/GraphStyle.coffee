'use strict';

angular.module('neo4jApp.services')
  .provider 'GraphStyle', [->
    provider = @

    # Build in style
    @defaultStyle =
      'node':
        'fill': '#C3C6C6'
        'stroke': '#B7B7B7'
        'stroke-width': '2px'
        'color': '#fff'
        'caption': '{id}'
      'relationship':
        'fill': 'none'
        'stroke': '#e3e3e3'
        'stroke-width': '1.5px'

    # Default color scheme that user can choose from
    @defaultColors = [
      { fill: '#C3C6C6', stroke: '#B7B7B7' }
      { fill: '#30B6AF', stroke: '#46A39E' }
      { fill: '#AD62CE', stroke: '#9453B1' }
      { fill: '#FF6C7C', stroke: '#EB5D6C' }
      { fill: '#F25A29', stroke: '#DC4717' }
      { fill: '#FCC940', stroke: '#F3BA25' }
      { fill: '#4356C0', stroke: '#3445A2' }
    ]

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
      constructor: (@selector, @props) ->

      matches: (selector) ->
        if @selector.tag is selector.tag
          if @selector.klass is selector.klass or not @selector.klass
            return yes
        return no

      matchesExact: (selector) ->
        @selector.tag is selector.tag and @selector.klass is selector.klass

    class StyleElement
      constructor: (selector, @data) ->
        @selector = selector
        @props = {}

      applyRules: (rules) ->
        # Apply default style first
        if provider.defaultStyle[@selector.tag]
          angular.extend(@props, provider.defaultStyle[@selector.tag])
        # Two passes
        applied = no
        for rule in rules
          if rule.matchesExact(@selector)
            applied = yes
            angular.extend(@props, rule.props)
            break
        if not applied
          angular.extend(@props, rule.props) for rule in rules when rule.matches(@selector)

        @

      get: (attr) ->
        @props[attr] or ''


    class GraphStyle
      constructor: (@storage) ->
        @rules = []
        try
          @loadRules(@storage?.get('grass'))
        catch e

      #
      # Methods for calculating applied style for elements
      #
      calculateStyle: (selector, data) ->
        new StyleElement(selector, data).applyRules(@rules)

      forNode: (node = {}) ->
        @calculateStyle(@nodeSelector(node), node)

      forRelationship: (rel) ->
        @calculateStyle(@relationshipSelector(rel), rel)


      #
      # Methods for getting and modifying rules
      #
      changeForNode: (node, props) ->
        rule = @findNodeRule(node)
        if not rule?
          rule = new StyleRule(@nodeSelector(node), {})
          @rules.push(rule)
        angular.extend(rule.props, props)
        @persist()
        rule

      destroyRule: (rule) ->
        idx = @rules.indexOf(rule)
        @rules.splice(idx, 1) if idx?
        @persist()

      findNodeRule: (node) ->
        selector = @nodeSelector(node)
        rule = r for r in @rules when r.matchesExact(selector)
        rule

      #
      # Selector helpers
      #
      nodeSelector: (node = {}) ->
        selector = 'node'
        if node.labels?.length > 0
          selector += ".#{node.labels[0]}"
        new Selector(selector)

      relationshipSelector: (rel) ->
        selector = 'relationship'
        selector += ".#{rel.type}" if rel.type?
        new Selector(selector)

      #
      # Import/export
      #

      import: (string) ->
        try
          rules = @parse(string)
          @loadRules(rules)
          @persist()
        catch
          return

      loadRules: (data) ->
        return @ unless angular.isObject(data)
        @rules.length = 0
        for rule, props of data
          @rules.push(new StyleRule(new Selector(rule), angular.copy(props)))
        @

      parse: (string)->
        # TODO
        chars = string.split('')
        insideString = no
        insideProps = no
        keyword = ""
        props = ""

        rules = {}

        for c in chars
          skipThis = yes
          switch c
            when "{"
              if not insideString
                insideProps = yes
              else
                skipThis = no
            when "}"
              if not insideString
                insideProps = no
                rules[keyword] = props
                keyword = ""
                props = ""
              else
                skipThis = no
            when "'", "\"" then insideString ^= true
            else skipThis = no

          continue if skipThis

          if insideProps
            props += c
          else
            keyword += c unless c.match(/[\s\n]/)

        for k, v of rules
          rules[k] = {}
          for prop in v.split(';')
            [key, val] = prop.split(':')
            continue unless key and val
            rules[k][key?.trim()] = val?.trim()

        rules

      persist: ->
        @storage?.add('grass', JSON.stringify(@toSheet()))

      toSheet: ->
        sheet = {}
        sheet[rule.selector.toString()] = rule.props for rule in @rules
        sheet

      toString: ->
        str = ""
        for r in @rules
          str += r.selector.toString() + " {\n"
          for k, v of r.props
            v = "'#{v}'" if k == "caption"
            str += "  #{k}: #{v};\n"
          str += "}\n\n"
        str

      #
      # Misc.
      #
      defaultColors: -> provider.defaultColors
      interpolate: (str, data) ->
        # Supplant
        # http://javascript.crockford.com/remedial.html
        str.replace(
          /\{([^{}]*)\}/g,
          (a, b) ->
            r = data[b] or data.id
            return if (typeof r is 'string' or typeof r is 'number') then r else a
        )

    @$get = ['localStorageService', (localStorageService) ->
      new GraphStyle(localStorageService)
    ]
    @
  ]


