<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%@page import="authentication.*"%>
<%@page import="java.util.*"%>
<%@page import="util.*"%>
<%@page import="java.io.File"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.net.URI"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>

<%@page import="org.apache.commons.lang3.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.time.*"%>

<%
	Object email = (null == session.getAttribute("email")) ? "" : session.getAttribute("email");
	Object tid = (null == request.getParameter("tid")) ? "" : request.getParameter("tid");

	Object user = (null == session.getAttribute("username")) ? "" : session.getAttribute("username");
	Object userid = (null == session.getAttribute("user")) ? "" : session.getAttribute("user");
	Object termites = (null == session.getAttribute("top_terms")) ? "" : session.getAttribute("top_terms");

	Object date_start = (null == request.getParameter("date_start")) ? "" : request.getParameter("date_start");
	Object date_end = (null == request.getParameter("date_end")) ? "" : request.getParameter("date_end");
	Object single = (null == request.getParameter("single_date")) ? "" : request.getParameter("single_date");
	String sort = (null == request.getParameter("sortby"))
			? "blog"
			: request.getParameter("sortby").toString().replaceAll("[^a-zA-Z]", " ");
	int selectedkeycount = 0;

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
		ArrayList liwcpost = new ArrayList();

		ArrayList allterms = new ArrayList();

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

				File path_new = new File(
						application.getRealPath("/").replace('/', '/') + "images/profile_images");
				if (f.exists() && !f.isDirectory()) {
					profileimage = "images/profile_images/" + userinfo.get(2).toString() + ".jpg";
				} else {
					/* new File("/path/directory").mkdirs(); */
					path_new.mkdirs();
					System.out.println("pathhhhh1--" + path_new);
				}

				if (path_new.exists()) {

					String t = "/images/profile_images";
					int p = userpic.indexOf(t);
					System.out.println(p);
					if (p != -1) {

						System.out.println("pic path---" + userpic);
						System.out.println("path exists---" + userpic.substring(0, p));
						String path_update = userpic.substring(0, p);
						if (!path_update.equals(path_new.toString())) {
							profileimage = "images/profile_images/" + userinfo.get(2).toString() + ".jpg";
							/* profileimage=userpic.replace(userpic.substring(0, p), path_new.toString()); */
							String new_file_path = path_new.toString().replace("\\images\\profile_images", "")
									+ "/" + profileimage;
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

						new DbConnection().updateTable("UPDATE usercredentials SET profile_picture  = '"
								+ "images/profile_images/" + userinfo.get(2).toString() + ".jpg"
								+ "' WHERE Email = '" + email + "'");
						System.out.println("updated");
					}
				} else {
					System.out.println("path doesnt exist");
				}
			} catch (Exception e) {

			}
			String firstname = "";
			String[] user_name = name.split(" ");
			String[] names = name.split(" ");
			firstname = names[0];
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

			Date dstart = new Date();//SimpleDateFormat("yyyy-MM-dd").parse(stdate);
			Date today = new Date();//SimpleDateFormat("yyyy-MM-dd").parse(endate);

			Date nnow = new Date();
			try {
				dstart = new SimpleDateFormat("yyyy-MM-dd").parse(stdate);
			} catch (Exception ex) {
				dstart = nnow;//new SimpleDateFormat("yyyy-MM-dd").parse(nnow);
			}

			try {
				today = new SimpleDateFormat("yyyy-MM-dd").parse(endate);
			} catch (Exception ex) {
				today = nnow;//new SimpleDateFormat("yyyy-MM-dd").parse(nnow);
			}

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

			String totalpost = "0";
			ArrayList allauthors = new ArrayList();

			String possentiment = "0";
			String negsentiment = "0";
			String ddey = "31";
			String dt = dst;
			String dte = dend;
			String year_start = "";
			String year_end = "";

			if (!single.equals("")) {
				month = MONTH_ONLY.format(nnow);
				day = DAY_ONLY.format(nnow);
				year = YEAR_ONLY.format(nnow);
				//System.out.println("Now:"+month+"small:"+smallmonth);
				if (month.equals("02")) {
					ddey = (Integer.parseInt(year) % 4 == 0) ? "28" : "29";
				} else if (month.equals("09") || month.equals("04") || month.equals("05")
						|| month.equals("11")) {
					ddey = "30";
				}
			}

			termss = term._searchByRange("blogsiteid", dt, dte, ids);

			//System.out.println("start date"+date_start+"end date "+date_end);
			if (!date_start.equals("") && !date_end.equals("")) {

				possentiment = post._searchRangeTotal("sentiment", "0", "10", ids);
				negsentiment = post._searchRangeTotal("sentiment", "-10", "-1", ids);

				Date start = new SimpleDateFormat("yyyy-MM-dd").parse(date_start.toString());
				Date end = new SimpleDateFormat("yyyy-MM-dd").parse(date_end.toString());

				dt = date_start.toString();
				dte = date_end.toString();

				historyfrom = DATE_FORMAT.format(start);
				historyto = DATE_FORMAT.format(end);

			} else if (single.equals("day")) {
				dt = year + "-" + month + "-" + day;

			} else if (single.equals("week")) {

				dte = year + "-" + month + "-" + day;
				int dd = Integer.parseInt(day) - 7;

				Calendar cal = Calendar.getInstance();
				cal.add(Calendar.DATE, -7);
				Date dateBefore7Days = cal.getTime();
				dt = YEAR_ONLY.format(dateBefore7Days) + "-" + MONTH_ONLY.format(dateBefore7Days) + "-"
						+ DAY_ONLY.format(dateBefore7Days);

			} else if (single.equals("month")) {
				dt = year + "-" + month + "-01";
				dte = year + "-" + month + "-" + day;
			} else if (single.equals("year")) {
				dt = year + "-01-01";
				dte = year + "-12-" + ddey;

			} else {
				dt = dst;
				dte = dend;

			}

			String test = post._searchTotalByTitleAndBody("war", "date", "2009-01-01", "2009-12-31");//term._searchByRange("date",dt,dte, tm,"term","10");
			System.out.println("Size=" + test);

			String[] yst = dt.split("-");
			String[] yend = dte.split("-");
			year_start = yst[0];
			year_end = yend[0];
			int ystint = new Double(year_start).intValue();
			int yendint = new Double(year_end).intValue();

			if (yendint > Integer.parseInt(YEAR_ONLY.format(new Date()))) {
				dte = DATE_FORMAT2.format(new Date()).toString();
				yendint = Integer.parseInt(YEAR_ONLY.format(new Date()));
			}

			if (ystint < 2000) {
				ystint = 2000;
				dt = "2000-01-01";
			}

			dispfrom = DATE_FORMAT.format(new SimpleDateFormat("yyyy-MM-dd").parse(dt));
			dispto = DATE_FORMAT.format(new SimpleDateFormat("yyyy-MM-dd").parse(dte));

			ArrayList allposts = new ArrayList();

			String allpost = "0";
			String mostactiveterm = "";
			String toplocation = "";
			String mostactiveterm_id = "";

			JSONArray termscount = new JSONArray();

			JSONArray posttodisplay = new JSONArray();
			JSONObject years = new JSONObject();
			JSONArray yearsarray = new JSONArray();
			JSONObject locations = new JSONObject();

			JSONArray unsortedterms = new JSONArray();
			JSONObject termstore = new JSONObject();
			Map<String, Integer> top_terms = new HashMap<String, Integer>();
			if (termss.size() > 0) {
				for (int p = 0; p < termss.size(); p++) {
					String bstr = termss.get(p).toString();
					JSONObject bj = new JSONObject(bstr);
					bstr = bj.get("_source").toString();
					bj = new JSONObject(bstr);
					String tm = bj.get("term").toString();

					String frequency = bj.get("frequency").toString();
					String id = bj.get("id").toString();
					//String frequency = "10";
					int frequency2 = Integer.parseInt(frequency);
					if (top_terms.containsKey(tm)) {
						top_terms.put(tm, top_terms.get(tm) + frequency2);
						frequency2 = top_terms.get(tm) + frequency2;
					} else {
						top_terms.put(tm, frequency2);
					}
					JSONObject cont = new JSONObject();
					unsortedterms.put(frequency2 + "___" + tm + "___" + id);

				}
			}

			JSONArray sortedterms = term._sortJson2(unsortedterms);

			if (sortedterms.length() > 0) {
				for (int i = 0; i < sortedterms.length(); i++) {
					String[] vals = sortedterms.get(i).toString().split("___");
					String size = vals[0];
					String tm = vals[1];
					String terms_id = vals[2];
					if (i == 0) {
						mostactiveterm = tm;
						mostactiveterm_id = terms_id;
					}

				}
			}

			JSONObject termsyears = new JSONObject();

			allterms = term._searchByRange("blogsiteid", dt, dte, ids);//term._searchByRange("date", dt, dte, ids);
			//termss = term._searchByRange("blogsiteid", dt, dte, ids);

			int postmentioned = 0;
			int blogmentioned = 0;
			int bloggermentioned = 0;

			int highestfrequency = 0;
			int highestpost = 0;

			int alloccurence = 0;

			JSONArray topterms = new JSONArray();

			JSONObject keys = new JSONObject();
			JSONObject positions = new JSONObject();
			int termsposition = 0;
			if (allterms.size() > 0) {
				for (int p = 0; p < allterms.size(); p++) {
					String bstr = allterms.get(p).toString();
					JSONObject bj = new JSONObject(bstr);
					bstr = bj.get("_source").toString();
					bj = new JSONObject(bstr);
					String frequency = bj.get("frequency").toString();
					//String frequency = "10";
					int freq = Integer.parseInt(frequency);

					String tm = bj.get("term").toString();
					String tmid = bj.get("id").toString();
					String blogpostid = bj.get("blogpostid").toString();
					String blogid = bj.get("blogsiteid").toString();

					if (freq > highestfrequency) {
						highestfrequency = freq;
						//mostactiveterm = tm;
					}

					String postc = "0";
					String blogc = "0";
					String bloggerc = "0";
					String language = "";
					String leadingblogger = "";
					String location = "";
					String leadingblogid = "";

					ArrayList postdetail = post._fetch(blogpostid);

					if (postdetail.size() > 0) {
						String tres3 = null;
						JSONObject tresp3 = null;
						String tresu3 = null;
						JSONObject tobj3 = null;

						for (int j = 0; j < 1; j++) {
							tres3 = postdetail.get(j).toString();
							tresp3 = new JSONObject(tres3);
							tresu3 = tresp3.get("_source").toString();
							tobj3 = new JSONObject(tresu3);

							leadingblogger = tobj3.get("blogger").toString();
							language = tobj3.get("language").toString();
							leadingblogid = tobj3.get("blogsite_id").toString();
							location = blog._getTopLocation(leadingblogid);//tobj3.get("location").toString();

						}
					}

					if (p == 0) {
						allposts = post._searchByTitleAndBody(tm, "date", dt, dte);//term._searchByRange("date",dt,dte, tm,"term","10");
						toplocation = location;
						//mostactiveterm = tm;
						//mostactiveterm_id = tmid;

						postc = post._searchTotalAndUnique(tm, "date", dt, dte, "blogpost_id");//post._searchTotalByTitleAndBody(tm,"date", dt,dte);

						//System.out.println("postc="+postc);
						blogc = post._searchTotalAndUnique(tm, "date", dt, dte, "blogsite_id");
						bloggerc = post._searchTotalAndUnique(tm, "date", dt, dte, "blogger");//post._searchTotalAndUniqueBlogger(tm,"date", dt,dte,"blogger");

						postmentioned += (Integer.parseInt(postc));
						blogmentioned += (Integer.parseInt(blogc));
						bloggermentioned += (Integer.parseInt(bloggerc));

						//postm   = post._searchByTitleAndBodyTotal(tm,"date",dt,dte);
					}

					JSONObject cont = new JSONObject();

					cont.put("key", tm);
					cont.put("id", tmid);
					cont.put("frequency", frequency);
					cont.put("postcount", postc);
					cont.put("blogcount", blogc);
					cont.put("bloggercount", bloggerc);
					cont.put("blogsite_id", blogid);
					cont.put("leadingblogger", leadingblogger);
					cont.put("language", language);
					cont.put("location", location);

					if (keys.has(tm)) {
						String frequ = keys.get(tm).toString();
						String pos = positions.get(tm).toString();
						int fr1 = Integer.parseInt(frequency);
						int fr2 = Integer.parseInt(frequ);

						cont.put("key", tm);
						cont.put("frequency", (fr1 + fr2));
						topterms.put(Integer.parseInt(pos), cont);
					} else {
						cont.put("key", tm);
						cont.put("frequency", frequency);
						keys.put(tm, frequency);
						positions.put(tm, termsposition);
						topterms.put(cont);
						termscount.put(p, tm);
					}
					/*
					if(!keys.has(tm)){
						keys.put(tm,tm);
						topterms.put(cont);
						termscount.put(p, tm);
					}
					*/
				}
			}

			if (termscount.length() > 0) {
				for (int n = 0; n < 1; n++) {
					int b = 0;
					JSONObject postyear = new JSONObject();
					for (int y = ystint; y <= yendint; y++) {
						String dtu = y + "-01-01";
						String dtue = y + "-12-31";
						if (b == 0) {
							dtu = dt;
						} else if (b == yendint) {
							dtue = dte;
						}

						String totu = post._searchTotalByTitleAndBody(mostactiveterm, "date", dtu, dtue);//term._searchRangeTotal("date",dtu, dtue,termscount.get(n).toString());						   

						System.out.println(mostactiveterm + ":TM:" + dtu + "," + dtue + "=" + totu);

						if (!years.has(y + "")) {
							years.put(y + "", y);
							yearsarray.put(b, y);
							b++;
						}

						postyear.put(y + "", totu);
					}
					termsyears.put(termscount.get(n).toString(), postyear);
				}
			}
