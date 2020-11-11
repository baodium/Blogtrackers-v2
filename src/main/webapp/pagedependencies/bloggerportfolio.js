// delete all blog from tracker action

$(document).ready(function(){
	var all_bloggers = $("#all_bloggers").val();
	
	var blogger = $('#blogger-changed').val();
	var blg = blogger.split("______");
	var blog_id = blg[0];
	var date_start = $("#date_start").val();
	var date_end = $("#date_end").val();
	
	var all_ids = $("#id__").val();
	
	$(".active-blog").html(blg[1]);
	$("#blogger").val(blg[1]);
	console.log('blogger ', blg[1]);
	
	loadStat(blg[1], all_bloggers,all_ids, date_start, date_end);
	loadtermss(blg[1]);
})


$('#blogger-changed').on("change", function(){


	var date_start = $("#date_start").val();
	var date_end = $("#date_end").val();
	var all_ids = $("#id__").val();
	var blogger = $(this).val();
	var blg = blogger.split("______");
	
	var blog_id = blg[0];
	//alert(blog_id)
	
	$(".active-blog").html(blg[1]);
	$("#blogger").val(blg[1]);
	$("#visit_site").attr("href", blg[2]);
	
	
	//loadInfluence(bloog,blg[1]);
	
	var all_bloggers = $("#all_bloggers").val();
	
//	var all_blgs = all_bloggers.split("|-|");
	
	
	

	loadStat(blg[1], all_bloggers,all_ids, date_start, date_end);
	loadChart(blg[1],all_ids, date_start, date_end);
	loadYearlyChart(blg[1],all_ids, date_start, date_end);
	loadDailyChart(blg[1],all_ids, date_start, date_end);
	loadUrls(date_start,date_end,all_ids, blog_id);
	
	loadInfluence(blg[1],date_start,date_end);
	
	loadtermss(blg[1]);
});

function loadtermss(blogger){
	$(".top-keyword").html("<img src='images/loading.gif' />");
	
	/*blog_url = $('#blog__'+blog_id).attr('url');*/
		
	$.ajax({
		url: "Terms",
		method: 'POST',
		data: {
			action:"getbloggerhighestterms",
			blogger:blogger,
			/*ids:blog_id,*/
			date_start:$("#date_start").val(),
			date_end:$("#date_end").val()
		},
		error: function(response)
		{						
			console.log("The error log is "+response);
		},
		success: function(response)
		{   		
		response = response.trim().replace('[', '').replace(']','').replace('(','').replace(')','').split(',')[0];
		//var data = JSON.parse(response);
		console.log(response);
		$(".top-keyword").html(response);		
		//$('#blog_url_link').attr('href', blog_url);
		}
	});
}

function loadInfluence(blogger,start_date,end_date){
	$("#influence_table").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
	$("#blogpost_detail").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
	
	//var blogger = $("#author").val();
	var blog_id =$("#blogid").val();
	
		
	$.ajax({
		url: app_url+"subpages/postingfrequencyinfluence.jsp",
		method: 'POST',
		data: {
			action:"getchart",
			blogger:blogger,
			tid:$("#tid").val(),
			blog_id:blog_id,
			sort:"date",
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
			//console.log(response);
			//$('#influence_table').html('');
			$("#influence_table").delay(3000).html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />").delay(2000).html(response);
			 $.getScript("assets/vendors/DataTables/datatables.min.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/dataTables.bootstrap4.min.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/Buttons-1.5.1/js/buttons.flash.min.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/Buttons-1.5.1/js/dataTables.buttons.min.js", function(data, textStatus, jqxhr) {	});
			 
			 $.getScript("assets/vendors/DataTables/pdfmake-0.1.32/pdfmake.min.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/pdfmake-0.1.32/vfs_fonts.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/Buttons-1.5.1/js/buttons.html5.min.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/Buttons-1.5.1/js/buttons.print.min.js", function(data, textStatus, jqxhr) {	});
			 
			// $.getScript("pagedependencies/postingfrequency.js?v=1980", function(data, textStatus, jqxhr) {	});
			 
			$.getScript("pagedependencies/baseurl.js?v=38", function(data, textStatus, jqxhr) {	 });
			$.getScript("pagedependencies/postingfrequency1.js?v=900", function(data, textStatus, jqxhr) {	 });
				
			 
			//$("#influence_table").html(response);
			loadSinglePost(blogger,blog_id,start_date,end_date);
//			alert(blogger)
			/* $.getScript("assets/js/generic.js", function(data, textStatus, jqxhr) {	
			  });*/
		}
	});
	
}


function loadSinglePost(blogger,blog_id,start_date,end_date){
	$("#blogpost_detail").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
	
	
	$.ajax({
		url: app_url+"subpages/postingfrequencypostdetail.jsp",
		method: 'POST',
		data: {
			action:"getchart",
			blogger:blogger,
			blog_id:blog_id,
			tid:$("#alltid").val(),
			sort:"date",
			date_start:start_date,
			date_end:end_date,
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
			$("#blogpost_detail").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />").html(response);
			$.getScript("assets/js/generic.js", function(data, textStatus, jqxhr) {	
			  });
	
		}
	});
	
}



