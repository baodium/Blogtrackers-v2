
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
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
<%@page import="java.net.URI"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
Object date_start = (null == request.getParameter("date_start")) ? "" : request.getParameter("date_start");
Object date_end = (null == request.getParameter("date_end")) ? "" : request.getParameter("date_end");
String mostactiveterm = (null == request.getParameter("term")) ? "" : request.getParameter("term").toString();

Object sort = (null == request.getParameter("sort")) ? "" : request.getParameter("sort");
Object action = (null == request.getParameter("action")) ? "" : request.getParameter("action");
Object id = (null == request.getParameter("id")) ? "" : request.getParameter("id");
Object tid = (null == request.getParameter("tid")) ? "" : request.getParameter("tid");


Trackers tracker  = new Trackers();
Blogposts post  = new Blogposts();
Blogs blog  = new Blogs();

Terms term  = new Terms();
String dt = date_start.toString();
String dte = date_end.toString();
JSONArray termscount = new JSONArray();

JSONObject years = new JSONObject();
JSONArray yearsarray = new JSONArray();


JSONObject termsyears = new JSONObject();

String year_start="";
String year_end="";
		
%>


<%  
if(action.toString().equals("getstats")){	
	String postc =  post._searchTotalAndUnique(mostactiveterm,"date", dt,dte,"blogpost_id");
	String blogc = post._searchTotalAndUnique(mostactiveterm,"date", dt,dte,"blogsite_id");
	String bloggerc = post._searchTotalAndUniqueBlogger(mostactiveterm,"date", dt,dte,"blogger");
	String toplocation = "";
	
    ArrayList allposts =  post._searchByBody(mostactiveterm, dt,dte);
    JSONObject firstpost = new JSONObject();
    JSONObject locations = new JSONObject();
    
    
    if(allposts.size()>0){			
								String tres = null;
								JSONObject tresp = null;
								String tresu = null;
								JSONObject tobj = null;
								
								
								int k=0;
								int tloc = 0;
								for(int i=0; i< allposts.size(); i++){
									tres = allposts.get(i).toString();	
									tresp = new JSONObject(tres);
									
									tresu = tresp.get("_source").toString();
									tobj = new JSONObject(tresu);
									String country = 	blog._getTopLocation(tobj.get("blogsite_id").toString());
									
									if(locations.has(country)){
										int val = Integer.parseInt(locations.get(country).toString());			
										locations.put(country,val);
										if(val>tloc){
											tloc = val;
											toplocation = country;
										}
									}else{
										locations.put(country,1);
									}
									
											
									

                             }					
	}
    
    int keycount = term.getTermOcuurence(mostactiveterm, dt, dte);
	
				
	JSONObject result = new JSONObject();
	result.put("postmentioned",postc);
	result.put("blogmentioned",blogc);
	result.put("bloggermentioned",keycount);
	result.put("toplocation",toplocation);
%>
<%=result.toString()%>
<% }else if(action.toString().equals("gettable")){
	System.out.println("start:"+dt+",End:"+dte); 
%>

<% 
   ArrayList allposts =  post._searchByTitleAndBody(mostactiveterm,"date", dt,dte);//term._searchByRange("date",dt,dte, tm,"term","10");		
%>
          
          
 <div class="row m0 mt20 mb0 d-flex align-items-stretch">
			<div class="col-md-6 mt20 card card-style nobordertopright noborderbottomright" id="post-list">
				<div class="card-body p0 pt20 pb20" style="min-height: 420px;">
					<p>
						Posts that mentioned <b class="text-green active-term"><%=mostactiveterm%></b>
					</p>
					<!--  <div class="p15 pb5 pt0" role="group">
          Export Options
          </div> -->
          <%  
          JSONObject firstpost = new JSONObject();
          if(allposts.size()>0){	%>
					<table id="DataTables_Table_2_wrapper" class="display"
						style="width: 100%">
						<thead>
							<tr>
								<th>Post title</th>
								<th>Occurence</th>
							</tr>
						</thead>
						<tbody>
							<%				
									String tres = null;
									JSONObject tresp = null;
									String tresu = null;
									JSONObject tobj = null;								
									
									int k=0;
									
									for(int i=0; i< allposts.size(); i++){
										tres = allposts.get(i).toString();	
										tresp = new JSONObject(tres);									
										tresu = tresp.get("_source").toString();
										tobj = new JSONObject(tresu);
										
										
												
												//System.out.println("postdet +"+tobj3);
												if(i==0){
													firstpost = tobj;
												}
												
												int bodyoccurencece = 0;//ut.countMatches(tobj3.get("post").toString(), mostactiveterm);
												
										        String str = tobj.get("post").toString()+" "+ tobj.get("post").toString();
												str = str.toLowerCase();
												mostactiveterm = mostactiveterm.toLowerCase();
										        String findStr = mostactiveterm;
												int lastIndex = 0;
												//int count = 0;

												while(lastIndex != -1){

												    lastIndex = str.indexOf(findStr,lastIndex);

												    if(lastIndex != -1){
												        bodyoccurencece++;
												       // alloccurence+=bodyoccurencece;
												        lastIndex += findStr.length();
												    }
												    
												    
												    
												}
									%>
                                    <tr>
                                   <td><a class="blogpost_link cursor-pointer blogpost_link" id="<%=tobj.get("blogpost_id")%>" ><%=tobj.get("title") %></a><br/>
								<a class="mt20 viewpost makeinvisible" href="<%=tobj.get("permalink") %>" target="_blank"><buttton class="btn btn-primary btn-sm mt10 visitpost">Visit Post &nbsp;<i class="fas fa-external-link-alt"></i></buttton></a>
								</td>
								<td align="center"><%=(bodyoccurencece) %></td>
                                     </tr>
                                    <% }%>
							</tr>						
						</tbody>
					</table>
					<% } %>
				</div>

			</div>

			<div class="col-md-6 mt20 card card-style nobordertopleft noborderbottomleft">

				<div style="" class="pt20" id="blogpost_detail">
					<%
                                if(firstpost.length()>0){	
									JSONObject tobj = firstpost;
									String title = tobj.get("title").toString().replaceAll("[^a-zA-Z]", " ");
									String body = tobj.get("post").toString().replaceAll("[^a-zA-Z]", " ");
									String dat = tobj.get("date").toString().substring(0,10);
									LocalDate datee = LocalDate.parse(dat);
									DateTimeFormatter dtf = DateTimeFormatter.ofPattern("MMM dd, yyyy");
									String date = dtf.format(datee);
									String replace = 	"<span style=background:red;color:#fff>"+mostactiveterm+"</span>";
									String link = tobj.get("permalink").toString();
									
									String maindomain="";
									try {
										URI uri = new URI(link);
										String domain = uri.getHost();
										if (domain.startsWith("www.")) {
											maindomain = domain.substring(4);
										} else {
											maindomain = domain;
										}
									} catch (Exception ex) {}
									

									title = title.replaceAll(mostactiveterm,replace);
									String active2 = mostactiveterm.substring(0,1).toUpperCase()+mostactiveterm.substring(1,mostactiveterm.length());
									String active3= mostactiveterm.toUpperCase();
									
									
									title = title.replaceAll(mostactiveterm,replace);
									title = title.replaceAll(active2,replace);
									title = title.replaceAll(active3,replace);
									
									
									body = body.replaceAll(mostactiveterm,replace);
									body = body.replaceAll(active2,replace);
									body = body.replaceAll(active3,replace);
									%>                                    
                                    <h5 class="text-primary p20 pt0 pb0"><%=title%></h5>
										<div class="text-center mb20 mt20">
											<a href="<%=request.getContextPath()%>/bloggerportfolio.jsp?tid=<%=tid.toString()%>&blogger=<%=tobj.get("blogger")%>">
											<button class="btn stylebuttonblue">
												<b class="float-left ultra-bold-text"><%=tobj.get("blogger")%></b> <i
													class="far fa-user float-right blogcontenticon"></i>
											</button>
											</a>
											<button class="btn stylebuttonnocolor nocursor"><%=date %></button>
											<button class="btn stylebuttonnocolor nocursor">
												<b class="float-left ultra-bold-text"><%=tobj.get("num_comments")%> comments</b><i
													class="far fa-comments float-right blogcontenticon"></i>
											</button>
										</div>
										<div style="height: 600px;">
										<div class="p20 pt0 pb20 text-blog-content text-primary"
											style="height: 550px; overflow-y: scroll;">
											<%=body%>
										</div>         
										</div>             
                     		<% } %>

				</div>
				</div>
			</div>
<link rel="stylesheet" href="assets/vendors/DataTables/dataTables.bootstrap4.min.css" />	
<script type="text/javascript" src="assets/vendors/DataTables/datatables.min.js"></script>
 
<script>
			
 $(document).ready(function() {
	 
	 
	$('#printdoc').on('click',function(){
		print();
	}) 
	
		  
		  // datatable setup
		    $('#DataTables_Table_2_wrapper').DataTable( {
		        "scrollY": 480,
		        "scrollX": true,
		         "pagingType": "simple",
		        	 "bLengthChange": false,
		             "order": [[ 1, "desc" ]]
		      /*    ,
		         dom: 'Bfrtip',
		         "columnDefs": [
		      { "width": "80%", "targets": 0 }
		    ],
		      buttons:{
		        buttons: [
		            { extend: 'pdfHtml5',orientation: 'potrait', pageSize: 'LEGAL', className: 'btn-primary stylebutton1'},
		            {extend:'csv',className: 'btn-primary stylebutton1'},
		            {extend:'excel',className: 'btn-primary stylebutton1'},
		           // {extend:'copy',className: 'btn-primary stylebutton1', text: 'Copy to Clipboard'},
		            {extend:'print',className: 'btn-primary stylebutton1'},
		        ]
		      } */
		    } );
	 
 } );
 </script>       		
 	
<%}else{ 

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
					   if(b==0){
							dtu = dt;
						}else if(b==yendint){
							dtue = dte;
						}
					   
					   String totu = post._searchTotalByBody(mostactiveterm,dtu,dtue);//term._searchRangeTotal("date",dtu, dtue,termscount.get(n).toString());
					   
					   if(!years.has(y+"")){
				    		years.put(y+"",y);
				    		yearsarray.put(b,y);
				    		b++;
				    	}
					   //System.out.println("totu here "+totu);
					   postyear.put(y+"",totu);
			}
			termsyears.put(mostactiveterm,postyear);

