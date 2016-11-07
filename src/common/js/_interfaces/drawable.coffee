module.exports = class Drawable

  constructor: (url, x,y,h,w) ->

    _this = this

    rsc.load url
    rsc.onReady -> _this.image = rsc.get(url)

    this.position = {
      x:parseInt(x) || 0,
      y:parseInt(y) || 0
    }
    this.size = {
      h:parseInt(h) || 0,
      w:parseInt(w) || 0
    }

  draw: ->

    coords = grid.getRelXy(@position.x, @position.y, @size.h, @size.w)

    if coords
      ctx.save()
      ctx.drawImage(this.image, coords.x, coords.y)
      ctx.restore()