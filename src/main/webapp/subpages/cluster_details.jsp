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
Object cluster = (null == request.getParameter("cluster")) ? "" : request.getParameter("cluster");
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
	if (action.toString().equals("loadkeywords")) {

	/* String dashboardterms = null;
	dashboardterms = Terms.getTopTerms("blogsiteid", blog_ids, date_start.toString(), date_end.toString(), "100"); */
%>

<%-- //<%=result.toString()%> --%>

<div class="chart-container" id="new_word">
	<div id="tagcloudcontainer1" class="hidden " style="min-height: 300px;"></div>
	<div class="jvectormap-zoomin zoombutton" id="zoom_in">+</div>
	<div class="jvectormap-zoomout zoombutton" id="zoom_out">−</div>
</div>



<div class="chart-container keyword_display" id="keyword_display">
	<div id="tagcloudcontainer" style="min-height: 480px;"></div>
	<div class="jvectormap-zoomin zoombutton" id="zoom_in">+</div>
	<div class="jvectormap-zoomout zoombutton" id="zoom_out">−</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
<script type="text/javascript" src="assets/vendors/d3/d3.min.js"></script>
<script src="assets/vendors/wordcloud/d3.layout.cloud.js"></script>
<script type="text/javascript" src="assets/vendors/d3/d3_tooltip.js"></script>
<script type="text/javascript" src="assets/js/jquery.inview.js"></script>
<script type="text/javascript" src="chartdependencies/keywordtrendd3.js"></script>

<script>
 
     var terms = [{"text":"study","size":40},{"text":"motion","size":15},{"text":"forces","size":10},{"text":"electricity","size":15},{"text":"movement","size":10},{"text":"relation","size":5},{"text":"things","size":10},{"text":"force","size":5},{"text":"ad","size":5},{"text":"energy","size":85},{"text":"living","size":5},{"text":"nonliving","size":5},{"text":"laws","size":15},{"text":"speed","size":45},{"text":"velocity","size":30},{"text":"define","size":5},{"text":"constraints","size":5},{"text":"universe","size":10},{"text":"distinguished","size":5},{"text":"chemistry","size":5},{"text":"biology","size":5},{"text":"includes","size":5},{"text":"radiation","size":5},{"text":"sound","size":5},{"text":"structure","size":5},{"text":"atoms","size":5},{"text":"including","size":10},{"text":"atomic","size":10},{"text":"nuclear","size":10},{"text":"cryogenics","size":10},{"text":"solid-state","size":10},{"text":"particle","size":10},{"text":"plasma","size":10},{"text":"deals","size":5},{"text":"merriam-webster","size":5},{"text":"dictionary","size":10},{"text":"analysis","size":5},{"text":"conducted","size":5},{"text":"order","size":5},{"text":"understand","size":5},{"text":"behaves","size":5},{"text":"en","size":5},{"text":"wikipedia","size":5},{"text":"wiki","size":5},{"text":"physics-","size":5},{"text":"physical","size":5},{"text":"behaviour","size":5},{"text":"collinsdictionary","size":5},{"text":"english","size":5},{"text":"time","size":35},{"text":"distance","size":35},{"text":"wheels","size":5},{"text":"revelations","size":5},{"text":"minute","size":5},{"text":"acceleration","size":20},{"text":"torque","size":5},{"text":"wheel","size":5},{"text":"rotations","size":5},{"text":"resistance","size":5},{"text":"momentum","size":5},{"text":"measure","size":10},{"text":"direction","size":10},{"text":"car","size":5},{"text":"add","size":5},{"text":"traveled","size":5},{"text":"weight","size":5},{"text":"electrical","size":5},{"text":"power","size":5}];


<%-- var terms = <%=dashboardterms.toString()%> --%>
var jsonresult = {}
var currenttuple = null;
var currentkey = null;
var currentvalue = null;
/* for(var i = 0; i < terms.length; i++){
	if (i == 0){
		var tuple_ = terms[0].replace('(','').replace(')','').replace(' ','');
		currentkey = tuple_.split(',')[0]
	}
	var tuple = terms[i].replace('(','').replace(')','').replace(' ','');
	var key = tuple.split(',')[0]
	var value = tuple.split(',')[1]
	jsonresult[key]=value;
	
} */
console.log(jsonresult, "jsonresult")
terms1 = {"teump":234,"fdereal":34,"ragolis":123,"thor":500,"memus":3,}
wordtagcloud("#tagcloudcontainer",450,terms1);
</script>

<%
	} else if (action.toString().equals("post_detail_row")) {
%>

<!-- START LOCATION  -->
			<div
				class="col-md-6 mt20 card card-style nobordertopright noborderbottomright">
				<div class="card-body p0 pt20 pb20" style="min-height: 420px;">
					<p>
						Posts from <b class="text-success activeblog">Cluster 1</b>
					</p>
					<!-- <div class="p15 pb5 pt0" role="group">
          Export Options
          </div> -->
          
          <div id="posts_display2 hidden">
          			
          				<table id="DataTables_Table_20_wrapper" class="display posts_display2 hidden"
						style="width: 100%">
						<thead>
							<tr>
								<th>Post title</th>
								<th>Cluster distance</th>


							</tr>
						</thead>
						<tbody id="cluster_post_body2">
						
						</tbody>
					</table>
          
         			</div>
          
          			<div id="posts_display">
          			
          				<table id="DataTables_Table_19_wrapper" class="display"
						style="width: 100%">
						<thead>
							<tr>
								<th>Post title</th>
								<th>Cluster distance</th>


							</tr>
						</thead>
						<tbody id="">
							
							<tr>
							
								<td><a class="blogpost_link cursor-pointer active" id="344" >post title</a><br/>
								<a id="viewpost_344" class="mt20 viewpost erer" href="www.facebook.com" target="_blank"><buttton class="btn btn-primary btn-sm mt10 visitpost">Visit Post &nbsp;<i class="fas fa-external-link-alt"></i></buttton></a></td>
								<%-- <td><%=(double) Math.round(Double.parseDouble(distances.get(blog_post_id.toString()))) / 100000%></td> --%>
								<td>3453424.234323</td>

							</tr>
							
						</tbody>
					</table>
          
         			</div>
					
					<div style="height: 250px; padding-right: 10px !important;" id="posts_display_loader" class="hidden">
						<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />
					</div>
					
					
					
					
					
				</div>

			</div>

			<div id="blogPostContainer"
				class="col-md-6 mt20 card card-style nobordertopleft noborderbottomleft">
				<div id="posts_details" style="" class="pt20">
					<h5 id="titleContainer" class="text-primary p20 pt0 pb0">test post</h5>
					<div class="text-center mb20 mt20">
					<button class="btn stylebuttonblue" onclick="window.location.href = '<%=request.getContextPath()%>/bloggerportfolio.jsp?tid=344&blogger=testblogger'">
						<%-- <button class="btn stylebuttonblue">
							<b id="authorContainer" class="float-left ultra-bold-text"><%=currentBlogger%></b> <i
								class="far fa-user float-right blogcontenticon"></i>--%>
						<b class="float-left ultra-bold-text">test case</b> <i
													class="far fa-user float-right blogcontenticon"></i>
											</button>
						<button id="dateContainer" class="btn stylebuttonnocolor">02-01-2018, 5:30pm</button>
						<button class="btn stylebuttonorange">
							<b id="numCommentsContainer" class="float-left ultra-bold-text">34
								comments</b><i class="far fa-comments float-right blogcontenticon"></i>
						</button>
					</div>
					<div style="height: 600px;">
						<div id="postContainer" class="p20 pt0 pb20 text-blog-content text-primary"
							style="height: 550px; overflow-y: scroll;">67</div>
					</div>
				</div>
				
				<div style="height: 250px; padding-right: 10px !important;" id="posts_details_loader" class="hidden">
					<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />
				</div>
			</div>
		

<script>
		
					
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
					
					
				</script>
<!-- END LOCATION -->




<%
	} else if (action.toString().equals("blogdistribution")) {
%>



45%



<%
	} else if (action.toString().equals("postinglocation")) {
%>

ZIM

<%
	} else if (action.toString().equals("bloggersmentioned")) {
%>


567

<%
	} else if (action.toString().equals("postmentioned")) {
%>

219

<%
	} else if (action.toString().equals("clusterchord")) {
		
%>		

<div class="chart svg-center " id="chorddiagram"></div>

<div id="chorddiagram_loader" class="">
	<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />
</div>

<script >
	buildAndDisplayChord(0);
	
	//start buildAndDisplayChord function
	function buildAndDisplayChord(cluster_number){
		console.log(cluster_number, 'cluster_number')
		$('#chorddiagram_loader').removeClass('hidden');
		/* d3version3 = d3
		   // window.d3 = null
		    // test it worked
		    console.log('v3', d3version3.version)
		    d3 = d3version3 */
		    var rotation = 0;
		 	var names = ["Cluster 1", "Cluster 2", "Cluster 3", "Cluster 4", "Cluster 5", "Cluster 6", "Cluster 7", "Cluster 8", "Cluster 9", "Cluster 10"];
		 	var colors = ["#E377C2","#8C564B", "#9467BD", "#D62728", "#2CA02C", "#FF7F0E", "#1F77B4", "#7F7F7F","#17B890", "#D35269"];
		    var chord_options = {
	    		    "gnames": names,
	    		    "rotation": rotation,
	    		    "colors": colors
	    		};
		     clusterMatrix = [
		    	[0 , 3, 4, 0, 2 , 4 ,5 , 6, 0, 7],
		    	[0 , 0, 4, 0, 2 , 4 ,5 , 6, 0, 0],
		    	[1 , 3, 0, 0, 2 , 4 ,5 , 6, 0, 6],
		    	[0 , 3, 4, 0, 2 , 4 ,0 , 6, 0, 0],
		    	[0 , 3, 4, 7, 0 , 4 ,5 , 6, 0, 9],
		    	[0 , 3, 4, 0, 2 , 0 ,5 , 0, 0, 7],
		    	[0 , 0, 4, 0, 2 , 4 ,0 , 6, 0, 8],
		    	[0 , 3, 4, 8, 2 , 4 ,5 , 0, 0, 4],
		    	[0 , 3, 4, 3, 2 , 4 ,5 , 6, 0, 7],
		    	[0 , 5, 4, 0, 2 , 4 ,5 , 6, 0, 0]
		    ] 
		    
		    var cluster_numy = cluster_number
		   
			
			//console.log('matirx', clusterMatrix)
			<%-- <%for(int j = 0; j < termsMatrix.length; j++){%>
	    	var temparr = []
	    	<%System.out.println("items--"+termsMatrix[0][j]);%>
	    	<%for(int k = 0; k < termsMatrix.length; k++){%>
	    		
	    		
	    	<%}%>
	    	clusterMatrix.push(temparr);
	    	temparr.push(<%=termsMatrix[0][j]%>);
		<%}%>  --%>
		    drawChord("#chorddiagram", chord_options, clusterMatrix, names); 
		    $('#chorddiagram').removeClass('hidden');
			$('#chorddiagram_loader').addClass('hidden');
		
	}
	 ///end buildAndDisplayChord function
 </script>

<%
	} else if (action.toString().equals("clusterwordcount")) {
		
%>


<!-- START DOMAIN -->
<div id="top-domain-box" class="getdomaindashboard">
	<table id="DataTables_Table_0_wrapper"
		class="display table_over_cover" style="width: 100%">
		<thead>
			<tr>
				<th>Domain1</th>
				<th>Frequency 2</th>
				<th>Frequency 3</th>
				<th>Frequency 4</th>
				<th>Frequency 5</th>
				<th>Frequency 6</th>
				<th>Frequency 7</th>
				<th>Frequency 8</th>
				<th>Frequency 9</th>
				<th>Frequency 10</th>
			</tr>
		</thead>
		<tbody>

			<tr>
				<td class="">test</td>
				<td>test</td>
				<td class="">test</td>
				<td>test</td>
				<td class="">test</td>
				<td>test</td>
				<td class="">test</td>
				<td class="">test</td>
				<td class="">test</td>
				
			</tr>
			
		</tbody>
	</table>
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
			    	"scrollY": 430,
			         "scrollX": true,
			         "targets": 'no-sort',
			         "bSort": false
			    } );
			    
			    $('#DataTables_Table_0_wrapper').css( 'display', 'block' );
			    $('#DataTables_Table_0_wrapper').width('100%');
				</script>



<%
	} else if (action.toString().equals("getblogcount")) {
		
%>



<%
	} 
		
%>























