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

PrintWriter out_ = response.getWriter();


Trackers tracker  = new Trackers();
Blogposts post  = new Blogposts();
Blogs blog  = new Blogs();

Terms term  = new Terms();


//String sql = post._getMostKeywordDashboard(null,date_start.toString(),date_end.toString(),ids.toString());
//JSONObject json_type = new JSONObject();
//Map<String, Integer> json_type = new HashMap<String, Integer>();

//json_type=post._keywordTermvctors(sql);


/* JSONObject res=post._keywordTermvctors(sql); */
//System.out.println("data--"+json_type);
//System.out.println("action--"+action.toString());
if(action.toString().equals("getkeyworddashboard")){
	
	System.out.println(action+"--->"+date_start.toString()+"--->"+date_end.toString()+"--->"+ids.toString());
String dashboardterms = null;
dashboardterms = Clustering.getTopTermsFromDashboard(ids.toString(), date_start.toString(),date_end.toString() , "100");
System.out.println("terms --"+dashboardterms);
	//JSONObject result = new JSONObject(json_type);
	/* result.put("alltermsdata",res); */

	/* out_.println(json_type); */
//session.setAttribute(action.toString(), json_type);
	
//Object json_type_2 = (null == session.getAttribute(action.toString())) ? "" : session.getAttribute(action.toString());
	%>
	
	<%-- //<%=result.toString()%> --%>
 <div class="chart-container">
	<div class="chart" id="tagcloudcontainer" asertain="nerc"></div>
	<div class="jvectormap-zoomin zoombutton" id="zoom_in">+</div>
	<div class="jvectormap-zoomout zoombutton" id="zoom_out">−</div>
</div>



word cloud 
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
console.log('terms',jsonresult);
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
//System.out.println("terms_result" + jsonresult);
wordtagcloud("#tagcloudcontainer",450,jsonresult); 
console.log('terms',jsonresult);
</script>
	
<% } %>
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	