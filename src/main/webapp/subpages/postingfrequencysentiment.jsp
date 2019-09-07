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

Object postids = (null == request.getParameter("post_ids")) ? "" : request.getParameter("post_ids");

String bloggerstr = blogger.toString().replaceAll("_"," ");
Blogpost_entitysentiment blogpostsentiment  = new Blogpost_entitysentiment();
ArrayList allentitysentiments = new ArrayList(); 
String dt = date_start.toString();
String dte = date_end.toString();
String year_start="";
String year_end="";	
String pids = new Blogposts()._getPostIdsByBloggerName("date",dt, dte,blogger.toString(),"date","DESC");

allentitysentiments = blogpostsentiment._searchByRange("date", dt, dte, pids);
%>
<link rel="stylesheet" href="assets/css/table.css" />
<link rel="stylesheet" href="assets/css/style.css" />
<table id="DataTables_Table_1_wrapper" class="display" style="width:100%">
                                <thead>
                                    <tr>
                                        <th>Entity</th>
                                        <th>Type</th>
                                        <th>Sentiment</th>

                                    </tr>
                                </thead>
                                <tbody>
                                <%
                                if(allentitysentiments.size()>0){							
									String tres = null;
									JSONObject tresp = null;
									String tresu = null;
									JSONObject tobj = null;
									int j=0;
									int k=0;
									for(int i=0; i< allentitysentiments.size(); i++){
										tres = allentitysentiments.get(i).toString();	
										tresp = new JSONObject(tres);
										tresu = tresp.get("_source").toString();
										tobj = new JSONObject(tresu);
									%>
                                    <tr>
                                        <td><%=tobj.get("entity").toString() %></td>
                                        <td><%=tobj.get("type").toString() %></td>
                                    
                                        <td><%=tobj.get("sentiment").toString() %></td>
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
		  
     $('#DataTables_Table_1_wrapper').DataTable( {
         "scrollY": 250,
          "pagingType": "simple",
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