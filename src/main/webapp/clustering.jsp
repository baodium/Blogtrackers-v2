<%-- <%@page import="breeze.linalg.cholesky$"%> --%>
<%@page import="com.fasterxml.jackson.databind.ObjectMapper"%>
<%@page import="authentication.*"%>
<%@page import="java.util.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="util.*"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.*"%>
<%@page import="javafx.util.Pair"%>
<%@page import="java.time.*"%>


<%-- <%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="org.json.simple.parser.ParseException"%> --%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
Instant start = Instant.now();
	Object email = (null == session.getAttribute("email")) ? "" : session.getAttribute("email");
	Object tid = (null == request.getParameter("tid")) ? "" : request.getParameter("tid");
	//if (email == null || email == "") {
	//response.sendRedirect("login.jsp");
	//}else{

	ArrayList<?> userinfo = new ArrayList();
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

			//System.out.println("new_pat--"+path_new);

			File path_new = new File(application.getRealPath("/").replace('/', '/') + "images/profile_images");
			if (f.exists() && !f.isDirectory()) {
				profileimage = "images/profile_images/" + userinfo.get(2).toString() + ".jpg";
			} else {
				/* new File("/path/directory").mkdirs(); */
				path_new.mkdirs();
				//System.out.println("pathhhhh1--" + path_new);
			}

			if (path_new.exists()) {

				String t = "/images/profile_images";
				int p = userpic.indexOf(t);
				//System.out.println(p);
				if (p != -1) {

					System.out.println("pic path---" + userpic);
					System.out.println("path exists---" + userpic.substring(0, p));
					String path_update = userpic.substring(0, p);
					if (!path_update.equals(path_new.toString())) {
						profileimage = "images/profile_images/" + userinfo.get(2).toString() + ".jpg";
						/* profileimage=userpic.replace(userpic.substring(0, p), path_new.toString()); */
						String new_file_path = path_new.toString().replace("\\images\\profile_images", "") + "/"
								+ profileimage;
						System.out.println("ready to be updated--" + new_file_path);
						/*new DbConnection().updateTable("UPDATE usercredentials SET profile_picture  = '" + pass + "' WHERE Email = '" + email + "'"); */
					}
				} else {
					path_new.mkdirs();
					profileimage = "images/profile_images/" + userinfo.get(2).toString() + ".jpg";
					/* profileimage=userpic.replace(userpic.substring(0, p), path_new.toString()); */
					String new_file_path = path_new.toString().replace("\\images\\profile_images", "") + "/"
							+ profileimage;
					System.out.println("ready to be updated--" + new_file_path);

					new DbConnection().updateTable(
							"UPDATE usercredentials SET profile_picture  = '" + "images/profile_images/"
									+ userinfo.get(2).toString() + ".jpg" + "' WHERE Email = '" + email + "'");
					System.out.println("updated");
				}
			} else {
				System.out.println("path doesnt exist");
			}
		} catch (Exception e) {
		}

	}

	Clustering cluster = new Clustering();

	//String url = "http://114.167.35.50:5000/";
	/* String url = "http://127.0.0.1:5000/"; */
	/* JSONParser jsonParser = new JSONParser();
	FileReader reader = new FileReader(request.getContextPath()+"\\clustering.json");
	Object obj = jsonParser.parse(reader);
	
	JSONObject query = new JSONObject(obj.toString()); */
	//System.out.println(query);

	/* JSONObject query = cluster.getPostsbyIdForApi("806","2012-11-03","2019-10-16");
	JSONObject result = cluster.getResult2(url, query.toString());  */

	//JSONObject result = cluster._getResult(url, query);
	//JSONObject result = cluster._getResult3(url, query);

	/* System.out.println(result);
	String postMentioned = null; */

	/* for(int i = 0; i < result.length(); i++){
	Object posts_ids = result.getJSONArray(String.valueOf(i)).getJSONObject(0).getJSONObject("cluster_" + (i + 1)).getJSONArray("post_ids");
	System.out.println(posts_ids.toString());
	}   */
	//System.out.println(result.length());
	//JSONObject result = new JSONObject();
	String tracker_id = tid.toString();
	//get postids from each cluster in tracker and save in JSONObject
	ArrayList result = cluster._getClusters(tracker_id);

	JSONObject res = new JSONObject(result.get(0).toString());
	JSONObject source = new JSONObject(res.get("_source").toString());

	//			ArrayList R2 = (ArrayList)result.get(0);
	//for()
	//			System.out.println(source.get("cluster_3"));
	HashMap<Pair<String, String>, JSONArray> clusterResult = new HashMap<Pair<String, String>, JSONArray>();
	//JSONObject key_val = new JSONObject();
	Pair<String, String> key_val = new Pair<String, String>(null, null);

	HashMap<String, String> key_val_posts = new HashMap<String, String>();
	ArrayList<JSONObject> scatterplotfinaldata = new ArrayList<JSONObject>();
	
	JSONObject distances = new JSONObject();
	HashMap<String, String> topterms = new HashMap<String, String>();
	
	String find = "";
	
	for (int i = 1; i < 11; i++) {
		String cluster_ = "cluster_" + String.valueOf(i);
		String centroids = "C" + String.valueOf(i) + "xy";
		JSONObject cluster_data = new JSONObject(source.get(cluster_).toString());
		
		String post_ids = cluster_data.get("post_ids").toString();
		///break;
		
		String centroid = source.get(centroids).toString().replace("[", "").replace("]", "");
		String centroid_x = centroid.split(",")[0].trim();
		String centroid_y = centroid.split(",")[1].trim();
		//System.out.println(centroid);
		
		ArrayList svd = cluster._getSvd(post_ids);
		int counter = 0;
		for(int j = 0; j < svd.size(); j++){
			
			JSONObject scatter_plot = new JSONObject();
			JSONObject source_ = new JSONObject(svd.get(j).toString());
			Object x_y = source_.getJSONObject("_source").get("svd");
			Object p_id = source_.getJSONObject("_source").get("post_id");
			x_y = x_y.toString().replaceAll("\\s+", " ");
			
			String x = x_y.toString().split(" ")[0];
			String y = x_y.toString().split(" ")[1];
			
			//System.out.println(x_y.toString());
			//System.out.println(x +"--"+ y);
			
			//System.out.println(svd);
			String postid = p_id.toString();
			/* if(p_id.toString().equals("62675")){
				find = x_y.toString() + "--" + x + "--" + y;
			
				
			} */
			scatter_plot.put("cluster",String.valueOf(i));
			scatter_plot.put("",String.valueOf(counter));
			scatter_plot.put("new_x",x);
			scatter_plot.put("new_y",y);
			//scatter_plot.put("post_id",postid);
			
			counter++;
			
			//Double.parseDouble(s)
			double left = Math.pow((double)Double.parseDouble(x) - (double)Double.parseDouble(centroid_x), 2);
			double right = Math.pow((double)Double.parseDouble(y) - (double)Double.parseDouble(centroid_y), 2);
			String distance = String.valueOf(Math.pow((left + right), 0.5));
			distances.put(postid, distance); 
			scatterplotfinaldata.add(scatter_plot);
			
		}
		
		//scatterplotfinaldata.add(new JSONObject("{columns:['','new_x','new_y','cluster']}"));
		//System.out.println(svd);
		
		JSONArray postDataAll = cluster.getPosts(post_ids, "", "", "__ONLY__POST__ID__");

		//String terms = cluster.getTopTerms(post_ids);
		//System.out.println(terms);
		//System.out.println("done");

		
		
		String terms = cluster_data.get("topterms").toString();
		//String terms = cluster.getTopTerms(post_ids);
		System.out.println(terms);

		topterms.put(cluster_,terms);
		
		key_val = new Pair<String, String>(cluster_, post_ids);
		//key_val.put(cluster_,post_ids);
		System.out.println("clusters --" + cluster_);

		/* for(int j = 0; j < postDataAll.length(); j++){
			
		} */
		key_val_posts.put(cluster_, post_ids);
		clusterResult.put(key_val, postDataAll);
		
		

	}

	//System.out.println(topterms.size());
	//System.out.println("find --" + find);
	session.setAttribute(tid.toString() + "cluster_terms", topterms);
	session.setAttribute(tid.toString() + "cluster_distances", distances);
	session.setAttribute(tid.toString() + "cluster_result", clusterResult);
	session.setAttribute(tid.toString() + "cluster_result_key_val", key_val_posts);
	//
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Blogtrackers - Clustering</title>
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
<script  src="pagedependencies/clustering.js">
</script>

