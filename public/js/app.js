$(function(){
	//clear
	function clear(){
		$("#id").val("");
		$("#textarea").val("");
	}
	//show and hide form
	$("#fAdd").click(function(event) {
		event.preventDefault();
		clear();
		$("#formNotes").slideToggle();
		$("#save").show();
		$("#update").hide();
	});
	//save
	$("#save").on("click", function(event){
		event.preventDefault();
		$("#formNotes").slideUp();
		$("#save").hide();
		$.ajax({
		type: "POST",
		url: "/notes",
		data: "text=" + $("#textarea").val(),
		success: function(n){
			clear();
			n=n[0];
			if(n) {
$(".bag:last").after('<div class="bag"><button id="c_'+n[0]+'" class="float-right btn btn-danger btn-sm" data-dismiss="bag"> Delete</button><button id="e_'+n[0]+'" class="float-right btn btn-info btn-sm">Edit</button><b class="date">'+n[3]+'</b><p id="t_'+n[0]+'">'+n[2]+'</p></div>');
			}
		}
		});
	});
	//edit
	$(".container").on("click",'.bag [id^="e_"]', function(event){
		event.preventDefault();
		clear();
		var id = $(this).prop('id').split("_")[1];
		$("#formNotes").slideDown();
		$("#save").hide();
		$("#update").show();
		$("#id").val(id);
		$("#textarea").val($("#t_"+id).text());
	});
	//update
	$("#update").on("click", function(event){
		event.preventDefault();
		$("#formNotes").slideUp();
		$("#update").hide();
		$.ajax({
		type: "PUT",
		url: "/notes/"+$("#id").val(),
		data: "text=" + $("#textarea").val(),
		success: function(n){
			clear();
			n=n[0];
			if(n) {
			$(".bag>#t_"+n[0]).text(n[2]);
			}
		}
		});
	});
	//close and delete
	$(".container").on("click",'.bag [data-dismiss="bag"]', function(event){
		event.preventDefault();
		$(this).parent().hide();
		$.ajax({
		type: "DELETE",
		url: "/notes/"+$(this).prop('id').split("_")[1],
		success: function(r){
		alert("Deleted row: " + r);
		}
		});
	});
});