%>

<!DOCTYPE html>
<html>

<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Blogtrackers - Keywords Trend</title>
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

  <link rel="stylesheet" type="text/css" href="multiline.css">

<!--end of bootsrap -->
<script src="assets/js/jquery-3.2.1.slim.min.js"></script>
<script src="assets/js/popper.min.js"></script>
<script src="pagedependencies/googletagmanagerscript.js"></script>
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
					<%-- <a class="cursor-pointer profilemenulink"
						href="<%=request.getContextPath()%>/notifications.jsp"><h6 class="text-primary">
						Notifications <b id="notificationcount" class="cursor-pointer">12</b>
					</h6> </a> --%>
					<a class="cursor-pointer profilemenulink"
						href="<%=request.getContextPath()%>/addblog.jsp">
						<h6 class="text-primary">Add Blog</h6>
					</a> <a class="cursor-pointer profilemenulink"
						href="<%=request.getContextPath()%>/profile.jsp">
						<h6 class="text-primary">Profile</h6>
					</a> <a class="cursor-pointer profilemenulink"
						href="https://addons.mozilla.org/en-US/firefox/addon/blogtrackers/">
						<h6 class="text-primary">Plugin</h6>
					</a> <a class="cursor-pointer profilemenulink"
						href="<%=request.getContextPath()%>/logout">
						<h6 class="text-primary">Log Out</h6>
					</a>
					<%
						} else {
					%>
					<a class="cursor-pointer profilemenulink"
						href="<%=request.getContextPath()%>/login">
						<h6 class="text-primary">Login</h6>
					</a>

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
							<span><%=firstname%></span></a>

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
			<div class="col-md-6 ">
				<nav class="breadcrumb">
					<a class="breadcrumb-item text-primary"
						href="<%=request.getContextPath()%>/trackerlist.jsp">Trackers</a>
					<a class="breadcrumb-item text-primary"
						href="<%=request.getContextPath()%>/edittracker.jsp?tid=<%=tid%>"><%=trackername%></a>
					<a class="breadcrumb-item active text-primary"
						href="<%=request.getContextPath()%>/dashboard.jsp?tid=<%=tid%>">Dashboard</a>
					<a class="breadcrumb-item active text-primary"
						href="<%=request.getContextPath()%>/postingfrequency.jsp?tid=<%=tid%>">Keyword
						Trend</a>
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
							<input type="radio" name="options" value="day"
							class="option-only" autocomplete="off"> Day
						</label> <label class="btn btn-primary btn-sm nobgnoborder"> <input
							type="radio" class="option-only" name="options" value="week"
							autocomplete="off">Week
						</label> <label class="btn btn-primary btn-sm nobgnoborder"> <input
							type="radio" class="option-only" name="options" value="month"
							autocomplete="off"> Month
						</label> <label class="btn btn-primary btn-sm text-center nobgnoborder">Year
							<input type="radio" class="option-only" name="options"
							value="year" autocomplete="off">
						</label> -->
						<!-- <label class="btn btn-primary btn-sm nobgnoborder" id="custom">Custom</label> -->
					</div>

				</div>
			</div>
		</div>

		<!-- <div class="row p40 border-top-bottom mt20 mb20">
  <div class="col-md-2">
<small class="text-primary">Selected Keyword</small>
<h2 class="text-primary styleheading pb10">Technology <div class="circle"></div></h2>
</div>
  <div class="col-md-10">
  <small class="text-primary">Explore Keywords </small>
  <input class="form-control inputboxstyle" placeholder="| Search" />
  </div>
</div> -->

		<div class="row mt20">
			<div class="col-md-3">

				<div class="card card-style mt20">
					<div class="card-body p20 pt5 pb5 mb20">

						<h6 class="mt20 mb20">Top Keywords</h6>
						<div style="padding-right: 10px !important;">
							<input type="search"
								class="form-control stylesearch mb20 inputportfolio2 searchkeywords"
								placeholder="Search Keyword" /> <i
								class="fas fa-search searchiconinputothers"></i> <i
								class="fas fa-times searchiconinputclose cursor-pointer resetsearch"></i>
						</div>
						<!-- <h6 class="card-title mb0">Maximum Influence</h6> -->
						<!-- <h4 class="mt20 mb0">Technology</h4> -->

						<!-- <small class="text-success pb10 ">+5% from <b>Last Week</b>

    </small> -->		<div style="height: 250px; padding-right: 10px !important;" id="scroll_list_loader" class="">
							<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />
						</div>
						<div id="scroll_list" class="hidden scrolly"
							style="height: 250px; padding-right: 10px !important;">


							<%
								/* 								if (sortedterms.length() > 0) {																	
																						for (int i=0; i<sortedterms.length(); i++) {
																							String[] vals = sortedterms.get(i).toString().split("___");
																							String size = vals[0];
																							String tm = vals[1];
																							String terms_id = vals[2];
																							
																							if(!termstore.has(tm)){
																								termstore.put(tm, tm);
																							
																								String dselected = "";
																								if(i==0){
																									dselected = "abloggerselected";
																									//mostactiveterm = tm;
																									selectedkeycount = term.getTermOcuurence(tm, dt, dte);;
																								} */

										/* BY SEUN--BEGINNING */
										Integer keyword_count = null;
										String top_location = null;
										Object json_type_2 = null;

										if (null == session.getAttribute(tid.toString())) {
							%>

							<%-- loadKeywordDashboard(null, "<%=ids%>"); --%>
							<%
								} else {
											json_type_2 = (null == session.getAttribute(tid.toString()))
													? ""
													: session.getAttribute(tid.toString());

											System.out.println("session obj" + json_type_2);

											Map<String, Integer> json = (HashMap<String, Integer>) json_type_2;

											Map.Entry<String, Integer> entry1 = json.entrySet().iterator().next();

											keyword_count = entry1.getValue();
											mostactiveterm = entry1.getKey();
											String dselected = "";
											String selectedid="";
											String activew = "";
											int k = 1;
													

											for (Map.Entry<String, Integer> entry : json.entrySet()) {
												
											if(k == 1){
												dselected = "abloggerselected";
												activew = "thanks";
											}else{
												dselected = "";
												activew = "";
											}
							%>	




							<%-- <a
								class="btn btn-primary form-control select-term bloggerinactive mb20 <%=dselected%> size-<%=size%>"
							id="<%=tm.replaceAll(" ","_")%>***<%=terms_id%>"><b><%=tm%></b></a> --%>
							<a	
								name="<%=entry.getKey()%>"
								class="topics topics1 btn btn-primary form-control select-term bloggerinactive mb20  size-1 <%=activew%>"
								value="<%=entry.getValue()%>"><b><%=entry.getKey()%></b></a>
							<%
							k++;
								}
										}
										/* 	}
										  }
										}	 */

										Integer blog_mentioned = post._getBlogOrPostMentioned("blogsite_id", mostactiveterm, dt, dte, ids);
										System.out.println(dt + dte + ids);

										try {
											top_location = post._getMostLocation(mostactiveterm, dt, dte, ids);
											top_location =(null == top_location || "" == top_location) ? "NOT AVAILABLE" : top_location;

										} catch (Exception e) {

										}
										top_location =(null == top_location || "" == top_location) ? "NOT AVAILABLE" : top_location;
										/* Integer post_mentioned=post._getBlogOrPostMentioned("post","care",dt, dte,ids); */
							%>
							<!-- BY SEUN--ENDING -->

						</div>
					</div>
				</div>
			</div>

			<div class="col-md-9">
				<div class="card card-style mt20">
					<div class="card-body  p30 pt5 pb5">
						<div style="min-height: 250px;">
							<div>
								<p class="text-primary mt10 float-left">
									Keyword Trend
									<!-- of Past <select
										class="text-primary filtersort sortbytimerange"><option
											value="week">Week</option>
										<option value="month">Month</option>
										<option value="year">Year</option></select> -->
								</p>
							</div>
							<div id="main-chart">
							  <div id="chart-container">
									<div class="chart-container">
										<!-- <div class="chart" id="d3-line-basic"></div>  -->
										
										<div id="line_graph_loader" class="hidden">
											<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />
										</div>
			  
			  
			  							 <div class="chart line_graph" id="chart"></div>
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
								<h6 class="card-title mb0">Blog Mentioned</h6>
								<%-- <h2 class="mb0 bold-text blog-mentioned"><%=NumberFormat.getNumberInstance(Locale.US).format(new Integer(blogmentioned))%>
								</h2> --%>
								<h2 class="mb0 bold-text blog-mentioned"><%=NumberFormat.getNumberInstance(Locale.US).format(new Integer(blog_mentioned))%></h2>
								<!-- <small class="text-success">+5% from <b>Last Week</b></small> -->
							</div>

							<div class="col-md-3 mt5 mb5">
								<h6 class="card-title mb0">Keyword Count</h6>
								<h2 class="mb0 bold-text keyword-count"><%=NumberFormat.getNumberInstance(Locale.US).format(new Integer(keyword_count))%></h2>
								<!-- <small class="text-success">+5% from <b>Last Week</b></small> -->
							</div>

							<div class="col-md-3 mt5 mb5">
								<h6 class="card-title mb0">Posts Mentioned</h6>
								<h2 class="mb0 bold-text post-mentioned">
									<%-- <%=post_mentioned%> --%>
								</h2>
								<!-- <small class="text-success">+5% from <b>Last Week</b></small> -->
							</div>

							<div class="col-md-3 mt5 mb5">
								<h6 class="card-title mb0">Top Posting Location</h6>

								<h3 class="mb0 bold-text top-location"><%=(null == top_location || "" == top_location) ? "NOT AVAILABLE" : top_location%></h3>
								<!-- <small class="text-success">+5% from <b>Last Week</b></small> -->
							</div>


						</div>
					</div>
				</div>
			</div>
		</div>

		<!-- <div class="row mb0 d-flex align-items-stretch">
  <div class="col-md-12 mt20 ">
    <div class="card card-style mt20">
      <div class="card-body p10 pt20 pb5">

        <div style="min-height: 420px;">
      <p class="text-primary">Top keywords of <b>Past Week</b></p>
<div id="networkgraph"></div>

        </div>
          </div>
    </div>
  </div>

</div> -->

		<div id="combined-div">

			<div class="row m0 mt20 mb0 d-flex align-items-stretch">
				<div
					class="col-md-6 mt20 card card-style nobordertopright noborderbottomright"
					id="post-list">
					<div class="card-body p0 pt20 pb20" style="min-height: 420px;">
						<p>
							Posts that mentioned <b class="text-green active-term"><%=mostactiveterm%></b>
						</p>
						<!--  <div class="p15 pb5 pt0" role="group">
          Export Options
          </div> -->
						<%
							System.out.println("values1--" + mostactiveterm + "NOBLOGGER" + "," + dt + "," + dte + "," + ids);
									JSONObject sql = post._getBloggerPosts(mostactiveterm, "NOBLOGGER", dt, dte, ids);

									JSONObject firstpost = new JSONObject();
									/*if(allposts.size()>0){ */

									if (sql.getJSONArray("data").length() > 0) {
										String perma_link = null;
										String j = null;
										String title = null;
										String blogpost_id = null;
										String date = null;
										String num_comments = null;
										String blogger = null;
										String posts = null;
										Integer occurence = null;
						%>
						<table id="DataTables_Table_2_wrapper" class="display"
							style="width: 100%">
							<thead>
								<tr>
									<th>Post title</th>
									<th>Occurence</th>
								</tr>
							</thead>
							<tbody>
								<%
									String tres = null;
												JSONObject tresp = null;
												String tresu = null;
												JSONObject tobj = null;

												int k = 0;

												/* for(int i=0; i< allposts.size(); i++){
													tres = allposts.get(i).toString();	
													tresp = new JSONObject(tres);									
													tresu = tresp.get("_source").toString();
													tobj = new JSONObject(tresu); */

												String sql_ = sql.get("data").toString();
												for (int i = 0; i < sql.getJSONArray("data").length(); i++) {
													Object jsonArray = sql.getJSONArray("data").get(i);

													j = jsonArray.toString();
													JSONObject j_ = new JSONObject(j);
													perma_link = j_.get("permalink").toString();
													title = j_.get("title").toString();
													blogpost_id = j_.get("blogpost_id").toString();
													date = j_.get("date").toString();
													num_comments = j_.get("num_comments").toString();
													blogger = j_.get("blogger").toString();
													posts = j_.get("post").toString();
													occurence = (Integer) j_.get("occurence");

													DateTimeFormatter inputFormatter = DateTimeFormatter
															.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.ENGLISH);
													DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("dd-MM-yyy",
															Locale.ENGLISH);
													LocalDate date_ = LocalDate.parse(date, inputFormatter);
													Integer d = date_.getYear();
													/* String formattedDate = outputFormatter.format(date); */
													System.out.println(d.toString());

													String replace = "<span style=background:red;color:#fff>" + mostactiveterm + "</span>";
													String active2 = mostactiveterm.substring(0, 1).toUpperCase()
															+ mostactiveterm.substring(1, mostactiveterm.length());
													String active3 = mostactiveterm.toUpperCase();

													System.out.println("mostactiveterms--="+mostactiveterm);
													
													posts = posts.replace(mostactiveterm, replace);
													posts = posts.replace(active2, replace);
													posts = posts.replace(active3, replace);

													title = title.replace(mostactiveterm, replace);
													title = title.replace(active2, replace);
													title = title.replace(active3, replace);

													/* 	LocalDate datee = LocalDate.parse(date);
														DateTimeFormatter dtf = DateTimeFormatter.ofPattern("MMM dd, yyyy");
														date = dtf.format(datee); */

													/* BY SEUN ENDING */
								%>
								<tr>
									<td><a class="blogpost_link cursor-pointer blogpost_link"
										id="<%-- <%=tobj.get("blogpost_id")%> --%><%=blogpost_id%>">
											<%-- <%=tobj.get("title") %> --%><%=title%></a><br /> <a
										class="mt20 viewpost makeinvisible"
										href="<%-- <%=tobj.get("permalink") %> --%><%=perma_link%>"
										target="_blank"> <buttton
												class="btn btn-primary btn-sm mt10 visitpost">Visit
											Post &nbsp;<i class="fas fa-external-link-alt"></i></buttton>
									</a></td>
									<td align="center">
										<%-- <%=(bodyoccurencece) %> --%><%=occurence%></td>
								</tr>
								<%
									}
								%>
								</tr>
							</tbody>
						</table>
						<%-- <% System.out.println("dd--"+title+blogpost_id+date+num_comments+blogger);} %> --%>
					</div>

				</div>

				<div
					class="col-md-6 mt20 card card-style nobordertopleft noborderbottomleft">

					<div style="" class="pt20" id="blogpost_detail">
						<%
							/* JSONObject tobj = firstpost;
													String title = tobj.get("title").toString().replaceAll("[^a-zA-Z]", " ");
													String body = tobj.get("post").toString().replaceAll("[^a-zA-Z]", " ");
													String dat = tobj.get("date").toString().substring(0,10);
													LocalDate datee = LocalDate.parse(dat);
													DateTimeFormatter dtf = DateTimeFormatter.ofPattern("MMM dd, yyyy");
													String date = dtf.format(datee);
													String replace = 	"<span style=background:red;color:#fff>"+mostactiveterm+"</span>";
													String link = tobj.get("permalink").toString();
													
													String maindomain="";
													try {
														URI uri = new URI(link);
														String domain = uri.getHost();
														if (domain.startsWith("www.")) {
															maindomain = domain.substring(4);
														} else {
															maindomain = domain;
														}
													} catch (Exception ex) {}
													System.out.println("dd--"+title+blogpost_id+date+num_comments+blogger);
													
													title = title.replaceAll(mostactiveterm,replace);
													String active2 = mostactiveterm.substring(0,1).toUpperCase()+mostactiveterm.substring(1,mostactiveterm.length());
													String active3= mostactiveterm.toUpperCase();
													
													
													title = title.replaceAll(mostactiveterm,replace);
													title = title.replaceAll(active2,replace);
													title = title.replaceAll(active3,replace);
													
													
													body = body.replaceAll(mostactiveterm,replace);
													body = body.replaceAll(active2,replace);
													body = body.replaceAll(active3,replace); */
						%>
						<h5 class="text-primary p20 pt0 pb0">
							<%-- <%=title%> --%><%=title%></h5>
						<div class="text-center mb20 mt20">
							<%-- <a href="<%=request.getContextPath()%>/bloggerportfolio.jsp?tid=<%=tid.toString()%>&blogger=<%=tobj.get("blogger")%>">
							<button class="btn stylebuttonblue">
								--%>
							<button class="btn stylebuttonblue"
								onclick="window.location.href = '<%=request.getContextPath()%>/bloggerportfolio.jsp?tid=<%=tid%>&blogger=<%-- <%=tobj.get("blogger")%> --%><%=blogger%>'">
								<b class="float-left ultra-bold-text"> <%-- <%=tobj.get("blogger")%> --%><%=blogger%></b>
								<i class="far fa-user float-right blogcontenticon"></i>
							</button>
							</a>
							<button class="btn stylebuttonnocolor nocursor">
								<%-- <%=date %> --%><%=date%></button>
							<button class="btn stylebuttonnocolor nocursor">
								<b class="float-left ultra-bold-text"> <%-- <%=tobj.get("num_comments")%> --%><%=num_comments%>
									comments
								</b><i class="far fa-comments float-right blogcontenticon"></i>
							</button>
						</div>
						<div style="height: 600px;">
							<div class="p20 pt0 pb20  text-primary"
								style="height: 550px; overflow-y: scroll;">
								<%-- <%=body%> --%>
								<p><%=posts%></p>
							</div>
						</div>
						<%
							System.out
												.println("dd--" + title + blogpost_id + date + num_comments + blogger + mostactiveterm);
									}
						%>

					</div>
				</div>
			</div>
		</div>

		<div class="row mb50 d-flex align-items-stretch">
			<div class="col-md-12 mt20 ">
				<div class="card card-style mt20">
					<div class="card-body p10 pt20 pb5">

						<div style="min-height: 420px;">
							<!-- <p class="text-primary">Top keywords of <b>Past Week</b></p> -->
							<!-- <div class="p15 pb5 pt0" role="group">
          Export Options
              </div> -->
							<table id="DataTables_Table_1_wrapper" class="display"
								style="width: 100%">
								<thead>
									<tr>
										<th>Keyword</th>
										<th>Frequency</th>
										<th>Post Count</th>
										<th>Blog Count</th>
										<!-- <th>Keyword Count</th> -->
										<!-- <th>Leading Blogger</th>
										<th>Language</th>
										<th>Location</th> -->

									</tr>
								</thead>
								<tbody id="tbody" class="termtable">
									<%
										if (null != session.getAttribute(tid.toString())) {
													/* for (int i = 0; i < topterms.length(); i++) {
														JSONObject jsonObj = topterms.getJSONObject(i);
														int size = 10;
														/* int size = Integer.parseInt(jsonObj.getString("frequency")); */
													/*String terms = jsonObj.getString("key");
													String postcount = post._searchTotalByTitleAndBody(terms,"date", dt,dte);
													String blogcount = post._searchTotalAndUnique(terms,"date", dt,dte,"blogsite_id");
													String bloggercount = post._searchTotalAndUnique(terms,"date", dt,dte,"blogger");
													String language = jsonObj.getString("language");//jsonObj.getString("language");
													String location = jsonObj.getString("location");
													String blogger = jsonObj.getString("leadingblogger");										
													int keycount = term.getTermOcuurence(terms, dt, dte); */

													//mostactiveterm = keys_.next();
													String t_ = null;
													Integer blog_mentioned_ = null;

													//System.out.println("keys2--"+keys_.hasNext());

													for (int i = 0; i < 50; i++) {
														/* while(keys_.hasNext()) { */

														//System.out.println("values2--"+key+"NOBLOGGER"+","+json.get(key)+","+dt+","+ dte+","+ids);
														/* try{
															JSONObject t = post._getBloggerPosts(key,"NOBLOGGER",dt, dte,ids);
															t_ = t.get("total").toString();
															blog_mentioned_ = post._getBlogOrPostMentioned("blogsite_id",key,dt, dte,ids);
															top_location=post._getMostLocation(key,dt, dte,ids);
														}
														catch(Exception e){
															
														} */
									%>
									<tr>
										<td>
											<%-- <%=terms%> --%> <%-- <%=key %> --%>
										</td>
										<%-- <td><%=NumberFormat.getNumberInstance(Locale.US).format(size)%></td> --%>
										<td>
											<%-- <%=NumberFormat.getNumberInstance(Locale.US).format(Integer.parseInt(postcount)) %>--%>
											<%-- <%=json.get(key) %> --%> <%-- <sub>of <%=postcount%></sub> --%>
										</td>
										<td>
											<%-- <%=NumberFormat.getNumberInstance(Locale.US).format(Integer.parseInt(blogcount))%> --%>
											<%-- <%=t_ %> --%> <%-- <sub>of <%=blogcount%></sub> --%>
										</td>
										<td>
											<%-- <%=NumberFormat.getNumberInstance(Locale.US).format(keycount)%> --%>
											<%-- <%=blog_mentioned_ %> --%> <%-- <sub>of <%=bloggercount%></sub> --%>
										</td>
										<%-- <td><%=blogger%></td>
										<td><%=language%></td>
										<td><%=location%></td> --%>

									</tr>
									<%
										}
												}
									%>


								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>

		</div>

	</div>



	<form action="" name="customform" id="customform" method="post">
		<input type="hidden" id="term" value="<%=mostactiveterm%>" /> <input
			type="hidden" id="date_start" value="<%=dt%>" /> <input
			type="hidden" id="term_id" value="<%=mostactiveterm_id%>" /> <input
			type="hidden" id="tid" value="<%=tid%>" /> <input type="hidden"
			id="date_end" value="<%=dte%>" /> <input type="hidden"
			id="all_blog_ids" value="<%=ids%>" /> <input type="hidden"
			id="SUCCESS" class="SUCCESS" value="" />

	</form>





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
	<script src="pagedependencies/baseurl.js?v=38"></script>

	<script>
