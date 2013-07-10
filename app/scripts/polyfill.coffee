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
