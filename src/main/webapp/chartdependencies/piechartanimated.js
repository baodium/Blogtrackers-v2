/* ------------------------------------------------------------------------------
 *
 *  # D3.js - pie chart entry animation
 *
 *  Demo d3.js pie chart setup with .csv data source and loading animation
 *
 *  Version: 1.0
 *  Latest update: August 1, 2015
 *
 * ---------------------------------------------------------------------------- */

    // Chart setup
    function pieChartAnimation(element, radius, data) {


        // Basic setup
        // ------------------------------

        // Create chart
        // ------------------------------

        // Add SVG element
        var container = d3.select(element).append("svg");
        //.margin = {top: 10, right: 10, bottom: 20, left: 30};

        // Add SVG group
        var svg = container
            .attr("width", radius * 2)
            .attr("height", radius * 2)
            .call(responsivefy)
            .append("g")
                .attr("transform", "translate(" + radius + "," + radius + ")");


        // Construct chart layout
        // ------------------------------


        

        // Arc
        var arc = d3.svg.arc()
            .outerRadius(radius)
            .innerRadius(0);

        // Pie
        var pie = d3.layout.pie()
            .sort(null)
            .value(function(d) { return d.value; });

            // construct the data format

              data.forEach(function(d) {
                  d.value = +d.value;
              });
              
              console.log(data);
              
              var totalValue = 0;
              
              data.forEach(function(d){
            	totalValue = totalValue + d.value;  
              });
              
              console.log(totalValue);
              
              
              var tip = d3.tip()
              .attr('class', 'd3-tip')
              .offset([-10, 0])
              .html(function(d) {
            	  
           	console.log(d)
               // console.log(d);
              if(d === null)
              {
                return "No Information Available";
              }
              else if(d !== null) {
             // calculate the percentage on the fly
            	percentageValue = d.value/totalValue * 100;  
               return d.data.label+" ("+percentageValue.toFixed(2)+"%)";
                }
              // return "here";
              });

              // contrstruct the chart
              var g = svg.selectAll(".d3-arc")
                  .data(pie(data))
                  .enter()
                  .append("g")
                      .attr("class", "d3-arc");

                      // Add arc path
                      g.append("path")
                         //.attr("d", arc)
                         // .style("stroke", "#fff")
                          .style("fill", function(d) {
                            customcolor = "";
                            if(d.data.label == "Positive")
                            {
                              customcolor = "#72C28E";
                            }
                            else if(d.data.label == "Negative") {
                              customcolor = "#FF7D7D";
                            }
                            return customcolor;

                          })
                          .on("mouseover",tip.show)
                          .on("mouseout",tip.hide);
//                          .transition()
//                              .ease("bounce")
//                              .duration(2000)
//                              .attrTween("d", tweenPie);
                     
                      
                 	 $(element).bind('inview', function (event, visible) {
                      	  if (visible == true) {
                      		svg.selectAll(".d3-arc")
                      		.selectAll("path")
                      		.attr("d", arc)
                            .style("stroke", "#fff")
                            .style("fill", function(d) {
                            customcolor = "";
                            if(d.data.label == "Positive")
                            {
                              customcolor = "#72C28E";
                            }
                            else if(d.data.label == "Negative") {
                              customcolor = "#FF7D7D";
                            }
                            return customcolor;

                          })
                            .transition()
                            .ease("bounce")
                             .duration(2000)
                             .attrTween("d", tweenPie);
                      	  } else {
                      		svg.selectAll(".d3-arc")
                      		.selectAll("path")
                      		.style("fill","#FFFFFF");
                      	  }
                      	});
                 	 
                 	 
                      // // Add text labels
                      g.append("text")
                          .attr("transform", function(d) { return "translate(" + arc.centroid(d) + ")"; })
                          .attr("dy", ".35em")
                          .style("opacity", 0)
                          .style("fill", "#fff")
                          .style("font-size", 16)
                          .style("text-anchor", "middle")
                          .text(function(d) { return d.data.label; })
                          .transition()
                              .ease("linear")
                              .delay(2000)
                              .duration(500)
                              .style("opacity", 1)

                              svg.call(tip)
                      //
                      //
                      // // Tween
                      function tweenPie(b) {
                          b.innerRadius = 0;
                          var i = d3.interpolate({startAngle: 0, endAngle: 0}, b);
                              return function(t) { return arc(i(t));
                          };
                      }
                      
                      function responsivefy(svg) {
                      	  // container will be the DOM element the svg is appended to
                      	  // we then measure the container and find its aspect ratioF
                      	  const container = d3.select(svg.node().parentNode),
                      	      width = parseInt(svg.style('width'), 10),
                      	      height = 360,
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
                      	      
                      	    plot_width = parseInt($('#scatter-container').width());
                      	    
                      	    if(targetWidth > 600){final_width = 360}else{final_width = targetWidth}
                      	    
                      	      svg.attr('width', final_width);
                      	      svg.attr('height', 360);
                      	  }
                      	}
    }
