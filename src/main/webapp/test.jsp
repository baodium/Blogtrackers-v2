<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="authentication.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.File"%>
<%@page import="util.*"%>
<%@page import="util.Blogs"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.NumberFormat"%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="org.json.JSONObject"%>

<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.*"%>





<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	Object email = (null == session.getAttribute("email")) ? "" : session.getAttribute("email");
	Object success_message = (null == session.getAttribute("success_message")) ? "" : "";
	if (email != null && email != "") {
		System.out.println("email is " + email);
	}

	Blogposts post = new Blogposts();
	/* Tim Brown */
	/* Maikel Nabil */
	/* Rhett Kelley */
	/* Zineb Dryef */
	/* Matt Finucane */
	/* Mike.R */
	/* geopoliticst */
	/* Mark Kersten */
	/* richardrozoff */
	/* NoBordersard */
	/* wmw_admin */
	/* Tyler Durden */
	/* Zia H Shah */
	/* hojja_nusreddin */
	/* kristin */
	/* George McGinn */
	/* CNN */

	String blogger = "CNN";
	
	/* String sql = post._getBloggerPosts(blogger,"2016-03-14","2016-05-23","142,153,229,148,127,46,3,170,154,72,38,224,157,128,61,112,140,116,125,193,173,74,249,250,243,263,98,69,62,78,117,73,135,133,100,143,77,233,221,163,132,147,150,43,242,111,101,86,199,251,118,106,121,129,49,48,66,91,176,124,167,215,141,166,17,220,119,236,230,225,252,20,130,22,76,235,85,245,79,26,109,80,131,253,105,226,137,115,52,53,65,213,96,238,210,136,239,27,206,107,63,57,204,205,216,208,36,102,134,108,113,59,54,88"); */
	
	/* _getMostKeywordDashboard */
	
	/*  String sql = post._getMostKeywordDashboard(null,"2000-01-01", "2019-10-15", "813,815,809,811,812,806,808,817,644,652,616,641,732,761,709,128");
	JSONObject res=post._keywordTermvctors(sql);   */
	

	
	/* String sql = post._getBloggerPosts(blogger,"2000-01-01","2019-10-11","142,153,229,148,127,46,3,170,154,72,38,224,157,128,61,112,140,116,125,193,173,74,249,250,243,263,98,69,62,78,117,73,135,133,100,143,77,233,221,163,132,147,150,43,242,111,101,86,199,251,118,106,121,129,49,48,66,91,176,124,167,215,141,166,17,220,119,236,230,225,252,20,130,22,76,235,85,245,79,26,109,80,131,253,105,226,137,115,52,53,65,213,96,238,210,136,239,27,206,107,63,57,204,205,216,208,36,102,134,108,113,59,54,88"); 
	 String result = post._termVectors(sql);  */
	
	
	//JSONArray sql = post. _getMostLanguage("2000-01-01", "2019-10-11", "142,153,229,148,127,46,3,170,154,72,38,224,157,128,61,112,140,116,125,193,173,74,249,250,243,263,98,69,62,78,117,73,135,133,100,143,77,233,221,163,132,147,150,43,242,111,101,86,199,251,118,106,121,129,49,48,66,91,176,124,167,215,141,166,17,220,119,236,230,225,252,20,130,22,76,235,85,245,79,26,109,80,131,253,105,226,137,115,52,53,65,213,96,238,210,136,239,27,206,107,63,57,204,205,216,208,36,102,134,108,113,59,54,88",10);
	//2000-01-01--->2019-10-14--->813,815,809,811,812,806,808,817,644,652,616,641,732,761,709,128,
	
	
	//String sql = post._getMostKeywordDashboard(null,"2000-01-01","2019-10-15","153,148,259,114,32,123,37,155,46,3,170,154,72,38,224,247,157,128,61,112,140,144,116,125,193,9,173,89,68,87,249,250,263,98,69,152,62,78,117,83,73,264,135,184,120,138,133,100,93,143,77,233,139,132,146,147,149,150,43,242,47,111,101,86,81,118,194,45,106,121,129,49,237,66,179,91,176,124,167,84,174,215,141,119,236,252,185,20,162,130,22,76,235,178,232,85,79,26,109,80,131,253,105,151,142,137,115,52,53,65,94,92,96,136,191,27,29,107,63,99,57,190,169,216,122,126,36,127,134,108,54");
	//JSONObject res=post._keywordTermvctors(sql);
	
	//Integer sql=post._getBlogOrPostMentioned("post","care","2000-01-01", "2019-10-15","813,815,809,811,812,806,808,817,644,652,616,641,732,761,709,128");
	
	//String sql=post._getMostLocation("care","2015-11-03", "2019-10-16", "148");
	
	/* String sql = post._getMostKeywordDashboard(null,dt,dte,ids);
	JSONObject res=post._keywordTermvctors(sql);	
	System.out.println("--->"+res); */
	
