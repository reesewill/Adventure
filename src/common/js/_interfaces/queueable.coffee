Drawable = require("./drawable.coffee")

module.exports = class Queueable extends Drawable

  constructor: (url,x,y,h,w,vx,vy) ->

    super(url,x,y,h,w)

    this.velocity = {
      x:vx || 0,
      y:vy || 0
    }

    this.isCycling = false
    this.cycleProgress = 0
    this.moveOnce = false

    this.cycleTarget = {
      x: 0
      y: 0
      startX: 0
      startY: 0
    }

  move: (dt) =>

    if (@velocity.x || @velocity.y) && !@isCycling
      @isCycling = true

      @cycleTarget.startX = @position.x
      @cycleTarget.startY = @position.y
      @cycleTarget.x = @position.x + @velocity.x
      @cycleTarget.y = @position.y + @velocity.y

      if !map.isTileOpen(@cycleTarget.x, @cycleTarget.y)
        @velocity.x = 0
        @velocity.y = 0
        @cycleTarget.x = @cycleTarget.startX
        @cycleTarget.y = @cycleTarget.startY

        # console.log @name + " cleared"

    if @isCycling
      step = dt / 360
      @cycleProgress += step

      @position.x = Math.floor(@cycleTarget.startX + (@velocity.x * @cycleProgress))
      @position.y = Math.floor(@cycleTarget.startY + (@velocity.y * @cycleProgress))

      # console.log @velocity.x * @cycleProgress

      if @cycleProgress >= 1
        
        @isCycling = false
        @cycleProgress = 0

        @position.x = @cycleTarget.x
        @position.y = @cycleTarget.y

        if @moveOnce
          @velocity.x = 0
          @velocity.y = 0

          @updateMovement()

  updateMovement: () =>  

        # console.log "x: " + @position.x + ", y: " + @position.y
    
    