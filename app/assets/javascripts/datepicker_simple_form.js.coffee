$ ->
  $("input.datepicker").each (i) ->
    $(this).datepicker
      dateFormat: "mm/dd/yy"
      altFormat: "yy-mm-dd"
      altField: $(this).next()