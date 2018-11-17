$('.blogger-select').on("click", function(){
	
	$(".blogger-select").removeClass("abloggerselected");
	$(this).addClass("abloggerselected");

	var date_start = $("#date_start").val();
	var date_end = $("#date_end").val();
	var blogger = $(this).attr("id");
	
	
	var blg = blogger.split("***");
	
	var bloog = blg[0];
	bloog = bloog.replaceAll("_"," ");
	
	$(".activeblogger").html(bloog);
	$(".activeblog").html(blg[2]);
	
	$("#author").val(bloog);
	$("#blogid").val(blg[1]);
	

	getTotalPost(bloog,blg[1]);
	getTopLocation(bloog,blg[1]);
	loadTopKeyword(bloog,blg[1]);
	
	loadChart(bloog,blg[1]);
	loadTerms(bloog,blg[1]);
	loadSentiments(bloog,blg[1]);
	
	loadInfluence(date_start,date_end);


});



$('.blogpost_link').on("click", function(){

	var post_id = $(this).attr("id");
	//alert(post_id);
	console.log(post_id);
	console.log("nddshhfjsdfjhds")
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
		}
	});
	
});

function loadChart(blogger,blog_id){
	$("#chart-container").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
	$.ajax({
		url: app_url+"subpages/postingfrequencychart.jsp",
		method: 'POST',
		data: {
			action:"getchart",
			blogger:blogger,
			blog_id:blog_id,
			sort:"date",
			date_start:$("#date_start").val(),
			date_end:$("#date_end").val(),
		},
		error: function(response)
		{						
			console.log(response);
			$("#chart-container").html(response);
		},
		success: function(response)
		{   

		$("#chart-container").delay(3000).html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />").delay(2000).html(response);

			/* $.getScript("assets/js/generic.js", function(data, textStatus, jqxhr) {	
			  });*/
		}
	});
	
}

function loadInfluence(start_date,end_date){
	$("#influence_table").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
	$("#blogpost_detail").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
	
	var blogger = $("#author").val();
	var blog_id =$("#blogid").val();
	
	$.ajax({
		url: app_url+"subpages/postingfrequencyinfluence.jsp",
		method: 'POST',
		data: {
			action:"getchart",
			blogger:blogger,
			blog_id:blog_id,
			sort:"date",
			date_start:start_date,
			date_end:end_date,
		},
		error: function(response)
		{						
			console.log(response);
			$("#influence_table").html(response);
		},
		success: function(response)
		{   
			console.log(response);
			$("#influence_table").delay(3000).html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />").delay(2000).html(response);
			 $.getScript("assets/vendors/DataTables/datatables.min.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/dataTables.bootstrap4.min.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/Buttons-1.5.1/js/buttons.flash.min.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/Buttons-1.5.1/js/dataTables.buttons.min.js", function(data, textStatus, jqxhr) {	});
			 
			 $.getScript("assets/vendors/DataTables/pdfmake-0.1.32/pdfmake.min.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/pdfmake-0.1.32/vfs_fonts.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/Buttons-1.5.1/js/buttons.html5.min.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/Buttons-1.5.1/js/buttons.print.min.js", function(data, textStatus, jqxhr) {	});
			 
			 $.getScript("pagedependencies/postingfrequency.js?v=1980", function(data, textStatus, jqxhr) {	});
			 
			 
			//$("#influence_table").html(response);
			loadSinglePost(blogger,blog_id);
			/* $.getScript("assets/js/generic.js", function(data, textStatus, jqxhr) {	
			  });*/
		}
	});
	
}




function loadTerms(blogger,blog_id){
	$("#tagcloudbox").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
	var blger = blogger.replaceAll(" ","_");
	$.ajax({
		url: app_url+"subpages/postingfrequencyterm.jsp",
		method: 'POST',
		data: {
			action:"getchart",
			blogger:blogger,
			post_ids:$("#postby"+blger).val(),
			date_start:$("#date_start").val(),
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

function loadTopKeyword(blogger,blog_id){
	$(".most-used-keyword").html("");
	var blger = blogger.replaceAll(" ","_");
	$.ajax({
		url: app_url+"subpages/postingfrequencyterm.jsp",
		method: 'POST',
		data: {
			action:"gettopkeyword",
			blogger:blogger,
			post_ids:$("#postby"+blger).val(),
			date_start:$("#date_start").val(),
			date_end:$("#date_end").val(),
		},
		error: function(response)
		{						
			//console.log(response);
			$(".most-used-keyword").html(response);
		},
		success: function(response)
		{   
			$(".most-used-keyword").html(response);
		}
	});
	
}


function loadSentiments(blogger,blog_id){
	$("#entity_table").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
	
	$.ajax({
		url: app_url+"subpages/postingfrequencysentiment.jsp",
		method: 'POST',
		data: {
			action:"getchart",
			blogger:blogger,
			blog_id:blog_id,
			date_start:$("#date_start").val(),
			date_end:$("#date_end").val(),
		},
		error: function(response)
		{						
			//console.log(response);
			$("#entity_table").html(response);
		},
		success: function(response)
		{   
			//console.log(response);
			$("#entity_table").delay(3000).html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />").delay(2000).html(response);
			/* $.getScript("assets/js/generic.js", function(data, textStatus, jqxhr) {	
			  });*/
		}
	});
	
}

function loadSinglePost(blogger,blog_id){
	$("#blogpost_detail").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
	
	
	$.ajax({
		url: app_url+"subpages/postingfrequencypostdetail.jsp",
		method: 'POST',
		data: {
			action:"getchart",
			blogger:blogger,
			blog_id:blog_id,
			sort:"date",
			date_start:$("#date_start").val(),
			date_end:$("#date_end").val(),
		},
		error: function(response)
		{						
			console.log(response);
			$("#blogpost_detail").html(response);
		},
		success: function(response)
		{   
			console.log(response);
			//$("#blogpost_detail").html(response);
			$("#blogpost_detail").delay(3000).html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />").delay(2000).html(response);
			
	
		}
	});
	
}

function getTotalPost(blogger,blog_id){
	var sel= $(".activeblog").html();
	$(".total-post").html("");
	$.ajax({
		url: app_url+"subpages/postingfrequencypostdetail.jsp",
		method: 'POST',
		data: {
			action:"gettotal",
			blogger:blogger,
			blog_id:blog_id,
			date_start:$("#date_start").val(),
			date_end:$("#date_end").val(),
		},
		error: function(response)
		{						
			console.log(response);
			$(".total-post").html(response);
		},
		success: function(response)
		{   
			console.log(response);
			$(".total-post").html(response);
			$(".activeblog").html(sel);
				
		}
	});	
}


function getTopLocation(blogger,blog_id){
	$(".top-location").html("");
	$.ajax({
		url: app_url+"subpages/postingfrequencypostdetail.jsp",
		method: 'POST',
		data: {
			action:"getmostacticelocation",
			blogger:blogger,
			blog_id:blog_id,
			date_start:$("#date_start").val(),
			date_end:$("#date_end").val(),
		},
		error: function(response)
		{						
			console.log(response);
			$(".total-post").html(response);
		},
		success: function(response)
		{   
			console.log(response);
			$(".top-location").html(response);
				
		}
	});	
}