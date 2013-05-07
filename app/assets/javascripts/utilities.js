 $.fn.fade = function(time){
	this.fadeOut(time);
};

$(document).ready(function(){
	$(".notice").fade(10000);
	$(".alert").fade(15000);
});