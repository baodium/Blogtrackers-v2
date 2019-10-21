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
System.out.println("--->"+date_start.toString()+"--->"+date_end.toString()+"--->"+ids.toString());

String sql = post._getMostKeywordDashboard(null,date_start.toString(),date_end.toString(),ids.toString());
//JSONObject json_type = new JSONObject();
Map<String, Integer> json_type = new HashMap<String, Integer>();

json_type=post._keywordTermvctors(sql);


/* JSONObject res=post._keywordTermvctors(sql); */
System.out.println("data--"+json_type);
System.out.println("action--"+action.toString());


	JSONObject result = new JSONObject(json_type);
	/* result.put("alltermsdata",res); */

	/* out_.println(json_type); */
session.setAttribute(action.toString(), json_type);
	
Object json_type_2 = (null == session.getAttribute(action.toString())) ? "" : session.getAttribute(action.toString());
	%>
	
	<%=result.toString()%>
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	