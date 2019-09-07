<%@page import="authentication.*"%>
<%@page import="java.util.*"%>
<%@page import="util.*"%>
<%@page import="java.io.File"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.net.URI"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	Object email = (null == session.getAttribute("email")) ? "" : session.getAttribute("email");
	Object tid = (null == request.getParameter("tid")) ? "" : request.getParameter("tid");

	Object user = (null == session.getAttribute("username")) ? "" : session.getAttribute("username");
	String single = (null == request.getParameter("sortdate")) ? "" : request.getParameter("sortdate");
	String sort =  (null == request.getParameter("sortby")) ? "blog" : request.getParameter("sortby").toString();//.replaceAll("[^a-zA-Z]", " ");
	String date_start = (null == request.getParameter("date_start")) ? "" : request.getParameter("date_start");
	String date_end = (null == request.getParameter("date_end")) ? "" : request.getParameter("date_end");
	String bloggersstr = (null == request.getParameter("bloggers")) ? "" : request.getParameter("bloggers");
		
	
	//JSONObject bloggers = new JSONObject(bloggersstr);
	//System.out.println("bloggers here "+bloggersstr);
%>
			
<div class="chart" id="influencebar"></div>
<script>


$(function () {

    // Initialize chart
    influencebar('#influencebar', 450);

    // Chart setup
    function influencebar(element, height) {

      // Basic setup
      // ------------------------------

      // Define main variables
      var d3Container = d3.select(element),
          margin = {top: 5, right: 50, bottom: 20, left: 150},
          width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right,
          height = height - margin.top - margin.bottom - 5;

         var formatPercent = d3.format("");

      // Construct scales
      // ------------------------------

      // Horizontal
      var y = d3.scale.ordinal()
          .rangeRoundBands([height,0], .5, .40);

      // Vertical
      var x = d3.scale.linear()
          .range([0,width]);

      // Color
      var color = d3.scale.category20c();



      // Create axes
      // ------------------------------

      // Horizontal
      var xAxis = d3.svg.axis()
          .scale(x)
          .orient("bottom")
          .ticks(6);

      // Vertical
      var yAxis = d3.svg.axis()
          .scale(y)
          .orient("left")
          //.tickFormat(formatPercent);



      // Create chart
      // ------------------------------

      // Add SVG element
      var container = d3Container.append("svg");

      // Add SVG group
      var svg = container
          .attr("width", width + margin.left + margin.right)
          .attr("height", height + margin.top + margin.bottom)
          .append("g")
              .attr("transform", "translate(" + margin.left + "," + margin.top + ")");


      //         // Create tooltip
      //             // ------------------------------
      //
      //
      //
      // // Load data
      // // ------------------------------
      //
      //
      //sort by influence score
     
      
      data = [ <%=bloggersstr.toString().toLowerCase()%>
        ];
      data = data.sort(function(a, b){
    	    return a.frequency - b.frequency;
    	}); 
      //
      //
      //   // Create tooltip
        var tip = d3.tip()
               .attr('class', 'd3-tip')
               .offset([-10, 0])
               .html(function(d) {
                 if(d.type === "blogger")
                 {
                   return "Blogger Name: "+d.name+"<br/> Influence Score: "+d.frequency;
                 }

                 if(d.type === "blog")
                 {
                   return d.letter+" ("+d.frequency+")<br/> Blog: "+d.name;
                 }

               });

           // Initialize tooltip
           svg.call(tip);

      //
      //     // Pull out values
      //     data.forEach(function(d) {
      //         d.frequency = +d.frequency;
      //     });
      //
      //
      //
      //     // Set input domains
      //     // ------------------------------
      //
      //     // Horizontal
          y.domain(data.map(function(d) { return d.letter; }));

          // Vertical
          x.domain([d3.min(data, function(d) { return d.frequency-20; }),d3.max(data, function(d) { return d.frequency; })]);
      //
      //
      //     //
      //     // Append chart elements
      //     //
      //
      //     // Append axes
      //     // ------------------------------
      //
          // Horizontal
          svg.append("g")
              .attr("class", "d3-axis d3-axis-horizontal d3-axis-strong")
              .attr("transform", "translate(0," + height + ")")
              .call(xAxis);

          // Vertical
          var verticalAxis = svg.append("g")
              .attr("class", "d3-axis d3-axis-vertical d3-axis-strong")
              .style("color","yellow")
              .call(yAxis)
              .selectAll("text")
              .style("font-size",12)
              .style("text-transform","capitalize")
   			/* .attr("y", -25)
    		.attr("x", 20)
    		.attr("dy", ".75em")
    		.attr("transform", "rotate(-70)"); */
      //
      //
      //     // Add text label
      //     verticalAxis.append("text")
      //         .attr("transform", "rotate(-90)")
      //         .attr("y", 10)
      //         .attr("dy", ".71em")
      //         .style("text-anchor", "end")
      //         .style("fill", "#999")
      //         .style("font-size", 12)
      //         // .text("Frequency")
      //         ;
      //
      //
      //     // Add bars
       var colorblogs = d3.scale.linear()
	.domain([0,1,2,3,4,5,6,10,15,20])
	.range(["#17394C", "#FFBB78", "#CE0202", "#0080CC", "#72C28E", "#D6A78D", "#FF7E7E", "#666", "#555", "#444"]);

          var transitionbarinfluence = svg.selectAll(".d3-bar")
              .data(data)
              .enter()
              .append("rect")
                  .attr("class", "d3-bar")
                  .attr("y", function(d) { return y(d.letter); })
                  //.attr("height", y.rangeBand())
                  .attr("height", 30)
                  .attr('transform', 'translate(0, '+(y.rangeBand()/2-14.5)+')')
                  .attr("x", function(d) { return 0; })
                  .attr("width", 0)
                  /* .style("fill", function(d) {
                	 
                  maxvalue = d3.max(data, function(d) { return d.frequency; });
                  if(d.frequency == maxvalue)
                  {
                    return "#0080CC";
                    
                  }
                  else
                  {
                    return "#78BCE4";
                  }

                })*/
                .style("fill", function(d,i) {
                    
                     return colorblogs(data.length - i - 1);
                    
                   })
                  .on('mouseover', tip.show)
                  .on('mouseout', tip.hide);
          
          transitionbarinfluence.transition()
          .delay(200)
          .duration(1000)
          .attr("width", function(d) { return x(d.frequency); })
          .attr('transform', 'translate(0, '+(y.rangeBand()/2-14.5)+')');
          
      
        
         /*  svg.append("g")
          .attr("transform", "translate("+x(50)+",0)")
          .append("line")
          .attr("y2", height)
          .style("stroke", "#2ecc71")
          .style("stroke-width", "1px") */


                  // svg.selectAll(".d3-bar")
                  //     .data(data)
                  //     .enter()
                  //     .append("rect")
                  //         .attr("class", "d3-bar")
                  //         .attr("x", function(d) { return x(d.letter); })
                  //         .attr("width", x.rangeBand())
                  //         .attr("y", function(d) { return y(d.frequency); })
                  //         .attr("height", function(d) { return height - y(d.frequency); })
                  //         .style("fill", function(d) { return "#58707E"; })
                  //         .on('mouseover', tip.show)
                  //         .on('mouseout', tip.hide);





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


            // // Layout
            // // -------------------------
            //
            // // Main svg width
            container.attr("width", width + margin.left + margin.right);

            // Width of appended group
            svg.attr("width", width + margin.left + margin.right);
            //
            //
            // // Axes
            // // -------------------------
            //
            // // Horizontal range
           x.range([0,width]);
            //
            // // Horizontal axis
            svg.selectAll('.d3-axis-horizontal').call(xAxis);
             // svg.selectAll('.d3-bar-vertical').call(yAxis);

            //
            // // Chart elements
            // // -------------------------
            //
            // // Line path
           svg.selectAll('.d3-bar').attr("width", function(d) { return x(d.frequency); });
        }
    }
});
</script>

