# * * * * * * * * * * * * * * * * * * * * * * * *
# Extend
# ------
# jQuery's extend function adapted to use Meteor's Match lib
# also converted to CoffeeScript...I know, right?!
# * * * * * * * * * * * * * * * * * * * * * * * *
@extend = ->
  options = undefined
  name = undefined
  src = undefined
  copy = undefined
  copyIsArray = undefined
  clone = undefined
  target = arguments[0] or {}
  i = 1
  length = arguments.length
  deep = false

  # Handle a deep copy situation
  if typeof target is "boolean"
    deep = target
    target = arguments[1] or {}

    # skip the boolean and the target
    i = 2

  # Handle case when target is a string or something (possible in deep copy)
  target = {}  if typeof target isnt "object" and not Match.test target, Function

  # extend jQuery itself if only one argument is passed
  if length is i
    target = this
    --i
  while i < length

    # Only deal with non-null/undefined values
    if (options = arguments[i])?

      # Extend the base object
      for name of options
        src = target[name]
        copy = options[name]

        # Prevent never-ending loop
        continue  if target is copy

        # Recurse if we're merging plain objects or arrays
        if deep and copy and (Match.test copy, Object or (copyIsArray = Match.test copy, Array))
          if copyIsArray
            copyIsArray = false
            clone = (if src and Match.test src, Array then src else [])
          else
            clone = (if src and Match.test src, Object then src else {})

          # Never move original objects, clone them
          target[name] = __extend(deep, clone, copy)

        # Don't bring in undefined values
        else target[name] = copy if copy isnt undefined
    i++

  # Return the modified object
  target
