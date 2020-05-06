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
	String trackername = "";
	//System.out.println(userinfo);
	if (userinfo.size() < 1) {
		//response.sendRedirect("login.jsp");
	} else {
		userinfo = (ArrayList<?>) userinfo.get(0);
		ArrayList detail = new ArrayList();
		Object user = (null == session.getAttribute("username")) ? "" : session.getAttribute("username");
		Trackers tracker = new Trackers();
		try {
			
			if (tid != "") {
				detail = tracker._fetch(tid.toString());
				//System.out.println(detail);
			} else {
				detail = tracker._list("DESC", "", user.toString(), "1");
				//System.out.println("List:"+detail);
			}
			
			if (detail.size() > 0) {
				//String res = detail.get(0).toString();
				ArrayList resp = (ArrayList<?>) detail.get(0);

				String tracker_userid = resp.get(1).toString();

				trackername = resp.get(2).toString();

				
			}
			
			
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
	System.out.println("done with clusters");

	JSONObject res = new JSONObject(result.get(0).toString());
	System.out.println("done with res");
	
	JSONObject source = new JSONObject(res.get("_source").toString());
	System.out.println("done with source");
	//			ArrayList R2 = (ArrayList)result.get(0);
	//for()
	//			System.out.println(source.get("cluster_3"));
	HashMap<Pair<String, String>, ArrayList<JSONObject>> clusterResult = new HashMap<Pair<String, String>, ArrayList<JSONObject>>();
	//JSONObject key_val = new JSONObject();
	Pair<String, String> key_val = new Pair<String, String>(null, null);

	HashMap<String, String> key_val_posts = new HashMap<String, String>();
	ArrayList<JSONObject> scatterplotfinaldata = new ArrayList<JSONObject>();
	
	JSONObject distances = new JSONObject();
	HashMap<String, String> topterms = new HashMap<String, String>();
	
	String find = "";
	int [][] termsMatrix = new int[10][10];
	//int count = 0;
	JSONArray links_centroids = new JSONArray();
	JSONArray nodes_centroids = new JSONArray();
	//start main foor loop
	for (int i = 1; i < 11; i++) {

		String cluster_ = "cluster_" + String.valueOf(i);
		String centroids = "C" + String.valueOf(i) + "xy";
		JSONObject cluster_data = new JSONObject(source.get(cluster_).toString());
		//Map s = new LinkedHashMap();
		//System.out.println(source.get(cluster_).toString());
		//System.out.println(cluster_data);
		String post_ids = cluster_data.get("post_ids").toString();
		System.out.println("done with postsids --");
		///break;
		
		String centroid = source.get(centroids).toString().replace("[", "").replace("]", "");
		String centroid_x = centroid.split(",")[0].trim();
		String centroid_y = centroid.split(",")[1].trim();
		System.out.println("done with centroid --");
		//System.out.println(centroid);
		
		//ArrayList svd = cluster._getSvd(post_ids);
		
		JSONObject data_centroids_ = new JSONObject();
		
		data_centroids_.put("id","Cluster_" + i);
	   	data_centroids_.put("group", i);
	   	data_centroids_.put("label","CLUSTER_" + i);
	   	data_centroids_.put("level",post_ids.split(",").length);
	
	   	nodes_centroids.put(data_centroids_);
		
		for(int k = 1; k < 11; k++){
			if(k != i){
				String centroids_ = "C" + String.valueOf(k) + "xy";
				String centroid_ = source.get(centroids_).toString().replace("[", "").replace("]", "");
				String centroid_x_ = centroid_.split(",")[0].trim();
				String centroid_y_ = centroid_.split(",")[1].trim();
				
				JSONObject data_centroids = new JSONObject();
				data_centroids.put("target","Cluster_" + i);
				data_centroids.put("source","Cluster_" + k);
				
				double left_ = Math.pow((double)Double.parseDouble(centroid_x_) - (double)Double.parseDouble(centroid_x), 2);
				double right_ = Math.pow((double)Double.parseDouble(centroid_y_) - (double)Double.parseDouble(centroid_y), 2);
				String distance_ = String.valueOf(Math.pow((left_ + right_), 0.5));
				 
				data_centroids.put("strength", 50 - Double.parseDouble(distance_));
				links_centroids.put(data_centroids);
				
			}
			
		}
		
		JSONObject svd_ = new JSONObject(source.get("svd").toString());
		//System.out.println("svd---"+svd_);
		int counter = 0;
		String [] post_split = post_ids.split(",");
		
		for(int j = 0; j < post_split.length; j++){
			
			
			
			JSONObject scatter_plot = new JSONObject();
			String p_id = post_split[j];
			Object x_y = svd_.get(p_id);
					
			x_y = x_y.toString().replace("[","").replace("]","").trim().replaceAll("\\s+", " ");
			
			String x = x_y.toString().split(" ")[0];
			String y = x_y.toString().split(" ")[1];
			
			String postid = p_id.toString();
			
			scatter_plot.put("cluster",String.valueOf(i));
			
			scatter_plot.put("",String.valueOf(counter));
			scatter_plot.put("new_x",x);
			scatter_plot.put("new_y",y);
			counter++;
			
			double left = Math.pow((double)Double.parseDouble(x) - (double)Double.parseDouble(centroid_x), 2);
			double right = Math.pow((double)Double.parseDouble(y) - (double)Double.parseDouble(centroid_y), 2);
			String distance = String.valueOf(Math.pow((left + right), 0.5));
			distances.put(postid, distance); 
			scatterplotfinaldata.add(scatter_plot);
			
		}
		
		ArrayList<JSONObject> postDataAll = DbConnection.queryJSON("select date,post,num_comments, blogger,permalink, title, blogpost_id, location, blogsite_id from blogposts where blogpost_id in ("+post_ids+") limit 500" );
		System.out.println("done with query --");
		
		String terms = cluster_data.get("topterms").toString();
		String str1 = null;
		str1 = terms.replace("),", "-").replace("(", "").replace(")", "").replaceAll("[0-9]","").replace("-", "");
		List<String> t1 = Arrays.asList(str1.replace("[","").replace("]","").split(","));
		termsMatrix[i - 1][i - 1] = t1.size();
		
		//CREATING CHORD MATRIX
		
		String str2 = null;
		
		for(int k = (i + 1); k < 11; k++)
		{
		String cluster_matrix  = "cluster_" + String.valueOf(k);
		JSONObject cluster_data_matrix = new JSONObject(source.get(cluster_matrix).toString());
		String terms_matrix = cluster_data_matrix.get("topterms").toString();
		
		str2 = terms_matrix.replace("),", "-").replace("(", "").replace(")", "").replaceAll("[0-9]","").replace("-", "");
	
		List<String> t2 = Arrays.asList(str2.replace("[","").replace("]","").split(","));
	
		int count = 0;
		for (int i_ = 0; i_ < t1.size(); i_++)
        {
            for (int j_ = 0; j_ < t2.size(); j_++)
            {
                if(t1.get(i_).contentEquals(t2.get(j_)))
                {
                 
                 count ++;
                 }
            }
        }
		
		termsMatrix[i-1][k-1] = count;
		termsMatrix[k-1][i-1] = count;
		 }
		//DONE CREATING CHORD MATRIX
		
		topterms.put(cluster_,terms);
		
		key_val = new Pair<String, String>(cluster_, post_ids);
		
		key_val_posts.put(cluster_, post_ids);
		
		clusterResult.put(key_val, postDataAll);
		
		

	}
//end main for loop

	
	JSONObject final_centroids = new JSONObject();
	final_centroids.put("nodes",nodes_centroids);
	final_centroids.put("links",links_centroids);

	
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

<style>
.karat{
	 bottom: 0 !important;
 height: 100% !important;
}
.overlay1 {
 position: absolute;
 bottom: 100%;
 left: 0;
 right: 0;
 background-color: #008CBA;
 overflow: hidden;
 width: 100%;
 height:0;
 transition: .5s ease;
}
.text1 {
 color: white;
 font-size: 20px;
 position: absolute;
 top: 50%;
 left: 50%;
 -webkit-transform: translate(-50%, -50%);
 -ms-transform: translate(-50%, -50%);
 transform: translate(-50%, -50%);
 text-align: center;
}
</style>

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
					<a class="breadcrumb-item text-primary"
						href="<%=request.getContextPath()%>/trackerlist.jsp">Trackers</a>
					<a class="breadcrumb-item text-primary"
						href="<%=request.getContextPath()%>/edittracker.jsp?tid=<%=tid%>"><%=trackername%></a>
					<a class="breadcrumb-item  text-primary"
						href="<%=request.getContextPath()%>/dashboard.jsp?tid=<%=tid%>">Dashboard</a>
					<a class="breadcrumb-item active text-primary"
						href="#">Clustering Analysis
						</a>
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

				<div class="card card-style mt25" style="height: 700px; margin-top: 20px">
					<div class="card-body  p30 pt5 pb5 mb40">
						<h5 class="mt20 mb20">Clusters</h5>
						<!-- <div style="padding-right: 10px !important;">
							<input type="search" class="form-control stylesearch mb20"
								placeholder="Search " />
						</div> -->
						<div class="scrolly"
							style="height: 600px; padding-right: 10px !important;">
							<%
								String bloggersMentioned = null;
								String currentPostIdsCount = null;
								String topPostingLocation = null;
								String currentPostIds = null;
								String blogDistribution = null;
								String total = source.get("total").toString();
								session.setAttribute(tid.toString() + "clusters_total", total);
								String blogdistribution = null;
								//JSONArray postData = new JSONArray();
								ArrayList postData;

								String[] colors = {"green", "red", "blue", "orange", "purple", "pink", "black", "grey", "brown", "yellow"};
								int i = 0;
								Pair<String, String> currentKey = new Pair<String, String>(null, null);

								for (Map.Entry<Pair<String, String>, ArrayList<JSONObject>> entry : clusterResult.entrySet()) {
									Pair<String, String> key = entry.getKey();
									
									//String temp_terms = topterms.get("cluster_" + (i + 1));
									//System.out.println("terms ---" + terms);
									String word_build = "";
									
									//System.out.println("terms ---" + terms);
									String [] splitted = source.get("cluster_" + (i + 1)).toString().split("\'topterms\':");
											//System.out.println("terms ---" + terms);
											//terms = terms.replace("{","").replace("}","").replace("[","").replace("]", "").replace("),", "-").replace("(", "").replace("\'", "").replace("\"", "");
											//String [] splitted2 = splitted[1].replace("{","").replace("}","").split(",");
											//List<String> termlist = Arrays.asList(terms.split(","));
									List<String> termlist = Arrays.asList(splitted[1].replace("{","").replace("}","").split(","));
									//max = Integer.parseInt(termlist.get(k).split(":")[1].trim());
									//temp_terms = temp_terms.replace("{","").replace("}", "").replace("[","").replace("]", "").replace("),", "-").replace("(", "").replace("\'", "").replace("\"", "");;
									//List<String> termlist = Arrays.asList(temp_terms.split(","));
									
									for(int m = 0; m < 10; m++){
										if(m > 0){
											word_build += ", ";
										}
										word_build += termlist.get(m).split(":")[0].replace("\'","");
										//System.out.println("original--" + termlist.get(m));
										//System.out.println("building--" + termlist.get(m).split(":")[0]);
									
									}
									//System.out.println("original--" + word_build);

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
							<a cluster_number="<%=i + 1%>" loaded_color="<%=colors[i]%>"  cluster_id="CLUSTER_<%=i + 1%>"  data-toggle="tooltip" data-placement="top" title="<%=word_build%>" class="clusters_ btn  form-control stylebuttonactive mb20 cluster_visual"
								id="cluster_<%=i + 1%>" counter_value="<%=i  +1%>"
								style="background-color: <%=colors[i]%>;"> <b>Cluster <%=i + 1%></b>
							</a>
							<%
								} else {
							%>
							<a cluster_number="<%=i + 1%>" loaded_color="<%=colors[i]%>" cluster_id="CLUSTER_<%=i + 1%>" data-toggle="tooltip" data-placement="top" title="<%=word_build%>"
								class="clusters_ btn form-control stylebuttoninactive text-primary mb20 cluster_visual"
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
				<div class="card card-style mt20" style="height: 570px;">
					<div class="card-body  p30 pt5 pb5">
						<div style="min-height: 250px;">
							<div>
								<p class="text-primary mt10">Cluster Map</p>
							</div>

							<div id="chart-container1" class="chart-container" style="min-height: 500px;">
								<div class="chart" id="clusterdiagram"></div>
								<div id="parentdivy"></div>
								
								<% for(int c=1; c<=10; c++){ %>
									
									<div id="CLUSTER_<%=c %>" class="overlay1 ">
									  <div style="min-height: 400px; width: 1000px;" class="text1 card card-style ">
											<div class="clusterdiagram_<%=c %>" class="card-body p30 pt5 pb5 container1">
												<div class="hidden" id="clusterdiagram_<%=c %>" load_status="0" ></div>
												
												<div id="clusterdiagram_loader_<%=c %>" class="">
													<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />
												</div>
											</div>
										</div>
									 </div>
									 
								 <% } %>
								
								
								
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
								Keywords of <b class="text-blue activeblog">Cluster 1</b> 
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
								<b class="text-blue activeblog">Cluster 1</b><b
									class="text-success"> Common Terms</b>
							</p>
						</div>
						<div class="chart-container">
							<div class="chart svg-center " id="chorddiagram"></div>

							<div id="chorddiagram_loader" class="">
								<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />
							</div>
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
          
          <div id="posts_display2 hidden">
          			
          				<table id="DataTables_Table_20_wrapper" class="display posts_display2 hidden"
						style="width: 100%">
						<thead>
							<tr>
								<th>Post title</th>
								<th>Cluster distance</th>


							</tr>
						</thead>
						<tbody id="cluster_post_body2">
						
						</tbody>
					</table>
          
         			</div>
          
          			<div id="posts_display">
          			
          				<table id="DataTables_Table_0_wrapper" class="display"
						style="width: 100%">
						<thead>
							<tr>
								<th>Post title</th>
								<th>Cluster distance</th>


							</tr>
						</thead>
						<tbody id="">
							<%
								String currentTitle = null;
								String currentBlogger = null;
								String currentPost = null;
								String currentDate = null;
								String currentNumComment = null;
								String activeDef = "";
								String activeDefLink = "";
								
								float max_distance_id = 0;
								String max_post_id = "";

								postData = clusterResult.get(currentKey);
								
								/* System.out.println("This is key--" + key); */


								for (int j = 0; j < postData.size(); j++) {
									JSONObject p = new JSONObject(postData.get(j).toString());
									Object blog_post_id = p.getJSONObject("_source").get("blogpost_id");
									Object title = p.getJSONObject("_source").get("title");
									Object permalink = p.getJSONObject("_source").get("permalink");
								
									
									
									if (j == 0) {
										max_distance_id = (float)Float.parseFloat(distances.get(blog_post_id.toString()).toString());
									}else{
										activeDefLink = "makeinvisible";
										activeDef = "";
									}
									
									if(max_distance_id > (float)Float.parseFloat(distances.get(blog_post_id.toString()).toString())){
										
										max_distance_id = (float)Float.parseFloat(distances.get(blog_post_id.toString()).toString());
										max_post_id = blog_post_id.toString();
										
										currentTitle = title.toString();

										Object blogger = p.getJSONObject("_source").get("blogger");
										currentBlogger = blogger.toString();

										try {
											Object comments = p.getJSONObject("_source").get("num_comments");
											currentNumComment = comments.toString();
										}catch(Exception e){
											currentNumComment = "0";
											
										}
										

										Object post = p.getJSONObject("_source").get("post");
										currentPost = post.toString();
										activeDef = "activeselectedblog";
										activeDefLink = "";
									}


									
									 //}
									
									
									


									//String distances = source.get("distances").toString();
									//ObjectMapper mapper = new ObjectMapper();

									//Map<String,String> map = mapper.readValue(distances, Map.class);

									/* JSONObject post_distances = new JSONObject(distances);  */
									/**/
									//System.out.println(post_distances.get(blog_post_id.toString()));
							%>
							<tr>
							
								<td><a class="blogpost_link cursor-pointer <%=activeDef %>" id="<%=blog_post_id.toString()%>" ><%=title.toString()%></a><br/>
								<a id="viewpost_<%=blog_post_id.toString()%>" class="mt20 viewpost <%=activeDefLink %>" href="<%=permalink.toString()%>" target="_blank"><buttton class="btn btn-primary btn-sm mt10 visitpost">Visit Post &nbsp;<i class="fas fa-external-link-alt"></i></buttton></a></td>
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
					<button class="btn stylebuttonblue" onclick="window.location.href = '<%=request.getContextPath()%>/bloggerportfolio.jsp?tid=<%=tid%>&blogger=<%=currentBlogger%>'">
						<%-- <button class="btn stylebuttonblue">
							<b id="authorContainer" class="float-left ultra-bold-text"><%=currentBlogger%></b> <i
								class="far fa-user float-right blogcontenticon"></i>--%>
						<b class="float-left ultra-bold-text"><%=currentBlogger%></b> <i
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
							<table id="DataTables_Table_3_wrapper" class="display table_over_cover"
								style="width: 100%">
								<thead>
									<tr>
										<%
											JSONObject toptermsjson = new JSONObject();
											ArrayList <List<String>> all_terms = new ArrayList<List<String>>();
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
								
								<% 
								
								
								for(int k = 0; k < topterms.size(); k++){ %>
								
									<tr>
										
										<% 
										int max = 0;
										for(int m = 0; m < 10; m++){
											
											//String terms = topterms.get("cluster_" + (m + 1));
											String [] splitted = source.get("cluster_" + (m + 1)).toString().split("\'topterms\':");
											//System.out.println("terms ---" + terms);
											//terms = terms.replace("{","").replace("}","").replace("[","").replace("]", "").replace("),", "-").replace("(", "").replace("\'", "").replace("\"", "");
											//String [] splitted2 = splitted[1].replace("{","").replace("}","").split(",");
											//List<String> termlist = Arrays.asList(terms.split(","));
											List<String> termlist = Arrays.asList(splitted[1].replace("{","").replace("}","").split(","));
											max = Integer.parseInt(termlist.get(k).split(":")[1].trim());
											
										%>
										
										<td>
											<%=termlist.get(k).split(":")[0].replace("\'","")%>
										</td>

										<%} %>
									</tr>
									
								<%} %>
								
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


 <script src="pagedependencies/baseurl.js?v=93"></script>
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
         "order": [[ 1, "asc" ]],
          "pagingType": "simple",
        	  "columnDefs": [
        	      { "width": "65%", "targets": 0 },
        	      { "width": "25%", "targets": 0 }
        	    ]
     } );
     
     $('#DataTables_Table_3_wrapper').DataTable( {
         "scrollY": 430,
         "scrollX": true,
         "targets": 'no-sort',
         "bSort": false
        	 
     } );
     
    
     
     ///getting post with highest distance
     id = <%=max_post_id %>
					
	$(".viewpost").addClass("makeinvisible");
   	$('.blogpost_link').removeClass("activeselectedblog");
   	$('#'+id).addClass("activeselectedblog");
   	$("#viewpost_"+id).removeClass("makeinvisible");

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
	////start cluster graph clicks
		$("body").delegate(".cluster_visual", "click", function() {
			$('.overlay1').removeClass('karat');
			loaded_color = $(this).attr('loaded_color');
			cluster_id = $(this).attr('cluster_id');
			cluster_number = $(this).attr('cluster_number');
			
			if( $('#clusterdiagram_'+cluster_number).attr('load_status') == 0  ){
				getClusterPoints(cluster_number)
			}
			
			$('#'+cluster_id).css("backgroundColor", loaded_color);
			$('#'+cluster_id).addClass('karat');
			
		})
		$("body").delegate(".overlay1", "click", function() {
			$(this).removeClass('karat');
		})
		////end cluster graph clicks
		
		
		
		////start get clusterPoint function
		function getClusterPoints(cluster_id){
		
			 id = <%=tid %>
			 cluster_number = cluster_id
			 $.ajax({
					url: app_url+"subpages/cluster_posts_chart.jsp",
					method: 'POST',
					/* dataType: 'json', */
					data: {
						action:"fetch_graph",
						tid:id,
						cluster_number:cluster_number
					},
					error: function(response)
					{		console.log("error")				
						console.log(response);
						//$("#blogpost_detail").html(response);
					},
					success: function(response)
					{   
						//console.log("succcccccc")
						//console.log(cluster_number);
						//console.log(response);
						var data = JSON.parse(response);
						//$(".char19").html(data.status_percentage);
						//$(".status").html(data.status);
						///console.log(data.cluster_id)
						//console.log(data.final_data)
						clusterdiagram3('#clusterdiagram_'+data.cluster_id, 500,data.final_data, data.cluster_id);
						//$(".clusterdiagram_"+).html(response).hide();
						//$("#posts_details").fadeIn(700);
					}
				});
		
		}
		///end get ClusterPoint function
		
		
		
		
		//nodes = []
 var d3v4 = window.d3;
 var plot_width = $('#chart-container1').width();
var plot_height = $('#chart-container1').outerHeight() - 25;
//console.log("plot_height",plot_height)
 //console.log("plot_width",plot_width)
 // Chart setup
clusterdiagram5('#parentdivy', plot_height, plot_width);
 var max_post_count = 0;
 var min_post_count = 0
 function clusterdiagram3(element, height, dataset, identify) {
		// console.log("this is dataset1",dataset)
		 
		 	 //console.log("this is dataset2",dataset)
		 	 
		 	//console.log("normalized_value",normalized_radius )
		 	//start get normalized array for radius values
	  /* var nodes = [
	   { id: "mammal", group: 0, label: "Mammals", level: 2 },
	   { id: "dog"  , group: 0, label: "Dogs"  , level: 2 },
	   { id: "cat"  , group: 0, label: "Cats"  , level: 2 },
	   { id: "fox"  , group: 0, label: "Foxes" , level: 2 },
	   { id: "elk"  , group: 0, label: "Elk"  , level: 2 },
	   { id: "insect", group: 1, label: "Insects", level: 2 },
	   { id: "ant"  , group: 1, label: "Ants"  , level: 2 },
	   { id: "bee"  , group: 1, label: "Bees"  , level: 2 },
	   { id: "fish" , group: 2, label: "Fish"  , level: 2 },
	   { id: "carp" , group: 2, label: "Carp"  , level: 2 },
	   { id: "pike" , group: 2, label: "Pikes" , level: 2 }
	  ] */
		 
	var nodes = dataset.nodes
	//console.log('nodes', nodes)
	//console.log('nodes',nodes)
	  /* var links = [
	  	{ target: "mammal", source: "dog" , strength: 3.0 },
	  	{ target: "bee", source: "cat" , strength: 3.0 }
	   /* { target: "mammal", source: "fox" , strength: 3.0 },
	   { target: "insect", source: "ant" , strength: 0.7 },
	   { target: "insect", source: "bee" , strength: 0.7 },
	   { target: "fish" , source: "carp", strength: 0.7 },
	   { target: "fish" , source: "pike", strength: 0.7 },
	   { target: "cat"  , source: "elk" , strength: 0.1 },
	   { target: "carp" , source: "ant" , strength: 0.1 },
	   { target: "elk"  , source: "bee" , strength: 0.1 },
	   { target: "dog"  , source: "cat" , strength: 0.1 },
	   { target: "fox"  , source: "ant" , strength: 0.1 },
	  	{ target: "pike" , source: "cat" , strength: 0.1 } */
	  /* ] */
	  var links = dataset.links
	//console.log('links', links)
		  //console.log('links',links)
		  //var width = $('#clusterdiagram').width();
		//var height = $('#clusterdiagram').height();
	   // Define main variables
	   var d3Container = d3v4.select(element),
	     margin = {top: 0, right: 50, bottom: 0, left: 50},
	     width = 960,
	     height = 550;
				radius = 6;
		
	   var colors = d3v4.scaleOrdinal(d3v4.schemeCategory10);
	   // Add SVG element
	   var container = d3Container.append("svg");
	   // Add SVG group
	   var svg = container
	     .attr("width", width + margin.left + margin.right)
	     .attr("height", height + margin.top + margin.bottom)
	   .attr("overflow", "visible");
	     //.append("g")
	    //  .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
	    // simulation setup with all forces
	  var linkForce = d3v4
	  .forceLink()
	  .id(function (link) { return link.id })
	  .strength(function (link) { return link.strength })
	    // simulation setup with all forces
	     var simulation = d3v4
	     .forceSimulation()
	     .force('link', d3v4.forceLink().id(d =>d.id).distance(-20))
	     .force('charge', d3v4.forceManyBody())
	     /* .force('center', d3v4.forceCenter(width, height ))  */
	     .force('center', d3v4.forceCenter())  
	     .force("collide",d3v4.forceCollide().strength(-5)) 
	     /* simulation.force("center")
	    .x(width * forceProperties.center.x)
	    .y(height * forceProperties.center.y); */
	     /* var simulation = d3.forceSimulation()
	       .force('x', d3.forceX().x(d => d.x))
	       .force('y', d3.forceY().y(d => d.y))
	       .force("charge",d3.forceManyBody().strength(-20))
	       .force("link", d3.forceLink().id(d =>d.id).distance(20)) 
	       .force("collide",d3.forceCollide().radius(d => d.r*10)) 
	       .force('center', d3v4.forceCenter(width, height )) */
				
				simulation.force("center")
			  .x(width / 2)
			  .y(height / 2)
			   
			  	simulation.force("charge")
	    .strength(-2000 * true)
	    .distanceMin(1)
	    .distanceMax(100);
			  /* .x(width * 0.5) */
				
				simulation.alpha(1).restart(); 
	     var linkElements = svg.append("g")
	      .attr("class", "links")
	      .selectAll("line")
	      .data(links)
	      .enter().append("line")
	       .attr("stroke-width", 0)
	     	 .attr("stroke", "rgba(50, 50, 50, 0.2)")
	    function getNodeColor(node) {
	     return node.level === 1 ? 'red' : 'gray'
	    }
	    var nodeElements = svg.append("g")
	     .attr("class", "nodes")
	     .selectAll("circle")
	     .data(nodes)
	     .enter().append("circle")
	     /* .attr(circleAttrs) */
	     // .attr("r", function (d, i) {return d.level})
	      .attr("r", 5)
	      .attr("fill", function (d, i) {return colors(d.group);})
	      .attr("class", "cluster_visual")
			  .attr("loaded_color",function (d) {return colors(d.group); })
			  .attr("cluster_id", function(node){return node.label})
	      //.attr("text",function (node) { return node.label })
	      /* .on("mouseover", function (node) { return node.label }); */
	    var textElements = svg.append("g")
	     .attr("class", "texts")
	     .selectAll("text")
	     .data(nodes)
	     .enter().append("text")
	      //.text(function (node) { return node.label })
	    	 .attr("font-size", 15)
	    	 .attr("dx", 15)
	      .attr("dy", 4) 
	     simulation.nodes(nodes).on('tick', () => {
	      nodeElements
	       .attr('cx', function (node) { return node.x })
	       .attr('cy', function (node) { return node.y })
	       textElements  
	       .attr('x', function (node) { return node.x })
	       .attr('y', function (node) { return node.y })
	       linkElements
	   .attr('x1', function (link) { return link.source.x })
	   .attr('y1', function (link) { return link.source.y })
	   .attr('x2', function (link) { return link.target.x })
	   .attr('y2', function (link) { return link.target.y })
	     })
	function handleMouseOver(d, i) { // Add interactivity
	      // Use D3 to select element, change color and size
	      d3.select(this).attr({
	       fill: "orange",
	       r: radius * 2
	      });
	      // Specify where to put label of text
	      svg.append("text").attr({
	        id: "t" + d.x + "-" + d.y + "-" + i, // Create an id for text so we can select it later for removing on mouseout
	        x: function() { return xScale(d.x) - 30; },
	        y: function() { return yScale(d.y) - 15; }
	      })
	      .text(function() {
	       return [d.x, d.y]; // Value of the text
	      });
	     }
	 simulation.force("link").links(links)
	 
	 ///view loaded chart and update loaad status
	 
	 $('#clusterdiagram_loader_'+identify).addClass('hidden')
	 $('#clusterdiagram_'+identify).removeClass('hidden')
	 $('#clusterdiagram_'+identify).attr('load_status', 1)
	 ///end view loaded chart and update oad status
	 
	 
	 }
 ////end clustering3 function 
 
 
 ///start clustering5 funtion
 function clusterdiagram5(element, height, plot_width) {
	// console.log("this is dataset1",dataset)
	 
	 var final_centroids = {};
	 dataset = <%=final_centroids %>
	 	 //console.log("this is dataset2",dataset)
	 	 
	 	 //start getting max and min posts numbers
	 	for(var i = 0; i < dataset.nodes.length; i++){
	 		// console.log("this is dataset4",dataset.nodes[i].level)
	 		 if(i == 0){
	 			min_post_count = dataset.nodes[i].level
	 			max_post_count = dataset.nodes[i].level
	 		 }
	 		 
	 		 if(dataset.nodes[i].level < min_post_count){
	 			min_post_count = dataset.nodes[i].level
	 		 }
	 		 
	 		if(dataset.nodes[i].level > max_post_count){
	 			max_post_count = dataset.nodes[i].level
	 		 }
	 		 
	 	}
	 	//end getting max and min posts numbers
	 	
	 	//start get normalized array for radius values
	 	normalized_radius = [];
	 	for(var i = 0; i < dataset.nodes.length; i++){
	 		
	 		normalized_value = ( (dataset.nodes[i].level - min_post_count)/(max_post_count - min_post_count));
	 		
	 		range = 2 - 1;
	 		normalized_value = (normalized_value * range) + 1;
	 		
	 		temp = normalized_value * 25;
	 		normalized_radius[i] = temp;
	 		
	 		 //console.log("normalized_value",dataset.nodes[i].level,normalized_value )
	 		
	 		 
	 	}
	 	//console.log("normalized_value",normalized_radius )
	 	//start get normalized array for radius values
  /* var nodes = [
   { id: "mammal", group: 0, label: "Mammals", level: 2 },
   { id: "dog"  , group: 0, label: "Dogs"  , level: 2 },
   { id: "cat"  , group: 0, label: "Cats"  , level: 2 },
   { id: "fox"  , group: 0, label: "Foxes" , level: 2 },
   { id: "elk"  , group: 0, label: "Elk"  , level: 2 },
   { id: "insect", group: 1, label: "Insects", level: 2 },
   { id: "ant"  , group: 1, label: "Ants"  , level: 2 },
   { id: "bee"  , group: 1, label: "Bees"  , level: 2 },
   { id: "fish" , group: 2, label: "Fish"  , level: 2 },
   { id: "carp" , group: 2, label: "Carp"  , level: 2 },
   { id: "pike" , group: 2, label: "Pikes" , level: 2 }
  ] */
	 
var nodes = dataset.nodes
//console.log('nodes', nodes)
//console.log('nodes',nodes)
  /* var links = [
  	{ target: "mammal", source: "dog" , strength: 3.0 },
  	{ target: "bee", source: "cat" , strength: 3.0 }
   /* { target: "mammal", source: "fox" , strength: 3.0 },
   { target: "insect", source: "ant" , strength: 0.7 },
   { target: "insect", source: "bee" , strength: 0.7 },
   { target: "fish" , source: "carp", strength: 0.7 },
   { target: "fish" , source: "pike", strength: 0.7 },
   { target: "cat"  , source: "elk" , strength: 0.1 },
   { target: "carp" , source: "ant" , strength: 0.1 },
   { target: "elk"  , source: "bee" , strength: 0.1 },
   { target: "dog"  , source: "cat" , strength: 0.1 },
   { target: "fox"  , source: "ant" , strength: 0.1 },
  	{ target: "pike" , source: "cat" , strength: 0.1 } */
  /* ] */
  var links = dataset.links

	  //console.log('links',links)
	  //var width = $('#clusterdiagram').width();
	//var height = $('#clusterdiagram').height();
   // Define main variables
  
   var d3Container = d3v4.select(element),
     margin = {top: 0, right: 50, bottom: 0, left: 50},
     width = plot_width,
     height = height;
			radius = 6;
			
			
	
   var colors = d3v4.scaleOrdinal().range(["green", "red", "blue", "orange", "purple", "pink", "black", "grey", "brown", "yellow"]);;
   // Add SVG element
   var container = d3Container.append("svg");
   // Add SVG group
   var svg = container
     .attr("width", width + margin.left + margin.right)
     .attr("height", height + margin.top + margin.bottom)
   .attr("overflow", "visible");
     //.append("g")
    //  .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
    // simulation setup with all forces
  var linkForce = d3v4
  .forceLink()
  .id(function (link) { return link.id })
  .strength(function (link) { return link.strength })
    // simulation setup with all forces
     var simulation = d3v4
     .forceSimulation()
     .force('link', d3v4.forceLink().id(d =>d.id).distance(-20))
     .force('charge', d3v4.forceManyBody())
     /* .force('center', d3v4.forceCenter(width, height ))  */
     .force('center', d3v4.forceCenter())  
     .force("collide",d3v4.forceCollide().strength(-5)) 
     /* simulation.force("center")
    .x(width * forceProperties.center.x)
    .y(height * forceProperties.center.y); */
     /* var simulation = d3.forceSimulation()
       .force('x', d3.forceX().x(d => d.x))
       .force('y', d3.forceY().y(d => d.y))
       .force("charge",d3.forceManyBody().strength(-20))
       .force("link", d3.forceLink().id(d =>d.id).distance(20)) 
       .force("collide",d3.forceCollide().radius(d => d.r*10)) 
       .force('center', d3v4.forceCenter(width, height )) */
			
			simulation.force("center")
		  .x(width / 2)
		  .y(height / 2)
		   
		  	simulation.force("charge")
    .strength(-2000 * true)
    .distanceMin(1)
    .distanceMax(1000);
		  /* .x(width * 0.5) */
			
			simulation.alpha(1).restart(); 
     var linkElements = svg.append("g")
      .attr("class", "links")
      .selectAll("line")
      .data(links)
      .enter().append("line")
       .attr("stroke-width", 0)
     	 .attr("stroke", "rgba(50, 50, 50, 0.2)")
    function getNodeColor(node) {
     return node.level === 1 ? 'red' : 'gray'
    }
    var nodeElements = svg.append("g")
     .attr("class", "nodes")
     .selectAll("circle")
     .data(nodes)
     .enter().append("circle")
     /* .attr(circleAttrs) */
     // .attr("r", function (d, i) {return d.level})
      .attr("r", function (d, i) {return normalized_radius[d.group-1]})
      .attr("cluster_number", function (d, i) {return d.group})
      .attr("fill", function (d, i) {return colors(d.group);})
      .attr("class", "cluster_visual")
		  .attr("loaded_color",function (d) {return colors(d.group); })
		  .attr("cluster_id", function(node){return node.label})
      //.attr("text",function (node) { return node.label })
      /* .on("mouseover", function (node) { return node.label }); */
    var textElements = svg.append("g")
     .attr("class", "texts")
     .selectAll("text")
     .data(nodes)
     .enter().append("text")
      .text(function (node) { return node.label })
    	 .attr("font-size", 15)
    	 .attr("dx", 15)
      .attr("dy", 4) 
     simulation.nodes(nodes).on('tick', () => {
      nodeElements
       .attr('cx', function (node) { return node.x })
       .attr('cy', function (node) { return node.y })
       textElements  
       .attr('x', function (node) { return node.x })
       .attr('y', function (node) { return node.y })
       linkElements
   .attr('x1', function (link) { return link.source.x })
   .attr('y1', function (link) { return link.source.y })
   .attr('x2', function (link) { return link.target.x })
   .attr('y2', function (link) { return link.target.y })
     })
function handleMouseOver(d, i) { // Add interactivity
      // Use D3 to select element, change color and size
      d3.select(this).attr({
       fill: "orange",
       r: radius * 2
      });
      // Specify where to put label of text
      svg.append("text").attr({
        id: "t" + d.x + "-" + d.y + "-" + i, // Create an id for text so we can select it later for removing on mouseout
        x: function() { return xScale(d.x) - 30; },
        y: function() { return yScale(d.y) - 15; }
      })
      .text(function() {
       return [d.x, d.y]; // Value of the text
      });
     }
 simulation.force("link").links(links)
 }
 ///end clustering5 function
 
 

 
 
 
 
 
 
 
 
 
 
 
	</script>
 <script>
    var d3v4_ = window.d3;
    //console.log(d3v4_.version)
    //window.d3 = null;
</script>
<script>
	//var d3 = d3v4_;
	//console.log("cluster",d3.version)
	
	
	$(document).ready(function() {
		
	$('#clusterdiagram').addClass('hidden');
	$('#clusterdiagram_loader').removeClass('hidden');
	
	//loadscatter(1);
	
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
		//loadscatter(counter_value);
		//loadtitletable(counter_value+1);
		
		$('#clusterdiagram').removeClass('hidden');
		$('#clusterdiagram_loader').addClass('hidden');
		
	});
	
	//end onCliocik handling

})
	
	
	
	
	
	
	
	
	
	
	
	
	
	function loadscatter(clusterid){
		var lengthy = $('#chart-container').width();
		var margin = {
				top : 10,
				right : 30,
				bottom : 30,
				left : 60
			}, width = lengthy - margin.left - margin.right, height = 300 - margin.top
					- margin.bottom;

			//append the SVG object to the body of the page
			var SVG = d3v4_.select("#clusterdiagram").append("svg").attr("width",
					width + margin.left + margin.right).attr("height",
					height + margin.top + margin.bottom).append("g").attr(
					"transform",
					"translate(" + margin.left + "," + margin.top + ")");

			//Read the data
			d3v4_.csv("test_data2.csv", function(data) {
				//console.log(data)
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
$('.blogpost_link').on("click", function(){
	$("body").addClass("loaded");
	var post_id = $(this).attr("id");
	//alert(post_id);
	//console.log(post_id);
	$("#posts_details").html("<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />");
	$(".viewpost").addClass("makeinvisible");
	$('.blogpost_link').removeClass("activeselectedblog");
	$('#'+post_id).addClass("activeselectedblog");
	$(this).parent().children(".viewpost").removeClass("makeinvisible");
	//grab all id of blog and perform an ajax request
	$.ajax({
		url: app_url+"subpages/influencedetail.jsp",
		method: 'POST',
		data: {
			action:"fetchpost",
			post_id:post_id,
			tid:$("#alltid").val()
		},
		error: function(response)
		{						
			//console.log(response);
			//$("#blogpost_detail").html(response);
		},
		success: function(response)
		{   
			//console.log(response);
			$("#posts_details").html(response).hide();
			$("#posts_details").fadeIn(700);
		}
	});
	
});
</script>
 
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
	
	var jsondata = <%=topterms.get("cluster_1").toString().trim()%>;
	//console.log('terms', terms);
	//var new_dd = terms.replace('[','{').replace(']','}').replace(/\),/g,'-').replace(/\(/g,'').replace(/,/g,':').replace(/-/g,',').replace(/\)/g,'').replace(/'/g,"");
	//var newjson = new_dd.replace(/\s+/g,'').replace(/{/g,'{"').replace(/:/g,'":"').replace(/,/g,'","').replace(/}/g,'"}')
	//var newjson = terms.replace(/"/g,"");
	//var jsondata = JSON.parse(terms);
	
	/* data = [];
	for (var key in jsondata) {var dic = {}; dic["text"] = key; dic["size"] = jsondata[key]; data.push(dic);} */
	//console.log('weeweweweewewewewewewew')
	//console.log(jsondata)
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
	buildAndDisplayChord(0);
	
	///Onclick Handling
	$("body").delegate(".clusters_", "click", function() {
		
		$('#chorddiagram').html('');
		$('#chorddiagram').empty();
		
		 counter_value = $(this).attr("counter_value");
		 
		 cluster_index = counter_value-1;
		console.log(cluster_index, 'cluster_index')
		buildAndDisplayChord(cluster_index)
		
		
	});
	
	//end onCliocik handling
	
	//start buildAndDisplayChord function
	function buildAndDisplayChord(cluster_number){
		console.log(cluster_number, 'cluster_number')
		$('#chorddiagram_loader').removeClass('hidden');
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
		    /* clusterMatrix = [
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
		    ] */
		    
		    var cluster_numy = cluster_number
		    var clusterMatrix = []
		     <%
		     int cluster_num = 4;
		     for (int j = 0; j < termsMatrix.length; j++) {%>
		    	var temparr = []
		    	<%for (int k = 0; k < termsMatrix.length; k++) {%>
		    		temp = <%=k %>
		    	if( temp == cluster_numy){ temparr.push(<%=termsMatrix[j][k]%>);}
		    	else{temparr.push(0);}
		    	
		    	<%}%>
		    	clusterMatrix.push(temparr);
			<%}%> 
			
			//console.log('matirx', clusterMatrix)
			<%-- <%for(int j = 0; j < termsMatrix.length; j++){%>
	    	var temparr = []
	    	<%System.out.println("items--"+termsMatrix[0][j]);%>
	    	<%for(int k = 0; k < termsMatrix.length; k++){%>
	    		
	    		
	    	<%}%>
	    	clusterMatrix.push(temparr);
	    	temparr.push(<%=termsMatrix[0][j]%>);
		<%}%>  --%>
		    drawChord("#chorddiagram", chord_options, clusterMatrix, names); 
		    $('#chorddiagram').removeClass('hidden');
			$('#chorddiagram_loader').addClass('hidden');
		
	}
	 ///end buildAndDisplayChord function
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