<script>
//console.log('scatter data');

</script>

</head>
<body>
	<input type="hidden" id="tid" value="<%=tid.toString()%>" />
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
			<!-- <div class="navbar-header ">
          <a class="navbar-brand text-center" href="#"><img src="images/blogtrackers.png" /></a>
          </div> -->
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

		<!-- <div class="col-md-12 mt0">
          <input type="search" class="form-control p30 pt5 pb5 icon-big border-none bottom-border text-center blogbrowsersearch nobackground" placeholder="Search Trackers" />
          </div> -->

	</nav>
	<div class="container analyticscontainer">
		<div class="row bottom-border pb20">
			<div class="col-md-6 paddi">
				<nav class="breadcrumb">
					<a class="breadcrumb-item text-primary" href="trackerlist.html">MY
						TRACKER</a> <a class="breadcrumb-item text-primary" href="#">Second
						Tracker</a> <a class="breadcrumb-item active text-primary"
						href="postingfrequency.html">Clustering</a>

				</nav>
				<div>
					Tracking:
					<button class="btn btn-primary stylebutton1">All Blogs</button>
				</div>
			</div>

			<div class="col-md-6 text-right mt10">
				<div class="text-primary demo">
					<h6 id="reportrange">
						Date: <span>02/21/18 - 02/28/18</span>
					</h6>
				</div>
				<div>
					<div class="btn-group mt5" data-toggle="buttons">
						<!--  <label class="btn btn-primary btn-sm daterangebutton legitRipple nobgnoborder"> <input type="radio" name="options" value="day" autocomplete="off" > Day
  	</label>
    <label class="btn btn-primary btn-sm nobgnoborder"> <input type="radio" name="options" value="week" autocomplete="off" >Week
  	</label>
     <label class="btn btn-primary btn-sm nobgnoborder nobgnoborder"> <input type="radio" name="options" value="month" autocomplete="off" > Month
  	</label>
    <label class="btn btn-primary btn-sm text-center nobgnoborder">Year <input type="radio" name="options" value="year" autocomplete="off" >
  	</label>
    <label class="btn btn-primary btn-sm nobgnoborder " id="custom">Custom</label> -->
					</div>

					<!-- Day Week Month Year <b id="custom" class="text-primary">Custom</b> -->

				</div>
			</div>
		</div>

		<!-- <div class="row p40 border-top-bottom mt20 mb20">
  <div class="col-md-2">
<small class="text-primary">Selected Blogger</small>
<h2 class="text-primary styleheading">AdNovum <div class="circle"></div></h2>
</div>
  <div class="col-md-10">
  <small class="text-primary">Find Blogger</small>
  <input class="form-control inputboxstyle" placeholder="| Search" />
  </div>
