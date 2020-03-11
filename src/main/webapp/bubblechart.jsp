<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>BUBBLE TEST</title>
<style>
.node {
	cursor: pointer;
}

.node:hover {
	stroke: #000;
	stroke-width: 1.5px;
}

.node--leaf {
	fill: white;
}

.label {
	font: 11px "Helvetica Neue", Helvetica, Arial, sans-serif;
	text-anchor: middle;
	text-shadow: 0 1px 0 #fff, 1px 0 0 #fff, -1px 0 0 #fff, 0 -1px 0 #fff;
}

.label, .node--root, .node--leaf {
	pointer-events: none;
}

.meter-background {
	fill: #DFEAFD;
}

.meter-foreground {
	fill: #2E7AF9;
}
</style>
</head>
<body>
	<div id="dataviz_axisZoom"></div>

	<!-- <script type="text/javascript" src="assets/vendors/d3/d3.min.js"></script>
	<script type="text/javascript" src="assets/vendors/d3/d3_tooltip.js"></script> -->
	<!-- <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.5/d3.min.js"></script> -->
	<script src="https://d3js.org/d3.v4.js"></script>
	<!-- <script src="assets/js/jquery.min.js"></script> -->
	<script>
		console.log('seun')

		/* var margin = {top: 10, right: 30, bottom: 30, left: 60},
		 width = 460 - margin.left - margin.right,
		 height = 400 - margin.top - margin.bottom;

		 // append the svg object to the body of the page
		 var svg = d3.select("#my_dataviz")
		 .append("svg")
		 .attr("width", width + margin.left + margin.right)
		 .attr("height", height + margin.top + margin.bottom)
		 .append("g")
		 .attr("transform",
		 "translate(" + margin.left + "," + margin.top + ")");

		 //Read the data
		 d3.csv("test_data.csv", function(data) {

		 // Add X axis
		 var x = d3.scaleLinear()
		 .domain([-0.2, 0.6])
		 .range([ 0, width ]);
		 svg.append("g")
		 .attr("transform", "translate(0," + height + ")")
		 .call(d3.axisBottom(x));

		 // Add Y axis
		 var y = d3.scaleLinear()
		 .domain([-0.6, 0.2])
		 .range([ height, 0]);
		 svg.append("g")
		 .call(d3.axisLeft(y));

		 // Color scale: give me a specie name, I return a color
		 var color = d3.scaleOrdinal()
		 .domain(["0", "1", "2","3","4","5","6","7","8","9" ])
		 .range([ "#440154ff", "#21908dff", "#fde725ff", "#440154ff", "#21908dff", "#fde725ff","#440154ff", "#21908dff", "#fde725ff","#fde725ff"])

		 // Add dots
		 svg.append('g')
		 .selectAll("dot")
		 .data(data)
		 .enter()
		 .append("circle")
		 .attr("cx", function (d) { return x(d.new_x); } )
		 .attr("cy", function (d) { return y(d.new_y); } )
		 .attr("r", 5)
		 .style("fill", function (d) { return color(d.cluster) } )

		 }) */

		// set the dimensions and margins of the graph
		/* var margin = {top: 10, right: 30, bottom: 30, left: 60},
		 width = 460 - margin.left - margin.right,
		 height = 400 - margin.top - margin.bottom;

		 // append the svg object to the body of the page
		 var Svg = d3.select("#dataviz_brushZoom")
		 .append("svg")
		 .attr("width", width + margin.left + margin.right)
		 .attr("height", height + margin.top + margin.bottom)
		 .append("g")
		 .attr("transform",
		 "translate(" + margin.left + "," + margin.top + ")");

		 //Read the data
		 d3.csv("test_data.csv", function(data) {

		 // Add X axis
		 var x = d3.scaleLinear()
		 .domain([-0.2, 0.6])
		 .range([ 0, width ]);
		 var xAxis = Svg.append("g")
		 .attr("transform", "translate(0," + height + ")")
		 .call(d3.axisBottom(x));

		 // Add Y axis
		 var y = d3.scaleLinear()
		 .domain([-0.6, 0.2])
		 .range([ height, 0]);
		 Svg.append("g")
		 .call(d3.axisLeft(y));

		 // Add a clipPath: everything out of this area won't be drawn.
		 var clip = Svg.append("defs").append("svg:clipPath")
		 .attr("id", "clip")
		 .append("svg:rect")
		 .attr("width", width )
		 .attr("height", height )
		 .attr("x", 0)
		 .attr("y", 0);

		 // Color scale: give me a specie name, I return a color
		 var color = d3.scaleOrdinal()
		 .domain(["0", "1", "2","3","4","5","6","7","8","9" ])
		 .range([ 'red', 'green', 'blue', 'orange', 'purple','pink', 'black', 'grey', 'brown','yellow'])

		 // Add brushing
		 var brush = d3.brushX()                 // Add the brush feature using the d3.brush function
		 .extent( [ [0,0], [width,height] ] ) // initialise the brush area: start at 0,0 and finishes at width,height: it means I select the whole graph area
		 .on("end", updateChart) // Each time the brush selection changes, trigger the 'updateChart' function

		 // Create the scatter variable: where both the circles and the brush take place
		 var scatter = Svg.append('g')
		 .attr("clip-path", "url(#clip)")

		 // Add circles
		 scatter
		 .selectAll("circle")
		 .data(data)
		 .enter()
		 .append("circle")
		 .attr("cx", function (d) { return x(d.new_x); } )
		 .attr("cy", function (d) { return y(d.new_y); } )
		 .attr("r", 8)
		 .style("fill", function (d) { return color(d.cluster) } )
		 .style("opacity", 0.5)

		 // Add the brushing
		 scatter
		 .append("g")
		 .attr("class", "brush")
		 .call(brush);

		 // A function that set idleTimeOut to null
		 var idleTimeout
		 function idled() { idleTimeout = null; }

		 // A function that update the chart for given boundaries
		 function updateChart() {

		 extent = d3.event.selection

		 // If no selection, back to initial coordinate. Otherwise, update X axis domain
		 if(!extent){
		 if (!idleTimeout) return idleTimeout = setTimeout(idled, 350); // This allows to wait a little bit
		 x.domain([ 4,8])
		 }else{
		 x.domain([ x.invert(extent[0]), x.invert(extent[1]) ])
		 scatter.select(".brush").call(brush.move, null) // This remove the grey brush area as soon as the selection has been done
		 }

		 // Update axis and circle position
		 xAxis.transition().duration(1000).call(d3.axisBottom(x))
		 scatter
		 .selectAll("circle")
		 .transition().duration(1000)
		 .attr("cx", function (d) { return x(d.new_x); } )
		 .attr("cy", function (d) { return y(d.new_y); } )

		 }



		 }) */

		//set the dimensions and margins of the graph
		var margin = {
			top : 10,
			right : 30,
			bottom : 30,
			left : 60
		}, width = 700 - margin.left - margin.right, height = 700 - margin.top
				- margin.bottom;

		//append the SVG object to the body of the page
		var SVG = d3.select("#dataviz_axisZoom").append("svg").attr("width",
				width + margin.left + margin.right).attr("height",
				height + margin.top + margin.bottom).append("g").attr(
				"transform",
				"translate(" + margin.left + "," + margin.top + ")");

		//Read the data
		d3.csv("test_data2.csv", function(data) {
			console.log(data)
		})

		/* var data2 = []; */
		var data = [ 
			 {
				"cluster" : "0",
				"new_x" : "1",
				"new_y" : "3"

			
		}, {
			
				"cluster" : "1",
				"new_x" : "4",
				"new_y" : "5"
			
		}, {
			
				"cluster" : "2",
				"new_x" : "6",
				"new_y" : "7"
		

		} ];
		/* var data_final = data2.push(data);
		console.log(data_final) */
		// Add X axis
		console.log(data)
		var x = d3.scaleLinear().domain([ 1, 10 ]).range([ 0, width ]);
		var xAxis = SVG.append("g").attr("transform",
				"translate(0," + height + ")").call(d3.axisBottom(x));

		// Add Y axis
		var y = d3.scaleLinear().domain([ 1, 10 ]).range([ height, 0 ]);
		var yAxis = SVG.append("g").call(d3.axisLeft(y));

		// Add a clipPath: everything out of this area won't be drawn.
		var clip = SVG.append("defs").append("SVG:clipPath").attr("id", "clip")
				.append("SVG:rect").attr("width", width).attr("height", height)
				.attr("x", 0).attr("y", 0);

		var color = d3.scaleOrdinal().domain([ "0", "1", "2" ]).range(
				[ 'red', 'green', 'blue' ])
		/* .domain(["0", "1", "2","3","4","5","6","7","8","9" ]) */
		/* .range([ 'red', 'green', 'blue', 'orange', 'purple','pink', 'black', 'grey', 'brown','yellow']) */

		// Create the scatter variable: where both the circles and the brush take place
		var scatter = SVG.append('g').attr("clip-path", "url(#clip)")

		// Add circles
		scatter.selectAll("circle").data(data).enter().append("circle").attr(
				"cx", function(d) {
					return x(d.new_x);
				}).attr("cy", function(d) {
			return y(d.new_y);
		}).attr("r", 8).style("fill", function(d) {
			return color(d.cluster)
		}).style("opacity", 0.5)

		// Set the zoom and Pan features: how much you can zoom, on which part, and what to do when there is a zoom
		var zoom = d3.zoom().scaleExtent([ .5, 20 ]) // This control how much you can unzoom (x0.5) and zoom (x20)
		.extent([ [ 0, 0 ], [ width, height ] ]).on("zoom", updateChart);

		// This add an invisible rect on top of the chart area. This rect can recover pointer events: necessary to understand when the user zoom
		SVG.append("rect").attr("width", width).attr("height", height).style(
				"fill", "none").style("pointer-events", "all").attr(
				'transform',
				'translate(' + margin.left + ',' + margin.top + ')').call(zoom);
		// now the user can zoom and it will trigger the function called updateChart

		// A function that updates the chart when the user zoom and thus new boundaries are available
		function updateChart() {

			// recover the new scale
			var newX = d3.event.transform.rescaleX(x);
			var newY = d3.event.transform.rescaleY(y);

			// update axes with these new boundaries
			xAxis.call(d3.axisBottom(newX))
			yAxis.call(d3.axisLeft(newY))

			// update circle position
			scatter.selectAll("circle").attr('cx', function(d) {
				return newX(d.new_x)
			}).attr('cy', function(d) {
				return newY(d.new_y)
			});
		}

		/* }) */
	</script>
</body>
</html>