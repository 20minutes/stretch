_ = 
  toCapitalize: (name) ->
    while (indice = name.indexOf "-") > -1
      name = name.replace "-", ""
      suffixe = name.slice(indice)
      suffixe = suffixe.replace suffixe[0], suffixe[0].toUpperCase()
      name = name.replace name.slice(indice), suffixe      
    name

class Stretch
  max: null,
  min: null,
  
  constructor: (elm) ->
    id = "#{elm.attr('id')}-textmetrics"    
    if typeof @_shadow is "undefined"
      shadow = $("##{id}")
      if not shadow.get(0)
        shadow = document.createElement "textarea"
        shadow.id = id
        shadow.rows = 1
        shadow.className = "textmetrics"
        shadow = $(shadow)      
        properties = ['font-size', 'font-style', 'font-weight', 'font-family', 'line-height', 'word-wrap', "width"]
        for property in  properties
          test = @css elm, property
          value = elm.css property
          shadow.css property, value
        shadow.css "height", @css(shadow, "line-height")
        shadow.appendTo document.body
        @_shadow = shadow
    elm.addClass "resizable"
    elm.css("min-height", "#{shadow.height()}px") if @css(elm, "min-height") is "0px"
    @min = @css(elm, "height").replace("px", "")
    @max = max*1 if (max = @css(elm, "max-height").replace("px", "")) isnt "none"
    @_node = elm
    @resize()
  
  measure: =>
    @_shadow.val "#{@_node.val()}..."
    {
      width: @_shadow.get(0).scrollWidth
      height: @_shadow.get(0).scrollHeight
    }
  destroy: =>
    document.body.removeChild @_shadow
    
  css: (el, property) =>
    el.css(property) or el.css(_.toCapitalize property)
    
  resize: =>
    height = this.measure().height
    height = Math.max @min, height
    height = Math.min height, @max if @max
    @_node.css "height", height