</div> -->

		<div class="row mt20">
			<div class="col-md-3">

				<div class="card card-style mt50" style="height: 450px;">
					<div class="card-body  p30 pt5 pb5 mb40">
						<h5 class="mt20 mb20">Clusters</h5>
						<!-- <div style="padding-right: 10px !important;">
							<input type="search" class="form-control stylesearch mb20"
								placeholder="Search " />
						</div> -->
						<div class="scrolly"
							style="height: 350px; padding-right: 10px !important;">
							<%
								String bloggersMentioned = null;
								String currentPostIdsCount = null;
								String topPostingLocation = null;
								String currentPostIds = null;
								String blogDistribution = null;
								String total = source.get("total").toString();
								session.setAttribute(tid.toString() + "clusters_total", total);
								String blogdistribution = null;
								JSONArray postData = new JSONArray();

								String[] colors = {"green", "red", "blue", "orange", "purple", "pink", "black", "grey", "brown", "yellow"};
								int i = 0;
								Pair<String, String> currentKey = new Pair<String, String>(null, null);

								for (Map.Entry<Pair<String, String>, JSONArray> entry : clusterResult.entrySet()) {
									Pair<String, String> key = entry.getKey();

									if (key.getKey().equals("cluster_1")) {

										currentKey = key;

										/* System.out.println(postData.length()); */

										String value = key.getValue();
										//System.out.println("This is key--" + key.getKey());
										/* currentPostIds = clusterResult.get("cluster_" + String.valueOf((i + 1)));  */
										currentPostIds = value.toString();
										String[] arr = currentPostIds.split(",");
										currentPostIdsCount = String.valueOf(arr.length);
										//String str = currentPostIds.toString().replaceAll("\\[", "").replaceAll("\\]", "").replace("\"", "");
										bloggersMentioned = cluster.getBloggersMentioned(currentPostIds);
										topPostingLocation = cluster.getTopPostingLocation(currentPostIds);
										//System.out.println(currentPostIds);
										//System.out.println(total);
										blogdistribution = cluster.getBlogDistribution(currentPostIds, (double) Integer.parseInt(total));

										/* postData = cluster.getPosts(currentPostIds, "", "", "__ONLY__POST__ID__");
										System.out.println(postData.length()); */
							%>
							<a class="clusters_ btn  form-control stylebuttonactive mb20 "
								id="cluster_<%=i + 1%>" counter_value="<%=i  +1%>"
								style="background-color: <%=colors[i]%>;"> <b>Cluster <%=i + 1%></b>
							</a>
							<%
								} else {
							%>
							<a
								class="clusters_ btn form-control stylebuttoninactive text-primary mb20 "
								id="cluster_<%=i + 1%>" counter_value="<%=i+1 %>"
								style="background-color: <%=colors[i]%>;"> <b>Cluster <%=i + 1%></b>
							</a>
							<%
								}
									i++;
								}
							%>
							<!-- <a
								class="btn form-control stylebuttoninactive opacity53 text-primary mb20"><b>Cluster
									2</b></a> <a
								class="btn form-control stylebuttoninactive opacity53 text-primary mb20"><b>Cluster
									3</b></a> <a
								class="btn form-control stylebuttoninactive opacity53 text-primary mb20"><b>Cluster
									4</b></a> <a
								class="btn form-control stylebuttoninactive opacity53 text-primary mb20"><b>Cluster
									5</b></a> <a
								class="btn form-control stylebuttoninactive opacity53 text-primary mb20"><b>Cluster
									6</b></a> <a
								class="btn form-control stylebuttoninactive opacity53 text-primary mb20"><b>Cluster
									7</b></a> <a
								class="btn form-control stylebuttoninactive opacity53 text-primary mb20"><b>Cluster
									8</b></a> -->

						</div>


					</div>
				</div>
			</div>

			<div class="col-md-9">
				<div class="card card-style mt20">
					<div class="card-body  p30 pt5 pb5">
						<div style="min-height: 250px;">
							<div>
								<p class="text-primary mt10">Cluster Map</p>
							</div>

							<div class="chart-container">
								<div class="chart" id="clusterdiagram"></div>
								
								<div id="clusterdiagram_loader" class="hidden">
								<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />
							</div>
							</div>
							
						</div>
					</div>
				</div>
				<div class="card card-style mt20">
					<div class="card-body  p30 pt20 pb20">
						<div class="row">
							<div class="col-md-3 mt5 mb5">
								<h6 class="card-title mb0">Blog Distribution</h6>
								<h3 class="mb0 text-primary text-statistics "
									id="blogdistribution"><%=(null == blogdistribution) ? "" : blogdistribution%></h3>
								<!-- <small class="text-success">+5% from <b>Last Week</b></small> -->
							</div>

							<div class="col-md-3 mt5 mb5">
								<h6 class="card-title mb0">Bloggers Mentioned</h6>
								<h3 class="mb0 text-primary text-statistics"
									id="bloggersmentioned"><%=(null == bloggersMentioned) ? "" : bloggersMentioned%></h3>
								<!-- <small class="text-success">+5% from <b>Last Week</b></small> -->
							</div>

							<div class="col-md-3 mt5 mb5">
								<h6 class="card-title mb0">Post Mentioned</h6>
								<h3 class="mb0 text-primary text-statistics" id="postmentioned"><%=(null == currentPostIdsCount) ? "" : currentPostIdsCount%></h3>
								<!-- <small class="text-success">+5% from <b>Last Week</b></small> -->
							</div>

							<div class="col-md-3  mt5 mb5">
								<h6 class="card-title mb0">Top Posting Location</h6>
								<h3 class="mb0 text-primary text-statistics"
									id="postinglocation"><%=(null == topPostingLocation) ? "" : topPostingLocation%></h3>
							</div>

						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="row mb0">
			<div class="col-md-6 mt20 ">
				<div class="card card-style mt20">
					<div class="card-body  p20 pt5 pb5">
						<div>
							<p class="text-primary mt10">
								Keywords of <b class="text-blue activeblog">Cluster 1</b> of
								Past <b class="text-success">Week</b>
							</p>
							
						</div>
						
						<div id="new_word">
							<div id="tagcloudcontainer1" class="hidden " style="min-height: 300px;"></div>
						</div>
						
						
						
						<div class="chart-container keyword_display" id="keyword_display">
							<div id="tagcloudcontainer" style="min-height: 300px;"></div>
						</div>
						
						
						<div style="height: 250px; padding-right: 10px !important;" id="keyword_display_loader" class="hidden">
							<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />
						</div>
					</div>
				</div>
			</div>

			<div class="col-md-6 mt20">
				<div class="card card-style mt20">


					<div class="card-body p20 pt0 pb20" style="min-height: 300px;">
						<div>
							<p class="text-primary mt10">
								<b class="text-blue activeblog">Cluster 1</b> of Past <b
									class="text-success">Week</b>
							</p>
						</div>
						<div class="chart-container">
							<div class="chart svg-center" id="chorddiagram"></div>


						</div>
					</div>

				</div>
			</div>

		</div>

		<div class="row m0 mt20 mb20 d-flex align-items-stretch">
			<div
				class="col-md-6 mt20 card card-style nobordertopright noborderbottomright">
				<div class="card-body p0 pt20 pb20" style="min-height: 420px;">
					<p>
						Posts from <b class="text-success activeblog">Cluster 1</b>
					</p>
					<!-- <div class="p15 pb5 pt0" role="group">
          Export Options
          </div> -->
          
          			<div id="posts_display">
          			
          				<table id="DataTables_Table_0_wrapper" class="display"
						style="width: 100%">
						<thead>
							<tr>
								<th>Post title</th>
								<th>Cluster distance</th>


							</tr>
						</thead>
						<tbody>
							<%
								String currentTitle = null;
								String currentBlogger = null;
								String currentPost = null;
								String currentDate = null;
								String currentNumComment = null;

								postData = clusterResult.get(currentKey);
								/* System.out.println("This is key--" + key); */

								for (int j = 0; j < postData.length(); j++) {
									if (j == 0) {
										Object title = postData.getJSONObject(0).getJSONObject("_source").get("title");
										currentTitle = title.toString();

										Object blogger = postData.getJSONObject(0).getJSONObject("_source").get("blogger");
										currentBlogger = blogger.toString();

										Object comments = postData.getJSONObject(0).getJSONObject("_source").get("num_comments");
										currentNumComment = comments.toString();

										Object post = postData.getJSONObject(0).getJSONObject("_source").get("post");
										currentPost = post.toString();
									}

									Object title = postData.getJSONObject(j).getJSONObject("_source").get("title");
									Object blog_post_id = postData.getJSONObject(j).getJSONObject("_source").get("blogpost_id");

									//String distances = source.get("distances").toString();
									//ObjectMapper mapper = new ObjectMapper();

									//Map<String,String> map = mapper.readValue(distances, Map.class);

									/* JSONObject post_distances = new JSONObject(distances);  */
									/**/
									//System.out.println(post_distances.get(blog_post_id.toString()));
							%>
							<tr>

								<td><%=title.toString()%></td>
								<%-- <td><%=(double) Math.round(Double.parseDouble(distances.get(blog_post_id.toString()))) / 100000%></td> --%>
								<td><%=String.format("%.5f", (float)Float.parseFloat(distances.get(blog_post_id.toString()).toString()))%></td>

							</tr>
							<%
								}
							%>

							<!-- <tr>
								<td>URL</td>
								<td>Frequency</td>


							</tr>
							<tr>
								<td>URL</td>
								<td>Frequency</td>


							</tr>
							-->

						</tbody>
					</table>
          
         			</div>
					
					<div style="height: 250px; padding-right: 10px !important;" id="posts_display_loader" class="hidden">
						<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />
					</div>
					
					
					
					
					
				</div>

			</div>

			<div id="blogPostContainer"
				class="col-md-6 mt20 card card-style nobordertopleft noborderbottomleft">
				<div id="posts_details" style="" class="pt20">
					<h5 id="titleContainer" class="text-primary p20 pt0 pb0"><%=currentTitle%></h5>
					<div class="text-center mb20 mt20">
						<button class="btn stylebuttonblue">
							<b id="authorContainer" class="float-left ultra-bold-text"><%=currentBlogger%></b> <i
								class="far fa-user float-right blogcontenticon"></i>
						</button>
						<button id="dateContainer" class="btn stylebuttonnocolor">02-01-2018, 5:30pm</button>
						<button class="btn stylebuttonorange">
							<b id="numCommentsContainer" class="float-left ultra-bold-text"><%=currentNumComment%>
								comments</b><i class="far fa-comments float-right blogcontenticon"></i>
						</button>
					</div>
					<div style="height: 600px;">
						<div id="postContainer" class="p20 pt0 pb20 text-blog-content text-primary"
							style="height: 550px; overflow-y: scroll;"><%=currentPost%></div>
					</div>
				</div>
				
				<div style="height: 250px; padding-right: 10px !important;" id="posts_details_loader" class="hidden">
					<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />
				</div>
			</div>
		</div>


		<div class="row mb50 d-flex align-items-stretch">
			<div class="col-md-12 mt20 ">
				<div class="card card-style mt20">
					<div class="card-body p10 pt20 pb5">

						<div style="min-height: 420px;">
							<!-- <p class="text-primary">Top keywords of <b>Past Week</b></p> -->
							<div class="p15 pb5 pt0" role="group"></div>
							<table id="DataTables_Table_3_wrapper" class="display"
								style="width: 100%">
								<thead>
									<tr>
										<%
											JSONObject toptermsjson = new JSONObject();
											for (int k = 0; k < clusterResult.size(); k++) {
												//Object terms = result.getJSONArray(String.valueOf(i)).getJSONObject(0).getJSONObject("cluster_" + String.valueOf((i+1))).get("topterms");
												//toptermsjson.put(String.valueOf((i+1)),terms);
										%>
										<th>Cluster <%=k + 1%></th>

										<%
											}

											//System.out.println(toptermsjson);
										%>
									</tr>
								</thead>
								<tbody>
								<%for(int j = 0; j < topterms.size(); j++) {
									String terms = topterms.get("cluster_" + (j + 1));
									//System.out.println("terms ---" + terms);
									terms = terms.replace("[","").replace("]", "").replace("),", "-").replace("(", "").replace("\'", "");
									List<String> termlist = Arrays.asList(terms.split("-"));
									//System.out.println(ssssss);
									//System.out.println(Arrays.asList(ssssss.split("-")).get(0));
								%>
									
									<tr>
										
										<%
										for(int k = 0; k < 10; k++){
											//JSONArray test = (JSONArray)toptermsjson.get("1");
											//for(int i = 0; i < test.length(); i++) {
										%>
										<td>
											<%=termlist.get(k).split(",")[0]%>
										</td>

										<%} %>
									</tr>
									


								<% }%>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>

		</div>








	</div>


	<!-- <footer class="footer">
  <div class="container-fluid bg-primary mt60">
