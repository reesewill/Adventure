Enemy = require("../_interfaces/enemy.coffee")

module.exports = class Bat extends Enemy

  constructor: (x,y,dir) ->

    super("/common/images/bat.png",x,y,32,32,dir,600)

    @name = "Bat"
