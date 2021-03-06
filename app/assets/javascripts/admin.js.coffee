# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

nextID = (association) ->
	$("ul[id^=" + association + "_]").length+1

jQuery ->
	$('form').on 'click', '.add-fields', (event) ->
		regexp = new RegExp($(this).data('id'), 'g')
		$(this).parent().parent().before($(this).data('fields').replace(regexp, nextID($(this).data('association'))))
		event.preventDefault()

	$('form').on 'click', '.remove-fields', (event) ->
		$(this).parent().parent().remove()
		event.preventDefault()

jQuery ->
  $(".datepicker").datepicker
    dateFormat: 'dd-mm-yy'