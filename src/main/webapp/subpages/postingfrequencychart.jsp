<%@page import="authentication.*"%>
<%@page import="java.util.*"%>
<%@page import="util.*"%>
<%@page import="java.io.File"%>
<%@page import="util.Blogposts"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
Object date_start = (null == request.getParameter("date_start")) ? "" : request.getParameter("date_start");
Object date_end = (null == request.getParameter("date_end")) ? "" : request.getParameter("date_end");
Object blogger = (null == request.getParameter("blogger")) ? "" : request.getParameter("blogger");
Object blog_id = (null == request.getParameter("blog_id")) ? "" : request.getParameter("blog_id");

Object sort = (null == request.getParameter("sort")) ? "" : request.getParameter("sort");

String bloggerstr = blogger.toString().replaceAll("_"," ");

Trackers tracker  = new Trackers();
Blogposts post  = new Blogposts();
Blogs blog  = new Blogs();
		String dt = date_start.toString();
		String dte = date_end.toString();
		String year_start="";
		String year_end="";		
		
		JSONObject authoryears = new JSONObject();
		JSONObject years = new JSONObject();
		JSONArray yearsarray = new JSONArray();
		String[] yst = dt.split("-");
		String[] yend = dte.split("-");
		year_start = yst[0];
		year_end = yend[0];
		int ystint = Integer.parseInt(year_start);
		int yendint = Integer.parseInt(year_end);
		
				int b=0;
				JSONObject postyear =new JSONObject();
				for(int y=ystint; y<=yendint; y++){ 
						   String dtu = y + "-01-01";
						   String dtue = y + "-12-31";
						   String totu = "0";
						   if(b==0){
								dtu = dt;
							}else if(b==yendint){
								dtue = dte;
							}
						   
						   //if(sort.toString().equals("influence_score")){
							
						   	 totu = post._searchRangeTotalByBlogger("date",dtu, dtue,blogger.toString());
						   //}
						   
						   if(!years.has(y+"")){
					    		years.put(y+"",y);
					    		yearsarray.put(b,y);
					    		b++;
					    	}
						   
						   postyear.put(y+"",totu);
				}
				authoryears.put(bloggerstr,postyear);
%>
<div class="chart-container">
		  <div class="chart" id="d3-line-basic"></div>
		</div>	
