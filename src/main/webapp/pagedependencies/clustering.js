/*function graphicviz(id) {   
    require.config({
        paths: {
            d3: "https://d3js.org/d3.v4.js"
        }
    });

    require(["d3"], function(d3) {
    	
    	
    });
}*/

$(document).ready(function() {
	
	$("body").delegate(".clusters_", "click", function() {
	
		var idName = $(this).attr("id");
		var cluster = idName.split("_")[1]
		$(".activeblog").html("Cluster "+cluster);
		console.log("this is cluster" + idName)
		console.log("this is cluster" + cluster)
		loadblogdistribution(idName)
		loadpostmentioned(idName)
		loadbloggersmentioned(idName)
		loadpostinglocation(idName)
		loadtitletable(idName)
		loadkeywords(idName)
		/*loadscatter(idName - 1);*/
	});

})

///////
$("body").delegate(".blogPostClickListener", "click", function() {
	
	$("#posts_details").addClass("hidden");
	$("#posts_details_loader").removeClass("hidden");
	
	let arr_count = $(this).attr("arr_count");

	id = blog_post_data[arr_count]['_source'].blogpost_id
	
	$(".viewpost").addClass("makeinvisible");
	$('.blogpost_link').removeClass("activeselectedblog");
	$('#blog_'+id).addClass("activeselectedblog");
	$("#viewpost_"+id).removeClass("makeinvisible");

	$('#titleContainer').html(blog_post_data[arr_count]['_source'].title);
	$('#authorContainer').html(blog_post_data[arr_count]['_source'].blogger);
	$('#dateContainer').html(blog_post_data[arr_count]['_source'].date);
	$('#postContainer').html(blog_post_data[arr_count]['_source'].post);
	$('#numCommentsContainer').html(blog_post_data[arr_count]['_source'].numComments + " comments");
	
	$("#posts_details").removeClass("hidden");
	$("#posts_details_loader").addClass("hidden");
	
});

//////



///start cluster change function
function filter_cluster_details(idName, date_start, date_end){
	
	custom_cluster_details("blogdistribution", idName, date_start, date_end)
	custom_cluster_details("postmentioned", idName, date_start, date_end)
	custom_cluster_details("bloggersmentioned", idName, date_start, date_end)
	custom_cluster_details("postinglocation", idName, date_start, date_end)
	custom_cluster_details("post_detail_row", idName, date_start, date_end)
	custom_cluster_details("loadkeywords", idName, date_start, date_end)
	custom_cluster_details("blogdistribution", idName, date_start, date_end)
	custom_cluster_details("clusterchord", idName, date_start, date_end)
	custom_cluster_details("clusterwordcount", idName, date_start, date_end)
	
}
///end cluster change function


function custom_cluster_details(filter_type,clusterid, date_start, date_end ){
	$("#"+filter_type).html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");

	
	$.ajax({
		url: app_url+"subpages/cluster_details.jsp",
		method: 'POST',
		data: {
			action:filter_type,
			cluster:clusterid,
			date_start:date_start,
			date_end:date_end,
			tid:$('#tid').val()
		},
		error: function(response)
		{	
			console.log("error");
			console.log(response);
			//$("#").html(response);
		},
		success: function(response)
		{   
			//console.log(response);
			//$("#blogpost_detail").html(response);
			$("#"+filter_type).html(response);	
			
	
		}
	});
	
}







function loadblogdistribution(clusterid){
	$("#blogdistribution").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");

	
	$.ajax({
		url: "CLUSTERING",
		method: 'POST',
		data: {
			action:"loadblogdistribution",
			cluster:clusterid,
			tid:$('#tid').val()
		},
		error: function(response)
		{						
			//console.log(response);
			$("#blogdistribution").html(response);
		},
		success: function(response)
		{   
			console.log(response);
			//$("#blogpost_detail").html(response);
			$("#blogdistribution").html(response);	
			
	
		}
	});
	
}

