module.exports = class Grid

  constructor: (startX, startY, expanseX, expanseY) ->

    this.height = canvas.height
    this.width = canvas.width

    this.left = startX
    this.right = this.left + this.width
    this.top = startY
    this.bottom = startY + this.height

    this.expanseX = expanseX
    this.expanseY = expanseY

    this.centerX = Math.floor(this.left + (this.width / 2) - 12)
    this.centerY = Math.floor(this.top + (this.height / 2) - 13)

    if this.centerY % 32 != 0
      this.centerY -= this.centerY % 32
    if this.centerX % 32 != 0
      this.centerX -= this.centerX % 32

    this.isCycling = false
    this.cycleProgress = 0

    this.cycleTarget = {
      startLeft: 0
      startRight: 0
      left: 0
      top: 0
    }

    this.vx = 0
    this.vy = 0

    @bind()

  bind: =>

    window.addEventListener "resize", @center

  center: =>

    newHeight = window.innerHeight
    newWidth = window.innerWidth

    adjustX = Math.floor((@width - newWidth) / 2)
    adjustY = Math.floor((@height - newHeight) / 2)

    @top += adjustY
    @bottom = @top + newHeight
    @left += adjustX
    @right = @left + newWidth

    @centerX += adjustX
    @centerY += adjustY

    @height = newHeight
    @width = newWidth

  getRelXy: (x, y, h, w) =>

    relx = @getRelX(x)
    rely = @getRelY(y)

    relxy = {}

    if relx + w > 0 && relx < @width
      relxy.x = relx
    else
      return null

    if rely + h > 0 && rely < @height
      relxy.y = rely
    else
      return null

    return relxy

  getRelX: (x) =>

    return x - @left

  getRelY: (y) =>

    return y - @top

  update: (dt) =>

    if input.direction && !@isCycling

      @isCycling = true

      @vx = {
        "left": -32
        "right": 32
      }[input.direction] || 0
      
      @vy = {
        "up": -32
        "down": 32
      }[input.direction] || 0

      @cycleTarget.left = @left + @vx
      @cycleTarget.top = @top + @vy
      @cycleTarget.startLeft = @left
      @cycleTarget.startTop = @top

      atLeftEdge = @cycleTarget.left <= 0 && @vx < 0
      atRightEdge = @cycleTarget.left + @width >= @expanseX && @vx > 0
      atTopEdge = @cycleTarget.top <= 0 && @vy < 0
      atBottomEdge = @cycleTarget.top + @height >= @expanseY && @vy > 0

      if atLeftEdge || atRightEdge || atTopEdge || atBottomEdge || !map.Link.canMove()
        @vx = @vy = 0
        @cycleTarget.left = @left
        @cycleTarget.top = @top

      isPastLeft = @vx > 0 && map.Link.position.x < @centerX
      isPastRight = @vx < 0 && map.Link.position.x > @centerX
      isPastTop = @vy < 0 && map.Link.position.y > @centerY
      isPastBottom = @vy > 0 && map.Link.position.y < @centerY

      if isPastLeft || isPastRight || isPastTop || isPastBottom
        @vx = @vy = 0
        @cycleTarget.left = @left
        @cycleTarget.top = @top

    if @isCycling
      step = dt / 360
      @cycleProgress += step

      @top = Math.floor(@cycleTarget.startTop + @vy * @cycleProgress)
      @left = Math.floor(@cycleTarget.startLeft + @vx * @cycleProgress)
      @bottom = @top + @height
      @right = @left + @width

      if @cycleProgress >= 1
        @top = @cycleTarget.top
        @bottom = @top + @height
        @left = @cycleTarget.left
        @right = @left + @width
        @centerX += @vx
        @centerY += @vy
        @isCycling = false
        @cycleProgress = 0

        # console.log "left: " + @left + ", top: " + @top
    


