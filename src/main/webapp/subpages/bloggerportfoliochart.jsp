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

Object sort = (null == request.getParameter("sort")) ? "" : request.getParameter("sort");
Object action = (null == request.getParameter("action")) ? "" : request.getParameter("action");
Object post_ids = (null == request.getParameter("post_ids")) ? "" : request.getParameter("post_ids");



Trackers tracker  = new Trackers();
Blogposts post  = new Blogposts();
Blogs blog  = new Blogs();

Terms term  = new Terms();
		String dt = date_start.toString();
		String dte = date_end.toString();

		
		String selectedblogid=blogger.toString();
		
		JSONObject graphyears = new JSONObject();
	    JSONArray yearsarray = new JSONArray();
	    
	   
	    
		String[] yst = dt.split("-");
		String[] yend = dte.split("-");
		String year_start = yst[0];
		String year_end = yend[0];
		
		String month_start = yst[1];
		String month_end = yend[1];
		
		int ystint = Integer.parseInt(year_start);
		int yendint = Integer.parseInt(year_end);
		
		int b=0;
		int jan=0;
		int feb=0;
		int march=0;
		int apr=0;
		int may=0;
		int june=0;
		int july=0;
		int aug=0;
		int sep=0;
		int oct=0;
		int nov=0;
		int dec=0;
		
	if(!action.toString().equals("getstats")){
		for(int y=ystint; y<=yendint; y++){
				   String dtu = y + "-01-01";

				   String dtue = y + "-12-31";
				   
				   if(b==0){
						dtu = dt;
					}else if(b==yendint){
						dtue = dte;
					}
				   
				   
				   String totu = post._searchRangeTotalByBlogger("date",dtu, dtue,selectedblogid);
				   if(action.toString().equals("getdailychart")){
				   
				   //if(1 >= Integer.parseInt(month_start)){
				   		jan += Integer.parseInt(post._searchRangeTotalByBlogger("date",y + "-01-01", y + "-01-31",selectedblogid));
				   //}
				   
				   //if(2>=Integer.parseInt(month_start) && y>=ystint){
					   feb += Integer.parseInt(post._searchRangeTotalByBlogger("date",y + "-02-01", y + "-02-29",selectedblogid));
				   //}
				   
				   //if(3>=Integer.parseInt(month_start) && y>=ystint){						
				   		march += Integer.parseInt(post._searchRangeTotalByBlogger("date",y + "-03-01", y + "-03-31",selectedblogid));
				   //}
				   
				   //if(4>=Integer.parseInt(month_start) && y>=ystint){						
				   	apr += Integer.parseInt(post._searchRangeTotalByBlogger("date",y + "-04-01", y + "-04-30",selectedblogid));
				   //}
				   
				   //if(5>=Integer.parseInt(month_start) && y>=ystint){							
				  	 may += Integer.parseInt(post._searchRangeTotalByBlogger("date",y + "-05-01", y + "-05-31",selectedblogid));
				   //}
				   
				   //if( 6 >=Integer.parseInt(month_start) && y>=ystint){							
				   	june += Integer.parseInt(post._searchRangeTotalByBlogger("date",y + "-06-01", y + "-06-30",selectedblogid));
				   //}
				  // if(7 >= Integer.parseInt(month_start) && y>=ystint){							
				   	july += Integer.parseInt(post._searchRangeTotalByBlogger("date",y + "-07-01", y + "-07-31",selectedblogid));
				   //}
				   //if(8 >= Integer.parseInt(month_start) && y>=ystint){							
				   	aug += Integer.parseInt(post._searchRangeTotalByBlogger("date",y + "-08-01", y + "-08-31",selectedblogid));
				   //}
				   //if(9 >= Integer.parseInt(month_start) && y>=ystint){					
				   	sep += Integer.parseInt(post._searchRangeTotalByBlogger("date",y + "-09-01", y + "-09-30",selectedblogid));
				  // }
				   //if(10 >= Integer.parseInt(month_start) && y>=ystint){			
				   oct += Integer.parseInt(post._searchRangeTotalByBlogger("date",y + "-10-01", y + "-10-31",selectedblogid));
				   //}
				   //if(11 >= Integer.parseInt(month_start) && y>=ystint){						
				   		nov += Integer.parseInt(post._searchRangeTotalByBlogger("date",y + "-11-01", y + "-11-30",selectedblogid));
				   //}
				   //if(12 >= Integer.parseInt(month_start) && y>=ystint){						
				   	dec += Integer.parseInt(post._searchRangeTotalByBlogger("date",y + "-12-01", y + "-12-31",selectedblogid));
				   //}
				   }
				   graphyears.put(y+"",totu);
		    	   yearsarray.put(b,y);	
		    	   b++;
		}
		
	    }

	JSONArray sortedyearsarray = yearsarray;
