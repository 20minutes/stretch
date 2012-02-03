
$(document).ready(function() {
  var field;
  field = new Stretch($("#description"));
  return field._node.bind("keyup", field.resize);
});