function loadpostmentioned(clusterid){
	$("#postmentioned").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");

	
	$.ajax({
		url: "CLUSTERING",
		method: 'POST',
		data: {
			action:"loadpostmentioned",
			cluster:clusterid,
			tid:$('#tid').val()
		},
		error: function(response)
		{						
			//console.log(response);
			$("#postmentioned").html(response);
		},
		success: function(response)
		{   
			console.log(response);
			//$("#blogpost_detail").html(response);
			$("#postmentioned").html(response);	
			
	
		}
	});
	
}

function loadbloggersmentioned(clusterid){
	$("#bloggersmentioned").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");

	
	$.ajax({
		url: "CLUSTERING",
		method: 'POST',
		data: {
			action:"loadbloggersmentioned",
			cluster:clusterid,
			tid:$('#tid').val()
		},
		error: function(response)
		{						
			
			
			//console.log(response);
			$("#bloggersmentioned").html(response);
		},
		success: function(response)
		{   
			console.log(response);
			//$("#blogpost_detail").html(response);
			$("#bloggersmentioned").html(response);	
			
	
		}
	});
	
}


function loadpostinglocation(clusterid){
	$("#postinglocation").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");

	
	$.ajax({
		url: "CLUSTERING",
		method: 'POST',
		data: {
			action:"loadpostinglocation",
			cluster:clusterid,
			tid:$('#tid').val()
		},
		error: function(response)
		{						
			//console.log(response);
			$("#postinglocation").html(response);
		},
		success: function(response)
		{   
			console.log(response);
			//$("#blogpost_detail").html(response);
			$("#postinglocation").html(response);	
			
	
		}
	});
	
}

function loadtitletable(clusterid){
	/*$("#postinglocation").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");*/

	
	$.ajax({
		url: "CLUSTERING",
		method: 'POST',
		dataType:'json',
		data: {
			action:"loadtitletable",
			cluster:clusterid,
			tid:$('#tid').val()
		},
		error: function(response)
		{						
			//console.log(response);
			/*$("#postinglocation").html(response);*/
		},
		success: function(response)
		{   
			console.log("response", response);
			blog_post_data = response['post_data']
			var arrayLength = response['post_data'].length;
			$("#posts_display").addClass("hidden");
			$("#posts_display_loader").removeClass("hidden");
			
			$("#posts_details").addClass("hidden");
			$("#posts_details_loader").removeClass("hidden");
			
			$("#posts_display").html("");
			$('#posts_display').empty();
			
			$("#cluster_post_body2").html("");
			$("#cluster_post_body2").empty();
			
			if ( $.fn.DataTable.isDataTable('#DataTables_Table_20_wrapper') ) {
				// alert("already");
				 $('#DataTables_Table_20_wrapper').DataTable().clear();
				 $('#DataTables_Table_20_wrapper').DataTable().destroy();
				} 
			
			
			
			if(arrayLength > 0){
				
				details1 = '';
				max_post_id = parseFloat(0.00);
				max_disatance_id = parseFloat(0.00);
				
				//end if empty length check
		
				for (var i = 0; i < arrayLength; i++) {
					
					
					var post_identify = response['post_data'][i]['_source'].blogpost_id;
					if(i === 0){
						max_post_id = post_identify;
						max_distance_id = parseFloat(response['distances'][post_identify]);
						console.log(max_distance_id)
						temporary = i
					}
					
					a = parseFloat(max_distance_id)
					b = parseFloat(response['distances'][post_identify])
					
					
					
					if(parseFloat(b) < parseFloat(a)){
						max_post_id = post_identify;
						max_distance_id = parseFloat(response['distances'][post_identify]);
						temporary = i
					}
					
					details1 += '<tr>';
					details1 += '<td ><a blogid='+post_identify+' id="blog_'+post_identify+'" arr_count="'+i+'" class="blogPostClickListener blogpost_link cursor-pointer">'+response['post_data'][i]['_source'].title+'</a>  <br/>';
					details1 += '<a id="viewpost_'+post_identify+'" class="mt20 viewpost makeinvisible" href="'+response['post_data'][i]['_source'].permalink+'" target="_blank"><buttton class="btn btn-primary btn-sm mt10 visitpost">Visit Post &nbsp;<i class="fas fa-external-link-alt"></i></buttton></a></td>';
					details1 += '<td>'+parseFloat(response['distances'][post_identify])+'</td>';
					details1 += '</tr>';
					
					
					
				}
				
				$("#cluster_post_body2").html(details1);
				
				
				 $('#DataTables_Table_0_wrapper').DataTable().destroy();
				 $('#DataTables_Table_20_wrapper').DataTable().destroy();
				// table set up datatable for blog posts
				 
				  
				 console.log('sfddfsdfsdfsfsdfs')
				 console.log(max_post_id)
				 console.log(temporary)
				  console.log(max_distance_id)
				 console.log('sfddfsdfsdfsfsdfs')
					
					let arr_count = $(this).attr("arr_count");
				
					id = blog_post_data[temporary]['_source'].blogpost_id
					
					$(".viewpost").addClass("makeinvisible");
			    	$('.blogpost_link').removeClass("activeselectedblog");
			    	$('#blog_'+id).addClass("activeselectedblog");
			    	$("#viewpost_"+id).removeClass("makeinvisible");
				
					$('#titleContainer').html(blog_post_data[temporary]['_source'].title);
			    	$('#authorContainer').html(blog_post_data[temporary]['_source'].blogger);
			    	$('#dateContainer').html(blog_post_data[temporary]['_source'].date);
			    	$('#postContainer').html(blog_post_data[temporary]['_source'].post);
			    	$('#numCommentsContainer').html(blog_post_data[temporary]['_source'].numComments + " comments");
			    	
			    	 $('#DataTables_Table_20_wrapper').DataTable( {
				         "scrollY": 430,
				         "scrollX": true,
				         "order": [[ 1, "asc" ]],
				         "pagingType": "simple",
				         "columnDefs": [
			        	      { "width": "65%", "targets": 0 },
			        	      { "width": "25%", "targets": 0 }
			        	    ]
				        	 
				     } );
			    	
			    	$("#posts_details").removeClass("hidden");
					$("#posts_details_loader").addClass("hidden");
			     
			     ///end instantiating datatable
					
					  
					  $("#posts_display").empty()
			     $("#posts_display2").removeClass("hidden");
				$(".posts_display2").removeClass("hidden");
				$("#posts_display_loader").addClass("hidden");
				
				
				
				
				
				
				
				
				
			}else{
				console.log('no post title')
			}
			
			
	
		}
	});
	
}

