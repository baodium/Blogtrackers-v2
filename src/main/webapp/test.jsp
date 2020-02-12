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
<%@page import="scala.Tuple2"%>
<%@page import="java.*"%>
 





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

	   /* System.out.println(dtf.format(now));  */
	/* Date d1 = format.parse(dateStart); */
	

	//in milliseconds
	
//JSONObject sql = post._getBloggerPosts("___NO__TERM___","NOBLOGGER","2000-01-01","2019-12-15","616"); 

//ArrayList<String> sql	 = post._getHighestTerm("CNN", "142,153,229,148,127,46,3,170,154,72,38,224,157,128,61,112,140,116,125,193,173,74,249,250,243,263,98,69,62,78,117,73,135,133,100,143,77,233,221,163,132,147,150,43,242,111,101,86,199,251,118,106,121,129,49,48,66,91,176,124,167,215,141,166,17,220,119,236,230,225,252,20,130,22,76,235,85,245,79,26,109,80,131,253,105,226,137,115,52,53,65,213,96,238,210,136,239,27,206,107,63,57,204,205,216,208,36,102,134,108,113,59,54,88", "2000-01-01","2019-12-15");
	//String sql_ = sql.get("posts").toString();
	/*  JSONObject result =  post._multipleTermVectors (sql); */
	/* 	
	Object jsonArray = sql.getJSONArray("data").get(0);
	System.out.println("dd--"+sql.getJSONArray("data").length());
	String j = jsonArray.toString();
	JSONObject j_ = new JSONObject(j);
	String result = j_.get("permalink").toString(); */
	/* String result = null;
	 try{
	  result = post.getHighestTerm(sql_);  
	}catch(Exception e){
		System.out.println(e);
	} 
	 */
	
	
	//your code
	
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
	
    //ArrayList allposts=post._getBloggerByBloggerName("date","2008-10-18", "2019-10-30","NASHA","date","DESC");
    
    //JSONObject allposts = post._newGetBloggerByBloggerName("date", "2008-10-18", "2019-10-30", "NASHA", "DESC");

	//post.countTerms("C:\\Users\\oljohnson\\Desktop\\SQL\\file2.json");
	/* Clustering cluster = new Clustering();
	String pathin = "C:\\Users\\oljohnson\\Desktop\\spark_test\\LIVERAMP - Copy.txt";
	String pathout = "C:\\Users\\oljohnson\\Desktop\\spark_test";
	cluster._clusteringTest(pathin, pathout);
	PrintWriter pww = response.getWriter(); */
	
	Instant start = Instant.now();
	
	/* String s1 = "[('ukraine', 10), ('russia', 9), ('neutralism', 7), ('yugoslavia', 6), ('likely', 5), ('states', 5), ('two', 4), ('economy', 4), ('west', 4), ('new', 3), ('policy', 3), ('stalin', 3), ('poroshenko', 3), ('imf', 3), ('war', 3), ('tito', 3), ('blocs', 3), ('power', 2), ('though', 2), ('grey', 2), ('cold', 2), ('members', 2), ('none', 2), ('stop', 2), ('send', 2), ('soviet', 2), ('nato', 2), ('threat', 2), ('interest', 2), ('looked', 2), ('petro', 2), ('already', 2), ('putin', 2), ('offers', 2), ('means', 2), ('would', 2), ('never', 2), ('crisis', 2), ('relations', 2), ('obama', 2), ('split', 2), ('side', 2), ('rapprochement', 2), ('one', 2), ('exchange', 2), ('sending', 2), ('people', 2), ('without', 2), ('regime', 2), ('union', 2), ('economic', 2), ('eu', 2), ('might', 2), ('present', 2), ('government', 2), ('heralds', 1), ('world', 1), ('balances', 1), ('shifting', 1), ('united', 1), ('close', 1), ('rising', 1), ('allegedly', 1), ('emboldened', 1), ('vacillations', 1), ('areas', 1), ('alarmed', 1), ('hands-off', 1), ('approach', 1), ('appears', 1), ('increasingly', 1), ('revival', 1), ('defined', 1), ('foreign', 1), ('following', 1), ('1948', 1), ('geographically', 1), ('sandwiched', 1), ('relationships', 1), ('rewards', 1), ('paid-up', 1), ('modicum', 1), ('security', 1), ('considered', 1), ('mutual', 1), ('defection', 1), ('foresaw', 1), ('featured', 1), ('kill', 1), ('moscow', 1), ('ensuing', 1), ('isolation', 1), ('nevertheless', 1), ('seeing', 1), ('thorn', 1), ('communist', 1), ('trade', 1), ('deficits', 1), ('quickly', 1), ('kept', 1)]";
	String s2 = "[('china', 34), ('chinese', 11), ('crimea', 11), ('�', 9), ('even', 7), ('xinjiang', 6), ('russia', 6), ('south', 6), ('tatars', 6), ('ethnic', 6), ('putin', 5), ('independence', 5), ('tibet', 5), ('many', 5), ('beijing', 5), ('situation', 4), ('rather', 4), ('would', 4), ('political', 4), ('kind', 4), ('trade', 4), ('policy', 4), ('resources', 4), ('west', 4), ('russian', 4), ('precedent', 4), ('crimean', 4), ('strategic', 3), ('set', 3), ('taiwan', 3), ('perhaps', 3), ('last', 3), ('week', 3), ('language', 3), ('considered', 3), ('ccp', 3), ('particularly', 3), ('ossetia', 3), ('ethnicity', 3), ('territory', 3), ('countries', 3), ('sanctions', 3), ('ukraine', 3), ('territorial', 3), ('tensions', 3), ('reason', 3), ('also', 3), ('2008', 3), ('abkhazia', 3), ('history', 3), ('among', 3), ('important', 3), ('doors', 3), ('minorities', 3), ('oil', 3), ('regions', 3), ('looking', 2), ('long-term', 2), ('open', 2), ('anything', 2), ('subtle', 2), ('incursion', 2), ('integrity', 2), ('statement', 2), ('however', 2), ('territories', 2), ('issues', 2), ('claims', 2), ('several', 2), ('sea', 2), ('nuclear', 2), ('yanukovich', 2), ('though', 2), ('kremlin', 2), ('large', 2), ('mineral', 2), ('huge', 2), ('diplomatic', 2), ('analysts', 2), ('expansion', 2), ('issued', 2), ('statements', 2), ('parties', 2), ('conflict', 2), ('crisis', 2), ('knife', 2), ('attack', 2), ('asia', 2), ('less', 2), ('exacerbating', 2), ('still', 2), ('recent', 2), ('military', 2), ('stance', 2), ('could', 2), ('much', 2), ('voicing', 2), ('relations', 2), ('x', 2), ('marks', 2)]";
	
	String [] values = {s1 , s2}; */
	
	
	String result = null;
	//String ids_ = "182,142,128,193,173,74,135,133,100,143,77,233,221,163,132,147,150,43,242,111,101,86,199,251,118,106,121,129,49,48,66,91,176,124,167,215,141,166,17,220,119,236,230,225,252,20,130,22,76,235,85,245,79,26,109,80,131,253,105,226,137,115,52,53,65,213,96,238,210,136,239,27,206,107,63,57,204,205,216,208,36,102,134,108,113,59,54,88";
	String ids_ = "182,142,128,193,173,74,135,133,100,143,77,233,221,163,132,147,150,43,242,\r\n" + 
					"			111,101,86,199,251,118,106,121,129,49,48,66,91,176,124,167,215,141,166,17,220,\r\n" + 
					"			119,236,230,225,252,20,130,22,76,235,85,245,\r\n" + 
					"			79,26,109,80,131,253,105,226,137,115,52";
	Terms terms = new Terms();
	JSONObject termsData = terms._getTerms("___NO__TERM___" ,"__NOBLOGGER__",  "2007-08-23","2018-12-07", ids_);
	
	Instant middle = Instant.now();
	Duration timeElapsedmid = Duration.between(start, middle);
	System.out.println("Time taken: "+ timeElapsedmid.getSeconds() +" seconds");
	
	List<Tuple2<String, Integer>> data = terms.getTupleData();
	System.out.println("--->size"+data.size());
	//String tuple = termsData.toString();
	//List<Tuple2<String, Integer>> data  = new ArrayList<Tuple2<String, Integer>>();
	
	// = (List<Tuple2<String, Integer>>)termsData;
	//data = (ArrayList<Tuple2<String, Integer>>) ;

	System.out.println("------>>reduced"+terms.mapReduce(data,"topterm"));
	
	Instant end = Instant.now();
	Duration timeElapsed = Duration.between(start, end);
	System.out.println("Time taken: "+ timeElapsed.getSeconds() +" seconds");
	
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
/* Float highestinfluence = Float.parseFloat(post._searchMaxInfluence2("max","influence_score", "2000-01-01", "2019-11-13", "813,815,809,811,812,806,808,817,644,652,616,641,732,761,709,128")); */
			%>
			<p>His trackers  <%-- <%=  highestinfluence %> --%></p>
			   
			  
			  
			  <%
			  /* Object hits_array = allposts.getJSONArray("hit_array");
			  String resul = null;
			  
			  resul = hits_array.toString();
			  JSONArray all = new JSONArray(resul);
			  String tres = null;
				JSONObject tresp = null;
				String tresu = null;
				JSONObject tobj = null;
				String date =null;
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
					date = dtf.format(datee); */
					
			/* 		
					LocalDate datee = LocalDate.parse(dat);
					DateTimeFormatter dtf = DateTimeFormatter.ofPattern("MMM dd, yyyy");
					date = dtf.format(datee); */
			  
			  %>
			  <h1>HIGHEST TERM --><%-- <%=/* tobj.get("title") */ result%> --%></h1>   
			  
			  <%/* } */%>
			 <%--  <%
			    if(allposts.size()>0){	
			        
					String tres = null;
					JSONObject tresp = null;
					String tresu = null;
					JSONObject tobj = null;
					String date =null;
					int j=0;
					int k=0;
					for(int i=0; i< 5; i++){
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
			 
			 <td><a class="blogpost_link cursor-pointer" id="<%=tobj.get("blogpost_id")%>" ><%=tobj.get("title") %></a><br/>
								<a class="mt20 viewpost makeinvisible" href="<%=tobj.get("permalink") %>" target="_blank"><buttton class="btn btn-primary btn-sm mt10 visitpost">Visit Post &nbsp;<i class="fas fa-external-link-alt"></i></buttton></a></td>
								<td align="center"><%=date %></td>
								
			 <% }}%> --%>
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
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