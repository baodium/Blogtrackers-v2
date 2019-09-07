// delete all blog from tracker action


//$('.blogger-select').on("click", function(){

$(document).delegate('.blogger-select', 'click', function(){
	$(".blogger-select").removeClass("abloggerselected");
	$(this).addClass("abloggerselected");

	var date_start = $("#date_start").val();
	var date_end = $("#date_end").val();
	var blogger = $(this).attr("id");
	
	var blg = blogger.split("***");
	
	var bloog = blg[0];
	bloog = bloog.replaceAll("__"," ");
	
	$(".activeblogger").html(bloog);
	$(".activeblog").html(blg[2]);
	
	$("#author").val(bloog);
	$("#blogid").val(blg[1]);
	

	

	//loadInfluence(bloog,blg[1]);

	loadInfluence(date_start,date_end);
	//getTotalPost(bloog,blg[1]);
	//getTotalInfluence(bloog,blg[1]);
	loadChart(bloog,blg[1]);
	//loadTerms(bloog,blg[1]);
	loadStat(bloog,blg[1]);
});


//$('.blogpost_link').on("click", function(){
$(document).delegate('.blogpost_link', 'click', function(){
	var post_id = $(this).attr("id");
	//alert(post_id);
	//console.log(post_id);
	//console.log("nddshhfjsdfjhds")
	$("#blogpost_detail").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
	$(".viewpost").addClass("makeinvisible");
	$('.blogpost_link').removeClass("activeselectedblog");
	$('#'+post_id).addClass("activeselectedblog");
	$(this).parent().children(".viewpost").removeClass("makeinvisible");
	//grab all id of blog and perform an ajax request
	$.ajax({
		url: app_url+'tracker',
		method: 'POST',
		data: {
			action:"fetchpost",
			key:"blogpost_id",
			value:post_id,
			source:"influence",
			sort:"influence_score",
			section:"detail_table"
		},
		error: function(response)
		{						
			//console.log(response);
			$("#blogpost_detail").html(response);
		},
		success: function(response)
		{   
			//console.log(response);
			$("#blogpost_detail").html(response).hide();
			$("#blogpost_detail").fadeIn(700);
			
			/*$.getScript("pagedependencies/influence.js", function(data, textStatus, jqxhr) {
				
			});*/
		}
	});
});


function loadChart(blogger,blog_id){
	$("#chart-container").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
	$.ajax({
		url: app_url+"subpages/influencechart.jsp",
		method: 'POST',
		data: {
			action:"getchart",
			blogger:blogger,
			blog_id:blog_id,
			sort:"influence_score",
			date_start:$("#date_start").val(),
			date_end:$("#date_end").val(),
		},
		error: function(response)
		{						
			//console.log(response);
			$("#chart-container").html(response);
		},
		success: function(response)
		{   

		$("#chart-container").delay(3000).html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />").delay(2000).html(response);
		
		}
	});
}

function loadInfluence(start_date,end_date){
	$("#influence_table").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
	$("#blogpost_detail").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
	
	var blogger = $("#author").val();
	var blog_id =$("#blogid").val();
	
	
	
	$("#date_start").val(start_date);
	$("#date_end").val(end_date);
	
	//getTotalInfluence(blogger,blog_id);
	
	loadTerms(blogger,blog_id);
	
	$.ajax({
		url: app_url+"subpages/postingfrequencyinfluence.jsp",
		method: 'POST',
		data: {
			action:"getchart",
			blogger:blogger,
			blog_id:blog_id,
			sort:"influence_score",
			date_start:start_date,
			date_end:end_date,
		},
		error: function(response)
		{						
			//console.log(response);
			$("#influence_table").html(response);
		},
		success: function(response)
		{   
			
			$("#influence_table").delay(3000).html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />").delay(2000).html(response);
			/* $.getScript("assets/vendors/DataTables/datatables.min.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/dataTables.bootstrap4.min.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/Buttons-1.5.1/js/buttons.flash.min.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/Buttons-1.5.1/js/dataTables.buttons.min.js", function(data, textStatus, jqxhr) {	});
			 
			 $.getScript("assets/vendors/DataTables/pdfmake-0.1.32/pdfmake.min.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/pdfmake-0.1.32/vfs_fonts.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/Buttons-1.5.1/js/buttons.html5.min.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/Buttons-1.5.1/js/buttons.print.min.js", function(data, textStatus, jqxhr) {	});*/
	
			//$("#influence_table").html(response);
			loadSinglePost(blogger,blog_id);
			 $.getScript("assets/js/generic.js", function(data, textStatus, jqxhr) {	
			  });
			 //console.log("loadinfluence")
		}
	});
}


