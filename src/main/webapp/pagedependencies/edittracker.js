<<<<<<< HEAD
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
			//alert(tracker_id)
			if(response.indexOf("true")>-1){
				//alert(tracker_id)
				toastr.success('Tracker successfully deleted!','Success');
				//location.href=app_url+"trackerlist.jsp";
				uploadTerms(tid, "delete")
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

function uploadTerms(tid, type){
	$.ajax({
		url: app_url+'tracker',
		method: 'POST',
		data: {
			action:"uploadTerms",
			tracker_id:tid,
			type:type,
			
		},
		error: function(response)
		{
			//alert('could not compute terms')
			console.log('could not compute terms')
		},
		success: function(response)
		{
			console.log('term response',response);
		}
	});
}

function uploadClusters(tid){
	$.ajax({
		url: app_url+'tracker',
		method: 'POST',
		data: {
			action:"uploadClusters",
			tracker_id:tid,
			
			
		},
		error: function(response)
		{
			//alert('could not compute terms')
			console.log('could not compute terms')
		},
		success: function(response)
		{
			console.log('cluster response',response);
		}
	});
=======
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
			//alert(tracker_id)
			if(response.indexOf("true")>-1){
				//alert(tracker_id)
				toastr.success('Tracker successfully deleted!','Success');
				//location.href=app_url+"trackerlist.jsp";
				uploadTerms(tid, "delete")
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

function uploadTerms(tid, type){
	$.ajax({
		url: app_url+'tracker',
		method: 'POST',
		data: {
			action:"uploadTerms",
			tracker_id:tid,
			type:type,
			
		},
		error: function(response)
		{
			//alert('could not compute terms')
			console.log('could not compute terms')
		},
		success: function(response)
		{
			console.log('term response',response);
		}
	});
}

function uploadClusters(tid){
	$.ajax({
		url: app_url+'tracker',
		method: 'POST',
		data: {
			action:"uploadClusters",
			tracker_id:tid,
			
			
		},
		error: function(response)
		{
			//alert('could not compute terms')
			console.log('could not compute terms')
		},
		success: function(response)
		{
			console.log('cluster response',response);
		}
	});
>>>>>>> 1f92e31eaa52c61d7b7996ab5ec5a9cf214df293
}