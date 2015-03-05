UI = require './ui/ui.coffee'

console.log 'main'
UI('ui')

prod = no
#

#
#
for i in document.querySelectorAll '#calc li'
  i.addEventListener 'click', (e) ->
    pressButton e.target
#

#
#number = (num) ->
#  ui.dropMarks()
#  if lastEventIsOp
#    lastVal = output.get()
#    lastEventIsOp = no
#    output.clear()
#  output.input num
#
#
#operator = (op, el) ->
#
#  operate = (method, element) ->
#    if lastOperator? and lastOperator isnt ops['=']
#      a = parseFloat output.get()
#      b = parseFloat lastVal
#      output.set lastOperator a,b
#    ui.mark element
#    lastOperator = ops[method]
#    lastEventIsOp = yes
#
#  if op is '='
#    if lastOperator?
#
#      a = parseFloat lastVal
#      b = parseFloat output.get()
#      if lastOpIsEq isnt true
#        lastVal = output.get()
#        lastOpIsEq = yes
#      output.set lastOperator a,b
#    lastEventIsOp = yes
#  else if ops[op]? then operate op, el
#
#
#
#
#ops =
#  '+': (a,b) ->
#    return a+b
#  '*': (a,b) ->
#    return a*b
#  '-': (a,b) ->
#    return a-b
#  '/': (a,b) ->
#    return b/a
#  '=': ->
#    return '='
#
#ui =
#  _marked: null
#  mark: (el) ->
#    @_marked = el
#    el.classList.add 'pushed'
#  dropMarks: ->
#    if @_marked?
#      @_marked.classList.remove 'pushed'

lastOperator = null
lastVal = null
lastEventIsOp = no
lastOpIsEq = no
buffer = 0
memClear = yes

pressButton = (el) ->
  console.assert prod,
    lastOperator: lastOperator
    lastVal: lastVal
    lastEventIsOp: lastEventIsOp
  str = el.innerText
  if not isNaN str
    number parseInt str
  else
    operator str, el

number = (num) ->
  if memClear
    output.set num
    memClear = false
  else
    output.input num

operator = (op) ->
  if op is ','
    decimal()
  else if op is 'c'
    clearEntry()
  else if op is 'AC'
    clear()
  else if op is '%'
    percent()
  else if op is '±'
    neg()
  else
    lastVal = output.get()
    if memClear and lastOperator isnt "="
      output.set buffer
    else
      memClear = true
      if '+' is lastOperator
        buffer += parseFloat lastVal
      else if '-' is lastOperator
        buffer -= parseFloat lastVal
      else if '÷' is lastOperator
        buffer /= parseFloat lastVal
      else if '×' is lastOperator
        buffer *= parseFloat lastVal
      else
        buffer = parseFloat lastVal
      output.set buffer
      lastOperator = op

decimal = ->
  out = output.get()
  if memClear
    out = "0."
    memClear = false
  else
    if out.indexOf(".") is -1
      out += "."
  output.set out

clearEntry = ->
  output.set 0
  memClear = yes

clear = ->
  buffer = 0
  lastOperator = ''
  clearEntry()

neg = ->
  output.set parseFloat(output.get()) * -1


percent = ->
  output.set (parseFloat(output.get()) / 100) * parseFloat(buffer)

output =
  _val: '0'
  refresh: () ->
    document.getElementById 'output'
      .innerText = @_val
  input: (data) ->
    data = data.toString()
    if @get() is '0'
      if data isnt '0'
        @_val = data
    else
      if @_val.length < 9
        @_val += data
    @refresh()
  set: (str) ->
    str = str.toString()
    @_val = str
    if str.length > 9
      document.getElementById 'output'
        .innerText = str.substr(0,6)+'..'
    else
      @refresh()
  get: () ->
    return @_val
  read: () ->
    return document.getElementById 'output'
      .innerText
  clear: () ->
    @_val = '0'
    @refresh()