function loadTerms(blogger,blog_id){
	$("#tagcloudbox").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
	var blger = blogger.replaceAll(" ","__");
	//console.log("Posts:"+$("#postby"+blger).val());
	$.ajax({
		url: app_url+"subpages/influenceterm.jsp",
		method: 'POST',
		data: {
			action:"getchart",
			post_ids:$("#postby"+blger).val(),
			blogger:blogger,
			date_start:$("#date_start").val(),
			sort:"influence_score",
			date_end:$("#date_end").val(),
		},
		error: function(response)
		{						
			//console.log(response);
			$("#tagcloudbox").html(response);
		},
		success: function(response)
		{   
			//console.log(response);
			$("#tagcloudbox").delay(3000).html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />").delay(2000).html(response);
			/* $.getScript("assets/js/generic.js", function(data, textStatus, jqxhr) {	
			  });*/
		}
	});	
}



function loadSinglePost(blogger,blog_id){
	$("#blogpost_detail").html("<img src='"+app_url+"images/loading.gif'");
	
	$.ajax({
		url: app_url+"subpages/postingfrequencypostdetail.jsp",
		method: 'POST',
		data: {
			action:"getchart",
			blogger:blogger,
			blog_id:blog_id,
			sort:"influence_score",
			date_start:$("#date_start").val(),
			date_end:$("#date_end").val(),
		},
		error: function(response)
		{						
			//console.log(response);
			$("#blogpost_detail").html(response);
		},
		success: function(response)
		{   
			//console.log(response);
			//$("#blogpost_detail").html(response);
			$("#blogpost_detail").delay(3000).html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />").delay(2000).html(response);
			
			 $.getScript("assets/vendors/DataTables/datatables.min.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/dataTables.bootstrap4.min.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/Buttons-1.5.1/js/buttons.flash.min.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/Buttons-1.5.1/js/dataTables.buttons.min.js", function(data, textStatus, jqxhr) {	});
			 
			 $.getScript("assets/vendors/DataTables/pdfmake-0.1.32/pdfmake.min.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/pdfmake-0.1.32/vfs_fonts.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/Buttons-1.5.1/js/buttons.html5.min.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/Buttons-1.5.1/js/buttons.print.min.js", function(data, textStatus, jqxhr) {	});
			 //$.getScript("pagedependencies/influence.js?v=1980", function(data, textStatus, jqxhr) {	});
			 
		}
	});	
}

function getTotalPost(blogger,blog_id){
	$(".total-post").html("");
	$.ajax({
		url: app_url+"subpages/postingfrequencypostdetail.jsp",
		method: 'POST',
		data: {
			action:"gettotal",
			blogger:blogger,
			blog_id:blog_id,
			sort:"influence_score",
			date_start:$("#date_start").val(),
			date_end:$("#date_end").val(),
		},
		error: function(response)
		{						
			//console.log(response);
			$(".total-post").html(response);
		},
		success: function(response)
		{   
			//console.log(response);
			$(".total-post").html(response);
				
		}
	});	
}

function getTotalInfluence(blogger,blog_id){
	$(".total-influence").html("");
	$.ajax({
		url: app_url+"subpages/postingfrequencypostdetail.jsp",
		method: 'POST',
		data: {
			action:"gettotalinfluence",
			blogger:blogger,
			blog_id:blog_id,
			sort:"influence_score",
			date_start:$("#date_start").val(),
			date_end:$("#date_end").val(),
		},
		error: function(response)
		{						
			//console.log(response);
			$(".total-influence").html(response);
		},
		success: function(response)
		{   
			//console.log(response);
			$(".total-influence").html(response);
				
		}
	});	
}


function loadStat(blogger,blog_id){
	$(".total-influence").html("<img src='images/loading.gif' />");
	$(".total-post").html("<img src='images/loading.gif' />");
	$(".total-sentiment").html("<img src='images/loading.gif' />");
	$(".total-comments").html("<img src='images/loading.gif' />");
	$.ajax({
		url: app_url+"subpages/influencedetail.jsp",
		method: 'POST',
		data: {
			action:"getstats",
			blogger:blogger,
			blog_id:blog_id,
			sort:"influence_score",
			date_start:$("#date_start").val(),
			date_end:$("#date_end").val(),
		},
		error: function(response)
		{						
			//console.log(response);
			//$("#overall-chart").html(response);
		},
		success: function(response)
		{   
		
		response = response.trim();
		//console.log(response);
		var data = JSON.parse(response);
		$(".total-influence").html(data.totalinfluence);
		$(".total-post").html(data.totalpost);
		$(".total-sentiment").html(data.totalsentiment);
		$(".total-comments").html(data.totalcomment);
		//$("#overall-chart").delay(3000).html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />").delay(2000).html(response);
			/* $.getScript("assets/js/generic.js", function(data, textStatus, jqxhr) {	
			  });*/
		}
	});
}

