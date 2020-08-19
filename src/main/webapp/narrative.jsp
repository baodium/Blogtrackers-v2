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
<%@page import="java.time.LocalDateTime"%>

<%
	Object email = (null == session.getAttribute("email")) ? "" : session.getAttribute("email");
	Object tid = (null == request.getParameter("tid")) ? "" : request.getParameter("tid");
	Object user = (null == session.getAttribute("username")) ? "" : session.getAttribute("username");
	Object date_start = (null == request.getParameter("date_start")) ? "" : request.getParameter("date_start");
	Object date_end = (null == request.getParameter("date_end")) ? "" : request.getParameter("date_end");
	Object single = (null == request.getParameter("single_date")) ? "" : request.getParameter("single_date");
	String sort = (null == request.getParameter("sortby"))
			? "blog"
			: request.getParameter("sortby").toString().replaceAll("[^a-zA-Z]", " ");

	if (user == null || user == "") {
		response.sendRedirect("index.jsp");
	} else {

		ArrayList<?> userinfo = null;
		String profileimage = "";
		String username = "";
		String name = "";
		String phone = "";
		String date_modified = "";
		ArrayList detail = new ArrayList();
		ArrayList termss = new ArrayList();
		ArrayList outlinks = new ArrayList();
		ArrayList influentialp = new ArrayList();

		Trackers tracker = new Trackers();
		Terms term = new Terms();
		Outlinks outl = new Outlinks();
		if (tid != "") {
			detail = tracker._fetch(tid.toString());
			//System.out.println(detail);
		} else {
			detail = tracker._list("DESC", "", user.toString(), "1");
			//System.out.println("List:"+detail);
		}

		boolean isowner = false;
		JSONObject obj = null;
		String ids = "";
		String trackername = "";
		if (detail.size() > 0) {
			//String res = detail.get(0).toString();
			ArrayList resp = (ArrayList<?>) detail.get(0);

			String tracker_userid = resp.get(0).toString();
			trackername = resp.get(2).toString();
			//if (tracker_userid.equals(user.toString())) {
			isowner = true;
			String query = resp.get(5).toString();//obj.get("query").toString();
			query = query.replaceAll("blogsite_id in ", "");
			query = query.replaceAll("\\(", "");
			query = query.replaceAll("\\)", "");
			ids = query;
			//}
		}

		userinfo = new DbConnection().query("SELECT * FROM usercredentials where Email = '" + email + "'");
		if (userinfo.size() < 1 || !isowner) {
			response.sendRedirect("index.jsp");
		} else {
			userinfo = (ArrayList<?>) userinfo.get(0);
			try {
				username = (null == userinfo.get(0)) ? "" : userinfo.get(0).toString();

				name = (null == userinfo.get(4)) ? "" : (userinfo.get(4).toString());
				email = (null == userinfo.get(2)) ? "" : userinfo.get(2).toString();
				phone = (null == userinfo.get(6)) ? "" : userinfo.get(6).toString();
				String userpic = userinfo.get(9).toString();
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
				}else{
					/* new File("/path/directory").mkdirs(); */
					path_new.mkdirs();
					System.out.println("pathhhhh1--"+path_new);
				}
				
				
				if (path_new.exists()) {
					
					String t = "/images/profile_images";
					int p=userpic.indexOf(t);
					System.out.println(p);
					if (p != -1) {
						
						System.out.println("pic path---"+userpic);
						System.out.println("path exists---"+userpic.substring(0, p));
						String path_update=userpic.substring(0, p);
						if (!path_update.equals(path_new.toString())) {
							profileimage = "images/profile_images/" + userinfo.get(2).toString() + ".jpg";
							/* profileimage=userpic.replace(userpic.substring(0, p), path_new.toString()); */
							String new_file_path = path_new.toString().replace("\\images\\profile_images", "")+"/"+profileimage;
							System.out.println("ready to be updated--"+ new_file_path);
							/*new DbConnection().updateTable("UPDATE usercredentials SET profile_picture  = '" + pass + "' WHERE Email = '" + email + "'"); */											
						}
					}else{
						path_new.mkdirs();
						profileimage = "images/profile_images/" + userinfo.get(2).toString() + ".jpg";
						/* profileimage=userpic.replace(userpic.substring(0, p), path_new.toString()); */
						String new_file_path = path_new.toString().replace("\\images\\profile_images", "")+"/"+profileimage;
						System.out.println("ready to be updated--"+ new_file_path);
						
						new DbConnection().updateTable("UPDATE usercredentials SET profile_picture  = '" + "images/profile_images/" + userinfo.get(2).toString() + ".jpg" + "' WHERE Email = '" + email + "'");
						System.out.println("updated");
					}				
				}else{
					System.out.println("path doesnt exist");
				}
			} catch (Exception e) {

			}

			String[] user_name = name.split(" ");
			Blogposts post = new Blogposts();
			Blogs blog = new Blogs();
			Sentiments senti = new Sentiments();

			//Date today = new Date();
			SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("MMM d, yyyy");
			SimpleDateFormat DATE_FORMAT2 = new SimpleDateFormat("yyyy-MM-dd");

			SimpleDateFormat DAY_ONLY = new SimpleDateFormat("dd");
			SimpleDateFormat MONTH_ONLY = new SimpleDateFormat("MM");
			SimpleDateFormat SMALL_MONTH_ONLY = new SimpleDateFormat("mm");
			SimpleDateFormat WEEK_ONLY = new SimpleDateFormat("dd");
			SimpleDateFormat YEAR_ONLY = new SimpleDateFormat("yyyy");

			String stdate = post._getDate(ids, "first");
			String endate = post._getDate(ids, "last");

			Date dstart = new SimpleDateFormat("yyyy-MM-dd").parse(stdate);
			Date today = new SimpleDateFormat("yyyy-MM-dd").parse(endate);

			Date nnow = new Date();

			String day = DAY_ONLY.format(today);

			String month = MONTH_ONLY.format(today);
			String smallmonth = SMALL_MONTH_ONLY.format(today);
			String year = YEAR_ONLY.format(today);

			String dispfrom = DATE_FORMAT.format(dstart);
			String dispto = DATE_FORMAT.format(today);

			String historyfrom = DATE_FORMAT.format(dstart);
			String historyto = DATE_FORMAT.format(today);

			String dst = DATE_FORMAT2.format(dstart);
			String dend = DATE_FORMAT2.format(today);

			//ArrayList posts = post._list("DESC","");
			ArrayList sentiments = senti._list("DESC", "", "id");
			String totalpost = "0";
			ArrayList allauthors = new ArrayList();

			String possentiment = "0";
			String negsentiment = "0";
			String ddey = "31";
			String dt = dst;
			String dte = dend;
			String year_start = "";
			String year_end = "";
			

			if (!date_start.equals("") && !date_end.equals("")) {
				totalpost = post._searchRangeTotal("date", date_start.toString(), date_end.toString(), ids);
				//possentiment = post._searchRangeTotal("sentiment", "0", "10", ids);
				//negsentiment = post._searchRangeTotal("sentiment", "-10", "-1", ids);

				Date start = new SimpleDateFormat("yyyy-MM-dd").parse(date_start.toString());
				Date end = new SimpleDateFormat("yyyy-MM-dd").parse(date_end.toString());

				dt = date_start.toString();
				dte = date_end.toString();

				historyfrom = DATE_FORMAT.format(start);
				historyto = DATE_FORMAT.format(end);


			} 
				
				
				
				/* }  else {
				dt = dst;
				dte = dend;
				
			} */
														
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Blogtrackers - Narrative Analysis</title>
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
<link rel="stylesheet" href="assets/presentation/narrative-analysis.css"/>
        
        <script src="assets/behavior/narrative-analysis.js"></script>
<!--end of bootsrap -->
<script src="assets/js/jquery-3.2.1.slim.min.js"></script>
<script src="assets/js/popper.min.js"></script>
<script src="pagedependencies/googletagmanagerscript.js"></script>
</head>
<body> 
<%@include file="subpages/loader.jsp" %>
	<noscript>
		<%@include file="subpages/googletagmanagernoscript.jsp"%>
	</noscript>
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
					<%-- <a class="cursor-pointer profilemenulink"
						href="<%=request.getContextPath()%>/notifications.jsp"><h6
							class="text-primary">
							Notifications <b id="notificationcount" class="cursor-pointer">12</b>
						</h6> </a> --%>  <a class="cursor-pointer profilemenulink" href="<%=request.getContextPath()%>/addblog.jsp"><h6 class="text-primary">Add Blog</h6></a>
						<a class="cursor-pointer profilemenulink"
						href="<%=request.getContextPath()%>/profile.jsp"><h6
							class="text-primary">Profile</h6></a> 
							
							<a
						class="cursor-pointer profilemenulink"
						href="https://addons.mozilla.org/en-US/firefox/addon/blogtrackers/"><h6
							class="text-primary">Plugin</h6></a>
							
							<a
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
						data-toggle="dropdown"> <!-- <i class="fas fa-circle"
							id="notificationcolor"> --></i> <img src="<%=profileimage%>"
							width="50" height="50"
							onerror="this.src='images/default-avatar.png'" alt="" class="" />
							<span><%=user_name[0]%></span></a>

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
		<!-- start of print section  -->



		<div class="row bottom-border pb20">
			<div class="col-md-6 ">
				<nav class="breadcrumb">
					<a class="breadcrumb-item text-primary"
						href="<%=request.getContextPath()%>/trackerlist.jsp">Trackers</a> <a class="breadcrumb-item text-primary"
						href="<%=request.getContextPath()%>/edittracker.jsp?tid=<%=tid%>"><%=trackername%></a>
						<a class="breadcrumb-item active text-primary" href="<%=request.getContextPath()%>/dashboard.jsp?tid=<%=tid%>">Dashboard</a>
					<a class="breadcrumb-item active text-primary" href="<%=request.getContextPath()%>/narrative.jsp?tid=<%=tid%>">Narrative Analysis</a>
				</nav>
				<!-- <div>
					<button class="btn btn-primary stylebutton1 " id="printdoc">SAVE
						AS PDF</button>
				</div> -->
			</div>
			<div class="col-md-6 text-right mt10">
				<div class="text-primary demo">
					<h6 id="reportrange">
						Date: <span><%=dispfrom%> - <%=dispto%></span>
					</h6>
				</div>
				<div>
					<div class="btn-group mt5" data-toggle="buttons">
						<!-- <label
							class="btn btn-primary btn-sm daterangebutton legitRipple nobgnoborder">
							<input type="radio" name="options" value="day" autocomplete="off">
							Day
						</label> <label class="btn btn-primary btn-sm nobgnoborder"> <input
							type="radio" name="options" value="week" autocomplete="off">Week
						</label> <label class="btn btn-primary btn-sm nobgnoborder nobgnoborder">
							<input type="radio" name="options" value="month"
							autocomplete="off"> Month
						</label> <label class="btn btn-primary btn-sm text-center nobgnoborder">Year
							<input type="radio" name="options" value="year"
							autocomplete="off">
						</label> -->
						<!--  <label class="btn btn-primary btn-sm nobgnoborder " id="custom">Custom</label> -->
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




	<ul id="narrativeTree">
            <li class="level">
                <div class="keyword">
                    <div class="collapseIcon"></div>
                    <p class="text">COVID-19</p>
                </div>
                <ul class="narratives">
                    <li class="narrative">
                        <div class="topSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                            </div>
                        </div>
                        <div class="middleSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                                <div class="dot"></div>
                            </div>
                            <p class="narrativeText">The American Red Cross is closely monitoring the outbreak…</p>
                        </div>
                        <div class="bottomSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                            </div>
                            <div class="posts">
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/1.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/2.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/3.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/4.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/5.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/6.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/7.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/8.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/9.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/10.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/11.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/12.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/13.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/14.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/15.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </li>
                    <li class="narrative last">
                        <div class="topSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                            </div>
                        </div>
                        <div class="middleSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                                <div class="dot"></div>
                            </div>
                            <p class="narrativeText">Cautioned young people to heed the advice to socially distance and be wary of the…</p>
                        </div>
                        <div class="bottomSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                            </div>
                            <div class="posts">
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/1.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/2.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/3.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/4.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/5.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/6.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/7.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/8.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/9.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/10.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/11.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/12.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/13.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/14.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/15.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </li>
                </ul>
            </li>
            <li class="level uncollapse">
                <div class="keyword">
                    <div class="collapseIcon"></div>
                    <p class="text">US Forces</p>
                </div>
                <ul class="narratives">
                    <li class="narrative">
                        <div class="topSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                            </div>
                        </div>
                        <div class="middleSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                                <div class="dot"></div>
                            </div>
                            <p class="narrativeText">The American Red Cross is closely monitoring the outbreak…</p>
                        </div>
                        <div class="bottomSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                            </div>
                            <div class="posts">
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/24.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/25.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/35.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/4.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/5.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/6.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/7.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/8.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/9.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/10.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/11.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/12.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/13.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/14.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/15.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </li>
                    <li class="narrative open">
                        <div class="topSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                            </div>
                        </div>
                        <div class="middleSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                                <div class="dot"></div>
                            </div>
                            <p class="narrativeText">President Donald Trump and a top US health official cautioned young people to heed the advice to socially distance and be wary of the…</p>
                        </div>
                        <div class="bottomSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                            </div>
                            <div class="posts">
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/1.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/2.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/3.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/4.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/5.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/6.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/7.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/8.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/9.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/10.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/11.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/12.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/13.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/14.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/15.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </li>
                    <li class="narrative last">
                        <div class="topSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                            </div>
                        </div>
                        <div class="middleSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                                <div class="dot"></div>
                            </div>
                            <p class="narrativeText">Cautioned young people to heed the advice to socially distance and be wary of the…</p>
                        </div>
                        <div class="bottomSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                            </div>
                            <div class="posts">
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/1.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/2.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/3.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/4.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/5.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/6.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/7.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/8.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/9.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/10.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/11.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/12.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/13.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/14.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/15.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </li>
                </ul>
            </li>
            <li class="level">
                <div class="keyword">
                    <div class="collapseIcon"></div>
                    <p class="text">Hackers Trackers 2</p>
                </div>
                <ul class="narratives">
                    <li class="narrative">
                        <div class="topSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                            </div>
                        </div>
                        <div class="middleSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                                <div class="dot"></div>
                            </div>
                            <p class="narrativeText">The American Red Cross is closely monitoring the outbreak…</p>
                        </div>
                        <div class="bottomSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                            </div>
                            <div class="posts">
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/1.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/2.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/3.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/4.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/5.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/6.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/7.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/8.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/9.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/10.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/11.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/12.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/13.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/14.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/15.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </li>
                    <li class="narrative">
                        <div class="topSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                            </div>
                        </div>
                        <div class="middleSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                                <div class="dot"></div>
                            </div>
                            <p class="narrativeText">President Donald Trump and a top US health official cautioned young people to heed the advice to socially distance and be wary of the…</p>
                        </div>
                        <div class="bottomSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                            </div>
                            <div class="posts">
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/1.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/2.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/3.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/4.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/5.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/6.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/7.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/8.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/9.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/10.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/11.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/12.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/13.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/14.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/15.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </li>
                    <li class="narrative">
                        <div class="topSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                            </div>
                        </div>
                        <div class="middleSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                                <div class="dot"></div>
                            </div>
                            <p class="narrativeText">President Donald Trump and a top US health official cautioned young people to heed the advice to socially distance and be wary of the…</p>
                        </div>
                        <div class="bottomSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                            </div>
                            <div class="posts">
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/1.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/2.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/3.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/4.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/5.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/6.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/7.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/8.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/9.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/10.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/11.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/12.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/13.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/14.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/15.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </li>
                    <li class="narrative last">
                        <div class="topSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                            </div>
                        </div>
                        <div class="middleSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                                <div class="dot"></div>
                            </div>
                            <p class="narrativeText">Cautioned young people to heed the advice to socially distance and be wary of the…</p>
                        </div>
                        <div class="bottomSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                            </div>
                            <div class="posts">
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/1.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/2.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/3.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/4.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/5.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/6.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/7.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/8.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/9.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/10.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/11.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/12.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/13.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/14.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/15.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </li>
                </ul>
            </li>
            <li class="level">
                <div class="keyword">
                    <div class="collapseIcon"></div>
                    <p class="text">Nato</p>
                </div>
                <ul class="narratives">
                    <li class="narrative">
                        <div class="topSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                            </div>
                        </div>
                        <div class="middleSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                                <div class="dot"></div>
                            </div>
                            <p class="narrativeText">The American Red Cross is closely monitoring the outbreak…</p>
                        </div>
                        <div class="bottomSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                            </div>
                            <div class="posts">
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/1.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/2.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/3.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/4.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/5.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/6.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/7.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/8.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/9.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/10.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/11.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/12.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/13.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/14.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/15.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </li>
                    <li class="narrative last">
                        <div class="topSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                            </div>
                        </div>
                        <div class="middleSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                                <div class="dot"></div>
                            </div>
                            <p class="narrativeText">Cautioned young people to heed the advice to socially distance and be wary of the…</p>
                        </div>
                        <div class="bottomSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                            </div>
                            <div class="posts">
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/1.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/2.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/3.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/4.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/5.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/6.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/7.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/8.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/9.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/10.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/11.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/12.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/13.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/14.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/15.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </li>
                </ul>
            </li>
            <li class="level uncollapse">
                <div class="keyword">
                    <div class="collapseIcon"></div>
                    <p class="text">China</p>
                </div>
                <ul class="narratives">
                    <li class="narrative last">
                        <div class="topSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                            </div>
                        </div>
                        <div class="middleSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                                <div class="dot"></div>
                            </div>
                            <p class="narrativeText">Cautioned young people to heed the advice to socially distance and be wary of the…</p>
                        </div>
                        <div class="bottomSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                            </div>
                            <div class="posts">
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/1.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/2.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/3.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/4.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/5.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/6.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/7.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/8.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/9.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/10.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/11.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/12.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/13.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/14.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                                <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/15.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </li>
                </ul>
            </li>
        </ul>




	

	</div>


	<!-- <footer class="footer">
  <div class="container-fluid bg-primary mt60">
<p class="text-center text-medium pt10 pb10 mb0">Copyright &copy; Blogtrackers 2017 All Rights Reserved.</p>
</div>
  </footer> -->


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

	<script src="pagedependencies/baseurl.js?v=3"></script>
	<script src="pagedependencies/sentiment.js?v=140"></script>

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
         "scrollY": 370,
         "order": [[ 0, "asc" ]],
         "pagingType": "simple",
         "ordering": false
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
	<!--end for table  -->
	<script>
 $(document).ready(function() {
	 
		 
   $(document)
   						.ready(
   								function() {
   	var cb = function(start, end, label) {
           //console.log(start.toISOString(), end.toISOString(), label);
          // $('#reportrange span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
           $('#reportrange input').val(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY')).trigger('change');
         };

         var optionSet1 =
       	      {   startDate: moment().subtract(29, 'days'),
       	          endDate: moment(),
       	          minDate: '01/01/1947',
       	       	  linkedCalendars: false,
       	          maxDate: moment(),
       			  showDropdowns: true,
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
      // $('#reportrange span').html(moment().subtract( 500, 'days').format('MMMM D, YYYY') + ' - ' + moment().format('MMMM D, YYYY'))
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
   					var start = picker.startDate.format('YYYY-MM-DD');
   	            	var end = picker.endDate.format('YYYY-MM-DD');
   	            	//console.log("End:"+end);
   	            	
   	            	$("#date_start").val(start);
   	            	$("#date_end").val(end);
   	            	//toastr.success('Date changed!','Success');
   	            	$("form#customform").submit();
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
	<script type="text/javascript" src="assets/vendors/d3/d3.min.js"></script>
	<script src="assets/vendors/wordcloud/d3.layout.cloud.js"></script>
	<script type="text/javascript" src="assets/vendors/d3/d3_tooltip.js"></script>
	<script src="assets/vendors/radarchart/radarChart.js"></script>
	<script>
$(function () {
    

    //////////////////////////////////////////////////////////////
    //////////////////////// Set-Up //////////////////////////////
    //////////////////////////////////////////////////////////////

    var margin = {top: 100, right: 100, bottom: 100, left: 100},
      width = Math.min(450, window.innerWidth - 10) - margin.left - margin.right,
      height = Math.min(width, window.innerHeight - margin.top - margin.bottom - 20);



    //////////////////////////////////////////////////////////////
    ////////////////////////// Data //////////////////////////////
    //////////////////////////////////////////////////////////////

    
    //////////////////////////////////////////////////////////////
    //////////////////// Draw the Chart //////////////////////////
    //////////////////////////////////////////////////////////////

    var color = d3.scale.ordinal()
      .range(["#0080CC","#0080CC","#0080CC"]);

    var radarChartOptions1 = {
      w: width,
      h: height,
      margin: margin,
      maxValue: 0.5,
      levels: 5,
      roundStrokes: true,
      color: color
    };
    var radarChartOptions2 = {
      w: width,
      h: height,
      margin: margin,
      maxValue: 0.5,
      levels: 5,
      roundStrokes: true,
      color: color
    };
    var radarChartOptions3 = {
      w: width,
      h: height,
      margin: margin,
      maxValue: 0.5,
      levels: 5,
      roundStrokes: true,
      color: color
    };
    var radarChartOptions4 = {
      w: width,
      h: height,
      margin: margin,
      maxValue: 0.5,
      levels: 5,
      roundStrokes: true,
      color: color
    };
    var radarChartOptions5 = {
      w: width,
      h: height,
      margin: margin,
      maxValue: 0.5,
      levels: 5,
      roundStrokes: true,
      color: color
    };
    
    var radarChartOptions6 = {
    	      w: width,
    	      h: height,
    	      margin: margin,
    	      maxValue: 0.5,
    	      levels: 5,
    	      roundStrokes: true,
    	      color: color
    	    };
    
    var radarChartOptions7 = {
  	      w: width,
  	      h: height,
  	      margin: margin,
  	      maxValue: 0.5,
  	      levels: 5,
  	      roundStrokes: true,
  	      color: color
  	    };
 
    //Call function to draw the Radar chart

      RadarChart(".personalcontent", personalcontent, radarChartOptions1);
      RadarChart(".timeorientation", timeorientation, radarChartOptions2);
      RadarChart(".coredriveandneed", coredriveandneed, radarChartOptions3);
      RadarChart(".cognitiveprocess", cognitiveprocess, radarChartOptions4);
      RadarChart(".summaryvariable", summaryvariable, radarChartOptions5);
      RadarChart(".sentimentemotion", sentimentemotion, radarChartOptions6);
      RadarChart(".toxicity", toxicity, radarChartOptions7);

});
  </script>
	<script>

 </script>
	<script>
$(".option-only").on("change",function(e){
	//console.log("only changed ");
	var valu =  $(this).val();
	$("#single_date").val(valu);
	$('form#customformsingle').submit();
});

$(".option-only").on("click",function(e){
	//console.log("only Click ");
	$("#single_date").val($(this).val());
	//$('form#customformsingle').submit();
});

$(".option-lable").on("click",function(e){
	//console.log("Label Click ");
	
	$("#single_date").val($(this).val());
	//$('form#customformsingle').submit();
});
</script>
	<script>
  $('.carousel').carousel({
      interval: false
  });
  </script>



</body>
</html>

<% }} %>
