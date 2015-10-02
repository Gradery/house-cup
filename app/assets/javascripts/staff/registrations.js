//= require jquery
//= require bootstrap
//= require jquery_ujs

$(document).ready(function(){
	$("#profileBtn").click(function(){
		$("#profile").show();
		$("#reports").hide();
	});

	$("#reportsBtn").click(function(){
		$("#profile").hide();
		$("#reports").show();
	});
});