$(document).ready(function() {
	loadMostPost("<%=mostactiveterm%>");
});


$(document).ready(function() {
	<%if (null == session.getAttribute(tid.toString() + "_termtable")) {%>
		  // keywords have not been computed.
		loadtermTableBulk();
		<%} else {
			
									Object data_table = (null == session.getAttribute(tid.toString() + "_termtable"))
								? ""
								: session.getAttribute(tid.toString() + "_termtable");

						System.out.println("session obj" + data_table);%>
		  // Keywords have been computed
		  updateTable(<%=data_table%>);
		  
		<%}%>
		
});
</script>

	<script>
		$(document).ready(function () {
			

			$('#DataTables_Table_0_wrapper').DataTable({
				"scrollY": 430,

				"pagingType": "simple"
				/*   ,
			 dom: 'Bfrtip'
		   ,
		 buttons:{
		   buttons: [
			   { extend: 'pdfHtml5',orientation: 'potrait', pageSize: 'LEGAL', className: 'btn-primary stylebutton1'},
			   {extend:'csv',className: 'btn-primary stylebutton1'},
			   {extend:'excel',className: 'btn-primary stylebutton1'},
			  // {extend:'copy',className: 'btn-primary stylebutton1', text: 'Copy to Clipboard'},
			   {extend:'print',className: 'btn-primary stylebutton1'},
		   ]
		 } */
			});

			$('#DataTables_Table_2_wrapper').DataTable({
				"scrollY": 480,

				"pagingType": "simple",
				"order": [[1, "desc"]]
				/*  ,
			 dom: 'Bfrtip'
		   ,
		 buttons:{
		   buttons: [
			   { extend: 'pdfHtml5',orientation: 'potrait', pageSize: 'LEGAL', className: 'btn-primary stylebutton1'},
			   {extend:'csv',className: 'btn-primary stylebutton1'},
			   {extend:'excel',className: 'btn-primary stylebutton1'},
			  // {extend:'copy',className: 'btn-primary stylebutton1', text: 'Copy to Clipboard'},
			   {extend:'print',className: 'btn-primary stylebutton1'},
		   ]
		 } */
			});
		});
	</script>
	<!--end for table  -->
	<script>
		$(document).ready(function () {

			$('#printdoc').on('click', function () {
				print();
			});
			$(document)
				.ready(
					function () {
						var cb = function (start, end, label) {
							//console.log(start.toISOString(), end.toISOString(), label);
							$('#reportrange span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
							$('#reportrange input').val(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY')).trigger('change');
						};

						var optionSet1 =
						{
							startDate: moment().subtract(29, 'days'),
							endDate: moment(),
							minDate: '01/01/1947',
							linkedCalendars: false,
							maxDate: moment(),
							showDropdowns: true,
							showWeekNumbers: true,
							timePicker: false,
							timePickerIncrement: 1,
							timePicker12Hour: true,
							dateLimit: { days: 50000 },
							ranges: {

								'This Year': [
									moment()
										.startOf('year'),
									moment()],
								'Last Year': [
									moment()
										.subtract(1, 'year').startOf('year'),
									moment().subtract(1, 'year').endOf('year')]
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
						//  $('#reportrange span').html(moment().subtract( 500, 'days').format('MMMM D, YYYY') + ' - ' + moment().format('MMMM D, YYYY'))
						$('#reportrange, #custom').daterangepicker(optionSet1, cb);
						$('#reportrange')
							.on(
								'show.daterangepicker',
								function () {
									/* 	console
												.log("show event fired"); */
								});
						$('#reportrange')
							.on(
								'hide.daterangepicker',
								function () {
									/* console
											.log("hide event fired"); */
								});
						$('#reportrange')
							.on(
								'apply.daterangepicker',
								function (ev, picker) {
									/* console
											.log("apply event fired, start/end dates are "
													+ picker.startDate
															.format('MMMM D, YYYY')
													+ " to "
													+ picker.endDate
															.format('MMMM D, YYYY')); */
									var start = picker.startDate.format('YYYY-MM-DD');
									var end = picker.endDate.format('YYYY-MM-DD');
									$("#date_start").val(start);
									$("#date_end").val(end);
									$("form#customform").submit();
								});
						$('#reportrange')
							.on(
								'cancel.daterangepicker',
								function (ev, picker) {
									/* console
											.log("cancel event fired"); */
								});
						$('#options1').click(
							function () {
								$('#reportrange').data(
									'daterangepicker')
									.setOptions(
										optionSet1,
										cb);
							});
						$('#options2').click(
							function () {
								$('#reportrange').data(
									'daterangepicker')
									.setOptions(
										optionSet2,
										cb);
							});
						$('#destroy').click(
							function () {
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
	<script type="text/javascript" src="assets/vendors/d3/d3_tooltip.js"></script>
	
	
	
	
	
	
	
	
	<script>
    
 /////////////////////////////////////////////////////
 
 
 //////start time converting function
 	
 function convertTime(str) {
  var date = new Date(str);
  return [date.getFullYear()];
}
 
 
 ///////end time converting function
    
 
    var uche = [];
     
    

    function color1(i, id, name){
    	
    	var t = parseFloat(i);

    switch(t) {

      //case 0:
        //var hex = 'yellow';
      case 1:
        var hex = 'green'; 
        break;
      case 2:
        var hex = '#c18fb6';
        break;
      case 3:
        var hex = '#8fc199';
        break;
      case 4:
        var hex = '#c1958f';
        break;
      case 5:
        var hex = '#e17d70';
        break;
      case 6:
        var hex = '#b770e1';
        break;
      case 7:
        var hex = '#1fa701';
        break;
      case 8:
        var hex = '#011aa7';
        break;
      case 9:
        var hex = '#a78901';
        break;
      case 10:
        var hex = '#981010';
        break;
      default:
        var hex = 'red';

    }


    
    $('.thanks').each(function() {
    	
    	var g = $(this).attr('name');
    	
        if ( $(this).attr('name') == ''+name+'' ) {
        	$(this).css('background-color', hex);
        };
        
    });
    return hex;


    }


    //////////////////////////////////////////////////////////////
    
    $(document).ready(function(){
    	
    	$('.line_graph').addClass('hidden');
        $('#line_graph_loader').removeClass('hidden');
        
        
    	  setTimeout(
     			  function() 
     			  { 
           finalGraph();
        }, 1000)
    });
    
    
    $(document).delegate('.topics1', 'click', function(){

        var id = this.id;
        var name = $(this).attr('name');
        
       $('.line_graph').addClass('hidden');
       $('#line_graph_loader').removeClass('hidden');
       
       $("#scroll_list_loader").removeClass("hidden");
   	   $("#scroll_list").addClass("hidden");
       
       $('#chart').html('');

       if ( $(this).hasClass("thanks") ) {
            
          $(this).removeClass("thanks"); 

          $(this).addClass('nobccolor');


        }else{

          $(this).removeClass('nobccolor');

          $(this).addClass("thanks"); 
          

        }

      	
       setTimeout(
 			  function() 
 			  { 
       finalGraph();
    }, 2000)
      
      

      })
      
    
      
    
   function finalGraph(){
    	
    	var data1 = [];
    	
    	var data = [];
    	
    	var highest_date_index = 0;
   		var highest_price_index = 0;
   		
   		var highest_date_name = '';
   		var highest_price_name = '';
    		
  		var highest_date = 0;
  		var highest_price = 0;
  		
    	
    	 var count = $('.thanks').length;
    	 
   
    	 
    	 if(count > 0){
    		
    		 
///////////////start collecting names
    		 var county = $('.thanks').length;
    		 
    		 if(county > 0){
    			 
    			 var all_selected_names = '';
    			 var i = 1;
    			 $( ".thanks" ).each(function( index ) {
    				 
    				 
    				 if(i > 1){
    					 all_selected_names += ' , ';
    				 }
    				 
    		    	blog_name = $(this).attr('name');
    		    	
    		    	
    		    	all_selected_names += '"'+blog_name+'"';
    		    	
/*     		    	all_selected_names += '"'+blog_name+'"';
    		    	all_selected_names1 += blog_name; */
    		    	
    		    		
    		    	i++;
    			    		
    			});
    			 
    			 
    		 }
    		////////////end collecting names
    		 
    		 
    		 
    		 
    		 $( ".thanks" ).each(function( index ) {
    			 
       		  		var ind = index;
       		  		
    		    	name = 	$(this).attr('name');
    		    	
    		    	id = 	$(this).attr('value');
    		    	
    		    	
    		    		
    		    		
    		    ////start ajax
    		    	
    		    	$.ajax({
    		    		url : app_url + "KeywordTrend1",
    					method : 'POST',
    					dataType:'json',
    					data : {
    						action : "line_graph",
    						term : name,
    						all_selected_names : all_selected_names,
    						index:ind,
    						async: false,
    						all_blog_ids : $("#all_blog_ids").val(),
    						date_start : $("#date_start").val(),
    						date_end : $("#date_end").val(),
    					},
    		  			error: function(response)
    		  			{						
    		  				alert('error');
    		  				console.log(response);
    		  			//	$("#chart-container").html(response);
    		  			},
    		  			success: function(response)
    		  			{   
    		  				console.log('before response');
    		  				console.log(response)
    		  				var arr1 = [];
    		    		  	
    		  				$.each(response.values, function( key, value ) {
    		  					
        		  				
    		  					var d = parseFloat(key);
    		  					var p = parseFloat(value);
    		  					
    		  					if(d > highest_date){
    		  						highest_date = key;
    		  						highest_date_index = response.index;
    		  						highest_date_name = response.name;
    		  						
    		  						
    		  						
    		  					}
    		  					
    		  					if(p > highest_price){
    		  						highest_price = value;
    		  						highest_price_index = response.index;
    		  						highest_price_name = response.name;
    		  						
    		  					}
    		  					
    		  					
    		  					var string2 = key.toString();
    		  				
    		  					var string3 = value.toString();
    		  				
    		  					arr1.push({date: string2 ,close: string3, name:response.name});
    		  					
    			  				
    				  		});
    		  				
    		  				
    		  				data1.push(
		  						      
		  						      {
		  						    	name: response.name,
		  						      	identify: id,
		  						        values: 
		  						          
		  						        	  arr1
		  						        	
		  						      }
		  						    );
    		  				
    		  				
    						
    						/* console.log("arr--"+d+"--"+JSON.parse(JSON.stringify(array))); */
    						/* d=response; */
    						//for(var key in response){
    							
    							//var dic = Object.create(null);

    						//	dic.date=key;
    						//	dic.close=response[key];
    						//	dic.name=name;

    						//	array.push(dic);

    						//}
    						//array_2=[];
    						//array_2.push(array);
    						//console.log("ddddddd");
    						//console.log(array_2);
    						
    		  				
    		    	
    				  			}
    		  			
    		  			
    		  			
    				  		});
    		    	
    		  
    		    ///////end ajax
    		    		
    		    		});
    		 
    		 
    		 	
    		 
    	    	var longt = 0;
    	    	
    	    	  setTimeout(
    	    			  function() 
    	    			  {
    	    				  console.log('check this ');
    	    	    		 	console.log(data1);
    	    	    		 	
    	    				  data1.forEach((arrayItem) => {
    	    				    data.push(arrayItem)
    	    				    
    	    				    
    	    				    

    	    				    
    	    				  });
    	    				  
    	    			/////////start graph stuff
    	    				indexy = data.findIndex(x => x.name === highest_date_name);
	    				    
	    				    console.log(data);
      	    				
  				 			//var width = 750;
  				 			var width = $('#chart-container').width();
  				 		    var height = 200;
  				 		    var margin = 30;
  				 		    var duration = 250;

  				 		    var lineOpacity = "0.25";
  				 		    var lineOpacityHover = "0.85";
  				 		    var otherLinesOpacityHover = "0.1";
  				 		    var lineStroke = "1.5px";
  				 		    var lineStrokeHover = "2.5px";

  				 		    var circleOpacity = '0.85';
  				 		    var circleOpacityOnLineHover = "0.25"
  				 		    var circleRadius = 3;
  				 		    var circleRadiusHover = 6;


  				 		    /* Format Data */
  				 		    var parseDate = d3.time.format("%Y").parse;
  				 		    data.forEach(function(d, i) {
  				 		    	
  				 		      d.values.forEach(function(d) {
  				 		        d.date = parseDate(d.date);
  				 		        d.close = +d.close;    
  				 		      });
  				 		      
  				 		    });


  				 		    /* Scale */
  				 		    var xScale = d3.time.scale()
  				 		   // var xScale = d3.scaleTime()
  				 		      .domain(d3.extent(data[indexy].values, d => d.date))
  				 		      .range([0, width-margin]);

  				 		   //var yScale = d3.scaleLinear()
				 		      //.domain([0, d3.max(data[highest_price_index].values, d => d.price)])
				 		     // .range([height-margin, 0]);
  				 		   
  				 		    var yScale = d3.scale.linear()
  				 		      .domain([0, highest_price])
  				 		      .range([height-margin, 0]);
  				 		  
  				 		     

  				 		    var color = d3.scale.ordinal(d3.schemeCategory10);

  				 		    /* Add SVG */
  				 		    var svg = d3.select("#chart").append("svg")
  				 		      .attr("width", (width+margin)+"px")
  				 		      .attr("height", (height+margin)+"px")
  				 		      .append('g')
  				 		      .attr("transform", `translate(${margin}, ${margin})`);


  				 		    /* Add line into SVG */
  				 		    var line = d3.svg.line()
  				 		      .x(d => xScale(d.date))
  				 		      .y(d => yScale(d.close));

  				 		    let lines = svg.append('g')
  				 		      .attr('class', 'lines');


  				 		    lines.selectAll('.line-group')
  				 		      .data(data).enter()
  				 		      .append('g')
  				 		      .attr('class', 'line-group')  
  				 		      .on("mouseover", function(d, i) {
  				 		    	  
  				 		          svg.append("text")
  				 		            .attr("class", "title-text")
  				 		            .style("fill", color1(i, d.identify, d.name))        
  				 		            .text(d.name)
  				 		            .attr("text-anchor", "middle")
  				 		            .attr("x", (width-margin)/2)
  				 		            .attr("y", 5);
  				 		        })
  				 		      .on("mouseout", function(d) {
  				 		          svg.select(".title-text").remove();
  				 		        })
  				 		      .append('path')
  				 		      .attr('class', 'line')  
  				 		      .attr('d', d => line(d.values))
  				 		      .style('stroke', (d, i) => color1(i, d.identify, d.name))
  				 		      .style('opacity', lineOpacity)
  				 		      .on("mouseover", function(d) {
  				 		          d3.selectAll('.line')
  				 		              .style('opacity', otherLinesOpacityHover);
  				 		          d3.selectAll('.circle')
  				 		              .style('opacity', circleOpacityOnLineHover);
  				 		          d3.select(this)
  				 		            .style('opacity', lineOpacityHover)
  				 		            .style("stroke-width", lineStrokeHover)
  				 		            .style("cursor", "pointer");
  				 		        })
  				 		      .on("mouseout", function(d) {
  				 		          d3.selectAll(".line")
  				 		              .style('opacity', lineOpacity);
  				 		          d3.selectAll('.circle')
  				 		              .style('opacity', circleOpacity);
  				 		          d3.select(this)
  				 		            .style("stroke-width", lineStroke)
  				 		            .style("cursor", "none");
  				 		        });


  				 		    /* Add circles in the line */
  				 		    lines.selectAll("circle-group")
  				 		      .data(data).enter()
  				 		      .append("g")
  				 		      .style("fill", (d, i) => color1(i, d.identify, d.name))
  				 		     
  				 		      .selectAll("circle")
  				 		       
  				 		      .data(d => d.values).enter()
  				 		      .append("g")
  				 		      .attr("class", "circle") 
  				 		      
  				 		      
  				 		      .on("click",function(d){
  				 		    	 
  				 		       var tempYear = convertTime(d.date);
                        	   var d1 = 	  tempYear + "-01-01";
                        	   var d2 = 	  tempYear + "-12-31";
                        	 
                        	   bloog = d.name.replaceAll("__"," ");
                        		
                        	   $('.activeblogger').html(bloog);
                        	
                        	   getTopLocation(bloog,$("#all_blog_ids").val(),d1,d2);
                        	   loadTerms(bloog,$("#all_blog_ids").val(),d1,d2);	
                        		loadSentiments(bloog,$("#all_blog_ids").val(),d1,d2);
                        		
                        	  // loadInfluence(d1,d2); 
                        	   
                           })
                           
                           
  				 		      .on("mouseover", function(d) {
  				 		          d3.select(this)     
  				 		            .style("cursor", "pointer")
  				 		            .append("text")
  				 		            .attr("class", "text d3-tip")
  				 		            .text(function(d) {
  				 		                if(d.close === 0)
  				 		                {
  				 		                  return "No Information Available";
  				 		                }
  				 		                else if(d.close !== 0) {
  				 		                 return d.close+"(Click for more information)";
  				 		                  }
  				 		                // return "here";
  				 		                })
  				 		            .attr("x", d => xScale(d.date) + 5)
  				 		            .attr("y", d => yScale(d.close) - 10);
  				 		        })
  				 		      .on("mouseout", function(d) {
  				 		          d3.select(this)
  				 		            .style("cursor", "none")  
  				 		            .transition()
  				 		            .duration(duration)
  				 		            .selectAll(".text").remove();
  				 		        })
  				 		      .append("circle")
  				 		      .attr("cx", d => xScale(d.date))
  				 		      .attr("cy", d => yScale(d.close))
  				 		      .attr("r", circleRadius)
  				 		      .style('opacity', circleOpacity)
  				 		      .on("mouseover", function(d) {
  				 		            d3.select(this)
  				 		              .transition()
  				 		              .duration(duration)
  				 		              .attr("r", circleRadiusHover);
  				 		          })
  				 		        .on("mouseout", function(d) {
  				 		            d3.select(this) 
  				 		              .transition()
  				 		              .duration(duration)
  				 		              .attr("r", circleRadius);  
  				 		          });


  				 		    /* Add Axis into SVG */
  				 		    //var xAxis = d3.svg.axis(xScale).ticks(9);
  				 		    //var yAxis = d3.svg.axis(yScale).ticks(6);
  				 		    
  				 		    
  				 		     // Construct scales
				          // ------------------------------
				
				          // Horizontal
				          var x = d3.scale.ordinal()
				              .rangeRoundBands([0, width]);
				
				          // Vertical
				          var y = d3.scale.linear()
				              .range([height, 0]);
				
				
				          // Create axes
				          // ------------------------------
				
				          // Horizontal
				          var xAxis = d3.svg.axis()
				              .scale(xScale)
				              .orient("bottom")
				             .ticks(5)
				
				            // .tickFormat(formatPercent);
				
				
				          // Vertical
				          var yAxis = d3.svg.axis()
				              .scale(yScale)
				              .orient("left")
				              .ticks(5);
				          
				          
				          ///////////////////

  				 		 //   svg.append("g")
  				 		    //  .attr("class", "x axis")
  				 		   //   .attr("transform", `translate(0, ${height-margin})`)
  				 		    //  .call(xAxis);

  				 		   // svg.append("g")
  				 		     // .attr("class", "y axis")
  				 		    //  .call(yAxis)
  				 		    //  .append('text')
  				 		     // .attr("y", 15)
  				 		     // .attr("transform", "rotate(-90)")
  				 		     // .attr("fill", "black")
  				 		     // .text("Total values");
  				 		    
  				 		    //////////////
  				 		    
  				 		    
  				 		    
  				 		    // Append axes
			              // ------------------------------
			
			              // Horizontal
			              svg.append("g")
			                  .attr("class", "x axis d3-axis d3-axis-horizontal d3-axis-strong")
			                  .attr("transform", `translate(0, ${height-margin})`)
			                  .call(xAxis);
			
			              // Vertical
			               svg.append("g")
			                  .attr("class", "y axis d3-axis d3-axis-vertical d3-axis-strong")
			                  .call(yAxis)
			                  .append('text')
			                  .attr("y", 15)
			                  .attr("fill", "black")
			              	  .text("Total values");
			              
			                  
  				 		    
  				 		    
  				 		    
  				 		    
  				 		    
  				 		
  				 	/////////end graph stuff	
    	    				  
    	    				 		   $('.line_graph').removeClass('hidden');
    	    				 	       $('#line_graph_loader').addClass('hidden');
    	    				  		
    	    				 	      $("#scroll_list_loader").addClass("hidden");
    	    				 	 	$("#scroll_list").removeClass("hidden");
    	    				 	       
    	    				  
    	    			  }, 3000)
    	    			  
    		 
    		 
    		 
    		 
    		 
    		 
    	 }else{
    		 alert("no active selection");
    	 }
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	

    	
    	
    }
    
    </script>
	
	
	
	
	
	
	
	
	
	
	<!--word cloud  -->
	<script>
		var color = d3.scale.linear()
			.domain([0, 1, 2, 3, 4, 5, 6, 10, 15, 20, 80])
			.range(["#17394C", "#F5CC0E", "#CE0202", "#aaa", "#999", "#888", "#777", "#666", "#555", "#444", "#333", "#222"]);

	</script>





	<script src="pagedependencies/baseurl.js?v=38"></script>

	<script src="pagedependencies/keywordtrends1.js?v=7831690"></script>

	<script>
		$(".blogger-mentioned").html("<%=alloccurence%>");
	</script>

</body>

</html>

<%
	}
	}
%>