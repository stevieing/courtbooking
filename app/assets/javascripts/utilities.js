$.fn.fade = function(time){
	this.fadeOut(time);
};

$(document).ready(function(){
	$(".notice").fade(5000);
	$(".alert").fade(10000);
});