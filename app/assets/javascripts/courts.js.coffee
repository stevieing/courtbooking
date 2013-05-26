# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
	$(".notice").fade 10000
	$(".alert").fade 15000
	$(".booked").parentColor();
	$(".past").parentColor();
	return
