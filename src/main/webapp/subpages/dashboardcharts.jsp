<%@page import="java.io.PrintWriter"%>
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
<%@page import="java.io.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	Object date_start = (null == request.getParameter("date_start")) ? "" : request.getParameter("date_start");
Object date_end = (null == request.getParameter("date_end")) ? "" : request.getParameter("date_end");
Object blogger = (null == request.getParameter("blogger")) ? "" : request.getParameter("blogger");

Object all_bloggers = (null == request.getParameter("all_bloggers")) ? "" : request.getParameter("all_bloggers");

Object sort = (null == request.getParameter("sort")) ? "" : request.getParameter("sort");
Object action = (null == request.getParameter("action")) ? "" : request.getParameter("action");
Object post_ids = (null == request.getParameter("post_ids")) ? "" : request.getParameter("post_ids");
Object ids = (null == request.getParameter("ids")) ? "" : request.getParameter("ids");
String tid = (null == request.getParameter("tid")) ? "" : request.getParameter("tid");

String action_type = (null == request.getParameter("action_type")) ? "" : request.getParameter("action_type");

String[] array = ids.toString().split(",");
String blog_ids = "";
for (String x : array) {
	blog_ids += "\"" + x + "\",";
}
int length = blog_ids.length();
blog_ids = blog_ids.substring(0, length - 1);


PrintWriter out_ = response.getWriter();

Trackers tracker = new Trackers();
Blogposts post = new Blogposts();
Blogs blog = new Blogs();

Dashboard d  = new Dashboard(ids.toString(), date_start.toString(), date_end.toString());

Terms term = new Terms();
ArrayList<scala.Tuple2<String, scala.Tuple2<String, Integer>>> top_location = new ArrayList<>();
JSONObject elastic_query = new JSONObject();
JSONObject myResponse = new JSONObject();
JSONArray rows = new JSONArray();
/* post._getGetDateAggregate("NOBLOGGER","date","yyyy","post","1y","date_histogram", date_start.toString(), date_end.toString(), blog_ids);

post._getGetDateAggregate("NOBLOGGER","date","MMM","post","month","date_histogram", dt, dte, blog_id.toString());
post._getGetDateAggregate("NOBLOGGER","date","yyyy","post","1y","date_histogram", dt, dte, blog_id.toString());
post._getGetDateAggregate("NOBLOGGER","date","E","post","day","date_histogram", dt, dte, blog_id.toString());
post._getGetDateAggregate("NOBLOGGER","date","MMM","post","month","date_histogram", dt, dte, blog_id.toString()); */
%>


