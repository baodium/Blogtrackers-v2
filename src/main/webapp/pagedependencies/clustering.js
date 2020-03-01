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
//		alert('here');
		var idName = $(this).attr("id");
		var cluster = idName.split("_")[1]
		$(".activeblog").html("Cluster "+cluster);
		console.log("this is cluster" + idName)
		loadblogdistribution(idName)
		loadpostmentioned(idName)
		loadbloggersmentioned(idName)
		loadpostinglocation(idName)
		loadtitletable(idName)
		/*loadscatter(idName - 1);*/
	});

})

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
			console.log('post details')
			console.log(response[0]['_source'].blogger);
			
			/*$("#postinglocation").html(response);	*/
			
	
		}
	});
	
}

