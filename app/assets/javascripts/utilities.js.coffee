$.fn.fade = (time) -> this.fadeOut time

$.fn.parentColor = () -> this.parent().css 'background-color', this.css 'background-color'

$(document).ajaxError (e, XHR, options) ->
	if(XHR.status == 401)
		$("#flash").show()
		$("#flash").append("<div class='alert'><p>"+ XHR.responseText + "</p></div>")
		$(".alert").fade(15000)

$.fn.addDialog = (partial, title) ->
	this.dialog
		autoOpen: true
		height: 500
		width: 600
		title: title
		open: -> $(this).html(partial)
		buttons:
			Cancel: -> $(this).dialog("close")

$.fn.addAutocomplete = () ->
  this.autocomplete
    source: this.data('autocomplete-source')