%>
<div class="chart-container">
		<div class="chart" id="d3-line-basic"></div>
</div>


	<!--end for table  -->	
<script>

 $(function () {

     // Initialize chart
     lineBasic('#d3-line-basic', 200);

     // Chart setup
     function lineBasic(element, height) {


         // Basic setup
         // ------------------------------

         // Define main variables
         var d3Container = d3.select(element),
             margin = {top: 10, right: 10, bottom: 20, left: 50},
             width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right,
             height = height - margin.top - margin.bottom;


         // var formatPercent = d3.format(",.3f");
         // Format data
         // var parseDate = d3.time.format("%d-%b-%y").parse,
         //     bisectDate = d3.bisector(function(d) { return d.date; }).left,
         //     formatValue = d3.format(",.0f"),
         //     formatCurrency = function(d) { return formatValue(d); }



         // Construct scales
         // ------------------------------

         // Horizontal
         var x = d3.scale.ordinal()
             .rangeRoundBands([0, width], .72, .5);

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
  	  		String au = mostactiveterm;//termscount.get(p).toString();
  	  		JSONObject specific_auth= new JSONObject(termsyears.get(au).toString());
  	  %>[<% for(int q=0; q<yearsarray.length(); q++){ 
  		  		String yearr=yearsarray.get(q).toString(); 
  		  		if(specific_auth.has(yearr)){ %>
  		  			{"date":"<%=yearr%>","close":<%=specific_auth.get(yearr)%>},
  			<%
  		  		}else{ %>
  		  			{"date":"<%=yearr%>","close":0},
  	   		<% } %>
  		<%  
  	  		}%>]];

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
                                .append("path")
                                .attr("class", "d3-line d3-line-medium")
                                .attr("d", line)
                                // .style("fill", "rgba(0,0,0,0.54)")
                                .style("stroke-width",2)
                                .style("stroke", "#17394C")
                                 .attr("transform", "translate("+margin.left/4.7+",0)");
                                // .datum(data)

                       // add point
                        circles = svg.selectAll(".circle-point")
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

                              .attr("transform", "translate("+margin.left/4.7+",0)");

                              svg.selectAll(".circle-point").data(data[0])
                              .on("mouseover",tip.show)
                              .on("mouseout",tip.hide)
                              .on("click",function(d){
                            	  //console.log(d.date);
                            	  console.log("Here g"+d.date);
                            	  var d1 = 	  d.date + "-01-01";
                                	 var d2 = 	  d.date + "-12-31";
                      				
                                	  loadTable(d1,d2);	
                            	  
                              });
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
                                  .style("stroke", function(d,i) { return color(i);})
                                  .attr("transform", "translate("+margin.left/4.7+",0)");




                       // add multiple circle points

                           // data.forEach(function(e){
                           // console.log(e)
                           // })

                           // console.log(data);

                              var mergedarray = [].concat(...data);
                               // console.log(mergedarray)
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
                                    	  console.log("Here g"+d.date);
                                    	  var d1 = 	  d.date + "-01-01";
 	                                   	 var d2 = 	  d.date + "-12-31";
 	                         				
 	                                   	  loadTable(d1,d2);	  
                                      });
                                 //                         svg.call(tip)

                               //console.log(newi);


                                     svg.selectAll(".circle-point").data(mergedarray)
                                     .on("mouseover",tip.show)
                                     .on("mouseout",tip.hide)
                                     .on("click",function(d){
                                    	 console.log("Here"+d.date);
                                    	 var d1 = 	  d.date + "-01-01";
	                                   	 var d2 = 	  d.date + "-12-31";
	                         				
	                                   	  loadTable(d1,d2);	
	                                   	  
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




             // Append tooltip
             // -------------------------






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



             svg.selectAll(".circle-point")
             .attr("cx",function(d) { return x(d.date);})
             .attr("cy", function(d){return y(d.close)});


           //
           // // Crosshair
           // svg.selectAll('.d3-crosshair-overlay').attr("width", width);

         }
     }
 });
 </script>
 


<% } %>

	