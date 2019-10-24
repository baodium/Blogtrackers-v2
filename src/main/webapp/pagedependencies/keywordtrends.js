// delete all blog from tracker action

$('.select-term').on("click", function() {

	$(".select-term").removeClass("abloggerselected");
	$(this).addClass("abloggerselected");

	var date_start = $("#date_start").val();
	var date_end = $("#date_end").val();
	var term = $(this).attr("id");

	var t2 = term.split("***");

	term = t2[0];
	var freq = t2[1];
	/*freq=parseInt(freq);*/
	//console.log("freq--"+freq.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
	/* var tm = term.replaceAll("_", " "); */

	$(".active-term").html(term);
	/* console.log(freq); */
	$(".keyword-count").html(freq.replace(/\B(?=(\d{3})+(?!\d))/g, ","));

	// loadInfluence(bloog,blg[1]);
	$("#term").val(term);
	$('#d3-line-basic').html('');
	
	/* $("#term_id").val(term_id); */
	loadBlogMentioned(term);
	loadMostLocation(term);
	loadMostPost(term);
	getLineData(term);

	/* loadStat(tm); */
	/* loadChart(tm); */

	loadTable(date_start, date_end);
});
var r = /a/;
// console.log(typeof r.test('a')); // true
// console.log(r.test('ba')); // false

$('.resetsearch').on("click", function() {
	$('.searchkeywords').val("");
});

$('.searchkeywords').on("keyup", function(e) {
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

function loadBlogMentioned(term) {
	$(".blog-mentioned").html("<img src='images/loading.gif' />");
	$.ajax({
		url : app_url + "KeywordTrend",
		method : 'POST',
		dataType : 'json',
		data : {
			action : "getblogmentioned",
			term : term,
			all_blog_ids : $("#all_blog_ids").val(),
			date_start : $("#date_start").val(),
			date_end : $("#date_end").val(),
		},
		error : function(response) {
			console.log("error occured blog mentioned" + response);
		},
		success : function(response) {
			console.log(response)
			$(".blog-mentioned").html(parseInt(response.blogmentioned));
		}
	});
}

function loadMostLocation(term) {
	$(".top-location").html("<img src='images/loading.gif' />");
	$.ajax({
		url : app_url + "KeywordTrend",
		method : 'POST',
		dataType : 'json',
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
			$(".top-location").html(response.toplocation);
		}
	});
}

function loadMostPost(term) {
	$(".post-mentioned").html("<img src='images/loading.gif' />");
	$.ajax({
		url : app_url + "KeywordTrend",
		method : 'POST',
		dataType : 'json',
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
			$(".post-mentioned").html(response.post);
		}
	});
}

function loadtermTableBulk() {
	$(".termtable").html(
			"<img src='images/loading.gif' /> TERMS LOADING PLEASE WAIT ...");
	$.ajax({
		url : app_url + "KeywordTrend",
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

function loadTable(date_start, date_end) {

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
					term : $("#term").val(),
					id : $("#term_id").val(),
					all_blog_ids : $("#all_blog_ids").val(),
					tid : $("#tid").val(),
					date_start : date_start,
					date_end : date_end,
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

$('.blogpost_link')
		.on(
				"click",
				function() {

					var post_id = $(this).attr("id");
					

					$("#blogpost_detail")
							.html(
									"<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
					$(".viewpost").addClass("makeinvisible");
					$('.blogpost_link').removeClass("activeselectedblog");
					$('#' + post_id).addClass("activeselectedblog");
					$(this).parent().children(".viewpost").removeClass(
							"makeinvisible");
					// grab all id of blog and perform an ajax request
					$.ajax({
						url : app_url + 'tracker',
						method : 'POST',
						data : {
							action : "fetchpost",
							key : "blogpost_id",
							tid : $("#tid").val(),
							value : post_id,
							term : $("#term").val(),
							source : "keywordtrend",
							section : "detail_table"
						},
						error : function(response) {
							// console.log(response);
							$("#blogpost_detail").html(response);
						},
						success : function(response) {
							// console.log(response);
							$("#blogpost_detail").html(response).hide();
							$("#blogpost_detail").fadeIn(700);
						}
					});

				});
