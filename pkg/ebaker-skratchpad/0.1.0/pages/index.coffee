class exports.Page extends lt3.Page
  events:
    'keypress .insert': 'newSkratch'
    'click .edit-btn': 'editSkratch'
    'keypress .update': 'saveSkratch'
    'blur .update': 'stopEditing'
    'click .remove-btn': 'destroySkratch'

  newSkratch: (e) ->
    return unless e.keyCode is 13
    new_note = @$el.find('.insert').val()
    skratches = lt3.page.get('data.skratches').val()
    new_skratch = {note: new_note, timestamp: $.now()}
    # add skratch to skratches array
    skratches = new Array(new_skratch).concat skratches
    lt3.page.get('data.skratches').set skratches, (err) =>
      if err
        console.log err
        $.alert 'An error has occured in saving, plase try again.'

  editSkratch: (e) ->
    $li = $(e.currentTarget).closest 'li'
    # console.log($li)
    $li.addClass 'editing'
    $li.find('.update').focus()

  saveSkratch: (e) ->
    # console.log e
    return unless e.keyCode is 13
    $li = $(e.currentTarget).closest 'li'
    # console.log $li
    new_note = $li.find('.update').val()
    data_id = $li.attr 'data-id'
    skratches = lt3.page.get('data.skratches').val()
    skratch = {note: new_note, timestamp: $.now()}
    # update skratch in skratches array
    skratches[data_id] = skratch
    lt3.page.get('data.skratches').set skratches, (err) =>
      if err
        console.log err
        $.alert 'An error has occured in saving, plase try again.'

  stopEditing: (e) ->
    $li = $(e.currentTarget).closest 'li'
    # console.log $li
    $li.removeClass 'editing'

  destroySkratch: (e) ->
    $li = $(e.currentTarget).closest 'li'
    # console.log $li
    data_id = $li.attr 'data-id'
    skratches = lt3.page.get('data.skratches').val()
    # remove skratch from skratches array
    skratches.splice data_id, 1
    lt3.page.get('data.skratches').set skratches, (err) =>
      if err
        console.log err
        $.alert 'An error has occured in saving, plase try again.'

  template: ->
    # setup header here for now
    div id: 'header', ->
      div class: 'title', ->
        'Skratchpad'

    # create skratch
    div class: 'new-skratch', ->
      input class:'insert', type: 'text',  placeholder: 'type text note here...'

    # read scratches
    renderSkratch = (index, skratch) ->
      li class: 'skratch', 'data-id': index, ->
        div class: 'skratch-view', ->
          div class: 'note', ->
            skratch.note
          span class: 'timestamp', ->
            new Date(skratch.timestamp).toString()
        # skratch edit and remove buttons
        button class: 'remove-btn control', ->
          i class: 'icon icon-cancel'
        button class: 'edit-btn control', ->
          i class: 'icon icon-pencil'
        # update scratches
        input class: 'update', type: 'text', value: skratch.note

    if @skratches
      ul class: 'skratch', ->
        # setup id as index in array
        for skratch, index in @skratches
          renderSkratch index, skratch
