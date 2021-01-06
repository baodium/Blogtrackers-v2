<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
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
System.out.println("bloger oooo--"+blogger);

Object blog_id = (null == request.getParameter("blog_id")) ? "" : request.getParameter("blog_id");
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

//ArrayList allauthors = post._getBloggerByBloggerName("date",dt, dte,blogger.toString(),"influence_score","DESC");

//ArrayList allauthors = post._getBloggerByBloggerName("date",dt, dte,blogger.toString().toLowerCase(),sort.toString(),"DESC");

JSONObject allauthors = new JSONObject();

if (action.toString().equals("getchart")) {

allauthors = post._newGetBloggerByBloggerName("date", dt, dte, blogger.toString(), "DESC");
}else if(action.toString().equals("getchart_blogs")){
	System.out.println("I AM HERE POSTING");
	allauthors = post._getPostByBlogID(blog_id.toString(), dt, dte);
}
//System.out.println("sort"+sort);
%>
<link rel="stylesheet" href="assets/css/table.css" />
<link rel="stylesheet" href="assets/css/style.css" />
    <table id="DataTables_Table_0_wrapper" class="display" style="width:100%">
                        <thead>
                            <tr>
                                <th>Post title1</th>
                                <th><% if(sort.toString().equals("date")){ %> Date<% }else{ %>Influence Score <% }  %></th>
                            </tr>
                        </thead>
                        <tbody>
                                <%
        /*                         if(allauthors.size()>0){							
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
										String dat = tobj.get("date").toString().substring(0,10);
										LocalDate datee = LocalDate.parse(dat);
										DateTimeFormatter dtf = DateTimeFormatter.ofPattern("MMM dd, yyyy");
										String date = dtf.format(datee);
										
										k++; */
										
										
										
										Object hits_array = allauthors.getJSONArray("hit_array");
										  String resul = null;
										  
										  resul = hits_array.toString();
										  JSONArray all = new JSONArray(resul);
										if(all.length()>0){	  
										  	String tres = null;
											JSONObject tresp = null;
											String tresu = null;
											JSONObject tobj = null;
											String date =null;
											String activeDef = "";
											String activeDefLink = "";
											int j=0;
											int k=0;
											
											
											for(int i=0; i< all.length(); i++){
												tres = all.get(i).toString();	
												tresp = new JSONObject(tres);
												
												tresu = tresp.get("_source").toString();
												tobj = new JSONObject(tresu);
												
												Object date_ = tresp.getJSONObject("fields").getJSONArray("date").get(0);
												String dat = date_.toString().substring(0,10);
												LocalDate datee = LocalDate.parse(dat);
												DateTimeFormatter dtf = DateTimeFormatter.ofPattern("MMM dd, yyyy");
												date = dtf.format(datee);
												
												if (i == 0) {
													activeDefLink = "";
													activeDef = "activeselectedblog";
												}else{
												
													activeDefLink = "makeinvisible";
													activeDef = "";
												}
									%>
                                    <tr>
                                        <td><a  class="blogpost_link cursor-pointer <%=activeDef %>" id="<%=tobj.get("blogpost_id")%>" ><%=tobj.get("title") %><br/>
                                        <a id="viewpost_<%=tobj.get("blogpost_id")%>" class="mt20 viewpost <%=activeDefLink %>" href="<%=tobj.get("permalink") %>" target="_blank"><buttton class="btn btn-primary btn-sm mt10 visitpost">Visit Post &nbsp;<i class="fas fa-external-link-alt"></i></button></buttton></a></a></td>
                                       
                                        <td align="center">
                                        <% if(sort.toString().equals("date")){ %> <%=date %><% }else{ %><%=tobj.get("influence_score") %><% }  %>
                                        
                                        </td>
                                        
                                        <%-- <td><a class="blogpost_link cursor-pointer" id="<%=tobj.get("blogpost_id")%>" ><%=tobj.get("title") %></a><br/>
								<a class="mt20 viewpost makeinvisible" href="<%=tobj.get("permalink") %>" target="_blank"><buttton class="btn btn-primary btn-sm mt10 visitpost">Visit Post &nbsp;<i class="fas fa-external-link-alt"></i></buttton></a></td>
								<td align="center"><%=date %></td> --%>
                                    </tr>
                                    <% }} %>
                                </tbody>
                            </table>
                            
                           

<script type="text/javascript"
		src="assets/vendors/DataTables/datatables.min.js"></script>
			<script>
 $(document).ready(function() {
	 
	 
	$('#printdoc').on('click',function(){
		print();
	}) 
	
	 $(function () {
		    $('[data-toggle="tooltip"]').tooltip()
		  })
		  
		     $('#DataTables_Table_0_wrapper').DataTable( {
		         "scrollY": 430,
		         "scrollX": true,
		         "order": [],
		          "pagingType": "simple",
		        	  "columnDefs": [
		        	      { "width": "65%", "targets": 0 },
		        	      { "width": "25%", "targets": 0 }
		        	    ]
		       /*    ,
		          dom: 'Bfrtip',
		       buttons:{
		         buttons: [
		             { extend: 'pdfHtml5',orientation: 'potrait', pageSize: 'LEGAL', className: 'btn-primary stylebutton1'},
		             {extend:'csv',className: 'btn-primary stylebutton1'},
		             {extend:'excel',className: 'btn-primary stylebutton1'},
		            // {extend:'copy',className: 'btn-primary stylebutton1', text: 'Copy to Clipboard'},
		             {extend:'print',className: 'btn-primary stylebutton1'},
		         ]
		       } */
		     } );
	 
 } );
 
 
 
 </script>
	<!--end for table  -->