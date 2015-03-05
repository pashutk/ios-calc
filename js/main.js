(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var UI, buffer, clear, clearEntry, decimal, i, j, lastEventIsOp, lastOpIsEq, lastOperator, lastVal, len, memClear, neg, number, operator, output, percent, pressButton, prod, ref;

UI = require('./ui/ui.coffee');

console.log('main');

UI('ui');

prod = false;

ref = document.querySelectorAll('#calc li');
for (j = 0, len = ref.length; j < len; j++) {
  i = ref[j];
  i.addEventListener('click', function(e) {
    return pressButton(e.target);
  });
}

lastOperator = null;

lastVal = null;

lastEventIsOp = false;

lastOpIsEq = false;

buffer = 0;

memClear = true;

pressButton = function(el) {
  var str;
  console.assert(prod, {
    lastOperator: lastOperator,
    lastVal: lastVal,
    lastEventIsOp: lastEventIsOp
  });
  str = el.innerText;
  if (!isNaN(str)) {
    return number(parseInt(str));
  } else {
    return operator(str, el);
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
  if (op === ',') {
    return decimal();
  } else if (op === 'c') {
    return clearEntry();
  } else if (op === 'AC') {
    return clear();
  } else if (op === '%') {
    return percent();
  } else if (op === '±') {
    return neg();
  } else {
    lastVal = output.get();
    if (memClear && lastOperator !== "=") {
      return output.set(buffer);
    } else {
      memClear = true;
      if ('+' === lastOperator) {
        buffer += parseFloat(lastVal);
      } else if ('-' === lastOperator) {
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

decimal = function() {
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
};

clearEntry = function() {
  output.set(0);
  return memClear = true;
};

clear = function() {
  buffer = 0;
  lastOperator = '';
  return clearEntry();
};

neg = function() {
  return output.set(parseFloat(output.get()) * -1);
};

percent = function() {
  return output.set((parseFloat(output.get()) / 100) * parseFloat(buffer));
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
    str = str.toString();
    this._val = str;
    if (str.length > 9) {
      return document.getElementById('output').innerText = str.substr(0, 6) + '..';
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
