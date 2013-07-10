if typeof String::trim isnt "function"
  String::trim = ->
    @replace /^\s+|\s+$/g, ""
