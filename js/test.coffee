$(document).ready ->
  field = new Stretch $("#description")
  field._node.bind "keyup", field.resize