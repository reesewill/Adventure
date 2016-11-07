module.exports = do ->

  readyCallbacks = []
  resourceCache = {}

  load = (urlOrArr) ->
    if urlOrArr instanceof Array
      urlOrArr.forEach (url) ->
        _load(url)
    else
      _load(urlOrArr)

  getImage = (url) ->
    return resourceCache[url]

  isReady = () ->
    ready = true
    for k in resourceCache
      if resourceCache.hasOwnProperty(k) && !resourceCache[k]
        ready = false

    return ready

  onFlagsSet = (callback, args...) ->

    cloop = ->

      isSet = true

      for arg in args

        if typeof arg == "function"
          if !arg()
            isSet = false

      if isSet
        callback()
      else
        setTimeout cloop, 50

    cloop()

  onReady = (func) ->
    readyCallbacks.push(func)

  _load = (url) ->
    if resourceCache[url]
      return resourceCache[url]
    else
      img = new Image()
      img.onload = ->
        resourceCache[url] = img

        if isReady()
          readyCallbacks.forEach (func) -> func()

      resourceCache[url] = false
      img.src = url


  window.rsc = { 
    load: load,
    get: getImage,
    onFlagsSet: onFlagsSet,
    onReady: onReady,
    isReady: isReady
  };