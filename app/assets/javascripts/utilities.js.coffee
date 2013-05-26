$.fn.fade = (time) -> this.fadeOut time

$.fn.parentColor = () -> this.parent().css 'background-color', this.css 'background-color'

profiles =
	window1200:
		height: 600
		width: 1200
		status:1
		center:1
	window800:
		height:800
		width:800
		status:1
	window200:
		height:200
		width:200
		status:1
		resizable:0
	windowCenter:
		height:300
		width:400
		center:1
	windowNotNew:
		height:300
		width:400
		center:1
		createnew:0
	windowCallUnload:
		height:300
		width:400
		center:1
		onUnload:unloadcallback
		
unloadcallback = () -> alert "unloaded"

$(document).ready -> $(".popupwindow").popupwindow profiles

