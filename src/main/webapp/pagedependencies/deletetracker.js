$(document).ready(function(){	
	var theme =  Cookies.get('theme');
	console.log(theme);	
// handles individual tracker deletion
$('.deletetracker').on("click", function(){
var tid = $(this).children(".tid").val();
confirmdelete = confirm("Are you sure you want to delete this tracker?");
if(confirmdelete)
{
// start deleting process
//	console.log(tid);	
//	 $.getScript("assets/js/toastr.js", function(data, textStatus, jqxhr) {
//		 loadCSS("assets/css/toastr.css");	
//toastr.error("Deleting Tracker","Wait");
//	 });
	
	$.ajax({
		url: app_url+'tracker',
		method: 'POST',
		data: {
			action:"delete",
			tracker_id:tid,
		},
		error: function(response)
		{						
			console.log(response);	
			toastr.error('Tracker could not be deleted!','Error');
		},
		success: function(response)
		{   
			//console.log(response);
			if(response.indexOf("success")>-1){
//				 $.getScript("assets/js/toastr.js", function(data, textStatus, jqxhr) {
//					 loadCSS("assets/css/toastr.css");
				toastr.success('Tracker successfully deleted!','Success');
//				 });
				//location.href=app_url+"trackerlist.jsp";
				
				console.log("tracker deleted")	
				// add an ajax to deleted tracker 
				// on success go back to tracker list
				setTimeout(function(){
					location.href = "trackerlist.jsp";	
				}, 2000);
				
			}else{
//				 $.getScript("assets/js/toastr.js", function(data, textStatus, jqxhr) {
//					 loadCSS("assets/css/toastr.css");
				toastr.error('Tracker could not be deleted!','Error');
				// });
			}
		}
	});
	
}

//console.log(e)	

})	
	
	
});