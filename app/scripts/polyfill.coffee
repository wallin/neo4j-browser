if typeof String::trim isnt "function"
  String::trim = ->
    @replace /^\s+|\s+$/g, ""

Object.keys = Object.keys or (o, k, r) ->
  # object
  # key
  # result array

  # initialize object and result
  r = []

  # iterate over object keys
  for k of o

    # fill result array with non-prototypical keys
    r.hasOwnProperty.call(o, k) and r.push(k)

  # return result
  r


if typeof String::endsWith isnt "function"
  String::endsWith = (suffix) ->
    @indexOf(suffix, @length - suffix.length) isnt -1

if typeof String::beginsWith isnt "function"
  String::beginsWith = (prefix) ->
    @indexOf(prefix) is 0