%>

<%  
if(action.toString().equals("getstats")){	
	JSONArray sentimentpost = new JSONArray();
	ArrayList allauthors = post._getBloggerByBloggerName("date", dt, dte, selectedblogid, "influence_score", "DESC");
	String blogids = "";
	if(allauthors.size()>0){
		String tres = null;
		JSONObject tresp = null;
		String tresu = null;
		JSONObject tobj = null;
		int j=0;
		int k=0;
		int n = 0;
		
		for(int i=0; i< allauthors.size(); i++){
					tres = allauthors.get(i).toString();			
					tresp = new JSONObject(tres);
				    tresu = tresp.get("_source").toString();
				    tobj = new JSONObject(tresu);
				    blogids+=tobj.get("blogsite_id").toString()+",";
				    sentimentpost.put(tobj.get("blogpost_id").toString());
			}
	} 
	
	String totalpost = post._searchRangeTotalByBlogger("date", date_start.toString(), date_end.toString(), selectedblogid);
	
	//String totalinfluence = post._searchRangeAggregateByBloggers("date", dt, dte, selectedblogid);	
	Double influence =  Double.parseDouble(post._searchRangeMaxByBloggers("date",dt, dte,blogger.toString()));
	String totalinfluence = influence+"";
	
	String possentiment=new Liwc()._searchRangeAggregate("date", date_start.toString(), date_end.toString(), sentimentpost,"posemo");
	String negsentiment=new Liwc()._searchRangeAggregate("date", date_start.toString(), date_end.toString(), sentimentpost,"negemo");
	
	int comb = Integer.parseInt(possentiment)+Integer.parseInt(negsentiment);
	String mostactiveterm = "";

	int highestfrequency = 0; 
	 
	ArrayList termss =  term._searchByRange("blogsiteid", dt, dte, blogids);
	JSONArray topterms = new JSONArray();
	if (termss.size() > 0) {
		for (int p = 0; p < termss.size(); p++) {
			String bstr = termss.get(p).toString();
			JSONObject bj = new JSONObject(bstr);
			bstr = bj.get("_source").toString();
			bj = new JSONObject(bstr);
			String frequency = bj.get("frequency").toString();
			String tm = bj.get("term").toString();
			JSONObject cont = new JSONObject();
			
			int freq = Integer.parseInt(frequency);
			
			String blogpostid = bj.get("blogpostid").toString();
			
			if(freq>highestfrequency){
				highestfrequency = freq;
				mostactiveterm = tm;
			}		
			
			cont.put("key", tm);
			cont.put("frequency", frequency);
			topterms.put(cont);
		}
	}
	
	JSONObject result = new JSONObject();
	result.put("totalpost",totalpost);
	result.put("totalsentiment",comb);
	result.put("totalinfluence",totalpost);
	result.put("topterm",mostactiveterm);
%>
<%=result.toString()%>
<% } else if(action.toString().equals("getdayonlychart")){ 
	SimpleDateFormat DAY_NAME_ONLY = new SimpleDateFormat("EEEE");
	
	ArrayList allauthors = post._getBloggerByBloggerName("date", dt, dte, selectedblogid, "influence_score", "DESC");
	String blogids = "";
	int sun=0;
    int mon=0;
    int tue=0;
    int wed =0;
    int thur =0;
    int fri=0;
    int sat =0;
    
	if(allauthors.size()>0){
		String tres = null;
		JSONObject tresp = null;
		String tresu = null;
		JSONObject tobj = null;
		int j=0;
		int k=0;
		int n = 0;
		
		for(int i=0; i< allauthors.size(); i++){
					tres = allauthors.get(i).toString();			
					tresp = new JSONObject(tres);
				    tresu = tresp.get("_source").toString();
				    tobj = new JSONObject(tresu);
				    
				    Date rawdaydate = new SimpleDateFormat("yyyy-mm-dd").parse(tobj.get("date").toString());
				    String rawday = DAY_NAME_ONLY.format(rawdaydate);
				   
				    if(rawday.equals("Sunday")){
				    	sun++;
				    }else if(rawday.equals("Monday")){
				    	mon++;
				    }else if(rawday.equals("Tuesday")){
				    	tue++;
				    }else if(rawday.equals("Wednesday")){
				    	wed++;
				    }else if(rawday.equals("Thursday")){
				    	thur++;
				    }else if(rawday.equals("Friday")){
				    	fri++;
				    }else if(rawday.equals("Saturday")){
				    	sat++;
				    }
		}
	} 
	
%>
  <div class="chart" id="d3-bar-horizontal"></div>
<!--  <script type="text/javascript" src="assets/vendors/d3/d3.min.js"></script>
 <script type="text/javascript" src="assets/vendors/d3/d3_tooltip.js"></script> -->
 
<script>
 $(function () {

     // Initialize chart
     barHorizontal('#d3-bar-horizontal', 390);

     // Chart setup
     function barHorizontal(element, height) {

       // Basic setup
       // ------------------------------

       // Define main variables
       var d3Container = d3.select(element),
           margin = {top: 5, right: 50, bottom: 20, left: 70},
           width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right,
           height = height - margin.top - margin.bottom - 5;

          var formatPercent = d3.format("");

       // Construct scales
       // ------------------------------

       // Horizontal
       var y = d3.scale.ordinal()
           .rangeRoundBands([height,0], .02, .7);

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
       //
       data = [
    	   {letter:"Sat", frequency:<%=sat%>},
    	   {letter:"Fri", frequency:<%=fri%>},
             {letter:"Wed", frequency:<%=wed%>},
             {letter:"Thu", frequency:<%=thur%>},
             {letter:"Tue", frequency:<%=tue%>},
             {letter:"Mon", frequency:<%=mon%>},
             {letter:"Sun", frequency:<%=sun%>}
                     
         ];
       //
       //
       //   // Create tooltip
         var tip = d3.tip()
                .attr('class', 'd3-tip')
                .offset([-10, 0])
                .html(function(d) {
                    return d.letter+" ("+d.frequency+")";
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
           x.domain([0,d3.max(data, function(d) { return d.frequency; })]);
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
               .call(yAxis);
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
           svg.selectAll(".d3-bar")
               .data(data)
               .enter()
               .append("rect")
                   .attr("class", "d3-bar")
                   .attr("y", function(d) { return y(d.letter); })
                   //.attr("height", y.rangeBand())
                   .attr("height",30)
                   .attr("x", function(d) { return 0; })
                   .attr("width", function(d) { return x(d.frequency); })
                   .attr('transform', 'translate(0, '+(y.rangeBand()/2-14.5)+')')
                   .style("fill", function(d) {
                   maxvalue = d3.max(data, function(d) { return d.frequency; });
                   if(d.frequency == maxvalue)
                   {
                     return "#0080CC";
                   }
                   else
                   {
                     return "#78BCE4";
                   }

                 })
                   .on('mouseover', tip.show)
                   .on('mouseout', tip.hide);


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

	
<% }else if(action.toString().equals("getdailychart")){ %>
 <div class="chart" id="yearlypattern"></div>
 
 <!-- <script type="text/javascript" src="assets/vendors/d3/d3.min.js"></script>
 <script type="text/javascript" src="assets/vendors/d3/d3_tooltip.js"></script> -->
 
 <!-- Yearly patterns  -->
 <script>
 $(function () {

     // Initialize chart
     yearlypattern('#yearlypattern', 385);

     // Chart setup
     function yearlypattern(element, height) {


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

 // data = [
 //   [{"date":"2016","close":1300},{"date":"2017","close":1700},{"date":"2018","close":2100}],
 //   [{"date":"2016","close":1500},{"date":"2017","close":1800}],
 //   [{"date":"2014","close":500},{"date":"2015","close":900},{"date":"2016","close":1200}]
 // ];

 // data = [[
 //
 //  {
 //    "date": "2015",
 //    "close": 500
 //  },
 //  {
 //    "date": "2016",
 //    "close": 100
 //  },
 //  {
 //    "date": "2017",
 //    "close": 300
 //  },
 //  {
 //    "date": "2018",
 //    "close": 500
 //  }
 // ]];

 //console.log(data);
 // data = [];

 data = [
 [{"date": "Jan","close": <%=jan%>},{"date": "Feb","close": <%=feb%>},{"date": "Mar","close":<%=march%>},{"date": "Apr","close": <%=jan%>},{"date": "May","close": <%=may%>},{"date": "Jun","close": <%=june%>},{"date": "Jul","close": <%=july%>},{"date": "Aug","close": <%=aug%>},{"date": "Sep","close": <%=sep%>},{"date": "Oct","close": <%=oct%>},{"date": "Nov","close": <%=nov%>},{"date": "Dec","close": <%=dec%>}],
 ];

 // console.log(data);
 var line = d3.svg.line()
 .interpolate("monotone")
      //.attr("width", x.rangeBand())
     .x(function(d) { return x(d.date); })
     .y(function(d) { return y(d.close); });
     // .x(function(d){d.forEach(function(e){return x(d.date);})})
     // .y(function(d){d.forEach(function(e){return y(d.close);})});



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
                        .style("stroke", "#0080CC")
                         //.attr("transform", "translate("+margin.left/4.7+",0)");
                        // .datum(data)

               // add point
                circles = svg.append("g").attr("class","circlecontainer").selectAll(".circle-point")
                          .data(data[0])
                          .enter();


                      circles
                      // .enter()
                      .append("circle")
                      .attr("class","circle-point")
                      .attr("r",3.4)
                      .style("stroke", "#0080CC")
                      .style("fill","#0080CC")
                      .attr("cx",function(d) { return x(d.date); })
                      .attr("cy", function(d){return y(d.close)})

                      //.attr("transform", "translate("+margin.left/4.7+",0)");



                      svg.selectAll(".circle-point").data(data[0])
                      .on("mouseover",tip.show)
                      .on("mouseout",tip.hide)
                      .on("click",function(d){console.log(d.date)});
                                         svg.call(tip)
                                         
                       
              }
              // handles multiple json parameter
              else if(data.length > 1)
              {
                // add multiple line

                var path = svg.selectAll('.d3-line')
                          .data(data)
                          .enter()
                          .append("path")
                          .attr("class", "d3-line d3-line-medium")
                          .attr("d", line)
                          // .style("fill", "rgba(0,0,0,0.54)")
                          .style("stroke-width", 2)
                          .style("stroke", "17394C")
                          .attr("transform", "translate("+margin.left/4.7+",0)");




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
                              .on("click",function(d){console.log(d.date)});
                         //                         svg.call(tip)

                       //console.log(newi);


                             svg.selectAll(".circle-point").data(mergedarray)
                             .on("mouseover",tip.show)
                             .on("mouseout",tip.hide)
                             .on("click",function(d){console.log(d.date)});
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
             // Crosshair
             //svg.selectAll('.d3-crosshair-overlay').attr("width", width);
         }
     }
 });


 </script>
 

<% }else{ %>

		 <div class="chart" id="d3-line-basic"></div>

	
 <script>

 $(function () {

     // Initialize chart
     lineBasic('#d3-line-basic', 400);

     // Chart setup
     function lineBasic(element, height) {


         // Basic setup
         // ------------------------------

         // Define main variables
         var d3Container = d3.select(element),
             margin = {top: 10, right: 10, bottom: 20, left: 30},
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

 // data = [
 //   [{"date":"2016","close":1300},{"date":"2017","close":1700},{"date":"2018","close":2100}],
 //   [{"date":"2016","close":1500},{"date":"2017","close":1800}],
 //   [{"date":"2014","close":500},{"date":"2015","close":900},{"date":"2016","close":1200}]
 // ];

 data = [[<% for(int q=0; q<sortedyearsarray.length(); q++){ 
	  		String yer=sortedyearsarray.get(q).toString(); 
	  		int vlue = Integer.parseInt(graphyears.get(yer).toString()); %>
	  			{"date":"<%=yer%>","close":<%=vlue%>},
	<% } %>]];

 //console.log(data);
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
                        .style("stroke", "#0080CC")

               // add point
                circles = svg.append("g").attr("class","circlecontainer").selectAll(".circle-point")
                          .data(data[0])
                          .enter();


                      circles
                      .append("circle")
                      .attr("class","circle-point")
                      .attr("r",3.4)
                      .style("stroke", "#0080CC")
                      .style("fill","#0080CC")
                      .attr("cx",function(d) { return x(d.date); })
                      .attr("cy", function(d){return y(d.close)})

                     /*  .attr("transform", "translate("+margin.left/4.7+",0)"); */



                      svg.selectAll(".circle-point").data(data[0])
                      .on("mouseover",tip.show)
                      .on("mouseout",tip.hide)
                      .on("click",function(d){console.log(d.date)});
                                         svg.call(tip)
              }
              // handles multiple json parameter
              else if(data.length > 1)
              {
                // add multiple line

                var path = svg.selectAll('.d3-line')
                          .data(data)
                          .enter()
                          .append("path")
                          .attr("class", "d3-line d3-line-medium")
                          .attr("d", line)
                          // .style("fill", "rgba(0,0,0,0.54)")
                          .style("stroke-width", 2)
                          .style("stroke", "17394C")
                          /* .attr("transform", "translate("+margin.left/4.7+",0)"); */




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

                               /* .attr("transform", "translate("+margin.left/4.7+",0)"); */
                               svg.selectAll(".circle-point").data(mergedarray)
                              .on("mouseover",tip.show)
                              .on("mouseout",tip.hide)
                              .on("click",function(d){console.log(d.date)});
                         //                         svg.call(tip)

                       //console.log(newi);


                             svg.selectAll(".circle-point").data(mergedarray)
                             .on("mouseover",tip.show)
                             .on("mouseout",tip.hide)
                             .on("click",function(d){console.log(d.date)});
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
             // Crosshair
             //svg.selectAll('.d3-crosshair-overlay').attr("width", width);
         }
     }
 });
 </script>

<% } %>

	