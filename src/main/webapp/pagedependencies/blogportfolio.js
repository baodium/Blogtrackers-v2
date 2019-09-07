// delete all blog from tracker action


$('#blogger-changed').on("change", function(){


	var date_start = $("#date_start").val();
	var date_end = $("#date_end").val();
	var blogger = $(this).val();
	
	var blg = blogger.split("_");
	
	var blog_id = blg[0];
	
	$(".active-blog").html(blg[1]);
	$("#blogid").val(blog_id);
	
	
	//loadInfluence(bloog,blg[1]);

	loadStat(blog_id);
	loadChart(blog_id);
	loadYearlyChart(blog_id);
	loadDailyChart(blog_id);
	loadUrls(date_start,date_end);
});



function loadStat(blog_id){
	$(".total-influence").html("<img src='images/loading.gif' />");
	$(".total-post").html("<img src='images/loading.gif' />");
	$(".total-sentiment").html("<img src='images/loading.gif' />");
	$(".top-keyword").html("<img src='images/loading.gif' />");
	$.ajax({
		url: app_url+"subpages/blogportfoliochart.jsp",
		method: 'POST',
		data: {
			action:"getstats",
			blog_id:blog_id,
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

		$(".total-influence").html(parseInt(data.totalinfluence).toLocaleString('en'));
		$(".total-post").html(parseInt(data.totalpost).toLocaleString('en'));
		$(".total-sentiment").html(parseInt(data.totalsentiment).toLocaleString('en'));
		$(".top-keyword").html(data.topterm);
		//$("#overall-chart").delay(3000).html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />").delay(2000).html(response);
			/* $.getScript("assets/js/generic.js", function(data, textStatus, jqxhr) {	
			  });*/
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

function loadYearlyChart(blog_id){
	$("#year-chart").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
	$.ajax({
		url: app_url+"subpages/blogportfoliochart.jsp",
		method: 'POST',
		data: {
			action:"getdailychart",
			blog_id:blog_id,
			date_start:$("#date_start").val(),
			date_end:$("#date_end").val(),
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

function loadDailyChart(blog_id){
	$("#day-chart").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
	$.ajax({
		url: app_url+"subpages/blogportfoliochart.jsp",
		method: 'POST',
		data: {
			action:"getdayonlychart",
			blog_id:blog_id,
			date_start:$("#date_start").val(),
			date_end:$("#date_end").val(),
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