/* JSONObject sql = post._getBloggerPosts("","tine","2017-04-22","2017-04-22","697"); */

	/* 		
	String sql_ = sql.get("data").toString();
	
	
	Object jsonArray = sql.getJSONArray("data").get(0);
	System.out.println("dd--"+sql.getJSONArray("data").length());
	String j = jsonArray.toString();
	JSONObject j_ = new JSONObject(j);
	String result = j_.get("permalink").toString(); */
	
	
	/* String result = post._termVectors(sql_);   */
	
	
	/* String ids_ =  "148";
	String date_from = "2015-11-03";
	String date_to = "2019-10-16";
	String term = "care";
	
	JSONObject query = new JSONObject();
	query = new JSONObject("{\r\n" + "    \"size\": 0,\r\n" + "    \"query\": {\r\n"
			+ "        \"bool\": {\r\n" + "            \"must\": [\r\n" + "                {\r\n"
			+ "                    \"match\": {\r\n" + "                        \"post\": \"" + term + "\"\r\n"
			+ "                    }\r\n" + "                },\r\n" + "                {\r\n"
			+ "                    \"bool\": {\r\n" + "                        \"must\": [\r\n"
			+ "                            {\r\n" + "                                \"terms\": {\r\n"
			+ "                                    \"blogsite_id\": [" + ids_ + "],\r\n"
			+ "                                    \"boost\": 1\r\n" + "                                }\r\n"
			+ "                            },\r\n" + "                            {\r\n"
			+ "                                \"exists\": {\r\n"
			+ "                                    \"field\": \"location\",\r\n"
			+ "                                    \"boost\": 1\r\n" + "                                }\r\n"
			+ "                            }\r\n" + "                        ],\r\n"
			+ "                        \"adjust_pure_negative\": true,\r\n"
			+ "                        \"boost\": 1\r\n" + "                    }\r\n" + "                },\r\n"
			+ "                {\r\n" + "                    \"range\": {\r\n"
			+ "                        \"date\": {\r\n" + "                            \"from\": \"" + date_from
			+ "\",\r\n" + "                            \"to\": \"" + date_to + "\",\r\n"
			+ "                            \"include_lower\": true,\r\n"
			+ "                            \"include_upper\": true,\r\n"
			+ "                            \"boost\": 1\r\n" + "                        }\r\n"
			+ "                    }\r\n" + "                }\r\n" + "            ],\r\n"
			+ "            \"adjust_pure_negative\": true,\r\n" + "            \"boost\": 1\r\n" + "        }\r\n"
			+ "    },\r\n" + "    \"_source\": false,\r\n" + "    \"stored_fields\": \"_none_\",\r\n"
			+ "    \"aggregations\": {\r\n" + "        \"groupby\": {\r\n" + "            \"composite\": {\r\n"
			+ "                \"size\": 1000,\r\n" + "                \"sources\": [\r\n"
			+ "                    {\r\n" + "                        \"dat\": {\r\n"
			+ "                            \"terms\": {\r\n"
			+ "                                \"field\": \"location.keyword\",\r\n"
			+ "                                \"missing_bucket\": true,\r\n"
			+ "                                \"order\": \"asc\"\r\n" + "                            }\r\n"
			+ "                        }\r\n" + "                    }\r\n" + "                ]\r\n"
			+ "            },\r\n" + "            \"aggregations\": {\r\n" + "                \"dat\": {\r\n"
			+ "                    \"filter\": {\r\n" + "                        \"exists\": {\r\n"
			+ "                            \"field\": \"location\",\r\n"
			+ "                            \"boost\": 1\r\n" + "                        }\r\n"
			+ "                    }\r\n" + "                }\r\n" + "            }\r\n" + "        }\r\n"
			+ "    }\r\n" + "}");
	System.out.println(query);
	JSONObject myResponse = post._makeElasticRequest(query, "POST", "/blogposts/_search/?"); */
	/*
	JSONObject sql = post._elastic(query);
	
	JSONArray jsonArray = (JSONArray)sql.getJSONArray("hit_array");
	
	ArrayList<String> list = new ArrayList<String>();
	jsonArray.toString(); */
	/* String result = null; */
	
