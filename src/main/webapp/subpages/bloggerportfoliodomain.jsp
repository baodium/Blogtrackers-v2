<%@page import="authentication.*"%>
<%@page import="java.util.*"%>
<%@page import="util.*"%>
<%@page import="java.io.File"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.net.URI"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	Object email = (null == session.getAttribute("email")) ? "" : session.getAttribute("email");
	Object tid = (null == request.getParameter("tid")) ? "" : request.getParameter("tid");

	Object user = (null == session.getAttribute("username")) ? "" : session.getAttribute("username");
	String date_start = (null == request.getParameter("date_start")) ? "" : request.getParameter("date_start");
	String date_end = (null == request.getParameter("date_end")) ? "" : request.getParameter("date_end");
	String blogger = (null == request.getParameter("blogger")) ? "" : request.getParameter("blogger");
	String sort =  (null == request.getParameter("sortby")) ? "blog" : request.getParameter("sortby").toString().replaceAll("[^a-zA-Z]", " ");
	String listtype =  (null == request.getParameter("listtype")) ? "ulr" : request.getParameter("listtype").toString().replaceAll("[^a-zA-Z]", " ");
	
	String selectedblog_id="";

			ArrayList<?> userinfo = null;
			String profileimage = "";
			String username = "";
			ArrayList outlinks = new ArrayList();
			
			Trackers tracker = new Trackers();
			Outlinks outl = new Outlinks();
			Blogposts post = new Blogposts();
			String ids = "";
			
			ArrayList allauthors2 = post._getBloggerByBloggerName("date", date_start, date_end, blogger, "influence_score", "DESC");
			
			//System.out.println("all authors"+allauthors2);
			if(allauthors2.size()>0){
				String tres = null;
				JSONObject tresp = null;
				String tresu = null;
				JSONObject tobj = null;
				int j=0;
				int k=0;
				int n = 0;
				for(int i=0; i< allauthors2.size(); i++){
							tres = allauthors2.get(i).toString();			
							tresp = new JSONObject(tres);
						    tresu = tresp.get("_source").toString();
						    tobj = new JSONObject(tresu);	
						    String bloggerr = tobj.get("blogger").toString();
						    String blog_id = tobj.get("blogsite_id").toString();
						    if(bloggerr.equals(blogger)){
						    	selectedblog_id = blog_id;
						    }
						    ids+=tobj.get("blogpost_id").toString()+",";
					}
			} 	

			
			
			
		

			outlinks = outl._searchByRange("date",date_start, date_end, selectedblog_id);

			//outlinks = outl._searchByRange("date", date_start, date_end,blogger);
		
			JSONObject outerlinks = new JSONObject();
			ArrayList outlinklooper = new ArrayList();
			if (outlinks.size() > 0) {
				int mm=0;
				for (int p = 0; p < outlinks.size(); p++) {
					String bstr = outlinks.get(p).toString();
					JSONObject bj = new JSONObject(bstr);
					bstr = bj.get("_source").toString();
					bj = new JSONObject(bstr);
					String link = bj.get("link").toString();
					
					JSONObject content = new JSONObject();
					String maindomain="";
					try {
						URI uri = new URI(link);
						String domain = bj.get("link").toString();
						if (domain.startsWith("www.")) {
							maindomain = domain.substring(4);
						} else {
							maindomain = domain;
						}
					} catch (Exception ex) {}
						maindomain = bj.get("domain").toString();
						if (outerlinks.has(link)) {
							content = new JSONObject(outerlinks.get(link).toString());
							
							int valu = Integer.parseInt(content.get("value").toString());
							valu++;
							
							content.put("value", valu);
							content.put("link", link);
							content.put("domain", maindomain);
							outerlinks.put(link, content);
						} else {
							int valu = 1;
							content.put("value", valu);
							content.put("link", link);
							content.put("domain", maindomain);
							outerlinks.put(link, content);
							outlinklooper.add(mm, link);
							mm++;
						}		
					
			}

		}
%>

<link rel="stylesheet" href="assets/css/table.css" />
<link rel="stylesheet" href="assets/css/style.css" />
  <table id="DataTables_Table_0_wrapper" class="display" style="width:100%">


                        <thead>
                            <tr>
                                <th>Domain</th>
                                <th>Frequency</th>


                            </tr>
                        </thead>
                        <tbody>
                            <%
										if (outlinklooper.size() > 0) {
													//System.out.println(bloggers);
													for (int y = 0; y < outlinklooper.size(); y++) {
														String key = outlinklooper.get(y).toString();
														JSONObject resu = outerlinks.getJSONObject(key);
									%>
									<tr>
										<td class=""><a href="http://<%=resu.get("domain")%>" target="_blank"><%=resu.get("domain")%></a></td>
										<td><%=resu.get("value")%></td>
									</tr>
									<%
										}
									}
									%>                     
                        </tbody>

</table>

<script type="text/javascript" src="assets/vendors/DataTables/datatables.min.js"></script>						
									
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
         "scrollX": 250,
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


	<!--end for table  -->	

 </script>

