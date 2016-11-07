Bat = require("../_entities/bat.coffee")
Ghost = require("../_entities/ghost.coffee")

module.exports = class Interaction

  constructor: (map) ->

    this.isLoaded = false
    this.spawns = []

    $.ajax 
      dataType: "json"
      type: "get"
      url: "/common/js/interactions/" + map
      success: @init
  
  init: (data) =>

    @data = data
    @isLoaded = true

    @checkForSpawns()

  checkForSpawns: () =>

    blocks = []
    matches = []

    #get blocks in 4 corners

    bottomY = map.getBlockY(grid.bottom)
    topY = map.getBlockY(grid.top)
    leftX = map.getBlockX(grid.left)
    rightX = map.getBlockX(grid.right)

    topleft = leftX + "x" + topY
    topright = rightX + "x" + topY
    bottomleft = leftX + "x" + bottomY
    bottomright = rightX + "x" + bottomY
  
    #add unique blocks
    blocks = [topleft,topright,bottomleft,bottomright].filter (v, i, self) ->
      return self.indexOf(v) == i

    #for each block, do a search to see if there is
    #anything unspawned in the view (check "spawned" prop)
    for block in blocks

      if @data[block]

        matches = matches.concat @data[block].filter (val) ->
          inx = val.x >= grid.left && val.x < grid.right
          iny = val.y >= grid.top && val.y <grid.bottom

          return inx && iny && !val.spawned

    if matches.length
      console.log matches
    #anything new should be marked "spawned", call @spawn
    for match in matches
      match.spawned = true
      @spawn(match)

  spawn: (data) =>

    typeObj = @spawnTypes[data.name]
    
    monster = new typeObj(data.x, data.y, data.dir)

    this.spawns.push monster
    sprites.push monster

  spawnTypes: {
    "bat": Bat
    "ghost": Ghost
  }