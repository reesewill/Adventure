# do ->
#
#   headerOffset = 0
#   headerScrollTop = 0
#   headerHeight = 70 # the height of a fixed banner, used to adjust target scroll position
#   winWidth = window.innerWidth
#
#   setBaseProps = ->
#
#     headerOffset = getOffsetTop(document.querySelector(".content-body"))
#     headerHeight = document.querySelector(".header-main").clientHeight
#     winWidth = window.innerWidth
#
#   window.onload = setBaseProps
#   window.onresize = setBaseProps
#
#   ##########################################
#   # jQuery sticky header
#   $page = $(".page-wrap")
#   stickyHeader = () ->
#     newScrollTop = $(window).scrollTop()
#
#     isGoingDown = newScrollTop > headerOffset && headerScrollTop <= headerOffset
#     isGoingUp = newScrollTop <= headerOffset && headerScrollTop > headerOffset
#     if isGoingDown
#       $page.addClass("stuck").css("margin-top", headerHeight + "px")
#       headerScrollTop = newScrollTop
#     else if isGoingUp
#       $page.removeClass("stuck").css("margin-top","")
#       headerScrollTop = newScrollTop
#   # End of jQuery stick header
#   ##########################################
#
#   ##########################################
#   # No jQuery sticky header
#   page = document.querySelector(".page-wrap")
#   stickyHeader = () ->
#     newScrollTop = window.pageYOffset || document.body.scrollTop || 0
#
#     isGoingDown = newScrollTop > headerOffset && headerScrollTop <= headerOffset
#     isGoingUp = newScrollTop <= headerOffset && headerScrollTop > headerOffset
#     if isGoingDown
#       page.className += " stuck"
#       page.style.marginTop = headerHeight + "px"
#       headerScrollTop = newScrollTop
#     else if isGoingUp
#       page.className = page.className.replace(/ stuck/g, "")
#       page.style.marginTop = ""
#       headerScrollTop = newScrollTop
#   # End of no jQuery sticky header
#   ##########################################
#
#   scrollLoop = ->
#     requestAnimFrame(scrollLoop)
#     stickyHeader()
#
#   scrollLoop()
#
#   easeInOutQuad = (t, b, c, d) ->
#
#     t /= (d/2)
#     return c/2*t*t + b if (t < 1)
#
#     t--
#     return -c/2 * (t*(t-2) - 1) + b
#
#   ##########################################
#   # jQuery smooth scroll code
#   smoothScroll = () ->
#     selector = $(this).data("target")
#     scrollTop = $(window).scrollTop()
#     scrollTarget = $(selector).offset().top - headerHeight
#     time = 0
#     timer = setInterval ( ->
#       t = easeInOutQuad(time, scrollTop, scrollTarget - scrollTop, 400)
#       if Math.abs(scrollTarget - t) <= 1 || time >= 400
#           $(window).scrollTop scrollTarget
#           clearTimeout timer
#       else
#           $(window).scrollTop t
#           time+= 17
#     ), 17
#
#     return false
#
#   $(".js-anchor-link").on "tap", smoothScroll
#   # End of jQuery smooth scroll code
#   ##########################################
#
#   ##########################################
#   # No jQuery smooth scroll code
#   isAutoScroll = false # prevent loops of two animations fighting each other
#   anchors = document.querySelectorAll(".js-anchor-link")
#
#   smoothScroll = (selector, offset) ->
#
#     isAutoScroll = true
#     scrollTop = window.pageYOffset || document.body.scrollTop || 0
#     scrollTarget = getOffsetTop(document.querySelector(selector)) - (offset || 0) - headerHeight
#     time = 0
#     distance = scrollTarget - scrollTop
#     duration = Math.max(parseInt(Math.abs(distance) / 20), 400)
#     timer = setInterval ( ->
#       t = Math.easeInOutQuad(time, scrollTop, distance, duration)
#
#       if Math.abs(scrollTarget - t) <= 1 || time >= duration
#           window.scrollTo 0, scrollTarget
#           clearTimeout timer
#           isAutoScroll = false
#           prevScroll = document.body.scrollTop
#       else
#           window.scrollTo 0, t
#           time+= 17
#     ), 17
#
#     return false
#
#   for a in anchors
#     do (a) ->
#       # mc = new Hammer(a)
#       # mc.on "tap", ->
#       a.onclick = (event) ->
#         return if isAutoScroll
#
#         event = event || window.event
#         smoothScroll(a.getAttribute("data-target"), parseInt(a.getAttribute("data-offset")))
#
#         # index = 1
#         if event.preventDefault
#           event.preventDefault()
#         else
#           event.returnValue = false
#
#         return false
#   # End of no jQuery smooth scroll code
#   ##########################################
