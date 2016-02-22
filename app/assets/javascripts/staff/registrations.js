//= require jquery
//= require bootstrap
//= require jquery_ujs
var table;
$(document).ready(function(){
	$("#profileBtn").click(function(){
		$("#profile").show();
		$("#reports").hide();
		$("#roster").hide();
		$("li.active").removeClass("active");
		$(this).parent().addClass("active");
	});

	$("#reportsBtn").click(function(){
		$("#profile").hide();
		$("#reports").show();
		$("#roster").hide();
		$("li.active").removeClass("active");
		$(this).parent().addClass("active");
	});
	$("#rosterBtn").click(function(){
		$("#profile").hide();
		$("#reports").hide();
		$("#roster").show();
		$("li.active").removeClass("active");
		$(this).parent().addClass("active");
		if ( $.fn.dataTable.isDataTable( '.datatable' ) ) {
			table.destroy();
		}
		table = $('.datatable').DataTable({});
	});

	$("#generate_reports").click(function(){
		// get selected ids
		var ids = [];
		$(":checked").each(function(index, element){
			//console.log($(element));
			ids.push($(element).attr("id"));
		});
		//console.log(ids);
		if (ids !== []){
			//submit request
			$.post("/api/behavior_report",{
				members: ids
			})
			.success(function(data){
				//console.log(data);
				toastr.success("Report Generation Requested Successfully");
				$(":checked").each(function(index, element){
					$(element).attr("checked", false);
				});
			})
			.error(function(error){
				//console.log(error);
				toastr.error("Uh oh, something went wrong and we couldn't queue up your request. Please try again later.")
			});
		}
	});
});