function loadStat(blogger, all_bloggers,ids, date_start, date_end){
	

	
	$(".total-influence").html("<img src='images/loading.gif' />");
	$(".total-post").html("<img src='images/loading.gif' />");
	$(".total-sentiment").html("<img src='images/loading.gif' />");
	/*$(".top-keyword").html("<img src='images/loading.gif' />");*/
	$.ajax({
		url: app_url+"subpages/bloggerportfoliochart.jsp",
		method: 'POST',
		data: {
			action:"getstats",
			blogger:blogger,
			ids:ids,
			all_bloggers:all_bloggers,
			date_start:date_start,
			date_end:date_end,
		},
		error: function(response)
		{						
			console.log(response);
			//$("#overall-chart").html(response);
		},
		success: function(response)
		{   
		
		var data = JSON.parse(response);
		$(".total-influence").html(data.totalinfluence);
//		$(".total-influence").html(parseInt(data.totalinfluence).toLocaleString('en'));
		$(".total-post").html(parseInt(data.totalpost).toLocaleString('en'));
		$(".total-sentiment").html(data.totalsentiment);
	
		/*$(".top-keyword").html(data.topterm);*/
		//$("#overall-chart").delay(3000).html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />").delay(2000).html(response);
			/* $.getScript("assets/js/generic.js", function(data, textStatus, jqxhr) {	
			  });*/
		}
	});
}

$('.blogpost_link').on("click", function(){
	$("body").addClass("loaded");
	var post_id = $(this).attr("id");
	//alert(post_id);
	//console.log(post_id);
	$("#blogpost_detail").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
	$(".viewpost").addClass("makeinvisible");
	$('.blogpost_link').removeClass("activeselectedblog");
	$('#'+post_id).addClass("activeselectedblog");
	$(this).parent().children(".viewpost").removeClass("makeinvisible");
	//grab all id of blog and perform an ajax request
	$.ajax({
		url: app_url+"subpages/influencedetail.jsp",
		method: 'POST',
		data: {
			action:"fetchpost",
			post_id:post_id,
			tid:$("#alltid").val()
		},
		error: function(response)
		{						
			//console.log(response);
			//$("#blogpost_detail").html(response);
		},
		success: function(response)
		{   
			//console.log(response);
			$("#blogpost_detail").html(response).hide();
			$("#blogpost_detail").fadeIn(700);
		}
	});
	
});

function loadChart(blogger,ids, date_start, date_end){
	$("#overall-chart").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
	$.ajax({
		url: app_url+"subpages/bloggerportfoliochart.jsp",
		method: 'POST',
		data: {
			action:"getchart",
			blogger:blogger,
			ids:ids,
			date_start:date_start,
			date_end:date_end,
		},
		error: function(response)
		{						
			console.log(response);
			$("#overall-chart").html(response);
		},
		success: function(response)
		{   

		$("#overall-chart").delay(3000).html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />").delay(2000).html(response);
			/* $.getScript("assets/js/generic.js", function(data, textStatus, jqxhr) {	
			  });*/
		}
	});
}

function loadYearlyChart(blogger,ids, date_start, date_end){
	$("#year-chart").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
	$.ajax({
		url: app_url+"subpages/bloggerportfoliochart.jsp",
		method: 'POST',
		data: {
			action:"getdailychart",
			blogger:blogger,
			ids:ids,
			date_start:date_start,
			date_end:date_end,
		},
		error: function(response)
		{						
			console.log(response);
			$("#year-chart").html(response);
		},
		success: function(response)
		{   

		$("#year-chart").delay(3000).html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />").delay(2000).html(response);
			/* $.getScript("assets/js/generic.js", function(data, textStatus, jqxhr) {	
			  });*/
		}
	});
}


function loadDailyChart(blogger,ids, date_start, date_end){
	console.log(blogger,'/////////',ids)
	$("#day-chart").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
	$.ajax({
		url: app_url+"subpages/bloggerportfoliochart.jsp",
		method: 'POST',
		data: {
			action:"getdayonlychart",
			blogger:blogger,
			ids:ids,
			date_start:date_start,
			date_end:date_end,
		},
		error: function(response)
		{						
			console.log(response);
			$("#day-chart").html(response);
		},
		success: function(response)
		{   

		$("#day-chart").delay(3000).html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />").delay(2000).html(response);
			/* $.getScript("assets/js/generic.js", function(data, textStatus, jqxhr) {	
			  });*/
		}
	});
}




function loadUrls(date_start,date_end,ids, selected_blogger_id){
	$("#url-table").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
	//alert(selected_blogger_id);
		$.ajax({
			url: app_url+'subpages/bloggerportfoliodomain.jsp',
			method: 'POST',
			data: {
				blogger:$("#blogger").val(),
				blogger_id:selected_blogger_id,
				date_start:date_start,
				ids:ids,
				date_end:date_end,
				listtype:$("#top-listtype").val(),
			},
			error: function(response)
			{						
				console.log(response);		
			},
			success: function(response)
			{   
				$("#url-table").html(response);
			}
		});
	}




