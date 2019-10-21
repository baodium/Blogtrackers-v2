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
Object blog_id = (null == request.getParameter("blog_id")) ? "" : request.getParameter("blog_id");

Object sort = (null == request.getParameter("sort")) ? "" : request.getParameter("sort");

String bloggerstr = blogger.toString().replaceAll("_"," ");

Trackers tracker  = new Trackers();
Blogposts post  = new Blogposts();
Blogs blog  = new Blogs();
		String dt = date_start.toString();
		String dte = date_end.toString();
		String year_start="";
		String year_end="";		
		
		JSONObject authoryears = new JSONObject();
		JSONObject years = new JSONObject();
		JSONArray yearsarray = new JSONArray();
		String[] yst = dt.split("-");
		String[] yend = dte.split("-");
		year_start = yst[0];
		year_end = yend[0];
		
		int base = 0;
		int ystint = Integer.parseInt(year_start);
		int yendint = Integer.parseInt(year_end);
		
				int b=0;
				JSONObject postyear =new JSONObject();
				for(int y=ystint; y<=yendint; y++){ 
						   String dtu = y + "-01-01";
						   String dtue = y + "-12-31";
						   String totu = "0";
						   if(b==0){
								dtu = dt;
							}else if(b==yendint){
								dtue = dte;
							}
						  
						  
						   totu = post._searchRangeMaxByBloggers("date",dtu, dtue,bloggerstr);
						   
						   if(new Double(totu).intValue() <base){
							   base = new Double(totu).intValue();
						   }
						   if(!years.has(y+"")){
					    		years.put(y+"",y);
					    		yearsarray.put(b,y);
					    		b++;
					    	}
						   
						   postyear.put(y+"",totu);
				}
				
				//authoryears.put(bloggerstr,postyear);
				
				base = Math.abs(base);
				if(postyear.length()>0){
						for(int y=ystint; y<=yendint; y++){ 
								   String v1 = postyear.get(y+"").toString();
								  
								   postyear.put(y+"",(new Double(v1).intValue())+base);
						}					
				}
				authoryears.put(bloggerstr,postyear);
%>



<script>

var data = [
    
	  {
	        name: "<%=blogger%>",
	        values: 
	        	[
	        	
	        	
  
  		<% 
		  		String au = bloggerstr;
		  		JSONObject specific_auth= new JSONObject(authoryears.get(au).toString());
		  		for(int q=0; q<yearsarray.length(); q++){ 
			  
			  		String yearr=yearsarray.get(q).toString(); 
			  		if(specific_auth.has(yearr)){ %>
			  			{"date":"<%=yearr%>","price":<%=specific_auth.get(yearr) %>},
				<%
			  		}else{ %>
			  			{"date":"<%=yearr%>","price":0},
		   		<% } %>
			<%  
		  		}%>
		  		
		  		
		  		]
		  
		  
		  
		  	
	  
	  
	  }
		  
		  ];
</script>

