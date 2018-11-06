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
Object blog_id = (null == request.getParameter("blog_id")) ? "" : request.getParameter("blog_id");
String dt = date_start.toString();
String dte = date_end.toString();
ArrayList allterms = new Terms()._searchByRange("date", dt, dte, blog_id.toString());
int highestfrequency = 0;
JSONArray topterms = new JSONArray();
JSONObject keys = new JSONObject();
if (allterms.size() > 0) {
	for (int p = 0; p < allterms.size(); p++) {
		String bstr = allterms.get(p).toString();
		JSONObject bj = new JSONObject(bstr);
		bstr = bj.get("_source").toString();
		bj = new JSONObject(bstr);
		String frequency = bj.get("frequency").toString();
		int freq = Integer.parseInt(frequency);
		
		String tm = bj.get("term").toString();
		if(freq>highestfrequency){
			highestfrequency = freq;
		}
		JSONObject cont = new JSONObject();
		cont.put("key", tm);
		cont.put("frequency", frequency);
		if(!keys.has(tm)){
			keys.put(tm,tm);
			topterms.put(cont);
		}
	}
}
%>
<!-- <div class="tagcloudcontainer" style="min-height: 420px;">
</div> -->	

 <div class="chart-container">
 <div class="chart" id="tagcloudcontainer"></div>
</div>
       


<!--word cloud  -->
 <script type="text/javascript" src="assets/vendors/d3/d3.min.js"></script>
 <script src="assets/vendors/wordcloud/d3.layout.cloud.js"></script>
 <script type="text/javascript" src="assets/vendors/d3/d3_tooltip.js"></script>
 <script type="text/javascript" src="assets/js/jquery.inview.js"></script>
 <script>
 /*
     var frequency_list = [{"text":"study","size":40},{"text":"motion","size":15},{"text":"forces","size":10},{"text":"electricity","size":15},{"text":"movement","size":10},{"text":"relation","size":5},{"text":"things","size":10},{"text":"force","size":5},{"text":"ad","size":5},{"text":"energy","size":85},{"text":"living","size":5},{"text":"nonliving","size":5},{"text":"laws","size":15},{"text":"speed","size":45},{"text":"velocity","size":30},{"text":"define","size":5},{"text":"constraints","size":5},{"text":"universe","size":10},{"text":"distinguished","size":5},{"text":"chemistry","size":5},{"text":"biology","size":5},{"text":"includes","size":5},{"text":"radiation","size":5},{"text":"sound","size":5},{"text":"structure","size":5},{"text":"atoms","size":5},{"text":"including","size":10},{"text":"atomic","size":10},{"text":"nuclear","size":10},{"text":"cryogenics","size":10},{"text":"solid-state","size":10},{"text":"particle","size":10},{"text":"plasma","size":10},{"text":"deals","size":5},{"text":"merriam-webster","size":5},{"text":"dictionary","size":10},{"text":"analysis","size":5},{"text":"conducted","size":5},{"text":"order","size":5},{"text":"understand","size":5},{"text":"behaves","size":5},{"text":"en","size":5},{"text":"wikipedia","size":5},{"text":"wiki","size":5},{"text":"physics-","size":5},{"text":"physical","size":5},{"text":"behaviour","size":5},{"text":"collinsdictionary","size":5},{"text":"english","size":5},{"text":"time","size":35},{"text":"distance","size":35},{"text":"wheels","size":5},{"text":"revelations","size":5},{"text":"minute","size":5},{"text":"acceleration","size":20},{"text":"torque","size":5},{"text":"wheel","size":5},{"text":"rotations","size":5},{"text":"resistance","size":5},{"text":"momentum","size":5},{"text":"measure","size":10},{"text":"direction","size":10},{"text":"car","size":5},{"text":"add","size":5},{"text":"traveled","size":5},{"text":"weight","size":5},{"text":"electrical","size":5},{"text":"power","size":5}];
*/
wordtagcloud("#tagcloudcontainer",450);
function wordtagcloud(element, height) {
	 var d3Container = d3.select(element),
    margin = {top: 5, right: 50, bottom: 20, left: 60},
    width = d3Container.node().getBoundingClientRect().width,
    height = height - margin.top - margin.bottom - 5;
		
		var container = d3Container.append("svg");
	var frequency_list = [
	 <%if (topterms.length() > 0) {
					for (int i = 0; i < topterms.length(); i++) {
						JSONObject jsonObj = topterms.getJSONObject(i);
						int size = Integer.parseInt(jsonObj.getString("frequency")) * 5;%>
		{"text":"<%=jsonObj.getString("key")%>","size":<%=size%>},
	 <%}
				}%>
	 ];
	var color = d3.scale.linear()
	.domain([0,1,2,3,4,5,6,10,12,15,20])
	.range(["#0080CC", "#FFBB78", "#CE0202", "#0080CC", "#72C28E", "#D6A78D", "#FF7E7E", "#666", "#555", "#444"]);
	var svg =  container;
	d3.layout.cloud().size([450,400])
	        .words(frequency_list)
	        .rotate(0)
	        .fontSize(function(d) { return d.size * 1.20; })
	        .on("end", draw)
	        .start();
	  
	function draw(words) {
		 		svg
	            .attr("width", width)
	            .attr("height", height)
	            //.attr("class", "wordcloud")
	            .append("g")
	            .attr("transform", "translate("+ width/2 +",180)")
	             .on("wheel", function() { d3.event.preventDefault(); })
	             .call(d3.behavior.zoom().on("zoom", function () {
	           	var g = svg.selectAll("g"); 
	           	g.attr("transform", "translate("+(width/2-10) +",180)" + " scale(" + d3.event.scale + ")")
	            })) 
	           
	    		
	            .selectAll("text")
	            .data(words)
	            .enter().append("text")
	            .style("font-size", 0)
	            .style("fill", function(d, i) { return color(i); })
	            .call(d3.behavior.drag()
	    		.origin(function(d) { return d; })
	    		.on("dragstart", dragstarted) 
	    		.on("drag", dragged)			
	    		)
	    		
	            .attr("transform", function(d) {
	                return "translate(" + [d.x + 12, d.y + 3] + ")rotate(" + d.rotate + ")";
	            })
	            .text(function(d) { return d.text; });
		 		
		 		// animation effect for tag cloud
		 		 $(element).bind('inview', function (event, visible) {
	       	  if (visible == true) {
	       		  svg.selectAll("text").transition()
	                 .delay(200)
	                 .duration(1000)
	                 .style("font-size", function(d) { return d.size * 0.93 + "px"; })
	       	  } else {
	       		  svg.selectAll("text")
	                 .style("font-size", 0)
	       	  }
	       	});
		 		
	           	function dragged(d) {
	           	 var movetext = svg.select("g").selectAll("text");
	           	 movetext.attr("dx",d3.event.x)
	           	 .attr("dy",d3.event.y)
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
	     
	 }
 </script>