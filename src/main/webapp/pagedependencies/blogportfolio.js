// delete all blog from tracker action
$(document).ready(function(){
	var all_blogs = $("#all_blogs").val();
	
	var blog = $('#blogger-changed').val();
	var blg = blog.split("_");
	var blog_id = blg[0];
	
	$(".active-blog").html(blg[1]);
	$("#blogger").val(blg[1]);
	
	loadStat(blg[0], all_blogs);
	
	
	
	
	
	
})



$('#blogger-changed').on("change", function(){


	var date_start = $("#date_start").val();
	var date_end = $("#date_end").val();
	var blogger = $(this).val();
	
	var blg = blogger.split("_");
	
	var blog_id = blg[0];
	
	$(".active-blog").html(blg[1]);
	$("#blogid").val(blog_id);
	
	
	//loadInfluence(bloog,blg[1]);
	

	
	var all_blogs = $("#all_blogs").val();
	
	$(".activeblog").html(blg[1]);
	
	loadInfluence(blog_id,date_start,date_end);

	loadStat(blog_id, all_blogs);
	loadChart(blog_id);
	loadYearlyChart(blog_id, date_start, date_end);
	loadDailyChart(blog_id, date_start, date_end);
	loadUrls(date_start,date_end);
	loadtermss(blog_id)
});

$( "body" ).delegate( ".blogpost_link", "click", function() {
//$('.blogpost_link').on("click", function(){
	$("body").addClass("loaded");
	var post_id = $(this).attr("id");
	//alert(post_id);
//	alert($("#alltid").val());
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
			alert('error')
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

function loadSinglePost(blog,blog_id,start_date,end_date){
	$("#blogpost_detail").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
	
//	alert(blog)
//	alert(blog_id)
//	alert($("#alltid").val())
//	alert(start_date)
//	alert(end_date)
	
	$.ajax({
		url: app_url+"subpages/postingfrequencypostdetail.jsp",
		method: 'POST',
		data: {
			action:"getchart_blogs",
			blogger:blog,
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
			console.log(response);
			//$("#blogpost_detail").html(response);
			$("#blogpost_detail").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />").html(response);
			$.getScript("assets/js/generic.js", function(data, textStatus, jqxhr) {	
			  });
	
		}
	});
	
}


function loadInfluence(blog,start_date,end_date){
	$("#influence_table").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
	$("#blogpost_detail").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
	
	//var blogger = $("#author").val();
	var blog_id =$("#blogid").val();
	//alert(blog_id)
		
	$.ajax({
		url: app_url+"subpages/postingfrequencyinfluence.jsp",
		method: 'POST',
		data: {
			action:"getchart_blogs",
			blogger:blog,
			tid:$("#tid").val(),
			blog_id:blog_id,
			sort:"date",
			date_start:start_date,
			date_end:end_date,
		},
		error: function(response)
		{						
			$("#influence_table").html(response);			
		},
		success: function(response)
		{   
			//console.log(response);
			$("#influence_table").delay(3000).html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />").delay(2000).html(response);
/*			 $.getScript("assets/vendors/DataTables/datatables.min.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/dataTables.bootstrap4.min.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/Buttons-1.5.1/js/buttons.flash.min.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/Buttons-1.5.1/js/dataTables.buttons.min.js", function(data, textStatus, jqxhr) {	});
			 
			 $.getScript("assets/vendors/DataTables/pdfmake-0.1.32/pdfmake.min.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/pdfmake-0.1.32/vfs_fonts.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/Buttons-1.5.1/js/buttons.html5.min.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/Buttons-1.5.1/js/buttons.print.min.js", function(data, textStatus, jqxhr) {	});

			 $.getScript("pagedependencies/baseurl.js?v=38", function(data, textStatus, jqxhr) {	 });
			$.getScript("pagedependencies/postingfrequency1.js?v=900", function(data, textStatus, jqxhr) {	 });*/
			
			loadSinglePost(blog,blog_id,start_date,end_date);

		}
	});
	
}

function loadStat(blog_id, all_blogs){
	$(".total-influence").html("<img src='images/loading.gif' />");
	$(".total-post").html("<img src='images/loading.gif' />");
	$(".total-sentiment").html("<img src='images/loading.gif' />");
	//$(".top-keyword").html("<img src='images/loading.gif' />");
	
	blog_url = $('#blog__'+blog_id).attr('url');
	
	
	$.ajax({
		url: app_url+"subpages/blogportfoliochart.jsp",
		method: 'POST',
		data: {
			action:"getstats",
			blog_id:blog_id,
			all_blogs:all_blogs,
			date_start:$("#date_start").val(),
			date_end:$("#date_end").val(),
		},
		error: function(response)
		{						

			console.log("The error log is "+response);
			
			//$("#overall-chart").html(response);
		},
		success: function(response)
		{   
			
		
		response = response.trim();
		var data = JSON.parse(response);
//		$(".total-influence").html(parseInt(data.totalinfluence).toLocaleString('en'));
		$(".total-influence").html(data.totalinfluence).toLocaleString('en');
		$(".total-post").html(parseInt(data.totalpost).toLocaleString('en'));
		$(".total-sentiment").html(data.totalsentiment).toLocaleString('en');
		//$(".top-keyword").html(data.topterm);
		
		$('#blog_url_link').attr('href', blog_url);
		
		//$("#overall-chart").delay(3000).html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />").delay(2000).html(response);
			/* $.getScript("assets/js/generic.js", function(data, textStatus, jqxhr) {	
			  });*/
		}
	});
}

function loadtermss(blog_id){
	$(".top-keyword").html("<img src='images/loading.gif' />");
	
	blog_url = $('#blog__'+blog_id).attr('url');
		
	$.ajax({
		url: "Terms",
		method: 'POST',
		data: {
			action:"gethighestterms",
			blogger:null,
			ids:blog_id,
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
		$('#blog_url_link').attr('href', blog_url);
		}
	});
}

function loadChart(blog_id){
	$("#overall-chart").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
	$.ajax({
		url: app_url+"subpages/blogportfoliochart.jsp",
		method: 'POST',
		data: {
			action:"getchart",
			blog_id:blog_id,
			date_start:$("#date_start").val(),
			date_end:$("#date_end").val(),
		},
		error: function(response)
		{						
			console.log(response);
			//$("#overall-chart").html(response);
		},
		success: function(response)
		{   

			$("#overall-chart").html("");	
		$("#overall-chart").delay(3000).html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />").delay(2000).html(response);
			/* $.getScript("assets/js/generic.js", function(data, textStatus, jqxhr) {	
			  });*/
		}
	});
}

function loadYearlyChart(blog_id, date_start,date_end){
	$("#year-chart").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
	$.ajax({
		url: app_url+"subpages/blogportfoliochart.jsp",
		method: 'POST',
		data: {
			action:"getdailychart",
			blog_id:blog_id,
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

function loadDailyChart(blog_id, date_start, end_date){
	$("#day-chart").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
	$.ajax({
		url: app_url+"subpages/blogportfoliochart.jsp",
		method: 'POST',
		data: {
			action:"getdayonlychart",
			blog_id:blog_id,
			date_start:date_start,
			date_end:end_date,
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


function loadUrls(date_start,date_end){
	$("#url-table").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
		
		$.ajax({
			url: app_url+'subpages/blogportfoliodomain.jsp',
			method: 'POST',
			data: {
				blog_id:$("#blogid").val(),
				date_start:date_start,
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




