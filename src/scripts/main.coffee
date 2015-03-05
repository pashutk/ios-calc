UI = require './ui/ui.coffee'

console.log 'main'
UI('ui')

prod = yes

for i in document.querySelectorAll '#calc li'
  i.addEventListener 'click', (e) ->
    pressButton e.target.innerText

mouseDictionary = '1234567890*-+=%.,/c'.split('')
mouseDictionary.push 'enter', 'esc', ' '

Mousetrap.bind mouseDictionary, (event,str) ->
  console.log str
  switch str
    when '/' then pressButton '÷'
    when '-' then pressButton '−'
    when '*' then pressButton '×'
    when '.' then pressButton ','
    when 'enter' then pressButton '='
    when 'esc' then pressButton 'AC'
    when ' ' then pressButton '='
    when 'c' then pressButton 'AC'
    else
      pressButton str

lastOperator = null
lastVal = null
lastEventIsOp = no
lastOpIsEq = no
buffer = 0
memClear = yes

pressButton = (str) ->
  if not isNaN str
    number parseInt str
  else
    operator str

number = (num) ->
  if memClear
    output.set num
    memClear = false
  else
    output.input num

operator = (op) ->
  if staticOps[op]?
    do staticOps[op]
  else
    lastVal = output.get()
    if memClear and lastOperator isnt "="
      output.set buffer
    else
      memClear = true
      if '+' is lastOperator
        buffer += parseFloat lastVal
      else if '−' is lastOperator
        buffer -= parseFloat lastVal
      else if '÷' is lastOperator
        buffer /= parseFloat lastVal
      else if '×' is lastOperator
        buffer *= parseFloat lastVal
      else
        buffer = parseFloat lastVal
      output.set buffer
      lastOperator = op

staticOps =
  ',': ->
    out = output.get()
    if memClear
      out = "0."
      memClear = false
    else
      if out.indexOf(".") is -1
        out += "."
    output.set out

  'AC': ->
    buffer = 0
    lastOperator = ''
    output.set 0
    memClear = yes

  '±': ->
    output.set parseFloat(output.get()) * -1

  '%': ->
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
    outputLength = 9
    maxNum = ''
    for i in [0..outputLength]
      maxNum += '9'
    maxNum = parseInt maxNum
    str = str.toString()
    @_val = str
    if str.length > outputLength
      temp = parseFloat(str)
#      if temp > maxNum
      document.getElementById 'output'
        .innerText = temp.toPrecision(5)

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



