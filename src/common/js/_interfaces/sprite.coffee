Queueable = require("./queueable.coffee")

module.exports = class Sprite extends Queueable

  constructor: (url,x,y,h,w,vx,vy,frames,duration,isOn,isOnce,isRepeatable) ->

    super(url,x,y,h,w,vx,vy)

    @frames = frames
    @duration = duration
    @isOnce = isOnce
    @isOn = isOn
    @isRepeatable = isRepeatable

    @index = 0

    @sx = 0
    @sy = 0

    @cycles = 0
    @isSpriting = false
    @spriteProgress = 0

  animate: (dt) =>

    #if cycle has started, increment
    if @isSpriting
      @spriteProgress += dt

      # increment the frame if time has incremented past it
      if @duration / @frames * (@index + 1) <= @spriteProgress
        
        # if this is the last frame
        if @index + 1 == @frames
          #repeat if not a one-time action
          if !@isOnce
            @spriteProgress = 0
            @setFrame(0)

          else
            #if is a repeatable action check to see if should continue
            if @isRepeatable
              if !@isOn
                @isSpriting = false
              #if should continue, increment cycles, call the callback
              #and reset the frame and progress
              else
                @cycles++
                @handleRepeat(@cycles)

              @spriteProgress = 0
              @setFrame(0)

            #if not repeatable and just a one-off, exit
            else
              @isSpriting = false
        
        # increment frame if there are more to show
        else
          @setFrame(@index + 1)
      # otherwise redraw the same frame
      else
        @setFrame(@index)
    
    #restart cycle
    else
      if @isOn
        @cycles = 0
        @isSpriting = true
        @spriteProgress = 0
      @setFrame(0)

  handleInput: () =>

  handleRepeat: () =>

  setFrame: (index) =>

    coords = grid.getRelXy(@position.x, @position.y, @size.h, @size.w)
      
    if coords
      ctx.save()

      @sx = index * @size.w

      ctx.drawImage(@image, @sx, @sy, @size.w, @size.h, coords.x, coords.y, @size.w, @size.h)

      @index = index

      ctx.restore()

  step: (dt) =>

    @handleInput()
    @move(dt)
    @animate(dt)
    
    

    
