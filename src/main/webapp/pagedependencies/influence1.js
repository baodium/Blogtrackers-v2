// delete all blog from tracker action


//$('.blogger-select').on("click", function(){

$(document).delegate('.topics1', 'click', function(){
	$(".blogger-select").removeClass("abloggerselected");
	//$(this).addClass("abloggerselected");

	var date_start = $("#date_start").val();
	var date_end = $("#date_end").val();
	var blogger = $(this).attr("id");
	
	var blg = blogger.split("***");
	
	var id = this.id;
    var name = $(this).attr('name');
	
	var bloog = blg[0];
	bloog = name.replaceAll("__"," ");
	
	
///////////////start collecting names
	 var count = $('.thanks').length;
	 
	 if(count > 0){
		 
		 var all_selected_names = '';
		 var all_selected_names1 = '';
		 var all_selected_id = '';
		 var i = 1;
		 var total_post_county = 0;
		 $( ".thanks" ).each(function( index ) {
			 
			 console.log('Got here')
			 if(i > 1){
				 all_selected_names += ' , ';
				 all_selected_names1 += ' , ';
				 all_selected_id += ' , ';
			 }
			 
	    	blog_name = 	$(this).attr('name');
	    	
	    	blog_id = 	this.id;
	    	
	    	all_selected_names += '"'+blog_name+'"';
	    	all_selected_names1 += blog_name;
	    	
	    	all_selected_id += blog_id;
	    	
	    	//getting total post count from each blogger
	    	total_post_county+=parseInt($(this).attr('total_post_counter'));
	    	console.log('total_post_counter1',$(this).attr('total_post_counter'))
	    	i++;
		    		
		});
		 
		 
	 }
	////////////end collecting names
	 
	
	$(".activeblogger").html(all_selected_names1);
	$(".activeblog").html(all_selected_names1);
	
	$("#author").val(all_selected_names1);
	$("#blogid").val(all_selected_id);
	
	//loadChart(bloog,blg[1]);
	loadTerms(all_selected_names,$("#all_blog_ids").val(),date_start,date_end, all_selected_names1);
	loadInfluence(all_selected_names,date_start,date_end);
	/*loadInfluence(date_start,date_end);*/
	$(".total-post").html(total_post_county);
	console.log('Finatotal_post_counter',total_post_county)
	/*loadStat(all_selected_names1,id);*/
});


$('.searchbloggers').on("keyup",function(e){
	var valuetype = e.target.value;
	//console.log(valuetype==="");
	if(valuetype === "")
	{
	$('.blogger-select').removeClass("hidesection");	
	}
	$('.blogger-select').removeClass("hidesection")
	var valuetocheck = new RegExp(valuetype);
	var checkclass = ""
	$('.blogger-select').each(function(el,i)
	{
	var eachvalue = $(this).children("b").html();
	//console.log(valuetocheck.test(eachvalue));

		//console.log(typeof eachvalue);
	if(!valuetocheck.test(eachvalue) && e.target.value !== "")
	{
		$(this).addClass("hidesection");	
	}

	//console.log(el);	
	})
	})
	

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

/*function loadInfluence(start_date,end_date){
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
			 $.getScript("assets/vendors/DataTables/datatables.min.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/dataTables.bootstrap4.min.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/Buttons-1.5.1/js/buttons.flash.min.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/Buttons-1.5.1/js/dataTables.buttons.min.js", function(data, textStatus, jqxhr) {	});
			 
			 $.getScript("assets/vendors/DataTables/pdfmake-0.1.32/pdfmake.min.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/pdfmake-0.1.32/vfs_fonts.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/Buttons-1.5.1/js/buttons.html5.min.js", function(data, textStatus, jqxhr) {	});
			 $.getScript("assets/vendors/DataTables/Buttons-1.5.1/js/buttons.print.min.js", function(data, textStatus, jqxhr) {	});
	
			//$("#influence_table").html(response);
			loadSinglePost(blogger,blog_id);
			 $.getScript("assets/js/generic.js", function(data, textStatus, jqxhr) {	
			  });
			 //console.log("loadinfluence")
		}
	});
}*/

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


/*function loadTerms(blogger,blog_id){
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
			 $.getScript("assets/js/generic.js", function(data, textStatus, jqxhr) {	
			  });
		}
	});	
}*/


function loadTerms(blogger,blog_id,start_date,end_date, activeTerms){
	/*$("#tagcloudbox").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");*/
	$("#tagcloudbox").html("<img src='images/loading.gif' /> COMPUTING TERMS PLEASE WAIT....");
	$(".most-used-keyword").html("<img src='images/loading.gif'/>");
	var blger = blogger.replaceAll(" ","__");
	$.ajax({
		url: app_url+"subpages/postingfrequencyterm.jsp",
		method: 'POST',
		data: {
			action:"getchart",
			blogger:blogger,
			//post_ids:$("#postby"+blger).val(),
			all_blog_ids:$("#all_blog_ids").val(),
			date_start:start_date,
			date_end:end_date,
		},
		error: function(response)
		{						
			//console.log(response);
			$("#tagcloudbox").html(response);
		},
		success: function(response)
		{   
			console.log(response.highest);
			$('.activeblogger').html(activeTerms);
			$("#tagcloudbox").html("<img src='images/loading.gif' /> COMPUTING TERMS PLEASE WAIT....").html(response);
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
			console.log('RENTERED');
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
	//$(".total-post").html("<img src='images/loading.gif' />");
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
		//$(".total-post").html(data.totalpost);
		$(".total-sentiment").html(data.totalsentiment);
		$(".total-comments").html(data.totalcomment);
		//$("#overall-chart").delay(3000).html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />").delay(2000).html(response);
			/* $.getScript("assets/js/generic.js", function(data, textStatus, jqxhr) {	
			  });*/
		}
	});
}

