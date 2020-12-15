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
.marygy{
margin: 20px;
}

.mark{

margin-left:100px;
margin-right:100px;
margin-top:50px;
height: 600px;
width: 600px;
}

</style>
</head>
<body>

	<div class="mark">
		<div id="clusterdiagram"></div>
	</div>
	

	<!-- <script type="text/javascript" src="assets/vendors/d3/d3.min.js"></script> -->
	<!-- <script type="text/javascript" src="assets/vendors/d3/d3_tooltip.js"></script> -->
	<!-- <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.5/d3.min.js"></script> -->
	<script src="https://d3js.org/d3.v4.js"></script>
	<script src="https://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>
	 
	<script>
		console.log('seun')
		
		//nodes = []
  
  var d3v4 = window.d3;

 
 

 // Chart setup
 d3.json("data_cluster.json", function(dataset){
	 clusterdiagram('#clusterdiagram', 500,dataset);
 })
 
 function clusterdiagram(element, height, dataset) {

   /* var nodes = [
     { id: "mammal", group: 0, label: "Mammals", level: 2 },
     { id: "dog"   , group: 0, label: "Dogs"   , level: 2 },
     { id: "cat"   , group: 0, label: "Cats"   , level: 2 },
     { id: "fox"   , group: 0, label: "Foxes"  , level: 2 },
     { id: "elk"   , group: 0, label: "Elk"    , level: 2 },
     { id: "insect", group: 1, label: "Insects", level: 2 },
     { id: "ant"   , group: 1, label: "Ants"   , level: 2 },
     { id: "bee"   , group: 1, label: "Bees"   , level: 2 },
     { id: "fish"  , group: 2, label: "Fish"   , level: 2 },
     { id: "carp"  , group: 2, label: "Carp"   , level: 2 },
     { id: "pike"  , group: 2, label: "Pikes"  , level: 2 }
   ] */
   
   
	 
var nodes = dataset.nodes
console.log('nodes', nodes)
//console.log('nodes',nodes)
   /* var links = [
   	{ target: "mammal", source: "dog" , strength: 3.0 },
   	{ target: "bee", source: "cat" , strength: 3.0 }
     /* { target: "mammal", source: "fox" , strength: 3.0 },
  
     { target: "insect", source: "ant" , strength: 0.7 },
     { target: "insect", source: "bee" , strength: 0.7 },
     { target: "fish"  , source: "carp", strength: 0.7 },
     { target: "fish"  , source: "pike", strength: 0.7 },
     { target: "cat"   , source: "elk" , strength: 0.1 },
     { target: "carp"  , source: "ant" , strength: 0.1 },
     { target: "elk"   , source: "bee" , strength: 0.1 },
     { target: "dog"   , source: "cat" , strength: 0.1 },
     { target: "fox"   , source: "ant" , strength: 0.1 },
   	{ target: "pike"  , source: "cat" , strength: 0.1 } */
   /* ]  */

   var links = dataset.links
console.log('links', links)
	   //console.log('links',links)
	   //var width = $('#clusterdiagram').width();
	//var height = $('#clusterdiagram').height();
   
   
      // Define main variables
      var d3Container = d3v4.select(element),
          margin = {top: 1000, right: 100, bottom: 200, left: 200},
          width = $('#clusterdiagram').width() - margin.left - margin.right,
          height = $('#clusterdiagram').height() - margin.top - margin.bottom;
			radius = 6;
	
     var colors = d3v4.scaleOrdinal(d3v4.schemeCategory10);
     
     
      // Add SVG element
      var container = d3Container.append("svg");

      // Add SVG group
      var svg = container
          .attr("width", width + margin.left + margin.right)
          .attr("height", height + margin.top + margin.bottom)
      .attr("overflow", "visible");
         //.append("g")
       //   .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

       // simulation setup with all forces
    var linkForce = d3v4
   .forceLink()
   .id(function (link) { return link.id })
   .strength(function (link) { return link.strength })

       // simulation setup with all forces
          var simulation = d3v4
         .forceSimulation()
         .force('link', d3.forceLink().id(d =>d.id).distance(-20))
         .force('charge', d3v4.forceManyBody())
         /* .force('center', d3v4.forceCenter(width, height ))   */
         .force('center', d3v4.forceCenter())  
         .force("collide",d3.forceCollide().strength(-5)) 
         
          /* simulation.force("center")
        .x(width * forceProperties.center.x)
        .y(height * forceProperties.center.y); */
         
         
          /*  var simulation = d3.forceSimulation()
             .force('x', d3.forceX().x(d => d.x))
             .force('y', d3.forceY().y(d => d.y))
             .force("charge",d3.forceManyBody().strength(-20))
              .force("link", d3.forceLink().id(d =>d.id).distance(20)) 
              .force("collide",d3.forceCollide().radius(d => d.r*10)) 
             .force('center', d3v4.forceCenter(width, height ))  */
            
			
			simulation.force("center")
		    .x(window.innerWidth / 2)
		    .y(window.innerHeight / 2)
		    
		   	simulation.force("charge")
        .strength(-3000 * true)
        .distanceMin(1)
        .distanceMax(2000);
		    /* .x(width * 0.5) */
			
			simulation.alpha(1).restart(); 

         var linkElements = svg.append("g")
           .attr("class", "links")
           .selectAll("line")
           .data(links)
           .enter().append("line")
             .attr("stroke-width", 0)
         	  .attr("stroke", "rgba(50, 50, 50, 0.2)")

       function getNodeColor(node) {
         return node.level === 1 ? 'red' : 'gray'
       }

         
         
       var nodeElements = svg.append("g")
         .attr("class", "nodes marygy")
         .selectAll("circle")
         .data(nodes)
         .enter().append("circle")
         
         /* .attr(circleAttrs) */
         
           .attr("r", function (d, i) {return d.level})
           .attr("fill", function (d, i) {return colors(d.group);})
           
           //.attr("text",function (node) { return  node.label })
           /* .on("mouseover", function (node) { return  node.label }); */

        var textElements = svg.append("g")
         .attr("class", "texts")
         .selectAll("text")
         .data(nodes)
         .enter().append("text")
           .text(function (node) { return  node.label })
       	  .attr("font-size", 15)
       	  .attr("dx", 15)
           .attr("dy", 4) 

         simulation.nodes(nodes).on('tick', () => {
           nodeElements
             .attr('cx', function (node) { return node.x })
             .attr('cy', function (node) { return node.y })
             textElements  
             .attr('x', function (node) { return node.x })
             .attr('y', function (node) { return node.y })
             linkElements
     .attr('x1', function (link) { return link.source.x })
     .attr('y1', function (link) { return link.source.y })
     .attr('x2', function (link) { return link.target.x })
     .attr('y2', function (link) { return link.target.y })
         })

function handleMouseOver(d, i) {  // Add interactivity

            // Use D3 to select element, change color and size
            d3.select(this).attr({
              fill: "orange",
              r: radius * 2
            });

            // Specify where to put label of text
            svg.append("text").attr({
               id: "t" + d.x + "-" + d.y + "-" + i,  // Create an id for text so we can select it later for removing on mouseout
                x: function() { return xScale(d.x) - 30; },
                y: function() { return yScale(d.y) - 15; }
            })
            .text(function() {
              return [d.x, d.y];  // Value of the text
            });
          }
        
 simulation.force("link").links(links)
 }

	</script>
</body>
</html>