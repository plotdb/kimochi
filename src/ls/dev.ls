# global variable 'config' loaded by watcher

eventhub = do
  handlers: {}
  listen: (name, handle) ->
    @handlers[][name].push handle
    if @init => @init!
  trigger: (name, value) -> for item in (@handlers[name] or []) => item(value)
  init: ->
    @init = null
    (req, sender, res) <~ chrome.runtime.onMessage.addListener
    if !@handlers[req.type] => return
    for handler in @handlers[req.type] => handler req, sender, res

bar-style = do
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

bar = document.createElement \div
bar.innerHTML = "hello world!"
bar.style <<< bar-style
document.body.appendChild bar
nodes = Array.from(document.querySelectorAll \*)
hash = {}
#bound = document.createElement \div
#bound.setAttribute \class, 'bound'
base-style = do
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

data = []
bounds = do
  add: (node) ->
    if !node => return null
    if node.{}_plotdb_.bound => return that
    bound = document.createElement \div
    bound.setAttribute \class, '_plotdb_ scraper'
    document.body.appendChild bound
    style = window.getComputedStyle(node)
    for k of style => if /^-webkit/.exec(k) => bound.style[k] = style[k]
    for k of style => if !/^-webkit/.exec(k) => bound.style[k] = style[k]
    bound.style <<< base-style
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

rules = do
  selector: null
#document.body.appendChild(bound)
rules.selector = "body:nth-child(2) > div:nth-child(2) > div.r-list-container.bbs-screen:nth-child(2) > div.r-ent > div.title:nth-child(3) > a:nth-child(1)"
setInterval (->
  if !rules.selector => return
  affected = Array.from(document.querySelectorAll(rules.selector)).length
  console.log "affected nodes: ", affected
  #if affected > 20 => document.body.scrollTop = 99999999 + document.body.scrollTop

  Array.from(document.querySelectorAll(rules.selector)).map ->
    it.style.color = \#f00
    bounds.add it
), 1000

