<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%@page import="authentication.*"%>
<%@page import="java.util.*"%>
<%@page import="util.*"%>
<%@page import="java.io.File"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.net.URI"%>
<%@page import="java.text.NumberFormat" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>

<%@page import="org.apache.commons.lang3.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.time.LocalDateTime"%>
	
<%
	Object email = (null == session.getAttribute("email")) ? "" : session.getAttribute("email");
	Object tid = (null == request.getParameter("tid")) ? "" : request.getParameter("tid");

	Object user = (null == session.getAttribute("username")) ? "" : session.getAttribute("username");
	Object date_start = (null == request.getParameter("date_start")) ? "" : request.getParameter("date_start");
	Object date_end = (null == request.getParameter("date_end")) ? "" : request.getParameter("date_end");
	Object single = (null == request.getParameter("single_date")) ? "" : request.getParameter("single_date");
	String sort =  (null == request.getParameter("sortby")) ? "blog" : request.getParameter("sortby").toString().replaceAll("[^a-zA-Z]", " ");

	
	//System.out.println(date_start);
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
		String trackername="";
		if (detail.size() > 0) {
			//String res = detail.get(0).toString();
			ArrayList resp = (ArrayList<?>)detail.get(0);

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
					if (f.exists() && !f.isDirectory()) {
						profileimage = "images/profile_images/" + userinfo.get(2).toString() + ".jpg";
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
			
			String stdate = post._getDate(ids,"first");
			String endate = post._getDate(ids,"last");
			
			Date dstart = new Date();//SimpleDateFormat("yyyy-MM-dd").parse(stdate);
			Date today = new Date();//SimpleDateFormat("yyyy-MM-dd").parse(endate);


			Date nnow = new Date(); 
			try{
				dstart = new SimpleDateFormat("yyyy-MM-dd").parse(stdate);
			}catch(Exception ex){
				dstart = nnow;//new SimpleDateFormat("yyyy-MM-dd").parse(nnow);
			}
			
			try{
				today = new SimpleDateFormat("yyyy-MM-dd").parse(endate);
			}catch(Exception ex){
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
			String year_start="";
			String year_end="";
			
			if(!single.equals("")){
				month = MONTH_ONLY.format(nnow); 
				day = DAY_ONLY.format(nnow); 
				year = YEAR_ONLY.format(nnow); 
				//System.out.println("Now:"+month+"small:"+smallmonth);
				if(month.equals("02")){
					ddey = (Integer.parseInt(year)%4==0)?"28":"29";
				}else if(month.equals("09") || month.equals("04") || month.equals("05") || month.equals("11")){
					ddey = "30";
				}
			}
			//System.out.println(s)
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
			
			dispfrom = DATE_FORMAT.format(new SimpleDateFormat("yyyy-MM-dd").parse(dt));
			dispto = DATE_FORMAT.format(new SimpleDateFormat("yyyy-MM-dd").parse(dt));			
				
		} else if (single.equals("week")) {
			
			 dte = year + "-" + month + "-" + day;
			int dd = Integer.parseInt(day)-7;
			
			Calendar cal = Calendar.getInstance();
			cal.add(Calendar.DATE, -7);
			Date dateBefore7Days = cal.getTime();
			dt = YEAR_ONLY.format(dateBefore7Days) + "-" + MONTH_ONLY.format(dateBefore7Days) + "-" + DAY_ONLY.format(dateBefore7Days);
	
			dispfrom = DATE_FORMAT.format(new SimpleDateFormat("yyyy-MM-dd").parse(dt));
			dispto = DATE_FORMAT.format(new SimpleDateFormat("yyyy-MM-dd").parse(dte));					
		} else if (single.equals("month")) {
			dt = year + "-" + month + "-01";
			dte = year + "-" + month + "-"+day;	
			dispfrom = DATE_FORMAT.format(new SimpleDateFormat("yyyy-MM-dd").parse(dt));
			dispto = DATE_FORMAT.format(new SimpleDateFormat("yyyy-MM-dd").parse(dte));
		} else if (single.equals("year")) {
			dt = year + "-01-01";
			dte = year + "-12-"+ddey;
			dispfrom = DATE_FORMAT.format(new SimpleDateFormat("yyyy-MM-dd").parse(dt));
			dispto = DATE_FORMAT.format(new SimpleDateFormat("yyyy-MM-dd").parse(dte));

		}else {
			dt = dst;
			dte = dend;
			
		}  
		
				
		ArrayList allposts = new ArrayList();	
		
		
		
		String allpost = "0";
		String mostactiveterm="";
		String toplocation="";
		String mostactiveterm_id ="";
		
		
		JSONArray termscount = new JSONArray();
		
		JSONArray posttodisplay = new JSONArray();
		JSONObject years = new JSONObject();
		JSONArray yearsarray = new JSONArray();
		JSONObject locations = new JSONObject();
		

		JSONObject termsyears = new JSONObject();

		
		allterms = term._searchByRange("date", dt, dte, ids,"blogsiteid","50");
		
		int postmentioned=0;
		int blogmentioned=0;
		int bloggermentioned=0;
		
		int highestfrequency = 0;
		int highestpost =0;
		
		JSONArray topterms = new JSONArray();
		JSONObject keys = new JSONObject();
		if (allterms.size() > 0) {
			for (int p = 0; p < allterms.size(); p++) {
				String bstr = allterms.get(p).toString();
				JSONObject bj = new JSONObject(bstr);
				bstr = bj.get("_source").toString();
				bj = new JSONObject(bstr);
				String frequency = bj.get("frequency").toString();
				int freq = Integer.parseInt(frequency);
				
				
				
				String tm = bj.get("term").toString();
				String tmid = bj.get("id").toString();
				String blogpostid = bj.get("blogpostid").toString();
				
				if(freq>highestfrequency){
					highestfrequency = freq;
					//mostactiveterm = tm;
				}
				
				String postc = "0";
				String blogc="0";
				String bloggerc="0";
				String language="";
				String leadingblogger="";
				String location="";
				
				
					
				
				ArrayList postdetail = post._fetch(blogpostid);
				
				
				if(postdetail.size()>0){							
					String tres3 = null;
					JSONObject tresp3 = null;
					String tresu3 = null;
					JSONObject tobj3 = null;
					
					for(int j=0; j< 1; j++){
						tres3 = postdetail.get(j).toString();	
						tresp3 = new JSONObject(tres3);
						tresu3 = tresp3.get("_source").toString();
						tobj3 = new JSONObject(tresu3);
						
						leadingblogger = tobj3.get("blogger").toString();
						location = tobj3.get("location").toString();
						language = tobj3.get("language").toString();
					}
				}
				
				

				if(p==0){
					allposts =  post._searchByTitleAndBody(tm,"date", dt,dte);//term._searchByRange("date",dt,dte, tm,"term","10");
					toplocation = location;
					mostactiveterm = tm;
					mostactiveterm_id = tmid;
					
					postc = post._searchTotalAndUnique(tm,"date", dt,dte,"blogpost_id");//post._searchTotalByTitleAndBody(tm,"date", dt,dte);
					blogc = post._searchTotalAndUnique(tm,"date", dt,dte,"blogsite_id");
					bloggerc = post._searchTotalAndUnique(tm,"date", dt,dte,"blogger");//post._searchTotalAndUniqueBlogger(tm,"date", dt,dte,"blogger");
					System.out.println(bloggerc);
					postmentioned+=(Integer.parseInt(postc));
					blogmentioned+=(Integer.parseInt(blogc));
					bloggermentioned+=(Integer.parseInt(bloggerc));
					System.out.println(bloggermentioned);
					//postm   = post._searchByTitleAndBodyTotal(tm,"date",dt,dte);
				}
				
				JSONObject cont = new JSONObject();
				cont.put("key", tm);
				cont.put("id", tmid);
				cont.put("frequency", frequency);
				cont.put("postcount",postc);
				cont.put("blogcount",blogc);
				cont.put("bloggercount",bloggerc);
				cont.put("leadingblogger",leadingblogger);
				cont.put("language",language);
				cont.put("location",location);
				
				if(!keys.has(tm)){
					keys.put(tm,tm);
					topterms.put(cont);
					termscount.put(p, tm);
				}
			}
		}




		
		String[] yst = dt.split("-");
		String[] yend = dte.split("-");
		year_start = yst[0];
		year_end = yend[0];
		int ystint = Integer.parseInt(year_start);
		int yendint = Integer.parseInt(year_end);

		if(termscount.length()>0){
			for(int n=0; n<1;n++){
				int b=0;
				JSONObject postyear =new JSONObject();
				for(int y=ystint; y<=yendint; y++){ 
						   String dtu = y + "-01-01";
						   String dtue = y + "-12-31";
						   if(b==0){
								dtu = dt;
							}else if(b==yendint){
								dtue = dte;
							}
						   
						   String totu = post._searchTotalByTitleAndBody(mostactiveterm,"date", dtu,dtue);//term._searchRangeTotal("date",dtu, dtue,termscount.get(n).toString());
						   
						   if(!years.has(y+"")){
					    		years.put(y+"",y);
					    		yearsarray.put(b,y);
					    		b++;
					    	}
						   
						   postyear.put(y+"",totu);
				}
				termsyears.put(termscount.get(n).toString(),postyear);
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

<!--end of bootsrap -->
<script src="assets/js/jquery-3.2.1.slim.min.js"></script>
<script src="assets/js/popper.min.js"></script>
<script src="pagedependencies/googletagmanagerscript.js"></script>
</head>
<body>
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

		<!-- <div class="col-md-12 mt0">
          <input type="search" class="form-control p30 pt5 pb5 icon-big border-none bottom-border text-center blogbrowsersearch nobackground" placeholder="Search Trackers" />
          </div> -->

	</nav>
	<div class="container analyticscontainer">
		<div class="row bottom-border pb20">
			<div class="col-md-6 ">
				<nav class="breadcrumb">
  <a class="breadcrumb-item text-primary" href="<%=request.getContextPath()%>/trackerlist.jsp">Trackers</a>
  <a class="breadcrumb-item text-primary" href="<%=request.getContextPath()%>/edittracker.jsp?tid=<%=tid%>"><%=trackername%></a>
  <a class="breadcrumb-item active text-primary" href="<%=request.getContextPath()%>/dashboard.jsp?tid=<%=tid%>">Dashboard</a>
  <a class="breadcrumb-item active text-primary" href="<%=request.getContextPath()%>/postingfrequency.jsp?tid=<%=tid%>">Keyword Trend</a>
  </nav>
				<div>
					<button class="btn btn-primary stylebutton1 " id="printdoc">SAVE
						AS PDF</button>
				</div>
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
								class="form-control stylesearch mb20 inputportfolio2"
								placeholder="| Search Keyword" /> <i
								class="fas fa-search searchiconinputothers"></i> <i
								class="fas fa-times searchiconinputclose cursor-pointer"></i>
						</div>
						<!-- <h6 class="card-title mb0">Maximum Influence</h6> -->
						<!-- <h4 class="mt20 mb0">Technology</h4> -->

						<!-- <small class="text-success pb10 ">+5% from <b>Last Week</b>

    </small> -->
						<div class="scrolly"
							style="height: 250px; padding-right: 10px !important;">
							
									<%if (topterms.length() > 0) {
													
										for (int i = 0; i < topterms.length(); i++) {
											JSONObject jsonObj = topterms.getJSONObject(i);
											String terms = jsonObj.getString("key");
											String terms_id = jsonObj.getString("id");
											
											String dselected = "";
											if(i==0){
												dselected = "abloggerselected";
											}
																			
											%><a
											class="btn form-control select-term stylebuttoninactive opacity53 text-primary mb20 <%=dselected%>" id="<%=terms.replaceAll(" ","_")%>***<%=terms_id%>"><b><%=terms%></b></a>
											<%
										}
									}	
							%>


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
									Keyword Trend <!-- of Past <select
										class="text-primary filtersort sortbytimerange"><option
											value="week">Week</option>
										<option value="month">Month</option>
										<option value="year">Year</option></select> -->
								</p>
							</div>
							<div id="main-chart">
								<div class="chart-container">
									<div class="chart" id="d3-line-basic"></div>
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
								<h2 class="mb0 bold-text blog-mentioned"><%=NumberFormat.getNumberInstance(Locale.US).format(blogmentioned)%></h2>
								<!-- <small class="text-success">+5% from <b>Last Week</b></small> -->
							</div>

							<div class="col-md-3 mt5 mb5">
								<h6 class="card-title mb0">Bloggers Mentioned</h6>
								<h2 class="mb0 bold-text blogger-mentioned"><%=NumberFormat.getNumberInstance(Locale.US).format(bloggermentioned+1)%></h2>
								<!-- <small class="text-success">+5% from <b>Last Week</b></small> -->
							</div>
							
							<div class="col-md-3 mt5 mb5">
								<h6 class="card-title mb0">Posts Mentioned</h6>
								<h2 class="mb0 bold-text post-mentioned"><%=NumberFormat.getNumberInstance(Locale.US).format(postmentioned)%></h2>
								<!-- <small class="text-success">+5% from <b>Last Week</b></small> -->
							</div>

							<div class="col-md-3 mt5 mb5">
								<h6 class="card-title mb0">Top Posting Location</h6>
								<h3 class="mb0 bold-text top-location"><%=(toplocation==null)?"Not Available":toplocation%></h3>
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
			<div class="col-md-6 mt20 card card-style nobordertopright noborderbottomright" id="post-list">
				<div class="card-body p0 pt20 pb20" style="min-height: 420px;">
					<p>
						Posts that mentioned <b class="text-green active-term"><%=mostactiveterm%></b>
					</p>
					<!--  <div class="p15 pb5 pt0" role="group">
          Export Options
          </div> -->
          <%  
          JSONObject firstpost = new JSONObject();
          if(allposts.size()>0){	%>
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
								
									
									
									int k=0;
									for(int i=0; i< allposts.size(); i++){
										tres = allposts.get(i).toString();	
										tresp = new JSONObject(tres);
										
										tresu = tresp.get("_source").toString();
										tobj = new JSONObject(tresu);
										
										
												
												//System.out.println("postdet +"+tobj3);
												if(i==0){
													firstpost = tobj;
												}
												
												int bodyoccurencece = 0;//ut.countMatches(tobj3.get("post").toString(), mostactiveterm);
												
										        String str = tobj.get("post").toString()+" "+ tobj.get("post").toString();
												String findStr = mostactiveterm;
												int lastIndex = 0;
												//int count = 0;

												while(lastIndex != -1){

												    lastIndex = str.indexOf(findStr,lastIndex);

												    if(lastIndex != -1){
												        bodyoccurencece++;
												        lastIndex += findStr.length();
												    }
												}
									%>
                                    <tr>
                                   <td><a class="blogpost_link cursor-pointer blogpost_link" id="<%=tobj.get("blogpost_id")%>" ><%=tobj.get("title") %></a><br/>
								<a class="mt20 viewpost makeinvisible" href="<%=tobj.get("permalink") %>" target="_blank"><buttton class="btn btn-primary btn-sm mt10 visitpost">Visit Post &nbsp;<i class="fas fa-external-link-alt"></i></button></buttton></a>
								</td>
								<td align="center"><%=(bodyoccurencece+1) %></td>
                                     </tr>
                                    <% }%>
							</tr>						
						</tbody>
					</table>
					<% } %>
				</div>

			</div>

			<div class="col-md-6 mt20 card card-style nobordertopleft noborderbottomleft">

				<div style="" class="pt20" id="blogpost_detail">
					<%
                                if(firstpost.length()>0){	
									JSONObject tobj = firstpost;
									String title = tobj.get("title").toString().replaceAll("[^a-zA-Z]", " ");
									String body = tobj.get("post").toString().replaceAll("[^a-zA-Z]", " ");
									String dat = tobj.get("date").toString().substring(0,10);
									LocalDate datee = LocalDate.parse(dat);
									DateTimeFormatter dtf = DateTimeFormatter.ofPattern("MMM dd, yyyy");
									String date = dtf.format(datee);
									String replace = 	"<span style=background:red;color:#fff>"+mostactiveterm+"</span>";
									%>                                    
                                    <h5 class="text-primary p20 pt0 pb0"><%=title.replaceAll(mostactiveterm,replace)%></h5>
										<div class="text-center mb20 mt20">
										<a href="<%=request.getContextPath()%>/bloggerportfolio.jsp?tid=<%=tid%>&blogger=<%=tobj.get("blogger")%>">
											<button class="btn stylebuttonblue">
												<b class="float-left ultra-bold-text"><%=tobj.get("blogger")%></b> <i
													class="far fa-user float-right blogcontenticon"></i>
											</button>
											</a>
											<button class="btn stylebuttonnocolor"><%=date %></button>
											<button class="btn stylebuttonnocolor">
												<b class="float-left ultra-bold-text"><%=tobj.get("num_comments")%> comments</b><i
													class="far fa-comments float-right blogcontenticon"></i>
											</button>
										</div>
										<div style="height: 600px;">
										<div class="p20 pt0 pb20 text-blog-content text-primary"
											style="height: 550px; overflow-y: scroll;">
											<%=body.replaceAll(mostactiveterm,replace)%>
										</div>         
										</div>             
                     		<% } %>

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
										<th>Blogger Count</th>
										<th>Leading Blogger</th>
										<th>Language</th>
										<th>Location</th>

									</tr>
								</thead>
								<tbody>
								<%if (topterms.length() > 0) {
													
										for (int i = 0; i < topterms.length(); i++) {
											JSONObject jsonObj = topterms.getJSONObject(i);
											int size = Integer.parseInt(jsonObj.getString("frequency"));
											String terms = jsonObj.getString("key");
											String postcount = post._searchTotalByTitleAndBody(terms,"date", dt,dte);
											String blogcount = post._searchTotalAndUnique(terms,"date", dt,dte,"blogsite_id");
											String bloggercount = post._searchTotalAndUnique(terms,"date", dt,dte,"blogger");
											String language = jsonObj.getString("language");
											String location = jsonObj.getString("location");
											String blogger = jsonObj.getString("leadingblogger");
											
											
																		
											%>
									<tr>
										<td><%=terms%></td>
										<td><%=size%></td>
										<td><%=postcount%> <%-- <sub>of <%=postcount%></sub> --%></td>
										<td><%=blogcount%> <%-- <sub>of <%=blogcount%></sub> --%></td>
										<td><%=bloggercount%> <%-- <sub>of <%=bloggercount%></sub> --%></td>
										<td><%=blogger%></td>
										<td><%=language%></td>
										<td><%=location%></td>

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
		









<%-- 

	<form action="" name="customform" id="customform" method="post">
		<input type="hidden" name="tid" value="<%=tid%>" /> 
		<input type="hidden" name="date_start" id="date_start" value="" /> 
		<input type="hidden" name="date_end" id="date_end" value="" />

<<<<<<< HEAD
 --%>
 
<form action="" name="customform" id="customform" method="post">
<input type="hidden" id="term" value="<%=mostactiveterm%>" />
<input type="hidden" id="date_start" value="<%=dt%>" />
<input type="hidden" id="term_id" value="<%=mostactiveterm_id%>" />
<input type="hidden" id="date_end" value="<%=dte%>" />

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

	<script>
 $(document).ready(function() {
     $('#DataTables_Table_1_wrapper').DataTable( {
         "scrollY": 430,
         "scrollX": true,
          "pagingType": "simple"
       /*    ,
          dom: 'Bfrtip',
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
     } );

     $('#DataTables_Table_2_wrapper').DataTable( {
         "scrollY": 480,

          "pagingType": "simple"
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
     } );
 } );
 </script>
	<!--end for table  -->
	<script>
 $(document).ready(function() {
	 
	 $('#printdoc').on('click',function(){
			print();
		}) ;
   $(document)
   						.ready(
   								function() {
   	var cb = function(start, end, label) {
           //console.log(start.toISOString(), end.toISOString(), label);
           $('#reportrange span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
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
     //  $('#reportrange span').html(moment().subtract( 500, 'days').format('MMMM D, YYYY') + ' - ' + moment().format('MMMM D, YYYY'))
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
   	            console
   	               .log("apply event fired, start/end dates are "
   	                   + picker.startDate
   	                       .format('MMMM D, YYYY')
   	                   + " to "
   	                   + picker.endDate
   	                       .format('MMMM D, YYYY')); 
   	            	console.log("applied");
   	            	
   	            	var start = picker.startDate.format('YYYY-MM-DD');
   	            	var end = picker.endDate.format('YYYY-MM-DD');
   	            	//console.log("End:"+end);
   	            	
   	            	$("#date_start").val(start);
   	            	$("#date_end").val(end);
   	            	//toastr.success('Date changed!','Success');
   	            	$("form#customform").submit();	});

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
	<script type="text/javascript" src="assets/vendors/d3/d3_tooltip.js"></script>
	<script>

 $(function () {

     // Initialize chart
     lineBasic('#d3-line-basic', 200);

     // Chart setup
     function lineBasic(element, height) {


         // Basic setup
         // ------------------------------

         // Define main variables
         var d3Container = d3.select(element),
             margin = {top: 10, right: 10, bottom: 20, left: 50},
             width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right,
             height = height - margin.top - margin.bottom;


         // var formatPercent = d3.format(",.3f");
         // Format data
         // var parseDate = d3.time.format("%d-%b-%y").parse,
         //     bisectDate = d3.bisector(function(d) { return d.date; }).left,
         //     formatValue = d3.format(",.0f"),
         //     formatCurrency = function(d) { return formatValue(d); }



         // Construct scales
         // ------------------------------

         // Horizontal
         var x = d3.scale.ordinal()
             .rangeRoundBands([0, width], .72, .5);

         // Vertical
         var y = d3.scale.linear()
             .range([height, 0]);



         // Create axes
         // ------------------------------

         // Horizontal
         var xAxis = d3.svg.axis()
             .scale(x)
             .orient("bottom")
            .ticks(9)

           // .tickFormat(formatPercent);


         // Vertical
         var yAxis = d3.svg.axis()
             .scale(y)
             .orient("left")
             .ticks(6);



         // Create chart
         // ------------------------------

         // Add SVG element
         var container = d3Container.append("svg");

         // Add SVG group
         var svg = container
             .attr("width", width + margin.left + margin.right)
             .attr("height", height + margin.top + margin.bottom)
             .append("g")
                 .attr("transform", "translate(" + margin.left + "," + margin.top + ")");



         // Construct chart layout
         // ------------------------------

         // Line


         // Load data
         // ------------------------------

         // data = [[{"date": "Jan","close": 120},{"date": "Feb","close": 140},{"date": "Mar","close":160},{"date": "Apr","close": 180},{"date": "May","close": 200},{"date": "Jun","close": 220},{"date": "Jul","close": 240},{"date": "Aug","close": 260},{"date": "Sep","close": 280},{"date": "Oct","close": 300},{"date": "Nov","close": 320},{"date": "Dec","close": 340}],
         // [{"date":"Jan","close":10},{"date":"Feb","close":20},{"date":"Mar","close":30},{"date": "Apr","close": 40},{"date": "May","close": 50},{"date": "Jun","close": 60},{"date": "Jul","close": 70},{"date": "Aug","close": 80},{"date": "Sep","close": 90},{"date": "Oct","close": 100},{"date": "Nov","close": 120},{"date": "Dec","close": 140}],
         // ];
		
        
         data = [<% if(termscount.length()>0){
       	  for(int p=0; p<1; p++){ 
  	  		String au = termscount.get(p).toString();
  	  		JSONObject specific_auth= new JSONObject(termsyears.get(au).toString());
  	  %>[<% for(int q=0; q<yearsarray.length(); q++){ 
  		  		String yearr=yearsarray.get(q).toString(); 
  		  		if(specific_auth.has(yearr)){ %>
  		  			{"date":"<%=yearr%>","close":<%=specific_auth.get(yearr)%>},
  			<%
  		  		}else{ %>
  		  			{"date":"<%=yearr%>","close":0},
  	   		<% } %>
  		<%  
  	  		}%>]<% if(p<termscount.length()-1){%>,<%}%>
  	  <%	}}
  	  %> ];

         //console.log(data);
         // data = [];

         // data = [
         // [
         //   {
         //     "date": "Jan",
         //     "close": 1000
         //   },
         //   {
         //     "date": "Feb",
         //     "close": 1800
         //   },
         //   {
         //     "date": "Mar",
         //     "close": 1600
         //   },
         //   {
         //     "date": "Apr",
         //     "close": 1400
         //   },
         //   {
         //     "date": "May",
         //     "close": 2500
         //   },
         //   {
         //     "date": "Jun",
         //     "close": 500
         //   },
         //   {
         //     "date": "Jul",
         //     "close": 100
         //   },
         //   {
         //     "date": "Aug",
         //     "close": 500
         //   },
         //   {
         //     "date": "Sep",
         //     "close": 2300
         //   },
         //   {
         //     "date": "Oct",
         //     "close": 1500
         //   },
         //   {
         //     "date": "Nov",
         //     "close": 1900
         //   },
         //   {
         //     "date": "Dec",
         //     "close": 4170
         //   }
         // ]
         // ];

         // console.log(data);
         var line = d3.svg.line()
         .interpolate("monotone")
              //.attr("width", x.rangeBand())
             .x(function(d) { return x(d.date); })
             .y(function(d) { return y(d.close); });
             // .x(function(d){d.forEach(function(e){return x(d.date);})})
             // .y(function(d){d.forEach(function(e){return y(d.close);})});



         // Create tooltip
         var tip = d3.tip()
                .attr('class', 'd3-tip')
                .offset([-10, 0])
                .html(function(d) {
                if(d === null)
                {
                  return "No Information Available";
                }
                else if(d !== null) {
                 return d.date+" ("+d.close+")<br/> Click for more information";
                  }
                // return "here";
                });

            // Initialize tooltip
            //svg.call(tip);


           // Pull out values
           // data.forEach(function(d) {
           //     d.frequency = +d.close;
           //
           // });


                     // Pull out values
                     // data.forEach(function(d) {
                     //     // d.date = parseDate(d.date);
                     //     //d.date = +d.date;
                     //     //d.date = d.date;
                     //     d.close = +d.close;
                     // });

                     // Sort data
                     // data.sort(function(a, b) {
                     //     return a.date - b.date;
                     // });


                     // Set input domains
                     // ------------------------------

                     // Horizontal
           //  console.log(data[0])


                   // Vertical
         // extract max value from list of json object
         // console.log(data.length)
             var maxvalue =
             data.map(function(d){
               var mvalue = [];
               if(data.length > 1)
             {
               d.forEach(function(f,i){
               mvalue[i] = f.close;

               })
             return d3.max(mvalue);
             }

             //console.log(mvalue);
             });



         ////console.log(data)
         if(data.length == 1)
         {
           var returnedvalue = data[0].map(function(e){
           return e.date
           });

         // for single json data
         x.domain(returnedvalue);
         // rewrite x domain

         var maxvalue2 =
         data.map(function(d){
         return d3.max(d,function(t){return t.close});
         });
         y.domain([0,maxvalue2]);
         }
         else if(data.length > 1)
         {
         //console.log(data.length);
         //console.log(data);

         var returnedata = data.map(function(e){
         // console.log(k)
         var all = []
         e.forEach(function(f,i){
         all[i] = f.date;
         //console.log(all[i])
         })
         return all
         //console.log(all);
         });
         // console.log(returnedata);
         // combines all the array
         var newArr = returnedata.reduce((result,current) => {
         return result.concat(current);
         });

         //console.log(newArr);
         var set = new Set(newArr);
         var filteredArray = Array.from(set);
         //console.log(filteredArray.sort());
         // console.log(returnedata);
         x.domain(filteredArray);
         y.domain([0, d3.max(maxvalue)]);
         }




                     //
                     // Append chart elements
                     //




         // svg.call(tip);
                      // data.map(function(d){})
                      if(data.length == 1)
                      {
                        // Add line
                      var path = svg.selectAll('.d3-line')
                                .data(data)
                                .enter()
                                .append("path")
                                .attr("class", "d3-line d3-line-medium")
                                .attr("d", line)
                                // .style("fill", "rgba(0,0,0,0.54)")
                                .style("stroke-width",2)
                                .style("stroke", "17394C")
                                 .attr("transform", "translate("+margin.left/4.7+",0)");
                                // .datum(data)

                       // add point
                        circles = svg.selectAll(".circle-point")
                                  .data(data[0])
                                  .enter();


                              circles
                              // .enter()
                              .append("circle")
                              .attr("class","circle-point")
                              .attr("r",3.4)
                              .style("stroke", "#4CAF50")
                              .style("fill","#4CAF50")
                              .attr("cx",function(d) { return x(d.date); })
                              .attr("cy", function(d){return y(d.close)})

                              .attr("transform", "translate("+margin.left/4.7+",0)");

                              svg.selectAll(".circle-point").data(data[0])
                              .on("mouseover",tip.show)
                              .on("mouseout",tip.hide)
                              .on("click",function(d){console.log(d.date)});
                                                 svg.call(tip)
                      }
                      // handles multiple json parameter
                      else if(data.length > 1)
                      {
                        // add multiple line

                        var path = svg.selectAll('.d3-line')
                                  .data(data)
                                  .enter()
                                  .append("path")
                                  .attr("class", "d3-line d3-line-medium")
                                  .attr("d", line)
                                  // .style("fill", "rgba(0,0,0,0.54)")
                                  .style("stroke-width", 2)
                                  .style("stroke", function(d,i) { return color(i);})
                                  .attr("transform", "translate("+margin.left/4.7+",0)");




                       // add multiple circle points

                           // data.forEach(function(e){
                           // console.log(e)
                           // })

                           // console.log(data);

                              var mergedarray = [].concat(...data);
                               // console.log(mergedarray)
                                 circles = svg.selectAll(".circle-point")
                                     .data(mergedarray)
                                     .enter();

                                       circles
                                       // .enter()
                                       .append("circle")
                                       .attr("class","circle-point")
                                       .attr("r",3.4)
                                       .style("stroke", "#4CAF50")
                                       .style("fill","#4CAF50")
                                       .attr("cx",function(d) { return x(d.date)})
                                       .attr("cy", function(d){return y(d.close)})

                                       .attr("transform", "translate("+margin.left/4.7+",0)");
                                       svg.selectAll(".circle-point").data(mergedarray)
                                      .on("mouseover",tip.show)
                                      .on("mouseout",tip.hide)
                                      .on("click",function(d){
                                    	  console.log(d.date);
                                    	  var d1 = 	  d.date + "-01-01";
                                     	   var d2 = 	  d.date + "-12-31";
                           				
                                     	  loadTable(d1,d2);
                                      });
                                 //                         svg.call(tip)

                               //console.log(newi);


                                     svg.selectAll(".circle-point").data(mergedarray)
                                     .on("mouseover",tip.show)
                                     .on("mouseout",tip.hide)
                                     .on("click",function(d){
                                    	 console.log(d.date);

                                   	  var d1 = 	  d.date + "-01-01";
                                     var d2 = 	  d.date + "-12-31";
                          				
                                    	  loadTable(d1,d2);
                                    	 
                                     });
                                                        svg.call(tip)










                      }


         // show data tip


                     // Append axes
                     // ------------------------------

                     // Horizontal
                     svg.append("g")
                         .attr("class", "d3-axis d3-axis-horizontal d3-axis-strong")
                         .attr("transform", "translate(0," + height + ")")
                         .call(xAxis);

                     // Vertical
                     var verticalAxis = svg.append("g")
                         .attr("class", "d3-axis d3-axis-vertical d3-axis-strong")
                         .call(yAxis);





                     // Add text label
                     verticalAxis.append("text")
                         .attr("transform", "rotate(-90)")
                         .attr("y", 10)
                         .attr("dy", ".71em")
                         .style("text-anchor", "end")
                         .style("fill", "#999")
                         .style("font-size", 12)
                         // .text("Frequency")
                         ;




             // Append tooltip
             // -------------------------






         // Resize chart
         // ------------------------------

         // Call function on window resize
         $(window).on('resize', resize);

         // Call function on sidebar width change
         $('.sidebar-control').on('click', resize);

         // Resize function
         //
         // Since D3 doesn't support SVG resize by default,
         // we need to manually specify parts of the graph that need to
         // be updated on window resize
         function resize() {

           // Layout variables
           width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right;
           //
           //
           // // Layout
           // // -------------------------
           //
           // // Main svg width
           container.attr("width", width + margin.left + margin.right);
           //
           // // Width of appended group
           svg.attr("width", width + margin.left + margin.right);
           //
           //
           // // Axes
           // // -------------------------
           //
           // // Horizontal range
           x.rangeRoundBands([0, width],.72,.5);
           //
           // // Horizontal axis
           svg.selectAll('.d3-axis-horizontal').call(xAxis);
           //
           //
           // // Chart elements
           // // -------------------------
           //
           // // Line path
           svg.selectAll('.d3-line').attr("d", line);



             svg.selectAll(".circle-point")
             .attr("cx",function(d) { return x(d.date);})
             .attr("cy", function(d){return y(d.close)});


           //
           // // Crosshair
           // svg.selectAll('.d3-crosshair-overlay').attr("width", width);

         }
     }
 });
 </script>

	<!--word cloud  -->
	<script>
     var color = d3.scale.linear()
             .domain([0,1,2,3,4,5,6,10,15,20,80])
             .range(["#17394C", "#F5CC0E", "#CE0202", "#aaa", "#999", "#888", "#777", "#666", "#555", "#444", "#333", "#222"]);

 </script>





<script src="pagedependencies/baseurl.js?v=38"></script>
 
<script src="pagedependencies/keywordtrends.js?v=490879"></script>
	

</body>
</html>

<% }} %>
