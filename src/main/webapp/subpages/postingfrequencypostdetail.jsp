<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%@page import="authentication.*"%>
<%@page import="java.util.*"%>
<%@page import="util.*"%>
<%@page import="java.io.File"%>
<%@page import="util.Blogposts"%>
<%@page import="util.Blogs"%>
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
Object action = (null == request.getParameter("action")) ? "" : request.getParameter("action");
Object sort = (null == request.getParameter("sort")) ? "" : request.getParameter("sort");
Object tid = (null == request.getParameter("tid")) ? "" : request.getParameter("tid");


String bloggerstr = blogger.toString().replaceAll("_"," ");

Blogposts post  = new Blogposts();
Blogs blog  = new Blogs();
ArrayList allentitysentiments = new ArrayList(); 


String dt = date_start.toString();
String dte = date_end.toString();
String year_start="";
String year_end="";	

if(action.toString().equals("gettotal")){
	System.out.println("blogger:"+blogger.toString());
	
%>	
<%=post._searchRangeTotalByBlogger("date", dt, dte, blogger.toString())%>
<%}else if(action.toString().equals("gettotalinfluence")){%>
<%=post._searchRangeAggregateByBloggers("date", dt, dte, blogger.toString())%>	
<% }else if(action.toString().equals("getstats")){
	
	String totalpost = post._searchRangeTotal("date", dt, dte, blog_id.toString());
	String totalinfluence = post._searchRangeAggregate("date", dt, dte, blog_id.toString());
	
	String totalcomment = post._searchRangeAggregate("date", dt, dte, blog_id.toString(),"num_comments");
	
	JSONArray sentimentpost = new JSONArray();
	ArrayList allauthors = post._getBloggerByBlogId("date", dt, dte, blog_id.toString(), "influence_score", "DESC");
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
	
	int comb = Integer.parseInt(possentiment)+Integer.parseInt(negsentiment);

	String totalsenti  = comb+"";
	//String toplocation = blog._getTopLocation(blog_id.toString());
	
	JSONObject result = new JSONObject();
	result.put("totalpost",totalpost);
	result.put("totalinfluence",totalinfluence);
	result.put("totalsentiment",totalsenti);
	result.put("totalcomment",totalcomment);
	//result.put("toplocation",toplocation);
%>
<%=result.toString()%>
 <% }else if(action.toString().equals("getmostacticelocation")){ 
	 ArrayList blogs = blog._fetch(blog_id.toString());
	 String toplocation = "";//blog._getTopLocation(blog_id.toString());
	 if (blogs.size() > 0) {
			String bres = null;
			JSONObject bresp = null;
			
			String bresu = null;
			JSONObject bobj = null;
			
				bres = blogs.get(0).toString();
				bresp = new JSONObject(bres);
				bresu = bresp.get("_source").toString();
				bobj = new JSONObject(bresu);
				toplocation = bobj.get("location").toString();
				
				
	}
%>
<%=toplocation%>	
<% }else{
	//ArrayList allauthors = post._getBloggerByBloggerName("date",dt, dte,blogger.toString(),"influence_score","DESC");
	//System.out.println("bloggers:"+blogger.toString());
ArrayList allauthors=post._getBloggerByBloggerName("date",dt, dte,blogger.toString().toLowerCase(),sort.toString(),"DESC");
%>

<%
                                if(allauthors.size()>0){							
									String tres = null;
									JSONObject tresp = null;
									String tresu = null;
									JSONObject tobj = null;
									int j=0;
									int k=0;
									for(int i=allauthors.size(); i> allauthors.size()-1; i--){
										tres = allauthors.get(i-1).toString();	
										tresp = new JSONObject(tres);
										tresu = tresp.get("_source").toString();
										tobj = new JSONObject(tresu);
										String dat = tobj.get("date").toString().substring(0,10);
										LocalDate datee = LocalDate.parse(dat);
										DateTimeFormatter dtf = DateTimeFormatter.ofPattern("MMM dd, yyyy");
										String date = dtf.format(datee);
										
										k++;
									%>                                    
                                    <h5 class="text-primary p20 pt0 pb0"><%=tobj.get("title").toString().replaceAll("[^a-zA-Z]", " ")%></h5>
										<div class="text-center mb20 mt20">
											
											<button class="btn stylebuttonblue" onclick="window.location.href = '<%=request.getContextPath()%>/bloggerportfolio.jsp?tid=<%=tid%>&blogger=<%=tobj.get("blogger")%>'">
												<b class="float-left ultra-bold-text"><%=tobj.get("blogger")%></b> <i
													class="far fa-user float-right blogcontenticon"></i>
											</button>
											
											<button class="btn stylebuttonnocolor nocursor"><%=date%></button>
											<button class="btn stylebuttonnocolor nocursor">
												<b class="float-left ultra-bold-text"><%=tobj.get("num_comments")%> comments</b><i
													class="far fa-comments float-right blogcontenticon"></i>
											</button>
										</div>
										<div style="height: 600px;">
										<div class="p20 pt0 pb20 text-blog-content text-primary"
											style="height: 550px; overflow-y: scroll;">
											<%=tobj.get("post").toString().replaceAll("[^a-zA-Z]", " ")%>
										</div>
										</div>                      
                     		<% }} %>
                               
<% } %>