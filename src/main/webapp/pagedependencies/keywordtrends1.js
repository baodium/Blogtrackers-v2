// delete all blog from tracker action

$(document).delegate('.topics1', 'click', function(){
	
	
	
	$(".topics1").removeClass("abloggerselected");
	//$(this).addClass("abloggerselected");

	var date_start = $("#date_start").val();
	var date_end = $("#date_end").val();
	var value = $(this).attr("value");
	var name = $(this).attr("name");

///////////////start collecting names
	 var count = $('.thanks').length;
	 
	 if(count > 0){
		 
		 var all_selected_names = '';
		 var all_selected_names1 = '';
		 var total = 0;
		 var i = 1;
		 $( ".thanks" ).each(function( index ) {
			 
			 
			 if(i > 1){
				 all_selected_names += ' , ';
				 all_selected_names1 += ' , ';
			 }
			 
	    	blog_name = 	$(this).attr('name');
	    	
	    	blog_id = 	this.id;
	    	
	    	all_selected_names += '"'+blog_name+'"';
	    	all_selected_names1 += blog_name;
	    	
	    	total+=parseInt($(this).attr('value'));
	    		
	    	i++;
		    		
		});
		 
		 
	 }
	////////////end collecting names
	
	$(".active-term").html(all_selected_names1);
	
	$(".keyword-count").html(total.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));

	// loadInfluence(bloog,blg[1]);
	//$("#term").val(all_selected_names);
	$('#d3-line-basic').html('');
	$("#term").val(all_selected_names);
	
	
	/* $("#term_id").val(term_id); */
	loadBlogMentioned($("#term").val(),date_start, date_end);
	
	loadMostLocation($("#term").val(), date_start, date_end);
	loadMostPost($("#term").val(), date_start, date_end);
	//getLineData(name);

	/* loadStat(tm); */
	/* loadChart(tm); */

	loadTable($("#term").val(), date_start, date_end, all_selected_names1);
});


/*START ON SEARCH FOR TERM*/
$('#searchInput').keydown(function(e) {
	var key = e.which;
	if (key == 13) {
			e.preventDefault();
		   
		   var date_start = $("#date_start").val();
		   var date_end = $("#date_end").val();
		   
		  
///////////////start collecting names
			 var count = $('.thanks').length;
			 
			 if(count > 0){
				 
				 var all_selected_names = '';
				 var all_selected_names1 = '';
				 var total = 0;
				 var i = 1;
				 $( ".thanks" ).each(function( index ) {
					 
					 if(i > 1){
						 all_selected_names += ' , ';
						 all_selected_names1 += ' , ';
					 }
					 
			    	blog_name = 	$(this).attr('name');
			    	
			    	blog_id = 	this.id;
			    	
			    	all_selected_names += '"'+blog_name+'"';
			    	all_selected_names1 += blog_name;
			    	
			    	i++;
				    		
				});
				 
				 
			 }
			////////////end collecting names
			
		  var final_terms = all_selected_names+',"'+$('#searchInput').val()+'"';
		  var final_terms1 = all_selected_names1+','+$('#searchInput').val();
		  
		  $("#term").val(final_terms);
		  $(".active-term").html(final_terms1);
		   
		   loadGraphData($('#searchInput').val());
			 
		   loadBlogMentioned($('#term').val(),date_start, date_end);
		   loadMostLocation($('#term').val(), date_start, date_end);
		   loadMostPost($('#term').val(), date_start, date_end);
		   loadTable($('#term').val(), date_start, date_end, "");
		   
		   $('.searchkeywords').val("");
	}
	});
/*END ON  SEARCH FOR TERM*/



var r = /a/;
// console.log(typeof r.test('a')); // true
// console.log(r.test('ba')); // false

$('.resetsearch').on("click", function() {
	$('.searchkeywords').val("");
	$('.select-term').css("display", "")
});


