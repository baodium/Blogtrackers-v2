	function wordtagcloud(element, height,word_count2) {
		
		var d3Container = d3.select(element),
        margin = {top: 5, right: 50, bottom: 20, left: 60},
        width = d3Container.node().getBoundingClientRect().width,
        height = height - margin.top - margin.bottom - 5;
		
		var container = d3Container.append("svg");
		var svg =  container
		 var word_count = {}; 
		    word_count = word_count2;
		// var word_count2 = {"ade":5};

        /* var words = text_string.split(/[ '\-\(\)\*":;\[\]|{},.!?]+/);
          if (words.length == 1){
            word_count[words[0]] = 1;
          } else {
            words.forEach(function(word){
              var word = word.toLowerCase();
              if (word != "" && common.indexOf(word)==-1 && word.length>1){
                if (word_count[word]){
                  word_count[word]++;
                } else {
                  word_count[word] = 1;
                }
              }
            })  */
            
            
					//console.log(typeof word_count2);
          var fill = d3.scale.category20();
            
		 var word_entries = d3.entries(word_count);
		 //console.log(word_count);
            
		var xScale = d3.scale.linear()
        .domain([0, d3.max(word_entries, function(d) {
           return d.value;
         })
        ])
        .range([10,100]);

     d3.layout.cloud().size([width, height])
       .timeInterval(20)
       .words(word_entries)
       .fontSize(function(d) { return xScale(+d.value); })
       .text(function(d) { return d.key; })
      // .rotate(function() { return ~~(Math.random() * 2) * 90; })
       .rotate(0)
       .font("Impact")
       .on("end", draw)
       .start();

     function draw(words) {
    	 svg
           .attr("width", width)
           .attr("height", height)
         .append("g")
           .attr("transform", "translate(" + [width >> 1, height >> 1] + ")")
         .selectAll("text")
           .data(words)
         .enter().append("text")
         .style("font-size", 0)
           //.style("font-size", function(d) { return xScale(d.value) + "px"; })
           .style("font-family", "Impact")
           .style("fill", function(d, i) { return fill(i); })
           .attr("text-anchor", "middle")
           .attr("transform", function(d) {
             return "translate(" + [d.x, d.y] + ")"+"rotate(" + d.rotate + ")";
           })
           /* .on("wheel", function() { d3.event.preventDefault(); })
                  .call(d3.behavior.zoom().on("zoom", function () {
                	var g = svg.selectAll("g"); 
                  g.attr("transform", "translate("+(width/2-10) +",180)" + " scale(" + d3.event.scale + ")").style("cursor","zoom-out")
                 })) */
           .text(function(d) { return d.key; })
    	 
    	/* .call(d3.behavior.drag()
          		.origin(function(d) { return d; })
          		.on("dragstart", dragstarted) 
          		.on("drag", dragged)			
          		); */
         
           svg.selectAll("text").transition()
                     .delay(200)
                     .duration(1000)
                     .style("font-size", function(d) { return xScale(d.value) + "px"; })
                     
          	// animation effect for tag cloud
   	 		 $(element).bind('inview', function (event, visible) {
           	  if (visible == true) {
           		  svg.selectAll("text").transition()
                     .delay(200)
                     .duration(1000)
                     .style("font-size", function(d) { return xScale(d.value) + "px"; })
           	  } else {
           		  svg.selectAll("text")
                     .style("font-size", 0)
           	  }
           	});
   	 		
   	 		d3.selectAll('.zoombutton').on("click",zoomClick);
   	 		
   	 		var zoom = d3.behavior.zoom().scaleExtent([1, 20]).on("zoom", zoomed);
   	 		
   	 		function zoomed() {
   	 			var g = svg.selectAll("g"); 
                  g.attr("transform",
   	 		        "translate(" +[width >> 1, height >> 1] +")" +
   	 		        "scale(" + zoom.scale() + ")"
   	 		    );
   	 		}
   	 		
   	 	// trasnlate and scale the zoom	
   	 	function interpolateZoom (translate, scale) {
   	 	    var self = this;
   	 	    return d3.transition().duration(350).tween("zoom", function () {
   	 	        var iTranslate = d3.interpolate(zoom.translate(), translate),
   	 	            iScale = d3.interpolate(zoom.scale(), scale);
   	 	        return function (t) {
   	 	            zoom
   	 	                .scale(iScale(t))
   	 	                .translate(iTranslate(t));
   	 	            zoomed();
   	 	        };
   	 	    });
   	 	}
   	 	
   	 	// respond to click efffect on the zoom
   	 	function zoomClick() {
   	 	    var clicked = d3.event.target,
   	 	        direction = 1,
   	 	        factor = 0.1,
   	 	        target_zoom = 1,
   	 	        center = [width >> 1, height >> 1],
   	 	        extent = zoom.scaleExtent(),
   	 	        translate = zoom.translate(),
   	 	        translate0 = [],
   	 	        l = [],
   	 	        view = {x: translate[0], y: translate[1], k: zoom.scale()};
   	 	    //console.log(this.id);
   	 	    d3.event.preventDefault();
   	 	    direction = (this.id === 'zoom_in') ? 1 : -1;
   	 	    target_zoom = zoom.scale() * (1 + factor * direction);
   	 	    if (target_zoom < extent[0] || target_zoom > extent[1]) { return false; }
   	 	    translate0 = [(center[0] - view.x) / view.k, (center[1] - view.y) / view.k];
   	 	    view.k = target_zoom;
   	 	    l = [translate0[0] * view.k + view.x, translate0[1] * view.k + view.y];
   	 	    view.x += center[0] - l[0];
   	 	    view.y += center[1] - l[1];
   	 	    interpolateZoom([view.x, view.y], view.k);
   	 	}
   	 		
   	 		
   	 		
               	function dragged(d) {
               	 var movetext = svg.select("g").selectAll("text");
               	 movetext.attr("dx",d3.event.y)
               	 .attr("dy",d3.event.x)
               	 .style("cursor","move"); 
               	 /* g.attr("transform","translateX("+d3.event.x+")")
               	 .attr("transform","translateY("+d3.event.y+")")
               	 .attr("width", width)
                    .attr("height", height); */
               	} 
               	function dragstarted(d){
       				d3.event.sourceEvent.stopPropagation();
       			} 
     
     
     
     }

     d3.layout.cloud().stop(); 	 	                
     
     // Resize chart
     // ------------------------------
     // Call function on window resize
     $(window).on('resize', resize);
     // Call function on sidebar width change
     $('.sidebar-control').on('click', resize);
     // Resize function
     //
     // Since D3 doesn't support SVG resize by default,
     // we need to manually specify parts of the graph that need to
     // be updated on window resize
     function resize() {
       // Layout variables
       width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right;
       //
       //
       // // Layout
       // // -------------------------
       //
       // // Main svg width
       container.attr("width", width + margin.left + margin.right);
       //
       // // Width of appended group
       svg.attr("width", width + margin.left + margin.right);
       //
       //
       // // Axes
       // // -------------------------
       //
       // // Horizontal range
       //x.rangeRoundBands([0, width]);
       //
       // // Horizontal axis
      // svg.selectAll('.d3-axis-horizontal').call(xAxis);
       //
       //
       // // Chart elements
       // // -------------------------
       //
       // // Line path
      
       //
       // // Crosshair
       // svg.selectAll('.d3-crosshair-overlay').attr("width", width);
     } 
	}