module.exports = do ->

  dirs = []
  dir = null

  dirmap = {
    "a": "left"
    "s": "down"
    "d": "right"
    "w": "up"
  }
  actionmap = {
    "space": "attack"
  }

  init = () ->

    window.input = {
      direction: ""
      actions: {
        "attack": false
      }
    }

    bind()

  bind = () ->

    window.addEventListener("keydown", handleKeydown)
    window.addEventListener("keyup", handleKeyup)
    # window.addEventListener("resize", @setPosition)

  handleKeyup = (e) ->

    key = getKey(e)
    index = dirs.indexOf(key)

    #directions
    if index >= 0

      dirs.splice(index,1)

      if dirs.length
        lastkey = dirs[dirs.length - 1]
        dir = lastkey
      else
        dir = null

      input.direction = dirmap[dir]

    #actions
    if typeof actionmap[key] != "undefined"
      input.actions[actionmap[key]] = false

    return false

  handleKeydown = (e) ->

    key = getKey(e)

    if typeof dirmap[key] != "undefined" && key != dir
      dir = key
      dirs.push key
      input.direction = dirmap[dir]

    if typeof actionmap[key] != "undefined"
      input.actions[actionmap[key]] = true

  
    return false

  init()