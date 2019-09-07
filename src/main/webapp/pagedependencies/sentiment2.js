var color = "#0080CC";
$('.blogpost_link').on("click", function(){

	var post_id = $(this).attr("id");
	$('.blogpost_link').removeClass("activeselectedblog");
	$(".viewpost").addClass("makeinvisible");
	$(this).addClass("activeselectedblog");
	$(this).parent().children(".viewpost").removeClass("makeinvisible");
	//alert(post_id);
	var color = "#0080CC";
	loadChart(post_id,color);

});

function loadChart(postid,color){
	var post_id = postid;
	post_id= post_id.split("-");
	$("#mainCarInd").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
	//grab all id of blog and perform an ajax request
	$.ajax({
		url: app_url+"subpages/sentiment.jsp",
		method: 'POST',
		data: {
			action:"getsentiment",
			key:"blogpost_id",
			value:post_id[0],
			source:"sentiment",
			section:"time_orientation",
			date_from:$("#date_from").val(),
			date_to:$("#date_to").val(),
			postno:post_id[2],
			//color:post_id[1]
			color:color
		},
		error: function(response)
		{						
			//console.log(response);
			console.log(color);
			$("#carouseller").html(response);
		},
		success: function(response)
		{   
			//console.log(response);
			$("#mainCarInd").delay(3000).html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />").delay(2000).html(response);
			/* $.getScript("assets/js/generic.js", function(data, textStatus, jqxhr) {	
			  });*/
		}
	});
	

}



