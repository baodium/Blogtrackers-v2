class ChordDiagram {

    constructor(_matrix, _height, elem) {
    	this.matrix = _matrix;
    	this.names = [];
    	this.height = _height;
    	this.container = document.getElementById(elem);
    	this.colors = ["#C4C4C4", "#69B40F", "#EC1D25", "#C8125C", "#008FC8", "#10218B", "#134B24", "#737373", "#ffff00", "#ff79c5"];
    	
    	for (let i = 0; i < this.matrix.length; i++) {
    		this.names.push("Topic " + (i + 1));
    	}
    }

    initialize() {
    	this.selectTopic(0);
    }
    
    update() {
    	// Reset container first
		while (this.container.firstChild) {
			this.container.removeChild(this.container.firstChild);
		}
    	this.selectTopic(selectedTopic);
    }
    
    selectTopic(topic) {
    	//alert(topic);
    	let topicMatrix = [];
    	
    	for(let i = 0; i < this.matrix.length; i++) {
    		topicMatrix[i] = this.matrix[i].slice();
    	}
    	
    	for(let i = 0; i < topicMatrix.length; i++) {
    		for(let j = 0; j < topicMatrix.length; j++) {
	    		// Save incoming chords (j == topic) and arc sizes (i ==j)
	    		if (j != topic && i != j) {
	    			topicMatrix[i][j] = 0.0;
	    		}
    		}
    	}
    	
    	var rotation = 0;
    	var chord_options = {
    		    "gnames": this.names,
    		    "rotation": rotation,
    		    "colors": this.colors
    		};
    	drawChord(this.container, chord_options, topicMatrix, this.names); 
    	
    	//this.Chord(this.container, this.height, topicMatrix, this.names, this.colors);
    }
   /* function drawChord(container, options, matrix, array){
    	rerurn 
    }*/
          
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
    .call(responsivefy)
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
            return  d.source.value + " posts from " + gnames[d.source.index] + " in " + gnames[d.target.index]; 
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

function responsivefy(svg) {
	  // container will be the DOM element the svg is appended to
	  // we then measure the container and find its aspect ratio
	  const container = d3.select(svg.node().parentNode),
	      width = parseInt(svg.style('width'), 10),
	      height = parseInt(svg.style('height'), 10),
	      aspect = width / height;

	  // add viewBox attribute and set its value to the initial size
	  // add preserveAspectRatio attribute to specify how to scale
	  // and call resize so that svg resizes on inital page load
	  svg.attr('viewBox', `0 0 ${width} ${height}`)
	      .attr('preserveAspectRatio', 'xMinYMid')
	      .call(resize);

	  // add a listener so the chart will be resized when the window resizes
	  // to register multiple listeners for same event type,
	  // you need to add namespace, i.e., 'click.foo'
	  // necessary if you invoke this function for multiple svgs
	  // api docs: https://github.com/mbostock/d3/wiki/Selections#on
	  d3.select(window).on('resize.' + container.attr('id'), resize);

	  // this is the code that actually resizes the chart
	  // and will be called on load and in response to window resize
	  // gets the width of the container and proportionally resizes the svg to fit
	  function resize() {
	      const targetWidth = parseInt(container.style('width'));
	      svg.attr('width', targetWidth);
	      svg.attr('height', Math.round(targetWidth / aspect));
	  }
	}
    
    /*window.onresize = function() {
        var targetWidth = (window.innerWidth < width)? window.innerWidth : width;
        
        var svg = d3.select('#chord_body')
            .attr("width", targetWidth)
            .attr("height", targetWidth / aspect);
    }*/
    };