<p class="text-center text-medium pt10 pb10 mb0">Copyright &copy; Blogtrackers 2017 All Rights Reserved.</p>
</div>
  </footer> -->
	<!-- <script type="text/javascript" src="assets/vendors/d3/d3.v4.min.js"></script> -->
	<!-- <script type="text/javascript"
		src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.5/d3.min.js"></script> -->

	<script src="assets/js/jquery.min.js"></script>



	<script type="text/javascript" src="assets/js/jquery-1.11.3.min.js"></script>
	<script src="assets/bootstrap/js/bootstrap.js">
 </script>
	<script src="assets/js/generic.js">
 </script>
	<script src="assets/vendors/bootstrap-daterangepicker/moment.js"></script>
	<script
		src="assets/vendors/bootstrap-daterangepicker/daterangepicker.js"></script>
	<!-- Start for tables  -->
	<script type="text/javascript"
		src="assets/vendors/DataTables/datatables.min.js"></script>
	<script type="text/javascript"
		src="assets/vendors/DataTables/dataTables.bootstrap4.min.js"></script>
	<script
		src="assets/vendors/DataTables/Buttons-1.5.1/js/buttons.flash.min.js"></script>
	<script
		src="assets/vendors/DataTables/Buttons-1.5.1/js/dataTables.buttons.min.js"></script>
	<script src="assets/vendors/DataTables/pdfmake-0.1.32/pdfmake.min.js"></script>
	<script src="assets/vendors/DataTables/pdfmake-0.1.32/vfs_fonts.js"></script>
	<script
		src="assets/vendors/DataTables/Buttons-1.5.1/js/buttons.html5.min.js"></script>
	<script
		src="assets/vendors/DataTables/Buttons-1.5.1/js/buttons.print.min.js"></script>




	<script>
	
	
 $(document).ready(function() {
     $('#DataTables_Table_1_wrapper').DataTable( {
         "scrollY": 450,
         "scrollX": true,
          "pagingType": "simple",
           // dom: 'Bfrtip'
       //    ,
       // buttons:{
       //   buttons: [
       //       { extend: 'pdfHtml5',orientation: 'potrait', pageSize: 'LEGAL', className: 'btn-primary stylebutton1'},
       //       {extend:'csv',className: 'btn-primary stylebutton1'},
       //       {extend:'excel',className: 'btn-primary stylebutton1'},
       //      // {extend:'copy',className: 'btn-primary stylebutton1', text: 'Copy to Clipboard'},
       //       {extend:'print',className: 'btn-primary stylebutton1'},
       //   ]
       // }
     } );

     /* $('#DataTables_Table_0_wrapper').DataTable( {
         "scrollY": 460,
         "scrollX": true,
          "pagingType": "simple",
          // dom: 'Bfrtip'
       //    ,
       // buttons:{
       //   buttons: [
       //       { extend: 'pdfHtml5',orientation: 'potrait', pageSize: 'LEGAL', className: 'btn-primary stylebutton1'},
       //       {extend:'csv',className: 'btn-primary stylebutton1'},
       //       {extend:'excel',className: 'btn-primary stylebutton1'},
       //      // {extend:'copy',className: 'btn-primary stylebutton1', text: 'Copy to Clipboard'},
       //       {extend:'print',className: 'btn-primary stylebutton1'},
       //   ]
       // }
     } ); */
     
     $('#DataTables_Table_0_wrapper').DataTable( {
         "scrollY": 430,
         "scrollX": true,
         "order": [],
          "pagingType": "simple",
        	  "columnDefs": [
        	      { "width": "65%", "targets": 0 },
        	      { "width": "25%", "targets": 0 }
        	    ]
     } );
 } );
 </script>
	<!--end for table  -->
	<script>
 $(document).ready(function() {
   $(document)
   						.ready(
   								function() {
   	var cb = function(start, end, label) {
           //console.log(start.toISOString(), end.toISOString(), label);
           $('#reportrange span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
           $('#reportrange input').val(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY')).trigger('change');
         };

         var optionSet1 =
       	      {   startDate: moment().subtract(120, 'days'),
       	          endDate: moment(),
                  linkedCalendars: false,
       	          minDate: '01/01/1947',
       	          maxDate: moment(),
                  maxSpan: {
                    "days":1550
                  },
       			  showDropdowns: true,
              setDate:null,
       	          showWeekNumbers: true,
       	          timePicker : false,
   				  timePickerIncrement : 1,
   				  timePicker12Hour : true,
   				  dateLimit: { days: 50000 },
          	          ranges: {

          	        	'This Year' : [
   						moment()
   								.startOf('year'),
   						moment() ],
   				'Last Year' : [
   						moment()
   								.subtract(1,'year').startOf('year'),
   						moment().subtract(1,'year').endOf('year') ]
       	          },
       	          opens: 'left',
       	          applyClass: 'btn-small bg-slate-600 btn-block',
       	          cancelClass: 'btn-small btn-default btn-block',
       	          format: 'MM/DD/YYYY',
       			  locale: {
       	          applyLabel: 'Submit',
       	          //cancelLabel: 'Clear',
       	          fromLabel: 'From',
       	          toLabel: 'To',
       	          customRangeLabel: 'Custom',
       	          daysOfWeek: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'],
       	          monthNames: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
       	          firstDay: 1
       	        }

       	      };


   	// if('${datepicked}' == '')
   	// {
     //   $('#reportrange span').html(moment().subtract('days', 500).format('MMMM D') + ' - ' + moment().format('MMMM D'));
     //   $('#reportrange').daterangepicker(optionSet1, cb);
   	// }
     //
   	// else{
   		// $('#reportrange span').html('${datepicked}');
      $('#reportrange span').html(moment().subtract( 500, 'days').format('MMMM D, YYYY') + ' - ' + moment().format('MMMM D, YYYY'))
   		$('#reportrange, #custom').daterangepicker(optionSet1, cb);
   		$('#reportrange')
   		.on(
   				'show.daterangepicker',
   				function() {
   				/* 	console
   							.log("show event fired"); */
   				});
   $('#reportrange')
   		.on(
   				'hide.daterangepicker',
   				function() {
   					/* console
   							.log("hide event fired"); */
   				});
   $('#reportrange')
   		.on(
   				'apply.daterangepicker',
   				function(ev, picker) {
   					/* console
   							.log("apply event fired, start/end dates are "
   									+ picker.startDate
   											.format('MMMM D, YYYY')
   									+ " to "
   									+ picker.endDate
   											.format('MMMM D, YYYY')); */
   				});
   $('#reportrange')
   		.on(
   				'cancel.daterangepicker',
   				function(ev, picker) {
   					/* console
   							.log("cancel event fired"); */
   				});
   $('#options1').click(
   		function() {
   			$('#reportrange').data(
   					'daterangepicker')
   					.setOptions(
   							optionSet1,
   							cb);
   		});
   $('#options2').click(
   		function() {
   			$('#reportrange').data(
   					'daterangepicker')
   					.setOptions(
   							optionSet2,
   							cb);
   		});
   $('#destroy').click(
   		function() {
   			$('#reportrange').data(
   					'daterangepicker')
   					.remove();
   		});
   		//}
   								});
                 // set attribute for the form
       //$('#trackerform').attr("action","ExportJSON");
       //$('#dateform').attr("action","ExportJSON");


   //$('#config-demo').daterangepicker(options, function(start, end, label) { console.log('New date range selected: ' + start.format('YYYY-MM-DD') + ' to ' + end.format('YYYY-MM-DD') + ' (predefined range: ' + label + ')'); });
 });
 </script>
 <script type="text/javascript" src="assets/vendors/d3/d3.v4_new.min.js" ></script> 
 <script>
    var d3v4_ = window.d3;
    //console.log(d3v4_.version)
    //window.d3 = null;
</script>
<script>
	//var d3 = d3v4_;
	console.log("cluster",d3.version)
	
	
	$(document).ready(function() {
		
	$('#clusterdiagram').addClass('hidden');
	$('#clusterdiagram_loader').removeClass('hidden');
	
	loadscatter(1);
	
	$('#clusterdiagram').removeClass('hidden');
	$('#clusterdiagram_loader').addClass('hidden');
	
	
	///Onclick Handling
	$("body").delegate(".clusters_", "click", function() {
		
		$('#clusterdiagram').addClass('hidden');
		$('#clusterdiagram_loader').removeClass('hidden');
		
		$('#clusterdiagram').html('');
		$('#clusterdiagram').empty();
		
		 counter_value = $(this).attr("counter_value");
		//alert(counter_value)
		loadscatter(counter_value);
		
		//loadtitletable(counter_value+1);
		
		$('#clusterdiagram').removeClass('hidden');
		$('#clusterdiagram_loader').addClass('hidden');
		
	});
	
	//end onCliocik handling

})
	
	
	
	
	
	
	
	
	
	
	
	
	
	function loadscatter(clusterid){
		var margin = {
				top : 10,
				right : 30,
				bottom : 30,
				left : 60
			}, width = 1000 - margin.left - margin.right, height = 300 - margin.top
					- margin.bottom;

			//append the SVG object to the body of the page
			var SVG = d3v4_.select("#clusterdiagram").append("svg").attr("width",
					width + margin.left + margin.right).attr("height",
					height + margin.top + margin.bottom).append("g").attr(
					"transform",
					"translate(" + margin.left + "," + margin.top + ")");

			//Read the data
			d3v4_.csv("test_data2.csv", function(data) {
				console.log(data)
			})

			/* var data2 = []; */
			var data = [ 
				 {
					"cluster" : "0",
					"new_x" : "1",
					"new_y" : "3"

				
			}, {
				
					"cluster" : "1",
					"new_x" : "4",
					"new_y" : "5"
				
			}, {
				
					"cluster" : "2",
					"new_x" : "6",
					"new_y" : "7"
			

			} ];
			
			var data = <%=scatterplotfinaldata.toString()%>
			/* var data_final = data2.push(data);
			console.log(data_final) */
			// Add X axis
			var new_array = data.filter(function (el){
		
		return Math.max(el.new_y  && el.cluster==clusterid);
	}
	
	); 
	
	var max_x = Math.max.apply(Math, new_array.map(function(o) { return o.new_x; }));
	var max_y = Math.max.apply(Math, new_array.map(function(o) { return o.new_y; }));
	var min_x = Math.min.apply(Math, new_array.map(function(o) { return o.new_x; }));
	var min_y = Math.min.apply(Math, new_array.map(function(o) { return o.new_y; }));
			
			
			var x = d3v4_.scaleLinear().domain([min_x, max_x]).range([ 0, width ]);
			var xAxis = SVG.append("g").attr("transform",
					"translate(0," + height + ")").call(d3v4_.axisBottom(x));

			// Add Y axis
			var y = d3v4_.scaleLinear().domain([min_y, max_y]).range([ height, 0 ]);
			var yAxis = SVG.append("g").call(d3v4_.axisLeft(y));

			// Add a clipPath: everything out of this area won't be drawn.
			var clip = SVG.append("defs").append("SVG:clipPath").attr("id", "clip")
					.append("SVG:rect").attr("width", width).attr("height", height)
					.attr("x", 0).attr("y", 0);

			var color = d3v4_.scaleOrdinal().domain(["1", "2","3","4","5","6","7","8","9","10" ]).range(
					[ 'green', 'red', 'blue', 'orange', 'purple','pink', 'black', 'grey', 'brown','yellow'])
			/* .domain(["0", "1", "2","3","4","5","6","7","8","9" ]) */
			/* .range([ 'red', 'green', 'blue', 'orange', 'purple','pink', 'black', 'grey', 'brown','yellow']) */

			// Create the scatter variable: where both the circles and the brush take place
			var scatter = SVG.append('g').attr("clip-path", "url(#clip)")

			// Add circles
			scatter.selectAll("circle").data(data).enter().append("circle").attr(
					"cx", function(d) {
						return x(d.new_x);
					}).attr("cy", function(d) {
				return y(d.new_y);
			}).attr("r", 8).style("fill", function(d) {
				return color(d.cluster)
			}).style("opacity", 0.5)

			// Set the zoom and Pan features: how much you can zoom, on which part, and what to do when there is a zoom
			var zoom = d3v4_.zoom().scaleExtent([ -0.0005, 170 ]) // This control how much you can unzoom (x0.5) and zoom (x20)
			.extent([ [ 0, 0 ], [ width, height ] ]).on("zoom", updateChart);

			// This add an invisible rect on top of the chart area. This rect can recover pointer events: necessary to understand when the user zoom
			SVG.append("rect").attr("width", width).attr("height", height).style(
					"fill", "none").style("pointer-events", "all").attr(
					'transform',
					'translate(' + margin.left + ',' + margin.top + ')').call(zoom);
			// now the user can zoom and it will trigger the function called updateChart

			// A function that updates the chart when the user zoom and thus new boundaries are available
			function updateChart() {

				// recover the new scale
				var newX = d3v4_.event.transform.rescaleX(x);
				var newY = d3v4_.event.transform.rescaleY(y);

				// update axes with these new boundaries
				xAxis.call(d3v4_.axisBottom(newX))
				yAxis.call(d3v4_.axisLeft(newY))

				// update circle position
				scatter.selectAll("circle").attr('cx', function(d) {
					return newX(d.new_x)
				}).attr('cy', function(d) {
					return newY(d.new_y)
				});
			}
	
	}
</script>

<script type="text/javascript" src="assets/vendors/d3/d3.min.js" ></script>
 <script src="assets/vendors/wordcloud/d3.layout.cloud.js" ></script>
 <script type="text/javascript" src="assets/vendors/d3/d3_tooltip.js" ></script>
 <script type="text/javascript"
		src="chartdependencies/keywordtrendd3.js"></script>
 
<script>
    var d3v3_ = window.d3;
    //console.log(d3v3_.version)
    //window.d3 = null;
</script>

	<!--word cloud  -->
	<!-- <script type="text/javascript"></script>
	<script type="text/javascript" src="assets/vendors/d3/d3.min.js"></script>
	<script src="assets/vendors/wordcloud/d3.layout.cloud.js"></script>
	<script type="text/javascript" src="assets/vendors/d3/d3_tooltip.js"></script> -->
	<script >
	
	function doCloud(jsondata, elem){
		
		
			$(elem).html('');
	
			
			wordtagcloud(elem,450,jsondata); 
			
		}
	
	var terms = "<%=topterms.get("cluster_1")%>";
	var new_dd = terms.replace('[','{').replace(']','}').replace(/\),/g,'-').replace(/\(/g,'').replace(/,/g,':').replace(/-/g,',').replace(/\)/g,'').replace(/'/g,"");
	var newjson = new_dd.replace(/\s+/g,'').replace(/{/g,'{"').replace(/:/g,'":"').replace(/,/g,'","').replace(/}/g,'"}')
	var jsondata = JSON.parse(newjson)
	
	/* data = [];
	for (var key in jsondata) {var dic = {}; dic["text"] = key; dic["size"] = jsondata[key]; data.push(dic);} */
	console.log('weeweweweewewewewewewew')
	console.log(jsondata)
	elem = '#tagcloudcontainer';
	
	
	
	
	doCloud(jsondata,elem)

	 /* d3version3 = d3
	   // window.d3 = null
	    // test it worked
	    console.log('v3', d3version3.version)
	    d3 = d3version3 */
 <%-- var color = d3.scale.linear()
         .domain([0,3,5,7,8,9,6,10,15,20,50])
         .range(["#17394C", "#F5CC0E", "#CE0202", "#1F90D0", "#999", "#888", "#777", "#666", "#555", "#444", "#333", "#222"]);

 $(function () {

   wordtagcloud("#tagcloudcontainer",410);
    function wordtagcloud(element, height) {
    	var d3 = d3v3_;
    	
//console.log(d3.version)
      // Define main variables of the container
      var d3Container = d3.select(element),
          margin = {top: 30, right: 10, bottom: 20, left: 25},
          width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right,
          height = height;

    var container = d3Container.append("svg");

    var color = d3.scale.linear()
           .domain([0,1,2,3,4,5,6,10,12,15,20])
           .range(["#0080CC", "#FFBB78", "#CE0202", "#0080CC", "#72C28E", "#D6A78D", "#FF7E7E", "#666", "#555", "#444"]);
	var terms = "<%=topterms.get("cluster_1")%>";
	var new_dd = terms.replace('[','{').replace(']','}').replace(/\),/g,'-').replace(/\(/g,'').replace(/,/g,':').replace(/-/g,',').replace(/\)/g,'')
	var newjson = new_dd.replace(/\s+/g,'').replace(/{/g,'{"').replace(/:/g,'":"').replace(/,/g,'","').replace(/}/g,'"}')
	var jsondata = JSON.parse(newjson)
	data = [];
	for (var key in jsondata) {var dic = {}; dic["text"] = key; dic["size"] = jsondata[key]; data.push(dic);}
	var frequency_list=data;
	console.log('frequency_list', frequency_list);
     var frequency_list2 = [{"text":"study","size":40},{"text":"motion","size":15},{"text":"forces","size":10},{"text":"electricity","size":15},{"text":"movement","size":10},{"text":"relation","size":5},{"text":"things","size":10},{"text":"force","size":5},{"text":"ad","size":5},{"text":"energy","size":85},{"text":"living","size":5},{"text":"nonliving","size":5},{"text":"laws","size":15},{"text":"speed","size":45},{"text":"velocity","size":30},{"text":"define","size":5},{"text":"constraints","size":5},{"text":"universe","size":10},{"text":"distinguished","size":5},{"text":"chemistry","size":5},{"text":"biology","size":5},{"text":"includes","size":5},{"text":"radiation","size":5},{"text":"sound","size":5},{"text":"structure","size":5},{"text":"atoms","size":5},{"text":"including","size":10},{"text":"atomic","size":10},{"text":"nuclear","size":10},{"text":"cryogenics","size":10},{"text":"solid-state","size":10},{"text":"particle","size":10},{"text":"plasma","size":10},{"text":"deals","size":5},{"text":"merriam-webster","size":5},{"text":"dictionary","size":10},{"text":"analysis","size":5},{"text":"conducted","size":5},{"text":"order","size":5},{"text":"understand","size":5},{"text":"behaves","size":5},{"text":"en","size":5},{"text":"wikipedia","size":5},{"text":"wiki","size":5},{"text":"physics-","size":5},{"text":"physical","size":5},{"text":"behaviour","size":5},{"text":"collinsdictionary","size":5},{"text":"english","size":5},{"text":"time","size":35},{"text":"distance","size":35},{"text":"wheels","size":5},{"text":"revelations","size":5},{"text":"minute","size":5},{"text":"acceleration","size":20},{"text":"torque","size":5},{"text":"wheel","size":5},{"text":"rotations","size":5},{"text":"resistance","size":5},{"text":"momentum","size":5},{"text":"measure","size":10},{"text":"direction","size":10},{"text":"car","size":5},{"text":"add","size":5},{"text":"traveled","size":5},{"text":"weight","size":5},{"text":"electrical","size":5},{"text":"power","size":5}];
     console.log('frequency_list2', frequency_list2)
     var svg =  container;
     console.log("wordcloud",d3.version)
     
     d3v3_.layout.cloud().size([width, height])
             .words(frequency_list)
             .rotate(0)
             .fontSize(function(d) { return d.size; })
             .on("end", draw)
             .start();



     function draw(words) {


       //console.log(height)

         // d3.select(".tagcloudcontainer").append("svg")
         container
                 .attr("width", width)
                 .attr("height", height)
                 .attr("class", "wordcloud")
                 .append("g")
                 // without the transform, words words would get cutoff to the left and top, they would
                 // appear outside of the SVG area
                 .attr("transform", "translate(165,180)")
                 .call(d3.behavior.zoom().on("zoom", function () {
                	var g = svg.selectAll("g");
                	g.attr("transform", "translate(165,180)" + " scale(" + d3.event.scale + ")")
                 }))
                 .selectAll("text")
                 .data(words)
                 .enter().append("text")
                 .style("font-size", function(d) { return d.size + "px"; })
                 .style("fill", function(d, i) { return color(i); })
                 .call(d3.behavior.drag()
         		.origin(function(d) { return d; })
         		.on("dragstart", dragstarted)
         		.on("drag", dragged)
         		)
                 .attr("transform", function(d) {
                     return "translate(" + [d.x + 2, d.y + 3] + ")rotate(" + d.rotate + ")";
                 })

                 .text(function(d) { return d.text; });

                 function dragged(d) {
                	 var movetext = svg.select("g").selectAll("text");
                	 movetext.attr("dx",d3.event.x)
                	 .attr("dy",d3.event.y);
                	 /* g.attr("transform","translateX("+d3.event.x+")")
                	 .attr("transform","translateY("+d3.event.y+")")
                	 .attr("width", width)
                     .attr("height", height); */
                	}
                	function dragstarted(d){
        				d3.event.sourceEvent.stopPropagation();
        			}
     }

}

}); --%>

 </script>
 <!-- <script type="text/javascript"></script>
	<script type="text/javascript" src="assets/vendors/d3/d3.min.js"></script>
	<script src="assets/vendors/wordcloud/d3.layout.cloud.js"></script>
	<script type="text/javascript" src="assets/vendors/d3/d3_tooltip.js"></script> -->
	<script src="pagedependencies/clustering.js"></script>
	<script >
	 /* d3version3 = d3
	   // window.d3 = null
	    // test it worked
	    console.log('v3', d3version3.version)
	    d3 = d3version3 */
	    var rotation = 0;
	 	var names = ["Cluster 1", "Cluster 2", "Cluster 3", "Cluster 4", "Cluster 5", "Cluster 6", "Cluster 7", "Cluster 8", "Cluster 9", "Cluster 10"];
	 	var colors = ["green", "red", "blue", "orange", "purple", "pink", "black", "grey", "brown", "yellow"];
	    var chord_options = {
    		    "gnames": names,
    		    "rotation": rotation,
    		    "colors": colors
    		};
	    clusterMatrix = [
	    	[0 , 3, 4, 0, 2 , 4 ,5 , 6, 0, 7],
	    	[0 , 0, 4, 0, 2 , 4 ,5 , 6, 0, 0],
	    	[1 , 3, 0, 0, 2 , 4 ,5 , 6, 0, 6],
	    	[0 , 3, 4, 0, 2 , 4 ,0 , 6, 0, 0],
	    	[0 , 3, 4, 7, 0 , 4 ,5 , 6, 0, 9],
	    	[0 , 3, 4, 0, 2 , 0 ,5 , 0, 0, 7],
	    	[0 , 0, 4, 0, 2 , 4 ,0 , 6, 0, 8],
	    	[0 , 3, 4, 8, 2 , 4 ,5 , 0, 0, 4],
	    	[0 , 3, 4, 3, 2 , 4 ,5 , 6, 0, 7],
	    	[0 , 5, 4, 0, 2 , 4 ,5 , 6, 0, 0]
	    ]
	    
	    drawChord("#chorddiagram", chord_options, clusterMatrix, names); 
 
 </script>


	<!-- <script
		src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.17/d3.min.js"></script> -->
	<script>
    /* d3version3 = d3
    window.d3 = null
    // test it worked
    console.log('v3', d3version3.version) */
    
  </script>
	<!-- <script src="https://d3js.org/d3.v4.js"></script> -->
	
	<!-- <script
		src="https://cdnjs.cloudflare.com/ajax/libs/d3/4.10.0/d3.min.js"></script> -->
		
	<script>
    /* d3version4 = d3
   // window.d3 = null
    
    console.log('v4', d3version4.version) */
  </script>
	<!-- <script async src="pagedependencies/clustering.js"></script> -->
	

<%
Instant end = Instant.now();
Duration timeElapsed = Duration.between(start, end);
System.out.println("Time taken: " + timeElapsed.getSeconds() + " seconds");
%>
</body>
</html>
