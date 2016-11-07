module.exports = do ->
  window.requestAnimFrame = do ->
    return  window.requestAnimationFrame       or
            window.webkitRequestAnimationFrame or
            window.mozRequestAnimationFrame    or
            (callback) ->
              window.setTimeout(callback, 1000 / 60)

  # window.isAndroid4 = /Android 4/.test(navigator.userAgent)
  # window.isTouch = (/Android|iPhone|iPad|iPod|BlackBerry|Windows Phone/i).test(navigator.userAgent || navigator.vendor || window.opera)

  window.keycodes = {
    13: "RETURN"
    27: "ESC"
    32: "SPACE"
    65: "a"
    68: "d"
    83: "s"
    87: "w"
  }

  window.getKey = (event) ->

    event = event || window.event
    code = event.which || event.keyCode

    return window.keycodes[code]

  window.isKey = (event, key) ->
  
    event = event || window.event
    code = event.which || event.keyCode
  
    return window.keycodes[code] == key

  window.getOffsetTop = (el) ->

    offset = el.offsetTop

    while(el = el.offsetParent)

      if !isNaN(el.offsetTop)
        offset += el.offsetTop

    return offset
