(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var Bat, Enemy,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Enemy = require("../_interfaces/enemy.coffee");

module.exports = Bat = (function(superClass) {
  extend(Bat, superClass);

  function Bat(x, y, dir) {
    Bat.__super__.constructor.call(this, "/common/images/bat.png", x, y, 32, 32, dir, 600);
    this.name = "Bat";
  }

  return Bat;

})(Enemy);



},{"../_interfaces/enemy.coffee":7}],2:[function(require,module,exports){
var Enemy, Ghost,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Enemy = require("../_interfaces/enemy.coffee");

module.exports = Ghost = (function(superClass) {
  extend(Ghost, superClass);

  function Ghost(x, y, dir) {
    Ghost.__super__.constructor.call(this, "/common/images/ghost.png", x, y, 32, 32, dir, 720);
    this.name = "ghost";
  }

  return Ghost;

})(Enemy);



},{"../_interfaces/enemy.coffee":7}],3:[function(require,module,exports){
var Link, Sprite,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Sprite = require("../_interfaces/sprite.coffee");

module.exports = Link = (function(superClass) {
  extend(Link, superClass);

  function Link() {
    this.handleRepeat = bind(this.handleRepeat, this);
    this.handleInput = bind(this.handleInput, this);
    this.canMove = bind(this.canMove, this);
    Link.__super__.constructor.call(this, "/common/images/link.png", grid.centerX, grid.centerY, 26, 24, 0, 0, 12, 360, false, true, true);
    this.sy = 64;
  }

  Link.prototype.canMove = function() {
    var cycleTarget, vx, vy;
    if (input.direction === "left") {
      vx = -32;
      vy = 0;
    } else if (input.direction === "right") {
      vx = 32;
      vy = 0;
    } else if (input.direction === "up") {
      vy = -32;
      vx = 0;
    } else if (input.direction === "down") {
      vy = 32;
      vx = 0;
    }
    cycleTarget = {};
    cycleTarget.x = this.position.x + vx;
    cycleTarget.y = this.position.y + vy;
    return map.isTileOpen(cycleTarget.x, cycleTarget.y);
  };

  Link.prototype.handleInput = function() {
    if (input.direction && !this.isCycling) {
      this.sy = this.animmap[input.direction];
      this.isOn = true;
      if (input.direction === "left") {
        this.velocity.x = -32;
        return this.velocity.y = 0;
      } else if (input.direction === "right") {
        this.velocity.x = 32;
        return this.velocity.y = 0;
      } else if (input.direction === "up") {
        this.velocity.y = -32;
        return this.velocity.x = 0;
      } else if (input.direction === "down") {
        this.velocity.y = 32;
        return this.velocity.x = 0;
      }
    } else if (!input.direction) {
      this.isOn = false;
      if (!this.isCycling) {
        return this.velocity = {
          x: 0,
          y: 0
        };
      }
    }
  };

  Link.prototype.handleRepeat = function(cycles) {
    var dir;
    dir = input.direction;
    if (cycles % 2 === 1) {
      dir += "-alt";
    }
    return this.sy = this.animmap[dir];
  };

  Link.prototype.animmap = {
    "left": 97,
    "down": 64,
    "right": 33,
    "up": 0,
    "down-alt": 192,
    "left-alt": 224,
    "right-alt": 160,
    "up-alt": 129
  };

  return Link;

})(Sprite);



},{"../_interfaces/sprite.coffee":9}],4:[function(require,module,exports){
module.exports = (function() {
  window.requestAnimFrame = (function() {
    return window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || function(callback) {
      return window.setTimeout(callback, 1000 / 60);
    };
  })();
  window.keycodes = {
    13: "RETURN",
    27: "ESC",
    32: "SPACE",
    65: "a",
    68: "d",
    83: "s",
    87: "w"
  };
  window.getKey = function(event) {
    var code;
    event = event || window.event;
    code = event.which || event.keyCode;
    return window.keycodes[code];
  };
  window.isKey = function(event, key) {
    var code;
    event = event || window.event;
    code = event.which || event.keyCode;
    return window.keycodes[code] === key;
  };
  return window.getOffsetTop = function(el) {
    var offset;
    offset = el.offsetTop;
    while ((el = el.offsetParent)) {
      if (!isNaN(el.offsetTop)) {
        offset += el.offsetTop;
      }
    }
    return offset;
  };
})();



},{}],5:[function(require,module,exports){




},{}],6:[function(require,module,exports){
var Drawable;

module.exports = Drawable = (function() {
  function Drawable(url, x, y, h, w) {
    var _this;
    _this = this;
    rsc.load(url);
    rsc.onReady(function() {
      return _this.image = rsc.get(url);
    });
    this.position = {
      x: parseInt(x) || 0,
      y: parseInt(y) || 0
    };
    this.size = {
      h: parseInt(h) || 0,
      w: parseInt(w) || 0
    };
  }

  Drawable.prototype.draw = function() {
    var coords;
    coords = grid.getRelXy(this.position.x, this.position.y, this.size.h, this.size.w);
    if (coords) {
      ctx.save();
      ctx.drawImage(this.image, coords.x, coords.y);
      return ctx.restore();
    }
  };

  return Drawable;

})();



},{}],7:[function(require,module,exports){
var Enemy, Sprite,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Sprite = require("./sprite.coffee");

module.exports = Enemy = (function(superClass) {
  extend(Enemy, superClass);

  function Enemy(url, x, y, h, w, dir, duration) {
    this.setDirection = bind(this.setDirection, this);
    this.getRandomDirection = bind(this.getRandomDirection, this);
    this.updateMovement = bind(this.updateMovement, this);
    this.canMove = bind(this.canMove, this);
    Enemy.__super__.constructor.call(this, url, x, y, h, w, 0, 0, 3, duration || 360, false, false, false);
    this.setDirection(dir || "down");
    this.isOn = true;
    this.moveOnce = true;
    this.updateMovement();
  }

  Enemy.prototype.canMove = function() {
    var cycleTarget, vx, vy;
    if (this.direction === "left") {
      vx = -32;
      vy = 0;
    } else if (this.direction === "right") {
      vx = 32;
      vy = 0;
    } else if (this.direction === "up") {
      vy = -32;
      vx = 0;
    } else if (this.direction === "down") {
      vy = 32;
      vx = 0;
    }
    cycleTarget = {};
    cycleTarget.x = this.position.x + vx;
    cycleTarget.y = this.position.y + vy;
    return map.isTileOpen(cycleTarget.x, cycleTarget.y);
  };

  Enemy.prototype.updateMovement = function() {
    var _this, t;
    t = (Math.random() * 400) + 600;
    _this = this;
    return setTimeout((function() {
      var dir;
      dir = _this.getRandomDirection();
      _this.setDirection(dir);
      if (_this.direction === "left") {
        _this.velocity.x = -32;
        return _this.velocity.y = 0;
      } else if (_this.direction === "right") {
        _this.velocity.x = 32;
        return _this.velocity.y = 0;
      } else if (_this.direction === "up") {
        _this.velocity.y = -32;
        return _this.velocity.x = 0;
      } else if (_this.direction === "down") {
        _this.velocity.y = 32;
        return _this.velocity.x = 0;
      }
    }), t);
  };

  Enemy.prototype.getRandomDirection = function() {
    return this.direction;
  };

  Enemy.prototype.setDirection = function(dir) {
    this.direction = dir;
    return this.sy = this.animmap[dir];
  };

  Enemy.prototype.animmap = {
    "left": 32,
    "down": 0,
    "right": 64,
    "up": 92
  };

  return Enemy;

})(Sprite);



},{"./sprite.coffee":9}],8:[function(require,module,exports){
var Drawable, Queueable,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Drawable = require("./drawable.coffee");

module.exports = Queueable = (function(superClass) {
  extend(Queueable, superClass);

  function Queueable(url, x, y, h, w, vx, vy) {
    this.updateMovement = bind(this.updateMovement, this);
    this.move = bind(this.move, this);
    Queueable.__super__.constructor.call(this, url, x, y, h, w);
    this.velocity = {
      x: vx || 0,
      y: vy || 0
    };
    this.isCycling = false;
    this.cycleProgress = 0;
    this.moveOnce = false;
    this.cycleTarget = {
      x: 0,
      y: 0,
      startX: 0,
      startY: 0
    };
  }

  Queueable.prototype.move = function(dt) {
    var step;
    if ((this.velocity.x || this.velocity.y) && !this.isCycling) {
      this.isCycling = true;
      this.cycleTarget.startX = this.position.x;
      this.cycleTarget.startY = this.position.y;
      this.cycleTarget.x = this.position.x + this.velocity.x;
      this.cycleTarget.y = this.position.y + this.velocity.y;
      if (!map.isTileOpen(this.cycleTarget.x, this.cycleTarget.y)) {
        this.velocity.x = 0;
        this.velocity.y = 0;
        this.cycleTarget.x = this.cycleTarget.startX;
        this.cycleTarget.y = this.cycleTarget.startY;
      }
    }
    if (this.isCycling) {
      step = dt / 360;
      this.cycleProgress += step;
      this.position.x = Math.floor(this.cycleTarget.startX + (this.velocity.x * this.cycleProgress));
      this.position.y = Math.floor(this.cycleTarget.startY + (this.velocity.y * this.cycleProgress));
      if (this.cycleProgress >= 1) {
        this.isCycling = false;
        this.cycleProgress = 0;
        this.position.x = this.cycleTarget.x;
        this.position.y = this.cycleTarget.y;
        if (this.moveOnce) {
          this.velocity.x = 0;
          this.velocity.y = 0;
          return this.updateMovement();
        }
      }
    }
  };

  Queueable.prototype.updateMovement = function() {};

  return Queueable;

})(Drawable);



},{"./drawable.coffee":6}],9:[function(require,module,exports){
var Queueable, Sprite,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Queueable = require("./queueable.coffee");

module.exports = Sprite = (function(superClass) {
  extend(Sprite, superClass);

  function Sprite(url, x, y, h, w, vx, vy, frames, duration, isOn, isOnce, isRepeatable) {
    this.step = bind(this.step, this);
    this.setFrame = bind(this.setFrame, this);
    this.handleRepeat = bind(this.handleRepeat, this);
    this.handleInput = bind(this.handleInput, this);
    this.animate = bind(this.animate, this);
    Sprite.__super__.constructor.call(this, url, x, y, h, w, vx, vy);
    this.frames = frames;
    this.duration = duration;
    this.isOnce = isOnce;
    this.isOn = isOn;
    this.isRepeatable = isRepeatable;
    this.index = 0;
    this.sx = 0;
    this.sy = 0;
    this.cycles = 0;
    this.isSpriting = false;
    this.spriteProgress = 0;
  }

  Sprite.prototype.animate = function(dt) {
    if (this.isSpriting) {
      this.spriteProgress += dt;
      if (this.duration / this.frames * (this.index + 1) <= this.spriteProgress) {
        if (this.index + 1 === this.frames) {
          if (!this.isOnce) {
            this.spriteProgress = 0;
            return this.setFrame(0);
          } else {
            if (this.isRepeatable) {
              if (!this.isOn) {
                this.isSpriting = false;
              } else {
                this.cycles++;
                this.handleRepeat(this.cycles);
              }
              this.spriteProgress = 0;
              return this.setFrame(0);
            } else {
              return this.isSpriting = false;
            }
          }
        } else {
          return this.setFrame(this.index + 1);
        }
      } else {
        return this.setFrame(this.index);
      }
    } else {
      if (this.isOn) {
        this.cycles = 0;
        this.isSpriting = true;
        this.spriteProgress = 0;
      }
      return this.setFrame(0);
    }
  };

  Sprite.prototype.handleInput = function() {};

  Sprite.prototype.handleRepeat = function() {};

  Sprite.prototype.setFrame = function(index) {
    var coords;
    coords = grid.getRelXy(this.position.x, this.position.y, this.size.h, this.size.w);
    if (coords) {
      ctx.save();
      this.sx = index * this.size.w;
      ctx.drawImage(this.image, this.sx, this.sy, this.size.w, this.size.h, coords.x, coords.y, this.size.w, this.size.h);
      this.index = index;
      return ctx.restore();
    }
  };

  Sprite.prototype.step = function(dt) {
    this.handleInput();
    this.move(dt);
    return this.animate(dt);
  };

  return Sprite;

})(Queueable);



},{"./queueable.coffee":8}],10:[function(require,module,exports){
var Map;

Map = require("./map.coffee");

module.exports = (function() {
  var animate, gameloop, init, isPaused, iter, last, now, size, start;
  isPaused = false;
  window.canvas = document.getElementById("canvas");
  window.ctx = canvas.getContext("2d");
  start = 0;
  now = 0;
  last = 0;
  window.drawables = [];
  window.queueables = [];
  window.sprites = [];
  animate = function(dt) {
    var i, item, j, k, len, len1, len2, ref, ref1, ref2, results, sprite;
    grid.update(dt);
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    map.update();
    ref = window.queueables;
    for (i = 0, len = ref.length; i < len; i++) {
      item = ref[i];
      item.move(dt);
    }
    ref1 = window.drawables;
    for (j = 0, len1 = ref1.length; j < len1; j++) {
      item = ref1[j];
      item.draw();
    }
    ref2 = window.sprites;
    results = [];
    for (k = 0, len2 = ref2.length; k < len2; k++) {
      sprite = ref2[k];
      results.push(sprite.step(dt));
    }
    return results;
  };
  init = function() {
    size();
    window.map = new Map("01.json");
    return rsc.onFlagsSet((function() {
      start = now = last = Date.now();
      return gameloop();
    }), map.isLoaded, rsc.isReady);
  };
  iter = function() {
    var dt;
    now = Date.now();
    dt = now - last;
    animate(dt);
    return last = now;
  };
  gameloop = function() {
    iter();
    if (!isPaused) {
      return window.requestAnimFrame(gameloop);
    }
  };
  size = function() {
    canvas.width = window.innerWidth;
    return canvas.height = window.innerHeight;
  };
  window.addEventListener("load", init);
  return window.addEventListener("resize", size);
})();



},{"./map.coffee":14}],11:[function(require,module,exports){
var Grid,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

module.exports = Grid = (function() {
  function Grid(startX, startY, expanseX, expanseY) {
    this.update = bind(this.update, this);
    this.getRelY = bind(this.getRelY, this);
    this.getRelX = bind(this.getRelX, this);
    this.getRelXy = bind(this.getRelXy, this);
    this.center = bind(this.center, this);
    this.bind = bind(this.bind, this);
    this.height = canvas.height;
    this.width = canvas.width;
    this.left = startX;
    this.right = this.left + this.width;
    this.top = startY;
    this.bottom = startY + this.height;
    this.expanseX = expanseX;
    this.expanseY = expanseY;
    this.centerX = Math.floor(this.left + (this.width / 2) - 12);
    this.centerY = Math.floor(this.top + (this.height / 2) - 13);
    if (this.centerY % 32 !== 0) {
      this.centerY -= this.centerY % 32;
    }
    if (this.centerX % 32 !== 0) {
      this.centerX -= this.centerX % 32;
    }
    this.isCycling = false;
    this.cycleProgress = 0;
    this.cycleTarget = {
      startLeft: 0,
      startRight: 0,
      left: 0,
      top: 0
    };
    this.vx = 0;
    this.vy = 0;
    this.bind();
  }

  Grid.prototype.bind = function() {
    return window.addEventListener("resize", this.center);
  };

  Grid.prototype.center = function() {
    var adjustX, adjustY, newHeight, newWidth;
    newHeight = window.innerHeight;
    newWidth = window.innerWidth;
    adjustX = Math.floor((this.width - newWidth) / 2);
    adjustY = Math.floor((this.height - newHeight) / 2);
    this.top += adjustY;
    this.bottom = this.top + newHeight;
    this.left += adjustX;
    this.right = this.left + newWidth;
    this.centerX += adjustX;
    this.centerY += adjustY;
    this.height = newHeight;
    return this.width = newWidth;
  };

  Grid.prototype.getRelXy = function(x, y, h, w) {
    var relx, relxy, rely;
    relx = this.getRelX(x);
    rely = this.getRelY(y);
    relxy = {};
    if (relx + w > 0 && relx < this.width) {
      relxy.x = relx;
    } else {
      return null;
    }
    if (rely + h > 0 && rely < this.height) {
      relxy.y = rely;
    } else {
      return null;
    }
    return relxy;
  };

  Grid.prototype.getRelX = function(x) {
    return x - this.left;
  };

  Grid.prototype.getRelY = function(y) {
    return y - this.top;
  };

  Grid.prototype.update = function(dt) {
    var atBottomEdge, atLeftEdge, atRightEdge, atTopEdge, isPastBottom, isPastLeft, isPastRight, isPastTop, step;
    if (input.direction && !this.isCycling) {
      this.isCycling = true;
      this.vx = {
        "left": -32,
        "right": 32
      }[input.direction] || 0;
      this.vy = {
        "up": -32,
        "down": 32
      }[input.direction] || 0;
      this.cycleTarget.left = this.left + this.vx;
      this.cycleTarget.top = this.top + this.vy;
      this.cycleTarget.startLeft = this.left;
      this.cycleTarget.startTop = this.top;
      atLeftEdge = this.cycleTarget.left <= 0 && this.vx < 0;
      atRightEdge = this.cycleTarget.left + this.width >= this.expanseX && this.vx > 0;
      atTopEdge = this.cycleTarget.top <= 0 && this.vy < 0;
      atBottomEdge = this.cycleTarget.top + this.height >= this.expanseY && this.vy > 0;
      if (atLeftEdge || atRightEdge || atTopEdge || atBottomEdge || !map.Link.canMove()) {
        this.vx = this.vy = 0;
        this.cycleTarget.left = this.left;
        this.cycleTarget.top = this.top;
      }
      isPastLeft = this.vx > 0 && map.Link.position.x < this.centerX;
      isPastRight = this.vx < 0 && map.Link.position.x > this.centerX;
      isPastTop = this.vy < 0 && map.Link.position.y > this.centerY;
      isPastBottom = this.vy > 0 && map.Link.position.y < this.centerY;
      if (isPastLeft || isPastRight || isPastTop || isPastBottom) {
        this.vx = this.vy = 0;
        this.cycleTarget.left = this.left;
        this.cycleTarget.top = this.top;
      }
    }
    if (this.isCycling) {
      step = dt / 360;
      this.cycleProgress += step;
      this.top = Math.floor(this.cycleTarget.startTop + this.vy * this.cycleProgress);
      this.left = Math.floor(this.cycleTarget.startLeft + this.vx * this.cycleProgress);
      this.bottom = this.top + this.height;
      this.right = this.left + this.width;
      if (this.cycleProgress >= 1) {
        this.top = this.cycleTarget.top;
        this.bottom = this.top + this.height;
        this.left = this.cycleTarget.left;
        this.right = this.left + this.width;
        this.centerX += this.vx;
        this.centerY += this.vy;
        this.isCycling = false;
        return this.cycleProgress = 0;
      }
    }
  };

  return Grid;

})();



},{}],12:[function(require,module,exports){
module.exports = (function() {
  var actionmap, bind, dir, dirmap, dirs, handleKeydown, handleKeyup, init;
  dirs = [];
  dir = null;
  dirmap = {
    "a": "left",
    "s": "down",
    "d": "right",
    "w": "up"
  };
  actionmap = {
    "space": "attack"
  };
  init = function() {
    window.input = {
      direction: "",
      actions: {
        "attack": false
      }
    };
    return bind();
  };
  bind = function() {
    window.addEventListener("keydown", handleKeydown);
    return window.addEventListener("keyup", handleKeyup);
  };
  handleKeyup = function(e) {
    var index, key, lastkey;
    key = getKey(e);
    index = dirs.indexOf(key);
    if (index >= 0) {
      dirs.splice(index, 1);
      if (dirs.length) {
        lastkey = dirs[dirs.length - 1];
        dir = lastkey;
      } else {
        dir = null;
      }
      input.direction = dirmap[dir];
    }
    if (typeof actionmap[key] !== "undefined") {
      input.actions[actionmap[key]] = false;
    }
    return false;
  };
  handleKeydown = function(e) {
    var key;
    key = getKey(e);
    if (typeof dirmap[key] !== "undefined" && key !== dir) {
      dir = key;
      dirs.push(key);
      input.direction = dirmap[dir];
    }
    if (typeof actionmap[key] !== "undefined") {
      input.actions[actionmap[key]] = true;
    }
    return false;
  };
  return init();
})();



},{}],13:[function(require,module,exports){
var Bat, Ghost, Interaction,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Bat = require("../_entities/bat.coffee");

Ghost = require("../_entities/ghost.coffee");

module.exports = Interaction = (function() {
  function Interaction(map) {
    this.spawn = bind(this.spawn, this);
    this.checkForSpawns = bind(this.checkForSpawns, this);
    this.init = bind(this.init, this);
    this.isLoaded = false;
    this.spawns = [];
    $.ajax({
      dataType: "json",
      type: "get",
      url: "/common/js/interactions/" + map,
      success: this.init
    });
  }

  Interaction.prototype.init = function(data) {
    this.data = data;
    this.isLoaded = true;
    return this.checkForSpawns();
  };

  Interaction.prototype.checkForSpawns = function() {
    var block, blocks, bottomY, bottomleft, bottomright, j, k, leftX, len, len1, match, matches, results, rightX, topY, topleft, topright;
    blocks = [];
    matches = [];
    bottomY = map.getBlockY(grid.bottom);
    topY = map.getBlockY(grid.top);
    leftX = map.getBlockX(grid.left);
    rightX = map.getBlockX(grid.right);
    topleft = leftX + "x" + topY;
    topright = rightX + "x" + topY;
    bottomleft = leftX + "x" + bottomY;
    bottomright = rightX + "x" + bottomY;
    blocks = [topleft, topright, bottomleft, bottomright].filter(function(v, i, self) {
      return self.indexOf(v) === i;
    });
    for (j = 0, len = blocks.length; j < len; j++) {
      block = blocks[j];
      if (this.data[block]) {
        matches = matches.concat(this.data[block].filter(function(val) {
          var inx, iny;
          inx = val.x >= grid.left && val.x < grid.right;
          iny = val.y >= grid.top && val.y < grid.bottom;
          return inx && iny && !val.spawned;
        }));
      }
    }
    if (matches.length) {
      console.log(matches);
    }
    results = [];
    for (k = 0, len1 = matches.length; k < len1; k++) {
      match = matches[k];
      match.spawned = true;
      results.push(this.spawn(match));
    }
    return results;
  };

  Interaction.prototype.spawn = function(data) {
    var monster, typeObj;
    typeObj = this.spawnTypes[data.name];
    monster = new typeObj(data.x, data.y, data.dir);
    this.spawns.push(monster);
    return sprites.push(monster);
  };

  Interaction.prototype.spawnTypes = {
    "bat": Bat,
    "ghost": Ghost
  };

  return Interaction;

})();



},{"../_entities/bat.coffee":1,"../_entities/ghost.coffee":2}],14:[function(require,module,exports){
var Grid, Interaction, Link, Map,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Grid = require("./grid.coffee");

Link = require("../_entities/link.coffee");

Interaction = require("./interaction.coffee");

module.exports = Map = (function() {
  function Map(map) {
    this.update = bind(this.update, this);
    this.isLoaded = bind(this.isLoaded, this);
    this.init = bind(this.init, this);
    this.isTileOpen = bind(this.isTileOpen, this);
    this.isEntityAtTile = bind(this.isEntityAtTile, this);
    this.getTile = bind(this.getTile, this);
    this.getOffsetY = bind(this.getOffsetY, this);
    this.getOffsetX = bind(this.getOffsetX, this);
    this.getBlockY = bind(this.getBlockY, this);
    this.getBlockX = bind(this.getBlockX, this);
    this.drawTile = bind(this.drawTile, this);
    this._isLoaded = false;
    this.url = map;
    $.ajax({
      dataType: "json",
      type: "get",
      url: "/common/js/maps/" + this.url,
      success: this.init
    });
  }

  Map.prototype.drawTile = function(type, x, y) {
    var coords, image;
    coords = grid.getRelXy(x, y, 32, 32);
    image = this.textures[type];
    if (coords) {
      ctx.save();
      ctx.drawImage(image, coords.x, coords.y);
      return ctx.restore();
    }
  };

  Map.prototype.getBlockX = function(x) {
    if (x % 32 !== 0) {
      x -= x % 32;
    }
    return Math.floor(x / (32 * 50));
  };

  Map.prototype.getBlockY = function(y) {
    if (y % 32 !== 0) {
      y -= y % 32;
    }
    return Math.floor(y / (32 * 50));
  };

  Map.prototype.getOffsetX = function(x) {
    if (x % 32 !== 0) {
      x -= x % 32;
    }
    return (x % (32 * 50)) / 32;
  };

  Map.prototype.getOffsetY = function(y) {
    if (y % 32 !== 0) {
      y -= y % 32;
    }
    return (y % (32 * 50)) / 32;
  };

  Map.prototype.getTile = function(x, y) {
    var blockX, blockY, offsetX, offsetY;
    blockY = this.getBlockY(y);
    offsetY = this.getOffsetY(y);
    blockX = this.getBlockX(x);
    offsetX = this.getOffsetX(x);
    return this.data[blockY][blockX][offsetY][offsetX];
  };

  Map.prototype.isEntityAtTile = function(x, y) {
    var isAtTile;
    isAtTile = 0 <= sprites.findIndex(function(val) {
      var isAtCurrentLoc, isAtFutureLoc;
      isAtCurrentLoc = val.position.x === x && val.position.y === y;
      isAtFutureLoc = false;
      if (val.cycleTarget.x !== val.position.x && val.cycleTarget.y !== val.position.y) {
        isAtFutureLoc = val.cycleTarget.x === x && val.cycleTarget.y === y;
      }
      return isAtCurrentLoc || isAtFutureLoc;
    });
    return isAtTile;
  };

  Map.prototype.isTileOpen = function(x, y) {
    var open, tile;
    if (x >= grid.expanseX || x <= 0 || y >= grid.expanseY || y <= 0) {
      return false;
    }
    if (this.isEntityAtTile(x, y)) {
      return false;
    }
    tile = this.getTile(x, y);
    return open = {
      0: true,
      1: false,
      2: true,
      3: true,
      9: true
    }[tile];
  };

  Map.prototype.init = function(data) {
    var _this, height, width;
    this.data = data;
    height = this.data.length;
    width = this.data[0].length;
    window.grid = new Grid(128, 384, height * 32 * 50, width * 32 * 50);
    this.Link = new Link();
    this.interaction = new Interaction(this.url);
    rsc.load(["/common/images/grass.png", "/common/images/tree.png", "/common/images/flower.png", "/common/images/pavement.png", "/common/images/tile-pink.png"]);
    sprites.push(this.Link);
    _this = this;
    return rsc.onReady(function() {
      _this.textures = {
        0: rsc.get("/common/images/grass.png"),
        1: rsc.get("/common/images/tree.png"),
        2: rsc.get("/common/images/flower.png"),
        3: rsc.get("/common/images/pavement.png"),
        9: rsc.get("/common/images/tile-pink.png")
      };
      return _this._isLoaded = true;
    });
  };

  Map.prototype.isLoaded = function() {
    return this._isLoaded;
  };

  Map.prototype.update = function() {
    var block, blockX, blockY, offsetX, offsetY, x, y;
    y = grid.top;
    if (y % 32 !== 0) {
      y -= y % 32;
    }
    while (y < grid.bottom) {
      blockY = Math.floor(y / (32 * 50));
      offsetY = (y % (32 * 50)) / 32;
      x = grid.left;
      if (x % 32 !== 0) {
        x -= x % 32;
      }
      while (x < grid.right) {
        blockX = Math.floor(x / (32 * 50));
        offsetX = (x % (32 * 50)) / 32;
        block = this.data[blockY][blockX];
        this.drawTile(block[offsetY][offsetX], x, y);
        x += 32;
      }
      y += 32;
    }
    if (this.interaction.isLoaded) {
      return this.interaction.checkForSpawns();
    }
  };

  return Map;

})();



},{"../_entities/link.coffee":3,"./grid.coffee":11,"./interaction.coffee":13}],15:[function(require,module,exports){
var slice = [].slice;

module.exports = (function() {
  var _load, getImage, isReady, load, onFlagsSet, onReady, readyCallbacks, resourceCache;
  readyCallbacks = [];
  resourceCache = {};
  load = function(urlOrArr) {
    if (urlOrArr instanceof Array) {
      return urlOrArr.forEach(function(url) {
        return _load(url);
      });
    } else {
      return _load(urlOrArr);
    }
  };
  getImage = function(url) {
    return resourceCache[url];
  };
  isReady = function() {
    var i, k, len, ready;
    ready = true;
    for (i = 0, len = resourceCache.length; i < len; i++) {
      k = resourceCache[i];
      if (resourceCache.hasOwnProperty(k) && !resourceCache[k]) {
        ready = false;
      }
    }
    return ready;
  };
  onFlagsSet = function() {
    var args, callback, cloop;
    callback = arguments[0], args = 2 <= arguments.length ? slice.call(arguments, 1) : [];
    cloop = function() {
      var arg, i, isSet, len;
      isSet = true;
      for (i = 0, len = args.length; i < len; i++) {
        arg = args[i];
        if (typeof arg === "function") {
          if (!arg()) {
            isSet = false;
          }
        }
      }
      if (isSet) {
        return callback();
      } else {
        return setTimeout(cloop, 50);
      }
    };
    return cloop();
  };
  onReady = function(func) {
    return readyCallbacks.push(func);
  };
  _load = function(url) {
    var img;
    if (resourceCache[url]) {
      return resourceCache[url];
    } else {
      img = new Image();
      img.onload = function() {
        resourceCache[url] = img;
        if (isReady()) {
          return readyCallbacks.forEach(function(func) {
            return func();
          });
        }
      };
      resourceCache[url] = false;
      return img.src = url;
    }
  };
  return window.rsc = {
    load: load,
    get: getImage,
    onFlagsSet: onFlagsSet,
    onReady: onReady,
    isReady: isReady
  };
})();



},{}],16:[function(require,module,exports){
require("./_etc/polyfill.coffee");

require("./_etc/scroll.coffee");

require("./_system/resources.coffee");

require("./_system/input.coffee");

require("./_system/frame.coffee");



},{"./_etc/polyfill.coffee":4,"./_etc/scroll.coffee":5,"./_system/frame.coffee":10,"./_system/input.coffee":12,"./_system/resources.coffee":15}]},{},[16]);