function loadkeywords(clusterid){
	/*$("#postinglocation").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");*/
	
	$.ajax({
		url: "CLUSTERING",
		method: 'POST',
		dataType:'json',
		data: {
			action:"loadkeywords",
			cluster:clusterid,
			tid:$('#tid').val()
		},
		error: function(response)
		{						
			console.log('error in keyword')
			console.log(response);
			/*$("#postinglocation").html(response);*/
		},
		success: function(response)
		{   
			//alert('i am here')
			console.log('loadkeywords details')
			console.log(response);
			
//			$("#keyword_display").addClass("hidden");
			$("#keyword_display_loader").removeClass("hidden");
			
//			$("#keyword_display").empty();
//			build = '<div id="tagcloudcontainer2" style="min-height: 300px;"></div>';
//			
//			$("#keyword_display").html(build);
			
			//var terms = response;
			//var new_dd = terms.replace('[','{').replace(']','}').replace(/\),/g,'-').replace(/\(/g,'').replace(/,/g,':').replace(/-/g,',').replace(/\)/g,'').replace(/'/g,"");
			//var newjson = new_dd.replace(/\s+/g,'').replace(/{/g,'{"').replace(/:/g,'":"').replace(/,/g,'","').replace(/}/g,'"}')
			//var newjson = terms.replace(/"/g,"");
			//var jsondata = JSON.parse(terms)
			var jsondata =response;
			
			console.log('trtrtrtrtrtrtrtrtrtr')
			console.log('data',jsondata)
			
			elem = '#tagcloudcontainer1';
			
			
			
			
//			doCloud(jsondata,elem)
			$("#tagcloudcontainer1").removeClass("hidden");
			$("#tagcloudcontainer1").html("");
			wordtagcloud("#tagcloudcontainer1",450,jsondata);
			
			$("#new_word").removeClass("hidden");
			
//			$(".keyword_display").addClass("hidden");
			$("#keyword_display").addClass("hidden");
			
//			$(".new_word").removeClass("hidden");
//			$("#for_word").addClass("hidden");
			
			$("#keyword_display_loader").addClass("hidden");
			
			
			
			
			/*console.log(response[0]['_source'].post);*/
			//alert('here')
			//console.log(response[0]);
			
			/*$("#postinglocation").html(response);	*/
			
	
		}
	});
	
}



