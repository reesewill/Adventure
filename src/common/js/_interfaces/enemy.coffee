Sprite = require("./sprite.coffee")

module.exports = class Enemy extends Sprite

  constructor: (url,x,y,h,w,dir,duration) ->

    super(url,x,y,h,w,0,0,3,duration || 360,false,false,false)

    this.setDirection(dir || "down")
    @isOn = true
    @moveOnce = true

    @updateMovement()

  canMove: () =>

    if @direction == "left"
      vx = -32
      vy = 0
    else if @direction == "right"
      vx = 32
      vy = 0
    else if @direction == "up"
      vy = -32
      vx = 0
    else if @direction == "down"
      vy = 32
      vx = 0

    cycleTarget = {}
    cycleTarget.x = @position.x + vx
    cycleTarget.y = @position.y + vy

    return map.isTileOpen(cycleTarget.x, cycleTarget.y)

  updateMovement: () =>

    t = (Math.random() * 400) + 600
    _this = this

    setTimeout((() ->

      dir = _this.getRandomDirection()

      _this.setDirection(dir)

      if _this.direction == "left"
        _this.velocity.x = -32
        _this.velocity.y = 0
      else if _this.direction == "right"
        _this.velocity.x = 32
        _this.velocity.y = 0
      else if _this.direction == "up"
        _this.velocity.y = -32
        _this.velocity.x = 0
      else if _this.direction == "down"
        _this.velocity.y = 32
        _this.velocity.x = 0

    ), t)

  getRandomDirection: () =>

    # dirs = []

    # if @canMove("left")
    #   dirs.push "left"
    # if @canMove("right")
    #   dirs.push "right"
    # if @canMove("down")
    #   dirs.push "down"
    # if @canMove("up")
    #   dirs.push "up"

    # dir = dirs[Math.floor(Math.random() * dirs.length)]

    # return dir

    return @direction

  setDirection: (dir) =>

    @direction = dir

    @sy = @animmap[dir]

  animmap: {
    "left": 32
    "down": 0
    "right": 64
    "up": 92
  }