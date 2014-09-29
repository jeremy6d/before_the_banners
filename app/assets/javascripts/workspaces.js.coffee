$ ->
  $('#workspaces').sortable
    update: ->
      $.ajax $('li#back-link a').attr('href') + "/workspaces/sort",
        type: 'PUT'
        handle: '.handle'
        dataType: 'script'
        data: $('#workspaces').sortable('serialize')
        complete: ->
          $('#workspaces').effect('highlight')

