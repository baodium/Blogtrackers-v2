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
	String single = (null == request.getParameter("sortdate")) ? "" : request.getParameter("sortdate");
	String sort =  (null == request.getParameter("sortby")) ? "blog" : request.getParameter("sortby").toString().replaceAll("[^a-zA-Z]", " ");
	String listtype =  (null == request.getParameter("listtype")) ? "urls" : request.getParameter("listtype").toString().replaceAll("[^a-zA-Z]", " ");
	

	if (user == null || user == "") {
		response.sendRedirect("index.jsp");
	} else {

			ArrayList<?> userinfo = null;
			String profileimage = "";
			String username = "";
			ArrayList outlinks = new ArrayList();
			ArrayList detail = new ArrayList();
			
			Trackers tracker = new Trackers();
			Outlinks outl = new Outlinks();
		
			String ids = "";
			String trackername="";
			if (tid != "") {
				detail = tracker._fetch(tid.toString());
			} else {
				detail = tracker._list("DESC", "", user.toString(), "1");
			}
			
			if (detail.size() > 0) {
				ArrayList resp = (ArrayList<?>)detail.get(0);
				String tracker_userid = resp.get(0).toString();
				trackername = resp.get(2).toString();
					String query = resp.get(5).toString();//obj.get("query").toString();
					query = query.replaceAll("blogsite_id in ", "");
					query = query.replaceAll("\\(", "");
					query = query.replaceAll("\\)", "");
					ids = query;
			}
		
			
			Date today = new Date();
			SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("MMM d, yyyy");
			SimpleDateFormat DATE_FORMAT2 = new SimpleDateFormat("yyyy-MM-dd");

			SimpleDateFormat DAY_ONLY = new SimpleDateFormat("dd");
			SimpleDateFormat MONTH_ONLY = new SimpleDateFormat("MM");
			SimpleDateFormat WEEK_ONLY = new SimpleDateFormat("dd");
			SimpleDateFormat YEAR_ONLY = new SimpleDateFormat("yyyy");

			Date dstart = new SimpleDateFormat("yyyy-MM-dd").parse("2013-01-01");

			String day = DAY_ONLY.format(today);
			String month = MONTH_ONLY.format(today);
			String year = YEAR_ONLY.format(today);

			String dispfrom = DATE_FORMAT.format(dstart);
			String dispto = DATE_FORMAT.format(today);

			String dst = DATE_FORMAT2.format(dstart);
			String dend = DATE_FORMAT2.format(today);


			if (!date_start.equals("") && !date_end.equals("")) {
				Date start = new SimpleDateFormat("yyyy-MM-dd").parse(date_start.toString());
				Date end = new SimpleDateFormat("yyyy-MM-dd").parse(date_end.toString());

				dispfrom = DATE_FORMAT.format(start);
				dispto = DATE_FORMAT.format(end);
				outlinks = outl._searchByRange("date", date_start.toString(), date_end.toString(), ids);
				
			} else if (single.equals("day")) {
				String dt = year + "-" + month + "-" + day;
				outlinks = outl._searchByRange("date", dt, dt, ids);
				
				
			} else if (single.equals("month")) {
				String dt = year + "-" + month + "-" + day;
				String dte = year + "-" + month + "-31";
				outlinks = outl._searchByRange("date", dt, dte, ids);
				
			} else if (single.equals("year")) {
				String dt = year + "-01-01";
				String dte = year + "-12-31";
				outlinks = outl._searchByRange("date", dt, dte, ids);
			} else {

				outlinks = outl._searchByRange("date",dst, dend, ids);
				
			}
			
			
		
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
					if(listtype.equals("urls")){
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
					}else{
						if (outerlinks.has(maindomain)) {
							content = new JSONObject(outerlinks.get(maindomain).toString());
							
							int valu = Integer.parseInt(content.get("value").toString());
							valu++;
							
							content.put("value", valu);
							content.put("link", link);
							content.put("domain", maindomain);
							outerlinks.put(maindomain, content);
						} else {
							int valu = 1;
							content.put("value", valu);
							content.put("link", link);
							content.put("domain", maindomain);
							outerlinks.put(maindomain, content);
							outlinklooper.add(mm, maindomain);
							mm++;
						}				
					}
			}

		}
			
%>
<link rel="stylesheet" href="assets/css/table.css" />
<link rel="stylesheet" href="assets/css/style.css" />

							<table id="DataTables_Table_0_wrapper" class="display" style="width: 100%">
								<thead>
									
									<% if(listtype.equals("urls")){ %>
										<tr><th>URLs</th>
										<th>Frequency</th>
										</tr>
									<% } else { %>	
									<tr>
									<th >Domain</th>
									<th>Frequency</th>
									</tr>
									<% } %>

									
								</thead>
									<tbody>

									<%
										if (outlinklooper.size() > 0) {
													//System.out.println(bloggers);
													for (int y = 0; y < outlinklooper.size(); y++) {
														String key = outlinklooper.get(y).toString();
														JSONObject resu = outerlinks.getJSONObject(key);
														if(resu.get("domain")!=""){
									%>
									<tr>
									<% if(listtype.equals("urls")){ %>
										<td class=""><a href="<%=resu.get("link")%>" target="_blank"><%=resu.get("link")%></a></td>
									<% }else{ %>
										<td class=""><a href="<%=resu.get("domain")%>" target="_blank"><%=resu.get("domain")%></a> </td>
									<% } %>
										<td><%=resu.get("value")%></td>
									</tr>
									<% }}}} %>
									
									</tbody>
							</table>
							
<script type="text/javascript" src="assets/vendors/DataTables/datatables.min.js"></script>
			<script>
 $(document).ready(function() {
	 
	 
	$('#printdoc').on('click',function(){
		print();
	}) 
	
	 $(function () {
		    $('[data-toggle="tooltip"]').tooltip()
		  })
		  
		  // datatable setup
		    $('#DataTables_Table_0_wrapper').DataTable( {
		        "scrollY": 430,
		       /*  "scrollX": "100%", */
		        /* "scrollX": true, */
		         "pagingType": "simple",
		        	 "bLengthChange": false,
		        	 "order": [[ 1, "desc" ]]
		        	/*  ,
		        	    "columnDefs": [
		      		      { "width": "50%", "targets": 0 },
		      		    { "width": "50%", "targets": 0 }
		      		    ] */
		      /*    ,
		         dom: 'Bfrtip',
		         "columnDefs": [
		      { "width": "80%", "targets": 0 }
		    ],
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