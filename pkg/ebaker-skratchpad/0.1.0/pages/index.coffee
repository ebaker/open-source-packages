class exports.Page extends lt3.Page
  template: ->
    div -> "hello #{@hello or 'world'}"