$('.searchkeywords').on("keyup", function(e) {
	var valuetype = e.target.value;
	if (valuetype === "") {
		$('.select-term').removeClass("hidesection");
	}
	
	mySearchingFunction()
})

function mySearchingFunction() {
    var input, filter, ul, li, a, i, txtValue;
    input = document.getElementById("searchInput");
    filter = input.value.toUpperCase();
    $('.select-term').each(function(el, i) {
        txtValue = $(this).attr('name');
        if (txtValue.toUpperCase().indexOf(filter) > -1) {
            $(this).css("display", "")
        } else {
        	$(this).css("display", "none")
        }
    })
}





$('.searchkeywords1111').on("keyup", function(e) {
	var valuetype = e.target.value;
	// console.log(valuetype==="");
	if (valuetype === "") {
		$('.select-term').removeClass("hidesection");
	}
	$('.select-term').removeClass("hidesection")
	var valuetocheck = new RegExp(valuetype);
	var checkclass = ""
	$('.select-term').each(function(el, i) {
		var eachvalue = $(this).children("b").html();
		// console.log(valuetocheck.test(eachvalue));

		// console.log(typeof eachvalue);
		if (!valuetocheck.test(eachvalue) && e.target.value !== "") {
			$(this).addClass("hidesection");
		}

		// console.log(el);
	})
})

/*
 * function loadStat(term){
 * 
 * $(".blog-mentioned").html("<img src='images/loading.gif' />");
 * $(".post-mentioned").html("<img src='images/loading.gif' />");
 * $(".blogger-mentioned").html("<img src='images/loading.gif' />");
 * $(".top-location").html("<img src='images/loading.gif' />"); $.ajax({ url:
 * app_url+"subpages/keywordtrendchart.jsp", method: 'POST', data: {
 * action:"getstats", term:term, date_start:$("#date_start").val(),
 * date_end:$("#date_end").val(), }, error: function(response) {
 * console.log(response); //$("#overall-chart").html(response); }, success:
 * function(response) {
 * 
 * response = response.trim(); //console.log(response); var data =
 * JSON.parse(response); //console.log(data); function numberWithCommas(x) { var
 * parts = x.toString().split("."); parts[0] =
 * parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ","); return parts.join("."); }
 * 
 * $(".blog-mentioned").html(numberWithCommas(data.blogmentioned));
 * $(".post-mentioned").html(numberWithCommas(data.postmentioned));
 * $(".blogger-mentioned").html(numberWithCommas(data.bloggermentioned));
 * $(".top-location").html(data.toplocation);
 * //$("#overall-chart").delay(3000).html("<img style='position: absolute;top:
 * 50%;left: 50%;' src='images/loading.gif' />").delay(2000).html(response);
 * $.getScript("assets/js/generic.js", function(data, textStatus, jqxhr) { }); }
 * }); }
 */


function isObjEmpty(obj) {
    for(var key in obj) {
        if(obj.hasOwnProperty(key))
            return false;
    }
    return true;
}


