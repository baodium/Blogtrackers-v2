$(document).ready(function(){
	
$('.edittrackerpopaction').on("click",function(e){
e.preventDefault();	
ShowAnElement('.edittrackerpop');
ShowAnElement('.modalbackdrop');
})


$('.closedialog').on("click",function(e){
e.preventDefault();	
HideAnElement('.edittrackerpop');
HideAnElement('.modalbackdrop');
})
	
});


function HideAnElement(className)
{
$(className).addClass("hidden");	
}

function ShowAnElement(className)
{
$(className).removeClass("hidden");	
}

//delete tracker
$('.trackerdelete').click(function(e){
//
var confirmdeletetracker = confirm("Are you sure you want delete tracker?");

if(confirmdeletetracker)
{
	toastr.error("Deleting Tracker","Wait");
	var trackerid = $(this).attr("id");
	$.ajax({
		url: app_url+'tracker',
		method: 'POST',
		data: {
			action:"delete",
			tracker_id:trackerid,
		},
		error: function(response)
		{						
			console.log(response);		
		},
		success: function(response)
		{   
			console.log(response);
			if(response.indexOf("true")>-1){
				toastr.success('Tracker successfully deleted!','Success');
				//location.href=app_url+"trackerlist.jsp";
				
				console.log("tracker deleted")	
				// add an ajax to deleted tracker 
				// on success go back to tracker list
				setTimeout(function(){
					location.href = "trackerlist.jsp";	
				}, 2000);
				
			}else{
				toastr.error('Tracker could not be deleted!','Error');
			}
		}
	});
	


}


});