/* 	if (jsonArray != null) {
		for (int i = 0; i < jsonArray.length(); i++) {
			String indx = jsonArray.get(i).toString();
			JSONObject j = new JSONObject(indx);
			String ids = j.get("_source").toString();
			j = new JSONObject(ids);
			String src = j.get("post").toString();

			list.add(src);
		} */
	
	/* jsonArray_.toString();
	
	
	JSONArray jsonArray = new JSONArray(jsonArray_); */
	
	
	/* String sql = post._getbloggermostterms(blogger); */
	/* System.out.println("-------" + sql); */
/* 	
	DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.ENGLISH);
	DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("dd-MM-yyy", Locale.ENGLISH);
	
	LocalDate date = LocalDate.parse("2018-04-10T04:00:00.000Z");
	
	String formattedDate = outputFormatter.format(date);
	System.out.println(formattedDate); // prints 10-04-2018 */
	/* String d = "2014-12-10T00:00:00.000Z"; */
	
	/* LocalDateTime now = LocalDateTime.now(); */

/*     System.out.println("Before : " + d);

    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    
    
    LocalDate date = LocalDate.parse(d);
    
    
    String formatDateTime = date.format(formatter);

    System.out.println("After : " + formatDateTime); */
 /*    
    DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.ENGLISH);
    DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("dd-MM-yyy", Locale.ENGLISH);
    LocalDate date = LocalDate.parse("2014-12-10T00:00:00.000Z", inputFormatter);
    Integer d = date.getYear();
    /* String formattedDate = outputFormatter.format(date); */
    /* System.out.println(d); */ // prints 10-04-2018
	
    ArrayList allposts=post._getBloggerByBloggerName("date","2008-10-18", "2019-10-30","NASHA","date","DESC");

	
	PrintWriter pww = response.getWriter();
	
%>

<html>
<head>API test for Mike
</head>

<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Blogtrackers - Login</title>
<link rel="shortcut icon" href="images/favicons/favicon-48x48.png">
<link rel="apple-touch-icon" href="images/favicons/favicon-48x48.png">
<link rel="apple-touch-icon" sizes="96x96"
	href="images/favicons/favicon-96x96.png">
<link rel="apple-touch-icon" sizes="144x144"
	href="images/favicons/favicon-144x144.png">
<!-- start of bootsrap -->
<link href="https://fonts.googleapis.com/css?family=Open+Sans:600,700"
	rel="stylesheet">
<link rel="stylesheet" href="assets/bootstrap/css/bootstrap-grid.css" />
<link rel="stylesheet" href="assets/bootstrap/css/bootstrap.css" />
<link rel="stylesheet"
	href="assets/fonts/fontawesome/css/fontawesome-all.css" />
<link rel="stylesheet" href="assets/fonts/iconic/css/open-iconic.css" />
<link rel="stylesheet"
	href="assets/vendors/bootstrap-daterangepicker/daterangepicker.css" />
<link rel="stylesheet" href="assets/css/table.css" />
<link rel="stylesheet"
	href="assets/vendors/DataTables/dataTables.bootstrap4.min.css" />
<link rel="stylesheet"
	href="assets/vendors/DataTables/Buttons-1.5.1/css/buttons.dataTables.min.css" />
<link rel="stylesheet" href="assets/css/daterangepicker.css" />

<link rel="stylesheet" href="assets/css/style.css" />