function loadGraphData(term) {
	
	$('.line_graph').addClass('hidden');
    $('#line_graph_loader').removeClass('hidden');
    
    $("#scroll_list_loader").removeClass("hidden");
	$("#scroll_list").addClass("hidden");
	
	$.ajax({
		url : app_url + "KeywordTrend1",
		method : 'POST',
		dataType : 'json',
		data : {
			action : "getgraphdata",
			term : term,
			all_blog_ids : $("#all_blog_ids").val(),
			date_start : $("#date_start").val(),
			date_end : $("#date_end").val(),
		},
		
		error : function(response) {
			console.log("error occured graph data" + response);
		},
		success : function(response) {
			
			if(isObjEmpty(response.details)) {
				
				$('.line_graph').removeClass('hidden');
			    $('#line_graph_loader').addClass('hidden');
			    
			    $("#scroll_list_loader").addClass("hidden");
				$("#scroll_list").removeClass("hidden");
				
				toastr.warning("We are Sorry",'We could not find any data for this term on this tracker',
						{
						    allowHtml: true,
						    closeButton: true,
						    showMethod: 'show',
						    positionClass: 'toast-page-center toaster1',
						    closeHtml: '<button type="button">&times;</button>',
						    showDuration: 0,
						    tapToDismiss: false,
						    closeOnHover: false,
						    timeOut: 0,
						    onclick: function (toast) { toastr.remove();}

						})
				
			} else {
			    // Object is NOT empty
				total_count = 0;
				for (const property in response.details) {total_count+= response.details[property]}
				
				out = Object.keys(response.details).reduce((all, item) => {all.push("'" + item + "':" + response.details[item]); return all}, []).join(", ");
				
				overal_holder_length = overal_holder.length;
				 
				overal_holder[overal_holder_length] = { name: ""+term+"", details: ""+out+""};
				
				build = '<a name="'+term+'" class="topics topics1 btn btn-primary form-control select-term bloggerinactive mb20 size-1 thanks" value="'+total_count+'"><b></b>'+ term +'</a>'
				
				$('#new_searched_terms').append(build);
				
				////
	///////////////start collecting names
				 var count = $('.thanks').length;
				 
				 if(count > 0){
					 
					 var all_selected_names = '';
					 var all_selected_names1 = '';
					 var total = 0;
					 var i = 1;
					 $( ".thanks" ).each(function( index ) {
						 
						 if(i > 1){
							 all_selected_names += ' , ';
							 all_selected_names1 += ' , ';
						 }
						 
				    	blog_name = 	$(this).attr('name');
				    	
				    	blog_id = 	this.id;
				    	
				    	all_selected_names += '"'+blog_name+'"';
				    	all_selected_names1 += blog_name;
				    	
				    	total+=parseInt($(this).attr('value'));
				    		
				    	i++;
					    		
					});
					 
					 
				 }
				////////////end collecting names
				
				$(".active-term").html(all_selected_names1);
				$(".keyword-count").html(total.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
				
				////
				
				//////initiate graph 
		       $('#chart').html('');

		    	finalGraph();
				//////end initiate graph
			}
			
			
			
			
			
					
		}
	});
}

function loadBlogMentioned(term, date_start,date_end) {
	$(".blog-mentioned").html("<img src='images/loading.gif' />");
	$.ajax({
		url : app_url + "KeywordTrend1",
		method : 'POST',
		/*dataType : 'json',*/
		data : {
			action : "getblogmentioned",
			term : term,
			all_blog_ids : $("#all_blog_ids").val(),
			date_start : date_start,
			date_end :  date_end,
		},
		error : function(response) {
			console.log("error occured blog mentioned" + response);
		},
		success : function(response) {
			console.log(response)
			$(".blog-mentioned").html(parseInt(response));
		}
	});
}

function loadMostLocation(term, date_start,date_end) {
	$(".top-location").html("<img src='images/loading.gif' />");
	$.ajax({
		url : app_url + "KeywordTrend1",
		method : 'POST',
		/*dataType : 'json',*/
		data : {
			action : "getmostlocation",
			term : term,
			all_blog_ids : $("#all_blog_ids").val(),
			date_start : $("#date_start").val(),
			date_end : $("#date_end").val(),
		},
		
		error : function(response) {
			console.log("error occured location" + response);
		},
		success : function(response) {
			console.log(response)
			if(response.includes("___")){
				$(".top-location").html(response.split("___")[0].toUpperCase());
			}
			else{
				$(".top-location").html(response);
			}
			
		}
	});
}



function loadMostPost(term, date_start,date_end) {
	$(".post-mentioned").html("<img src='images/loading.gif' />");
	$.ajax({
		url : app_url + "KeywordTrend1",
		method : 'POST',
		/*dataType : 'json',*/
		data : {
			action : "getmostpost",
			term : term,
			all_blog_ids : $("#all_blog_ids").val(),
			date_start : $("#date_start").val(),
			date_end : $("#date_end").val(),
		},
		error : function(response) {
			console.log("error occured posts" + response);
		},
		success : function(response) {
			console.log(response)
			$(".post-mentioned").html(response.replace(/\B(?=(\d{3})+(?!\d))/g, ","));
		}
	});
}

function loadtermTableBulk() {
	$(".termtable").html(
			"<img src='images/loading.gif' /> TERMS LOADING PLEASE WAIT ...");
	$.ajax({
		url : app_url + "KeywordTrend1",
		method : 'POST',
		dataType : 'json',
		data : {
			action : "gettermtable",
			tid : $("#tid").val(),
			/*term: term,*/
			all_blog_ids : $("#all_blog_ids").val(),
			date_start : $("#date_start").val(),
			date_end : $("#date_end").val(),
		},
		error : function(response) {
			console.log("error occured bulk");

		},
		success : function(response) {
			console.log(response)
			updateTable(response)

		}
	});
}

function updateTable(response) {
	var table_data = ''

	for (var i = 0; i < response.data.length; i++) {
//		console.log(i)
		table_data += "<tr>"
		table_data += '<td>' + response.data[i].term + '</td>'
		table_data += '<td>' + response.data[i].frequency + '</td>'
		table_data += '<td>' + response.data[i].post_count + '</td>'
		table_data += '<td>' + response.data[i].blog_count + '</td>'
		table_data += '</tr>'

	}
	$(".termtable").html("<tbody id ='tbody'class='termtable'></tbody>");

	$('#tbody').append(table_data);
	$('#DataTables_Table_1_wrapper').DataTable({
		"scrollY" : 430,
		"scrollX" : true,
		"pagingType" : "simple"

	});
	
}

/*function loadChart(term) {
	alert("i am here")
	$("#main-chart")
			.html(
					"<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
	$
			.ajax({
				url : app_url + "subpages/keywordtrendchart.jsp",
				method : 'POST',
				data : {
					action : "getchart",
					term : term,
					date_start : $("#date_start").val(),
					date_end : $("#date_end").val(),
				},
				error : function(response) {
					console.log(response);
					$("#overall-chart").html(response);
				},
				success : function(response) {

					$("#main-chart")
							.delay(3000)
							.html(
									"<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />")
							.delay(2000).html(response);
					// $.getScript("pagedependencies/baseurl.js?v=38",
					// function(data, textStatus, jqxhr) { });
					// $.getScript("pagedependencies/keywordtrends.js?v=0879",
					// function(data, textStatus, jqxhr) { });

				}
			});
}*/

function loadTable(term, date_start, date_end, term_string, tempYear) {
	
	$("#post-list")
			.html(
					"<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
	$("#blogpost_detail")
			.html(
					"<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");

	
			$.ajax({
				url : app_url + 'subpages/keywordtrendchart.jsp',
				method : 'POST',
				data : {
					action : "gettable",
					term : term,
					id : $("#term_id").val(),
					all_blog_ids : $("#all_blog_ids").val(),
					tid : $("#tid").val(),
					date_start : date_start,
					date_end : date_end,
					tempYear:tempYear,
					term_string : term_string
				},
				error : function(response) {
					console.log(response);

				},
				success : function(response) {
					$("#combined-div")
							.delay(3000)
							.html(
									"<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />")
							.delay(2000).html(response);

					$.getScript("pagedependencies/baseurl.js?v=38", function(
							data, textStatus, jqxhr) {
					});
					
				/*	$.getScript("pagedependencies/keywordtrends.js?v=0879",
							function(data, textStatus, jqxhr) {
							});*/

				}
			});
}

//$('.blogpost_link').on("click",function() {
					
$( "body" ).delegate( ".blogpost_link", "click", function() {
	//$('.blogpost_link').on("click", function(){
		$("body").addClass("loaded");
		var post_id = $(this).attr("id");
		//alert(post_id);
//		alert($("#alltid").val());
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
