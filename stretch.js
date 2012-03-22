var Stretch,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Stretch = (function() {

  Stretch.prototype.max = null;

  Stretch.prototype.min = null;

  Stretch.prototype.shadow = function() {
    return $("#" + this.id + "-textmetrics");
  };

  Stretch.prototype.el = function() {
    var el;
    el = $("#" + this.id);
    if (!el.hasClass("resizable")) el.addClass("resizable");
    return el;
  };

  function Stretch(elm) {
    this.resize = __bind(this.resize, this);
    this.css = __bind(this.css, this);
    this.destroy = __bind(this.destroy, this);
    this.measure = __bind(this.measure, this);
    this.el = __bind(this.el, this);
    var max, properties, property, shadow, value, _i, _len;
    this.id = elm.attr('id');
    shadow = this.shadow();
    if (!shadow.get(0)) {
      shadow = document.createElement("textarea");
      shadow.id = "" + this.id + "-textmetrics";
      shadow.rows = 1;
      shadow.className = "textmetrics";
      shadow = $(shadow);
      properties = ['font-size', 'font-style', 'font-weight', 'font-family', 'line-height', 'word-wrap', "width"];
      for (_i = 0, _len = properties.length; _i < _len; _i++) {
        property = properties[_i];
        value = this.css(elm, property);
        shadow.css(property, value);
      }
      shadow.css("height", this.css(shadow, "line-height"));
      shadow.appendTo(document.body);
    }
    if (this.css(elm, "min-height") === "0px") {
      elm.css("min-height", "" + (shadow.height()) + "px");
    }
    this.min = this.css(elm, "height").replace("px", "");
    if ((max = this.css(elm, "max-height").replace("px", "")) !== "none") {
      this.max = max * 1;
    }
    $(document.body).delegate("#" + (elm.attr('id')), "keyup", this.resize);
  }

  Stretch.prototype.capitalize = function(name) {
    var indice, suffixe;
    while ((indice = name.indexOf("-")) > -1) {
      name = name.replace("-", "");
      suffixe = name.slice(indice);
      suffixe = suffixe.replace(suffixe[0], suffixe[0].toUpperCase());
      name = name.replace(name.slice(indice), suffixe);
    }
    return name;
  };

  Stretch.prototype.measure = function() {
    var shadow;
    shadow = this.shadow();
    shadow.val("" + (this.el().val()) + "...");
    return {
      width: shadow.get(0).scrollWidth,
      height: shadow.get(0).scrollHeight
    };
  };

  Stretch.prototype.destroy = function() {
    return document.body.removeChild(this.shadow);
  };

  Stretch.prototype.css = function(el, property) {
    return el.css(property) || el.css(this.capitalize(property));
  };

  Stretch.prototype.resize = function() {
    var height;
    height = this.measure().height;
    height = Math.max(this.min, height);
    if (this.max) height = Math.min(height, this.max);
    return this.el().css("height", height);
  };

  return Stretch;

})();
