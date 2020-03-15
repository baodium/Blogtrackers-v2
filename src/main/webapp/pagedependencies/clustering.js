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
		loadkeywords(idName)
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
			/* console.log(response); */
			
			var vvv = response['post_data'][0]['_source'].blogpost_id;
			//console.log('post_id',vvv); 
			//console.log('distance',response['distances'][vvv]); 
			
			/*$("#postinglocation").html(response);	*/
			
	
		}
	});
	
}

function loadkeywords(clusterid){
	/*$("#postinglocation").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");*/
	
	$.ajax({
		url: "CLUSTERING",
		method: 'POST',
		/*dataType:'json',*/
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
        height: 450,
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
            return  d.source.value + " posts from " + gnames[d.source.index] + " in " + gnames[d.target.index]; 
        });
    
////////////////////////////////////////////////////////////
//////////////////Append Ticks ////////////////////////////
////////////////////////////////////////////////////////////
    
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