<%
	if (action.toString().equals("getkeyworddashboard")) {

	String dashboardterms = null;
	dashboardterms = Terms.getTopTerms("blogsiteid", blog_ids, date_start.toString(), date_end.toString(), "100");
%>

<%-- //<%=result.toString()%> --%>
<div class="chart-container">
	<div class="chart" id="tagcloudcontainer" asertain="nerc"></div>
	<div class="jvectormap-zoomin zoombutton" id="zoom_in">+</div>
	<div class="jvectormap-zoomout zoombutton" id="zoom_out">−</div>
</div>

<script type="text/javascript" src="assets/vendors/d3/d3.min.js"></script>
<script src="assets/vendors/wordcloud/d3.layout.cloud.js"></script>
<script type="text/javascript" src="assets/vendors/d3/d3_tooltip.js"></script>
<script type="text/javascript" src="assets/js/jquery.inview.js"></script>
<script type="text/javascript" src="chartdependencies/keywordtrendd3.js"></script>

<script>
 /*
     var frequency_list = [{"text":"study","size":40},{"text":"motion","size":15},{"text":"forces","size":10},{"text":"electricity","size":15},{"text":"movement","size":10},{"text":"relation","size":5},{"text":"things","size":10},{"text":"force","size":5},{"text":"ad","size":5},{"text":"energy","size":85},{"text":"living","size":5},{"text":"nonliving","size":5},{"text":"laws","size":15},{"text":"speed","size":45},{"text":"velocity","size":30},{"text":"define","size":5},{"text":"constraints","size":5},{"text":"universe","size":10},{"text":"distinguished","size":5},{"text":"chemistry","size":5},{"text":"biology","size":5},{"text":"includes","size":5},{"text":"radiation","size":5},{"text":"sound","size":5},{"text":"structure","size":5},{"text":"atoms","size":5},{"text":"including","size":10},{"text":"atomic","size":10},{"text":"nuclear","size":10},{"text":"cryogenics","size":10},{"text":"solid-state","size":10},{"text":"particle","size":10},{"text":"plasma","size":10},{"text":"deals","size":5},{"text":"merriam-webster","size":5},{"text":"dictionary","size":10},{"text":"analysis","size":5},{"text":"conducted","size":5},{"text":"order","size":5},{"text":"understand","size":5},{"text":"behaves","size":5},{"text":"en","size":5},{"text":"wikipedia","size":5},{"text":"wiki","size":5},{"text":"physics-","size":5},{"text":"physical","size":5},{"text":"behaviour","size":5},{"text":"collinsdictionary","size":5},{"text":"english","size":5},{"text":"time","size":35},{"text":"distance","size":35},{"text":"wheels","size":5},{"text":"revelations","size":5},{"text":"minute","size":5},{"text":"acceleration","size":20},{"text":"torque","size":5},{"text":"wheel","size":5},{"text":"rotations","size":5},{"text":"resistance","size":5},{"text":"momentum","size":5},{"text":"measure","size":10},{"text":"direction","size":10},{"text":"car","size":5},{"text":"add","size":5},{"text":"traveled","size":5},{"text":"weight","size":5},{"text":"electrical","size":5},{"text":"power","size":5}];
*/

var terms = <%=dashboardterms.toString()%>
var jsonresult = {}
var currenttuple = null;
var currentkey = null;
var currentvalue = null;
for(var i = 0; i < terms.length; i++){
	if (i == 0){
		var tuple_ = terms[0].replace('(','').replace(')','').replace(' ','');
		currentkey = tuple_.split(',')[0]
	}
	var tuple = terms[i].replace('(','').replace(')','').replace(' ','');
	var key = tuple.split(',')[0]
	var value = tuple.split(',')[1]
	jsonresult[key]=value;
	
}
wordtagcloud("#tagcloudcontainer",450,jsonresult);
</script>

<%
	} else if (action.toString().equals("getlocationdashboard")) {
%>

<!-- START LOCATION  -->
<div class="card card-style mt20">
	<div class="card-body mt0 pt0 pl0" style="min-height: 520px;">

		<div class="location_mecard">

			<div class="front p30 pt5 pb5">

				<div>
					<p class="text-primary mt0 float-left">Most Active Location</p>
					<button style="right: 10px; position: absolute" id="flip"
						type="button" onclick="location_flip()"
						class="btn btn-sm btn-primary float-right" data-toggle="tooltip"
						data-placement="top" title="Flip to view location usage"
						aria-expanded="false">
						<i class="fas fa-exchange-alt" aria-hidden="true"></i>
					</button>
				</div>
				<div style="min-height: 490px;">
					<div class="chart-container text-center">
						<div class="svg-center map-container map-choropleth getlocationdashboard"></div>
					</div>
				</div>


			</div>
			<!-- end front -->
			<div class="back p30 pt5 pb5">

				<div>
					<p class="text-primary mt10 float-left">Location Usage</p>
					<button style="right: 10px; position: absolute" id="flip"
						type="button" onclick="location_flip()"
						class="btn btn-sm btn-primary float-right" data-toggle="tooltip"
						data-placement="top" title="Flip to view location usage"
						aria-expanded="false">

						<i class="fas fa-exchange-alt" aria-hidden="true"></i>
					</button>
				</div>

				<div class="min-height-table">
					<table id="DataTables_Table_19_wrapper" class="display"
						style="width: 100%">
						<thead>
							<tr>
								<th>Blogs</th>
								<th>Location</th>

							</tr>
						</thead>
						<tbody>

							<%
							top_location = Blogs.getTopBlogs("blogsite_id", blog_ids,date_start.toString(), date_end.toString(), "10");
							if (top_location.size() > 0) {
								for (scala.Tuple2<String, scala.Tuple2<String, Integer>> x : top_location) {
									scala.Tuple2<String, Integer> location_count = x._2;
							%>

							<tr>
								<td class=""><%=x._1%></td>
								<td><%=location_count._1%></td>

							</tr>

							<%
								}
							}
							%>

						</tbody>
					</table>


				</div>

			</div>
			<!-- end back -->

		</div>
		<!--end location mecard -->

	</div>
</div>

<script>
					function location_flip() {
					    $('.location_mecard').toggleClass('flipped');
					}
					
					$('#DataTables_Table_19_wrapper').DataTable( {
						 "columnDefs": [
				 		    { "width": "65%", "targets": 0 }
				 		  ],
					        "scrollY": 380,
					        "scrollX": true,
					         "pagingType": "simple",
					        	 "bLengthChange": false,
					        	 "bFilter":false,
					        	 "bPaginate":false,
					        	 "bInfo":false,
					        	 "order": [[ 1, "desc" ]]
					  
					    } );
					
					
					$(function() {
						
					<%
					JSONObject location = new JSONObject();
					JSONObject country_name = new JSONObject();

							String csvFile = application.getRealPath("/").replace('/', '/') + "lat_long.csv";
							BufferedReader br = null;
							String line = "";
							String cvsSplitBy = ",";

							try {

								br = new BufferedReader(new FileReader(csvFile));
								while ((line = br.readLine()) != null) {
									// use comma as separator
									String[] country = line.split(cvsSplitBy);
									location.put(country[1].substring(0, 2), country[3] + "," + country[2]);
									country_name.put(country[1].substring(0, 2), country[0]);

								}

							} catch (FileNotFoundException e) {
								e.printStackTrace();
							} catch (IOException e) {
								e.printStackTrace();
							} finally {
								if (br != null) {
									try {
										br.close();
									} catch (IOException e) {
										e.printStackTrace();
									}
								}
							}%>
						var mymarker = [
							<%
							
							
							for (scala.Tuple2<String, scala.Tuple2<String, Integer>> x : top_location) {
								scala.Tuple2<String, Integer> location_count = x._2;
								if(location_count._1 != null){
								
								
							%>
							{latLng: [<%=location.get(location_count._1)%>], name: '<%=country_name.get(location_count._1)%>, <%=location_count._2%>' , r:<%=location_count._2/1000%>},
							/* {latLng: [40.463667, -3.74922], name: '101' , r:101},
							{latLng: [37.09024, -95.712891], name: '3' , r:3},
							{latLng: [52.132633, 5.291266], name: '10' , r:10},
							{latLng: [46.227638, 2.213749], name: '2' , r:2},
							{latLng: [-25.274398, 133.775136], name: '50' , r:50}, */
							<%}}%>]

						//console.log(mymarker[2].size);
						    // Choropleth map
						    var mapObj = new jvm.WorldMap({
						    	container: $('.map-choropleth'),
						        map: 'world_mill_en',
						        backgroundColor: 'transparent',
						        series: {
						        	markers: [{
						        		attribute: 'r',
						                scale: [3,10]	
						        	}],
						            regions: [{
						                values: gdpData,
						                scale: ['#E5DBD2', '#E6CEC3'],
						                normalizeFunction: 'polynomial'
						            }]
						        },
						        markerStyle: {
						                initial: {
						                    r: 3,
						                    'fill': '#F26247',
						                    'fill-opacity': 0.8,
						                    'stroke': '#fff',
						                    'stroke-width' : 1.5,
						                    'stroke-opacity': 0.9
						                },
						                hover: {
						                    'stroke': '#fff',
						                    'fill-opacity': 1,
						                    'stroke-width': 1.5
						                }
						            },
						            focusOn: {
						                x: 0.5,
						                y: 0.5,
						                scale: 1
						            },
						            markers:[],
						           // markers: mymarker,
						        onRegionLabelShow: function(e, el, code){
						            el.html(el.html()
						            		// remove the data count
						            		//+'<br>'+
						            		//gdpData[code]
						            );
						        }
						                 
						    });
						    var mapMarkers = [];
						    var mapMarkersValues = [];
						    mapMarkers.length = 0;
						    mapMarkersValues.length = 0;
						    //console.log(mymarker.length);
						    for (var i = 0, l= mymarker.length; i < l; i++) {
						    	//console.log(mymarker[i].name)      
						     mapMarkers.push({name: mymarker[i].name, latLng: mymarker[i].latLng, r:mymarker[i].r *10});
						    }
						    mapObj.addMarkers(mapMarkers, []); 
						    
						    for (var i = 0, l= mymarker.length; i < l; i++) {
						    	//console.log(mapObj.markers[i].element);
						    	if(mymarker[i].r >=1 && mymarker[i].r < 3)
						    		{
						    		mapObj.markers[i].element.style.initial.r = (mymarker[i].r / 0.75) * 1.5;
						    		}
						    	
						    	else if(mymarker[i].r > 30)
						    		{
						    		mapObj.markers[i].element.style.initial.r = mymarker[i].r/8;
						    		}
						    	else{
						    		mapObj.markers[i].element.style.initial.r = mymarker[i].r;
						    	}
						        
						    }
						    mapObj.applyTransform();

						});
				</script>
<!-- END LOCATION -->




<%
	} else if (action.toString().equals("getlanguagedashboard")) {
%>



<!-- START LANGUAGE -->
<div class="card card-style mt20">

	<div class="card-body mt0 pt0 pl0" style="min-height: 520px;">
		<div class="mecard">
			<div class="front p30 pt5 pb5">
				<div>
					<p class="text-primary mt10 float-left">Language Usage</p>
					<button style="right: 10px; position: absolute" id="flip1"
						type="button" onclick="flip()"
						class="btn btn-sm btn-primary float-right" data-toggle="tooltip"
						data-placement="top" title="Flip to view language usage"
						aria-expanded="false">
						<i class="fas fa-exchange-alt" aria-hidden="true"></i>
					</button>
				</div>
				<div style="min-height: 490px;">
					<div class="chart-container text-center">
						<div style="min-height: 400px;" class="chart getlanguagedashboard" id="languageusage"></div>
					</div>
				</div>
			</div>
			<div class="back p30 pt5 pb5">

				<div>
					<p class="text-primary mt10 float-left">Language Usage</p>
					<button style="right: 10px; position: absolute" id="flip1"
						type="button" onclick="flip()"
						class="btn btn-sm btn-primary float-right" data-toggle="tooltip"
						data-placement="top" title="Flip to view language usage"
						aria-expanded="false">

						<i class="fas fa-exchange-alt" aria-hidden="true"></i>
					</button>
				</div>

				<div class="min-height-table">


					<table id="DataTables_Table_1_wrapper" class="display"
						style="width: 100%">
						<thead>
							<tr>
								<th>Language</th>
								<th>Frequency</th>

							</tr>
						</thead>
						<tbody>
							<%
							java.sql.ResultSet language_data = d.load_filter(blog_ids, date_start.toString(), date_end.toString(), "top_language", "10");
								/* ArrayList<scala.Tuple2<String, Integer>> language_data = LanguageMapper.getTopLanguages("blogsite_id",
									blog_ids, date_start.toString(), date_end.toString(), "10");*/
							JSONArray result_language = new JSONArray(); 
							if (language_data != null) {
								while(language_data.next()) {
									JSONObject a = new JSONObject();
									
									String lang = language_data.getString("language");
									int count = language_data.getInt("c");

									a.put("letter", lang);
									a.put("frequency", count);
									result_language.put(a);
							%>
							<tr>
								<td class=""><%=lang%></td>
								<td><%=count%></td>
							</tr>
							<%
								}
							}
							%>


						</tbody>
					</table>


				</div>

			</div>
		</div>

	</div>

</div>

<script>
					function flip() {
					    $('.mecard').toggleClass('flipped');
					}
					
				  // datatable setup
				    $('#DataTables_Table_1_wrapper').DataTable( {
				    	"columnDefs": [
				 		    { "width": "65%", "targets": 0 }
				 		  ],
				        "scrollY": 380,
				        "scrollX": true,
				         "pagingType": "simple",
				        	 "bLengthChange": false,
				        	 "bFilter":false,
				        	 "bPaginate":false,
				        	 "bInfo":false,
				        	 "order": [[ 1, "desc" ]]
				  
				    } );
				  
				  
				  
				    <!--start of language bar chart  -->
				$(function () {
					
				    // Initialize chart
				    languageusage('#languageusage', 430);
				    // Chart setup
				    function languageusage(element, height) {
				      // Basic setup
				      // ------------------------------
				      // Define main variables
				      var d3Container = d3.select(element),
				          margin = {top: 5, right: 50, bottom: 20, left: 110},
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
				      var container = d3Container.append("svg").attr('class','languagesvg');
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
				      	/* String sql = post._getMostKeywordDashboard(dt,dte,ids);
					JSONObject res=post._keywordTermvctors(sql);	 */
					data = [];
					
					
				<%--      data = [
				    	  <%if (languages.size() > 0) {
										for (int y = 0; y < languages.size(); y++) {
											ArrayList<?> langu = (ArrayList<?>) languages.get(y);
											String languag = langu.get(0).toString();

											String languag_freq = langu.get(1).toString();
											if (y < 10) {%>
											{letter:"<%=languag%>", frequency:<%=languag_freq%>},
				    		<%}
										}
									}%>
					 ];  --%>
					
					  data = <%=result_language%> 
					  //console.log("data--",data)
					 
					 <%-- console.log("langdata-->"+"<%=language_data%>"); --%>
				     data.sort(function(a, b){
				    	    return a.frequency - b.frequency;
				    	});
				     
				   /*    data = [
				            {letter:"English", frequency:2550},
				            {letter:"Russian", frequency:800},
				            {letter:"Spanish", frequency:500},
				            {letter:"French", frequency:1700},
				            {letter:"Arabic", frequency:1900},
				            {letter:"Unknown", frequency:1500}
				        ]; */
				      
				      //
				      //
				      //   // Create tooltip
				        var tip = d3.tip()
				               .attr('class', 'd3-tip')
				               .style("text-transform", "uppercase")
				               .html(function(d) {
				                   return d.letter.toUpperCase()+" ("+formatNumber(d.frequency)+")";
				               });
				function formatNumber(num) {
					  return num.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,')
					}
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
				      //    // Vertical
				          y.domain(data.map(function(d) { return d.letter; }));
				          
				          
				          // Horizontal domain
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
				              //.attr("stroke","#333")
				              //.attr("fill","#333")
				              .attr("stroke-height","1")
				              .call(xAxis);
				          // Vertical
				          var verticalAxis = svg.append("g")
				              .attr("class", "d3-axis d3-axis-vertical d3-axis-strong")
				              .style("color","yellow")
				              .call(yAxis)
				              .selectAll("text")
				              .style("font-size",12)
				              .style("text-transform","capitalize");
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
				          var transitionbarlanguage = svg.selectAll(".d3-bar")
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
				                  .on('mouseout', tip.hide)
				                  transitionbarlanguage.transition()
				                  .delay(200)
				                  .duration(1000)
				                  .attr("width", function(d) { return x(d.frequency); })
				                  .attr('transform', 'translate(0, '+(y.rangeBand()/2-14.5)+')');
				      
				          $(element).bind('inview', function (event, visible) {
				        	  if (visible == true) {
				        	    // element is now visible in the viewport
				        		  transitionbarlanguage.transition()
				                  .delay(200)
				                  .duration(1000)
				                  .attr("width", function(d) { return x(d.frequency); })
				                  .attr('transform', 'translate(0, '+(y.rangeBand()/2-14.5)+')');
				        	  } else {
				        		  
				        		  transitionbarlanguage.attr("width", 0)
				        	    // element has gone out of viewport
				        	  }
				        	});
				         /*  element
				          transitionbar.transition()
				          .delay(200)
				          .duration(1000)
				          .attr("width", function(d) { return x(d.frequency); })
				          .attr('transform', 'translate(0, '+(y.rangeBand()/2-14.5)+')');
				 */
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
				 
				 
				 ExportSVGAsImage('.savelanguagejpg','click','.languagesvg',width,height,'jpg');
				 ExportSVGAsImage('.savelanguagepng','click','.languagesvg',width,height,'png');
				 
				//Set-up the export button
				/*  d3.select('#savelanguage').on('click', function(){
				 	var svgString = getSVGString(d3.select('.languagesvg').node());
				 	svgString2Image( svgString, 2*width, 2*height, 'png', save ); // passes Blob and filesize String to the callback
				 	function save( dataBlob, filesize ){
				 		saveAs( dataBlob, 'D3 vis exported to PNG.png' ); // FileSaver.js function
				 	}
				 }); */
				 
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
<!-- End of language bar chart  -->

<!-- END LANGUAGE -->



<%
	} else if (action.toString().equals("getsentimentdashboard")) {
%>

<!-- START SENTIMENT -->
<div class="card card-style mt20">
	<div class="card-body  p30 pt5 pb5">
		<div>
			<p class="text-primary mt10">Sentiment Usage</p>
		</div>
		<div style="min-height: 420px;">
			<div class="chart-container text-center">
				<div class="chart svg-center getsentimentdashboard" id="sentimentpiechart"></div>
			</div>
		</div>
	</div>
</div>
<div class="float-right">
	<a href="<%=request.getContextPath()%>/sentiment.jsp?tid=<%=tid%>"><button
			class="btn buttonportfolio2 mt10">
			<b class="float-left semi-bold-text">Sentiment Analysis </b> <b
				class="fas fa-adjust float-right icondash2"></b>
		</button></a>
</div>

<script type="text/javascript">
				  $(function () {
				
				 <%scala.Tuple2<Integer, Integer> result = Liwc.getSumPositveAndNegativeSentiment("blogsite_id", blog_ids,
		date_start.toString(), date_end.toString());%>
			      sentimentdata = [
			            <%-- {label:"Negative", value:<%=Integer.parseInt(neg)%>},
			            {label:"Positive", value:<%=Integer.parseInt(pos)%>}, --%>
			            {label:"Negative", value:<%=result._2%>},
			            {label:"Positive", value:<%=result._1%>}
			        ];
			      //console.log("here---",sentimentdata);
			      pieChartAnimation("#sentimentpiechart",180,sentimentdata);
				  });
			        
			      </script>
<!-- END SENTIMENT -->


<%
	} else if (action.toString().equals("getbloggerdashboard")) {
%>

<!-- START BLOGGER DISTRIBUTION -->
<div class="card card-style mt20">
	<div class="card-body p30 pt5 pb5">
		<div>
			<p class="text-primary mt10 float-left">Blogger Distribution</p>
		</div>
		<div class="min-height-table" style="min-height: 450px;">
			<div class="chart-container">
				<div class="chart getbloggerdashboard" id="bubblesblogger"></div>
			</div>
		</div>
	</div>
</div>
<div class="float-right">
	<a href="bloggerportfolio.jsp?tid=<%=tid%>"><button
			class="btn buttonportfolio2 mt10">
			<b class="float-left semi-bold-text">Blogger Portfolio Analysis </b>
			<b class="fas fa-user float-right icondash2"></b>
		</button></a>
</div>

<!-- Blogger Bubble Chart -->
<script>
$(function () {
    // Initialize chart
    bubblesblogger('#bubblesblogger', 450);
    $('[data-toggle="tooltip"]').tooltip();
    // Chart setup
    function bubblesblogger(element, diameter) {
        // Basic setup
        // ------------------------------
        // Format data
        var format = d3.format(",d");
        // Color scale
        color = d3.scale.category10();
        // Define main variables
        var d3Container = d3.select(element),
            margin = {top: 5, right: 20, bottom: 20, left: 50},
            width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right,
            height = height - margin.top - margin.bottom;
            diamter = height;
            // Add SVG element
            var container = d3Container.append("svg");
            // Add SVG group
            var svg = container
                .attr("width", diameter + margin.left + margin.right)
                .attr("height",diameter + margin.top + margin.bottom)
                .call(responsivefy)
                .attr("class", "bubble");
        // Create chart
        // ------------------------------
        // var svg = d3.select(element).append("svg")
        //     .attr("width", diameter)
        //     .attr("height", diameter)
        //     .attr("class", "bubble");
        // Create chart
        // ------------------------------
        // Add tooltip
        var tip = d3.tip()
            .attr('class', 'd3-tip')
            .offset([-5, 0])
            .html(function(d) {
                return "Blogger Name: "+toTitleCase(d.label)+"<br/> Total Blogposts: "
                //+d.className + ": " 
                + format(d.value) ;
            });
        // Initialize tooltip
        svg.call(tip);
        function toTitleCase(str) {
            return str.replace(
                /\w\S*/g,
                function(txt) {
                    return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
                }
            );
        }
        // Construct chart layout
        // ------------------------------
        // Pack
        
        var bubble = d3.layout.pack()
            .sort(null)
            .size([diameter, diameter])
            .padding(15);
        // Load data
        // ------------------------------
data = {
 //"name":"flare",
 "bloggers":[
	 
	 
	  <%ArrayList<scala.Tuple2<String, Integer>> bloggerPostFrequency = Blogger.getMostInfluentialBloggers("blogsite_id",
		blog_ids, date_start.toString(), date_end.toString(), "10");
if (bloggerPostFrequency.size() > 0) {
	for (scala.Tuple2<String, Integer> x : bloggerPostFrequency) {%>
							
							{"label":"<%=x._1%>","name":"<%=x._1%>", "size":<%=x._2%>},
<%}
}%> 
					

 
 ]
    }
  

	
	var mybloggers = 
		  data.bloggers.sort(function(a, b){
		return b.size - a.size;
		})
		
		
		/* resort the bubbles chart by size */
		var alldata=[];
		
	  for(i=0;i<mybloggers.length;i++)
		{
		var myconcat = ",";
		if(i == mybloggers.length - 1)
		{
			myconcat = "";	
		} 
		alldata[i]= {"label":mybloggers[i].label,"name":mybloggers[i].name,"size":mybloggers[i].size}
		} 
	/* End of sorting   */
	  bloggers = alldata;
	  
	  data = {  bloggers } 
	  //console.log("blogger_data",data)
            //
            // Append chart elements
            //
 			
            // Bind data
            var node = svg.selectAll(".d3-bubbles-node")
                .data(bubble.nodes(classes(data))
                .filter(function(d) { return !d.children; }))
                .enter()
                .append("g")
                    .attr("class", "d3-bubbles-node")
                    .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });
        
			var color = d3.scale.linear()
			.domain([0,1,2,3,4,5,6,10,15,20])
			.range(["#17394C", "#FFBB78", "#CE0202", "#0080CC", "#72C28E", "#D6A78D", "#FF7E7E", "#666", "#555", "#444"]);
            // Append circles
            node.append("circle")
                .attr("r", 0)
                .style("fill", function(d,i) {
                   return color(i);
                  // customize Color
                 /*  if(i<5)
                  {
                    return "#0080cc";
                  }
                  else if(i>=5)
                  {
                    return "#78bce4";
                  } */
                })
                .on('mouseover', tip.show)
                .on('mouseout', tip.hide);
            // Append text
            node.append("text")
                .attr("dy", ".3em")
                .style("fill", "#fff")
                .style("text-transform","capitalize")
                .style("font-size", 12)
                .style("text-anchor", "middle")
                .text(function(d) { 
                	
                	if(d.r < 30)
            		{
            		return "";
            		}
            	else
            		{
            		return d.label.substring(0, d.r / 3);  
            		}
                	
                });
     
            
            
            // animation effect for bubble chart
            $(element).bind('inview', function (event, visible) {
            	  if (visible == true) {
            		  node.selectAll("circle").transition()
                      .delay(200)
                      .duration(1000)
                      .attr("r", function(d) { return d.r; })
            	  } else {
            		  node.selectAll("circle")
                      .attr("r", 0 )
            	  }
            	});
           
           
        // Returns a flattened hierarchy containing all leaf nodes under the root.
        function classes(root) {
            var classes = [];
            function recurse(name, node) {
                if (node.bloggers) node.bloggers.forEach(function(child) { recurse(node.name, child); });
                else classes.push({packageName: name, className: node.name, value: node.size,label:node.label});
            }
            recurse(null, root);
            return {children: classes};
        }
        
        
        function responsivefy(svg) {
        	  // container will be the DOM element the svg is appended to
        	  // we then measure the container and find its aspect ratio
        	  const container = d3.select(svg.node().parentNode),
        	      width = parseInt(svg.style('width'), 10),
        	      height = 495,
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
    }
});
</script>
<script>
    var color = d3.scale.linear()
            .domain([0,1,2,3,4,5,6,10,15,20,80])
            .range(["#17394C", "#F5CC0E", "#CE0202", "#aaa", "#999", "#888", "#777", "#666", "#555", "#444", "#333", "#222"]);
</script>
<!-- end of blogger bubble chart -->
<!-- END BLOGGER DISTRIBUTION -->


<%
	} else if (action.toString().equals("getblogdashboard")) {
%>


<!-- START BLOG DISTRIBUTION -->

<div class="card card-style mt20">
	<div class="card-body   p30 pt5 pb5">
		<div>
			<p class="text-primary mt10 float-left">Blog Distribution</p>
		</div>
		<div class="min-height-table" style="min-height: 450px;">
			<div class="chart-container">
				<div class="chart getblogdashboard" id="bubblesblog"></div>
			</div>
		</div>
	</div>
</div>
<div class="float-right">
	<a href="blogportfolio.jsp?tid=<%=tid%>"><button
			class="btn buttonportfolio2 mt10">
			<b class="float-left semi-bold-text">Blog Portfolio Analysis</b> <b
				class="fas fa-file-alt float-right icondash2"></b>
		</button></a>
</div>

<!-- Blog Bubble Chart -->
<script>
$(function () {
    // Initialize chart
    bubblesblog('#bubblesblog', 450);
    $('[data-toggle="tooltip"]').tooltip();
    // Chart setup
    function bubblesblog(element, diameter) {
        // Basic setup
        // ------------------------------
        // Format data
        var format = d3.format(",d");
        // Color scale
        color = d3.scale.category10();
        // Define main variables
        var d3Container = d3.select(element),
            margin = {top: 5, right: 20, bottom: 20, left: 50},
            width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right,
            height = height - margin.top - margin.bottom;
            diamter = height;
            // Add SVG element
            var container = d3Container.append("svg");
            // Add SVG group
            var svg = container
                .attr("width", diameter + margin.left + margin.right)
                .attr("height",diameter + margin.top + margin.bottom)
                .call(responsivefy)
                .attr("class", "bubble");
        // Create chart
        // ------------------------------
        // var svg = d3.select(element).append("svg")
        //     .attr("width", diameter)
        //     .attr("height", diameter)
        //     .attr("class", "bubble");
        // Create chart
        // ------------------------------
        // Add tooltip
        var tip = d3.tip()
            .attr('class', 'd3-tip')
            .offset([-5, 0])
            .html(function(d) {
                return "Blog Name: "+toTitleCase(d.label)+"<br/> Total Blogposts: "
                //+d.className + ": " 
                + format(d.value);
            });
        // Initialize tooltip
        svg.call(tip);
        function toTitleCase(str) {
            return str.replace(
                /\w\S*/g,
                function(txt) {
                    return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
                }
            );
        }
        // Construct chart layout
        // ------------------------------
        // Pack
        var bubble = d3.layout.pack()
            .sort(null)
            .size([diameter, diameter])
            .padding(15);
        // Load data
        // ------------------------------
data = {
 //"name":"flare",
 "bloggers":[
	 <%
	 top_location = Blogs.getTopBlogs("blogsite_id", blog_ids,date_start.toString(), date_end.toString(), "10");
	 if (top_location.size() > 0) {
			for (scala.Tuple2<String, scala.Tuple2<String, Integer>> x : top_location) {
				scala.Tuple2<String, Integer> location_count = x._2;
				%>
							{label:"<%=x._1%>", "size":<%=location_count._2%>, name:"<%=x._1%>", type:"blog"},
		 <%}

}%>
					
/* 					 {"label":"Blogger 2","name":"Obadimu Adewale", "size":2500},
					 {"label":"Blogger 3","name":"Oluwaseun Walter", "size":2800},
					 {"label":"Blogger 4","name":"Kiran Bandeli", "size":900},
					 {"label":"Blogger 5","name":"Adekunle Mayowa", "size":1400},
					 {"label":"Blogger 6","name":"Nihal Hussain", "size":200},
					 {"label":"Blogger 7","name":"Adekunle Mayowa", "size":500},
					 {"label":"Blogger 8","name":"Adekunle Mayowa", "size":300},
					 {"label":"Blogger 9","name":"Adekunle Mayowa", "size":350},
					 {"label":"Blogger 10","name":"Adekunle Mayowa", "size":1400} */
 ]
}  
      
     
     
      
  var mybloggers = 
	  data.bloggers.sort(function(a, b){
	return b.size - a.size;
	})
	
	
	/* resort the bubbles chart by size */
	var alldata=[];
	
  for(i=0;i<mybloggers.length;i++)
	{
	var myconcat = ",";
	if(i == mybloggers.length - 1)
	{
		myconcat = "";	
	} 
	alldata[i]= {"label":mybloggers[i].label,"name":mybloggers[i].name,"size":mybloggers[i].size}
	} 
/* End of sorting   */
  bloggers = alldata;
  
  data = {   bloggers  }
  
  
            //
            // Append chart elements
            //
            // Bind data
            var node = svg.selectAll(".d3-bubbles-node")
                .data(bubble.nodes(classes(data))
                .filter(function(d) { return !d.children; }))
                .enter()
                .append("g")
                    .attr("class", "d3-bubbles-node")
                    .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });
        
			var color = d3.scale.linear()
			.domain([0,1,2,3,4,5,6,10,15,20])
			.range(["#17394C", "#FFBB78", "#CE0202", "#0080CC", "#72C28E", "#D6A78D", "#FF7E7E", "#666", "#555", "#444"]);
			
            // Append circles
            node.append("circle")
                .attr("r", 0)
                .style("fill", function(d,i) {
                  //return color(i);
                  /* if(i<5)
                  {
                    return "#0080cc";
                  }
                  else if(i>=5)
                  {
                    return "#78bce4";
                  } */
                  //console.log(d.r * 2);
                 // console.log("afde");
                  return color(i);
                
                })
                .on('mouseover',tip.show)
                .on('mouseout', tip.hide);
           
            // Append text
            node.append("text")
                .attr("dy", ".3em")
                .style("fill", "#fff")
                .style("text-transform","lowercase")
                .style("font-size", 12)
                .style("text-transform","capitalize")
                .style("text-anchor", "middle")
                .text(function(d) { 
                	if(d.r < 30)
                		{
                		return "";
                		}
                	else
                		{
                		return d.label.substring(0, d.r / 3);  
                		}
                
                	
                });
            
            // animation effect on bubble chart
            $(element).bind('inview', function (event, visible) {
          	  if (visible == true) {
          		  node.selectAll("circle").transition()
                    .delay(200)
                    .duration(1000)
                    .attr("r", function(d) { return d.r; })
          	  } else {
          		  node.selectAll("circle")
                    .attr("r", 0 )
          	  }
          	});
        // Returns a flattened hierarchy containing all leaf nodes under the root.
        function classes(root) {
            var classes = [];
            function recurse(name, node) {
                if (node.bloggers) node.bloggers.forEach(function(child) { recurse(node.name, child); });
                else classes.push({packageName: name, className: node.name, value: node.size,label:node.label});
            }
            recurse(null, root);
            return {children: classes};
        }
        
        function responsivefy(svg) {
      	  // container will be the DOM element the svg is appended to
      	  // we then measure the container and find its aspect ratioF
      	  const container = d3.select(svg.node().parentNode),
      	      width = parseInt(svg.style('width'), 10),
      	      height = 495,
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
    }
});
</script>
<script>
$(".option-only").on("change",function(e){
	//console.log("only changed ");
	var valu =  $(this).val();
	$("#single_date").val(valu);
	$('form#customformsingle').submit();
});
$(".option-only").on("click",function(e){
	//console.log("only Click ");
	$("#single_date").val($(this).val());
	//$('form#customformsingle').submit();
});
$(".option-lable").on("click",function(e){
	//gconsole.log("Label Click ");
	
	$("#single_date").val($(this).val());
	//$('form#customformsingle').submit();
});
</script>
<!-- End of blog bubble chart -->

<!-- END BLOG DISTRIBUTION -->



<%
	} else if (action.toString().equals("getinfluencedashboard")) {
		
		String blog_active;
		String bloggers_active;
		if(action_type.equals("bloggers")){ 
			bloggers_active = "selected='selected'";
			blog_active = "";
		}else{
			bloggers_active = "";
			blog_active = "selected='selected'";
		}
		
%>

<!-- START INFLUENCE -->
<div class="card card-style mt20">
	<div class="card-body p30 pt5 pb5">
		<div>
			<p class="text-primary mt10 float-left">

				Most Influential <select
					class="text-primary filtersort sortbyblogblogger"
					id="swapInfluence">
					<option <%=blog_active %> value="blogs">Blogs</option>
					<option <%=bloggers_active %> value="bloggers">Bloggers</option>
				</select>
			</p>
		</div>
		<div class="min-height-table" style="min-height: 500px;">
			<div class="chart-container" id="influencecontainer">
				<div class="chart  getinfluencedashboard" id="influencebar"></div>
			</div>
		</div>
	</div>
</div>
<div class="float-right">
	<a href="influence.jsp?tid=<%=tid%>"><button
			class="btn buttonportfolio2 mt10">
			<b class="float-left semi-bold-text">Influence Analysis </b> <b
				class="fas fa-exchange-alt float-right icondash2"></b>
		</button></a>
</div>

<!-- start of influence bar chart  -->
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
      data = [
    	  <%
    	  ArrayList<scala.Tuple2<String, Integer>> blogInfluence;
    	  if(action_type.equals("bloggers")){ 
    		  blogInfluence = Blogs.getMostInfluentialBlogs("blogger", blog_ids, date_start.toString(), date_end.toString(), "10");
    	  }else{
    		 blogInfluence = Blogs.getMostInfluentialBlogs("blogsite_id", blog_ids, date_start.toString(), date_end.toString(), "10");
    	  }
    	  
    	  
    	  
    	  if (blogInfluence.size() > 0) {
	
	for (scala.Tuple2<String, Integer> y : blogInfluence) {
		String fieldname = "";
		if(action_type.equals("bloggers")){ 
			fieldname = y._1.split("_______________")[1];
		}else{
			fieldname = y._1.split("_______________")[0];
		}
		%>
		 {letter:"<%=fieldname%>", frequency:<%=y._2%>, name:"<%=fieldname%>", type:"blogger"},
		 <%
						}
					}%>    
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
              .attr("data-toggle", "tooltip")
		      .attr("data-placement", "top")
		      .attr("title", function (d) {  return d; })
		      
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
                  /*
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

                })*/
                .style("fill", function(d,i) {
                    
                    return colorblogs(data.length - i - 1);
                   
                  })
                  .on('mouseover', tip.show)
                  .on('mouseout', tip.hide);
          $(element).bind('inview', function (event, visible) {
        	  if (visible == true) {
        	    // element is now visible in the viewport
        		  transitionbarinfluence.transition()
                  .delay(200)
                  .duration(1000)
                  .attr("width", function(d) { return x(d.frequency); })
                  .attr('transform', 'translate(0, '+(y.rangeBand()/2-14.5)+')');
        	  } else {
        		  
        		  transitionbarinfluence.attr("width", 0)
        	    // element has gone out of viewport
        	  }
        	});
        
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

<!--  End of influence bar -->
<!-- END INFLUENCE -->


<%
	} else if (action.toString().equals("getclusterdashboard")) {
%>

<!-- START CLUSTER -->
<div id="cluster_card_div" class="card card-style mt20 radial_f">
	<div class="card-body p30 pt5 pb5">
		<div>
			<p class="text-primary mt10 float-left">Clustering Analysis</p>
		</div>
		<div id="scatter-container1" class="min-height-table"
			style="min-height: 500px;">
			<div class="hidden" id="cluster_computing_loaader">
				<div align="center" class=" word1">
					COMPUTING-CLUSTERS... <span id="cluster_percentage"> <%
 	int cluster_status_percentage = 34;
 %> <%=cluster_status_percentage%>%
					</span>
				</div>
				<div align="center" class=" overlay1"></div>
			</div>
			<div class="chart-container" id="scatter-container">
				<div class="chart" id="dataviz_axisZoom"></div>
			</div>
		</div>
	</div>
</div>

<script>
<%
String cluster_status = "0";
String cluster_status_percent = "";
String status = "0";
String status_percentage = null;
JSONObject final_centroids = new JSONObject();
JSONObject final_result = new JSONObject();
java.sql.ResultSet source = null;
Dashboard dash = new Dashboard(tid.toString());
//d.load_cluster_and_terms_dashboard();

cluster_status = dash.get_cluster_status();
cluster_status_percent = dash.get_cluster_status_percentage();
//status = dash.get_kwt_status();
//status_percentage = dash.get_kwt_status_percentage();
final_centroids = dash.get_final_centroids();
//final_result = dash.get_final_result();

source = d.get_cluster_result(); 
if (cluster_status.equals("1")) {%>	
	console.log('cluster is 1')
		$('#clusterbtn').prop("disabled", false);
		$('#scatter-container').removeClass('hidden');
		$('#cluster_card_div').removeClass('radial_f')
		
		
		dataset = <%=final_centroids%>
		clusterdiagram5('#dataviz_axisZoom', dataset);
		
		
<%} else {

final_result.put("final_terms", "");%>
	 console.log('cluster is 0')
	 $('#clusterbtn').prop("disabled", true);
	 $('#cluster_computing_loaader').removeClass('hidden');
	 var cluster_refreshIntervalId = setInterval(function(){ cluster_refresh();    }, 15000);
	 cluster_matrix_loader();
	<%}
%>
					
					//dataset = {}
					clusterdiagram5('#dataviz_axisZoom', dataset);
					
					///start clustering5 funtion
					 function clusterdiagram5(element, dataset) {
						 var final_centroids = {};
						 var plot_width = $('#scatter-container').width();
						var height = $('#scatter-container1').height() - 25;
						 trending_words = [];												 	
						 	trending_words[0] = "aa, bb, cc";
						 	trending_words[1] = "ss, nn, xx";
						 	trending_words[2] = "ff, gg, nn";
						 	 
						 	 //start getting max and min posts numbers
						 	for(var i = 0; i < dataset.nodes.length; i++){
						 		 if(i == 0){
						 			min_post_count = dataset.nodes[i].level
						 			max_post_count = dataset.nodes[i].level
						 		 }
						 		 
						 		 if(dataset.nodes[i].level < min_post_count){
						 			min_post_count = dataset.nodes[i].level
						 		 }
						 		 
						 		if(dataset.nodes[i].level > max_post_count){
						 			max_post_count = dataset.nodes[i].level
						 		 }
						 		 
						 	}
						 	//end getting max and min posts numbers
						 	
						 	//start get normalized array for radius values
						 	normalized_radius = [];
						 	for(var i = 0; i < dataset.nodes.length; i++){
						 		
						 		normalized_value = ( (dataset.nodes[i].level - min_post_count)/(max_post_count - min_post_count));
						 		
						 		range = 2 - 1;
						 		normalized_value = (normalized_value * range) + 1;
						 		
						 		temp = normalized_value * 20;
						 		normalized_radius[i] = temp;
						 		
						 	}
						 	
						 	//start get normalized array for radius values
					  
						 
					var nodes = dataset.nodes
					 var links = dataset.links
					
					   // Define main variables
					   var d3Container = d3v4.select(element),
					     margin = {top: 0, right: 50, bottom: 0, left: 50},
					     width = plot_width,
					     height = height;
								radius = 6;
								
								
					
					   //var colors = d3v4.scaleOrdinal().range(["#6b085e", "#e50471", "#0571a0", "#038a2c", "#6b8a03", "#a02f05", "#b770e1", "#fc8f82 ", "#011aa7", "#a78901"]);
					   var colors = d3v4.scaleOrdinal().range(["#E377C2","#8C564B", "#9467BD", "#D62728", "#2CA02C", "#FF7F0E", "#1F77B4", "#7F7F7F","#17B890", "#D35269"]);
					   // Add SVG element
					   var container = d3Container.append("svg");
					   // Add SVG group
					   var svg = container
					     .attr("width", width + margin.left + margin.right)
					     .attr("height", height + margin.top + margin.bottom)
					     .call(responsivefy) // tada!
					   .attr("overflow", "visible");
					     //.append("g")
					    //  .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
					    // simulation setup with all forces
					  var linkForce = d3v4
					  .forceLink()
					  .id(function (link) { return link.id })
					  .strength(function (link) { return link.strength })
					    // simulation setup with all forces
					     var simulation = d3v4
					     .forceSimulation()
					     .force('link', d3v4.forceLink().id(d =>d.id).distance(-20))
					     .force('charge', d3v4.forceManyBody())
					     /* .force('center', d3v4.forceCenter(width, height ))  */
					     .force('center', d3v4.forceCenter())  
					     .force("collide",d3v4.forceCollide().strength(-5)) 
					     /* simulation.force("center")
					    .x(width * forceProperties.center.x)
					    .y(height * forceProperties.center.y); */
					     /* var simulation = d3.forceSimulation()
					       .force('x', d3.forceX().x(d => d.x))
					       .force('y', d3.forceY().y(d => d.y))
					       .force("charge",d3.forceManyBody().strength(-20))
					       .force("link", d3.forceLink().id(d =>d.id).distance(20)) 
					       .force("collide",d3.forceCollide().radius(d => d.r*10)) 
					       .force('center', d3v4.forceCenter(width, height )) */
								
								simulation.force("center")
							  .x(width / 2)
							  .y(height / 2)
							   
							  	simulation.force("charge")
					    .strength(-2000 * true)
					    .distanceMin(1)
					    .distanceMax(1000);
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
					     .attr("class", "nodes")
					     .selectAll("circle")
					     .data(nodes)
					     .enter().append("circle")
					     /* .attr(circleAttrs) */
					     // .attr("r", function (d, i) {return d.level})
					      .attr("r", function (d, i) {return normalized_radius[d.group-1]})
					      .attr("cluster_number", function (d, i) {return d.group})
					      .attr("data-toggle", "tooltip")
					      .attr("data-placement", "top")
					      .attr("title", function (d, i) {return trending_words[d.group-1]})
					      .attr("fill", function (d, i) {return colors(d.group);})
					      .attr("class", "cluster_visual")
							  .attr("loaded_color",function (d) {return colors(d.group); })
							  .attr("cluster_id", function(node){return node.label})
					      //.attr("text",function (node) { return node.label })
					      /* .on("mouseover", function (node) { return node.label }); */
					    var textElements = svg.append("g")
					     .attr("class", "texts")
					     .selectAll("text")
					     .data(nodes)
					     .enter().append("text")
					      .text(function (node) { return node.label })
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
					function handleMouseOver(d, i) { // Add interactivity
					      // Use D3 to select element, change color and size
					      d3.select(this).attr({
					       fill: "orange",
					       r: radius * 2
					      });
					      // Specify where to put label of text
					      svg.append("text").attr({
					        id: "t" + d.x + "-" + d.y + "-" + i, // Create an id for text so we can select it later for removing on mouseout
					        x: function() { return xScale(d.x) - 30; },
					        y: function() { return yScale(d.y) - 15; }
					      })
					      .text(function() {
					       return [d.x, d.y]; // Value of the text
					      });
					     }
					 simulation.force("link").links(links)
					 
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
					 
					
					 
					 }
					 ///end clustering5 function
				
				</script>

<!-- END CLUSTER -->

<%
	} else if (action.toString().equals("getdomaindashboard")) {
		String url_active;
		String domain_active;
		if(action_type.equals("urls")){ 
			url_active = "selected='selected'";
			domain_active = "";
		}else{
			url_active = "";
			domain_active = "selected='selected'";
		}
		
		
%>


<!-- START DOMAIN -->
<div class="card card-style mt20">
	<div class="card-body  p5 pt10 pb10">
		<div style="min-height: 420px;">
			<div>
				<p class="text-primary p15 pb5 pt0">
					List of Top <select id="top-listtype"
						class="text-primary filtersort sortbydomainsrls">
						<option <%=domain_active %> value="domains">Domains</option>
						<option <%=url_active %> value="urls">URLs</option>
					</select>
				</p>
			</div>

			<div id="top-domain-box" class="getdomaindashboard">
				<table id="DataTables_Table_0_wrapper"
					class="display table_over_cover" style="width: 100%">
					<thead>
						<tr>
							<th>Domain</th>
							<th>Frequency</th>
						</tr>
					</thead>
					<tbody>

						<%
						
						ArrayList<scala.Tuple2<String, Integer>> blogInfluence;
						String query;
						if(action_type.equals("urls")){ 

				    		   query = "select link, count(link) c\r\n" + 
										"from outlinks\r\n" + 
										"where blogsite_id in ("+blog_ids+") and link is not null and link != '' \r\n" + 
										"and date > \""+date_start.toString()+"\" \r\n" + 
										"and date < \""+date_end.toString()+"\"\r\n" + 
										"group by link \r\n" + 
										"order by c desc limit 1000;";
				    	  }else{
				    		   query = "select domain, count(domain) c\r\n" + 
										"from outlinks\r\n" + 
										"where blogsite_id in ("+blog_ids+") and domain is not null and domain != '' \r\n" + 
										"and date > \""+date_start.toString()+"\" \r\n" + 
										"and date < \""+date_end.toString()+"\"\r\n" + 
										"group by domain\r\n" + 
										"order by c desc limit 1000;";
				    	  }
				    	
						java.sql.ResultSet post_all =  DbConnection.queryResultSet(query);
						String domain = "";
						while(post_all.next()){
							if(action_type.equals("urls")){ 
								domain = post_all.getString("link");
							}else{
								domain = post_all.getString("domain");
							}
							
							int count = post_all.getInt("c");
							

						%>
						<tr>
							<td class=""><a href="http://<%=domain %>" target="_blank"><%=domain %></a></td>
							<td><%=count %></td>
						</tr>
						<%
						}
						%>

					</tbody>
				</table>
			</div>
		</div>
	</div>
</div>
<!-- Start for tables  -->
	<script type="text/javascript"
		src="assets/vendors/DataTables/datatables.min.js"></script>
	<script type="text/javascript"
		src="assets/vendors/DataTables/dataTables.bootstrap4.min.js"></script>
	<script
		src="assets/vendors/DataTables/Buttons-1.5.1/js/buttons.flash.min.js"></script>
	<script
		src="assets/vendors/DataTables/Buttons-1.5.1/js/dataTables.buttons.min.js"></script>
		
<script>
			    $('#DataTables_Table_0_wrapper').DataTable( {
			    	 "columnDefs": [
			    		    { "width": "80%", "targets": 0 }
			    		  ]
			    } );
			    
			    $('#DataTables_Table_0_wrapper').css( 'display', 'block' );
			    $('#DataTables_Table_0_wrapper').width('100%');
				</script>



<%
	} else if (action.toString().equals("getblogcount")) {
		String q = "{\n" + 
				"  \"query\":\"select count(distinct(blogsite_id)) from blogposts where blogsite_id in ("+ids.toString()+") and date > '"+date_start+"' and date < '"+date_end+"'\"\n" + 
				"}";
		elastic_query = new JSONObject(q);
		myResponse = Blogposts._makeElasticRequest(elastic_query, "POST", "/_xpack/sql");
		rows = new JSONArray(myResponse.getJSONArray("rows").get(0).toString());
		//System.out.println(rows.get(0));
%>


<%=NumberFormat.getNumberInstance(Locale.US).format(new Double(rows.get(0).toString()).intValue())%>

<%
	} else if (action.toString().equals("getbloggercount")) {
		elastic_query = new JSONObject("{\n" + 
				"  \"query\":\"select count(distinct(blogger)) from blogposts where blogsite_id in ("+ids.toString()+") and date > '"+date_start+"' and date < '"+date_end+"'\"\n" + 
				"}");
		myResponse = Blogposts._makeElasticRequest(elastic_query, "POST", "/_xpack/sql");
		rows = new JSONArray(myResponse.getJSONArray("rows").get(0).toString());
%>


<%=NumberFormat.getNumberInstance(Locale.US).format(new Double(rows.get(0).toString()).intValue())%>
<%
	} else if (action.toString().equals("getpostcount")) {
		elastic_query = new JSONObject("{\n" + 
				"  \"query\":\"select count(distinct(blogpost_id)) from blogposts where blogsite_id in ("+ids.toString()+") and date > '"+date_start+"' and date < '"+date_end+"'\"\n" + 
				"}");
		myResponse = Blogposts._makeElasticRequest(elastic_query, "POST", "/_xpack/sql");
		rows = new JSONArray(myResponse.getJSONArray("rows").get(0).toString());
%>


<%=NumberFormat.getNumberInstance(Locale.US).format(new Double(rows.get(0).toString()).intValue())%>
<%
	} else if (action.toString().equals("getcommentcount")) {
		elastic_query = new JSONObject("{\n" + 
				"  \"query\":\"select sum(num_comments) from blogposts where blogsite_id in ("+ids.toString()+") and date > '"+date_start+"' and date < '"+date_end+"'\"\n" + 
				"}");
		myResponse = Blogposts._makeElasticRequest(elastic_query, "POST", "/_xpack/sql");
		rows = new JSONArray(myResponse.getJSONArray("rows").get(0).toString());
%>


<%=NumberFormat.getNumberInstance(Locale.US).format(new Double(rows.get(0).toString()).intValue())%>


<%
	} else if (action.toString().equals("getpostingfrequencydashboard")) {
		JSONArray line_data = new JSONArray();
		if(action_type.equals("month")){ 
			line_data = post._getGetDateAggregate("NOBLOGGER","date","MMM-yyyy","post","month","date_histogram", date_start.toString(), date_end.toString(), blog_ids);
 	  }else if(action_type.equals("year")){
 		 line_data = post._getGetDateAggregate("NOBLOGGER","date","yyyy","post","year","date_histogram", date_start.toString(), date_end.toString(), blog_ids);
 	  }else if(action_type.equals("week")){
 		 line_data = post._getGetDateAggregate("NOBLOGGER","date","w-yyyy","post","week","date_histogram", date_start.toString(), date_end.toString(), blog_ids);
 	  }		
	
%>


	<div class="card  card-style  mt20">
		<div class="card-body  p30 pt5 pb5">
			<div>
				<p class="text-primary mt10 float-left">
	
					Posting Frequency  
					<%if(action_type.equals("month")){ %>
					<i><b>2020</b></i>
					<%-- <i><b><%=ystint %></b></i> --%>
					<% } %>
					 for Past <select
						class="text-primary filtersort sortbytimerange11 sort_frequency_range"><option
							value="week" <%=(action_type.equals("week"))?"selected":"" %>>Week</option>
						<option value="month" <%=(action_type.equals("month"))?"selected":"" %>>Month</option>
						<option value="year" <%=(action_type.equals("year"))?"selected":"" %>>Year</option></select> 
				</p>
			</div> 
			<div class="min-height-table" style="min-height: 300px;">
				<div class="chart-container">
					<div class="chart" id="postingfrequency"></div>
				</div>
			</div>
		</div>
	</div>
	
	
	<div class="float-right">
		<a href="postingfrequency.jsp?tid=<%=tid%>"><button
				class="btn buttonportfolio2 mt10">
				<b class="float-left semi-bold-text">Posting Frequency
					Analysis</b> <b class="fas fa-comment-alt float-right icondash2"></b>
			</button></a>
	</div>
	
	<!-- posting frequency -->
	<script>
 $(function () {
     // Initialize chart
     lineBasic('#postingfrequency', 300);
     // Chart setup
     function lineBasic(element, height) {
         // Basic setup
         var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct", "Nov", "Dec"]
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
             //.rangeRoundBands([0, width], .72, .5);
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
         
         //seun remove
         <%-- data = [	
        	[<%if (postingTrend.size() > 0) {
	for (int key : postingTrend.keySet()) {
		/* String postYear = postingTrend.get(key).toString(); */
		int postCount = Integer.parseInt(postingTrend.get(key).toString());
		 %>
		
			
		
			{"date":"<%=key%>","close":<%=postCount%>},
		
		
     		  			
     		<%}
}%>
     		]
        	
        	]; --%>
     	  //seun remove
        	 
          // [{"date":"2014","close":400},{"date":"2015","close":600},{"date":"2016","close":1300},{"date":"2017","close":1700},{"date":"2018","close":2100}],
          // [{"date":"2014","close":350},{"date":"2015","close":700},{"date":"2016","close":1500},{"date":"2017","close":1600},{"date":"2018","close":1250}],
         	
           
         
         //console.log("before posting frequenc data", data)
         
        	 data = [[
        		 <%
                 for(int x= 0; x< line_data.length(); x++){
                	 //System.out.println("");
                	 Object date = line_data.getJSONObject(x).getJSONObject("key").get("date");
                	 Object count = line_data.getJSONObject(x).getJSONObject("post").get("doc_count");
                	 
                	 String date_ = date.toString();
                	 int count_ = Integer.parseInt(count.toString());
                	 
                	 if(action_type.equals("week")){
                		 date_ = "Week" + date_;
                	 }
                	 
                	 %>
        		 {"date": "<%=date_%>","close": <%=count_%>},
        		 <%}
                 %>
        		 ]]
         
        
          /* data = [[{"date": "Jan","close": 120},{"date": "Feb","close": 140},{"date": "Mar","close":160},{"date": "Apr","close": 180},{"date": "May","close": 200},{"date": "Jun","close": 220},{"date": "Jul","close": 240},{"date": "Aug","close": 260},{"date": "Sep","close": 280},{"date": "Oct","close": 300},{"date": "Nov","close": 320},{"date": "Dec","close": 340}],
          [{"date":"Jan","close":10},{"date":"Feb","close":20},{"date":"Mar","close":30},{"date": "Apr","close": 40},{"date": "May","close": 50},{"date": "Jun","close": 60},{"date": "Jul","close": 70},{"date": "Aug","close": 80},{"date": "Sep","close": 90},{"date": "Oct","close": 100},{"date": "Nov","close": 120},{"date": "Dec","close": 140}],
          ]; */
          console.log("line--", data)
        // data = [[{"date":"2014","close":400},{"date":"2015","close":600},{"date":"2016","close":1300},{"date":"2017","close":1700},{"date":"2018","close":2100}],
          //    [{"date":"2014","close":350},{"date":"2015","close":700},{"date":"2016","close":1500},{"date":"2017","close":1600},{"date":"2018","close":1250}],];
         
         //console.log("after posting frequenc data", data)
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
                 return d.date+" ("+formatNumber(d.close)+")<br/>";
                  }
                // return "here";
                });
         function formatNumber(num) {
       	  return num.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,')
       	}
         
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
                      //0console.log(svg.selectAll(".tick"))
                     // tick = svg.select(".d3-axis-horizontal").selectAll(".tick")
                     // console.log(tick)
                      //var transform = d3.transform(tick.attr("transform")).translate;
                      //console.log(transform);
                      var path = svg.selectAll('.d3-line')
                                .data(data)
                                .enter()
                                .append("g")
                                .attr("class","linecontainer")
                               // .attr("transform", "translate(106,0)")
                                .append("path")
                                .attr("class", "d3-line d3-line-medium")
                                //.attr("transform", "translate("+129.5/6+",0)")
                                .attr("d", line)
                                // .style("fill", "rgba(0,0,0,0.54)")
                                //.style("fill", "#17394C")
                                .style("stroke-width",2)
                                .style("stroke", "#17394C")
                                //.attr("transform", "translate("+margin.left/4.7+",0)");
                                // .attr("transform", "translate(40,0)");
                        
                    /*   $(element).bind('inview', function (event, visible) {
                    	  if (visible == true) {
                    		  path.select("path")
                    		  .transition()
                              .duration(1000)
                              .attrTween("stroke-dasharray", tweenDash);
                              
                    	  } else {
                    		  //svg.selectAll("text")
                              //.style("font-size", 0)
                    	  }
                    	}); */
                      function tweenDash() {
                          var l = this.getTotalLength(),
                              i = d3.interpolateString("0," + l, l + "," + l);
                          return function (t) { return i(t); };
                      }
                                // .datum(data)
                     // firsttick =  return x(d.date[0]);
                       //         console.log(firsttick);
                       // add point
                       
                       //svg.call(xAxis).selectAll(".tick").each(function(tickdata) {
                        // var tick = svg.call(xAxis).selectAll(".tick").style("stroke",0);
                         //console.log(tick);
                          // pull the transform data out of the tick
                         //var transform = d3.transform(tick[0].g.attr("transform")).translate;
                          //console.log(tick);
                         // console.log("each tick", tickdata, transform); 
                      // });
                        circles =  svg.append("g").attr("class","circlecontainer")
                                 // .attr("transform", "translate("+106+",0)")
                        		  .selectAll(".circle-point")
                                  .data(data[0])
                                  .enter();
                              circles
                              // .enter()
                              
                              .append("circle")
                              .attr("class","circle-point")
                              .attr("r",3.0)
                              .style("stroke", "#4CAF50")
                              .style("fill","#4CAF50")
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
                                  .style("stroke", function(d,i) { return color(i);})
                                  .attr("transform", "translate("+margin.left/4.7+",0)");
                       // add multiple circle points
                           // data.forEach(function(e){
                           // console.log(e)
                           // })
                           // console.log(data);
                              var mergedarray = [].concat(...data);
                                //console.log(mergedarray);
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
           x.rangeRoundBands([0, width]);
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

<%
	}
%>


























