Grid = require("./grid.coffee")
Link = require("../_entities/link.coffee")
Interaction = require("./interaction.coffee")

module.exports = class Map

  constructor: (map) ->

    this._isLoaded = false
    this.url = map

    $.ajax 
      dataType: "json"
      type: "get"
      url: "/common/js/maps/" + this.url
      success: @init
  
  drawTile: (type, x, y) =>

    coords = grid.getRelXy(x, y, 32, 32)

    image = @textures[type]

    if coords
      ctx.save()
      ctx.drawImage(image, coords.x, coords.y)
      ctx.restore()

  getBlockX: (x) =>

    if x % 32 != 0
      x -= x % 32

    return Math.floor(x / (32 * 50))

  getBlockY: (y) =>

    if y % 32 != 0
      y -= y % 32

    return Math.floor(y / (32 * 50))

  getOffsetX: (x) =>

    if x % 32 != 0
      x -= x % 32

    return (x % (32 * 50)) / 32

  getOffsetY: (y) =>

    if y % 32 != 0
      y -= y % 32

    return (y % (32 * 50)) / 32

  getTile: (x,y) =>

    blockY = @getBlockY(y)
    offsetY = @getOffsetY(y)
    blockX = @getBlockX(x)
    offsetX = @getOffsetX(x)

    return @data[blockY][blockX][offsetY][offsetX]

  isEntityAtTile: (x,y) =>

    isAtTile = 0 <= sprites.findIndex((val) -> 
      isAtCurrentLoc = val.position.x == x && val.position.y == y
      isAtFutureLoc = false

      if val.cycleTarget.x != val.position.x && val.cycleTarget.y != val.position.y
        isAtFutureLoc = val.cycleTarget.x == x && val.cycleTarget.y == y

      return isAtCurrentLoc || isAtFutureLoc
    )

    return isAtTile

  isTileOpen: (x,y) =>

    if x >= grid.expanseX || x <= 0 || y >= grid.expanseY || y <= 0
      return false

    if @isEntityAtTile(x,y)
      return false

    tile = @getTile(x,y)

    return open = {
      0: true
      1: false
      2: true
      3: true
      9: true
    }[tile]

  init: (data) =>

    @data = data
    height = @data.length
    width = @data[0].length

    window.grid = new Grid(128, 384, height * 32 * 50, width * 32 * 50)

    @Link = new Link()

    this.interaction = new Interaction(@url)

    rsc.load([
      "/common/images/grass.png",
      "/common/images/tree.png",
      "/common/images/flower.png",
      "/common/images/pavement.png",
      "/common/images/tile-pink.png"
    ])

    sprites.push @Link

    _this = this

    rsc.onReady ->
      _this.textures = {
        0: rsc.get("/common/images/grass.png")
        1: rsc.get("/common/images/tree.png")
        2: rsc.get("/common/images/flower.png")
        3: rsc.get("/common/images/pavement.png")
        9: rsc.get("/common/images/tile-pink.png")
      }
      _this._isLoaded = true

  isLoaded: () =>

    return @_isLoaded

  update: () =>

    y = grid.top

    # make sure that we are starting at a cell space
    # (even if we are currently in the middle of a shift)
    if y % 32 != 0
      y -= y % 32

    while(y < grid.bottom)
      blockY = Math.floor(y / (32 * 50))
      offsetY = (y % (32 * 50)) / 32

      x = grid.left
      
      if x % 32 != 0
        x -= x % 32

      while(x < grid.right)
        blockX = Math.floor(x / (32 * 50))
        offsetX = (x % (32 * 50)) / 32

        block = @data[blockY][blockX]

        @drawTile(block[offsetY][offsetX], x, y)

        x+= 32
      y+= 32

    @interaction.checkForSpawns() if @interaction.isLoaded


