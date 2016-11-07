Sprite = require("../_interfaces/sprite.coffee")

module.exports = class Link extends Sprite

  constructor: () ->

    super("/common/images/link.png",grid.centerX,grid.centerY,26,24,0,0,12,360,false,true,true)

    @sy = 64

  canMove: () =>

    if input.direction == "left"
      vx = -32
      vy = 0
    else if input.direction == "right"
      vx = 32
      vy = 0
    else if input.direction == "up"
      vy = -32
      vx = 0
    else if input.direction == "down"
      vy = 32
      vx = 0

    cycleTarget = {}
    cycleTarget.x = @position.x + vx
    cycleTarget.y = @position.y + vy

    return map.isTileOpen(cycleTarget.x, cycleTarget.y)

  handleInput: () =>

    if input.direction && !@isCycling
      @sy = @animmap[input.direction]
      @isOn = true

      if input.direction == "left"
        @velocity.x = -32
        @velocity.y = 0
      else if input.direction == "right"
        @velocity.x = 32
        @velocity.y = 0
      else if input.direction == "up"
        @velocity.y = -32
        @velocity.x = 0
      else if input.direction == "down"
        @velocity.y = 32
        @velocity.x = 0

    else if !input.direction
      @isOn = false

      if !@isCycling
        @velocity = {
          x: 0
          y: 0
        }


  handleRepeat: (cycles) =>

    # dir = keymap[@key]
    dir = input.direction

    if cycles % 2 == 1
      dir += "-alt"

    @sy = @animmap[dir]

  animmap: {
    "left": 97
    "down": 64
    "right": 33
    "up": 0
    "down-alt": 192
    "left-alt": 224
    "right-alt": 160
    "up-alt": 129
  }