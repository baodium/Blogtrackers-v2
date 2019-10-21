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
	
	/* String sql = post._getMostKeywordDashboard("2000-01-01","2019-10-11","142,153,229,148,127,46,3,170,154,72,38,224,157,128,61,112,140,116,125,193,173,74,249,250,243,263,98,69,62,78,117,73,135,133,100,143,77,233,221,163,132,147,150,43,242,111,101,86,199,251,118,106,121,129,49,48,66,91,176,124,167,215,141,166,17,220,119,236,230,225,252,20,130,22,76,235,85,245,79,26,109,80,131,253,105,226,137,115,52,53,65,213,96,238,210,136,239,27,206,107,63,57,204,205,216,208,36,102,134,108,113,59,54,88");
	JSONObject res=post._keywordTermvctors(sql); */
	
	/* String sql = post._getBloggerPosts(blogger,"2000-01-01","2019-10-11","142,153,229,148,127,46,3,170,154,72,38,224,157,128,61,112,140,116,125,193,173,74,249,250,243,263,98,69,62,78,117,73,135,133,100,143,77,233,221,163,132,147,150,43,242,111,101,86,199,251,118,106,121,129,49,48,66,91,176,124,167,215,141,166,17,220,119,236,230,225,252,20,130,22,76,235,85,245,79,26,109,80,131,253,105,226,137,115,52,53,65,213,96,238,210,136,239,27,206,107,63,57,204,205,216,208,36,102,134,108,113,59,54,88"); 
	String result = post._termVectors(sql);  */
	
	
	JSONArray sql = post._getMostLanguage("2000-01-01", "2019-10-11", "142,153,229,148,127,46,3,170,154,72,38,224,157,128,61,112,140,116,125,193,173,74,249,250,243,263,98,69,62,78,117,73,135,133,100,143,77,233,221,163,132,147,150,43,242,111,101,86,199,251,118,106,121,129,49,48,66,91,176,124,167,215,141,166,17,220,119,236,230,225,252,20,130,22,76,235,85,245,79,26,109,80,131,253,105,226,137,115,52,53,65,213,96,238,210,136,239,27,206,107,63,57,204,205,216,208,36,102,134,108,113,59,54,88",10);
	
	
	/* String sql = post._getbloggermostterms(blogger); */
	/* System.out.println("-------" + sql); */
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
			 <%--  <h1>HIGHEST TERM --><%=res%></h1> --%>
			  <h1>POSTS--><%=sql%></h1>  
			
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