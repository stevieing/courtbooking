# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

nextID = (association) -> 
	$("ul[id^=" + association + "_]").length+1

jQuery ->
	$('form').on 'click', '.add_fields', (event) ->
		regexp = new RegExp($(this).data('id'), 'g')
		iD = nextID($(this).data('association'))
		$(this).parent().parent().before($(this).data('fields').replace(regexp, iD))
		$("<li><a class='remove_fields' href='#'>Remove</a></li>").appendTo("#" + $(this).data('association') + "_" + iD)
		event.preventDefault()

	$('form').on 'click', '.remove_fields', (event) ->
		$(this).parent().parent().remove()
		event.preventDefault()