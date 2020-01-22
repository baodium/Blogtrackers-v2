<%@page import="authentication.*"%>
<%@page import="java.util.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.File"%>
<%@page import="util.Blogposts"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="javafx.util.Pair"%>
<%@page import="util.TopicModelling"%>
<%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.text.SimpleDateFormat"%>

<%@page import="org.apache.lucene.analysis.CharArrayMap.EntrySet"%>

<%@page import="util.*"%>
<%@page import="java.io.*"%>

<%@page import="org.json.JSONArray"%>



<!-- Blog Posts Collection -->
<%
Object email = (null == session.getAttribute("email")) ? "" : session.getAttribute("email");
Object tid = (null == request.getParameter("tid")) ? "" : request.getParameter("tid");
Object user = (null == session.getAttribute("username")) ? "" : session.getAttribute("username");
Object date_start = (null == request.getParameter("date_start")) ? "" : request.getParameter("date_start");
Object date_end = (null == request.getParameter("date_end")) ? "" : request.getParameter("date_end");
Object single = (null == request.getParameter("single_date")) ? "" : request.getParameter("single_date");
String sort =  (null == request.getParameter("sortby")) ? "blog" : request.getParameter("sortby").toString().replaceAll("[^a-zA-Z]", " ");

if (user == null || user == "") {
	response.sendRedirect("index.jsp");
} else {
ArrayList detail = new ArrayList();
Trackers tracker = new Trackers();

if (tid != "") {
	detail = tracker._fetch(tid.toString());	
} else {
	detail = tracker._list("DESC", "", user.toString(), "1");
}

boolean isowner = false;
JSONObject obj = null;
String ids = "";
String trackername="";
if (detail.size() > 0) {
	//String res = detail.get(0).toString();
	ArrayList resp = (ArrayList<?>)detail.get(0);
	String tracker_userid = resp.get(1).toString();
	trackername = resp.get(2).toString();
	if (tracker_userid.equals(user.toString())) {
		isowner = true;
		String query = resp.get(5).toString();//obj.get("query").toString();
		query = query.replaceAll("blogsite_id in ", "");
		query = query.replaceAll("\\(", "");
		query = query.replaceAll("\\)", "");
		ids = query;
	}
}
	//TODO - These are arbitrary blogs, send selected tracker's blogs in this format
	/* String blogIds = "1,2,3,4,5,6,7,8,9,10"; */
	String blogIds = ids;
	System.out.println(blogIds);
	String DUMMYSTR = "";
	Blogposts blogpostsContainer = new Blogposts();
	
	String stdate = blogpostsContainer._getDate(ids,"first");
	LocalDate localDate = LocalDate.now();
    String today = DateTimeFormatter.ofPattern("yyy-MM-dd").format(localDate);
	
	//String endate = blogpostsContainer._getDate(ids,"last");
		
	//Date dstart = new SimpleDateFormat("yyyy-MM-dd").parse(stdate.split("T")[0]);
	//Date today = new SimpleDateFormat("yyyy-MM-dd").parse(endate);
	
	System.out.println(stdate.split("T")[0]);
	System.out.println(today.toString());
	
	ArrayList<String> JSONposts = blogpostsContainer._getPosts(blogIds, stdate, today);
	//System.out.println("SIZE --" + JSONposts.size());

	//ArrayList<String> JSONposts = blogpostsContainer._getPostByBlogId(blogIds, DUMMYSTR); 
	ArrayList<TopicModelling.BlogPost> blogpostsArray = new ArrayList<TopicModelling.BlogPost>(); 
	
	JSONObject rawJSONpost = null;
	JSONObject post = null;
	
	JSONObject post_date = null;
	// = null;
	
	for (int i = 0; i < JSONposts.size(); ++i) {
		rawJSONpost = new JSONObject(JSONposts.get(i).toString());
		post = new JSONObject(rawJSONpost.get("_source").toString());
		
		Object post_date_ = rawJSONpost.getJSONObject("fields").getJSONArray("date").get(0).toString();
		//System.out.println(post_date_.toString());
		
		//JSONObject post_date = null;
		
		blogpostsArray.add(new TopicModelling.BlogPost(
				post.get("blogpost_id").toString(),
				//blogpostsContainer.escape(post.get("title").toString()),
				blogpostsContainer.escape2(post.get("title").toString()),
				post.get("post").toString(),
				post_date_.toString(),
				//post.get("date").toString().split("T")[0], 
				post.get("blogger").toString(),
				post.get("location").toString(),
				post.get("num_comments").toString()));
	}
	
	for(TopicModelling.BlogPost x : blogpostsArray){
		//System.out.println(x);
	}
	//System.out.println(Arrays.toString(blogpostsArray));
%>

<!-- Topic Modelling  -->
<%
	final double TOPIC_THRESHOLD = 0.1;
	final int TOPIC_NUMBER= 10;
	final int TOPICMODEL_MAXWORDS = 30;
	final int WORDCLOUD_MAXWORDS = 20;
	final int DATATABLE_MAXWORDS = 10;
	
	TopicModelling model = new TopicModelling(blogpostsArray, TOPIC_NUMBER);
	Map<Integer, ArrayList<Pair<String, Double>>> topics = model.getTopics(TOPICMODEL_MAXWORDS);
	//Blogposts used in the local JS
	ArrayList<TopicModelling.Documents.Document> blogposts = model.getDocuments();
	for(TopicModelling.Documents.Document x : blogposts){
		//System.out.println(x.blog_date);
	}
	//Statistics Bar
	double blogDistribution[] = new double[topics.size()];
	int bloggerMention[] = new int[topics.size()];
	int postMention[] = new int[topics.size()];
	String locations[] = new String[topics.size()];
	String topBloggers[] = new String[topics.size()];
	final String DEFAULT_LOCATION = "Not Provided";
	final String DEFAULT_AUTHOR = "Not Provided";
	// Chord Diagram Matrix
	double blogDistributionMatrix[][] = new double[topics.size()][topics.size()];
	for (double[] row : blogDistributionMatrix){
		Arrays.fill(row, 0.0);
	}
	
	// Compute Stats (Blog/Blogger Distribution, Post Mentions, Locations)
	for (int i = 0; i < topics.size(); i++) {
		HashMap<String, Integer> bloggers = new HashMap<String, Integer>();
		HashMap<String, Integer> locationFrequency = new HashMap<String, Integer>();
		String bloggerHighestTopicProb = DEFAULT_AUTHOR;
		double highestTopicProb = 0;
		int blogPostsInThreshold = 0;
		
		for (TopicModelling.Documents.Document doc : blogposts) {
			if (doc.theta[i] > TOPIC_THRESHOLD) {
				blogPostsInThreshold++;
				// Track author whose post has highest topic probability
				if (doc.theta[i] > highestTopicProb) {
					highestTopicProb = doc.theta[i];
					bloggerHighestTopicProb = doc.blog_author;
				}
				// Track Number of Occurence for each Blogger
				if (bloggers.containsKey(doc.blog_author)) {
					bloggers.replace(doc.blog_author, bloggers.get(doc.blog_author) + 1);
				}
				else {
					bloggers.put(doc.blog_author, 1);	
				}
				// Track Location Frequency
	    	    if (locationFrequency.containsKey(doc.blog_location) ) {
		            locationFrequency.put(doc.blog_location, locationFrequency.get(doc.blog_location) + 1);
		        } else {
		        	locationFrequency.put(doc.blog_location, 1);
		        }
	    	 	// Track Topic Overlap
	    	 	for (int j = 0; j < topics.size(); j++) {
	    	 		if (doc.theta[j] > TOPIC_THRESHOLD) {blogDistributionMatrix[i][j]++;}
	    	 	}
			}
		}
		bloggerMention[i] = bloggers.size();
		postMention[i] = blogPostsInThreshold;
		topBloggers[i] = bloggerHighestTopicProb;
		
		// Alternate Top Author assignment - Assign Author with highest number of posts related to topic
		//
		//int max_count = 0;
       	//String mostFrequentAuthor = DEFAULT_AUTHOR;
       	//for(Entry<String, Integer> val : bloggers.entrySet()) 
       	//{
           //	if (max_count < val.getValue())
           	//{
           	//	mostFrequentAuthor = val.getKey();
            //   	max_count = val.getValue(); 
           	//}
       	//}
       	//topBloggers[i] = (mostFrequentAuthor == "null") ? DEFAULT_AUTHOR : mostFrequentAuthor;
	}
	
	//Compute Blog Distribution relative to the total topics
	int totalMentions = 0;
	for (int i = 0; i < topics.size(); i++) {
		totalMentions += postMention[i];
	}
	for (int i = 0; i < topics.size(); i++) {
		blogDistribution[i] = ((double) postMention[i]) / totalMentions;
	}
%>

<%
	//Object email = (null == session.getAttribute("email")) ? "" : session.getAttribute("email");

	//if (email == null || email == "") {
	//response.sendRedirect("login.jsp");
	//}else{

	ArrayList<?> userinfo = new ArrayList();//null;
	String profileimage = "";
	String username = "";
	String name = "";
	String phone = "";
	String date_modified = "";

	userinfo = new DbConnection().query("SELECT * FROM usercredentials where Email = '" + email + "'");
	//System.out.println(userinfo);
	if (userinfo.size() < 1) {
		//response.sendRedirect("login.jsp");
	} else {
		userinfo = (ArrayList<?>) userinfo.get(0);
		try {
			username = (null == userinfo.get(0)) ? "" : userinfo.get(0).toString();

			name = (null == userinfo.get(4)) ? "" : (userinfo.get(4).toString());

			email = (null == userinfo.get(2)) ? "" : userinfo.get(2).toString();
			phone = (null == userinfo.get(6)) ? "" : userinfo.get(6).toString();
			//date_modified = userinfo.get(11).toString();

			String userpic = userinfo.get(9).toString();
			String[] user_name = name.split(" ");
			username = user_name[0];

			String path = application.getRealPath("/").replace('\\', '/') + "images/profile_images/";
			String filename = userinfo.get(9).toString();

			profileimage = "images/default-avatar.png";
			if (userpic.indexOf("http") > -1) {
				profileimage = userpic;
			}

			File f = new File(filename);
			if (f.exists() && !f.isDirectory()) {
				profileimage = "images/profile_images/" + userinfo.get(2).toString() + ".jpg";
			}
		} catch (Exception e) {
		}

	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Blogtrackers-Topic Distribution</title>
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

<link rel="stylesheet" href="assets/css/daterangepicker.css" />
<link rel="stylesheet" href="assets/css/style.css" />

<!--end of bootsrap -->
<script src="assets/js/jquery-3.2.1.slim.min.js"></script>
<script src="assets/js/popper.min.js"></script>
<script src="pagedependencies/googletagmanagerscript.js"></script>

<script type="text/javascript" src="assets/js/jquery-1.11.3.min.js"></script>
<script src="assets/bootstrap/js/bootstrap.js"> </script>
<script src="assets/js/generic.js"> </script>
<script src="assets/vendors/bootstrap-daterangepicker/moment.js"></script>
<script src="assets/vendors/bootstrap-daterangepicker/daterangepicker.js"></script>

<!-- Charts -->
<script type="text/javascript" src="assets/vendors/d3/d3.min.js"></script>
<script src="assets/vendors/wordcloud/d3.layout.cloud.js"></script>
<script type="text/javascript" src="assets/vendors/d3/d3_tooltip.js"></script>
<script type="text/javascript" src="assets/vendors/d3/d3.v4.min.js"></script>
</head>
<body>
	<%@include file="subpages/loader.jsp"%>
	<%@include file="subpages/googletagmanagernoscript.jsp"%>
	<div class="modal-notifications">
		<div class="row">
			<div class="col-lg-10 closesection"></div>
			<div class="col-lg-2 col-md-12 notificationpanel">
				<div id="closeicon" class="cursor-pointer">
					<i class="fas fa-times-circle"></i>
				</div>
				<div class="profilesection col-md-12 mt50">
					<%
						if (userinfo.size() > 0) {
					%>
					<div class="text-center mb10">
						<img src="<%=profileimage%>" width="60" height="60"
							onerror="this.src='images/default-avatar.png'" alt="" />
					</div>
					<div class="text-center" style="margin-left: 0px;">
						<h6 class="text-primary m0 bolder profiletext"><%=name%></h6>
						<p class="text-primary profiletext"><%=email%></p>
					</div>
					<%
						}
					%>
				</div>
				<div id="othersection" class="col-md-12 mt10" style="clear: both">
					<%
						if (userinfo.size() > 0) {
					%>
					<a class="cursor-pointer profilemenulink"
						href="<%=request.getContextPath()%>/notifications.jsp"><h6
							class="text-primary">
							Notifications <b id="notificationcount" class="cursor-pointer">12</b>
						</h6> </a> <a class="cursor-pointer profilemenulink"
						href="<%=request.getContextPath()%>/addblog.jsp"><h6
							class="text-primary">Add Blog</h6></a> <a
						class="cursor-pointer profilemenulink"
						href="<%=request.getContextPath()%>/profile.jsp"><h6
							class="text-primary">Profile</h6></a> <a
						class="cursor-pointer profilemenulink"
						href="<%=request.getContextPath()%>/logout"><h6
							class="text-primary">Log Out</h6></a>
					<%
						} else {
					%>
					<a class="cursor-pointer profilemenulink"
						href="<%=request.getContextPath()%>/login"><h6
							class="text-primary">Login</h6></a>

					<%
						}
					%>
				</div>
			</div>
		</div>
	</div>

	<nav class="navbar navbar-inverse bg-primary">
		<div class="container-fluid mt10 mb10">

			<div
				class="navbar-header d-none d-lg-inline-flex d-xl-inline-flex  col-lg-3">
				<a class="navbar-brand text-center logohomeothers" href="./"> </a>
			</div>
			<!-- Mobile Menu -->
			<nav
				class="navbar navbar-dark bg-primary float-left d-md-block d-sm-block d-xs-block d-lg-none d-xl-none"
				id="menutoggle">
				<button class="navbar-toggler" type="button" data-toggle="collapse"
					data-target="#navbarToggleExternalContent"
					aria-controls="navbarToggleExternalContent" aria-expanded="false"
					aria-label="Toggle navigation">
					<span class="navbar-toggler-icon"></span>
				</button>
			</nav>

			<!-- Mobile menu  -->
			<div class="col-lg-6 themainmenu" align="center">
				<ul class="nav main-menu2"
					style="display: inline-flex; display: -webkit-inline-flex; display: -mozkit-inline-flex;">
					<li><a class="bold-text"
						href="<%=request.getContextPath()%>/blogbrowser.jsp"><i
							class="homeicon"></i> <b class="bold-text ml30">Home</b></a></li>
					<li><a class="bold-text"
						href="<%=request.getContextPath()%>/trackerlist.jsp"><i
							class="trackericon"></i><b class="bold-text ml30">Trackers</b></a></li>
					<li><a class="bold-text"
						href="<%=request.getContextPath()%>/favorites.jsp"><i
							class="favoriteicon"></i> <b class="bold-text ml30">Favorites</b></a></li>

				</ul>
			</div>


			<div class="col-lg-3">
				<%
					if (userinfo.size() > 0) {
				%>

				<ul class="nav navbar-nav" style="display: block;">
					<li class="dropdown dropdown-user cursor-pointer float-right">
						<a class="dropdown-toggle " id="profiletoggle"
						data-toggle="dropdown"> <i class="fas fa-circle"
							id="notificationcolor"></i> <img src="<%=profileimage%>"
							width="50" height="50"
							onerror="this.src='images/default-avatar.png'" alt="" class="" />
							<span><%=username%></span></a>

					</li>
				</ul>
				<%
					} else {
				%>
				<ul class="nav main-menu2 float-right"
					style="display: inline-flex; display: -webkit-inline-flex; display: -mozkit-inline-flex;">

					<li class="cursor-pointer"><a href="login.jsp">Login</a></li>
				</ul>
				<%
					}
				%>
			</div>

		</div>
		<div
			class="col-md-12 bg-dark d-md-block d-sm-block d-xs-block d-lg-none d-xl-none p0 mt20">
			<div class="collapse" id="navbarToggleExternalContent">
				<ul class="navbar-nav mr-auto mobile-menu">
					<li class="nav-item active"><a class=""
						href="<%=request.getContextPath()%>/blogbrowser.jsp">Home <span
							class="sr-only">(current)</span></a></li>
					<li class="nav-item"><a class="nav-link"
						href="<%=request.getContextPath()%>/trackerlist.jsp">Trackers</a>
					</li>
					<li class="nav-item"><a class="nav-link"
						href="<%=request.getContextPath()%>/favorites.jsp">Favorites</a></li>
				</ul>
			</div>
		</div>
	</nav>
	<div class="container analyticscontainer">
		
		<!--  Bread crumbs and Date -->
		<div class="row bottom-border pb20">
			<div class="col-md-6 paddi">
							<nav class="breadcrumb">
					<a class="breadcrumb-item text-primary"
						href="<%=request.getContextPath()%>/trackerlist.jsp">Trackers</a> 
						<a class="breadcrumb-item text-primary"	href="<%=request.getContextPath()%>/edittracker.jsp?tid=<%=tid%>"><%=trackername%></a>
					<a class="breadcrumb-item active text-primary" href="<%=request.getContextPath()%>/dashboard.jsp?tid=<%=tid%>">Dashboard</a>
					<a class="breadcrumb-item active text-primary" href="<%=request.getContextPath()%>/topic_distribution.jsp?tid=<%=tid%>">Topic Distribution</a>
				</nav>
				<!-- <nav class="breadcrumb">
					<a class="breadcrumb-item text-primary" href="trackerlist.html">MY TRACKER</a>
					<a class="breadcrumb-item text-primary" href="#">Second Tracker</a>
					<a class="breadcrumb-item active text-primary" href="postingfrequency.html">Topic Distribution</a>
				</nav> -->
		<div>
					<button class="btn btn-primary stylebutton1 " id="printdoc">SAVE
						AS PDF</button>
				</div> 
			</div>
		</div>

		<div class="row mt20">
			<div class="col-md-3">

				<!--  Topics -->
				<div class="card card-style mt20">
					<div class="card-body  p30 pt5 pb5 mb20">
						<h5 class="mt20 mb20">Topics</h5>
						<div style="padding-right: 10px !important;">
							<input id="topicsSearch" type="search" class="form-control stylesearch mb20"
								placeholder="Search " />
						</div>
						<div id="topicsContainer" class="scrolly" style="height: 270px; padding-right: 10px !important;">
						</div>
					</div>
				</div>
			</div>

			<!--  Line  Chart -->
			<div class="col-md-9">
				<div class="card card-style mt20">
					<div class="card-body  p30 pt5 pb5">
						<div style="min-height: 250px;">
							<div>
								<p class="text-primary mt10">
									<b>Individual</b> Number of Blog Posts
								</p>
							</div>
							<div class="chart-container">
								<div class="chart" id="topicstream"></div>
							</div>
						</div>
					</div>
				</div>
				<div class="card card-style mt20">
					<div class="card-body  p30 pt20 pb20">
						<div class="row">
							<div class="col-md-3 mt5 mb5">
								<h6 class="card-title mb0">Blog Distribution</h6>
								<h3 id="blogDistribution" class="mb0 text-primary text-statistics"></h3>
							</div>

							<div class="col-md-3 mt5 mb5">
								<h6 class="card-title mb0">Bloggers Mentioned</h6>
								<h3 id="bloggerMention" class="mb0 text-primary text-statistics"></h3>
							</div>

							<div class="col-md-3 mt5 mb5">
								<h6 class="card-title mb0">Post Mentioned</h6>
								<h3 id="postMention" class="mb0 text-primary text-statistics"></h3>
							</div>

							<div class="col-md-3  mt5 mb5">
								<h6 class="card-title mb0">Top Blogger</h6>
								<h3 id="topAuthor" class="mb0 text-primary text-statistics"></h3>
							</div>

						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="row mb0">
		
			<div class="col-md-6 mt20 ">
				<div class="card card-style mt20" >
					<div class="card-body  p20 pt5 pb5" style="min-height: 670px;">
						<div>
							<p class="text-primary mt10">
								Keywords of <b class="topic text-blue"></b>
							</p>
						</div>
						<div class="chart-container">
							<div class="chart tagcloudcontainer" id="tagcloudcontainer" style="min-height: 300px;"></div>
							<div class="jvectormap-zoomin zoombutton" id="zoom_in">+</div>
							<div class="jvectormap-zoomout zoombutton" id="zoom_out">−</div>
						</div>

					</div>
				</div>
			</div>
			
			

			<div class="col-md-6 mt20">
				<div class="card card-style mt20">
					<div class="card-body p20 pt0 pb20" style="min-height: 300px;">
						<div>
							<p class="text-primary mt10">
								<b class="topic text-blue"></b>
							</p>
						</div>
						<div class="chart-container">
							<div id="chorddiagram" class="chart svg-center"></div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="row m0 mt20 mb20 d-flex align-items-stretch">
			<div class="col-md-6 mt20 card card-style nobordertopright noborderbottomright">
				<div class="card-body p0 pt20 pb20" style="min-height: 420px;">
					<p>
						Posts from <b class="topic text-blue"></b>
					</p>
					<div id="table_view">
						 <!-- <table id="DataTables_Table_0_wrapper" class="display" style="width: 100%;">
							<thead>
								<tr>
									<th>Post title</th>
									<th>Topic weight</th>
								</tr>
							</thead>
							<tbody id="blogPostsContainer1" class="akpa">	
									
							</tbody>
						</table>
						-->
						
					</div>
						
					
					
					
				</div>
				<div style="height: 250px; padding-right: 10px !important;" id="table_display_loader" class="hidden">
						<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />
					</div>
			</div>
			

			<div id="blogPostContainer" class="col-md-6 mt20 card card-style nobordertopleft noborderbottomleft">
				<div style="" class="pt20">
					<h5 id="titleContainer" class="text-primary p20 pt0 pb0"></h5>
					<div class="text-center mb20 mt20">
						<button class="btn stylebuttonblue">
							<b id="authorContainer" class="float-left ultra-bold-text"></b>
							<i class="far fa-user float-right blogcontenticon"></i>
						</button>
						<button id="dateContainer" class="btn stylebuttonnocolor"></button>
						<button class="btn stylebuttonorange">
							<b id="numCommentsContainer" class="float-left ultra-bold-text"></b>
							<i class="far fa-comments float-right blogcontenticon"></i>
						</button>
					</div>
					<div style="height: 600px;">
						<div id="postContainer" class="p20 pt0 pb20 text-blog-content text-primary" style="height: 550px; overflow-y: scroll;"></div>
					</div>
				</div>
			</div>
		</div>

		<!-- Topic Words -->
		<div class="row mb50 d-flex align-items-stretch">
			<div class="col-md-12 mt20 ">
				<div class="card card-style mt20">
					<div class="card-body p10 pt20 pb5">
						<div style="min-height: 420px;">
							<div class="p15 pb5 pt0" role="group"></div>
							<table id="DataTables_Table_1_wrapper" class="display" style="width: 100%">
								<thead>
									<tr>
										<% for(Map.Entry<Integer, ArrayList<Pair<String, Double>>> entry : topics.entrySet()) { %>
											<th>Topic <%=entry.getKey() + 1%></th>
										<% } %>
									</tr>
								</thead>
								<tbody>
									<% for(int i = 0; i < DATATABLE_MAXWORDS; i++) { %>
										<tr> 
										<% for(Map.Entry<Integer, ArrayList<Pair<String, Double>>> entry : topics.entrySet()) { %>
											<% if(entry.getValue().size() > i) { %>
												<td><%=entry.getValue().get(i).getKey()%></td>
											<% } %>		
										<% } %>
										<tr>
									<% } %>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		<div id="blogPostsContainer1"></div>
	</div>
	



	
	
	<!--  Blogpost -->
<script>
class BlogPost {
	constructor(_id, _title, _author, _date, _numComments, _post, _location) {
		this.id= _id;
		this.title = _title;
		this.author = _author;
		this.date = _date;
		this.numComments = _numComments;
		this.post = _post;
		this.location = _location;
		this.topicDistrib = [];
	}
}
</script>

	<!-- Line Chart -->
	<script>

	class LineChart {

		constructor(_blogPostsData) {
			this.mouse;
			this.mousex;
			this.mousey;
			this.datearray;
			this.height = 230;
			this.blogPosts = _blogPostsData;
			this.data = [];
		}

		initialize() {
			this.processData("year");
			this.draw('#topicstream', this.height, this.data);
		}
		
		processData(range) {
			let distributions = {};
			let averages = {};
			this.data = [];
			
			if (range == "year") {
				// Collect blogs' topic distribution for each year
				for (var id in this.blogPosts) {
					if (this.blogPosts[id].date.substr(2,2) in distributions) {
						distributions[this.blogPosts[id].date.substr(2,2)].push(this.blogPosts[id].topicDistrib);
					}
					else {
						distributions[this.blogPosts[id].date.substr(2,2)] = [this.blogPosts[id].topicDistrib];
					}
				}
				// Average topic distribution for each year
				for (var year in distributions) {
					averages[year] = [];
					for (let topic = 0; topic < distributions[year][0].length; topic++) {
						let avg = 0;
						for (let i = 0; i < distributions[year].length; i++) {
							avg += distributions[year][i][topic]
						}
						averages[year].push(avg / distributions[year].length);
					}
				}
				// Format averaged data for the line chart 
				for (var year in averages) {
					for (let topic = 0; topic < averages[year].length; topic++) {
						let formatted_date = "01/01/" + year + " 0:00";
						//Full day format (use for monthly/weekly charts - i.e. 06/30/19 0:00)
						//formatted_date = ("0" + (date.getMonth() + 1)).slice(-2) + "/" + ("0" + date.getDate()).slice(-2) + "/" + date.getFullYear().toString().substr(-2) + " 0:00"; 
						this.data.push({"key": "Topic " + (topic + 1), "value": averages[year][topic].toFixed(3), "date": formatted_date});
					}
				}
			}
		}
		//console.log("This is data");
		//console.log(this.data); 
	    // Chart setup
	    draw(element, height, data) {
	    	console.log(data);

	        // Basic setup
	        // ------------------------------

	        // Define main variables
	        var d3Container = d3.select(element),
	            margin = {top: 5, right: 50, bottom: 40, left: 50},
	            width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right,
	            height = height - margin.top - margin.bottom,
	            tooltipOffset = 30;

	        // Tooltip
	        var tooltip = d3Container
	            .append("div")
	            .attr("class", "d3-tip e")
	            .style("display", "none")

	        // Format date
	        var format = d3.time.format("%m/%d/%y %H:%M");
	        var formatDate = d3.time.format("%H:%M");

	        // Colors
	        var colorrange = ['#03A9F4', '#29B6F6', '#4FC3F7', "#17394C", "#F5CC0E", "#CE0202"];



	        // Construct scales
	        // ------------------------------

	        // Horizontal
	        var x = d3.time.scale().range([0, width]);

	        // Vertical
	        var y = d3.scale.linear().range([height, 0]);

	        // Colors
	        var z = d3.scale.ordinal().range(colorrange);



	        // Create axes
	        // ------------------------------

	        // Horizontal
	        var xAxis = d3.svg.axis()
	            .scale(x)
	            .orient("bottom")
	            .ticks(d3.time.date, 2)
	            .innerTickSize(4)
	            .tickPadding(8)
	            .tickFormat(d3.time.format("%m/%d/%y")); // Display date in month day and year

	        // Left vertical
	        var yAxis = d3.svg.axis()
	            .scale(y)
	            .ticks(6)
	            .innerTickSize(4)
	            .outerTickSize(0)
	            .tickPadding(8)
	            // remove comma seperator
	             // .tickFormat(function (d) { return (d); });

	        // Right vertical
	        var yAxis2 = yAxis;

	        // Dash lines
	        var gridAxis = d3.svg.axis()
	            .scale(y)
	            .orient("left")
	            .ticks(6)
	            .tickPadding(8)
	            .tickFormat("")
	            .tickSize(-width, 0, 0);



	        // Create chart
	        // ------------------------------

	        // Container
	        var container = d3Container.append("svg")

	        // SVG element
	        var svg = container
	            .attr('width', width + margin.left + margin.right)
	            .attr("height", height + margin.top + margin.bottom)
	            .append("g")
	            .attr("transform", "translate(" + margin.left + "," + margin.top + ")");



	        // Construct chart layout
	        // ------------------------------

	        // Stack
	        var stack = d3.layout.stack()
	            .offset("silhouette")
	            .values(function(d) { return d.values; })
	            .x(function(d) { return d.date; })
	            .y(function(d) { return d.value; });

	        // Nest
	        var nest = d3.nest()
	            .key(function(d) { return d.key; });

	        // Area
	        var area = d3.svg.area()
	            .interpolate("cardinal")
	            .x(function(d) { return x(d.date); })
	            .y0(function(d) { return y(d.y0); })
	            .y1(function(d) { return y(d.y0 + d.y); });

	            // Pull out values
	            data.forEach(function (d) {
	                d.date = format.parse(d.date);
	                d.value = +d.value;
	            });

	            // // Stack and nest layers
	           var layers = stack(nest.entries(data));



	            // Set input domains
	            // ------------------------------

	            // Horizontal
	            x.domain(d3.extent(data, function(d, i) { return d.date; }));

	            // Vertical
	           y.domain([0, d3.max(data, function(d) { return d.y0+d.y; })]);



	            // Add grid
	            // ------------------------------

	            // Horizontal grid. Must be before the group
	            svg.append("g")
	                .attr("class", "d3-grid-dashed")
	                .call(gridAxis);



	            // //
	            // // Append chart elements
	            // //
	            //
	            // // Stream layers
	            // // ------------------------------
	            //
	            // Create group
	            var group = svg.append('g')
	                .attr('class', 'streamgraph-layers-group');

	            // And append paths to this group
	            var layer = group.selectAll(".streamgraph-layer")
	                .data(layers)
	                .enter()
	                    .append("path")
	                    .attr("class", "streamgraph-layer")
	                    .attr("d", function(d) { return area(d.values); })
	                    .style('stroke', '#fff')
	                    .style('stroke-width', 0.5)
	                    .style("fill", function(d, i) { return z(i); });

	            // Add transition
	            var layerTransition = layer
	                .style('opacity', 0)
	                .transition()
	                    .duration(750)
	                    .delay(function(d, i) { return i * 50; })
	                    .style('opacity', 1)



	            // // Append axes
	            // // ------------------------------
	            //
	            // //
	            // // Left vertical
	            // //
	            //
	            svg.append("g")
	                .attr("class", "d3-axis d3-axis-left d3-axis-solid")
	                .call(yAxis.orient("left"));

	            // // Hide first tick
	            d3.select(svg.selectAll('.d3-axis-left .tick text')[0][0])
	                .style("visibility", "hidden");

	            //
	            // //
	            // // Right vertical
	            // //
	            //
	            svg.append("g")
	                .attr("class", "d3-axis d3-axis-right d3-axis-solid")
	                .attr("transform", "translate(" + width + ", 0)")
	                .call(yAxis2.orient("right"));

	            // // Hide first tick
	            d3.select(svg.selectAll('.d3-axis-right .tick text')[0][0])
	                .style("visibility", "hidden");


	            // //
	            // // Horizontal
	            // //
	            //
	            var xaxisg = svg.append("g")
	                .attr("class", "d3-axis d3-axis-horizontal d3-axis-solid")
	                .attr("transform", "translate(0," + height + ")")
	                .call(xAxis);

	            // Add extra subticks for hidden hours
	            xaxisg.selectAll(".d3-axis-subticks")
	                .data(x.ticks(d3.time.date), function(d) { return d; })
	                .enter()
	                .append("line")
	                .attr("class", "d3-axis-subticks")
	                .attr("y1", 0)
	                .attr("y2", 4)
	                .attr("x1", x)
	                .attr("x2", x);



	            // Add hover line and pointer
	            // ------------------------------

	            // Append group to the group of paths to prevent appearance outside chart area
	            var hoverLineGroup = group.append("g")
	                .attr("class", "hover-line");

	            // Add line
	            var hoverLine = hoverLineGroup
	                .append("line")
	                .attr("y1", 0)
	                .attr("y2", height)
	                .style('fill', 'none')
	                .style('stroke', '#fff')
	                .style('stroke-width', 1)
	                .style('pointer-events', 'none')
	                .style('shape-rendering', 'crispEdges')
	                .style("opacity", 0);

	            // Add pointer
	            var hoverPointer = hoverLineGroup
	                .append("rect")
	                .attr("x", 2)
	                .attr("y", 2)
	                .attr("width", 6)
	                .attr("height", 6)
	                .style('fill', '#03A9F4')
	                .style('stroke', '#fff')
	                .style('stroke-width', 1)
	                .style('shape-rendering', 'crispEdges')
	                .style('pointer-events', 'none')
	                .style("opacity", 0);



	            // Append events to the layers group
	            // ------------------------------

	            layerTransition.each("end", function() {
	                layer
	                    .on("mouseover", function (d, i) {
	                        svg.selectAll(".streamgraph-layer")
	                            .transition()
	                            .duration(250)
	                            .style("opacity", function (d, j) {
	                                return j != i ? 0.75 : 1; // Mute all except hovered
	                            });
	                    })

	                    .on("mousemove", function (d, i) {
	                        this.mouse = d3.mouse(this);
	                        this.mousex = this.mouse[0];
	                        this.mousey = this.mouse[1];
	                        let datearray = [];
	                        var invertedx = x.invert(this.mousex);
	                        invertedx = invertedx.getDate();
	                        var selected = (d.values);
	                        for (var k = 0; k < selected.length; k++) {
	                            datearray[k] = selected[k].date
	                            datearray[k] = datearray[k].getDate();
	                        }
	                        
	                        let mousedate = datearray.indexOf(invertedx);
	                        let pro = d.values[mousedate].value;


	                        // Display mouse pointer
	                        hoverPointer
	                            .attr("x", this.mousex - 3)
	                            .attr("y", this.mousey - 6)
	                            .style("opacity", 1);

	                        hoverLine
	                            .attr("x1", this.mousex)
	                            .attr("x2", this.mousex)
	                            .style("opacity", 1);


	                        // Tooltip


	                        // Tooltip data
	                        tooltip.html(
	                            "<ul class='list-unstyled mb-5'>" +
	                                "<li>" + "<div class='text-size-base mt-5 mb-5'><i class='icon-circle-left2 position-left'></i>" + d.key + "</div>" + "</li>" +
	                                "<li>" + "Percentage: &nbsp;" + "<span class='text-semibold pull-right'>" + pro + "</span>" + "</li>" +
	                                "<li>" + "Date: &nbsp; " + "<span class='text-semibold pull-right'>" + format(d.values[mousedate].date) + "</span>" + "</li>" +
	                            "</ul>"
	                        )
	                        .style("display", "block");

	                        // Tooltip arrow
	                        tooltip.append('div').attr('class', 'd3-tip-arrow');
	                    })

	                    .on("mouseout", function (d, i) {

	                        // Revert full opacity to all paths
	                        svg.selectAll(".streamgraph-layer")
	                            .transition()
	                            .duration(250)
	                            .style("opacity", 1);

	                        // Hide cursor pointer
	                        hoverPointer.style("opacity", 0);

	                        // Hide tooltip
	                        tooltip.style("display", "none");

	                        hoverLine.style("opacity", 0);
	                    });
	                });


	            // Append events to the chart container
	            // ------------------------------
	/*             d3Container
	                .on("mousemove", function (d, i) {
	                    this.mouse = d3.mouse(this);
	                    this.mousex = this.mouse[0];
	                    this.mousey = this.mouse[1];

	                    // Display hover line
	                    // .style("opacity", 1);


	                    // Move tooltip vertically
	                    tooltip.style("top", (this.mousey - ($('.d3-tip').outerHeight() / 2)) - 2 + "px") // Half tooltip height - half arrow width

	                    // Move tooltip horizontally
	                    if (this.mousex >= ($(element).outerWidth() - $('.d3-tip').outerWidth() - margin.right - (tooltipOffset * 2))) {
	                        tooltip
	                            .style("left", (this.mousex - $('.d3-tip').outerWidth() - tooltipOffset) + "px") // Change tooltip direction from right to left to keep it inside graph area
	                            .attr("class", "d3-tip w");
	                    }
	                    else {
	                        tooltip
	                            .style("left", (this.mousex + tooltipOffset) + "px" )
	                            .attr("class", "d3-tip e");
	                    }
	                }); */

	        //});



	        // Resize chart
	        // ------------------------------

	        // Call function on window resize
	        $(window).on('resize', resizeStream);

	        // Call function on sidebar width change
	        // $('.sidebar-control').on('click', resizeStream);

	        // Resize function
	        //
	        // Since D3 doesn't support SVG resize by default,
	        // we need to manually specify parts of the graph that need to
	        // be updated on window resize
	        function resizeStream() {

	            // Layout
	            // -------------------------

	            // Define width
	            width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right;

	            // Main svg width
	            container.attr("width", width + margin.left + margin.right);

	            // Width of appended group
	            svg.attr("width", width + margin.left + margin.right);

	            // Horizontal range
	            x.range([0, width]);


	            // Chart elements
	            // -------------------------

	            // Horizontal axis
	            svg.selectAll('.d3-axis-horizontal').call(xAxis);

	            // Horizontal axis subticks
	            svg.selectAll('.d3-axis-subticks').attr("x1", x).attr("x2", x);

	            // Grid lines width
	            svg.selectAll(".d3-grid-dashed").call(gridAxis.tickSize(-width, 0, 0))

	            // Right vertical axis
	            svg.selectAll(".d3-axis-right").attr("transform", "translate(" + width + ", 0)");

	            // Area paths
	            svg.selectAll('.streamgraph-layer').attr("d", function(d) { return area(d.values); });
	        }
	    }
	}
 </script>
 
  <script type="text/javascript" src="assets/vendors/d3/d3.min.js"></script>
 <script type="text/javascript" src="assets/vendors/d3/d3.min.js"></script>
<script src="assets/vendors/wordcloud/d3.layout.cloud.js"></script>
<script type="text/javascript" src="assets/vendors/d3/d3_tooltip.js"></script>
<script type="text/javascript" src="assets/js/jquery.inview.js"></script>

 
<script type="text/javascript" src="chartdependencies/keywordtrendd3.js"></script>

<!-- Start for tables  -->
<script type="text/javascript" src="assets/vendors/DataTables/datatables.min.js"></script>
<script type="text/javascript" src="assets/vendors/DataTables/dataTables.bootstrap4.min.js"></script>
<script src="assets/vendors/DataTables/Buttons-1.5.1/js/buttons.flash.min.js"></script>
<script src="assets/vendors/DataTables/Buttons-1.5.1/js/dataTables.buttons.min.js"></script>
<script src="assets/vendors/DataTables/pdfmake-0.1.32/pdfmake.min.js"></script>
<script src="assets/vendors/DataTables/pdfmake-0.1.32/vfs_fonts.js"></script>
<script src="assets/vendors/DataTables/Buttons-1.5.1/js/buttons.html5.min.js"></script>
<script src="assets/vendors/DataTables/Buttons-1.5.1/js/buttons.print.min.js"></script>

<script>
 $(document).ready(function() {
	 
	
   // datatable setup
     $('#DataTables_Table_1_wrapper').DataTable( {
         "scrollY": 430,
         "scrollX": false,
          "pagingType": "simple"
    /*       ,
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

	<!--Word Cloud  -->
	<script>
	class WordCloud {

	    constructor(_wordCloudData) { 
	    	
	    	this.data = _wordCloudData;
	    	this.container = document.getElementById("tagcloudcontainer");
	    	this.width = this.container.offsetWidth;
	    	this.height = this.container.offsetHeight;
	    	
	    	
	    	
	    }
		
	    update() {	    	
	    	// Reset container first
			while (this.container.firstChild) {
				this.container.removeChild(this.container.firstChild);
			}
	    	//this.initialize(this.data[selectedTopic]);
	    	
	  
	    	const obj1 = this.data[selectedTopic].reduce((o, key) => Object.assign(o, {[key.text]: Math.round(key.size)}), {});
	    	var t = obj1;
	    	
	    	
	    	wordtagcloud(this.container,this.container.offsetHeight,  t); 
	    	
	    	
	    	
	    }
	    
	   
	    initialize(frequency_list) {

	        var color = d3.scale.linear()
	            .domain([0, 1, 2, 3, 4, 5, 6, 10, 15, 20, 50])
	            .range(["#17394C", "#F5CC0E", "#CE0202", "#1F90D0", "#999", "#888", "#777", "#666", "#555", "#444", "#333", "#222"]);

	        d3.layout.cloud().size([this.width, this.height])
	            .words(frequency_list)
	            .rotate(0)
	            .fontSize(function (d) { return d.size; })
	            .on("end", draw)
	            .start();

	        function draw(words) {
	            d3.select(".tagcloudcontainer").append("svg")
	                .attr("width", this.width)
	                .attr("height", this.height)
	                .attr("class", "wordcloud")
	                .append("g")
	                // without the transform, words words would get cutoff to the left and top, they would
	                // appear outside of the SVG area
	                .attr("transform", "translate(80,150)")
	                .selectAll("text")
	                .data(words)
	                .enter().append("text")
	                .style("font-size", function (d) { return d.size + "px"; })
	                .style("fill", function (d, i) { return color(i); })
	                .attr("transform", function (d) {
	                    return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")";
	                })

	                .text(function (d) { return d.text; });
	        }
	    }
	    
	 
	}
 </script>

	<!-- Chord Diagram --><!-- <script src="https://d3js.org/d3.v3.min.js"></script> -->
	<script>
 /*//////////////////////////////////////////////////////////
 ////////////////// Set up the Data /////////////////////////
 //////////////////////////////////////////////////////////*/

class ChordDiagram {

    constructor(_matrix, _height) {
    	this.matrix = _matrix;
    	this.names = [];
    	this.height = _height;
    	this.container = document.getElementById("chorddiagram");
    	this.colors = ["#C4C4C4", "#69B40F", "#EC1D25", "#C8125C", "#008FC8", "#10218B", "#134B24", "#737373", "#ffff00", "#ff79c5"];
    	
    	for (let i = 0; i < this.matrix.length; i++) {
    		this.names.push("Topic " + (i + 1));
    	}
    }

    initialize() {
    	this.selectTopic(0);
    }
    
    update() {
    	// Reset container first
		while (this.container.firstChild) {
			this.container.removeChild(this.container.firstChild);
		}
    	this.selectTopic(selectedTopic);
    }
    
    selectTopic(topic) {
    	//alert(topic);
    	let topicMatrix = [];
    	
    	for(let i = 0; i < this.matrix.length; i++) {
    		topicMatrix[i] = this.matrix[i].slice();
    	}
    	
    	for(let i = 0; i < topicMatrix.length; i++) {
    		for(let j = 0; j < topicMatrix.length; j++) {
	    		// Save incoming chords (j == topic) and arc sizes (i ==j)
	    		if (j != topic && i != j) {
	    			topicMatrix[i][j] = 0.0;
	    		}
    		}
    	}
    	
    	var rotation = 0;
    	var chord_options = {
    		    "gnames": this.names,
    		    "rotation": rotation,
    		    "colors": this.colors
    		};
    	this.draw(this.container, chord_options, topicMatrix, this.names); 
    	
    	//this.Chord(this.container, this.height, topicMatrix, this.names, this.colors);
    }
    
    draw(container, options, matrix, array) {
    	
    	/* function finalClick(t) {
            return this.selectTopic(t);
        } */
		
        // initialize the chord configuration variables
        var config = {
            width: 500,
            height: 600,
            rotation: 0,
            textgap: 40,
            colors: ["#C4C4C4", "#69B40F", "#EC1D25", "#C8125C", "#008FC8", "#10218B", "#134B24", "#737373", "#ffff00", "#ff79c5"]
        };
        
        // add options to the chord configuration object
        if (options) {
            extend(config, options);
        }
        
        // set chord visualization variables from the configuration object
        var offset = Math.PI * config.rotation,
            width = config.width,
            height = config.height,
            textgap = config.textgap,
            colors = config.colors;
        
        // set viewBox and aspect ratio to enable a resize of the visual dimensions 
        var viewBoxDimensions = "0 0 " + width + " " + height,
            aspect = width / height;
        
        var gnames = [];
        
        if (config.gnames) {
            gnames = config.gnames;
        } else {
            // make a list of names
            gnames = [];
            for (var i=97; i<matrix.length; i++) {
                gnames.push(String.fromCharCode(i));
            }
        }

        // start the d3 magic
        var chord = d3.layout.chord()
            .padding(.04)
            .sortSubgroups(d3.descending)
            .sortChords(d3.ascending) //which chord should be shown on top when chords cross. Now the biggest chord is at the bottom
            .matrix(matrix);

        var innerRadius = Math.min(width, height) * .35,
            outerRadius = innerRadius * 1.1;

        var fill = d3.scale.ordinal()
            .domain(d3.range(array.length-1))
            .range(colors);
    
        
        var d3Container = d3.select(container),
        margin = { top: 30, right: 10, bottom: 20, left: 25 },
        width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right,
        height = height - margin.top - margin.bottom;

    /*Initiate the color scale*/
    var fill = d3.scale.ordinal()
        .domain(d3.range(array.length))
        .range(colors);

    /*//////////////////////////////////////////////////////////
    /////////////// Initiate Chord Diagram /////////////////////
    //////////////////////////////////////////////////////////*/
    // var margin = {top: 30, right: 25, bottom: 20, left: 25},
    //     width = 650 - margin.left - margin.right,
    //     height = 600 - margin.top - margin.bottom,
    var innerRadius = Math.min(width, height) * .34,
        outerRadius = innerRadius * 1.10;

    var container = d3Container.append("svg:svg");

    /*Initiate the SVG*/
    // var svg = d3.select("#chart").append("svg:svg")
    var svg = container
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
        .append("svg:g")
        .attr("transform", "translate(" + (margin.left + width / 2) + "," + (margin.top + height / 2) + ")");
 
        var g = svg.selectAll("g.group")
            .data(chord.groups)
          .enter().append("svg:g")
            .attr("class", "group");

        g.append("svg:path")
            .style("fill", function(d) { return fill(d.index); })
            .style("stroke", function(d) { return fill(d.index); })
            
            .attr("id", function(d, i) { return "group" + d.index; })
            .attr("d", d3.svg.arc().innerRadius(innerRadius).outerRadius(outerRadius).startAngle(startAngle).endAngle(endAngle))
            .on("mouseover", fade(.02))
            .on("mouseout", fade(.80))
            .on("click",function(d){
            	selectedTopic = d.index;
            	topics.update();
            })
            .selectAll("path")
            .data(chord.chords)
             .enter().append("path")
          .append("svg:title")
            .text(function(d) { 
                return  d.source.value + " posts from " + gnames[d.source.index] + " in " + gnames[d.target.index]; 
            });
            
            /* .on("click",function(d){finalClick(d.index);}); */

////////////////////////////////////////////////////////////
////////////////// Append Names ////////////////////////////
////////////////////////////////////////////////////////////

        g.append("svg:text")
            .each(function(d) {d.angle = ((d.startAngle + d.endAngle) / 2) + offset; })
            .attr("dy", ".35em")
            //.attr("font-size", "100px")
            .attr("text-anchor", function(d) { return d.angle > Math.PI ? "end" : null; })
            .attr("transform", function(d) {
                return "rotate(" + (d.angle * 180 / Math.PI - 90) + ")"
                    + "translate(" + (innerRadius + 55) + ")"
                    + (d.angle > Math.PI ? "rotate(180)" : "");
              })
              
            .text(function(d) { return gnames[d.index]; });

        svg.append("g")
        
            .attr("class", "chord")
            
          .selectAll("path")
            .data(chord.chords)
            
          .enter().append("path")
            .attr("d", d3.svg.chord().radius(innerRadius).startAngle(startAngle).endAngle(endAngle))
            
            .style("fill", function(d) { return fill(d.source.index); })
            .style("opacity", 1)
            
          .append("svg:title")
            .text(function(d) { 
                return  d.source.value + " posts from " + gnames[d.source.index] + " in " + gnames[d.target.index]; 
            });
        
////////////////////////////////////////////////////////////
////////////////// Append Ticks ////////////////////////////
////////////////////////////////////////////////////////////
        
        var ticks = svg.append("svg:g").selectAll("g.ticks")
         .data(chord.groups)
         .enter().append("svg:g").selectAll("g.ticks")
         .attr("class", "ticks")
         .data(groupTicks)
	     .enter().append("svg:g")
         .attr("transform", function(d) {
      return "rotate(" + (d.angle * 180 / Math.PI - 90) + ")"
          + "translate(" + outerRadius+40 + ",0)";
    });

        ticks.append("svg:line")
    .attr("x1", 1)
    .attr("y1", 0)
    .attr("x2", 5)
    .attr("y2", 0)
    .style("stroke", "#000");

ticks.append("svg:text")
    .attr("x", 8)
    .attr("dy", ".35em")
    .attr("transform", function(d) { return d.angle > Math.PI ? "rotate(180)translate(-16)" : null; })
    .style("text-anchor", function(d) { return d.angle > Math.PI ? "end" : null; })
    .text(function(d) { return d.label; });
    
    
        
        // helper functions start here
        
        function startAngle(d) {
            return d.startAngle + offset;
        }

        function endAngle(d) {
            return d.endAngle + offset;
        }
        
        function extend(a, b) {
            for( var i in b ) {
            	
                a[ i ] = b[ i ];
            }
        }

        // Returns an event handler for fading a given chord group.
        function fade(opacity) {
            return function(g, i) {
                svg.selectAll(".chord path")
                    .filter(function(d) { return d.source.index != i && d.target.index != i; })
                    .transition()
                    .style("opacity", opacity);
            };
        }
        
        // Returns an array of tick angles and labels, given a group.
 function groupTicks(d) {
  var k = (d.endAngle - d.startAngle) / d.value;
  return d3.range(0, d.value, 100).map(function(v, i) {
    return {
      angle: v * k + d.startAngle,
      label: i % 1 ? null : v 
    };
  });
} //groupTicks
        
        window.onresize = function() {
            var targetWidth = (window.innerWidth < width)? window.innerWidth : width;
            
            var svg = d3.select("#chorddiagram")
                .attr("width", targetWidth)
                .attr("height", targetWidth / aspect);
        }
        };


        
 }


 </script>

	<!-- Data -->
	<script>
	
  	let _wordCloudData = [];
   
  	let _topicNumbers = [];
   
	let _blogDistribData = [];
	let _blogMentionData = [];
	let _postMentionData = [];
	let _bloggerData = [];
	
	let _blogPostsData = {};
	
	let _chordDiagramMatrix = [];
	
	<% for (TopicModelling.Documents.Document doc : blogposts) { %>
			_blogPostsData["<%=doc.blog_id%>"] = new BlogPost("<%=doc.blog_id%>", "<%=doc.blog_title%>", "<%=doc.blog_author%>", "<%=doc.blog_date%>", "<%=doc.blog_numComments%>", "<%=doc.blog_post%>", "<%=doc.blog_location%>");
			<% for(Map.Entry<Integer, ArrayList<Pair<String, Double>>> entry : topics.entrySet()) { %>
				_blogPostsData["<%=doc.blog_id%>"].topicDistrib.push(<%=doc.theta[entry.getKey()]%>);
			<% } %>
	<% } %>
	
	<% for(int i : topics.keySet()) { %>	
		_wordCloudData.push([]);
	 	<% for(int j = 0; j < WORDCLOUD_MAXWORDS; j++) { %>
	 		_wordCloudData[_wordCloudData.length - 1].push({"text":"<%=topics.get(i).get(j).getKey()%>","size":<%=topics.get(i).get(j).getValue() * 5000%>});
		<% } %>
		
		_topicNumbers.push(<%=i%>);
		
		_blogDistribData.push("<%=NumberFormat.getPercentInstance(Locale.US).format(blogDistribution[i])%>");
		_blogMentionData.push(<%=bloggerMention[i]%>);
		_postMentionData.push(<%=postMention[i]%>);
		_bloggerData.push("<%=topBloggers[i]%>");
		_chordDiagramMatrix.push([]);
		<% for(int j : topics.keySet()) { %>
			_chordDiagramMatrix[_chordDiagramMatrix.length - 1].push(<%=blogDistributionMatrix[i][j]%>);
		<% } %>
	<% } %>
	console.log("matrix data")
	console.log(_chordDiagramMatrix)
	
	console.log("blogPosts Data ")
	//console.log(_blogPostsData)
	
	</script>

<!--  Blogposts -->
<script>
class BlogPosts {
	constructor(_blogPostsData) {
		this.container = document.getElementById("blogPostsContainer1");
		this.postContainer = document.getElementById("blogPostContainer");
		this.titleContainer = document.getElementById("titleContainer");
		this.authorContainer = document.getElementById("authorContainer");
		this.dateContainer = document.getElementById("dateContainer");
		this.postContainer = document.getElementById("postContainer");
		this.numCommentsContainer = document.getElementById("numCommentsContainer");
		this.blogPosts = _blogPostsData;
		this.blogRows = [];
	}
	
	update() {	
		
		// Reset container
		$("#table_view").html("");
		$('#table_view').empty();
		
		//$("#table_display").addClass("hidden");
		$("#table_display_loader").removeClass("hidden");
		
		while (this.container.firstChild) {
			this.container.removeChild(this.container.firstChild);
		}
		
		this.blogRows = [];
		
		var details = "<table id='DataTables_Table_0_wrapper' class='display' style='width: 100%;'>";
			details += '<thead>';
				details += '<tr>';
					details += '<th>Post title</th>';
						details += '	<th>Topic weight</th>';
							details += '</tr>';
								details += '	</thead>';
									details += '	<tbody id="blogPostsContainer1">';
			
		var i = 1;
		
		for (var id in this.blogPosts) {
			let distrib = this.blogPosts[id].topicDistrib[selectedTopic];
			
			
			if (distrib > topicDistribThreshold) {
				let row = document.createElement("tr");
				row.setAttribute("blogId", id);
				let titleCell = document.createElement("td");
				let percentCell = document.createElement("td");
				titleCell.innerHTML = this.blogPosts[id].title;
				percentCell.innerHTML = parseFloat(distrib*100).toFixed(0)+"%";
				row.appendChild(titleCell);
				row.appendChild(percentCell);
				row.addEventListener("click", this.blogPostClickListener.bind(this));
				this.blogRows.push(row);
				//this.container.appendChild(row);
				details += '<tr>';
				details += '<td ><a blogid='+id+' id="blog_'+id+'" class="blogPostClickListener blogpost_link cursor-pointer">'+this.blogPosts[id].title+'</a>  <br/>';
				details += '<a id="viewpost_'+id+'" class="mt20 viewpost makeinvisible" href="'+this.blogPosts[id].permalink+'" target="_blank"><buttton class="btn btn-primary btn-sm mt10 visitpost">Visit Post &nbsp;<i class="fas fa-external-link-alt"></i></buttton></a></td>';
				details += '<td>'+parseFloat(distrib*100).toFixed(0)+'%</td>';
				details += '</tr>';
				
				
			}
			
		}
		
		details += '</tbody>';
		details += '</table>';
		
		$('#table_view').html(details);
	
		if ( $.fn.DataTable.isDataTable('#DataTables_Table_0_wrapper') ) {
			// alert("already");
			// $('#DataTables_Table_0_wrapper').DataTable().destroy();
			}    
				
				
				// $('#DataTables_Table_0_wrapper').DataTable().destroy();
				// table set up for topic
			     $('#DataTables_Table_0_wrapper').DataTable( {
			         "scrollY": 430,
			         "scrollX": false,
			          "pagingType": "simple"
			     /*      ,
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
			
			
			
			
		
		
		
	     $("#table_display_loader").addClass("hidden");
	   
		// Initialize details blog view with first blog
		if (this.blogRows.length > 0) {
			this.blogRows[0].click();
		}
	}
	
	blogPostClickListener(blog_data) {
		let selection = event.target;
        if (event.target.tagName == "TD") {
        	selection = event.target.parentElement;
        }
        let id = selection.getAttribute("blogId");
        
        //this.titleContainer.innerHTML = this.blogPosts[id].title;
		//this.authorContainer.innerHTML = this.blogPosts[id].author;
		//this.dateContainer.innerHTML = this.blogPosts[id].date;
		//this.postContainer.innerHTML = this.blogPosts[id].post;
		//this.numCommentsContainer.innerHTML = this.blogPosts[id].numComments + " comments";
		
		blog_data = _blogPostsData;
		
		$(".viewpost").addClass("makeinvisible");
    	$('.blogpost_link').removeClass("activeselectedblog");
    	$('#blog_'+id).addClass("activeselectedblog");
    	$("#viewpost_"+id).removeClass("makeinvisible");
		
		
		$('#titleContainer').html(blog_data[id].title);
    	$('#authorContainer').html(blog_data[id].author);
    	$('#dateContainer').html(blog_data[id].date);
    	$('#postContainer').html(blog_data[id].post);
    	$('#numCommentsContainer').html(blog_data[id].numComments + " comments");
			
	}
	
	
}

$(document).delegate('.blogPostClickListener', 'click', function(){
	var a_view_model = new BlogPosts();
	a_view_model.blogPostClickListener(_blogPostsData);
	
});
</script>

<!--  Topics -->
<script>
class Topics {
	
	constructor(topics, _statsBar, _blogPosts, _wordCloud, _chordDiagram) {
		this.statsBar = _statsBar;
		this.blogPosts= _blogPosts;
		this.wordCloud = _wordCloud;
		this.chordDiagram = _chordDiagram;
		this.topicButtons = [];
		this.container = document.getElementById("topicsContainer");
		this.searchBox = document.getElementById("topicsSearch");
		this.topicElements = document.getElementsByClassName("topic");
		
		this.searchBox.addEventListener("keyup", this.searchBoxKeyUpListener.bind(this));
		
		topics.forEach(topicNumber => {
			let topicButton = this.createTopicButton(topicNumber);
			this.topicButtons.push(topicButton);
			topicButton.addEventListener("click", this.topicButtonClickListener.bind(this));
			this.container.appendChild(topicButton);			
			})
    }
	
	initialize() {
		// Select first topic by default
		this.topicButtons[0].click();
	}
	
	update() {
        for (var i = 0; i < this.topicElements.length; i++) {
        	this.topicElements[i].innerHTML = "Topic " + (selectedTopic + 1);	
        }
        this.statsBar.update();
        this.blogPosts.update();
        this.wordCloud.update();
        this.chordDiagram.update();
	}
	
	topicButtonClickListener(event) {
		let selectedButton = event.target;
		
        if (event.target.tagName == "B") {
        	selectedButton = event.target.parentElement;
        }
		
		// Quit if clicking on active topic
        if (selectedButton.classList.contains("stylebuttonactive")) {
        	return
        }
        
        // Deselect current active topic
        this.topicButtons.forEach(topicButton => {
        	if (topicButton.classList.contains("stylebuttonactive")) {
        		topicButton.classList.remove("btn-primary", "stylebuttonactive", "activebar")
        		topicButton.classList.add("stylebuttoninactive", "opacity53", "text-primary");
        	}
        })        
        
        if (selectedButton.classList.contains("stylebuttoninactive")) {
        	selectedTopic = parseInt(selectedButton.getAttribute("topicNumber"));
        	selectedButton.classList.remove("stylebuttoninactive", "opacity53", "text-primary");        		
        	selectedButton.classList.add("btn-primary", "stylebuttonactive", "activebar")
        }
        
		this.update();
    }
	
    searchBoxKeyUpListener() {            
        let searchValue = event.target.value;
        //Dynamic Search List
        if(searchValue.length == 0 ){ //Reset list
            for(var i=0; i < this.topicButtons.length; i++){
            	this.topicButtons[i].style.display = 'block';}
        }
        for(var i=0; i < this.topicButtons.length; i++){//Reset list after backspacing
            if((this.topicButtons[i].getElementsByTagName('b')[0].innerHTML).toUpperCase().includes(searchValue.toUpperCase())){
            	this.topicButtons[i].style.display = 'block';
            }
            else if(!(this.topicButtons[i].getElementsByTagName('b')[0].innerHTML).toUpperCase().includes(searchValue.toUpperCase())){//Hide unmatched search results
            	this.topicButtons[i].style.display = 'none';
            }
        }
	}
	
	createTopicButton(n) {
		let element = document.createElement("a");
		element.classList.add("btn", "form-control", "stylebuttoninactive", "mb20", "opacity53", "text-primary");
		element.setAttribute("topicNumber", n);
		let bold = document.createElement("b");
		bold.innerHTML = "Topic " + (n + 1);
		element.appendChild(bold);
		return element;
	}
	
}
</script>

<!-- Stats Bar  -->
<script>
class StatsBar {
	
	constructor(_blogDistribData, _blogMentionData, _postMentionData, _bloggerData) {
		this.blogDistributionElement = document.getElementById("blogDistribution");
		this.bloggerMentionElement = document.getElementById("bloggerMention");
		this.postMentionnElement = document.getElementById("postMention");
		this.topAuthorElement = document.getElementById("topAuthor");
		this.blogDistribData = _blogDistribData;
		this.blogMentionData = _blogMentionData;
		this.postMentionData = _postMentionData;
		this.bloggerData = _bloggerData;
	}
	
	update() {
		this.blogDistributionElement.innerHTML = this.blogDistribData[selectedTopic];
		this.bloggerMentionElement.innerHTML = this.blogMentionData[selectedTopic];
		this.postMentionnElement.innerHTML = this.postMentionData[selectedTopic];
		this.topAuthorElement.innerHTML = this.bloggerData[selectedTopic];
	}
	
}
</script>

<!--  Main -->
<script>

let selectedTopic;
let topicDistribThreshold = <%=TOPIC_THRESHOLD%>;
let topics;

document.addEventListener("DOMContentLoaded", function() {

	let statsBar = new StatsBar(_blogDistribData, _blogMentionData, _postMentionData, _bloggerData);
	let blogPosts = new BlogPosts(_blogPostsData);
	let lineChart = new LineChart(_blogPostsData);
	let chordDiagram = new ChordDiagram(_chordDiagramMatrix, 400);
	let wordCloud = new WordCloud(_wordCloudData);
	//let topicDataTable = new TopicDataTable();
	topics = new Topics(_topicNumbers, statsBar, blogPosts, wordCloud, chordDiagram);
	
	topics.initialize();
	lineChart.initialize();
	//topicDataTable.initialize(); // DataTable formatting. Triggers error and causes other charts to disappear
});

</script>
</body>
<%} %>
</html>
