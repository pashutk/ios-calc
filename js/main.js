(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var UI, buffer, i, j, lastEventIsOp, lastOpIsEq, lastOperator, lastVal, len, memClear, mouseDictionary, number, operator, output, pressButton, prod, ref, staticOps;

UI = require('./ui/ui.coffee');

console.log('main');

UI('ui');

prod = true;

ref = document.querySelectorAll('#calc li');
for (j = 0, len = ref.length; j < len; j++) {
  i = ref[j];
  i.addEventListener('click', function(e) {
    return pressButton(e.target.innerText);
  });
}

mouseDictionary = '1234567890*-+=%.,/c'.split('');

mouseDictionary.push('enter', 'esc', ' ');

Mousetrap.bind(mouseDictionary, function(event, str) {
  console.log(str);
  switch (str) {
    case '/':
      return pressButton('÷');
    case '-':
      return pressButton('−');
    case '*':
      return pressButton('×');
    case '.':
      return pressButton(',');
    case 'enter':
      return pressButton('=');
    case 'esc':
      return pressButton('AC');
    case ' ':
      return pressButton('=');
    case 'c':
      return pressButton('AC');
    default:
      return pressButton(str);
  }
});

lastOperator = null;

lastVal = null;

lastEventIsOp = false;

lastOpIsEq = false;

buffer = 0;

memClear = true;

pressButton = function(str) {
  if (!isNaN(str)) {
    return number(parseInt(str));
  } else {
    return operator(str);
  }
};

number = function(num) {
  if (memClear) {
    output.set(num);
    return memClear = false;
  } else {
    return output.input(num);
  }
};

operator = function(op) {
  if (staticOps[op] != null) {
    return staticOps[op]();
  } else {
    lastVal = output.get();
    if (memClear && lastOperator !== "=") {
      return output.set(buffer);
    } else {
      memClear = true;
      if ('+' === lastOperator) {
        buffer += parseFloat(lastVal);
      } else if ('−' === lastOperator) {
        buffer -= parseFloat(lastVal);
      } else if ('÷' === lastOperator) {
        buffer /= parseFloat(lastVal);
      } else if ('×' === lastOperator) {
        buffer *= parseFloat(lastVal);
      } else {
        buffer = parseFloat(lastVal);
      }
      output.set(buffer);
      return lastOperator = op;
    }
  }
};

staticOps = {
  ',': function() {
    var out;
    out = output.get();
    if (memClear) {
      out = "0.";
      memClear = false;
    } else {
      if (out.indexOf(".") === -1) {
        out += ".";
      }
    }
    return output.set(out);
  },
  'AC': function() {
    buffer = 0;
    lastOperator = '';
    output.set(0);
    return memClear = true;
  },
  '±': function() {
    return output.set(parseFloat(output.get()) * -1);
  },
  '%': function() {
    return output.set((parseFloat(output.get()) / 100) * parseFloat(buffer));
  }
};

output = {
  _val: '0',
  refresh: function() {
    return document.getElementById('output').innerText = this._val;
  },
  input: function(data) {
    data = data.toString();
    if (this.get() === '0') {
      if (data !== '0') {
        this._val = data;
      }
    } else {
      if (this._val.length < 9) {
        this._val += data;
      }
    }
    return this.refresh();
  },
  set: function(str) {
    var k, maxNum, outputLength, ref1, temp;
    outputLength = 9;
    maxNum = '';
    for (i = k = 0, ref1 = outputLength; 0 <= ref1 ? k <= ref1 : k >= ref1; i = 0 <= ref1 ? ++k : --k) {
      maxNum += '9';
    }
    maxNum = parseInt(maxNum);
    str = str.toString();
    this._val = str;
    if (str.length > outputLength) {
      temp = parseFloat(str);
      return document.getElementById('output').innerText = temp.toPrecision(5);
    } else {
      return this.refresh();
    }
  },
  get: function() {
    return this._val;
  },
  read: function() {
    return document.getElementById('output').innerText;
  },
  clear: function() {
    this._val = '0';
    return this.refresh();
  }
};



},{"./ui/ui.coffee":2}],2:[function(require,module,exports){
var log;

log = console.log.bind(console);

module.exports = log;



},{}]},{},[1]);
