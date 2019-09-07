<%@page import="authentication.*"%>
<%@page import="java.util.*"%>
<%@page import="util.*"%>
<%@page import="java.io.File"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.net.URI"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	
<%
	Object email = (null == session.getAttribute("email")) ? "" : session.getAttribute("email");
	Object tid = (null == request.getParameter("tid")) ? "" : request.getParameter("tid");
	
	
	Object user = (null == session.getAttribute("username")) ? "" : session.getAttribute("username");
	String key= request.getParameter("key").replaceAll("\\<.*?\\>", "");
	String value= request.getParameter("value").replaceAll("\\<.*?\\>", "");
	String source = request.getParameter("source").replaceAll("\\<.*?\\>", "");
	String section = request.getParameter("section").replaceAll("\\<.*?\\>", "");
	String year = value;//request.getParameter("date").replaceAll("\\<.*?\\>", "");
	String postids = request.getParameter("post_ids");
	
	 String date_start = year + "-01-01";
	 String date_end = year + "-12-31";
	JSONArray postlist = new JSONArray(postids);
	//ArrayList allauthors =new Blogposts()._getBloggerByBlogId("date",date_start, date_end,postids);
	
	 ArrayList allauthors = new Blogposts()._getPostByBlogpostId("date",date_start, date_end,postlist);
			
%>
<link rel="stylesheet" href="assets/css/table.css" />
<link rel="stylesheet" href="assets/css/style.css" />


<table id="DataTables_Table_0_wrapper" class="display"
						style="width: 100%">
						<thead>
							<tr>
								<th class="bold-text">SN</th>
								<th class="bold-text">Post title</th>
								<th class="bold-text">Blogger</th>


							</tr>
						</thead>
						<tbody>
							
							<%	int y=0; if(allauthors.size()>0){
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
										    
										    String auth = tobj.get("blogger").toString();
										    String color="";
										   /*  if(i%2==0){
										    	color="#CC3300";
										    }else if(i%3 ==0){
										    	color="#EE33FF";
										    }else if(i%7 ==0){
										    	color="#28a745";
										    }else if(i%11 ==0){
										    	color="#3728a7";
										    }else if(i%17 ==0){
										    	color="#17a2b8";
										    }else {
										    	color="#000000";
										    } */
										   if(i == 0)
												{
												color = "#0080CC";	
												} 
										    
										    y++;
					    %>
							<tr>
								<td align="center"><%=(y)%></td>
								<td><a class="blogpost_link cursor-pointer" id="<%=tobj.get("blogpost_id")%>-<%=color%>-<%=(y)%>" onclick="loadChart('<%=tobj.get("blogpost_id")%>-<%=color%>-<%=(y)%>')" <%-- style="color:<%=color%>" --%>><%=tobj.get("title").toString() %></a>
								<br/>
								 <a class="mt20 viewpost makeinvisible" href="<%=tobj.get("permalink") %>" target="_blank"><buttton class="btn btn-primary btn-sm mt10 visitpost">Visit Post &nbsp;<i class="fas fa-external-link-alt"></i></buttton></a>
								
								</td>
								<td align="center"><%=tobj.get("blogger").toString() %></td>
							</tr>
						<% }} %>
							
							
						</tbody>
					</table>
					<script type="text/javascript"
		src="assets/vendors/DataTables/datatables.min.js"></script>
			<script>
 $(document).ready(function() {
	 
	/*  function PrintElem(elem)
	 {
	     var mywindow = window.open('', 'PRINT', 'height=400,width=600');

	     mywindow.document.write('<html><head><title>' + document.title  + '</title>');
	     mywindow.document.write('</head><body >');
	     mywindow.document.write('<h1>' + document.title  + '</h1>');
	     mywindow.document.write(document.getElementById(elem).innerHTML);
	     mywindow.document.write('</body></html>');

	     mywindow.document.close(); // necessary for IE >= 10
	     mywindow.focus(); // necessary for IE >= 10*/

	   /*  mywindow.print();
	     mywindow.close();

	     return true;
	 } */
 
	$('#printdoc').on('click',function(){
		print();
	}) 
	
	 $(function () {
		    $('[data-toggle="tooltip"]').tooltip()
		  })
		  
     $('#DataTables_Table_1_wrapper').DataTable( {
         "scrollY": 430,
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


	 
     $('#DataTables_Table_0_wrapper').DataTable( {
         "scrollY": 320,
         "order": [[ 0, "asc" ]],
         "pagingType": "simple",
        /*   dom: 'Bfrtip',

                    "columnDefs": [
                 { "width": "80%", "targets": 0 }
               ] */
    /*  ,
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
 <script src="pagedependencies/sentiment2.js"></script>
	<!--end for table  -->

