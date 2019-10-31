//$('.blogger-select').on("click", function(e){
	
	$(document).delegate('.topics1', 'click', function(){

	$(".blogger-select").removeClass("abloggerselected");
	//console.log("here 2")	;
	$("body").addClass("loaded");
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
		 var i = 1;
		 $( ".thanks" ).each(function( index ) {
			 
			 
			 if(i > 1){
				 all_selected_names += ' , ';
			 }
			 
	    	blog_name = 	$(this).attr('name');
	    	
	    	blog_id = 	this.id;
	    	
	    	all_selected_names += '"'+blog_name+'"';
	    		
	    	i++;
		    		
		});
		 
		 
	 }
	////////////end collecting names
	 
	
	
	$(".activeblogger").html(all_selected_names);
	$(".activeblog").html(blg[2]);
	
	$("#author").val(bloog);
	$("#blogid").val(blg[1]);
	
	loadTerms(all_selected_names,$("#all_blog_ids").val(),date_start,date_end);
	console.log(blogger+$("#all_blog_ids").val()+date_start+date_end)
	loadInfluence(date_start,date_end);
	getTotalPost(bloog,id,date_start,date_end);
	//loadChart(bloog,id,date_start,date_end);
	
	getTopLocation(bloog,$("#all_blog_ids").val(),date_start,date_end);
	loadTopKeyword(bloog,$("#all_blog_ids").val(),date_start,date_end);	
	loadSentiments(all_selected_names,$("#all_blog_ids").val(),date_start,date_end);
	/*alert(bloog);*/

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

function loadChart(blogger,blog_id,start_date,end_date){
	/*alert("get the charts man")*/
	console.log("blog_id--"+blogger)
	$("#chart-container").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
	$.ajax({
		url: app_url+"subpages/postingfrequencychart.jsp",
		method: 'POST',
		data: {
			action:"getchart",
			blogger:blogger,
			all_blog_ids:$("#all_blog_ids").val(),
			sort:"date",
			date_start:start_date,
			date_end:end_date,
		},
		error: function(response)
		{						
			//console.log(response);
			$("#chart-container").html(response);
		},
		success: function(response)
		{   

		$("#chart-container").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />").html(response);

			 $.getScript("pagedependencies/baseurl.js?v=93", function(data, textStatus, jqxhr) {	});
			 $.getScript("pagedependencies/postingfrequency1.js?v=78878909", function(data, textStatus, jqxhr) {	});
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
			/* $.getScript("assets/js/generic.js", function(data, textStatus, jqxhr) {	
			  });*/
		}
	});
	
}




function loadTerms(blogger,blog_id,start_date,end_date){
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
			$('.activeblogger').html(blogger);
			$("#tagcloudbox").html("<img src='images/loading.gif' /> COMPUTING TERMS PLEASE WAIT....").html(response);
			/* $.getScript("assets/js/generic.js", function(data, textStatus, jqxhr) {	
			  });*/
		}
	});
	
}

function loadTopKeyword(blogger,blog_id,start_date,end_date){
	//alert(blogger+blog_id+start_date+end_date)
	$(".most-used-keyword").html("");
	var blger = blogger.replaceAll(" ","__");
	$.ajax({
		url: app_url+"subpages/postingfrequencyterm.jsp",
		method: 'POST',
		data: {
			action:"gettopkeyword",
			blogger:blogger,
			post_ids:$("#postby"+blger).val(),
			date_start:start_date,
			date_end:end_date,
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


function loadSentiments(blogger,blog_id,start_date,end_date){
	$("#entity_table").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
	var blger = blogger.replaceAll(" ","__");
	
	$.ajax({
		url: app_url+"subpages/postingfrequencysentiment.jsp",
		method: 'POST',
		data: {
			action:"getsentimenttable",
			blogger:blogger,
			//post_ids:$("#postby"+blger).val(),
			date_start:start_date,
			date_end:end_date,
		},
		error: function(response)
		{						
			//console.log(response);
			$("#entity_table").html(response);
		},
		success: function(response)
		{   
			//console.log(response);
			$("#entity_table").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />").html(response);
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

function getTotalPost(blogger,blog_id,start_date,end_date){
	var sel= $(".activeblog").html();
	$(".total-post").html("");
	$.ajax({
		url: app_url+"subpages/postingfrequencypostdetail.jsp",
		method: 'POST',
		data: {
			action:"gettotal",
			blogger:blogger,
			blog_id:blog_id,
			date_start:start_date,
			date_end:end_date,
		},
		error: function(response)
		{						
			//console.log(response);
			$(".total-post").html(response);
		},
		success: function(response)
		{   
			//console.log(response);
			$(".total-post").html(parseInt(response).toLocaleString('en'));
			$(".activeblog").html(sel);
				
		}
	});	
}


function getTopLocation(blogger,blog_id,start_date,end_date){
	$(".top-location").html("");
	$.ajax({
		url: app_url+"subpages/postingfrequencypostdetail.jsp",
		method: 'POST',
		data: {
			action:"getmostacticelocation",
			blogger:blogger,
			blog_id:blog_id,
			date_start:start_date,
			date_end:end_date,
		},
		error: function(response)
		{						
			//console.log(response);
			$(".top-location").html(response);
		},
		success: function(response)
		{   
			//console.log(response);
			$(".top-location").html(response);
				
		}
	});	
}