<script type="text/javascript" src="assets/vendors/d3/d3_tooltip.js"></script>
 <script>
  $(function () {
      // Initialize chart
      lineBasic('#d3-line-basic', 235);
      // Chart setup
      function lineBasic(element, height) {
          // Basic setup
          // ------------------------------
          // Define main variables
          var d3Container = d3.select(element),
              margin = {top: 10, right: 10, bottom: 20, left: 50},
              width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right,
              height = height - margin.top - margin.bottom;
          var formatPercent = d3.format("");
          // Format data
          // var parseDate = d3.time.format("%d-%b-%y").parse,
          //     bisectDate = d3.bisector(function(d) { return d.date; }).left,
          //     formatValue = d3.format(",.0f"),
          //     formatCurrency = function(d) { return formatValue(d); }
          // Construct scales
          // ------------------------------
          // Horizontal
          var x = d3.scale.ordinal()
              .rangeRoundBands([0, width]);
          // Vertical
          var y = d3.scale.linear()
              .range([height, 0]);
          // Create axes
          // ------------------------------
          // Horizontal
          var xAxis = d3.svg.axis()
              .scale(x)
              .orient("bottom")
             .ticks(9)
            // .tickFormat(formatPercent);
          // Vertical
          var yAxis = d3.svg.axis()
              .scale(y)
              .orient("left")
              .ticks(6);
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
          // Construct chart layout
          // ------------------------------
          // Line
          // Load data
          // ------------------------------
  // data = [[{"date": "Jan","close": 120},{"date": "Feb","close": 140},{"date": "Mar","close":160},{"date": "Apr","close": 180},{"date": "May","close": 200},{"date": "Jun","close": 220},{"date": "Jul","close": 240},{"date": "Aug","close": 260},{"date": "Sep","close": 280},{"date": "Oct","close": 300},{"date": "Nov","close": 320},{"date": "Dec","close": 340}],
  // [{"date":"Jan","close":10},{"date":"Feb","close":20},{"date":"Mar","close":30},{"date": "Apr","close": 40},{"date": "May","close": 50},{"date": "Jun","close": 60},{"date": "Jul","close": 70},{"date": "Aug","close": 80},{"date": "Sep","close": 90},{"date": "Oct","close": 100},{"date": "Nov","close": 120},{"date": "Dec","close": 140}],
  // ];
  data = [<% 
	  		String au = bloggerstr;
	  		JSONObject specific_auth= new JSONObject(authoryears.get(au).toString());
	  %>[<% for(int q=0; q<yearsarray.length(); q++){ 
		  		String yearr=yearsarray.get(q).toString(); 
		  		if(specific_auth.has(yearr)){ %>
		  			{"date":"<%=yearr%>","close":<%=specific_auth.get(yearr) %>},
			<%
		  		}else{ %>
		  			{"date":"<%=yearr%>","close":0},
	   		<% } %>
		<%  
	  		}%>]
	  ];
  console.log(data);
 // console.log(data2);
  // data = [];
  // data = [
  // [
  //   {
  //     "date": "Jan",
  //     "close": 1000
  //   },
  //   {
  //     "date": "Feb",
  //     "close": 1800
  //   },
  //   {
  //     "date": "Mar",
  //     "close": 1600
  //   },
  //   {
  //     "date": "Apr",
  //     "close": 1400
  //   },
  //   {
  //     "date": "May",
  //     "close": 2500
  //   },
  //   {
  //     "date": "Jun",
  //     "close": 500
  //   },
  //   {
  //     "date": "Jul",
  //     "close": 100
  //   },
  //   {
  //     "date": "Aug",
  //     "close": 500
  //   },
  //   {
  //     "date": "Sep",
  //     "close": 2300
  //   },
  //   {
  //     "date": "Oct",
  //     "close": 1500
  //   },
  //   {
  //     "date": "Nov",
  //     "close": 1900
  //   },
  //   {
  //     "date": "Dec",
  //     "close": 4170
  //   }
  // ]
  // ];
  // console.log(data);
  var line = d3.svg.line()
  .interpolate("monotone")
       //.attr("width", x.rangeBand())
      .x(function(d) { return x(d.date); })
      .y(function(d) { return y(d.close); });
      // .x(function(d){d.forEach(function(e){return x(d.date);})})
      // .y(function(d){d.forEach(function(e){return y(d.close);})});
 var circles;
  // Create tooltip
  var tip = d3.tip()
         .attr('class', 'd3-tip')
         .offset([-10, 0])
         .html(function(d) {
         if(d === null)
         {
           return "No Information Available";
         }
         else if(d !== null) {
          return d.date+" ("+d.close+")<br/> Click for more information";
           }
         // return "here";
         });
     // Initialize tooltip
     //svg.call(tip);
    // Pull out values
    // data.forEach(function(d) {
    //     d.frequency = +d.close;
    //
    // });
              // Pull out values
              // data.forEach(function(d) {
              //     // d.date = parseDate(d.date);
              //     //d.date = +d.date;
              //     //d.date = d.date;
              //     d.close = +d.close;
              // });
              // Sort data
              // data.sort(function(a, b) {
              //     return a.date - b.date;
              // });
              // Set input domains
              // ------------------------------
              // Horizontal
    //  console.log(data[0])
            // Vertical
  // extract max value from list of json object
  // console.log(data.length)
      var maxvalue =
      data.map(function(d){
        var mvalue = [];
        if(data.length > 1)
      {
        d.forEach(function(f,i){
        mvalue[i] = f.close;
        })
      return d3.max(mvalue);
      }
      //console.log(mvalue);
      });
  ////console.log(data)
  if(data.length == 1)
  {
    var returnedvalue = data[0].map(function(e){
    return e.date
    });
  // for single json data
  x.domain(returnedvalue);
  // rewrite x domain
  var maxvalue2 =
  data.map(function(d){
  return d3.max(d,function(t){return t.close});
  });
  y.domain([0,maxvalue2]);
  }
  else if(data.length > 1)
  {
  //console.log(data.length);
  //console.log(data);
  var returnedata = data.map(function(e){
  // console.log(k)
  var all = []
  e.forEach(function(f,i){
  all[i] = f.date;
  //console.log(all[i])
  })
  return all
  //console.log(all);
  });
  // console.log(returnedata);
  // combines all the array
  var newArr = returnedata.reduce((result,current) => {
  return result.concat(current);
  });
  //console.log(newArr);
  var set = new Set(newArr);
  var filteredArray = Array.from(set);
  //console.log(filteredArray.sort());
  // console.log(returnedata);
  x.domain(filteredArray);
  y.domain([0, d3.max(maxvalue)]);
  }
              //
              // Append chart elements
              //
  // svg.call(tip);
               // data.map(function(d){})
               if(data.length == 1)
               {
                 // Add line
               var path = svg.selectAll('.d3-line')
                         .data(data)
                         .enter()
                         .append("g")
                                .attr("class","linecontainer")
                         .append("path")
                         .attr("class", "d3-line d3-line-medium")
                         .attr("d", line)
                         // .style("fill", "rgba(0,0,0,0.54)")
                         .style("stroke-width", 2)
                         .style("stroke", "#17394C")
                          //.attr("transform", "translate("+margin.left/4.7+",0)");
                         // .datum(data)
                // add point
                 circles = svg.append("g").attr("class","circlecontainer")
                 			.selectAll(".circle-point")
                           .data(data[0])
                           .enter();
                       circles
                       // .enter()
                       .append("circle")
                       .attr("class","circle-point")
                       .attr("r",3.4)
                       .style("stroke", "#4CAF50")
                       .style("fill","#4CAF50")
                       .attr("cx",function(d) { return x(d.date); })
                       .attr("cy", function(d){return y(d.close)})
                       //.attr("transform", "translate("+margin.left/4.7+",0)");
                       svg.selectAll(".circle-point").data(data[0])
                       .on("mouseover",tip.show)
                       .on("mouseout",tip.hide)
                       .on("click",function(d){
                    	   console.log(d.date);
                    	   var d1 = 	  d.date + "-01-01";
                    	   var d2 = 	  d.date + "-12-31";
           				
                    	   loadInfluence(d1,d2);
                    	   
                       });
                                          svg.call(tip)
               }
               // handles multiple json parameter
               else if(data.length > 1)
               {
                 // add multiple line
                 // var color = d3.scale.category20();
                 var path = svg.selectAll('.d3-line')
                           .data(data)
                           .enter()
                           .append("path")
                           .attr("class", "d3-line d3-line-medium")
                           .attr("d", line)
                           // .style("fill", "rgba(0,0,0,0.54)")
                           .style("stroke-width", 2)
                           .style("stroke", function(d,i) { return color(i);})
                           //.attr("transform", "translate("+margin.left/4.7+",0)");
                // add multiple circle points
                    // data.forEach(function(e){
                    // console.log(e)
                    // })
                    console.log(data);
                       var mergedarray = [].concat(...data);
                        console.log(mergedarray)
                          circles = svg.selectAll(".circle-point")
                              .data(mergedarray)
                              .enter();
                                circles
                                // .enter()
                                .append("circle")
                                .attr("class","circle-point")
                                .attr("r",3.4)
                                .style("stroke", "#4CAF50")
                                .style("fill","#4CAF50")
                                .attr("cx",function(d) { return x(d.date)})
                                .attr("cy", function(d){return y(d.close)})
                                .attr("transform", "translate("+margin.left/4.7+",0)");
                                svg.selectAll(".circle-point").data(mergedarray)
                               .on("mouseover",tip.show)
                               .on("mouseout",tip.hide)
                               .on("click",function(d){
                            	   console.log(d.date)
                            	   var d1 = 	  d.date + "-01-01";
                            	   var d2 = 	  d.date + "-12-31";
                   				
                            	   loadInfluence(d1,d2);   
                               });
                          //                         svg.call(tip)
                        //console.log(newi);
                              svg.selectAll(".circle-point").data(mergedarray)
                              .on("mouseover",tip.show)
                              .on("mouseout",tip.hide)
                              .on("click",function(d){
                            	  console.log(d.date)
                            	  var d1 = 	  d.date + "-01-01";
                           	   	  var d2 = 	  d.date + "-12-31";
                  				
                           	   	  loadInfluence(d1,d2);
                            	  
                              });
                                                 svg.call(tip)
               }
  // show data tip
              // Append axes
              // ------------------------------
              // Horizontal
              svg.append("g")
                  .attr("class", "d3-axis d3-axis-horizontal d3-axis-strong")
                  .attr("transform", "translate(0," + height + ")")
                  .call(xAxis);
              // Vertical
              var verticalAxis = svg.append("g")
                  .attr("class", "d3-axis d3-axis-vertical d3-axis-strong")
                  .call(yAxis);
              // Add text label
              verticalAxis.append("text")
                  .attr("transform", "rotate(-90)")
                  .attr("y", 10)
                  .attr("dy", ".71em")
                  .style("text-anchor", "end")
                  .style("fill", "#999")
                  .style("font-size", 12)
                  // .text("Frequency")
                  ;
              if(data.length == 1 )
         	 {
         	 var tick = svg.select(".d3-axis-horizontal").select(".tick");
         	 var transformfirsttick;
         	 //transformfirsttick =  tick[0][0].attributes[2].value;
             //console.log(tick[0][0].attributes[2]);
             //transformfirsttick = "translate(31.5,0)"
             //console.log(tick[0][0]);
             // handle based on browser
             var browser = "";
             c = navigator.userAgent.search("Chrome");
             f = navigator.userAgent.search("Firefox");
             m8 = navigator.userAgent.search("MSIE 8.0");
             m9 = navigator.userAgent.search("MSIE 9.0");
             if (c > -1) {
                 browser = "Chrome";
                 // chrome browser
             transformfirsttick =  tick[0][0].attributes[1].value;

             } else if (f > -1) {
                 browser = "Firefox";
                  // firefox browser
              transformfirsttick =  tick[0][0].attributes[2].value;
             } else if (m9 > -1) {
                 browser ="MSIE 9.0";
             } else if (m8 > -1) {
                 browser ="MSIE 8.0";
             }
             
             svg.select(".circlecontainer").attr("transform", transformfirsttick);
             svg.select(".linecontainer").attr("transform", transformfirsttick);
             
             
             
             //console.log(browser);
             
         	 }
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
             x.rangeRoundBands([0, width],.72,.5);
             //
             // // Horizontal axis
             svg.selectAll('.d3-axis-horizontal').call(xAxis);
             //
             //
             // // Chart elements
             // // -------------------------
             //
             // // Line path
             svg.selectAll('.d3-line').attr("d", line);
             if(data.length == 1)
             {
               svg.selectAll(".circle-point").attr("circle",circles)
               .attr("cx",function(d) { return x(d.date);})
               .attr("cy", function(d){return y(d.close)});
             }
             else if(data.length > 1)
             {
               svg.selectAll(".circle-point").attr("circle",circles)
               .attr("cx",function(d) { return x(d.date);})
               .attr("cy", function(d){return y(d.close)});
             }
             if(data.length == 1 )
        	 {
        	 var tick = svg.select(".d3-axis-horizontal").select(".tick");
        	 var transformfirsttick;
        	 //transformfirsttick =  tick[0][0].attributes[2].value;
            //console.log(tick[0][0].attributes[2]);
            //transformfirsttick = "translate(31.5,0)"
            //console.log(tick[0][0]);
            // handle based on browser
            var browser = "";
            c = navigator.userAgent.search("Chrome");
            f = navigator.userAgent.search("Firefox");
            m8 = navigator.userAgent.search("MSIE 8.0");
            m9 = navigator.userAgent.search("MSIE 9.0");
            if (c > -1) {
                browser = "Chrome";
                // chrome browser
            transformfirsttick =  tick[0][0].attributes[1].value;

            } else if (f > -1) {
                browser = "Firefox";
                 // firefox browser
             transformfirsttick =  tick[0][0].attributes[2].value;
            } else if (m9 > -1) {
                browser ="MSIE 9.0";
            } else if (m8 > -1) {
                browser ="MSIE 8.0";
            }
            
            svg.select(".circlecontainer").attr("transform", transformfirsttick);
            svg.select(".linecontainer").attr("transform", transformfirsttick);
            
            
            
            //console.log(browser);
            
        	 }
             //
             // // Crosshair
             // svg.selectAll('.d3-crosshair-overlay').attr("width", width);
         }
     }
 });
 </script>