navbar = do
  style: do
    position: \fixed
    top: \5px
    left: \5px
    width: \200px
    height: \20px
    background: \#fff
    "border-radius": \3px
    padding: \3px
    "z-index": 9999999999
    opacity: 0.95
    "box-shadow": "0 2px 4px rgba(0,0,0,0.3)"
  init: ->
    bar = document.createElement \div
    bar.innerHTML = "hello world!"
    bar.style <<< bar-style
    document.body.appendChild bar

highlight = do
  style: do
    position: \absolute
    top: 0
    left: 0
    width: 0
    height: 0
    background: \#ff0
    display: \block
    "z-index": 1048576
    "box-shadow": "0 2px 4px rgba(0,0,0,0.5)"
    "border-radius": \3px
    color: \#000
    margin: \0
    "-webkit-text-fill-color": \#000
  add: (node) ->
    if !node => return null
    if node.{}_plotdb_.bound => return that
    bound = document.createElement \div
    bound.setAttribute \class, '_plotdb_ scraper'
    document.body.appendChild bound
    style = window.getComputedStyle(node)
    for k of style => if /^-webkit/.exec(k) => bound.style[k] = style[k]
    for k of style => if !/^-webkit/.exec(k) => bound.style[k] = style[k]
    bound.style <<< @style
    box = node.getBoundingClientRect!
    sx = document.body.scrollLeft
    sy = document.body.scrollTop
    bound.style.top = "#{box.top - 0 + sy}px"
    bound.style.left = "#{box.left - 0 + sx}px"
    bound.style.width = "#{box.width + 0}px"
    bound.style.height = "#{box.height + 0}px"
    bound.innerText = node.innerText
    node.{}_plotdb_.bound = bound
    return bound
  remove: ->
    bound = node.{}_plotdb_.bound
    document.body.removeChild bound
