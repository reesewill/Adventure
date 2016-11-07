Map = require("./map.coffee")

module.exports = do ->

  isPaused = false

  window.canvas = document.getElementById("canvas")
  window.ctx = canvas.getContext("2d")
  
  start = 0
  now = 0
  last = 0

  window.drawables = []
  window.queueables = []
  window.sprites = []

  animate = (dt) ->

    grid.update(dt)

    ctx.clearRect(0,0,canvas.width,canvas.height)

    map.update()

    item.move(dt) for item in window.queueables
    item.draw() for item in window.drawables  

    sprite.step(dt) for sprite in window.sprites

  init = ->

    size()

    window.map = new Map("01.json")
    
    rsc.onFlagsSet((() ->
      start = now = last = Date.now()
      gameloop()
    ), map.isLoaded, rsc.isReady)

  iter = ->

    now = Date.now()
    dt = (now - last)
   
    animate(dt)

    last = now

  gameloop = ->

    iter()
    window.requestAnimFrame(gameloop) unless isPaused

  size = ->

    canvas.width = window.innerWidth
    canvas.height = window.innerHeight
    

  window.addEventListener "load", init
  window.addEventListener "resize", size