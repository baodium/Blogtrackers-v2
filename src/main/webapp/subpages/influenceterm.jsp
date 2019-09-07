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
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>

<%
Object date_start = (null == request.getParameter("date_start")) ? "" : request.getParameter("date_start");
Object date_end = (null == request.getParameter("date_end")) ? "" : request.getParameter("date_end");
//Object post_ids = (null == request.getParameter("post_ids")) ? "" : request.getParameter("post_ids");
Object blogger = (null == request.getParameter("blogger")) ? "" : request.getParameter("blogger");

Object bloggerId = (null == request.getParameter("bloggerId")) ? "" : request.getParameter("bloggerId");
System.out.println(bloggerId);

Object action = (null == request.getParameter("action")) ? "" : request.getParameter("action");

String dt = date_start.toString();
String dte = date_end.toString();
//ArrayList allterms = new Terms()._searchByRange("blogsiteid", dt, dte, post_ids.toString());
int highestfrequency = 0;

ArrayList allterms = new Terms().getTermsByBlogger(blogger.toString(), dt.toString(), dte.toString());

String mostusedkeyword="";
Map<String, Integer> topterms = new HashMap<String, Integer>();
if (allterms.size() > 0) {
	for (int p = 0; p < allterms.size(); p++) {
		String bstr = allterms.get(p).toString();
		JSONObject bj = new JSONObject(bstr);
		bstr = bj.get("_source").toString();
		bj = new JSONObject(bstr);
		String tm = bj.get("term").toString();
		String frequency = bj.get("frequency").toString();
		int frequency2 = Integer.parseInt(frequency);
		
		int freq = frequency2;
		if (topterms.containsKey(tm)) {
			topterms.put(tm, topterms.get(tm) + frequency2);
			freq= topterms.get(tm) + frequency2;
		} else {
			topterms.put(tm, frequency2);
		}
		
		if(freq>highestfrequency){
			highestfrequency = freq;
			mostusedkeyword = tm;
		}
	}
}





if(action.toString().equals("gettopkeyword")){%>
<%=mostusedkeyword%>
<%}else{ 
%>
<!-- <div class="tagcloudcontainer" style="min-height: 420px;">
</div> -->	

 <div class="chart-container">
 <div class="chart" id="tagcloudcontainer"></div>
 <div class="jvectormap-zoomin zoombutton" id="zoom_in">+</div>
								<div class="jvectormap-zoomout zoombutton" id="zoom_out" >−</div> 
</div>
       


<!--word cloud  -->
 <script type="text/javascript" src="assets/vendors/d3/d3.min.js"></script>
 <script src="assets/vendors/wordcloud/d3.layout.cloud.js"></script>
 <script type="text/javascript" src="assets/vendors/d3/d3_tooltip.js"></script>
 <script type="text/javascript" src="assets/js/jquery.inview.js"></script>
 <script type="text/javascript"
		src="chartdependencies/keywordtrendd3.js"></script>
 <script>
 /*
     var frequency_list = [{"text":"study","size":40},{"text":"motion","size":15},{"text":"forces","size":10},{"text":"electricity","size":15},{"text":"movement","size":10},{"text":"relation","size":5},{"text":"things","size":10},{"text":"force","size":5},{"text":"ad","size":5},{"text":"energy","size":85},{"text":"living","size":5},{"text":"nonliving","size":5},{"text":"laws","size":15},{"text":"speed","size":45},{"text":"velocity","size":30},{"text":"define","size":5},{"text":"constraints","size":5},{"text":"universe","size":10},{"text":"distinguished","size":5},{"text":"chemistry","size":5},{"text":"biology","size":5},{"text":"includes","size":5},{"text":"radiation","size":5},{"text":"sound","size":5},{"text":"structure","size":5},{"text":"atoms","size":5},{"text":"including","size":10},{"text":"atomic","size":10},{"text":"nuclear","size":10},{"text":"cryogenics","size":10},{"text":"solid-state","size":10},{"text":"particle","size":10},{"text":"plasma","size":10},{"text":"deals","size":5},{"text":"merriam-webster","size":5},{"text":"dictionary","size":10},{"text":"analysis","size":5},{"text":"conducted","size":5},{"text":"order","size":5},{"text":"understand","size":5},{"text":"behaves","size":5},{"text":"en","size":5},{"text":"wikipedia","size":5},{"text":"wiki","size":5},{"text":"physics-","size":5},{"text":"physical","size":5},{"text":"behaviour","size":5},{"text":"collinsdictionary","size":5},{"text":"english","size":5},{"text":"time","size":35},{"text":"distance","size":35},{"text":"wheels","size":5},{"text":"revelations","size":5},{"text":"minute","size":5},{"text":"acceleration","size":20},{"text":"torque","size":5},{"text":"wheel","size":5},{"text":"rotations","size":5},{"text":"resistance","size":5},{"text":"momentum","size":5},{"text":"measure","size":10},{"text":"direction","size":10},{"text":"car","size":5},{"text":"add","size":5},{"text":"traveled","size":5},{"text":"weight","size":5},{"text":"electrical","size":5},{"text":"power","size":5}];
*/
var word_count2 = {};



<%if (topterms.size() > 0) {
	for (String terms : topterms.keySet()) {
		int size = topterms.get(terms);%>
		 word_count2["<%=terms.toString()%>"] = <%=size%> 
	<%}}%>
	
wordtagcloud("#tagcloudcontainer",450,word_count2);	
	
<%-- wordtagcloud("#tagcloudcontainer",450);
function wordtagcloud(element, height) {
	 var d3Container = d3.select(element),
    margin = {top: 5, right: 50, bottom: 20, left: 60},
    width = d3Container.node().getBoundingClientRect().width,
    height = height - margin.top - margin.bottom - 5;
		
		var container = d3Container.append("svg");
	var frequency_list = [<%if (topterms.size() > 0) {
		for (String terms : topterms.keySet()) {
			int size = topterms.get(terms);%>
			{"text":"<%=terms.toString()%>","size":<%=size%>},
		<%}}%>];
	var color = d3.scale.linear()
	.domain([0,1,2,3,4,5,6,10,12,15,20])
	.range(["#0080CC", "#FFBB78", "#CE0202", "#0080CC", "#72C28E", "#D6A78D", "#FF7E7E", "#666", "#555", "#444"]);
	var svg =  container;
	d3.layout.cloud().size([450,400])
	        .words(frequency_list)
	        .rotate(0)
	        .padding(7)
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
           g.attr("transform", "translate("+(width/2-10) +",180)" + " scale(" + d3.event.scale + ")").style("cursor","zoom-out")
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
               .style("font-size", function(d) { return d.size * 1.10 + "px"; })
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
	 		        "translate(" + (width/2-10) + ",180)" +
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
	 	        factor = 0.2,
	 	        target_zoom = 1,
	 	        center = [width / 2-10, "180"],
	 	        extent = zoom.scaleExtent(),
	 	        translate = zoom.translate(),
	 	        translate0 = [],
	 	        l = [],
	 	        view = {x: translate[0], y: translate[1], k: zoom.scale()};

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
	     
	 } --%>
 </script>
 <% } %>