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

	JSONObject res = new JSONObject(result.get(0).toString());
	
	JSONObject source = new JSONObject(res.get("_source").toString());

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
	
	for (int i = 1; i < 11; i++) {

		String cluster_ = "cluster_" + String.valueOf(i);
		String centroids = "C" + String.valueOf(i) + "xy";
		JSONObject cluster_data = new JSONObject(source.get(cluster_).toString());
		//Map s = new LinkedHashMap();
		//System.out.println(source.get(cluster_).toString());
		//System.out.println(cluster_data);
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
		
		//List<JSONObject>  postDataAll = cluster.getPosts(post_ids, "", "", "__ONLY__POST__ID__","blogposts");
		ArrayList<JSONObject> postDataAll = DbConnection.queryJSON("select date,post,num_comments, blogger,permalink, title, blogpost_id, location, blogsite_id from blogposts where blogpost_id in ("+post_ids+") limit 500");
		//String terms = cluster.getTopTerms(post_ids);
		//System.out.println(terms);
		//System.out.println("done");

		
		
		String terms = cluster_data.get("topterms").toString();
		String str1 = null;
		str1 = terms.replace("),", "-").replace("(", "").replace(")", "").replaceAll("[0-9]","").replace("-", "");
		List<String> t1 = Arrays.asList(str1.replace("[","").replace("]","").split(","));
		termsMatrix[i - 1][i - 1] = t1.size();
		//String terms = cluster.getTopTerms(post_ids);
		System.out.println(terms);

		//CREATING CHORD MATRIX
		
		String str2 = null;
		
		for(int k = (i + 1); k < 11; k++)
		{
		String cluster_matrix  = "cluster_" + String.valueOf(k);
		JSONObject cluster_data_matrix = new JSONObject(source.get(cluster_matrix).toString());
		String terms_matrix = cluster_data_matrix.get("topterms").toString();
		
		
		str2 = terms_matrix.replace("),", "-").replace("(", "").replace(")", "").replaceAll("[0-9]","").replace("-", "");
		//JSONArray terms_array = new JSONArray(str);
		
		
		List<String> t2 = Arrays.asList(str2.replace("[","").replace("]","").split(","));
		//System.out.println(t1);
		//System.out.println(t2);
//		System.out.println("ttt"+t1.retainAll(t2));
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
		System.out.println(terms);
		
		key_val = new Pair<String, String>(cluster_, post_ids);
		//key_val.put(cluster_,post_ids);
		System.out.println("clusters --" + cluster_);

		/* for(int j = 0; j < postDataAll.length(); j++){
			
		} */
		key_val_posts.put(cluster_, post_ids);
		clusterResult.put(key_val, postDataAll);
		
		

	}

	//System.out.println(topterms.size());
	/* for(int i = 0; i < termsMatrix.length; i++){
		System.out.println("termsMatrix --" + Arrays.toString(termsMatrix[i]));
	} */
	
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
<script type="text/javascript" src="jquery.zoomooz.min.js"></script>
<script>
//console.log('scatter data');

</script>


    <style type="text/css">
        * { box-sizing: border-box; }

.grid:after {
  content: '';
  display: block;
  clear: both;
}

.grid-item {
  width: 80px;
  height: 60px;
  float: left;
  background: #00997B;
  border: 1px solid #333;
  border-color: hsla(0, 0%, 0%, 0.5);
  /* border-radius: 5px; */
  margin-bottom: 20px;
  margin: 10px;
  border-radius: 50%;
    behavior: url(PIE.htc); /* remove if you don't care about IE8 */
}

.grid-item1 {
  width: 80px;
  height: 60px;
  float: none;
  background: #00997B;
  border: 1px solid #333;
  border-color: hsla(0, 0%, 0%, 0.5);
  /* border-radius: 5px; */
  margin-bottom: 20px;
  margin: 10px;
  border-radius: 50%;
    behavior: url(PIE.htc); /* remove if you don't care about IE8 */
}

.displayed1 {
    display: block;
    margin-left: auto;
    margin-right: auto }

.holder1
    {
      display:table-cell !important;
      vertical-align:middle !important;
      text-align:center !important;
     
    }

.grid-item2 {
  width: 80px;
  height: 60px;
  float: none;
  background: white;
  border: 1px solid #333;
  border-color: grey;
  /* border-radius: 5px; */
  margin-bottom: 20px;
  margin: 10px;
  border-radius: 50%;
    behavior: url(PIE.htc); /* remove if you don't care about IE8 */
}

.grid-item--width2 { width: 340px; }
.grid-item--width3 { width: 520px; }
.grid-item--width4 { width: 780px; }

.grid-item--height2 { height: 200px; }
.grid-item--height3 { height: 260px; }
.grid-item--height4 { height: 360px; }



.hidden{
  
  display: none;
}

.oga_boss{
    height: 300px !important;
     width: 850px !important;
}

.float_center{
    text-align: center !important;
    float: none !important;
}
.float_right{
    float: right !important;
}

.float_left{
    float: left !important;
}

.testy {
    -webkit-transform: scale(0.2);
  -moz-transform: scale(0.2);
  -ms-transform: scale(0.2);
  transform: scale(0.2);
  display: block;
  margin-left: auto;
  margin-right: auto;
  width: 50%;
}

.ctna {
    min-height: 150px;
    min-width: 150px;
    margin-left: auto;
    margin-right: auto;
    text-align: center;
    display: table-cell;
    vertical-align: middle }

.testyq {
    -webkit-transform: scale(1.0);
  -moz-transform: scale(1.0);
  -ms-transform: scale(1.0);
  transform: scale(1.0);
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
								//JSONArray postData = new JSONArray();
								ArrayList postData;

								String[] colors = {"green", "red", "blue", "orange", "purple", "pink", "black", "grey", "brown", "yellow"};
								int i = 0;
								Pair<String, String> currentKey = new Pair<String, String>(null, null);

								for (Map.Entry<Pair<String, String>, ArrayList<JSONObject>> entry : clusterResult.entrySet()) {
									Pair<String, String> key = entry.getKey();
									
									String temp_terms = topterms.get("cluster_" + (i + 1));
									//System.out.println("terms ---" + terms);
									String word_build = "";
									
									//System.out.println("terms ---" + terms);
									temp_terms = temp_terms.replace("{","").replace("}", "").replace("[","").replace("]", "").replace("),", "-").replace("(", "").replace("\'", "").replace("\"", "");;
									List<String> termlist = Arrays.asList(temp_terms.split(","));
									
									for(int m = 0; m < 10; m++){
										if(m > 0){
											word_build += ", ";
										}
										word_build += termlist.get(m).split(":")[0];
										//System.out.println("original--" + termlist.get(m));
										//System.out.println("building--" + termlist.get(m).split(":")[0]);
									
									}
									System.out.println("original--" + word_build);

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
							<a data-toggle="tooltip" data-placement="top" title="<%=word_build%>" class="clusters_ btn  form-control stylebuttonactive mb20 "
								id="cluster_<%=i + 1%>" counter_value="<%=i  +1%>"
								style="background-color: <%=colors[i]%>;"> <b>Cluster <%=i + 1%></b>
							</a>
							<%
								} else {
							%>
							<a data-toggle="tooltip" data-placement="top" title="<%=word_build%>"
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
						<div style="min-height: 500px;">
							
							
							    <div align="center" class="container-fluid">
  
								  <div align="center" class="row">
								      <div class="col-md-6 text-center">
								        <div class=" ">
								            <div class="grid-item1 float_right"></div>
								        </div>
								        
								    </div>
								
								    <div class="col-md-6 text-center">
								        <div class="">
								            <div class="grid-item1 float_left"></div>
								        </div>
								        
								
								    </div>
								  </div>
								
								  <div style="width: 100%" class="row">
								
								    <div class="col-md-1">
								        <div class="grid-item pre_zoom"></div>
								        <div class="clearfix"></div>
								        <div class="grid-item pre_zoom"></div>
								        <div class="clearfix"></div>
								        <div class="grid-item pre_zoom"></div>
								        <circle r="25" cx="718.6455727647539" cy="227.62005403119366" style="fill: rgb(148, 103, 189); stroke: rgb(148, 103, 189); stroke-width: 10px; pointer-events: all;"></circle>
								     
								
								    </div>
								    <div id="mainTarget1" class="col-md-10">
								        <div style="padding-left: 100px; padding-top:100px;" data-targetsize="0.9" id="clusterdiagram" data-closeclick="true" class="displayed1 ctna grid-item2 oga_boss zoomTarget">
								        
								        </div>
								    </div>
								    <div class="col-md-1">
								        <div class="grid-item float_right pre_zoom"></div>
								        <div class="clearfix"></div>
								        <div class="grid-item float_right pre_zoom"></div>
								        <div class="clearfix"></div>
								        <div class="grid-item float_right pre_zoom"></div>
								    </div>
								      
								  </div>
								
								  <div align="center" class="row">
								      <div class="col-md-6 text-center">
								        <div class=" ">
								            <div class="grid-item1 float_right pre_zoom"></div>
								        </div>
								        
								    </div>
								
								    <div class="col-md-6 text-center">
								        <div class="">
								            <div class="grid-item1 float_left pre_zoom"></div>
								        </div>
								        
								
								    </div>
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
										System.out.println(p);
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
								
								<% for(int k = 0; k < topterms.size(); k++){ %>
								
									<tr>
										
										<% 
										int max = 0;
										for(int m = 0; m < 10; m++){
											
											String terms = topterms.get("cluster_" + (m + 1));
											//System.out.println("terms ---" + terms);
											terms = terms.replace("{","").replace("}","").replace("[","").replace("]", "").replace("),", "-").replace("(", "").replace("\'", "").replace("\"", "");
											List<String> termlist = Arrays.asList(terms.split(","));
											max = Integer.parseInt(termlist.get(k).split(":")[1]);
											
										%>
										
										<td>
											<%=termlist.get(k).split(":")[0]%>
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

 <script src="https://d3js.org/d3.v4.js"></script>
<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
try {
var pageTracker = _gat._getTracker("UA-16288001-1");
pageTracker._trackPageview();
} catch(err) {}</script>

<script type="text/javascript">
	$("body").delegate(".pre_zoom", "click", function() {
		
		//$('.zoomTarget').click();
		//alert('bobo');
		
		  var d3v4 = window.d3;
		  var plot_width = $('#clusterdiagram').width();
		var plot_height = $('#clusterdiagram').height() - 25;

		 clusterdiagram('#clusterdiagram', 500);
		 
		//Chart setup
		 function clusterdiagram(element, height) {

		    /* var nodes = [
		     { id: "mammal", group: 0, label: "Mammals", level: 2 },
		     { id: "dog"   , group: 0, label: "Dogs"   , level: 2 },
		     { id: "cat"   , group: 0, label: "Cats"   , level: 2 },
		     { id: "fox"   , group: 0, label: "Foxes"  , level: 2 },
		     { id: "elk"   , group: 0, label: "Elk"    , level: 2 },
		     { id: "insect", group: 1, label: "Insects", level: 2 },
		     { id: "ant"   , group: 1, label: "Ants"   , level: 2 },
		     { id: "bee"   , group: 1, label: "Bees"   , level: 2 },
		     { id: "fish"  , group: 2, label: "Fish"   , level: 2 },
		     { id: "carp"  , group: 2, label: "Carp"   , level: 2 },
		     { id: "pike"  , group: 2, label: "Pikes"  , level: 2 }
		   ]  */

		    /* var links = [
		    { target: "mammal", source: "dog" , strength: 3.0 },
		    { target: "bee", source: "cat" , strength: 3.0 }] */
		    var nodes = [{'id': 'post_0', 'group': 4, 'label': 'Post_0', 'level': 1},
		   	 {'id': 'post_1', 'group': 5, 'label': 'Post_1', 'level': 1},
		   	 {'id': 'post_2', 'group': 2, 'label': 'Post_2', 'level': 1},
		   	 {'id': 'post_3', 'group': 10, 'label': 'Post_3', 'level': 1},
		   	 {'id': 'post_4', 'group': 1, 'label': 'Post_4', 'level': 1},
		   	 {'id': 'post_5', 'group': 5, 'label': 'Post_5', 'level': 1},
		   	 {'id': 'post_6', 'group': 5, 'label': 'Post_6', 'level': 1},
		   	 {'id': 'post_7', 'group': 4, 'label': 'Post_7', 'level': 1},
		   	 {'id': 'post_8', 'group': 4, 'label': 'Post_8', 'level': 1},
		   	 {'id': 'post_9', 'group': 5, 'label': 'Post_9', 'level': 1},
		   	 {'id': 'post_10', 'group': 1, 'label': 'Post_10', 'level': 1},
		   	 {'id': 'post_11', 'group': 4, 'label': 'Post_11', 'level': 1},
		   	 {'id': 'post_12', 'group': 8, 'label': 'Post_12', 'level': 1},
		   	 {'id': 'post_13', 'group': 6, 'label': 'Post_13', 'level': 1},
		   	 {'id': 'post_14', 'group': 6, 'label': 'Post_14', 'level': 1},
		   	 {'id': 'post_15', 'group': 2, 'label': 'Post_15', 'level': 1},
		   	 {'id': 'post_16', 'group': 3, 'label': 'Post_16', 'level': 1},
		   	 {'id': 'post_17', 'group': 1, 'label': 'Post_17', 'level': 1},
		   	 {'id': 'post_18', 'group': 8, 'label': 'Post_18', 'level': 1},
		   	 {'id': 'post_19', 'group': 4, 'label': 'Post_19', 'level': 1},
		   	 {'id': 'post_20', 'group': 4, 'label': 'Post_20', 'level': 1},
		   	 {'id': 'post_21', 'group': 1, 'label': 'Post_21', 'level': 1},
		   	 {'id': 'post_22', 'group': 1, 'label': 'Post_22', 'level': 1},
		   	 {'id': 'post_23', 'group': 5, 'label': 'Post_23', 'level': 1},
		   	 {'id': 'post_24', 'group': 1, 'label': 'Post_24', 'level': 1},
		   	 {'id': 'post_25', 'group': 5, 'label': 'Post_25', 'level': 1},
		   	 {'id': 'post_26', 'group': 7, 'label': 'Post_26', 'level': 1},
		   	 {'id': 'post_27', 'group': 5, 'label': 'Post_27', 'level': 1},
		   	 {'id': 'post_28', 'group': 4, 'label': 'Post_28', 'level': 1},
		   	 {'id': 'post_29', 'group': 4, 'label': 'Post_29', 'level': 1},
		   	 {'id': 'post_30', 'group': 9, 'label': 'Post_30', 'level': 1},
		   	 {'id': 'post_31', 'group': 7, 'label': 'Post_31', 'level': 1},
		   	 {'id': 'post_32', 'group': 7, 'label': 'Post_32', 'level': 1},
		   	 {'id': 'post_33', 'group': 9, 'label': 'Post_33', 'level': 1},
		   	 {'id': 'post_34', 'group': 2, 'label': 'Post_34', 'level': 1},
		   	 {'id': 'post_35', 'group': 1, 'label': 'Post_35', 'level': 1},
		   	 {'id': 'post_36', 'group': 4, 'label': 'Post_36', 'level': 1},
		   	 {'id': 'post_37', 'group': 7, 'label': 'Post_37', 'level': 1},
		   	 {'id': 'post_38', 'group': 1, 'label': 'Post_38', 'level': 1},
		   	 {'id': 'post_39', 'group': 6, 'label': 'Post_39', 'level': 1},
		   	 {'id': 'post_40', 'group': 2, 'label': 'Post_40', 'level': 1},
		   	 {'id': 'post_41', 'group': 9, 'label': 'Post_41', 'level': 1},
		   	 {'id': 'post_42', 'group': 2, 'label': 'Post_42', 'level': 1},
		   	 {'id': 'post_43', 'group': 10, 'label': 'Post_43', 'level': 1},
		   	 {'id': 'post_44', 'group': 10, 'label': 'Post_44', 'level': 1},
		   	 {'id': 'post_45', 'group': 7, 'label': 'Post_45', 'level': 1},
		   	 {'id': 'post_46', 'group': 6, 'label': 'Post_46', 'level': 1},
		   	 {'id': 'post_47', 'group': 2, 'label': 'Post_47', 'level': 1},
		   	 {'id': 'post_48', 'group': 7, 'label': 'Post_48', 'level': 1},
		   	 {'id': 'post_49', 'group': 7, 'label': 'Post_49', 'level': 1},
		   	 {'id': 'post_50', 'group': 6, 'label': 'Post_50', 'level': 1},
		   	 {'id': 'post_51', 'group': 8, 'label': 'Post_51', 'level': 1},
		   	 {'id': 'post_52', 'group': 1, 'label': 'Post_52', 'level': 1},
		   	 {'id': 'post_53', 'group': 7, 'label': 'Post_53', 'level': 1},
		   	 {'id': 'post_54', 'group': 10, 'label': 'Post_54', 'level': 1},
		   	 {'id': 'post_55', 'group': 9, 'label': 'Post_55', 'level': 1},
		   	 {'id': 'post_56', 'group': 10, 'label': 'Post_56', 'level': 1},
		   	 {'id': 'post_57', 'group': 7, 'label': 'Post_57', 'level': 1},
		   	 {'id': 'post_58', 'group': 8, 'label': 'Post_58', 'level': 1},
		   	 {'id': 'post_59', 'group': 4, 'label': 'Post_59', 'level': 1},
		   	 {'id': 'post_60', 'group': 1, 'label': 'Post_60', 'level': 1},
		   	 {'id': 'post_61', 'group': 10, 'label': 'Post_61', 'level': 1},
		   	 {'id': 'post_62', 'group': 3, 'label': 'Post_62', 'level': 1},
		   	 {'id': 'post_63', 'group': 3, 'label': 'Post_63', 'level': 1},
		   	 {'id': 'post_64', 'group': 6, 'label': 'Post_64', 'level': 1},
		   	 {'id': 'post_65', 'group': 5, 'label': 'Post_65', 'level': 1},
		   	 {'id': 'post_66', 'group': 3, 'label': 'Post_66', 'level': 1},
		   	 {'id': 'post_67', 'group': 7, 'label': 'Post_67', 'level': 1},
		   	 {'id': 'post_68', 'group': 6, 'label': 'Post_68', 'level': 1},
		   	 {'id': 'post_69', 'group': 5, 'label': 'Post_69', 'level': 1},
		   	 {'id': 'post_70', 'group': 8, 'label': 'Post_70', 'level': 1},
		   	 {'id': 'post_71', 'group': 4, 'label': 'Post_71', 'level': 1},
		   	 {'id': 'post_72', 'group': 7, 'label': 'Post_72', 'level': 1},
		   	 {'id': 'post_73', 'group': 5, 'label': 'Post_73', 'level': 1},
		   	 {'id': 'post_74', 'group': 1, 'label': 'Post_74', 'level': 1},
		   	 {'id': 'post_75', 'group': 6, 'label': 'Post_75', 'level': 1},
		   	 {'id': 'post_76', 'group': 3, 'label': 'Post_76', 'level': 1},
		   	 {'id': 'post_77', 'group': 8, 'label': 'Post_77', 'level': 1},
		   	 {'id': 'post_78', 'group': 8, 'label': 'Post_78', 'level': 1},
		   	 {'id': 'post_79', 'group': 4, 'label': 'Post_79', 'level': 1},
		   	 {'id': 'post_80', 'group': 8, 'label': 'Post_80', 'level': 1},
		   	 {'id': 'post_81', 'group': 5, 'label': 'Post_81', 'level': 1},
		   	 {'id': 'post_82', 'group': 7, 'label': 'Post_82', 'level': 1},
		   	 {'id': 'post_83', 'group': 3, 'label': 'Post_83', 'level': 1},
		   	 {'id': 'post_84', 'group': 7, 'label': 'Post_84', 'level': 1},
		   	 {'id': 'post_85', 'group': 3, 'label': 'Post_85', 'level': 1},
		   	 {'id': 'post_86', 'group': 10, 'label': 'Post_86', 'level': 1},
		   	 {'id': 'post_87', 'group': 4, 'label': 'Post_87', 'level': 1},
		   	 {'id': 'post_88', 'group': 7, 'label': 'Post_88', 'level': 1},
		   	 {'id': 'post_89', 'group': 9, 'label': 'Post_89', 'level': 1},
		   	 {'id': 'post_90', 'group': 4, 'label': 'Post_90', 'level': 1},
		   	 {'id': 'post_91', 'group': 10, 'label': 'Post_91', 'level': 1},
		   	 {'id': 'post_92', 'group': 6, 'label': 'Post_92', 'level': 1},
		   	 {'id': 'post_93', 'group': 8, 'label': 'Post_93', 'level': 1},
		   	 {'id': 'post_94', 'group': 6, 'label': 'Post_94', 'level': 1},
		   	 {'id': 'post_95', 'group': 1, 'label': 'Post_95', 'level': 1},
		   	 {'id': 'post_96', 'group': 5, 'label': 'Post_96', 'level': 1},
		   	 {'id': 'post_97', 'group': 8, 'label': 'Post_97', 'level': 1},
		   	 {'id': 'post_98', 'group': 8, 'label': 'Post_98', 'level': 1},
		   	 {'id': 'post_99', 'group': 8, 'label': 'Post_99', 'level': 1},
		   	 {'id': 'post_100', 'group': 7, 'label': 'Post_100', 'level': 1},
		   	 {'id': 'post_101', 'group': 7, 'label': 'Post_101', 'level': 1},
		   	 {'id': 'post_102', 'group': 10, 'label': 'Post_102', 'level': 1},
		   	 {'id': 'post_103', 'group': 1, 'label': 'Post_103', 'level': 1},
		   	 {'id': 'post_104', 'group': 1, 'label': 'Post_104', 'level': 1},
		   	 {'id': 'post_105', 'group': 10, 'label': 'Post_105', 'level': 1},
		   	 {'id': 'post_106', 'group': 2, 'label': 'Post_106', 'level': 1},
		   	 {'id': 'post_107', 'group': 5, 'label': 'Post_107', 'level': 1},
		   	 {'id': 'post_108', 'group': 6, 'label': 'Post_108', 'level': 1},
		   	 {'id': 'post_109', 'group': 6, 'label': 'Post_109', 'level': 1},
		   	 {'id': 'post_110', 'group': 6, 'label': 'Post_110', 'level': 1},
		   	 {'id': 'post_111', 'group': 4, 'label': 'Post_111', 'level': 1},
		   	 {'id': 'post_112', 'group': 7, 'label': 'Post_112', 'level': 1},
		   	 {'id': 'post_113', 'group': 9, 'label': 'Post_113', 'level': 1},
		   	 {'id': 'post_114', 'group': 5, 'label': 'Post_114', 'level': 1},
		   	 {'id': 'post_115', 'group': 10, 'label': 'Post_115', 'level': 1},
		   	 {'id': 'post_116', 'group': 6, 'label': 'Post_116', 'level': 1},
		   	 {'id': 'post_117', 'group': 4, 'label': 'Post_117', 'level': 1},
		   	 {'id': 'post_118', 'group': 6, 'label': 'Post_118', 'level': 1},
		   	 {'id': 'post_119', 'group': 1, 'label': 'Post_119', 'level': 1},
		   	 {'id': 'post_120', 'group': 1, 'label': 'Post_120', 'level': 1},
		   	 {'id': 'post_121', 'group': 6, 'label': 'Post_121', 'level': 1},
		   	 {'id': 'post_122', 'group': 6, 'label': 'Post_122', 'level': 1},
		   	 {'id': 'post_123', 'group': 6, 'label': 'Post_123', 'level': 1},
		   	 {'id': 'post_124', 'group': 4, 'label': 'Post_124', 'level': 1},
		   	 {'id': 'post_125', 'group': 6, 'label': 'Post_125', 'level': 1},
		   	 {'id': 'post_126', 'group': 6, 'label': 'Post_126', 'level': 1},
		   	 {'id': 'post_127', 'group': 2, 'label': 'Post_127', 'level': 1},
		   	 {'id': 'post_128', 'group': 3, 'label': 'Post_128', 'level': 1},
		   	 {'id': 'post_129', 'group': 8, 'label': 'Post_129', 'level': 1},
		   	 {'id': 'post_130', 'group': 7, 'label': 'Post_130', 'level': 1},
		   	 {'id': 'post_131', 'group': 1, 'label': 'Post_131', 'level': 1},
		   	 {'id': 'post_132', 'group': 8, 'label': 'Post_132', 'level': 1},
		   	 {'id': 'post_133', 'group': 5, 'label': 'Post_133', 'level': 1},
		   	 {'id': 'post_134', 'group': 3, 'label': 'Post_134', 'level': 1},
		   	 {'id': 'post_135', 'group': 1, 'label': 'Post_135', 'level': 1},
		   	 {'id': 'post_136', 'group': 7, 'label': 'Post_136', 'level': 1},
		   	 {'id': 'post_137', 'group': 9, 'label': 'Post_137', 'level': 1},
		   	 {'id': 'post_138', 'group': 4, 'label': 'Post_138', 'level': 1},
		   	 {'id': 'post_139', 'group': 10, 'label': 'Post_139', 'level': 1},
		   	 {'id': 'post_140', 'group': 5, 'label': 'Post_140', 'level': 1},
		   	 {'id': 'post_141', 'group': 1, 'label': 'Post_141', 'level': 1},
		   	 {'id': 'post_142', 'group': 7, 'label': 'Post_142', 'level': 1},
		   	 {'id': 'post_143', 'group': 5, 'label': 'Post_143', 'level': 1},
		   	 {'id': 'post_144', 'group': 9, 'label': 'Post_144', 'level': 1},
		   	 {'id': 'post_145', 'group': 1, 'label': 'Post_145', 'level': 1},
		   	 {'id': 'post_146', 'group': 5, 'label': 'Post_146', 'level': 1},
		   	 {'id': 'post_147', 'group': 6, 'label': 'Post_147', 'level': 1},
		   	 {'id': 'post_148', 'group': 5, 'label': 'Post_148', 'level': 1},
		   	 {'id': 'post_149', 'group': 2, 'label': 'Post_149', 'level': 1},
		   	 {'id': 'post_150', 'group': 9, 'label': 'Post_150', 'level': 1},
		   	 {'id': 'post_151', 'group': 1, 'label': 'Post_151', 'level': 1},
		   	 {'id': 'post_152', 'group': 8, 'label': 'Post_152', 'level': 1},
		   	 {'id': 'post_153', 'group': 7, 'label': 'Post_153', 'level': 1},
		   	 {'id': 'post_154', 'group': 4, 'label': 'Post_154', 'level': 1},
		   	 {'id': 'post_155', 'group': 4, 'label': 'Post_155', 'level': 1},
		   	 {'id': 'post_156', 'group': 5, 'label': 'Post_156', 'level': 1},
		   	 {'id': 'post_157', 'group': 3, 'label': 'Post_157', 'level': 1},
		   	 {'id': 'post_158', 'group': 8, 'label': 'Post_158', 'level': 1},
		   	 {'id': 'post_159', 'group': 6, 'label': 'Post_159', 'level': 1},
		   	 {'id': 'post_160', 'group': 5, 'label': 'Post_160', 'level': 1},
		   	 {'id': 'post_161', 'group': 5, 'label': 'Post_161', 'level': 1},
		   	 {'id': 'post_162', 'group': 1, 'label': 'Post_162', 'level': 1},
		   	 {'id': 'post_163', 'group': 7, 'label': 'Post_163', 'level': 1},
		   	 {'id': 'post_164', 'group': 7, 'label': 'Post_164', 'level': 1},
		   	 {'id': 'post_165', 'group': 5, 'label': 'Post_165', 'level': 1},
		   	 {'id': 'post_166', 'group': 5, 'label': 'Post_166', 'level': 1},
		   	 {'id': 'post_167', 'group': 10, 'label': 'Post_167', 'level': 1},
		   	 {'id': 'post_168', 'group': 10, 'label': 'Post_168', 'level': 1},
		   	 {'id': 'post_169', 'group': 10, 'label': 'Post_169', 'level': 1},
		   	 {'id': 'post_170', 'group': 9, 'label': 'Post_170', 'level': 1},
		   	 {'id': 'post_171', 'group': 4, 'label': 'Post_171', 'level': 1},
		   	 {'id': 'post_172', 'group': 8, 'label': 'Post_172', 'level': 1},
		   	 {'id': 'post_173', 'group': 6, 'label': 'Post_173', 'level': 1},
		   	 {'id': 'post_174', 'group': 4, 'label': 'Post_174', 'level': 1},
		   	 {'id': 'post_175', 'group': 3, 'label': 'Post_175', 'level': 1},
		   	 {'id': 'post_176', 'group': 2, 'label': 'Post_176', 'level': 1},
		   	 {'id': 'post_177', 'group': 6, 'label': 'Post_177', 'level': 1},
		   	 {'id': 'post_178', 'group': 3, 'label': 'Post_178', 'level': 1},
		   	 {'id': 'post_179', 'group': 5, 'label': 'Post_179', 'level': 1},
		   	 {'id': 'post_180', 'group': 2, 'label': 'Post_180', 'level': 1},
		   	 {'id': 'post_181', 'group': 9, 'label': 'Post_181', 'level': 1},
		   	 {'id': 'post_182', 'group': 9, 'label': 'Post_182', 'level': 1},
		   	 {'id': 'post_183', 'group': 3, 'label': 'Post_183', 'level': 1},
		   	 {'id': 'post_184', 'group': 2, 'label': 'Post_184', 'level': 1},
		   	 {'id': 'post_185', 'group': 4, 'label': 'Post_185', 'level': 1},
		   	 {'id': 'post_186', 'group': 7, 'label': 'Post_186', 'level': 1},
		   	 {'id': 'post_187', 'group': 4, 'label': 'Post_187', 'level': 1},
		   	 {'id': 'post_188', 'group': 4, 'label': 'Post_188', 'level': 1},
		   	 {'id': 'post_189', 'group': 9, 'label': 'Post_189', 'level': 1},
		   	 {'id': 'post_190', 'group': 4, 'label': 'Post_190', 'level': 1},
		   	 {'id': 'post_191', 'group': 10, 'label': 'Post_191', 'level': 1},
		   	 {'id': 'post_192', 'group': 10, 'label': 'Post_192', 'level': 1},
		   	 {'id': 'post_193', 'group': 4, 'label': 'Post_193', 'level': 1},
		   	 {'id': 'post_194', 'group': 5, 'label': 'Post_194', 'level': 1},
		   	 {'id': 'post_195', 'group': 6, 'label': 'Post_195', 'level': 1},
		   	 {'id': 'post_196', 'group': 2, 'label': 'Post_196', 'level': 1},
		   	 {'id': 'post_197', 'group': 10, 'label': 'Post_197', 'level': 1},
		   	 {'id': 'post_198', 'group': 4, 'label': 'Post_198', 'level': 1},
		   	 {'id': 'post_199', 'group': 9, 'label': 'Post_199', 'level': 1},
		   	 {'id': 'post_200', 'group': 4, 'label': 'Post_200', 'level': 1},
		   	 {'id': 'post_201', 'group': 8, 'label': 'Post_201', 'level': 1},
		   	 {'id': 'post_202', 'group': 10, 'label': 'Post_202', 'level': 1},
		   	 {'id': 'post_203', 'group': 9, 'label': 'Post_203', 'level': 1},
		   	 {'id': 'post_204', 'group': 10, 'label': 'Post_204', 'level': 1},
		   	 {'id': 'post_205', 'group': 9, 'label': 'Post_205', 'level': 1},
		   	 {'id': 'post_206', 'group': 4, 'label': 'Post_206', 'level': 1},
		   	 {'id': 'post_207', 'group': 10, 'label': 'Post_207', 'level': 1},
		   	 {'id': 'post_208', 'group': 4, 'label': 'Post_208', 'level': 1},
		   	 {'id': 'post_209', 'group': 1, 'label': 'Post_209', 'level': 1},
		   	 {'id': 'post_210', 'group': 8, 'label': 'Post_210', 'level': 1},
		   	 {'id': 'post_211', 'group': 8, 'label': 'Post_211', 'level': 1},
		   	 {'id': 'post_212', 'group': 7, 'label': 'Post_212', 'level': 1},
		   	 {'id': 'post_213', 'group': 1, 'label': 'Post_213', 'level': 1},
		   	 {'id': 'post_214', 'group': 1, 'label': 'Post_214', 'level': 1},
		   	 {'id': 'post_215', 'group': 4, 'label': 'Post_215', 'level': 1},
		   	 {'id': 'post_216', 'group': 8, 'label': 'Post_216', 'level': 1},
		   	 {'id': 'post_217', 'group': 9, 'label': 'Post_217', 'level': 1},
		   	 {'id': 'post_218', 'group': 3, 'label': 'Post_218', 'level': 1},
		   	 {'id': 'post_219', 'group': 10, 'label': 'Post_219', 'level': 1},
		   	 {'id': 'post_220', 'group': 6, 'label': 'Post_220', 'level': 1},
		   	 {'id': 'post_221', 'group': 7, 'label': 'Post_221', 'level': 1},
		   	 {'id': 'post_222', 'group': 2, 'label': 'Post_222', 'level': 1},
		   	 {'id': 'post_223', 'group': 4, 'label': 'Post_223', 'level': 1},
		   	 {'id': 'post_224', 'group': 4, 'label': 'Post_224', 'level': 1},
		   	 {'id': 'post_225', 'group': 6, 'label': 'Post_225', 'level': 1},
		   	 {'id': 'post_226', 'group': 7, 'label': 'Post_226', 'level': 1},
		   	 {'id': 'post_227', 'group': 1, 'label': 'Post_227', 'level': 1},
		   	 {'id': 'post_228', 'group': 5, 'label': 'Post_228', 'level': 1},
		   	 {'id': 'post_229', 'group': 1, 'label': 'Post_229', 'level': 1},
		   	 {'id': 'post_230', 'group': 5, 'label': 'Post_230', 'level': 1},
		   	 {'id': 'post_231', 'group': 2, 'label': 'Post_231', 'level': 1},
		   	 {'id': 'post_232', 'group': 5, 'label': 'Post_232', 'level': 1},
		   	 {'id': 'post_233', 'group': 3, 'label': 'Post_233', 'level': 1},
		   	 {'id': 'post_234', 'group': 2, 'label': 'Post_234', 'level': 1},
		   	 {'id': 'post_235', 'group': 10, 'label': 'Post_235', 'level': 1},
		   	 {'id': 'post_236', 'group': 8, 'label': 'Post_236', 'level': 1},
		   	 {'id': 'post_237', 'group': 7, 'label': 'Post_237', 'level': 1},
		   	 {'id': 'post_238', 'group': 6, 'label': 'Post_238', 'level': 1},
		   	 {'id': 'post_239', 'group': 9, 'label': 'Post_239', 'level': 1},
		   	 {'id': 'post_240', 'group': 3, 'label': 'Post_240', 'level': 1},
		   	 {'id': 'post_241', 'group': 10, 'label': 'Post_241', 'level': 1},
		   	 {'id': 'post_242', 'group': 2, 'label': 'Post_242', 'level': 1},
		   	 {'id': 'post_243', 'group': 5, 'label': 'Post_243', 'level': 1},
		   	 {'id': 'post_244', 'group': 5, 'label': 'Post_244', 'level': 1},
		   	 {'id': 'post_245', 'group': 8, 'label': 'Post_245', 'level': 1},
		   	 {'id': 'post_246', 'group': 7, 'label': 'Post_246', 'level': 1},
		   	 {'id': 'post_247', 'group': 1, 'label': 'Post_247', 'level': 1},
		   	 {'id': 'post_248', 'group': 3, 'label': 'Post_248', 'level': 1},
		   	 {'id': 'post_249', 'group': 5, 'label': 'Post_249', 'level': 1},
		   	 {'id': 'post_250', 'group': 6, 'label': 'Post_250', 'level': 1},
		   	 {'id': 'post_251', 'group': 6, 'label': 'Post_251', 'level': 1},
		   	 {'id': 'post_252', 'group': 8, 'label': 'Post_252', 'level': 1},
		   	 {'id': 'post_253', 'group': 5, 'label': 'Post_253', 'level': 1},
		   	 {'id': 'post_254', 'group': 5, 'label': 'Post_254', 'level': 1},
		   	 {'id': 'post_255', 'group': 2, 'label': 'Post_255', 'level': 1},
		   	 {'id': 'post_256', 'group': 7, 'label': 'Post_256', 'level': 1},
		   	 {'id': 'post_257', 'group': 3, 'label': 'Post_257', 'level': 1},
		   	 {'id': 'post_258', 'group': 6, 'label': 'Post_258', 'level': 1},
		   	 {'id': 'post_259', 'group': 10, 'label': 'Post_259', 'level': 1},
		   	 {'id': 'post_260', 'group': 1, 'label': 'Post_260', 'level': 1},
		   	 {'id': 'post_261', 'group': 5, 'label': 'Post_261', 'level': 1},
		   	 {'id': 'post_262', 'group': 8, 'label': 'Post_262', 'level': 1},
		   	 {'id': 'post_263', 'group': 1, 'label': 'Post_263', 'level': 1},
		   	 {'id': 'post_264', 'group': 1, 'label': 'Post_264', 'level': 1},
		   	 {'id': 'post_265', 'group': 8, 'label': 'Post_265', 'level': 1},
		   	 {'id': 'post_266', 'group': 5, 'label': 'Post_266', 'level': 1},
		   	 {'id': 'post_267', 'group': 4, 'label': 'Post_267', 'level': 1},
		   	 {'id': 'post_268', 'group': 10, 'label': 'Post_268', 'level': 1},
		   	 {'id': 'post_269', 'group': 2, 'label': 'Post_269', 'level': 1},
		   	 {'id': 'post_270', 'group': 6, 'label': 'Post_270', 'level': 1},
		   	 {'id': 'post_271', 'group': 3, 'label': 'Post_271', 'level': 1},
		   	 {'id': 'post_272', 'group': 6, 'label': 'Post_272', 'level': 1},
		   	 {'id': 'post_273', 'group': 6, 'label': 'Post_273', 'level': 1},
		   	 {'id': 'post_274', 'group': 5, 'label': 'Post_274', 'level': 1},
		   	 {'id': 'post_275', 'group': 4, 'label': 'Post_275', 'level': 1},
		   	 {'id': 'post_276', 'group': 4, 'label': 'Post_276', 'level': 1},
		   	 {'id': 'post_277', 'group': 8, 'label': 'Post_277', 'level': 1},
		   	 {'id': 'post_278', 'group': 7, 'label': 'Post_278', 'level': 1},
		   	 {'id': 'post_279', 'group': 7, 'label': 'Post_279', 'level': 1},
		   	 {'id': 'post_280', 'group': 1, 'label': 'Post_280', 'level': 1},
		   	 {'id': 'post_281', 'group': 7, 'label': 'Post_281', 'level': 1},
		   	 {'id': 'post_282', 'group': 5, 'label': 'Post_282', 'level': 1},
		   	 {'id': 'post_283', 'group': 4, 'label': 'Post_283', 'level': 1},
		   	 {'id': 'post_284', 'group': 5, 'label': 'Post_284', 'level': 1},
		   	 {'id': 'post_285', 'group': 5, 'label': 'Post_285', 'level': 1},
		   	 {'id': 'post_286', 'group': 7, 'label': 'Post_286', 'level': 1},
		   	 {'id': 'post_287', 'group': 7, 'label': 'Post_287', 'level': 1},
		   	 {'id': 'post_288', 'group': 10, 'label': 'Post_288', 'level': 1},
		   	 {'id': 'post_289', 'group': 3, 'label': 'Post_289', 'level': 1},
		   	 {'id': 'post_290', 'group': 7, 'label': 'Post_290', 'level': 1},
		   	 {'id': 'post_291', 'group': 1, 'label': 'Post_291', 'level': 1},
		   	 {'id': 'post_292', 'group': 2, 'label': 'Post_292', 'level': 1},
		   	 {'id': 'post_293', 'group': 7, 'label': 'Post_293', 'level': 1},
		   	 {'id': 'post_294', 'group': 6, 'label': 'Post_294', 'level': 1},
		   	 {'id': 'post_295', 'group': 8, 'label': 'Post_295', 'level': 1},
		   	 {'id': 'post_296', 'group': 5, 'label': 'Post_296', 'level': 1},
		   	 {'id': 'post_297', 'group': 3, 'label': 'Post_297', 'level': 1},
		   	 {'id': 'post_298', 'group': 6, 'label': 'Post_298', 'level': 1},
		   	 {'id': 'post_299', 'group': 5, 'label': 'Post_299', 'level': 1},
		   	 {'id': 'post_300', 'group': 4, 'label': 'Post_300', 'level': 1},
		   	 {'id': 'post_301', 'group': 3, 'label': 'Post_301', 'level': 1},
		   	 {'id': 'post_302', 'group': 6, 'label': 'Post_302', 'level': 1},
		   	 {'id': 'post_303', 'group': 5, 'label': 'Post_303', 'level': 1},
		   	 {'id': 'post_304', 'group': 2, 'label': 'Post_304', 'level': 1},
		   	 {'id': 'post_305', 'group': 4, 'label': 'Post_305', 'level': 1},
		   	 {'id': 'post_306', 'group': 6, 'label': 'Post_306', 'level': 1},
		   	 {'id': 'post_307', 'group': 6, 'label': 'Post_307', 'level': 1},
		   	 {'id': 'post_308', 'group': 1, 'label': 'Post_308', 'level': 1},
		   	 {'id': 'post_309', 'group': 8, 'label': 'Post_309', 'level': 1},
		   	 {'id': 'post_310', 'group': 1, 'label': 'Post_310', 'level': 1},
		   	 {'id': 'post_311', 'group': 5, 'label': 'Post_311', 'level': 1},
		   	 {'id': 'post_312', 'group': 2, 'label': 'Post_312', 'level': 1},
		   	 {'id': 'post_313', 'group': 8, 'label': 'Post_313', 'level': 1},
		   	 {'id': 'post_314', 'group': 9, 'label': 'Post_314', 'level': 1},
		   	 {'id': 'post_315', 'group': 6, 'label': 'Post_315', 'level': 1},
		   	 {'id': 'post_316', 'group': 9, 'label': 'Post_316', 'level': 1},
		   	 {'id': 'post_317', 'group': 9, 'label': 'Post_317', 'level': 1},
		   	 {'id': 'post_318', 'group': 9, 'label': 'Post_318', 'level': 1},
		   	 {'id': 'post_319', 'group': 3, 'label': 'Post_319', 'level': 1},
		   	 {'id': 'post_320', 'group': 2, 'label': 'Post_320', 'level': 1},
		   	 {'id': 'post_321', 'group': 4, 'label': 'Post_321', 'level': 1},
		   	 {'id': 'post_322', 'group': 9, 'label': 'Post_322', 'level': 1},
		   	 {'id': 'post_323', 'group': 10, 'label': 'Post_323', 'level': 1},
		   	 {'id': 'post_324', 'group': 9, 'label': 'Post_324', 'level': 1},
		   	 {'id': 'post_325', 'group': 3, 'label': 'Post_325', 'level': 1},
		   	 {'id': 'post_326', 'group': 4, 'label': 'Post_326', 'level': 1},
		   	 {'id': 'post_327', 'group': 8, 'label': 'Post_327', 'level': 1},
		   	 {'id': 'post_328', 'group': 10, 'label': 'Post_328', 'level': 1},
		   	 {'id': 'post_329', 'group': 7, 'label': 'Post_329', 'level': 1},
		   	 {'id': 'post_330', 'group': 8, 'label': 'Post_330', 'level': 1},
		   	 {'id': 'post_331', 'group': 7, 'label': 'Post_331', 'level': 1},
		   	 {'id': 'post_332', 'group': 2, 'label': 'Post_332', 'level': 1},
		   	 {'id': 'post_333', 'group': 7, 'label': 'Post_333', 'level': 1},
		   	 {'id': 'post_334', 'group': 5, 'label': 'Post_334', 'level': 1},
		   	 {'id': 'post_335', 'group': 4, 'label': 'Post_335', 'level': 1},
		   	 {'id': 'post_336', 'group': 10, 'label': 'Post_336', 'level': 1},
		   	 {'id': 'post_337', 'group': 7, 'label': 'Post_337', 'level': 1},
		   	 {'id': 'post_338', 'group': 5, 'label': 'Post_338', 'level': 1},
		   	 {'id': 'post_339', 'group': 5, 'label': 'Post_339', 'level': 1},
		   	 {'id': 'post_340', 'group': 2, 'label': 'Post_340', 'level': 1},
		   	 {'id': 'post_341', 'group': 3, 'label': 'Post_341', 'level': 1},
		   	 {'id': 'post_342', 'group': 7, 'label': 'Post_342', 'level': 1},
		   	 {'id': 'post_343', 'group': 10, 'label': 'Post_343', 'level': 1},
		   	 {'id': 'post_344', 'group': 5, 'label': 'Post_344', 'level': 1},
		   	 {'id': 'post_345', 'group': 1, 'label': 'Post_345', 'level': 1},
		   	 {'id': 'post_346', 'group': 3, 'label': 'Post_346', 'level': 1},
		   	 {'id': 'post_347', 'group': 8, 'label': 'Post_347', 'level': 1},
		   	 {'id': 'post_348', 'group': 9, 'label': 'Post_348', 'level': 1},
		   	 {'id': 'post_349', 'group': 7, 'label': 'Post_349', 'level': 1},
		   	 {'id': 'post_350', 'group': 4, 'label': 'Post_350', 'level': 1},
		   	 {'id': 'post_351', 'group': 9, 'label': 'Post_351', 'level': 1},
		   	 {'id': 'post_352', 'group': 1, 'label': 'Post_352', 'level': 1},
		   	 {'id': 'post_353', 'group': 3, 'label': 'Post_353', 'level': 1},
		   	 {'id': 'post_354', 'group': 3, 'label': 'Post_354', 'level': 1},
		   	 {'id': 'post_355', 'group': 1, 'label': 'Post_355', 'level': 1},
		   	 {'id': 'post_356', 'group': 9, 'label': 'Post_356', 'level': 1},
		   	 {'id': 'post_357', 'group': 9, 'label': 'Post_357', 'level': 1},
		   	 {'id': 'post_358', 'group': 1, 'label': 'Post_358', 'level': 1},
		   	 {'id': 'post_359', 'group': 8, 'label': 'Post_359', 'level': 1},
		   	 {'id': 'post_360', 'group': 4, 'label': 'Post_360', 'level': 1},
		   	 {'id': 'post_361', 'group': 2, 'label': 'Post_361', 'level': 1},
		   	 {'id': 'post_362', 'group': 10, 'label': 'Post_362', 'level': 1},
		   	 {'id': 'post_363', 'group': 2, 'label': 'Post_363', 'level': 1},
		   	 {'id': 'post_364', 'group': 8, 'label': 'Post_364', 'level': 1},
		   	 {'id': 'post_365', 'group': 1, 'label': 'Post_365', 'level': 1},
		   	 {'id': 'post_366', 'group': 6, 'label': 'Post_366', 'level': 1},
		   	 {'id': 'post_367', 'group': 9, 'label': 'Post_367', 'level': 1},
		   	 {'id': 'post_368', 'group': 9, 'label': 'Post_368', 'level': 1},
		   	 {'id': 'post_369', 'group': 6, 'label': 'Post_369', 'level': 1},
		   	 {'id': 'post_370', 'group': 7, 'label': 'Post_370', 'level': 1},
		   	 {'id': 'post_371', 'group': 9, 'label': 'Post_371', 'level': 1},
		   	 {'id': 'post_372', 'group': 9, 'label': 'Post_372', 'level': 1},
		   	 {'id': 'post_373', 'group': 4, 'label': 'Post_373', 'level': 1},
		   	 {'id': 'post_374', 'group': 1, 'label': 'Post_374', 'level': 1},
		   	 {'id': 'post_375', 'group': 7, 'label': 'Post_375', 'level': 1},
		   	 {'id': 'post_376', 'group': 9, 'label': 'Post_376', 'level': 1},
		   	 {'id': 'post_377', 'group': 6, 'label': 'Post_377', 'level': 1},
		   	 {'id': 'post_378', 'group': 3, 'label': 'Post_378', 'level': 1},
		   	 {'id': 'post_379', 'group': 5, 'label': 'Post_379', 'level': 1},
		   	 {'id': 'post_380', 'group': 5, 'label': 'Post_380', 'level': 1},
		   	 {'id': 'post_381', 'group': 7, 'label': 'Post_381', 'level': 1},
		   	 {'id': 'post_382', 'group': 1, 'label': 'Post_382', 'level': 1},
		   	 {'id': 'post_383', 'group': 5, 'label': 'Post_383', 'level': 1},
		   	 {'id': 'post_384', 'group': 8, 'label': 'Post_384', 'level': 1},
		   	 {'id': 'post_385', 'group': 3, 'label': 'Post_385', 'level': 1},
		   	 {'id': 'post_386', 'group': 1, 'label': 'Post_386', 'level': 1},
		   	 {'id': 'post_387', 'group': 3, 'label': 'Post_387', 'level': 1},
		   	 {'id': 'post_388', 'group': 7, 'label': 'Post_388', 'level': 1},
		   	 {'id': 'post_389', 'group': 3, 'label': 'Post_389', 'level': 1},
		   	 {'id': 'post_390', 'group': 2, 'label': 'Post_390', 'level': 1},
		   	 {'id': 'post_391', 'group': 3, 'label': 'Post_391', 'level': 1},
		   	 {'id': 'post_392', 'group': 10, 'label': 'Post_392', 'level': 1},
		   	 {'id': 'post_393', 'group': 4, 'label': 'Post_393', 'level': 1},
		   	 {'id': 'post_394', 'group': 10, 'label': 'Post_394', 'level': 1},
		   	 {'id': 'post_395', 'group': 6, 'label': 'Post_395', 'level': 1},
		   	 {'id': 'post_396', 'group': 4, 'label': 'Post_396', 'level': 1},
		   	 {'id': 'post_397', 'group': 10, 'label': 'Post_397', 'level': 1},
		   	 {'id': 'post_398', 'group': 8, 'label': 'Post_398', 'level': 1},
		   	 {'id': 'post_399', 'group': 10, 'label': 'Post_399', 'level': 1},
		   	 {'id': 'post_400', 'group': 6, 'label': 'Post_400', 'level': 1},
		   	 {'id': 'post_401', 'group': 8, 'label': 'Post_401', 'level': 1},
		   	 {'id': 'post_402', 'group': 6, 'label': 'Post_402', 'level': 1},
		   	 {'id': 'post_403', 'group': 2, 'label': 'Post_403', 'level': 1},
		   	 {'id': 'post_404', 'group': 5, 'label': 'Post_404', 'level': 1},
		   	 {'id': 'post_405', 'group': 7, 'label': 'Post_405', 'level': 1},
		   	 {'id': 'post_406', 'group': 3, 'label': 'Post_406', 'level': 1},
		   	 {'id': 'post_407', 'group': 2, 'label': 'Post_407', 'level': 1},
		   	 {'id': 'post_408', 'group': 8, 'label': 'Post_408', 'level': 1},
		   	 {'id': 'post_409', 'group': 7, 'label': 'Post_409', 'level': 1},
		   	 {'id': 'post_410', 'group': 5, 'label': 'Post_410', 'level': 1},
		   	 {'id': 'post_411', 'group': 5, 'label': 'Post_411', 'level': 1},
		   	 {'id': 'post_412', 'group': 7, 'label': 'Post_412', 'level': 1},
		   	 {'id': 'post_413', 'group': 7, 'label': 'Post_413', 'level': 1},
		   	 {'id': 'post_414', 'group': 4, 'label': 'Post_414', 'level': 1},
		   	 {'id': 'post_415', 'group': 7, 'label': 'Post_415', 'level': 1},
		   	 {'id': 'post_416', 'group': 1, 'label': 'Post_416', 'level': 1},
		   	 {'id': 'post_417', 'group': 4, 'label': 'Post_417', 'level': 1},
		   	 {'id': 'post_418', 'group': 3, 'label': 'Post_418', 'level': 1},
		   	 {'id': 'post_419', 'group': 1, 'label': 'Post_419', 'level': 1},
		   	 {'id': 'post_420', 'group': 3, 'label': 'Post_420', 'level': 1},
		   	 {'id': 'post_421', 'group': 7, 'label': 'Post_421', 'level': 1},
		   	 {'id': 'post_422', 'group': 2, 'label': 'Post_422', 'level': 1},
		   	 {'id': 'post_423', 'group': 7, 'label': 'Post_423', 'level': 1},
		   	 {'id': 'post_424', 'group': 8, 'label': 'Post_424', 'level': 1},
		   	 {'id': 'post_425', 'group': 4, 'label': 'Post_425', 'level': 1},
		   	 {'id': 'post_426', 'group': 10, 'label': 'Post_426', 'level': 1},
		   	 {'id': 'post_427', 'group': 10, 'label': 'Post_427', 'level': 1},
		   	 {'id': 'post_428', 'group': 8, 'label': 'Post_428', 'level': 1},
		   	 {'id': 'post_429', 'group': 3, 'label': 'Post_429', 'level': 1},
		   	 {'id': 'post_430', 'group': 3, 'label': 'Post_430', 'level': 1},
		   	 {'id': 'post_431', 'group': 7, 'label': 'Post_431', 'level': 1},
		   	 {'id': 'post_432', 'group': 6, 'label': 'Post_432', 'level': 1},
		   	 {'id': 'post_433', 'group': 4, 'label': 'Post_433', 'level': 1},
		   	 {'id': 'post_434', 'group': 1, 'label': 'Post_434', 'level': 1},
		   	 {'id': 'post_435', 'group': 8, 'label': 'Post_435', 'level': 1},
		   	 {'id': 'post_436', 'group': 9, 'label': 'Post_436', 'level': 1},
		   	 {'id': 'post_437', 'group': 10, 'label': 'Post_437', 'level': 1},
		   	 {'id': 'post_438', 'group': 3, 'label': 'Post_438', 'level': 1},
		   	 {'id': 'post_439', 'group': 9, 'label': 'Post_439', 'level': 1},
		   	 {'id': 'post_440', 'group': 2, 'label': 'Post_440', 'level': 1},
		   	 {'id': 'post_441', 'group': 7, 'label': 'Post_441', 'level': 1},
		   	 {'id': 'post_442', 'group': 5, 'label': 'Post_442', 'level': 1},
		   	 {'id': 'post_443', 'group': 9, 'label': 'Post_443', 'level': 1},
		   	 {'id': 'post_444', 'group': 10, 'label': 'Post_444', 'level': 1},
		   	 {'id': 'post_445', 'group': 10, 'label': 'Post_445', 'level': 1},
		   	 {'id': 'post_446', 'group': 3, 'label': 'Post_446', 'level': 1},
		   	 {'id': 'post_447', 'group': 3, 'label': 'Post_447', 'level': 1},
		   	 {'id': 'post_448', 'group': 3, 'label': 'Post_448', 'level': 1},
		   	 {'id': 'post_449', 'group': 2, 'label': 'Post_449', 'level': 1},
		   	 {'id': 'post_450', 'group': 5, 'label': 'Post_450', 'level': 1},
		   	 {'id': 'post_451', 'group': 9, 'label': 'Post_451', 'level': 1},
		   	 {'id': 'post_452', 'group': 1, 'label': 'Post_452', 'level': 1},
		   	 {'id': 'post_453', 'group': 8, 'label': 'Post_453', 'level': 1},
		   	 {'id': 'post_454', 'group': 4, 'label': 'Post_454', 'level': 1},
		   	 {'id': 'post_455', 'group': 1, 'label': 'Post_455', 'level': 1},
		   	 {'id': 'post_456', 'group': 1, 'label': 'Post_456', 'level': 1},
		   	 {'id': 'post_457', 'group': 2, 'label': 'Post_457', 'level': 1},
		   	 {'id': 'post_458', 'group': 3, 'label': 'Post_458', 'level': 1},
		   	 {'id': 'post_459', 'group': 9, 'label': 'Post_459', 'level': 1},
		   	 {'id': 'post_460', 'group': 3, 'label': 'Post_460', 'level': 1},
		   	 {'id': 'post_461', 'group': 5, 'label': 'Post_461', 'level': 1},
		   	 {'id': 'post_462', 'group': 8, 'label': 'Post_462', 'level': 1},
		   	 {'id': 'post_463', 'group': 1, 'label': 'Post_463', 'level': 1},
		   	 {'id': 'post_464', 'group': 1, 'label': 'Post_464', 'level': 1},
		   	 {'id': 'post_465', 'group': 7, 'label': 'Post_465', 'level': 1},
		   	 {'id': 'post_466', 'group': 4, 'label': 'Post_466', 'level': 1},
		   	 {'id': 'post_467', 'group': 1, 'label': 'Post_467', 'level': 1},
		   	 {'id': 'post_468', 'group': 4, 'label': 'Post_468', 'level': 1},
		   	 {'id': 'post_469', 'group': 4, 'label': 'Post_469', 'level': 1},
		   	 {'id': 'post_470', 'group': 9, 'label': 'Post_470', 'level': 1},
		   	 {'id': 'post_471', 'group': 2, 'label': 'Post_471', 'level': 1},
		   	 {'id': 'post_472', 'group': 7, 'label': 'Post_472', 'level': 1},
		   	 {'id': 'post_473', 'group': 4, 'label': 'Post_473', 'level': 1},
		   	 {'id': 'post_474', 'group': 2, 'label': 'Post_474', 'level': 1},
		   	 {'id': 'post_475', 'group': 1, 'label': 'Post_475', 'level': 1},
		   	 {'id': 'post_476', 'group': 1, 'label': 'Post_476', 'level': 1},
		   	 {'id': 'post_477', 'group': 9, 'label': 'Post_477', 'level': 1},
		   	 {'id': 'post_478', 'group': 3, 'label': 'Post_478', 'level': 1},
		   	 {'id': 'post_479', 'group': 5, 'label': 'Post_479', 'level': 1},
		   	 {'id': 'post_480', 'group': 5, 'label': 'Post_480', 'level': 1},
		   	 {'id': 'post_481', 'group': 9, 'label': 'Post_481', 'level': 1},
		   	 {'id': 'post_482', 'group': 8, 'label': 'Post_482', 'level': 1},
		   	 {'id': 'post_483', 'group': 3, 'label': 'Post_483', 'level': 1},
		   	 {'id': 'post_484', 'group': 7, 'label': 'Post_484', 'level': 1},
		   	 {'id': 'post_485', 'group': 4, 'label': 'Post_485', 'level': 1},
		   	 {'id': 'post_486', 'group': 6, 'label': 'Post_486', 'level': 1},
		   	 {'id': 'post_487', 'group': 5, 'label': 'Post_487', 'level': 1},
		   	 {'id': 'post_488', 'group': 2, 'label': 'Post_488', 'level': 1},
		   	 {'id': 'post_489', 'group': 2, 'label': 'Post_489', 'level': 1},
		   	 {'id': 'post_490', 'group': 3, 'label': 'Post_490', 'level': 1},
		   	 {'id': 'post_491', 'group': 4, 'label': 'Post_491', 'level': 1},
		   	 {'id': 'post_492', 'group': 2, 'label': 'Post_492', 'level': 1},
		   	 {'id': 'post_493', 'group': 2, 'label': 'Post_493', 'level': 1},
		   	 {'id': 'post_494', 'group': 5, 'label': 'Post_494', 'level': 1},
		   	 {'id': 'post_495', 'group': 4, 'label': 'Post_495', 'level': 1},
		   	 {'id': 'post_496', 'group': 5, 'label': 'Post_496', 'level': 1},
		   	 {'id': 'post_497', 'group': 5, 'label': 'Post_497', 'level': 1},
		   	 {'id': 'post_498', 'group': 8, 'label': 'Post_498', 'level': 1},
		   	 {'id': 'post_499', 'group': 3, 'label': 'Post_499', 'level': 1}]
		      /* var links = [
		      	{ target: "mammal", source: "dog" , strength: 3.0 },
		      	{ target: "bee", source: "cat" , strength: 3.0 }
		        /* { target: "mammal", source: "fox" , strength: 3.0 },
		     
		        { target: "insect", source: "ant" , strength: 0.7 },
		        { target: "insect", source: "bee" , strength: 0.7 },
		        { target: "fish"  , source: "carp", strength: 0.7 },
		        { target: "fish"  , source: "pike", strength: 0.7 },
		        { target: "cat"   , source: "elk" , strength: 0.1 },
		        { target: "carp"  , source: "ant" , strength: 0.1 },
		        { target: "elk"   , source: "bee" , strength: 0.1 },
		        { target: "dog"   , source: "cat" , strength: 0.1 },
		        { target: "fox"   , source: "ant" , strength: 0.1 },
		      	{ target: "pike"  , source: "cat" , strength: 0.1 } */
		      /* ]  */

		      var links = [{'target': 'post_290', 'source': 'post_430', 'strength': 3.0},
		   	   {'target': 'post_148', 'source': 'post_131', 'strength': 3.0},
		   	   {'target': 'post_121', 'source': 'post_221', 'strength': 3.0},
		   	   {'target': 'post_374', 'source': 'post_433', 'strength': 3.0},
		   	   {'target': 'post_314', 'source': 'post_409', 'strength': 3.0},
		   	   {'target': 'post_272', 'source': 'post_150', 'strength': 3.0},
		   	   {'target': 'post_147', 'source': 'post_303', 'strength': 3.0},
		   	   {'target': 'post_318', 'source': 'post_387', 'strength': 3.0},
		   	   {'target': 'post_71', 'source': 'post_30', 'strength': 3.0},
		   	   {'target': 'post_240', 'source': 'post_127', 'strength': 3.0},
		   	   {'target': 'post_370', 'source': 'post_41', 'strength': 3.0},
		   	   {'target': 'post_464', 'source': 'post_51', 'strength': 3.0},
		   	   {'target': 'post_8', 'source': 'post_220', 'strength': 3.0},
		   	   {'target': 'post_423', 'source': 'post_47', 'strength': 3.0},
		   	   {'target': 'post_141', 'source': 'post_277', 'strength': 3.0},
		   	   {'target': 'post_259', 'source': 'post_157', 'strength': 3.0},
		   	   {'target': 'post_426', 'source': 'post_391', 'strength': 3.0},
		   	   {'target': 'post_251', 'source': 'post_37', 'strength': 3.0},
		   	   {'target': 'post_78', 'source': 'post_387', 'strength': 3.0},
		   	   {'target': 'post_69', 'source': 'post_305', 'strength': 3.0},
		   	   {'target': 'post_128', 'source': 'post_23', 'strength': 3.0},
		   	   {'target': 'post_488', 'source': 'post_199', 'strength': 3.0},
		   	   {'target': 'post_175', 'source': 'post_118', 'strength': 3.0},
		   	   {'target': 'post_186', 'source': 'post_373', 'strength': 3.0},
		   	   {'target': 'post_59', 'source': 'post_423', 'strength': 3.0},
		   	   {'target': 'post_207', 'source': 'post_17', 'strength': 3.0},
		   	   {'target': 'post_343', 'source': 'post_495', 'strength': 3.0},
		   	   {'target': 'post_297', 'source': 'post_10', 'strength': 3.0},
		   	   {'target': 'post_314', 'source': 'post_219', 'strength': 3.0},
		   	   {'target': 'post_100', 'source': 'post_271', 'strength': 3.0},
		   	   {'target': 'post_274', 'source': 'post_310', 'strength': 3.0},
		   	   {'target': 'post_152', 'source': 'post_235', 'strength': 3.0},
		   	   {'target': 'post_244', 'source': 'post_379', 'strength': 3.0},
		   	   {'target': 'post_23', 'source': 'post_239', 'strength': 3.0},
		   	   {'target': 'post_151', 'source': 'post_298', 'strength': 3.0},
		   	   {'target': 'post_247', 'source': 'post_159', 'strength': 3.0},
		   	   {'target': 'post_454', 'source': 'post_496', 'strength': 3.0},
		   	   {'target': 'post_16', 'source': 'post_208', 'strength': 3.0},
		   	   {'target': 'post_357', 'source': 'post_123', 'strength': 3.0},
		   	   {'target': 'post_458', 'source': 'post_491', 'strength': 3.0},
		   	   {'target': 'post_24', 'source': 'post_237', 'strength': 3.0},
		   	   {'target': 'post_482', 'source': 'post_178', 'strength': 3.0},
		   	   {'target': 'post_265', 'source': 'post_92', 'strength': 3.0},
		   	   {'target': 'post_407', 'source': 'post_349', 'strength': 3.0},
		   	   {'target': 'post_319', 'source': 'post_237', 'strength': 3.0},
		   	   {'target': 'post_371', 'source': 'post_460', 'strength': 3.0},
		   	   {'target': 'post_158', 'source': 'post_114', 'strength': 3.0},
		   	   {'target': 'post_421', 'source': 'post_215', 'strength': 3.0},
		   	   {'target': 'post_207', 'source': 'post_299', 'strength': 3.0},
		   	   {'target': 'post_432', 'source': 'post_66', 'strength': 3.0},
		   	   {'target': 'post_98', 'source': 'post_33', 'strength': 3.0},
		   	   {'target': 'post_436', 'source': 'post_126', 'strength': 3.0},
		   	   {'target': 'post_484', 'source': 'post_457', 'strength': 3.0},
		   	   {'target': 'post_12', 'source': 'post_435', 'strength': 3.0},
		   	   {'target': 'post_139', 'source': 'post_222', 'strength': 3.0},
		   	   {'target': 'post_222', 'source': 'post_427', 'strength': 3.0},
		   	   {'target': 'post_442', 'source': 'post_237', 'strength': 3.0},
		   	   {'target': 'post_10', 'source': 'post_159', 'strength': 3.0},
		   	   {'target': 'post_298', 'source': 'post_123', 'strength': 3.0},
		   	   {'target': 'post_279', 'source': 'post_65', 'strength': 3.0},
		   	   {'target': 'post_271', 'source': 'post_151', 'strength': 3.0},
		   	   {'target': 'post_9', 'source': 'post_63', 'strength': 3.0},
		   	   {'target': 'post_499', 'source': 'post_44', 'strength': 3.0},
		   	   {'target': 'post_51', 'source': 'post_438', 'strength': 3.0},
		   	   {'target': 'post_393', 'source': 'post_441', 'strength': 3.0},
		   	   {'target': 'post_431', 'source': 'post_471', 'strength': 3.0},
		   	   {'target': 'post_125', 'source': 'post_119', 'strength': 3.0},
		   	   {'target': 'post_482', 'source': 'post_342', 'strength': 3.0},
		   	   {'target': 'post_187', 'source': 'post_89', 'strength': 3.0},
		   	   {'target': 'post_288', 'source': 'post_272', 'strength': 3.0},
		   	   {'target': 'post_87', 'source': 'post_189', 'strength': 3.0},
		   	   {'target': 'post_441', 'source': 'post_261', 'strength': 3.0},
		   	   {'target': 'post_90', 'source': 'post_338', 'strength': 3.0},
		   	   {'target': 'post_406', 'source': 'post_384', 'strength': 3.0},
		   	   {'target': 'post_180', 'source': 'post_77', 'strength': 3.0},
		   	   {'target': 'post_300', 'source': 'post_376', 'strength': 3.0},
		   	   {'target': 'post_436', 'source': 'post_226', 'strength': 3.0},
		   	   {'target': 'post_405', 'source': 'post_357', 'strength': 3.0},
		   	   {'target': 'post_269', 'source': 'post_387', 'strength': 3.0},
		   	   {'target': 'post_467', 'source': 'post_461', 'strength': 3.0},
		   	   {'target': 'post_278', 'source': 'post_254', 'strength': 3.0},
		   	   {'target': 'post_410', 'source': 'post_147', 'strength': 3.0},
		   	   {'target': 'post_444', 'source': 'post_193', 'strength': 3.0},
		   	   {'target': 'post_104', 'source': 'post_225', 'strength': 3.0},
		   	   {'target': 'post_169', 'source': 'post_374', 'strength': 3.0},
		   	   {'target': 'post_213', 'source': 'post_349', 'strength': 3.0},
		   	   {'target': 'post_29', 'source': 'post_190', 'strength': 3.0},
		   	   {'target': 'post_479', 'source': 'post_2', 'strength': 3.0},
		   	   {'target': 'post_373', 'source': 'post_156', 'strength': 3.0},
		   	   {'target': 'post_4', 'source': 'post_97', 'strength': 3.0},
		   	   {'target': 'post_346', 'source': 'post_239', 'strength': 3.0},
		   	   {'target': 'post_292', 'source': 'post_395', 'strength': 3.0},
		   	   {'target': 'post_256', 'source': 'post_178', 'strength': 3.0},
		   	   {'target': 'post_464', 'source': 'post_17', 'strength': 3.0},
		   	   {'target': 'post_206', 'source': 'post_120', 'strength': 3.0},
		   	   {'target': 'post_236', 'source': 'post_488', 'strength': 3.0},
		   	   {'target': 'post_122', 'source': 'post_250', 'strength': 3.0},
		   	   {'target': 'post_109', 'source': 'post_7', 'strength': 3.0},
		   	   {'target': 'post_268', 'source': 'post_432', 'strength': 3.0},
		   	   {'target': 'post_473', 'source': 'post_283', 'strength': 3.0},
		   	   {'target': 'post_154', 'source': 'post_234', 'strength': 3.0},
		   	   {'target': 'post_250', 'source': 'post_243', 'strength': 3.0},
		   	   {'target': 'post_77', 'source': 'post_190', 'strength': 3.0},
		   	   {'target': 'post_352', 'source': 'post_217', 'strength': 3.0},
		   	   {'target': 'post_120', 'source': 'post_376', 'strength': 3.0},
		   	   {'target': 'post_148', 'source': 'post_136', 'strength': 3.0},
		   	   {'target': 'post_442', 'source': 'post_35', 'strength': 3.0},
		   	   {'target': 'post_445', 'source': 'post_141', 'strength': 3.0},
		   	   {'target': 'post_230', 'source': 'post_386', 'strength': 3.0},
		   	   {'target': 'post_377', 'source': 'post_285', 'strength': 3.0},
		   	   {'target': 'post_227', 'source': 'post_382', 'strength': 3.0},
		   	   {'target': 'post_373', 'source': 'post_344', 'strength': 3.0},
		   	   {'target': 'post_391', 'source': 'post_415', 'strength': 3.0},
		   	   {'target': 'post_476', 'source': 'post_299', 'strength': 3.0},
		   	   {'target': 'post_491', 'source': 'post_336', 'strength': 3.0},
		   	   {'target': 'post_85', 'source': 'post_69', 'strength': 3.0},
		   	   {'target': 'post_369', 'source': 'post_332', 'strength': 3.0},
		   	   {'target': 'post_204', 'source': 'post_219', 'strength': 3.0},
		   	   {'target': 'post_214', 'source': 'post_476', 'strength': 3.0},
		   	   {'target': 'post_411', 'source': 'post_382', 'strength': 3.0},
		   	   {'target': 'post_249', 'source': 'post_432', 'strength': 3.0},
		   	   {'target': 'post_300', 'source': 'post_215', 'strength': 3.0},
		   	   {'target': 'post_115', 'source': 'post_253', 'strength': 3.0},
		   	   {'target': 'post_468', 'source': 'post_266', 'strength': 3.0},
		   	   {'target': 'post_399', 'source': 'post_490', 'strength': 3.0},
		   	   {'target': 'post_143', 'source': 'post_106', 'strength': 3.0},
		   	   {'target': 'post_19', 'source': 'post_239', 'strength': 3.0},
		   	   {'target': 'post_309', 'source': 'post_289', 'strength': 3.0},
		   	   {'target': 'post_207', 'source': 'post_261', 'strength': 3.0},
		   	   {'target': 'post_488', 'source': 'post_46', 'strength': 3.0},
		   	   {'target': 'post_493', 'source': 'post_190', 'strength': 3.0},
		   	   {'target': 'post_404', 'source': 'post_309', 'strength': 3.0},
		   	   {'target': 'post_132', 'source': 'post_217', 'strength': 3.0},
		   	   {'target': 'post_480', 'source': 'post_171', 'strength': 3.0},
		   	   {'target': 'post_197', 'source': 'post_260', 'strength': 3.0},
		   	   {'target': 'post_357', 'source': 'post_397', 'strength': 3.0},
		   	   {'target': 'post_355', 'source': 'post_288', 'strength': 3.0},
		   	   {'target': 'post_440', 'source': 'post_16', 'strength': 3.0},
		   	   {'target': 'post_176', 'source': 'post_16', 'strength': 3.0},
		   	   {'target': 'post_360', 'source': 'post_111', 'strength': 3.0},
		   	   {'target': 'post_97', 'source': 'post_65', 'strength': 3.0},
		   	   {'target': 'post_475', 'source': 'post_67', 'strength': 3.0},
		   	   {'target': 'post_284', 'source': 'post_29', 'strength': 3.0},
		   	   {'target': 'post_191', 'source': 'post_289', 'strength': 3.0},
		   	   {'target': 'post_417', 'source': 'post_157', 'strength': 3.0},
		   	   {'target': 'post_63', 'source': 'post_499', 'strength': 3.0},
		   	   {'target': 'post_211', 'source': 'post_63', 'strength': 3.0},
		   	   {'target': 'post_272', 'source': 'post_2', 'strength': 3.0},
		   	   {'target': 'post_415', 'source': 'post_153', 'strength': 3.0},
		   	   {'target': 'post_66', 'source': 'post_130', 'strength': 3.0},
		   	   {'target': 'post_385', 'source': 'post_270', 'strength': 3.0},
		   	   {'target': 'post_19', 'source': 'post_174', 'strength': 3.0},
		   	   {'target': 'post_101', 'source': 'post_219', 'strength': 3.0},
		   	   {'target': 'post_155', 'source': 'post_97', 'strength': 3.0},
		   	   {'target': 'post_384', 'source': 'post_329', 'strength': 3.0},
		   	   {'target': 'post_220', 'source': 'post_192', 'strength': 3.0},
		   	   {'target': 'post_233', 'source': 'post_258', 'strength': 3.0},
		   	   {'target': 'post_157', 'source': 'post_27', 'strength': 3.0},
		   	   {'target': 'post_54', 'source': 'post_178', 'strength': 3.0},
		   	   {'target': 'post_17', 'source': 'post_478', 'strength': 3.0},
		   	   {'target': 'post_495', 'source': 'post_290', 'strength': 3.0},
		   	   {'target': 'post_386', 'source': 'post_134', 'strength': 3.0},
		   	   {'target': 'post_173', 'source': 'post_65', 'strength': 3.0},
		   	   {'target': 'post_160', 'source': 'post_417', 'strength': 3.0},
		   	   {'target': 'post_327', 'source': 'post_450', 'strength': 3.0},
		   	   {'target': 'post_280', 'source': 'post_380', 'strength': 3.0},
		   	   {'target': 'post_464', 'source': 'post_375', 'strength': 3.0},
		   	   {'target': 'post_330', 'source': 'post_446', 'strength': 3.0},
		   	   {'target': 'post_463', 'source': 'post_452', 'strength': 3.0},
		   	   {'target': 'post_268', 'source': 'post_339', 'strength': 3.0},
		   	   {'target': 'post_101', 'source': 'post_195', 'strength': 3.0},
		   	   {'target': 'post_387', 'source': 'post_148', 'strength': 3.0},
		   	   {'target': 'post_16', 'source': 'post_85', 'strength': 3.0},
		   	   {'target': 'post_175', 'source': 'post_173', 'strength': 3.0},
		   	   {'target': 'post_420', 'source': 'post_325', 'strength': 3.0},
		   	   {'target': 'post_41', 'source': 'post_468', 'strength': 3.0},
		   	   {'target': 'post_292', 'source': 'post_140', 'strength': 3.0},
		   	   {'target': 'post_286', 'source': 'post_151', 'strength': 3.0},
		   	   {'target': 'post_105', 'source': 'post_77', 'strength': 3.0},
		   	   {'target': 'post_335', 'source': 'post_415', 'strength': 3.0},
		   	   {'target': 'post_381', 'source': 'post_440', 'strength': 3.0},
		   	   {'target': 'post_80', 'source': 'post_288', 'strength': 3.0},
		   	   {'target': 'post_308', 'source': 'post_167', 'strength': 3.0},
		   	   {'target': 'post_127', 'source': 'post_186', 'strength': 3.0},
		   	   {'target': 'post_227', 'source': 'post_92', 'strength': 3.0},
		   	   {'target': 'post_421', 'source': 'post_444', 'strength': 3.0},
		   	   {'target': 'post_198', 'source': 'post_113', 'strength': 3.0},
		   	   {'target': 'post_193', 'source': 'post_416', 'strength': 3.0},
		   	   {'target': 'post_176', 'source': 'post_72', 'strength': 3.0},
		   	   {'target': 'post_498', 'source': 'post_166', 'strength': 3.0},
		   	   {'target': 'post_208', 'source': 'post_412', 'strength': 3.0},
		   	   {'target': 'post_275', 'source': 'post_462', 'strength': 3.0},
		   	   {'target': 'post_221', 'source': 'post_372', 'strength': 3.0},
		   	   {'target': 'post_275', 'source': 'post_219', 'strength': 3.0},
		   	   {'target': 'post_239', 'source': 'post_420', 'strength': 3.0},
		   	   {'target': 'post_459', 'source': 'post_230', 'strength': 3.0},
		   	   // {'target': 'post_459', 'source': 'post_124', 'strength': 3.0},
		   	   // {'target': 'post_294', 'source': 'post_349', 'strength': 3.0},
		   	   // {'target': 'post_220', 'source': 'post_172', 'strength': 3.0},
		   	   // {'target': 'post_49', 'source': 'post_69', 'strength': 3.0},
		   	   // {'target': 'post_443', 'source': 'post_437', 'strength': 3.0},
		   	   // {'target': 'post_493', 'source': 'post_331', 'strength': 3.0},
		   	   // {'target': 'post_363', 'source': 'post_462', 'strength': 3.0},
		   	   // {'target': 'post_282', 'source': 'post_33', 'strength': 3.0},
		   	   // {'target': 'post_36', 'source': 'post_394', 'strength': 3.0},
		   	   // {'target': 'post_249', 'source': 'post_201', 'strength': 3.0},
		   	   // {'target': 'post_349', 'source': 'post_21', 'strength': 3.0},
		   	   // {'target': 'post_160', 'source': 'post_308', 'strength': 3.0},
		   	   // {'target': 'post_494', 'source': 'post_80', 'strength': 3.0},
		   	   // {'target': 'post_256', 'source': 'post_203', 'strength': 3.0},
		   	   // {'target': 'post_64', 'source': 'post_310', 'strength': 3.0},
		   	   // {'target': 'post_208', 'source': 'post_286', 'strength': 3.0},
		   	   // {'target': 'post_19', 'source': 'post_362', 'strength': 3.0},
		   	   // {'target': 'post_239', 'source': 'post_66', 'strength': 3.0},
		   	   // {'target': 'post_59', 'source': 'post_184', 'strength': 3.0},
		   	   // {'target': 'post_49', 'source': 'post_179', 'strength': 3.0},
		   	   // {'target': 'post_149', 'source': 'post_496', 'strength': 3.0},
		   	   // {'target': 'post_145', 'source': 'post_124', 'strength': 3.0},
		   	   // {'target': 'post_50', 'source': 'post_402', 'strength': 3.0},
		   	   // {'target': 'post_5', 'source': 'post_118', 'strength': 3.0},
		   	   // {'target': 'post_222', 'source': 'post_409', 'strength': 3.0},
		   	   // {'target': 'post_47', 'source': 'post_132', 'strength': 3.0},
		   	   // {'target': 'post_404', 'source': 'post_197', 'strength': 3.0},
		   	   // {'target': 'post_104', 'source': 'post_153', 'strength': 3.0},
		   	   // {'target': 'post_207', 'source': 'post_108', 'strength': 3.0},
		   	   // {'target': 'post_194', 'source': 'post_478', 'strength': 3.0},
		   	   // {'target': 'post_15', 'source': 'post_79', 'strength': 3.0},
		   	   // {'target': 'post_264', 'source': 'post_408', 'strength': 3.0},
		   	   // {'target': 'post_455', 'source': 'post_390', 'strength': 3.0},
		   	   // {'target': 'post_460', 'source': 'post_283', 'strength': 3.0},
		   	   // {'target': 'post_350', 'source': 'post_250', 'strength': 3.0},
		   	   // {'target': 'post_302', 'source': 'post_485', 'strength': 3.0},
		   	   // {'target': 'post_28', 'source': 'post_104', 'strength': 3.0},
		   	   // {'target': 'post_421', 'source': 'post_298', 'strength': 3.0},
		   	   // {'target': 'post_250', 'source': 'post_430', 'strength': 3.0},
		   	   // {'target': 'post_341', 'source': 'post_70', 'strength': 3.0},
		   	   // {'target': 'post_443', 'source': 'post_78', 'strength': 3.0},
		   	   // {'target': 'post_392', 'source': 'post_452', 'strength': 3.0},
		   	   // {'target': 'post_232', 'source': 'post_406', 'strength': 3.0},
		   	   // {'target': 'post_427', 'source': 'post_169', 'strength': 3.0},
		   	   // {'target': 'post_419', 'source': 'post_399', 'strength': 3.0},
		   	   // {'target': 'post_14', 'source': 'post_297', 'strength': 3.0},
		   	   // {'target': 'post_61', 'source': 'post_388', 'strength': 3.0},
		   	   // {'target': 'post_488', 'source': 'post_373', 'strength': 3.0},
		   	   // {'target': 'post_151', 'source': 'post_417', 'strength': 3.0},
		   	   // {'target': 'post_477', 'source': 'post_170', 'strength': 3.0},
		   	   // {'target': 'post_336', 'source': 'post_82', 'strength': 3.0},
		   	   // {'target': 'post_94', 'source': 'post_245', 'strength': 3.0},
		   	   // {'target': 'post_281', 'source': 'post_367', 'strength': 3.0},
		   	   // {'target': 'post_371', 'source': 'post_395', 'strength': 3.0},
		   	   // {'target': 'post_426', 'source': 'post_224', 'strength': 3.0},
		   	   // {'target': 'post_498', 'source': 'post_435', 'strength': 3.0},
		   	   // {'target': 'post_109', 'source': 'post_472', 'strength': 3.0},
		   	   // {'target': 'post_240', 'source': 'post_242', 'strength': 3.0},
		   	   // {'target': 'post_364', 'source': 'post_202', 'strength': 3.0},
		   	   // {'target': 'post_336', 'source': 'post_219', 'strength': 3.0},
		   	   // {'target': 'post_428', 'source': 'post_7', 'strength': 3.0},
		   	   // {'target': 'post_50', 'source': 'post_426', 'strength': 3.0},
		   	   // {'target': 'post_376', 'source': 'post_174', 'strength': 3.0},
		   	   // {'target': 'post_204', 'source': 'post_338', 'strength': 3.0},
		   	   // {'target': 'post_439', 'source': 'post_3', 'strength': 3.0},
		   	   // {'target': 'post_342', 'source': 'post_115', 'strength': 3.0},
		   	   // {'target': 'post_297', 'source': 'post_461', 'strength': 3.0},
		   	   // {'target': 'post_171', 'source': 'post_432', 'strength': 3.0},
		   	   // {'target': 'post_9', 'source': 'post_140', 'strength': 3.0},
		   	   // {'target': 'post_78', 'source': 'post_370', 'strength': 3.0},
		   	   // {'target': 'post_435', 'source': 'post_122', 'strength': 3.0},
		   	   // {'target': 'post_93', 'source': 'post_335', 'strength': 3.0},
		   	   // {'target': 'post_477', 'source': 'post_3', 'strength': 3.0},
		   	   // {'target': 'post_216', 'source': 'post_254', 'strength': 3.0},
		   	   // {'target': 'post_134', 'source': 'post_263', 'strength': 3.0},
		   	   // {'target': 'post_120', 'source': 'post_187', 'strength': 3.0},
		   	   // {'target': 'post_494', 'source': 'post_35', 'strength': 3.0},
		   	   // {'target': 'post_432', 'source': 'post_129', 'strength': 3.0},
		   	   // {'target': 'post_268', 'source': 'post_156', 'strength': 3.0},
		   	   // {'target': 'post_99', 'source': 'post_138', 'strength': 3.0},
		   	   // {'target': 'post_401', 'source': 'post_40', 'strength': 3.0},
		   	   // {'target': 'post_164', 'source': 'post_60', 'strength': 3.0},
		   	   // {'target': 'post_37', 'source': 'post_457', 'strength': 3.0},
		   	   // {'target': 'post_38', 'source': 'post_32', 'strength': 3.0},
		   	   // {'target': 'post_303', 'source': 'post_255', 'strength': 3.0},
		   	   // {'target': 'post_150', 'source': 'post_204', 'strength': 3.0},
		   	   // {'target': 'post_231', 'source': 'post_66', 'strength': 3.0},
		   	   // {'target': 'post_240', 'source': 'post_496', 'strength': 3.0},
		   	   // {'target': 'post_415', 'source': 'post_47', 'strength': 3.0},
		   	   // {'target': 'post_465', 'source': 'post_429', 'strength': 3.0},
		   	   // {'target': 'post_358', 'source': 'post_466', 'strength': 3.0},
		   	   // {'target': 'post_180', 'source': 'post_5', 'strength': 3.0},
		   	   // {'target': 'post_252', 'source': 'post_1', 'strength': 3.0},
		   	   // {'target': 'post_311', 'source': 'post_377', 'strength': 3.0},
		   	   // {'target': 'post_110', 'source': 'post_230', 'strength': 3.0},
		   	   // {'target': 'post_359', 'source': 'post_302', 'strength': 3.0},
		   	   // {'target': 'post_418', 'source': 'post_215', 'strength': 3.0},
		   	   // {'target': 'post_431', 'source': 'post_298', 'strength': 3.0},
		   	   // {'target': 'post_457', 'source': 'post_182', 'strength': 3.0},
		   	   // {'target': 'post_183', 'source': 'post_447', 'strength': 3.0},
		   	   // {'target': 'post_190', 'source': 'post_491', 'strength': 3.0},
		   	   // {'target': 'post_399', 'source': 'post_401', 'strength': 3.0},
		   	   // {'target': 'post_113', 'source': 'post_242', 'strength': 3.0},
		   	   // {'target': 'post_336', 'source': 'post_401', 'strength': 3.0},
		   	   // {'target': 'post_423', 'source': 'post_173', 'strength': 3.0},
		   	   // {'target': 'post_45', 'source': 'post_40', 'strength': 3.0},
		   	   // {'target': 'post_28', 'source': 'post_261', 'strength': 3.0},
		   	   // {'target': 'post_361', 'source': 'post_326', 'strength': 3.0},
		   	   // {'target': 'post_292', 'source': 'post_416', 'strength': 3.0},
		   	   // {'target': 'post_207', 'source': 'post_429', 'strength': 3.0},
		   	   // {'target': 'post_368', 'source': 'post_353', 'strength': 3.0},
		   	   // {'target': 'post_420', 'source': 'post_479', 'strength': 3.0},
		   	   // {'target': 'post_24', 'source': 'post_449', 'strength': 3.0},
		   	   // {'target': 'post_242', 'source': 'post_268', 'strength': 3.0},
		   	   // {'target': 'post_427', 'source': 'post_460', 'strength': 3.0},
		   	   // {'target': 'post_384', 'source': 'post_217', 'strength': 3.0},
		   	   // {'target': 'post_368', 'source': 'post_108', 'strength': 3.0},
		   	   // {'target': 'post_198', 'source': 'post_7', 'strength': 3.0},
		   	   // {'target': 'post_396', 'source': 'post_401', 'strength': 3.0},
		   	   // {'target': 'post_233', 'source': 'post_244', 'strength': 3.0},
		   	   // {'target': 'post_322', 'source': 'post_317', 'strength': 3.0},
		   	   // {'target': 'post_431', 'source': 'post_16', 'strength': 3.0},
		   	   // {'target': 'post_165', 'source': 'post_29', 'strength': 3.0},
		   	   // {'target': 'post_149', 'source': 'post_125', 'strength': 3.0},
		   	   // {'target': 'post_453', 'source': 'post_395', 'strength': 3.0},
		   	   // {'target': 'post_245', 'source': 'post_219', 'strength': 3.0},
		   	   // {'target': 'post_437', 'source': 'post_10', 'strength': 3.0},
		   	   // {'target': 'post_315', 'source': 'post_417', 'strength': 3.0},
		   	   // {'target': 'post_124', 'source': 'post_383', 'strength': 3.0},
		   	   // {'target': 'post_402', 'source': 'post_141', 'strength': 3.0},
		   	   // {'target': 'post_465', 'source': 'post_192', 'strength': 3.0},
		   	   // {'target': 'post_499', 'source': 'post_169', 'strength': 3.0},
		   	   // {'target': 'post_328', 'source': 'post_280', 'strength': 3.0},
		   	   // {'target': 'post_408', 'source': 'post_376', 'strength': 3.0},
		   	   // {'target': 'post_171', 'source': 'post_195', 'strength': 3.0},
		   	   // {'target': 'post_160', 'source': 'post_17', 'strength': 3.0},
		   	   // {'target': 'post_359', 'source': 'post_74', 'strength': 3.0},
		   	   // {'target': 'post_316', 'source': 'post_24', 'strength': 3.0},
		   	   // {'target': 'post_57', 'source': 'post_216', 'strength': 3.0},
		   	   // {'target': 'post_64', 'source': 'post_280', 'strength': 3.0},
		   	   // {'target': 'post_264', 'source': 'post_361', 'strength': 3.0},
		   	   // {'target': 'post_186', 'source': 'post_85', 'strength': 3.0},
		   	   // {'target': 'post_87', 'source': 'post_265', 'strength': 3.0},
		   	   // {'target': 'post_425', 'source': 'post_262', 'strength': 3.0},
		   	   // {'target': 'post_230', 'source': 'post_14', 'strength': 3.0},
		   	   // {'target': 'post_457', 'source': 'post_327', 'strength': 3.0},
		   	   // {'target': 'post_190', 'source': 'post_308', 'strength': 3.0},
		   	   // {'target': 'post_434', 'source': 'post_264', 'strength': 3.0},
		   	   // {'target': 'post_168', 'source': 'post_322', 'strength': 3.0},
		   	   // {'target': 'post_260', 'source': 'post_252', 'strength': 3.0},
		   	   // {'target': 'post_267', 'source': 'post_487', 'strength': 3.0},
		   	   // {'target': 'post_448', 'source': 'post_240', 'strength': 3.0},
		   	   // {'target': 'post_385', 'source': 'post_97', 'strength': 3.0},
		   	   // {'target': 'post_212', 'source': 'post_38', 'strength': 3.0},
		   	   // {'target': 'post_474', 'source': 'post_380', 'strength': 3.0},
		   	   // {'target': 'post_357', 'source': 'post_350', 'strength': 3.0},
		   	   // {'target': 'post_369', 'source': 'post_312', 'strength': 3.0},
		   	   // {'target': 'post_75', 'source': 'post_438', 'strength': 3.0},
		   	   // {'target': 'post_17', 'source': 'post_123', 'strength': 3.0},
		   	   // {'target': 'post_426', 'source': 'post_382', 'strength': 3.0},
		   	   // {'target': 'post_52', 'source': 'post_498', 'strength': 3.0},
		   	   // {'target': 'post_280', 'source': 'post_396', 'strength': 3.0},
		   	   // {'target': 'post_481', 'source': 'post_2', 'strength': 3.0},
		   	   // {'target': 'post_178', 'source': 'post_290', 'strength': 3.0},
		   	   // {'target': 'post_487', 'source': 'post_52', 'strength': 3.0},
		   	   // {'target': 'post_492', 'source': 'post_443', 'strength': 3.0},
		   	   // {'target': 'post_435', 'source': 'post_232', 'strength': 3.0},
		   	   // {'target': 'post_149', 'source': 'post_59', 'strength': 3.0},
		   	   // {'target': 'post_194', 'source': 'post_321', 'strength': 3.0},
		   	   // {'target': 'post_137', 'source': 'post_318', 'strength': 3.0},
		   	   // {'target': 'post_190', 'source': 'post_349', 'strength': 3.0},
		   	   // {'target': 'post_471', 'source': 'post_149', 'strength': 3.0},
		   	   // {'target': 'post_418', 'source': 'post_292', 'strength': 3.0},
		   	   // {'target': 'post_414', 'source': 'post_397', 'strength': 3.0},
		   	   // {'target': 'post_484', 'source': 'post_157', 'strength': 3.0},
		   	   // {'target': 'post_258', 'source': 'post_339', 'strength': 3.0},
		   	   // {'target': 'post_333', 'source': 'post_319', 'strength': 3.0},
		   	   // {'target': 'post_46', 'source': 'post_42', 'strength': 3.0},
		   	   // {'target': 'post_168', 'source': 'post_397', 'strength': 3.0},
		   	   // {'target': 'post_36', 'source': 'post_344', 'strength': 3.0},
		   	   // {'target': 'post_86', 'source': 'post_158', 'strength': 3.0},
		   	   // {'target': 'post_37', 'source': 'post_390', 'strength': 3.0},
		   	   // {'target': 'post_269', 'source': 'post_195', 'strength': 3.0},
		   	   // {'target': 'post_178', 'source': 'post_473', 'strength': 3.0},
		   	   // {'target': 'post_9', 'source': 'post_127', 'strength': 3.0},
		   	   // {'target': 'post_243', 'source': 'post_157', 'strength': 3.0},
		   	   // {'target': 'post_371', 'source': 'post_42', 'strength': 3.0},
		   	   // {'target': 'post_188', 'source': 'post_74', 'strength': 3.0},
		   	   // {'target': 'post_193', 'source': 'post_195', 'strength': 3.0},
		   	   // {'target': 'post_291', 'source': 'post_217', 'strength': 3.0},
		   	   // {'target': 'post_215', 'source': 'post_185', 'strength': 3.0},
		   	   // {'target': 'post_211', 'source': 'post_327', 'strength': 3.0},
		   	   // {'target': 'post_284', 'source': 'post_68', 'strength': 3.0},
		   	   // {'target': 'post_406', 'source': 'post_303', 'strength': 3.0},
		   	   // {'target': 'post_208', 'source': 'post_191', 'strength': 3.0},
		   	   // {'target': 'post_469', 'source': 'post_288', 'strength': 3.0},
		   	   // {'target': 'post_158', 'source': 'post_35', 'strength': 3.0},
		   	   // {'target': 'post_335', 'source': 'post_210', 'strength': 3.0},
		   	   // {'target': 'post_437', 'source': 'post_483', 'strength': 3.0},
		   	   // {'target': 'post_142', 'source': 'post_435', 'strength': 3.0},
		   	   // {'target': 'post_123', 'source': 'post_336', 'strength': 3.0},
		   	   // {'target': 'post_447', 'source': 'post_113', 'strength': 3.0},
		   	   // {'target': 'post_458', 'source': 'post_215', 'strength': 3.0},
		   	   // {'target': 'post_85', 'source': 'post_220', 'strength': 3.0},
		   	   // {'target': 'post_76', 'source': 'post_286', 'strength': 3.0},
		   	   // {'target': 'post_423', 'source': 'post_293', 'strength': 3.0},
		   	   // {'target': 'post_382', 'source': 'post_102', 'strength': 3.0},
		   	   // {'target': 'post_342', 'source': 'post_396', 'strength': 3.0},
		   	   // {'target': 'post_415', 'source': 'post_357', 'strength': 3.0},
		   	   // {'target': 'post_90', 'source': 'post_486', 'strength': 3.0},
		   	   // {'target': 'post_406', 'source': 'post_67', 'strength': 3.0},
		   	   // {'target': 'post_470', 'source': 'post_43', 'strength': 3.0},
		   	   // {'target': 'post_17', 'source': 'post_150', 'strength': 3.0},
		   	   // {'target': 'post_171', 'source': 'post_299', 'strength': 3.0},
		   	   // {'target': 'post_416', 'source': 'post_170', 'strength': 3.0},
		   	   // {'target': 'post_228', 'source': 'post_472', 'strength': 3.0},
		   	   // {'target': 'post_155', 'source': 'post_210', 'strength': 3.0},
		   	   // {'target': 'post_386', 'source': 'post_300', 'strength': 3.0},
		   	   // {'target': 'post_325', 'source': 'post_189', 'strength': 3.0},
		   	   // {'target': 'post_446', 'source': 'post_468', 'strength': 3.0},
		   	   // {'target': 'post_227', 'source': 'post_36', 'strength': 3.0},
		   	   // {'target': 'post_373', 'source': 'post_312', 'strength': 3.0},
		   	   // {'target': 'post_281', 'source': 'post_79', 'strength': 3.0},
		   	   // {'target': 'post_53', 'source': 'post_262', 'strength': 3.0},
		   	   // {'target': 'post_464', 'source': 'post_4', 'strength': 3.0},
		   	   // {'target': 'post_123', 'source': 'post_386', 'strength': 3.0},
		   	   // {'target': 'post_213', 'source': 'post_497', 'strength': 3.0},
		   	   // {'target': 'post_53', 'source': 'post_380', 'strength': 3.0},
		   	   // {'target': 'post_424', 'source': 'post_117', 'strength': 3.0},
		   	   // {'target': 'post_419', 'source': 'post_239', 'strength': 3.0},
		   	   // {'target': 'post_284', 'source': 'post_36', 'strength': 3.0},
		   	   // {'target': 'post_393', 'source': 'post_289', 'strength': 3.0},
		   	   // {'target': 'post_375', 'source': 'post_353', 'strength': 3.0},
		   	   // {'target': 'post_143', 'source': 'post_355', 'strength': 3.0},
		   	   // {'target': 'post_304', 'source': 'post_109', 'strength': 3.0},
		   	   // {'target': 'post_402', 'source': 'post_398', 'strength': 3.0},
		   	   // {'target': 'post_479', 'source': 'post_254', 'strength': 3.0},
		   	   // {'target': 'post_499', 'source': 'post_313', 'strength': 3.0},
		   	   // {'target': 'post_110', 'source': 'post_446', 'strength': 3.0},
		   	   // {'target': 'post_496', 'source': 'post_346', 'strength': 3.0},
		   	   // {'target': 'post_1', 'source': 'post_6', 'strength': 3.0},
		   	   // {'target': 'post_290', 'source': 'post_471', 'strength': 3.0},
		   	   // {'target': 'post_396', 'source': 'post_92', 'strength': 3.0},
		   	   // {'target': 'post_375', 'source': 'post_126', 'strength': 3.0},
		   	   // {'target': 'post_30', 'source': 'post_209', 'strength': 3.0},
		   	   // {'target': 'post_159', 'source': 'post_457', 'strength': 3.0},
		   	   // {'target': 'post_133', 'source': 'post_341', 'strength': 3.0},
		   	   // {'target': 'post_428', 'source': 'post_160', 'strength': 3.0},
		   	   // {'target': 'post_24', 'source': 'post_112', 'strength': 3.0},
		   	   // {'target': 'post_458', 'source': 'post_275', 'strength': 3.0},
		   	   // {'target': 'post_258', 'source': 'post_352', 'strength': 3.0},
		   	   // {'target': 'post_196', 'source': 'post_319', 'strength': 3.0},
		   	   // {'target': 'post_7', 'source': 'post_113', 'strength': 3.0},
		   	   // {'target': 'post_107', 'source': 'post_320', 'strength': 3.0},
		   	   // {'target': 'post_393', 'source': 'post_423', 'strength': 3.0},
		   	   // {'target': 'post_494', 'source': 'post_438', 'strength': 3.0},
		   	   // {'target': 'post_206', 'source': 'post_277', 'strength': 3.0},
		   	   // {'target': 'post_16', 'source': 'post_191', 'strength': 3.0},
		   	   // {'target': 'post_75', 'source': 'post_413', 'strength': 3.0},
		   	   // {'target': 'post_369', 'source': 'post_327', 'strength': 3.0},
		   	   // {'target': 'post_222', 'source': 'post_251', 'strength': 3.0},
		   	   // {'target': 'post_29', 'source': 'post_94', 'strength': 3.0},
		   	   // {'target': 'post_475', 'source': 'post_489', 'strength': 3.0},
		   	   // {'target': 'post_315', 'source': 'post_348', 'strength': 3.0},
		   	   // {'target': 'post_406', 'source': 'post_460', 'strength': 3.0},
		   	   // {'target': 'post_135', 'source': 'post_352', 'strength': 3.0},
		   	   // {'target': 'post_336', 'source': 'post_248', 'strength': 3.0},
		   	   // {'target': 'post_199', 'source': 'post_171', 'strength': 3.0},
		   	   // {'target': 'post_109', 'source': 'post_318', 'strength': 3.0},
		   	   // {'target': 'post_248', 'source': 'post_211', 'strength': 3.0},
		   	   // {'target': 'post_313', 'source': 'post_436', 'strength': 3.0},
		   	   // {'target': 'post_88', 'source': 'post_317', 'strength': 3.0},
		   	   // {'target': 'post_68', 'source': 'post_424', 'strength': 3.0},
		   	   // {'target': 'post_311', 'source': 'post_177', 'strength': 3.0},
		   	   // {'target': 'post_403', 'source': 'post_70', 'strength': 3.0},
		   	   // {'target': 'post_302', 'source': 'post_45', 'strength': 3.0},
		   	   // {'target': 'post_259', 'source': 'post_21', 'strength': 3.0},
		   	   // {'target': 'post_311', 'source': 'post_447', 'strength': 3.0},
		   	   // {'target': 'post_380', 'source': 'post_177', 'strength': 3.0},
		   	   // {'target': 'post_94', 'source': 'post_453', 'strength': 3.0},
		   	   // {'target': 'post_308', 'source': 'post_295', 'strength': 3.0},
		   	   // {'target': 'post_102', 'source': 'post_130', 'strength': 3.0},
		   	   // {'target': 'post_65', 'source': 'post_449', 'strength': 3.0},
		   	   // {'target': 'post_483', 'source': 'post_360', 'strength': 3.0},
		   	   // {'target': 'post_26', 'source': 'post_35', 'strength': 3.0},
		   	   // {'target': 'post_497', 'source': 'post_428', 'strength': 3.0},
		   	   // {'target': 'post_47', 'source': 'post_198', 'strength': 3.0},
		   	   // {'target': 'post_329', 'source': 'post_24', 'strength': 3.0},
		   	   // {'target': 'post_315', 'source': 'post_461', 'strength': 3.0},
		   	   // {'target': 'post_157', 'source': 'post_86', 'strength': 3.0},
		   	   // {'target': 'post_201', 'source': 'post_354', 'strength': 3.0},
		   	   // {'target': 'post_22', 'source': 'post_12', 'strength': 3.0},
		   	   {'target': 'post_46', 'source': 'post_84', 'strength': 3.0},
		   	   {'target': 'post_435', 'source': 'post_307', 'strength': 3.0},
		   	   {'target': 'post_425', 'source': 'post_125', 'strength': 3.0},
		   	   {'target': 'post_352', 'source': 'post_270', 'strength': 3.0},
		   	   {'target': 'post_498', 'source': 'post_452', 'strength': 3.0},
		   	   {'target': 'post_23', 'source': 'post_70', 'strength': 3.0},
		   	   {'target': 'post_151', 'source': 'post_105', 'strength': 3.0},
		   	   {'target': 'post_179', 'source': 'post_292', 'strength': 3.0},
		   	   {'target': 'post_440', 'source': 'post_118', 'strength': 3.0},
		   	   {'target': 'post_498', 'source': 'post_366', 'strength': 3.0},
		   	   {'target': 'post_390', 'source': 'post_149', 'strength': 3.0},
		   	   {'target': 'post_113', 'source': 'post_365', 'strength': 3.0}]
		     /* { target: "mammal", source: "fox" , strength: 3.0 },
		  
		     { target: "insect", source: "ant" , strength: 0.7 },
		     { target: "insect", source: "bee" , strength: 0.7 },
		     { target: "fish"  , source: "carp", strength: 0.7 },
		     { target: "fish"  , source: "pike", strength: 0.7 },
		     { target: "cat"   , source: "elk" , strength: 0.1 },
		     { target: "carp"  , source: "ant" , strength: 0.1 },
		     { target: "elk"   , source: "bee" , strength: 0.1 },
		     { target: "dog"   , source: "cat" , strength: 0.1 },
		     { target: "fox"   , source: "ant" , strength: 0.1 },
		    { target: "pike"  , source: "cat" , strength: 0.1 } 
		   /* ]  */

		  
		      // Define main variables
		      var d3Container = d3v4.select(element),
		          margin = {top: 10, right: 10, bottom: 20, left: 20},
		          width = 650 - margin.left - margin.right,
		          height = height - margin.top - margin.bottom;

		     var colors = d3v4.scaleOrdinal(d3v4.schemeCategory10);

		      // Add SVG element
		      var container = d3Container.append("svg");

		      // Add SVG group
		      var svg = container
		          .attr("width", width + margin.left + margin.right)
		          .attr("height", height + margin.top + margin.bottom);
		         //.append("g")
		       //   .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

		       // simulation setup with all forces
		    var linkForce = d3v4
		   .forceLink()
		   .id(function (link) { return link.id })
		   .strength(function (link) { return link.strength })

		       // simulation setup with all forces
		       var simulation = d3v4
		         .forceSimulation()
		         .force('link', linkForce)
		         .force('charge', d3v4.forceManyBody().strength(-50))
		         .force('center', d3v4.forceCenter(width / 2, height / 2))

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
		         .attr("class", "testy nodes")
		         .selectAll("circle")
		         .data(nodes)
		         .enter().append("circle")
		           .attr("r", 5)
		           .attr("fill", function (d, i) {return colors(d.group);})

		       /* var textElements = svg.append("g")
		         .attr("class", "texts")
		         .selectAll("text")
		         .data(nodes)
		         .enter().append("text")
		           .text(function (node) { return  node.label })
		          .attr("font-size", 15)
		          .attr("dx", 15)
		           .attr("dy", 4) */

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


		 simulation.force("link").links(links)
		 }
		
	});
	
$("body").delegate("#mainTarget", "click", function() {
		
	var tip = $('#mainTarget1').width();
	
	console.log(tip);
	
	});
	

	
</script>

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
		loadscatter(counter_value);
		
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

<!--  <script type="text/javascript" src="assets/vendors/d3/d3.min.js" ></script> -->
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
	console.log('weeweweweewewewewewewew')
	console.log(jsondata)
	elem = '#tagcloudcontainer';
	
	
	
	
	//doCloud(jsondata,elem)

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
 <script src="pagedependencies/baseurl.js?v=93"></script>
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
	    
	    var cluster = 1
	    var clusterMatrix = []
	     <%for(int j = 0; j < termsMatrix.length; j++){%>
	    	var temparr = []
	    	<%for(int k = 0; k < termsMatrix.length; k++){%>
	    		
	    		temparr.push(<%=termsMatrix[j][k]%>);
	    	<%}%>
	    	clusterMatrix.push(temparr);
		<%}%>  
		<%-- <%for(int j = 0; j < termsMatrix.length; j++){%>
    	var temparr = []
    	<%System.out.println("items--"+termsMatrix[0][j]);%>
    	<%for(int k = 0; k < termsMatrix.length; k++){%>
    		
    		
    	<%}%>
    	clusterMatrix.push(temparr);
    	temparr.push(<%=termsMatrix[0][j]%>);
	<%}%>  --%>
	   // drawChord("#chorddiagram", chord_options, clusterMatrix, names); 
 
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
