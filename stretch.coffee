class Stretch
  max: null,
  min: null,
  
  shadow: ->
    $("##{@id}-textmetrics")
    
  el: =>
    el = $("##{@id}")
    el.addClass("resizable") if not el.hasClass "resizable"
    el
  
  constructor: (elm) ->
    @id = elm.attr('id')     
    shadow = @shadow()    
    if not shadow.get(0)
      shadow = document.createElement "textarea"
      shadow.id = "#{@id}-textmetrics"
      shadow.rows = 1
      shadow.className = "textmetrics"
      shadow = $(shadow)      
      properties = ['font-size', 'font-style', 'font-weight', 'font-family', 'line-height', 'word-wrap', "width"]
      for property in properties
        value = @css elm, property
        shadow.css property, value
      shadow.css "height", @css(shadow, "line-height")
      shadow.appendTo document.body
    elm.css("min-height", "#{shadow.height()}px") if @css(elm, "min-height") is "0px"
    @min = @css(elm, "height").replace("px", "")
    @max = max*1 if (max = @css(elm, "max-height").replace("px", "")) isnt "none"        
    $(document.body).delegate "##{elm.attr('id')}", "keyup", @resize
  
  capitalize: (name) ->
    while (indice = name.indexOf "-") > -1
      name = name.replace "-", ""
      suffixe = name.slice indice
      suffixe = suffixe.replace suffixe[0], suffixe[0].toUpperCase()
      name = name.replace name.slice(indice), suffixe      
    name
  
  measure: =>  
    shadow = @shadow()
    shadow.val "#{@el().val()}..."
    width: shadow.get(0).scrollWidth
    height: shadow.get(0).scrollHeight
  
  destroy: =>
    document.body.removeChild @_shadow
    
  css: (el, property) =>
    el.css(property) or el.css(@capitalize property)
    
  resize: =>
    height = this.measure().height
    height = Math.max @min, height
    height = Math.min height, @max if @max
    @el().css "height", height
