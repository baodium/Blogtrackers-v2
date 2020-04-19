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
	//Object post_ids = (null == request.getParameter("post_ids")) ? "" : request.getParameter("post_ids");

	Object action = (null == request.getParameter("action")) ? "" : request.getParameter("action");
	Object blogger = (null == request.getParameter("blogger")) ? "" : request.getParameter("blogger");
	Object tid = (null == request.getParameter("tid")) ? "" : request.getParameter("tid");

	String dt = date_start.toString();
	String dte = date_end.toString();
	
	//String pids = new Blogposts()._getPostIdsByBloggerName("date", dt, dte, blogger.toString(), "date", "DESC");

	//ArrayList allterms = new Terms()._searchByRange("blogpostid", dt, dte, pids);//_searchByRange(dt, dte, post_ids.toString());
	Object all_blog_ids = (null == request.getParameter("all_blog_ids"))
			? ""
			: request.getParameter("all_blog_ids");

	int highestfrequency = 0;

	Blogposts post = new Blogposts();
	JSONArray topterms = new JSONArray();
	JSONObject keys = new JSONObject();
	String mostusedkeyword = "";
/* 	if (allterms.size() > 0) {
		for (int p = 0; p < allterms.size(); p++) {
			String bstr = allterms.get(p).toString();
			JSONObject bj = new JSONObject(bstr);
			bstr = bj.get("_source").toString();
			bj = new JSONObject(bstr);
			String frequency = bj.get("frequency").toString();
			int freq = Integer.parseInt(frequency);

			String tm = bj.get("term").toString();
			if (freq > highestfrequency) {
				highestfrequency = freq;
				mostusedkeyword = tm;
			}

			JSONObject cont = new JSONObject();
			cont.put("key", tm);
			cont.put("frequency", frequency);
			if (!keys.has(tm)) {
				keys.put(tm, tm);
				/* topterms.put(cont); */
/* 			}
		}
	} */ 
