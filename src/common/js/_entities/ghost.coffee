Enemy = require("../_interfaces/enemy.coffee")

module.exports = class Ghost extends Enemy

  constructor: (x,y,dir) ->

    super("/common/images/ghost.png",x,y,32,32,dir,720)

    @name = "ghost"