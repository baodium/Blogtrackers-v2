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
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
Object date_start = (null == request.getParameter("date_start")) ? "" : request.getParameter("date_start");
Object date_end = (null == request.getParameter("date_end")) ? "" : request.getParameter("date_end");

Object blogger = (null == request.getParameter("blogger")) ? "" : request.getParameter("blogger");

Object blog_id = (null == request.getParameter("blog_id")) ? "" : request.getParameter("blog_id");
Object post_id = (null == request.getParameter("post_id")) ? "" : request.getParameter("post_id");

Object action = (null == request.getParameter("action")) ? "" : request.getParameter("action");
Object sort = (null == request.getParameter("sort")) ? "" : request.getParameter("sort");
Object tid = (null == request.getParameter("tid")) ? "" : request.getParameter("tid");

String bloggerstr = blogger.toString().replaceAll("_"," ");

Blogposts post  = new Blogposts();
ArrayList allentitysentiments = new ArrayList(); 


String dt = date_start.toString();
String dte = date_end.toString();
String year_start="";
String year_end="";	

if(action.toString().equals("gettotal")){
%>	
<%=post._searchRangeTotalByBlogger("date", dt, dte, blogger.toString())%>
<%}else if(action.toString().equals("gettotalinfluence")){%>
<%=post._searchRangeAggregateByBloggers("date", dt, dte, blogger.toString())%>	
<% }else if(action.toString().equals("getstats")){
	
	//String totalpost = post._searchRangeTotal("date", dt, dte, blog_id.toString());
	//String totalinfluence = post._searchRangeAggregate("date", dt, dte, blogger.toString());
	
	String totalpost = post._searchRangeTotalByBlogger("date",dt, dte, blogger.toString());
   String formattedtotalpost = NumberFormat.getNumberInstance(Locale.US).format(Integer.parseInt(totalpost));

	float totalinfluence  = Float.parseFloat(post._searchRangeMaxTotalByBloggers(blogger.toString()));

	String totalcomment =  new Comment()._getCommentByBlogger(blogger.toString());
	String formattedtotalcomment = NumberFormat.getNumberInstance(Locale.US).format(Integer.parseInt(totalcomment));

	//String totalcomment = post._searchRangeAggregate("date", dt, dte, blogger.toString(),"num_comments");
	
	//JSONArray sentimentpost = new JSONArray();
	/*
	ArrayList allauthors = post._getBloggerByBloggerName("date", dt, dte, blogger.toString(), "influence_score", "DESC");
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
				    sentimentpost.put(tobj.get("blogpost_id").toString());
			}
	} 	

	String possentiment=new Liwc()._searchRangeAggregate("date", date_start.toString(), date_end.toString(), sentimentpost,"posemo");
	String negsentiment=new Liwc()._searchRangeAggregate("date", date_start.toString(), date_end.toString(), sentimentpost,"negemo");
	*/
	Liwc liwc = new Liwc();
	
	String possentiment= liwc._getPosEmotionByBlogger(blogger.toString());
	String negsentiment  = liwc._getNegEmotionByBlogger(blogger.toString());

	int comb = Integer.parseInt(possentiment)+Integer.parseInt(negsentiment);
	
	Float highestinfluence = Float.parseFloat(post._searchMaxInfluence());
	Float lowestinfluence = Float.parseFloat(post._searchMinInfluence());



	Float highestsentiment = Float.parseFloat(liwc._getHighestPosSentiment());
	Float lowestsentiment = Float.parseFloat(liwc._getLowestNegSentiment());
	Float totalsentiment = Float.parseFloat(comb+"");

	int normalizedinfluence =  Math.round((2-(-2))*((totalinfluence-lowestinfluence)/(highestinfluence-lowestinfluence))+(-2));
	int normalizedsentiment =  Math.round((2-(-2))*((totalsentiment-lowestsentiment)/(highestsentiment-lowestsentiment))+(-2));

	String totalsenti  = comb+"";
	
	JSONObject result = new JSONObject();
	result.put("totalpost",totalpost);
	//result.put("totalinfluence",totalinfluence);

	result.put("totalinfluence",post.NormalizedOutput(normalizedinfluence+""));
	result.put("totalsentiment",totalsenti);
	result.put("totalsentiment",post.NormalizedOutput(normalizedsentiment+""));
	result.put("totalcomment",formattedtotalcomment);
%>
<%=result.toString()%>
 <% }else if(action.toString().equals("getmostacticelocation")){ 
	ArrayList allauthors=post._getBloggerByBloggerName("date",dt, dte,blogger.toString(),sort.toString(),"DESC");
	
	JSONObject locations = new JSONObject();
	
	String toplocation="";
	int tloc =0;
	if(allauthors.size()>0){
		
		String tres = null;
		JSONObject tresp = null;
		String tresu = null;
		JSONObject tobj = null;
		int j=0;
		int k=0;
		for(int i=0; i< allauthors.size(); i++){
			tres = allauthors.get(i).toString();	
			tresp = new JSONObject(tres);
			tresu = tresp.get("_source").toString();
			tobj = new JSONObject(tresu);
			
			String country = tobj.get("location").toString();
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
%>
<%=toplocation%>	
<% }else{
	ArrayList allauthors = new ArrayList();
if(action.toString().equals("fetchpost")){	
	allauthors = post._getPost("blogpost_id",post_id.toString());
	//System.out.println("posts hre"+allauthors);
}else{
	
	allauthors=post._getBloggerByBloggerName("date",dt, dte,blogger.toString(),sort.toString(),"DESC");
}
%>
<%
                                if(allauthors.size()>0){							
									String tres = null;
									JSONObject tresp = null;
									String tresu = null;
									JSONObject tobj = null;
									int j=0;
									int k=0;
									for(int i=0; i< 1; i++){
										tres = allauthors.get(i).toString();	
										tresp = new JSONObject(tres);
										tresu = tresp.get("_source").toString();
										tobj = new JSONObject(tresu);
										k++;
										
										String dat = tobj.get("date").toString().substring(0,10);
										LocalDate datee = LocalDate.parse(dat);
										DateTimeFormatter dtf = DateTimeFormatter.ofPattern("MMM dd, yyyy");
										String date = dtf.format(datee);
										
									%>    <h5 class="text-primary p20 pt0 pb0"><%=tobj.get("title")%></h5>
										<div class="text-center mb20 mt20">
											<a href="<%=request.getContextPath()%>/bloggerportfolio.jsp?tid=<%=tid%>&blogger=<%=tobj.get("blogger")%>">
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

											<%=tobj.get("post").toString()%>

										</div>
										</div>       
									                      
                     		<% }} %>
                               
<% } %>