String bloggerterms = null;
	if (action.toString().equals("gettopkeyword")) {
%>
<%=bloggerterms.split(")")[0]%>
<%
	} else {
		
		bloggerterms = Clustering.getTopTermsFromBlogger(blogger.toString(), dt,dte , "100");
		System.out.println("terms --"+bloggerterms);
%>
<!-- <div class="tagcloudcontainer" style="min-height: 420px;">
</div> -->

<div class="chart-container">
	<div class="chart" id="tagcloudcontainer"></div>
	<div class="jvectormap-zoomin zoombutton" id="zoom_in">+</div>
	<div class="jvectormap-zoomout zoombutton" id="zoom_out">−</div>
</div>



<!--word cloud  -->
<script type="text/javascript" src="assets/vendors/d3/d3.min.js"></script>
<script src="assets/vendors/wordcloud/d3.layout.cloud.js"></script>
<script type="text/javascript" src="assets/vendors/d3/d3_tooltip.js"></script>
<script type="text/javascript" src="assets/js/jquery.inview.js"></script>
<script type="text/javascript" src="chartdependencies/keywordtrendd3.js"></script>
<script>
 /*
     var frequency_list = [{"text":"study","size":40},{"text":"motion","size":15},{"text":"forces","size":10},{"text":"electricity","size":15},{"text":"movement","size":10},{"text":"relation","size":5},{"text":"things","size":10},{"text":"force","size":5},{"text":"ad","size":5},{"text":"energy","size":85},{"text":"living","size":5},{"text":"nonliving","size":5},{"text":"laws","size":15},{"text":"speed","size":45},{"text":"velocity","size":30},{"text":"define","size":5},{"text":"constraints","size":5},{"text":"universe","size":10},{"text":"distinguished","size":5},{"text":"chemistry","size":5},{"text":"biology","size":5},{"text":"includes","size":5},{"text":"radiation","size":5},{"text":"sound","size":5},{"text":"structure","size":5},{"text":"atoms","size":5},{"text":"including","size":10},{"text":"atomic","size":10},{"text":"nuclear","size":10},{"text":"cryogenics","size":10},{"text":"solid-state","size":10},{"text":"particle","size":10},{"text":"plasma","size":10},{"text":"deals","size":5},{"text":"merriam-webster","size":5},{"text":"dictionary","size":10},{"text":"analysis","size":5},{"text":"conducted","size":5},{"text":"order","size":5},{"text":"understand","size":5},{"text":"behaves","size":5},{"text":"en","size":5},{"text":"wikipedia","size":5},{"text":"wiki","size":5},{"text":"physics-","size":5},{"text":"physical","size":5},{"text":"behaviour","size":5},{"text":"collinsdictionary","size":5},{"text":"english","size":5},{"text":"time","size":35},{"text":"distance","size":35},{"text":"wheels","size":5},{"text":"revelations","size":5},{"text":"minute","size":5},{"text":"acceleration","size":20},{"text":"torque","size":5},{"text":"wheel","size":5},{"text":"rotations","size":5},{"text":"resistance","size":5},{"text":"momentum","size":5},{"text":"measure","size":10},{"text":"direction","size":10},{"text":"car","size":5},{"text":"add","size":5},{"text":"traveled","size":5},{"text":"weight","size":5},{"text":"electrical","size":5},{"text":"power","size":5}];
*/

var terms = <%=bloggerterms.toString()%>
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

//var new_dd = terms.replace('[','{').replace(']','}').replace(/\),/g,'-').replace(/\(/g,'').replace(/,/g,':').replace(/-/g,',').replace(/\)/g,'').replace(/'/g,'');
console.log('terms',jsonresult);
wordtagcloud("#tagcloudcontainer",450,jsonresult); 
$(".most-used-keyword").html(currentkey);


<%-- var word_count2 = {}; 

<%if (topterms.length() > 0) {
	 for (int i = 0; i < topterms.length(); i++) {
		 JSONObject jsonObj = topterms.getJSONObject(i);
			int size = Integer.parseInt(jsonObj.getString("frequency"));%>
		{"text":"<%=terms.toString() %>","size":<%=size %>},
		 word_count2["<%=jsonObj.getString("key")%>"] = <%=size%> 
<%}
	}%>

	<%/* outlinks = outl._searchByRange("date", dt, dte, ids); */
				JSONObject d = new JSONObject();
				String highest = null;
				
		        String[] arrOfStrStart = date_start.toString().split("-");
		        String[] arrOfStrEnd = date_end.toString().split("-");
		        
		        List<String> itemListStart = Arrays.asList(arrOfStrStart);
		        List<String> itemListEnd = Arrays.asList(arrOfStrEnd);
		        
		        String dateStartNew = itemListStart.get(0);
		        String dateEndNew = itemListEnd.get(0);
		        
				if (null == session.getAttribute(blogger.toString() + "_wordcloud_" + tid.toString()+ dateStartNew + dateEndNew)) {

					try {
						String sql = post._getMostKeywordDashboard(blogger.toString(), dt, dte,
								all_blog_ids.toString());
						Map<String, Integer> res = new HashMap<String, Integer>();

						res = post._keywordTermvctors(sql);

						Map.Entry<String, Integer> entry1 = res.entrySet().iterator().next();
						highest = entry1.getKey();

						/* /* JSONObject res=post._keywordTermvctors(sql); */
						d = new JSONObject();
						d.put("data", res);
						d.put("highest", highest);

						String s = res.toString();
						JSONObject o = new JSONObject(res);

						/* Map<String, Integer> json = (HashMap<String, Integer>)json_type_2; */

						System.out.println("testing w---" + res);

						session.setAttribute(blogger.toString() + "_wordcloud_" + tid.toString()+ dateStartNew + dateEndNew, d);
						session.setAttribute(blogger.toString() + "_topkeyword_" + tid.toString()+ dateStartNew + dateEndNew, d.get("highest"));%>

	wordtagcloud("#tagcloudcontainer",450,<%=d.get("data")%>); 
	wordtagcloud("#tagcloudcontainer",450,<%=d%>); 
	console.log("session not collected");
	console.log(<%=d.get("data")%>);
	$('.most-used-keyword').html("<%=d.get("highest")%>");
	
	<%} catch (Exception e) {%>
	
	wordtagcloud("#tagcloudcontainer",450,{'NO KEYWORDS':1});
	
	
	<%}

				} else {

					Object d_ = (null == session.getAttribute(blogger.toString() + "_wordcloud_" + tid.toString()+ dateStartNew + dateEndNew))
							? ""
							: session.getAttribute(blogger.toString() + "_wordcloud_" + tid.toString()+ dateStartNew + dateEndNew);

					JSONObject ddd = new JSONObject(d_.toString());
					System.out.println("tester" + ddd);%>
	console.log("session collected");
	console.log(<%=ddd.get("data")%>);
	console.log("<%=ddd.get("highest")%>");
	
	wordtagcloud("#tagcloudcontainer",450,<%=ddd.get("data")%>); 
	$('.most-used-keyword').html("<%=ddd.get("highest")%>");	

	
	<%}%> --%>
/* wordtagcloud("#tagcloudcontainer",450,word_count2); */

<%-- wordtagcloud("#tagcloudcontainer",450);
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
						int size = Integer.parseInt(jsonObj.getString("frequency")) * 2;%>
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
<%
	}
	if (action.toString().equals("")) {
%>


<%
	}
%>