function drawChord(container, options, matrix, array) {
	/*console.log("container")
	console.log(container)
	
	console.log("options")
	console.log(options)
	
	console.log("matrix")
	console.log(matrix)
	
	console.log("array")
	console.log(array)*/
	
	/* function finalClick(t) {
        return this.selectTopic(t);
    } */
	
    // initialize the chord configuration variables
	var elem = container;
    var config = {
        width: 500,
        height: 470,
        rotation: 0,
        textgap: 40,
        colors: ["#C4C4C4", "#69B40F", "#EC1D25", "#C8125C", "#008FC8", "#10218B", "#134B24", "#737373", "#ffff00", "#ff79c5"]
    };
    
    // add options to the chord configuration object
    if (options) {
        extend(config, options);
    }
    
    // set chord visualization variables from the configuration object
    var offset = Math.PI * config.rotation,
        width = config.width,
        height = config.height,
        textgap = config.textgap,
        colors = config.colors;
    
    // set viewBox and aspect ratio to enable a resize of the visual dimensions 
    var viewBoxDimensions = "0 0 " + width + " " + height,
        aspect = width / height;
    
    var gnames = [];
    
    if (config.gnames) {
        gnames = config.gnames;
    } else {
        // make a list of names
        gnames = [];
        for (var i=97; i<matrix.length; i++) {
            gnames.push(String.fromCharCode(i));
        }
    }

    // start the d3 magic
    var chord = d3.layout.chord()
        .padding(.04)
        .sortSubgroups(d3.descending)
        .sortChords(d3.ascending) //which chord should be shown on top when chords cross. Now the biggest chord is at the bottom
        .matrix(matrix);

    var innerRadius = Math.min(width, height) * .35,
        outerRadius = innerRadius * 1.1;

    var fill = d3.scale.ordinal()
        .domain(d3.range(array.length-1))
        .range(colors);

    
    var d3Container = d3.select(container),
    margin = { top: 30, right: 10, bottom: 20, left: 25 },
    width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right,
    height = height - margin.top - margin.bottom;

/*Initiate the color scale*/
var fill = d3.scale.ordinal()
    .domain(d3.range(array.length))
    .range(colors);

/*//////////////////////////////////////////////////////////
/////////////// Initiate Chord Diagram /////////////////////
//////////////////////////////////////////////////////////*/
// var margin = {top: 30, right: 25, bottom: 20, left: 25},
//     width = 650 - margin.left - margin.right,
//     height = 600 - margin.top - margin.bottom,
var innerRadius = Math.min(width, height) * .34,
    outerRadius = innerRadius * 1.10;

var container = d3Container.append("svg:svg");

/*Initiate the SVG*/
// var svg = d3.select("#chart").append("svg:svg")
var svg = container
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("svg:g")
    .attr("transform", "translate(" + (margin.left + width / 2) + "," + (margin.top + height / 2) + ")");

    var g = svg.selectAll("g.group")
        .data(chord.groups)
      .enter().append("svg:g")
        .attr("class", "group");

    g.append("svg:path")
        .style("fill", function(d) { return fill(d.index); })
        .style("stroke", function(d) { return fill(d.index); })
        
        .attr("id", function(d, i) { return "group" + d.index; })
        .attr("d", d3.svg.arc().innerRadius(innerRadius).outerRadius(outerRadius).startAngle(startAngle).endAngle(endAngle))
        .on("mouseover", fade(.02))
        .on("mouseout", fade(.80))
        .on("click",function(d){
        	selectedTopic = d.index;
        	topics.update();
        })
        .selectAll("path")
        .data(chord.chords)
         .enter().append("path")
      .append("svg:title")
        .text(function(d) { 
            return  d.source.value + " terms from " + gnames[d.source.index] + " in " + gnames[d.target.index]; 
        });
        
        /* .on("click",function(d){finalClick(d.index);}); */

////////////////////////////////////////////////////////////
//////////////////Append Names ////////////////////////////
////////////////////////////////////////////////////////////

    g.append("svg:text")
        .each(function(d) {d.angle = ((d.startAngle + d.endAngle) / 2) + offset; })
        .attr("dy", ".35em")
        //.attr("font-size", "100px")
        .attr("text-anchor", function(d) { return d.angle > Math.PI ? "end" : null; })
        .attr("transform", function(d) {
            return "rotate(" + (d.angle * 180 / Math.PI - 90) + ")"
                + "translate(" + (innerRadius + 55) + ")"
                + (d.angle > Math.PI ? "rotate(180)" : "");
          })
          
        .text(function(d) { return gnames[d.index]; });

    svg.append("g")
    
        .attr("class", "chord")
        
      .selectAll("path")
        .data(chord.chords)
        
      .enter().append("path")
        .attr("d", d3.svg.chord().radius(innerRadius).startAngle(startAngle).endAngle(endAngle))
        
        .style("fill", function(d) { return fill(d.source.index); })
        .style("opacity", 1)
        
      .append("svg:title")
        .text(function(d) { 
            return  d.source.value + " terms from " + gnames[d.source.index] + " in " + gnames[d.target.index]; 
        });
    
////////////////////////////////////////////////////////////
//////////////////Append Ticks ////////////////////////////
////////////////////////////////////////////////////////////
    //console.log('chord', chord.chords.source.value)
    var ticks = svg.append("svg:g").selectAll("g.ticks")
     .data(chord.groups)
     .enter().append("svg:g").selectAll("g.ticks")
     .attr("class", "ticks")
     .data(groupTicks)
     .enter().append("svg:g")
     .attr("transform", function(d) {
  return "rotate(" + (d.angle * 180 / Math.PI - 90) + ")"
      + "translate(" + outerRadius+40 + ",0)";
});

    ticks.append("svg:line")
.attr("x1", 1)
.attr("y1", 0)
.attr("x2", 5)
.attr("y2", 0)
.style("stroke", "#000");

ticks.append("svg:text")
.attr("x", 8)
.attr("dy", ".35em")
.attr("transform", function(d) { return d.angle > Math.PI ? "rotate(180)translate(-16)" : null; })
.style("text-anchor", function(d) { return d.angle > Math.PI ? "end" : null; })
.text(function(d) { return d.label; });


    
    // helper functions start here
    
    function startAngle(d) {
        return d.startAngle + offset;
    }

    function endAngle(d) {
        return d.endAngle + offset;
    }
    
    function extend(a, b) {
        for( var i in b ) {
        	
            a[ i ] = b[ i ];
        }
    }

    // Returns an event handler for fading a given chord group.
    function fade(opacity) {
        return function(g, i) {
            svg.selectAll(".chord path")
                .filter(function(d) { return d.source.index != i && d.target.index != i; })
                .transition()
                .style("opacity", opacity);
        };
    }
    
    // Returns an array of tick angles and labels, given a group.
function groupTicks(d) {
var k = (d.endAngle - d.startAngle) / d.value;
return d3.range(0, d.value, 500).map(function(v, i) {
return {
  angle: v * k + d.startAngle,
  label: i % 1 ? null : v 
};
});
} //groupTicks
    
    window.onresize = function() {
        var targetWidth = (window.innerWidth < width)? window.innerWidth : width;
        
        var svg = d3.select(elem)
            .attr("width", targetWidth)
            .attr("height", targetWidth / aspect);
    }
    };

