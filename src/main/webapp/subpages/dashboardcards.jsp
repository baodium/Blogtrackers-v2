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
Object action = (null == request.getParameter("action")) ? "" : request.getParameter("action");
Object tid = (null == request.getParameter("tid")) ? "" : request.getParameter("tid");

PrintWriter out_ = response.getWriter();


Trackers tracker  = new Trackers();
Blogposts post  = new Blogposts();
Blogs blog  = new Blogs();

Terms term  = new Terms();

if(action.toString().equals("getkeywordstatus")){
	
	
	ArrayList details = DbConnection.query("select status, status_percentage from tracker_keyword where tid = " + tid);
	ArrayList res = (ArrayList)details.get(0);
	
	String status = res.get(0).toString();
	String status_percentage = res.get(1).toString();
	
	JSONObject final_result = new JSONObject();
	final_result.put("status_percentage",status_percentage);
	final_result.put("status",status);
	
	
	if(status.equals("1")){
		
		ArrayList response_terms = DbConnection.query("select terms from tracker_keyword where tid = " + tid);
		ArrayList result = (ArrayList)response_terms.get(0);
		//System.out.println("terms_result" + res.get(0));
		
		JSONObject final_terms = new JSONObject(result.get(0).toString());
		final_result.put("final_terms",final_terms);
		
		
	}else if(status.equals("0")){
		
		
		final_result.put("final_terms","");
	}
%>
	
<%=final_result.toString()%>
	
<% } %>	