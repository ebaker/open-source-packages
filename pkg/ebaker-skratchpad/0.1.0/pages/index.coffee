class exports.Page extends lt3.Page
  events:
    'keypress .insert': 'newSkratch'
    'click .edit-btn': 'editSkratch'
    'keypress .update': 'saveSkratch'
    'blur .update': 'stopEditing'
    'click .remove-btn': 'destroySkratch'

  newSkratch: (e) ->
    if e.keyCode == 13
      new_note = $('.insert').val()
      skratches = lt3.page.get('data.skratches').val()
      new_skratch = {note: new_note, timestamp: new Date().toString()}
      skratches = new Array(new_skratch).concat(skratches)
      lt3.page.get('data.skratches').set(skratches)

  editSkratch: (e) ->
    $li = $(e.target).closest('li')
    # console.log($li)
    $li.addClass('editing')
    $li.find('.update').focus()

  saveSkratch: (e) ->
    if e.keyCode == 13
      $li = $(e.target).closest('li')
      # console.log($li)
      new_note = $li.find('.update').val()
      data_id = $li.attr('data-id')
      skratches = lt3.page.get('data.skratches').val()
      skratch = skratches[data_id]
      skratch.note = new_note
      skratches[data_id] = skratch
      lt3.page.get('data.skratches').set(skratches)

  stopEditing: (e) ->
    $li = $(e.target).closest('li')
    # console.log($li)
    $li.removeClass('editing')


  destroySkratch: (e) ->
    $li = $(e.target).closest('li')
    # console.log($li)
    data_id = $li.attr('data-id')
    skratches = lt3.page.get('data.skratches').val()
    skratches.splice(data_id, 1)
    lt3.page.get('data.skratches').set(skratches)

  template: ->
    # setup header here for now
    div id: 'header', ->
      div class: 'title', ->
        'Skratchpad'

    # create skratch
    div class: 'new-skratch', ->
      input class:'insert', type: 'text',  placeholder: 'type some text here...'

    # read scratches
    renderSkratch = (skratch, arr_index) ->
      li class: 'skratch', 'data-id': arr_index, ->
        div class: 'skratch-view', ->
          div class: 'note', ->
            skratch.note
          span class: 'timestamp', ->
            skratch.timestamp
        # skratch control buttons
        button class: 'remove-btn control', ->
          i class: 'remove-btn icon icon-cancel'
        button class: 'edit-btn control', ->
          i class: 'edit-btn icon icon-pencil'
        # update scratches
        input class: 'update', type: 'text', value: skratch.note

    if @skratches
      ul class: 'skratch', ->
        # setup id as index in array
        data_id = 0
        for skratch in @skratches
          renderSkratch skratch, data_id
          data_id = data_id + 1
