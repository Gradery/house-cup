//= require jquery
//= require bootstrap
//= require jquery_ujs

$(document).ready(function(){
	$("#profileBtn").click(function(){
		$("#profile").show();
		$("#reports").hide();
		$("li.active").removeClass("active");
		$(this).parent().addClass("active");
	});

	$("#reportsBtn").click(function(){
		$("#profile").hide();
		$("#reports").show();
		$("li.active").removeClass("active");
		$(this).parent().addClass("active");
	});

	$("#generate_reports").click(function(){
		// get selected ids
		var ids = [];
		$(":checked").each(function(index, element){
			console.log($(element));
			ids.push($(element).attr("id"));
		});
		console.log(ids);
		if (ids !== []){
			//submit request
			$.post("/api/behavior_report",{
				members: ids
			})
			.success(function(data){
				console.log(data);
				toastr.success("Report Generation Requested Successfully");
				$(":checked").each(function(index, element){
					$(element).attr("checked", false);
				});
			})
			.error(function(error){
				console.log(error);
				toastr.error("Uh oh, something went wrong and we couldn't queue up your request. Please try again later.")
			});
		}
	});
});