signs = []
for node in nodes =>
  if node.childNodes.length == 1 =>
    node.onclick = -> return false
    node.addEventListener \click, (e) ->
      e.cancelBubble = true
      e.stopPropagation!
      cur = e.target
      if cur.signtree => return
      signtree = []
      while true
        if !cur => break
        node-name = (cur.nodeName or 'HTML').toLowerCase!
        class-name = (cur.className or '').split(' ').filter(->it).map(->".#it").join('')
        if node-name == \html => break
        idx = Array.from(cur.parentNode.childNodes).filter(->it.nodeName!=\#text).indexOf(cur)
        signtree.push [node-name, idx + 1, class-name]
        cur = cur.parentNode
      #signtree.reverse!
      e.target.signtree = signtree
      signs.push signtree
      console.log signs.map(-> it.map(-> "#{it.0}.#{it.2}[#{it.1}]").join(" > ")).join(\\n)
      console.log signs.map(->
        ret = it.map(-> "#{it.0}#{if it.2 => it.2 else ''}:nth-child(#{it.1})")
        ret.reverse!
        ret.join(" > ")
      ).join(\\n)
      if signs.length < 2 => return false
      for i from 0 til signs.0.length =>
        if "#{signs.0[i]}" != "#{signs.1[i]}" => break
      console.log i
      rules.selector = ["#{signs.0[j].0}.#{signs.0[j].2}:nth-child(#{signs.0[j].1})" for j from i - 1 to 0 by -1].join(" > ")
      console.log rules.selector

      /*
      max = [0,0,0]
      console.log "trace up..."
      stop = false
      for i from 0 til signs.0.length
        for j from 1 til signs.length
          if signs[j][i].0 == signs.0[i].0 and signs[j][i].1 == signs.0[i].1 => max.0 = i
          else 
            stop = true
            break
        if stop => break
      console.log "trace down..."
      stop = 0
      max.2 = signs.0.length
      len = Math.min.apply null, signs.map -> it.length
      for i from 0 til len
        for j from 1 til signs.length
          k = signs[j].length - i - 1
          k0 = signs.0.length - i - 1
          equal = (signs[j][k].0 == signs.0[k0].0 and signs[j][k].1 == signs.0[k0].1)
          if stop == 0 and !equal => max.2 = i
          if stop == 0 and equal => stop = 1
          if stop == 1 and equal => max.1 = i
          if stop == 1 and !equal =>
            stop = 2
            break
        if stop == 2 => break
      console.log "max depth: ", max

      selector1 = ["#{signs.0[i][0]}:nth-child(#{signs.0[i][1]})" for i from 0 to max.0].join(">")
      selector2 = ["#{signs.0[i][0]}:nth-child(#{signs.0[i][1]})" for i from max.1 til signs.0.length].join(">")
      rules.selector = "#selector1 #selector2"
      Array.from(document.querySelectorAll(rules.selector)).map ->
        it.style.color = \#f00
      return false
      */
/*
candidates = []
for node in nodes =>
  if node.childNodes.length == 1 =>
    node.onclick = -> return false
    node.addEventListener \
    lick, (e) ->
      cur = e.target
      if cur.className => console.log document.querySelectorAll(cur.className.split(' ').map(->".#it").join(''))
      if cur.signtree => return
      console.log "construct signtree..."
      signtree = []
      while true
        if !cur => break
        class-name = cur.getAttribute \class
        node-name = (cur.nodeName or 'HTML').toLowerCase!
        if node-name == \html => break
        signtree.push [node-name, class-name, cur.childNodes.length]
        #matched = Array.from(cur.parentNode.childNodes)
        #  .map -> [it, it.getAttribute and it.getAttribute(\class) == clsname]
        #  .filter -> it.1
        #idx = Array.from(cur.parentNode.childNodes).indexOf(cur)
        #matches.push [idx, matched]
        cur = cur.parentNode
      signtree.reverse!
      e.target.signtree = signtree
      candidates.push e.target
      ref = candidates.0.signtree
      console.log "maximum match lv..."
      max = -1
      for i from 0 til signtree.length =>
        sign = candidates.map -> "#{it.signtree[i]}"
        console.log "my lv #i : ", sign
      for i from 0 til ref.length =>
        sign = candidates.map -> "#{it.signtree[i]}"
        console.log "lv #i : ", sign
        for j from 1 til sign.length =>
          if sign[j] != sign.0 =>
            max = i - 1
            break
        if max >= 0 => break
      if max == -1 => max = ref.length - 1
      console.log "max lv: ", max
*/

/*
for node in nodes =>
  if node.childNodes.length == 1 =>
    node.onclick = -> return false
    node.addEventListener \click, (e) ->
      cur = e.target
      matches = []
      while true
        if (cur.nodeName || 'HTML').toLowerCase! == \html => break
        clsname = cur.getAttribute \class
        matched = Array.from(cur.parentNode.childNodes)
          .map -> [it, it.getAttribute and it.getAttribute(\class) == clsname]
          .filter -> it.1
        idx = Array.from(cur.parentNode.childNodes).indexOf(cur)
        console.log cur.nodeName, cur.parentNode.childNodes.length, matched.length, clsname, idx
        matches.push [idx, matched]
        cur = cur.parentNode
      [idx,max] = [0,0]
      console.log matches
      for i from 0 til matches.length => if matches[i].1.length > max => [max,idx] = [matches[i].1.length, i]
      console.log idx, max
      list = []
      candidates = matches[idx].1
        .map -> it.0
        .forEach (n) ->
          for j from idx - 1 to 0 by -1 =>
            if !n or !n.childNodes =>
              list.push ''
              return
            n = n.childNodes[matches[j].0]
          list.push (n or {}).innerText
          bounds.add n
      data.push list
      for i from 0 til data.0.length =>
        console.log(data.map(-> it[i]).join(\,))
  names = node.getAttribute(\class) or ''
  for name in names.split(' ')
    if !name => continue
    hash[name] = ( hash[name] or 0 ) + 1
console.log hash
*/