<link rel="stylesheet" href="assets/css/toastr.css">
<!--end of bootsrap -->
<script src="assets/js/jquery.min.js"></script>
<script src="assets/js/popper.min.js"></script>

<!-- JavaScript to be reviewed thouroughly by me -->
<script type="text/javascript" src="assets/js/validate.min.js"></script>
<script type="text/javascript" src="assets/js/uniform.min.js"></script>

<script type="text/javascript" src="assets/js/toastr.js"></script>
<script src="pagedependencies/baseurl.js"></script>
<script type="text/javascript" src="js/request.js?v=97"></script>
<body>
	<form id="request_form" class="" method="post">
		<div>
			<input type="email" id="username" placeholder="Email"> <input
				type="password" id="password" placeholder="Password">
			<button type="submit"
				class="btn btn-primary loginformbutton mt10 bold-text"
				style="background: #28a745;">Login</button>
		</div>

		<div>

			<p><%=email%>
				is logged in
			</p>
			<%
				/* 	ArrayList sql = 
					JSONArray ids =  */
				
/* 				try {
					if (sql.size() > 0) {
						
						for (int i = 0; i < sql.size(); i++) {
							String indx = sql.get(i).toString();
							JSONObject j = new JSONObject(indx);
							String ids = j.get("_id").toString();  */
							/* j = new JSONObject(src); */
							/* String ids = j.get("_id").toString(); */
							
/* 							System.out.println("__ids__" + ids);
						}
					}
				} catch (Exception e) {
					System.err.println(e);
				} */
			%>
			<p>His trackers</p>
			  <%--  <h1>HIGHEST TERM --><%=result%></h1>   --%>
			  
			  <%
			    if(allposts.size()>0){	
			        
					String tres = null;
					JSONObject tresp = null;
					String tresu = null;
					JSONObject tobj = null;
					String date =null;
					int j=0;
					int k=0;
					for(int i=0; i< allposts.size(); i++){
							tres = allposts.get(i).toString();	
						tresp = new JSONObject(tres);
						tresu = tresp.get("_source").toString();
						tobj = new JSONObject(tresu);
						String dat = tobj.get("date").toString().substring(0,10);
						LocalDate datee = LocalDate.parse(dat);
						DateTimeFormatter dtf = DateTimeFormatter.ofPattern("MMM dd, yyyy");
						date = dtf.format(datee);
						
						k++; 
			  
			  %>
			 <h1>HIGHEST TERM --><%=tobj.get("title")%>  ------ <%= tobj.get("post").toString()%></h1> 
			 <% }}%>
<%-- 			   <h1>POSTS--><%
			   JSONObject j = new JSONObject();
			   for(int i=0; i<sql.length();i++){
				   String a = sql.get(i).toString();
				   j = new JSONObject(a);
				   System.out.println(j);
			   
			   
			   
			   %></h1> <%} %> --%>
			   
			   			   <%-- <h1>POSTS--><%=sql%></h1> --%>
			<%-- <h1>POSTS--><%=myResponse%></h1> --%> 
			<%--  <h1>POSTS AGAIN--><%=jsonArray%></h1>  --%>
			 
			<%
				/* 		try {
							if (termss.size() > 0) {
								for (int p = 0; p < termss.size(); p++) {
									String bstr = termss.get(p).toString();
									JSONObject bj = new JSONObject(bstr);
									bstr = bj.get("_source").toString();
									bj = new JSONObject(bstr);
									String tm = bj.get("term").toString();
									String frequency = bj.get("frequency").toString();
									String id = bj.get("id").toString();
				
									int frequency2 = Integer.parseInt(frequency);
									if (top_terms.containsKey(tm)) {
										top_terms.put(tm, top_terms.get(tm) + frequency2);
										frequency2 = top_terms.get(tm) + frequency2;
									} else {
										top_terms.put(tm, frequency2);
									}
				
									unsortedterms.put(frequency2 + "___" + tm + "___" + id);
				
								}
				
								session.setAttribute("top_term", top_terms);
							}
						} catch (Exception e) {
							System.err.println(e);
						} */
			%>

		</div>
	</form>
</body>
</html>