# global variable 'config' loaded by watcher

nodes = Array.from(document.querySelectorAll \*)

rules = do
  selector: null

setInterval (->
  if !rules.selector => return
  affected = Array.from(document.querySelectorAll(rules.selector)).length
  console.log "affected nodes: ", affected
  #if affected > 20 => document.body.scrollTop = 99999999 + document.body.scrollTop

  Array.from(document.querySelectorAll(rules.selector)).map ->
    it.style.color = \#f00
    highlight.add it
), 1000

#following code works in ptt and facebook
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
      e.target.signtree = signtree
      signs.push signtree
      mins = []
      for i from 0 til 2 =>
        maxs = [[signs.0.length, []]]
        for j from 1 til signs.length
          use-class = []
          for k from 0 til signs[j].length
            if signs[j][k].0 == signs.0[i].0 => break
          for m from k til signs[j].length
            use-class.push(signs[j][m].2 == signs.0[i + m - k].2)
            if signs[j][m].1 != signs.0[i + m - k].1 =>
              m++
              break
            if signs[j][m].0 != signs.0[i + m - k].0 => break
          maxs.push [m - k, use-class]
        maxs.sort (a,b) -> a.0 - b.0
        for k from 0 til maxs.0.1.length =>
          ret = true
          for j from 0 til maxs.length =>
            if maxs[j].1[k]? => ret = ret and maxs[j].1[k]
          maxs.0.1[k] = ret
        mins.push [maxs.0.0, maxs.0.1, i]
      mins.sort (a,b) -> b.0 - a.0
      offset = mins.0
      ret = []
      for i from offset.2 + offset.0 - 1 to offset.2 by -1 =>
        ret.push([
          "#{signs.0[i].0}#{if offset.1[i - offset.2] => signs.0[i].2 else ''}"
          if i == offset.2 + offset.0 - 1 => "" else ":nth-child(#{signs.0[i].1})"
        ].join(""))
      rules.selector = ret.join(' > ')
      console.log signs.map(->
        it.map(-> "#{it.0}#{it.2}[#{it.1}]").join(" > ")
      ).join(\\n)
      console.log "selector: ", rules.selector
      return
