$(document).ready(function() {
	$('#top-sorttype').on("change",function(e){	
		loadDomain();
	});
	
	$('#top-sortdate').on("change",function(e){
		loadDomain();
	});
	
	$('#top-listtype').on("change",function(e){
		loadDomain();
	});
});


function loadDomain(){
$("#top-domain-box").html('<div style="text-align:center"><img src="'+app_url+'images/preloader.gif"/><br/></div>');
	$.ajax({
		url: app_url+'topdomain.jsp',
		method: 'POST',
		data: {
			tid:$("#alltid").val(),
			sortby:$("#top-sorttype"),
			sortdate:$("#top-sortdate"),
			listtype:$("#top-listtype"),
		},
		error: function(response)
		{						
			console.log(response);		
		},
		success: function(response)
		{   
			$("#top-domain-box").html(response);
		}
	});
	
}