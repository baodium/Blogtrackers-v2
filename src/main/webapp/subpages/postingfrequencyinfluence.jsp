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

Object blog_id = (null == request.getParameter("blog_id")) ? "" : request.getParameter("blog_id");
Object action = (null == request.getParameter("action")) ? "" : request.getParameter("action");
Object sort = (null == request.getParameter("sort")) ? "" : request.getParameter("sort");


String bloggerstr = blogger.toString().replaceAll("_"," ");

Blogposts post  = new Blogposts();
ArrayList allentitysentiments = new ArrayList(); 


String dt = date_start.toString();
String dte = date_end.toString();
String year_start="";
String year_end="";	

//ArrayList allauthors = post._getBloggerByBloggerName("date",dt, dte,blogger.toString(),"influence_score","DESC");
ArrayList allauthors = post._getBloggerByBloggerName("date",dt, dte,blogger.toString().toLowerCase(),sort.toString(),"DESC");
//System.out.println("sort"+sort);
%>
<link rel="stylesheet" href="assets/css/table.css" />
<link rel="stylesheet" href="assets/css/style.css" />
    <table id="DataTables_Table_0_wrapper" class="display" style="width:100%">
                        <thead>
                            <tr>
                                <th>Post title</th>
                                <th><% if(sort.toString().equals("date")){ %> Date<% }else{ %>Influence Score <% }  %></th>
                            </tr>
                        </thead>
                        <tbody>
                                <%
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
										String dat = tobj.get("date").toString().substring(0,10);
										LocalDate datee = LocalDate.parse(dat);
										DateTimeFormatter dtf = DateTimeFormatter.ofPattern("MMM dd, yyyy");
										String date = dtf.format(datee);
										
										k++;
									%>
                                    <tr>
                                        <td><a  class="blogpost_link cursor-pointer" id="<%=tobj.get("blogpost_id")%>" ><%=tobj.get("title") %><br/>
                                        <a class="mt20 viewpost makeinvisible" href="<%=tobj.get("permalink") %>" target="_blank"><buttton class="btn btn-primary btn-sm mt10 visitpost">Visit Post &nbsp;<i class="fas fa-external-link-alt"></i></button></buttton></a></a></td>
                                       
                                        <td align="center">
                                        <% if(sort.toString().equals("date")){ %> <%=date %><% }else{ %><%=tobj.get("influence_score") %><% }  %>
                                        
                                        </td>
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
          "pagingType": "simple",
          "columnDefs": [
    	      { "width": "75%", "targets": 0 },
    	      { "width": "25%", "targets": 0 }
    	    ]
         /*  dom: 
        	   'Bfrtip', 
                    "columnDefs": [
                 { "width": "80%", "targets": 0 }
               ]  */
  /*    ,
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