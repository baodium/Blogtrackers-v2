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

		Trackers tracker = new Trackers();
		Terms term = new Terms();
		Outlinks outl = new Outlinks();
		if (tid != "") {
			detail = tracker._fetch(tid.toString());
			//System.out.println(detail);
		} else {
			detail = tracker._list("DESC", "", user.toString(), "1");
			System.out.println("List:"+detail);
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
			
			Date dstart = new SimpleDateFormat("yyyy-MM-dd").parse(stdate);
			Date today = new SimpleDateFormat("yyyy-MM-dd").parse(endate);

			Date nnow = new Date();  
			  
			String day = DAY_ONLY.format(today);
			
			String month = MONTH_ONLY.format(today);
			String smallmonth = SMALL_MONTH_ONLY.format(today);
			String year = YEAR_ONLY.format(today);

			String dispfrom = DATE_FORMAT.format(dstart);
			String dispto = DATE_FORMAT.format(today);

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
			
			if (!date_start.equals("") && !date_end.equals("")) {
				totalpost = post._searchRangeTotal("date", date_start.toString(), date_end.toString(), ids);
				possentiment = post._searchRangeTotal("sentiment", "0", "10", ids);
				negsentiment = post._searchRangeTotal("sentiment", "-10", "-1", ids);

				Date start = new SimpleDateFormat("yyyy-MM-dd").parse(date_start.toString());
				Date end = new SimpleDateFormat("yyyy-MM-dd").parse(date_end.toString());
				
				dt = date_start.toString();
				dte = date_end.toString();
				
				dispfrom = DATE_FORMAT.format(start);
				dispto = DATE_FORMAT.format(end);
				termss = term._searchByRange("date", date_start.toString(), date_end.toString(), ids);
				outlinks = outl._searchByRange("date", date_start.toString(), date_end.toString(), ids);

				allauthors=post._getBloggerByBlogId("date",date_start.toString(), date_end.toString(),ids);
			} else if (single.equals("day")) {
				 dt = year + "-" + month + "-" + day;
				
				dispfrom = DATE_FORMAT.format(new SimpleDateFormat("yyyy-MM-dd").parse(dt));
				dispto = DATE_FORMAT.format(new SimpleDateFormat("yyyy-MM-dd").parse(dt));			
				totalpost = post._searchRangeTotal("date", dt, dt, ids);
				termss = term._searchByRange("date", dt, dt, ids);
				outlinks = outl._searchByRange("date", dt, dt, ids);

				allauthors=post._getBloggerByBlogId("date",dt, dt,ids);
					
			} else if (single.equals("week")) {
				
				 dte = year + "-" + month + "-" + day;
				int dd = Integer.parseInt(day)-7;
				
				Calendar cal = Calendar.getInstance();
				cal.add(Calendar.DATE, -7);
				Date dateBefore7Days = cal.getTime();
				dt = YEAR_ONLY.format(dateBefore7Days) + "-" + MONTH_ONLY.format(dateBefore7Days) + "-" + DAY_ONLY.format(dateBefore7Days);
				
				
				dispfrom = DATE_FORMAT.format(new SimpleDateFormat("yyyy-MM-dd").parse(dt));
				dispto = DATE_FORMAT.format(new SimpleDateFormat("yyyy-MM-dd").parse(dte));			
				totalpost = post._searchRangeTotal("date", dt, dte, ids);
				termss = term._searchByRange("date", dt, dte, ids);
				outlinks = outl._searchByRange("date", dt, dte, ids);

				allauthors=post._getBloggerByBlogId("date",dt, dte,ids);
					
			} else if (single.equals("month")) {
				dt = year + "-" + month + "-01";
				dte = year + "-" + month + "-"+day;	
				dispfrom = DATE_FORMAT.format(new SimpleDateFormat("yyyy-MM-dd").parse(dt));
				dispto = DATE_FORMAT.format(new SimpleDateFormat("yyyy-MM-dd").parse(dte));
				
				totalpost = post._searchRangeTotal("date", dt, dte, ids);
				termss = term._searchByRange("date", dt, dte, ids);
				outlinks = outl._searchByRange("date", dt, dte, ids);

				allauthors=post._getBloggerByBlogId("date",dt, dte,ids);
				
			} else if (single.equals("year")) {
				dt = year + "-01-01";
				dte = year + "-12-"+ddey;
				dispfrom = DATE_FORMAT.format(new SimpleDateFormat("yyyy-MM-dd").parse(dt));
				dispto = DATE_FORMAT.format(new SimpleDateFormat("yyyy-MM-dd").parse(dte));
				
				totalpost = post._searchRangeTotal("date", dt, dte, ids);
				termss = term._searchByRange("date", dt, dte, ids);
				outlinks = outl._searchByRange("date", dt, dte, ids);
				allauthors=post._getBloggerByBlogId("date",dt, dte,ids);
				
				
			} else {
				totalpost = post._getTotalByBlogId(ids, "");
				possentiment = post._searchRangeTotal("sentiment", "0", "10", ids);
				negsentiment = post._searchRangeTotal("sentiment", "-10", "-1", ids);			
				termss = term._searchByRange("date", dst, dend, ids);
				outlinks = outl._searchByRange("date",dst, dend, ids);
				
				allauthors=post._getBloggerByBlogId("date",dst, dend,ids);
				
			}
			
			//System.out.println("Terms here:"+termss);
			
			ArrayList blogs = blog._fetch(ids);
			int totalblog = blogs.size();
			
			JSONObject graphyears = new JSONObject();
		    JSONArray yearsarray = new JSONArray();
		    
			String[] yst = dt.split("-");
			String[] yend = dte.split("-");
			year_start = yst[0];
			year_end = yend[0];
			int ystint = Integer.parseInt(year_start);
			int yendint = Integer.parseInt(year_end);
			
			int b=0;
			for(int y=ystint; y<=yendint; y++){
					   String dtu = y + "-01-01";
					   String dtue = y + "-12-31";
					   String totu = post._searchRangeTotal("date",dtu, dtue,ids);
					   graphyears.put(y+"",totu);
			    	   yearsarray.put(b,y);	
			    	   b++;
			}
			
		    JSONObject authors = new JSONObject();
		    
		    JSONArray authorcount = new JSONArray();
		    JSONObject language = new JSONObject();
		    ArrayList langlooper = new ArrayList();
		    
		    
			ArrayList authorlooper = new ArrayList();
			if(allauthors.size()>0){
				String tres = null;
				JSONObject tresp = null;
				String tresu = null;
				JSONObject tobj = null;
				int j=0;
				int k=0;
				int n = 0;
			for(int i=0; i< allauthors.size(); i++){
						tres = allauthors.get(i).toString();			
						tresp = new JSONObject(tres);
					    tresu = tresp.get("_source").toString();
					    tobj = new JSONObject(tresu);
					    
					    String auth = tobj.get("blogger").toString();
					    String lang = tobj.get("language").toString();
					    
					    Double influence =  Double.parseDouble(tobj.get("influence_score").toString());
					  	JSONObject content = new JSONObject();
					   
					  	String[] dateyear=tobj.get("date").toString().split("-");
					    String yy= dateyear[0];
					    
					   
					   
					    if(authors.has(auth)){
							content = new JSONObject(authors.get(auth).toString());
							Double inf = Double.parseDouble(content.get("influence").toString());
							inf = inf+influence;
							content.put("blogger", auth);
							content.put("influence", inf);
							authors.put(auth, content);
						} else {
							content.put("blogger", auth);
							content.put("influence", influence);
							authors.put(auth, content);
							authorlooper.add(j,auth);
							j++;
						}
					    
					  //Object ex = language.get(lang);
						if (language.has(lang)) {
							int val = Integer.parseInt(language.get(lang).toString()) + 1;
							language.put(lang, val);
						} else {
							//  	int val  = Integer.parseInt(ex.toString())+1;
							language.put(lang, 1);
							langlooper.add(n, lang);
							n++;
						}

				}
			//System.out.println("Authors here:"+graphyears);
			} 
			
			
			JSONArray sortedyearsarray = post._sortJson(yearsarray);
			
			JSONObject sentimentblog = new JSONObject();
			if (sentiments.size() > 0) {

				for (int p = 0; p < sentiments.size(); p++) {
					String bstr = sentiments.get(p).toString();
					JSONObject bj = new JSONObject(bstr);
					bstr = bj.get("_source").toString();
					bj = new JSONObject(bstr);
					String id = bj.get("blogsite_id").toString();
					//if(!sentimentblog.has(id)){
					sentimentblog.put(id, id);
					// }
				}
			}

			JSONArray topterms = new JSONArray();
			if (termss.size() > 0) {

				for (int p = 0; p < termss.size(); p++) {
					String bstr = termss.get(p).toString();
					JSONObject bj = new JSONObject(bstr);
					bstr = bj.get("_source").toString();
					bj = new JSONObject(bstr);
					String frequency = bj.get("frequency").toString();
					String tm = bj.get("term").toString();
					JSONObject cont = new JSONObject();
					cont.put("key", tm);
					cont.put("frequency", frequency);
					topterms.put(cont);
				}
			}
			
			JSONObject outerlinks = new JSONObject();
			ArrayList outlinklooper = new ArrayList();
			if (outlinks.size() > 0) {
				int mm=0;
				for (int p = 0; p < outlinks.size(); p++) {
					String bstr = outlinks.get(p).toString();
					JSONObject bj = new JSONObject(bstr);
					bstr = bj.get("_source").toString();
					bj = new JSONObject(bstr);
					String link = bj.get("link").toString();
					
					JSONObject content = new JSONObject();
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

					
					if (outerlinks.has(maindomain)) {
						content = new JSONObject(outerlinks.get(maindomain).toString());
						
						int valu = Integer.parseInt(content.get("value").toString());
						valu++;
						
						content.put("value", valu);
						content.put("link", link);
						content.put("domain", maindomain);
						outerlinks.put(maindomain, content);
					} else {
						int valu = 1;
						content.put("value", valu);
						content.put("link", link);
						content.put("domain", maindomain);
						outerlinks.put(maindomain, content);
						outlinklooper.add(mm, maindomain);
						mm++;
					}				
				
				}
			}

			//System.out.println("senti"+ sentimentblog);
			
			JSONObject bloggers = new JSONObject();

			ArrayList looper = new ArrayList();
			

			if (blogs.size() > 0) {
				String bres = null;
				JSONObject bresp = null;

				String bresu = null;
				JSONObject bobj = null;
				int m = 0;
				
				for (int k = 0; k < blogs.size(); k++) {
					bres = blogs.get(k).toString();
					bresp = new JSONObject(bres);
					bresu = bresp.get("_source").toString();
					bobj = new JSONObject(bresu);
					
					String blogger = bobj.get("blogsite_owner").toString();
					String blogname = bobj.get("blogsite_name").toString();
					
					String sentiment = "1";// bobj.get("sentiment").toString();
					String posting = bobj.get("totalposts").toString();

					JSONObject content = new JSONObject();

					String durl = bobj.get("blogsite_url").toString();//"";
					try {
						URI uri = new URI(bobj.get("blogsite_url").toString());
						String domain = uri.getHost();
						if (domain.startsWith("www.")) {
							durl = domain.substring(4);
						} else {
							durl = domain;
						}
					} catch (Exception ex) {}
					
						String toty = post._searchRangeTotal("date",dt, dte,bobj.get("blogsite_id").toString());
						String btoty = post._searchRangeTotalByBLogger("date",dt, dte,blogger);
						int valu = Integer.parseInt(btoty);
						
						content.put("blog", blogname);
						content.put("id", bobj.get("blogsite_id").toString());
						content.put("blogger", blogger);
						content.put("sentiment", sentiment);
						content.put("postingfreq", posting);
						content.put("value", valu);
						content.put("totalposts", toty);
						content.put("blogsite_url", bobj.get("blogsite_url").toString());
						content.put("blogsite_domain", durl);
						bloggers.put(blogger, content);
						looper.add(m, blogger);
						m++;		
				}

			}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Blogtrackers - Dashboard</title>
<!-- start of bootsrap -->
<link rel="shortcut icon" href="images/favicons/favicon-48x48.png">
<link rel="apple-touch-icon" href="images/favicons/favicon-48x48.png">
<link rel="apple-touch-icon" sizes="96x96"
	href="images/favicons/favicon-96x96.png">
<link rel="apple-touch-icon" sizes="144x144"
	href="images/favicons/favicon-144x144.png">

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
<!-- <link rel="stylesheet" href="assets/css/bar.css" /> -->
<!--end of bootsrap -->
<link rel="stylesheet" href="assets/css/toastr.css">

<script src="assets/js/jquery.min.js"></script>
<script type="text/javascript" src="assets/js/toastr.js"></script>

<!-- <script src="assets/js/jquery-3.2.1.slim.min.js"></script>-->
<script src="assets/js/popper.min.js"></script>
<script src="pagedependencies/googletagmanagerscript.js"></script>

  <script src="pagedependencies/baseurl.js"></script>
</head>
<body>
<%@include file="subpages/googletagmanagernoscript.jsp" %>
	<div class="modal-notifications">
		<div class="row">
			<div class="col-lg-10 closesection"></div>
			<div class="col-lg-2 col-md-12 notificationpanel">
				<div id="closeicon" class="cursor-pointer">
					<i class="fas fa-times-circle"></i>
				</div>
				<div class="profilesection col-md-12 mt50">
					<div class="text-center mb10">
						<img src="<%=profileimage%>" width="60" height="60"
							onerror="this.src='images/default-avatar.png'" alt="" />
					</div>
					<div class="text-center" style="margin-left: 0px;">
						<h6 class="text-primary m0 bolder profiletext"><%=name%></h6>
						<p class="text-primary profiletext"><%=email%></p>
					</div>

				</div>
				<div id="othersection" class="col-md-12 mt10" style="clear: both">
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
				</div>
			</div>
		</div>
	</div>



	<nav class="navbar navbar-inverse bg-primary">
		<div class="container-fluid mt10 mb10">

			<div class="navbar-header d-none d-lg-inline-flex d-xl-inline-flex  col-lg-3">
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
				<ul class="nav navbar-nav" style="display: block;">
					<li class="dropdown dropdown-user cursor-pointer float-right">
						<a class="dropdown-toggle " id="profiletoggle"
						data-toggle="dropdown"> <i class="fas fa-circle"
							id="notificationcolor"></i> <img src="<%=profileimage%>"
							width="50" height="50"
							onerror="this.src='images/default-avatar.png'" alt="" class="" />
							<span class="bold-text"><%=user_name[0]%></span> <!-- <ul class="profilemenu dropdown-menu dropdown-menu-left">
              <li><a href="#"> My profile</a></li>
              <li><a href="#"> Features</a></li>
              <li><a href="#"> Help</a></li>
              <li><a href="#">Logout</a></li>
  </ul> -->
					</a>

					</li>
				</ul>
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
		<!-- <div class="profilenavbar" style="visibility:hidden;"></div> -->


	</nav>


	<div class="container">
		<div class="row">
			<div class="col-md-6 ">
				<nav class="breadcrumb">
					<a class="breadcrumb-item text-primary"
						href="<%=request.getContextPath()%>/trackerlist.jsp">My	Trackers</a> <a class="breadcrumb-item text-primary"
						href="<%=request.getContextPath()%>/edittracker.jsp"><%=trackername%></a>
					<a class="breadcrumb-item active text-primary" href="#">Dashboard</a>
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
						<label
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
						</label>
						<!-- <label class="btn btn-primary btn-sm nobgnoborder" id="custom">Custom</label> -->
					</div>

				</div>
			</div>

		</div>

		<div class="row p0 pt20 pb20 border-top-bottom mt20 mb20">
			<div class="col-md-2">
				<div class="card nocoloredcard mt10 mb10">
					<div class="card-body p0 pt5 pb5">
						<h5 class="text-primary mb0">
							<i class="fas fa-file-alt icondash"></i>Blogs
						</h5>
						<h3 class="text-blue mb0 countdash dash-label"><%=totalblog%></h3>
					</div>
				</div>
			</div>

			<div class="col-md-2">
				<div class="card nocoloredcard mt10 mb10">
					<div class="card-body p0 pt5 pb5">
						<h5 class="text-primary mb0">
							<i class="fas fa-user icondash"></i>Bloggers
						</h5>
						<h3 class="text-blue mb0 countdash dash-label"><%=bloggers.length()%></h3>
					</div>
				</div>
			</div>

			<div class="col-md-2">
				<div class="card nocoloredcard mt10 mb10">
					<div class="card-body p0 pt5 pb5">
						<h5 class="text-primary mb0">
							<i class="fas fa-file-alt icondash"></i>Posts
						</h5>
						<h3 class="text-blue mb0 countdash dash-label"><%=totalpost%></h3>
					</div>
				</div>
			</div>

			<div class="col-md-2">
				<div class="card nocoloredcard mt10 mb10">
					<div class="card-body p0 pt5 pb5">
						<h5 class="text-primary mb0">
							<i class="fas fa-comment icondash"></i>Comments
						</h5>
						<h3 class="text-blue mb0 countdash dash-label">3</h3>
					</div>
				</div>
			</div>


			<div class="col-md-4">
				<div class="card nocoloredcard mt10 mb10">
					<div class="card-body p0 pt5 pb5">
						<h5 class="text-primary mb0">
							<i class="fas fa-clock icondash"></i>History
						</h5>
						<h3 class="text-blue mb0 countdash dash-label"><%=dispfrom%>
							-
							<%=dispto%></h3>
					</div>
				</div>
			</div>

		</div>

		<div class="row mb0">
			<div class="col-md-6 mt20 ">
				<div class="card card-style mt20">
					<div class="card-body  p15 pt15 pb15">
						<div>
							<p class="text-primary mt0 float-left">
								Most Active Location 
								<!-- <select
									class="text-primary filtersort sortbyblogblogger"><option
										value="blogs">Blogs</option>
									<option value="bloggers">Bloggers</option></select>  -->
									<%-- for Past <select
									class="text-primary filtersort sortbytimerange">
									<option value="" >All</option>
									<option value="week" <%=(single.equals("week"))?"selected":"" %>>Week</option>
									<option value="month" <%=(single.equals("month"))?"selected":"" %>>Month</option>
									<option value="year" <%=(single.equals("year"))?"selected":"" %>>Year</option></select> --%>
							</p>
						</div>
						<div style="min-height: 490px;">
							<div class="map-container map-choropleth"></div>
						</div>
					</div>
				</div>
			</div>

			<div class="col-md-6 mt20">
				<div class="card  card-style  mt20">
					<div class="card-body  p30 pt5 pb5">
						<div>
							<p class="text-primary mt10 float-left">
								Language Usage 
								<!-- <select
									class="text-primary filtersort sortbyblogblogger"><option
										value="blogs">Blogs</option>
									<option value="bloggers">Bloggers</option></select>  -->
									<%-- for Past <select
									class="text-primary filtersort sortbytimerange">
									<option value="" >All</option>
									<option value="week" <%=(single.equals("week"))?"selected":"" %>>Week</option>
									<option value="month" <%=(single.equals("month"))?"selected":"" %>>Month</option>
									<option value="year" <%=(single.equals("year"))?"selected":"" %>>Year</option></select>
						
									</select> --%>
							</p>
						</div>
						<div class="min-height-table" style="min-height: 500px;">
							<div class="chart-container">
								<div class="chart" id="languageusage"></div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="row mb0">
			<div class="col-md-12 mt20">

				<div class="card  card-style  mt20">
					<div class="card-body  p30 pt5 pb5">
						<div>
							<p class="text-primary mt10 float-left">

								Posting Frequency 
								<%-- for Past <select
									class="text-primary filtersort sortbytimerange"><option
										value="week" <%=(single.equals("week"))?"selected":"" %>>Week</option>

									<option value="month" <%=(single.equals("month"))?"selected":"" %>>Month</option>
									<option value="year" <%=(single.equals("year"))?"selected":"" %>>Year</option></select> --%>
							</p>
						</div>
						<div class="min-height-table" style="min-height: 300px;">
							<div class="chart-container">
								<div class="chart" id="postingfrequency"></div>
							</div>
						</div>
					</div>
				</div>

<div class="float-right">
					<a href="postingfrequency.jsp"><button
							class="btn buttonportfolio2 mt10">
							<b class="float-left semi-bold-text">Posting Frequency
								Analysis</b> <b class="fas fa-comment-alt float-right icondash2"></b>
						</button></a>
				</div>
			</div>
			
		</div>

		<div class="row mb0">
			<div class="col-md-6 mt20 ">
				<div class="card card-style mt20">
					<div class="card-body  p30 pt5 pb5">
						<div>
							<p class="text-primary mt10">
								Top Keywords
								<!-- <select
									class="text-primary filtersort sortbyblogblogger"><option
										value="blogs">Blogs</option>
									<option value="bloggers">Bloggers</option></select>  -->
									
									<%-- for Past <select
									class="text-primary filtersort sortbytimerange"><option
										value="week" <%=(single.equals("week"))?"selected":"" %>>Week</option>

									<option value="month" <%=(single.equals("month"))?"selected":"" %>>Month</option>
									<option value="year" <%=(single.equals("year"))?"selected":"" %>>Year</option></select> --%>
							</p>
						</div>
						<!-- <div class="tagcloudcontainer" style="min-height: 420px;"></div> -->
						<div class="chart-container">
								<div class="chart" id="tagcloudcontainer"></div>
							</div>
					</div>
				</div>
				<div class="float-right">
					<a href="keywordtrend.jsp"><button
							class="btn buttonportfolio2 mt10">
							<b class="float-left semi-bold-text">Keyword Trend Analysis </b>
							<b class="fas fa-search float-right icondash2"></b>
						</button></a>
				</div>
			</div>

			<div class="col-md-6 mt20">
				<div class="card card-style mt20">
					<div class="card-body  p30 pt5 pb5">
						<div>
							<p class="text-primary mt10">
								Sentiment Usage
							<!-- 	<select
									class="text-primary filtersort sortbyblogblogger"><option
										value="blogs">Blogs</option>
									<option value="bloggers">Bloggers</option></select>  -->

									<%-- for Past <select
									class="text-primary filtersort sortbytimerange"><option
										value="week" <%=(single.equals("week"))?"selected":"" %>>Week</option>

									<option value="month" <%=(single.equals("month"))?"selected":"" %>>Month</option>
									<option value="year" <%=(single.equals("year"))?"selected":"" %>>Year</option></select> --%>
							</p>
						</div>
						<div style="min-height: 420px;">
							<div class="chart-container">
								<div class="chart" id="sentimentbar"></div>
							</div>
						</div>
					</div>
				</div>
				<div class="float-right">
					<a
						href="<%=request.getContextPath()%>/sentiment.jsp?tid=<%=tid%>"><button
							class="btn buttonportfolio2 mt10">
							<b class="float-left semi-bold-text">Sentiment Analysis </b> <b
								class="fas fa-adjust float-right icondash2"></b>
						</button></a>
				</div>
			</div>
		</div>

		<div class="row mb0">
			<div class="col-md-6 mt20">
				<div class="card card-style mt20">
					<div class="card-body   p30 pt5 pb5">
						<div>
							<p class="text-primary mt10 float-left">

								Blog Distribution 
								<%-- for Past <select
									class="text-primary filtersort sortbytimerange"><option
										value="week" <%=(single.equals("week"))?"selected":"" %>>Week</option>
									<option value="month" <%=(single.equals("month"))?"selected":"" %>>Month</option>
									<option value="year" <%=(single.equals("year"))?"selected":"" %>>Year</option></select> --%>
							</p>
						</div>
						<div class="min-height-table" style="min-height: 500px;">
							<div class="chart-container">
								<div class="chart" id="bubblesblog"></div>
							</div>
						</div>
					</div>
				</div>
				<div class="float-right">
					<a href="blogportfolio.jsp"><button
							class="btn buttonportfolio2 mt10">
							<b class="float-left semi-bold-text">Blog Portfolio Analysis</b>
							<b class="fas fa-file-alt float-right icondash2"></b>
						</button></a>
				</div>

			</div>

			<div class="col-md-6 mt20">
				<div class="card card-style mt20">
					<div class="card-body p30 pt5 pb5">
						<div>
							<p class="text-primary mt10 float-left">

								Blogger Distribution 
								<%-- for Past <select
									class="text-primary filtersort sortbytimerange"><option
										value="week" <%=(single.equals("week"))?"selected":"" %>>Week</option>
									<option value="month" <%=(single.equals("month"))?"selected":"" %>>Month</option>
									<option value="year" <%=(single.equals("year"))?"selected":"" %>>Year</option></select> --%>
							</p>
						</div>
						<div class="min-height-table" style="min-height: 450px;">
							<div class="chart-container">
								<div class="chart" id="bubblesblogger"></div>
							</div>
						</div>
					</div>
				</div>
				<div class="float-right">
					<a href="bloggerportfolio.jsp"><button
							class="btn buttonportfolio2 mt10">
							<b class="float-left semi-bold-text">Blogger Portfolio
								Analysis </b> <b class="fas fa-user float-right icondash2"></b>
						</button></a>
				</div>

			</div>

		</div>

		<div class="row mb0">
			<div class="col-md-6 mt20">
				<div class="card card-style mt20">
					<div class="card-body   p30 pt5 pb5">
						<div>
							<p class="text-primary mt10 float-left">
								Most Active 
								<select id="swapBlogger" class="text-primary filtersort sortbyblogblogger">
									<option value="blogs">Blogs</option>

									<option value="bloggers">Bloggers</option></select> 
							<%-- 		of Past <select
									class="text-primary filtersort sortbytimerange" id="active-sortdate"><option
										value="week" <%=(single.equals("week"))?"selected":"" %>>Week</option>
									<option value="month" <%=(single.equals("month"))?"selected":"" %>>Month</option>
									<option value="year" <%=(single.equals("year"))?"selected":"" %>>Year</option></select> --%>
						</p>
						</div>
						<div class="min-height-table" style="min-height: 500px;">
							<div class="chart-container" id="postingfrequencycontainer">
								<div class="chart" id="postingfrequencybar"></div>
							</div>
							
						</div>
					</div>
				</div>
				<div class="float-right">
					<a href="postingfrequency.jsp"><button
							class="btn buttonportfolio2 mt10">
							<b class="float-left semi-bold-text">Posting Frequency
								Analysis</b> <b class="fas fa-comment-alt float-right icondash2"></b>
						</button></a>
				</div>

			</div>

			<div class="col-md-6 mt20">
				<div class="card card-style mt20">
					<div class="card-body p30 pt5 pb5">
						<div>
							<p class="text-primary mt10 float-left">

								Most Influential  <%--<select class="text-primary filtersort sortby" id="sortbyselect"><option>Recent </option><option value="blogger">Influence Score</option></select>
								  of Past <select
									class="text-primary filtersort sortbytimerange"><option
										value="week" <%=(single.equals("week"))?"selected":"" %>>Week</option>
									<option value="month" <%=(single.equals("month"))?"selected":"" %>>Month</option>
									<option value="year" <%=(single.equals("year"))?"selected":"" %>>Year</option></select> --%>
							</p>
						</div>
						<div class="min-height-table" style="min-height: 500px;">
							<div class="chart-container">
								<div class="chart" id="influencebar"></div>
							</div>
						</div>
					</div>
				</div>
				<div class="float-right">
					<a href="influence.jsp"><button
							class="btn buttonportfolio2 mt10">
							<b class="float-left semi-bold-text">Influence Analysis </b> <b
								class="fas fa-exchange-alt float-right icondash2"></b>
						</button></a>
				</div>

			</div>

		</div>

		<div class="row mb50">
			<div class="col-md-12 mt20 ">
				<div class="card card-style mt20">
					<div class="card-body  p5 pt10 pb10">

						<div style="min-height: 420px;">
							<div>
								<p class="text-primary p15 pb5 pt0">
									List of Top <select id="top-listtype" 
										class="text-primary filtersort sortbydomainsrls"><option
											value="domains">Domains</option>
										<option value="urls">URLs</option></select> 
										<!-- of <select id="top-sorttype"
										class="text-primary filtersort sortbyblogblogger" ><option
											value="blogs">Blogs</option>

										<option value="bloggers">Bloggers</option></select>  -->
									<%-- 	of Past <select
										class="text-primary filtersort sortbytimerange" id="top-sortdate" ><option
											value="week" <%=(single.equals("week"))?"selected":"" %>>Week</option>
										<option value="month" <%=(single.equals("month"))?"selected":"" %>>Month</option>
										<option value="year" <%=(single.equals("year"))?"selected":"" %>>Year</option></select> --%>
								</p>
							</div>
							<!--   <div class="p15 pb5 pt0" role="group">
          Export Options
          </div> -->
							<table id="DataTables_Table_0_wrapper" class="display"
								style="width: 100%">
								<thead>
									<tr>
										<th>Domain</th>
										<th>Frequency</th>

									</tr>
								</thead>
								<tbody id="top-domain-box">
								
									<%
										if (outlinklooper.size() > 0) {
													//System.out.println(bloggers);
													for (int y = 0; y < outlinklooper.size(); y++) {
														String key = outlinklooper.get(y).toString();
														JSONObject resu = outerlinks.getJSONObject(key);
									%>
									<tr>
										<td class=""><a href="http://<%=resu.get("domain")%>" target="_blank"><%=resu.get("domain")%></a></td>
										<td><%=resu.get("value")%></td>
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

			<%-- <%--  <div class="col-md-6 mt20">
    <div class="card card-style mt20">
      <div class="card-body  p5 pt10 pb10">
        <div class="min-height-table"style="min-height: 420px;">
          <!-- <div class="dropdown show"><p class="text-primary p15 pb5 pt0">List of Top URLs of <a class=" dropdown-toggle" data-toggle="dropdown" href="#" aria-expanded="false" id="blogbloggermenu1" role="button">Blogs</a> of Past <b>Week</b></p>
            <div class="dropdown-menu" aria-labelledby="blogbloggermenu1">
               <a class="dropdown-item" href="#">Action</a>
               <a class="dropdown-item" href="#">Another action</a>
               <a class="dropdown-item" href="#">Something else here</a>
             </div>
          </div> -->

<div class="dropdown show text-primary p15 pb20 pt0">List of Top URLs of <select class="text-primary filtersort sortbyblogblogger"><option value="blogs">Blogs</option><option value="bloggers">Bloggers</option></select> of Past <select class="text-primary filtersort sortbytimerange"><option value="week">Week</option><option value="month">Month</option><option value="year">Year</option></select>

 

</div>

          <!-- Example split danger button -->

         <!--  <div class="p15 pb5 pt0" role="group">
          Export Options
          </div> -->
                <table id="DataTables_Table_1_wrapper" class="display" style="width:100%">
                        <thead>
                            <tr>
                                <th>URL</th>
                                <th>Frequency</th>


                            </tr>
                        </thead>
                        <tbody>
                        <% if(bloggers.length()>0){
							//System.out.println(bloggers);
							for(int y=0; y<bloggers.length(); y++){
								String key = looper.get(y).toString();
								 JSONObject resu = bloggers.getJSONObject(key);
						%>
						<tr>
                              <td><%=resu.get("blogsite_url")%></td>
                              <td><%=resu.get("value")%></td>
                        </tr>
						<% }} %>
                            
                            

                        </tbody>
                    </table>
        </div>
          </div>
    </div>
  </div> --%>
		</div>



	</div>

	<form action="" name="customformsingle" id="customformsingle"
		method="post">
		<input type="hidden" name="tid" id="alltid" value="<%=tid%>" /> <input
			type="hidden" name="single_date" id="single_date" value="" />
	</form>

	<form action="" name="customform" id="customform" method="post">
		<input type="hidden" name="tid" value="<%=tid%>" /> <input
			type="hidden" name="date_start" id="date_start" value="" /> <input
			type="hidden" name="date_end" id="date_end" value="" />
			<textarea style="display:none" name="blogs" id="blogs" >
			 <% if (bloggers.length() > 0) {
						int p = 0;
						for (int y = 0; y < bloggers.length(); y++) {
							String key = looper.get(y).toString();
							JSONObject resu = bloggers.getJSONObject(key);
							int size = Integer.parseInt(resu.get("postingfreq").toString());
							if (size > 0 && p < 15) {
								p++;%>{letter:"<%=resu.get("blog")%>", frequency:<%=size%>, name:"<%=resu.get("blog")%>", type:"blog"},
    			 <%}}}%>
			</textarea>
			<textarea style="display:none" name="bloggers" id="bloggers" ><%if (bloggers.length() > 0) {
			int k = 0;for (int y = 0; y < bloggers.length(); y++) {
				String key = looper.get(y).toString();
				JSONObject resu = bloggers.getJSONObject(key);
				int size = Integer.parseInt(resu.get("value").toString());
				if (size > 0 && k < 15) {
					k++;%>{letter:"<%=resu.get("blogger")%>", frequency:<%=size%>, name:"<%=resu.get("blogger")%>", type:"blogger"},
<%}}}%></textarea>
			</form>
	</form>

	<!-- <footer class="footer">
  <div class="container-fluid bg-primary mt60">
<p class="text-center text-medium pt10 pb10 mb0">Copyright &copy; Blogtrackers 2017 All Rights Reserved.</p>
</div>
  </footer> -->
<!-- <script src="pagedependencies/dashboard.js?v=209">
</script> -->
<!-- Added for interactivity for selecting tracker and favorites actions -->

<!-- <script src="assets/js/generic.js">

</script> -->


	<script type="text/javascript" src="assets/js/jquery-1.11.3.min.js"></script>
	<script src="assets/bootstrap/js/bootstrap.js">
</script>
	<script src="assets/js/generic.js">
</script>
	<!-- date range scripts -->
	<script src="assets/vendors/bootstrap-daterangepicker/moment.js"></script>
	<script
		src="assets/vendors/bootstrap-daterangepicker/daterangepicker.js"></script>
	<!--End of date range scripts  -->
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
	
  // datatable setup
    $('#DataTables_Table_1_wrapper').DataTable( {
        "scrollY": 430,
        "scrollX": false,
         "pagingType": "simple"
      /*    ,
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

// table set up 2
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
                   // date range configuration
   var cb = function(start, end, label) {
          //console.log(start.toISOString(), end.toISOString(), label);
          //$('#reportrange span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
          $('#reportrange input').val(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY')).trigger('change');
        };

        var optionSet1 =
             {   startDate: moment().subtract(90, 'days'),
                 endDate: moment(),
                 minDate: '01/01/1947',
                 maxDate: moment(),
                 maxSpan: {
                     days: 50000
                 },
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
      //$('#reportrange span').html(moment().subtract( 500, 'days').format('MMMM D, YYYY') + ' - ' + moment().format('MMMM D, YYYY'))
     $('#reportrange, #custom').daterangepicker(optionSet1, cb);
     $('#reportrange, #custom')
     .on(
         'show.daterangepicker',
         function() {
         	console
               .log("show event fired"); 
         });
  $('#reportrange')
     .on(
         'hide.daterangepicker',
         function() {
           /* console
               .log("hide event fired"); */
         });
  $('#reportrange, #custom')
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
            	$("form#customform").submit();
         });
  $('#reportrange')
     .on(
         'cancel.daterangepicker',
         function(ev, picker) {
           console.log("cancel event fired"); 
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
	<!-- <script src="http://d3js.org/d3.v3.min.js"></script> -->
	<script type="text/javascript" src="assets/vendors/d3/d3.min.js"></script>
	<script src="assets/vendors/wordcloud/d3.layout.cloud.js"></script>
	<script type="text/javascript" src="assets/vendors/d3/d3_tooltip.js"></script>
	<!--start of language bar chart  -->
	<script>
$(function () {

    // Initialize chart
    languageusage('#languageusage', 455);

    // Chart setup
    function languageusage(element, height) {

      // Basic setup
      // ------------------------------

      // Define main variables
      var d3Container = d3.select(element),
          margin = {top: 5, right: 50, bottom: 20, left: 60},
          width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right,
          height = height - margin.top - margin.bottom - 5;

         var formatPercent = d3.format("");

      // Construct scales
      // ------------------------------

      // Horizontal
      var y = d3.scale.ordinal()
          .rangeRoundBands([height,0], .65, .65);

      // Vertical
      var x = d3.scale.linear()
          .range([0,width]);

      // Color
      var color = d3.scale.category20c();



      // Create axes
      // ------------------------------

      // Horizontal
      var xAxis = d3.svg.axis()
          .scale(x)
          .orient("bottom")
          .ticks(6);

      // Vertical
      var yAxis = d3.svg.axis()
          .scale(y)
          .orient("left")
          //.tickFormat(formatPercent);



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


      //         // Create tooltip
      //             // ------------------------------
      //
      //
      //
      // // Load data
      // // ------------------------------
      //
      //
      //
     data = [
    	  <%if (langlooper.size() > 0) {
						for (int y = 0; y < langlooper.size(); y++) {
							String key = langlooper.get(y).toString();%>
    		{letter:"<%=key%>", frequency:<%=language.get(key)%>},
    		<%}
					}%>

	 ]; 
     data.sort(function(a, b){
    	    return a.frequency - b.frequency;
    	});
     
   /*    data = [
            {letter:"English", frequency:2550},
            {letter:"Russian", frequency:800},
            {letter:"Spanish", frequency:500},
            {letter:"French", frequency:1700},
            {letter:"Arabic", frequency:1900},
            {letter:"Unknown", frequency:1500}
        ]; */
      
      //
      //
      //   // Create tooltip
        var tip = d3.tip()
               .attr('class', 'd3-tip')
               .offset([-10, 0])
               .html(function(d) {
                   return d.letter+" ("+d.frequency+")";
               });

           // Initialize tooltip
           svg.call(tip);

      //
      //     // Pull out values
      //     data.forEach(function(d) {
      //         d.frequency = +d.frequency;
      //     });
      //
      //
      //
      //     // Set input domains
      //     // ------------------------------
      //
      //    // Vertical
          y.domain(data.map(function(d) { return d.letter; }));

          
          
          // Horizontal domain
          x.domain([0,d3.max(data, function(d) { return d.frequency; })]);
      //
      //
      //     //
      //     // Append chart elements
      //     //
      //
      //     // Append axes
      //     // ------------------------------
      //
          // Horizontal
          svg.append("g")
              .attr("class", "d3-axis d3-axis-horizontal d3-axis-strong")
              .attr("transform", "translate(0," + height + ")")
              .call(xAxis);

          // Vertical
          var verticalAxis = svg.append("g")
              .attr("class", "d3-axis d3-axis-vertical d3-axis-strong")
              .style("color","yellow")
              .call(yAxis);
      //
      //
      //     // Add text label
      //     verticalAxis.append("text")
      //         .attr("transform", "rotate(-90)")
      //         .attr("y", 10)
      //         .attr("dy", ".71em")
      //         .style("text-anchor", "end")
      //         .style("fill", "#999")
      //         .style("font-size", 12)
      //         // .text("Frequency")
      //         ;
      //
      //
      //     // Add bars
          svg.selectAll(".d3-bar")
              .data(data)
              .enter()
              .append("rect")
                  .attr("class", "d3-bar")
                  .attr("y", function(d) { return y(d.letter); })
                  .attr("height", y.rangeBand())
                  .attr("x", function(d) { return 0; })
                  .attr("width", function(d) { return x(d.frequency); })
                   .style("fill", function(d) {
                  maxvalue = d3.max(data, function(d) { return d.frequency; });
                  if(d.frequency == maxvalue)
                  {
                    return "0080CC";
                  }
                  else
                  {
                    return "#78BCE4";
                  }

                }) 
                  .on('mouseover', tip.show)
                  .on('mouseout', tip.hide);


                  // svg.selectAll(".d3-bar")
                  //     .data(data)
                  //     .enter()
                  //     .append("rect")
                  //         .attr("class", "d3-bar")
                  //         .attr("x", function(d) { return x(d.letter); })
                  //         .attr("width", x.rangeBand())
                  //         .attr("y", function(d) { return y(d.frequency); })
                  //         .attr("height", function(d) { return height - y(d.frequency); })
                  //         .style("fill", function(d) { return "#58707E"; })
                  //         .on('mouseover', tip.show)
                  //         .on('mouseout', tip.hide);





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


            // // Layout
            // // -------------------------
            //
            // // Main svg width
            container.attr("width", width + margin.left + margin.right);

            // Width of appended group
            svg.attr("width", width + margin.left + margin.right);
            //
            //
            // // Axes
            // // -------------------------
            //
            // // Horizontal range
           x.range([0,width]);
            //
            // // Horizontal axis
            svg.selectAll('.d3-axis-horizontal').call(xAxis);
             // svg.selectAll('.d3-bar-vertical').call(yAxis);

            //
            // // Chart elements
            // // -------------------------
            //
            // // Line path
           svg.selectAll('.d3-bar').attr("width", function(d) { return x(d.frequency); });
        }
    }
});
</script>

	<!-- End of language bar chart  -->

	<!-- start of influence bar chart  -->
	<script>
$(function () {

    // Initialize chart
    influencebar('#influencebar', 450);

    // Chart setup
    function influencebar(element, height) {

      // Basic setup
      // ------------------------------

      // Define main variables
      var d3Container = d3.select(element),
          margin = {top: 5, right: 50, bottom: 20, left: 60},
          width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right,
          height = height - margin.top - margin.bottom - 5;

         var formatPercent = d3.format("");

      // Construct scales
      // ------------------------------

      // Horizontal
      var y = d3.scale.ordinal()
          .rangeRoundBands([height,0], .5, .40);

      // Vertical
      var x = d3.scale.linear()
          .range([0,width]);

      // Color
      var color = d3.scale.category20c();



      // Create axes
      // ------------------------------

      // Horizontal
      var xAxis = d3.svg.axis()
          .scale(x)
          .orient("bottom")
          .ticks(6);

      // Vertical
      var yAxis = d3.svg.axis()
          .scale(y)
          .orient("left")
          //.tickFormat(formatPercent);



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


      //         // Create tooltip
      //             // ------------------------------
      //
      //
      //
      // // Load data
      // // ------------------------------
      //
      //
      //sort by influence score
      data = [
    	  <% if (authors.length() > 0) {
				int p = 0;
				//System.out.println(bloggers);
				for (int y = 0; y < authors.length(); y++) {
					String key = authorlooper.get(y).toString();
					JSONObject resu = authors.getJSONObject(key);
					Double size = Double.parseDouble(resu.get("influence").toString());
					if (p < 10) {
						p++;%>
		{letter:"<%=resu.get("blogger")%>", frequency:<%=size%>, name:"<%=resu.get("blogger")%>", type:"blogger"},
		 <%}
				}
			}%>    
        ];
      data = data.sort(function(a, b){
    	    return a.frequency - b.frequency;
    	}); 
      //
      //
      //   // Create tooltip
        var tip = d3.tip()
               .attr('class', 'd3-tip')
               .offset([-10, 0])
               .html(function(d) {
                 if(d.type === "blogger")
                 {
                   return d.letter+" ("+d.frequency+")<br/> Blogger: "+d.name;
                 }

                 if(d.type === "blog")
                 {
                   return d.letter+" ("+d.frequency+")<br/> Blog: "+d.name;
                 }

               });

           // Initialize tooltip
           svg.call(tip);

      //
      //     // Pull out values
      //     data.forEach(function(d) {
      //         d.frequency = +d.frequency;
      //     });
      //
      //
      //
      //     // Set input domains
      //     // ------------------------------
      //
      //     // Horizontal
          y.domain(data.map(function(d) { return d.letter; }));

          // Vertical
          x.domain([d3.min(data, function(d) { return d.frequency; }),d3.max(data, function(d) { return d.frequency; })]);
      //
      //
      //     //
      //     // Append chart elements
      //     //
      //
      //     // Append axes
      //     // ------------------------------
      //
          // Horizontal
          svg.append("g")
              .attr("class", "d3-axis d3-axis-horizontal d3-axis-strong")
              .attr("transform", "translate(0," + height + ")")
              .call(xAxis);

          // Vertical
          var verticalAxis = svg.append("g")
              .attr("class", "d3-axis d3-axis-vertical d3-axis-strong")
              .style("color","yellow")
              .call(yAxis)
              .selectAll("text")
   			.attr("y", -25)
    		.attr("x", 20)
    		.attr("dy", ".75em")
    		.attr("transform", "rotate(-70)");
      //
      //
      //     // Add text label
      //     verticalAxis.append("text")
      //         .attr("transform", "rotate(-90)")
      //         .attr("y", 10)
      //         .attr("dy", ".71em")
      //         .style("text-anchor", "end")
      //         .style("fill", "#999")
      //         .style("font-size", 12)
      //         // .text("Frequency")
      //         ;
      //
      //
      //     // Add bars
          svg.selectAll(".d3-bar")
              .data(data)
              .enter()
              .append("rect")
                  .attr("class", "d3-bar")
                  .attr("y", function(d) { return y(d.letter); })
                  .attr("height", y.rangeBand())
                  .attr("x", function(d) { return 0; })
                  .attr("width", function(d) { return x(d.frequency); })
                  .style("fill", function(d) {
                  maxvalue = d3.max(data, function(d) { return d.frequency; });
                  if(d.frequency == maxvalue)
                  {
                    return "0080CC";
                  }
                  else
                  {
                    return "#78BCE4";
                  }

                })
                  .on('mouseover', tip.show)
                  .on('mouseout', tip.hide);


                  // svg.selectAll(".d3-bar")
                  //     .data(data)
                  //     .enter()
                  //     .append("rect")
                  //         .attr("class", "d3-bar")
                  //         .attr("x", function(d) { return x(d.letter); })
                  //         .attr("width", x.rangeBand())
                  //         .attr("y", function(d) { return y(d.frequency); })
                  //         .attr("height", function(d) { return height - y(d.frequency); })
                  //         .style("fill", function(d) { return "#58707E"; })
                  //         .on('mouseover', tip.show)
                  //         .on('mouseout', tip.hide);





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


            // // Layout
            // // -------------------------
            //
            // // Main svg width
            container.attr("width", width + margin.left + margin.right);

            // Width of appended group
            svg.attr("width", width + margin.left + margin.right);
            //
            //
            // // Axes
            // // -------------------------
            //
            // // Horizontal range
           x.range([0,width]);
            //
            // // Horizontal axis
            svg.selectAll('.d3-axis-horizontal').call(xAxis);
             // svg.selectAll('.d3-bar-vertical').call(yAxis);

            //
            // // Chart elements
            // // -------------------------
            //
            // // Line path
           svg.selectAll('.d3-bar').attr("width", function(d) { return x(d.frequency); });
        }
    }
});
</script>

	<!--  End of influence bar -->

	<!-- start of posting frequency  -->
	<script>
$(function () {

    // Initialize chart
    postingfrequencybar('#postingfrequencybar', 450);

    // Chart setup
    function postingfrequencybar(element, height) {

      // Basic setup
      // ------------------------------

      // Define main variables
      var d3Container = d3.select(element),
          margin = {top: 5, right: 50, bottom: 20, left: 60},
          width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right,
          height = height - margin.top - margin.bottom - 5;

         var formatPercent = d3.format("");

      // Construct scales
      // ------------------------------

      // Horizontal
      var y = d3.scale.ordinal()
          .rangeRoundBands([height,0], .5, .40);

      // Vertical
      var x = d3.scale.linear()
          .range([0,width]);

      // Color
    //  var color = d3.scale.category20c();

  	
      // Create axes
      // ------------------------------

      // Horizontal
      var xAxis = d3.svg.axis()
          .scale(x)
          .orient("bottom")
          .ticks(6);

      // Vertical
      var yAxis = d3.svg.axis()
          .scale(y)
          .orient("left")
          //.tickFormat(formatPercent);



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


      //         // Create tooltip
      //             // ------------------------------
      //
      //
      //
      // // Load data
      // // ------------------------------
      //
      //
      //
      data = [
    		 <% if (bloggers.length() > 0) {
						int p = 0;
						//System.out.println(bloggers);
						for (int y = 0; y < bloggers.length(); y++) {
							String key = looper.get(y).toString();
							JSONObject resu = bloggers.getJSONObject(key);
							int size = Integer.parseInt(resu.get("postingfreq").toString());
							if (size > 200 && p < 10) {
								p++;%>
    							{letter:"<%=resu.get("blog")%>", frequency:<%=size%>, name:"<%=resu.get("blogger")%>", type:"blogger"},
    		 <% 			}
					}
				}
			%>
            //{letter:"Blog 5", frequency:2550, name:"Obadimu Adewale", type:"blogger"},
            
        ];
      
      data = data.sort(function(a, b){
  	    return a.frequency - b.frequency;
  	});
      
      //
      //
      //   // Create tooltip
        var tip = d3.tip()
               .attr('class', 'd3-tip')
               .offset([-10, 0])
               .html(function(d) {
                 if(d.type === "blogger")
                 {
                   return d.letter+" ("+d.frequency+")<br/> Blogger: "+d.name;
                 }

                 if(d.type === "blog")
                 {
                   return d.letter+" ("+d.frequency+")<br/> Blog: "+d.name;
                 }

               });

           // Initialize tooltip
           svg.call(tip);

      //
      //     // Pull out values
      //     data.forEach(function(d) {
      //         d.frequency = +d.frequency;
      //     });
      //
      //
      //
      //     // Set input domains
      //     // ------------------------------
      //
      //     // Horizontal
          y.domain(data.map(function(d) { return d.letter; }))

          // Vertical
          x.domain([0,d3.max(data, function(d) { return d.frequency; })]);
      //
      //
      //     //
      //     // Append chart elements
      //     //
      //
      //     // Append axes
      //     // ------------------------------
      //
          // Horizontal
          svg.append("g")
              .attr("class", "d3-axis d3-axis-horizontal d3-axis-strong")
              .attr("transform", "translate(0," + height + ")")
              .call(xAxis);

          // Vertical
          var verticalAxis = svg.append("g")
              .attr("class", "d3-axis d3-axis-vertical d3-axis-strong")
              .style("color","yellow")
              .call(yAxis)
              .selectAll("text")
   			.attr("y", -25)
    			.attr("x", 40)
    		.attr("dy", ".75em")
    		.attr("transform", "rotate(-70)")
              ;
      //
      //
      //     // Add text label
      //     verticalAxis.append("text")
      //         .attr("transform", "rotate(-90)")
      //         .attr("y", 10)
      //         .attr("dy", ".71em")
      //         .style("text-anchor", "end")
      //         .style("fill", "#999")
      //         .style("font-size", 12)
      //         // .text("Frequency")
      //         ;
      //
      //
      //     // Add bars
      
      var colorblogs = d3.scale.linear()
	.domain([0,1,2,3,4,5,6,10,15,20])
	.range(["#17394C", "#FFBB78", "#CE0202", "#0080CC", "#72C28E", "#D6A78D", "#FF7E7E", "#666", "#555", "#444"]);

          svg.selectAll(".d3-bar")
              .data(data)
              .enter()
              .append("rect")
                  .attr("class", "d3-bar")
                  .attr("y", function(d) { return y(d.letter); })
                  .attr("height", y.rangeBand())
                  .attr("x", function(d) { return 0; })
                  .attr("width", function(d) { return x(d.frequency); })
                  .style("fill", function(d,i) {
                 // maxvalue = d3.max(data, function(d) { return d.frequency; });
                 //console.log(i)
                /*    if(i == 0)
                  {
                	console.log(i)
                    return "#17394C";
                  }
                   else if(i == 1)
                   {
                 	console.log(i)
                     return "#FFBB78";
                   }
                   else
                  {
                    return "#78BCE4";
                  } */
                  //console.log(data.length - i -1)
                  return colorblogs(data.length - i - 1);

                })
                  .on('mouseover', tip.show)
                  .on('mouseout', tip.hide);


                  // svg.selectAll(".d3-bar")
                  //     .data(data)
                  //     .enter()
                  //     .append("rect")
                  //         .attr("class", "d3-bar")
                  //         .attr("x", function(d) { return x(d.letter); })
                  //         .attr("width", x.rangeBand())
                  //         .attr("y", function(d) { return y(d.frequency); })
                  //         .attr("height", function(d) { return height - y(d.frequency); })
                  //         .style("fill", function(d) { return "#58707E"; })
                  //         .on('mouseover', tip.show)
                  //         .on('mouseout', tip.hide);





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


            // // Layout
            // // -------------------------
            //
            // // Main svg width
            container.attr("width", width + margin.left + margin.right);

            // Width of appended group
            svg.attr("width", width + margin.left + margin.right);
            //
            //
            // // Axes
            // // -------------------------
            //
            // // Horizontal range
           x.range([0,width]);
            //
            // // Horizontal axis
            svg.selectAll('.d3-axis-horizontal').call(xAxis);
             // svg.selectAll('.d3-bar-vertical').call(yAxis);

            //
            // // Chart elements
            // // -------------------------
            //
            // // Line path
           svg.selectAll('.d3-bar').attr("width", function(d) { return x(d.frequency); });
        }
    }
});

</script>
	<!-- end of posting frequency  -->
	<!--  Start of sentiment Bar Chart -->
	<script>
$(function () {

    // Initialize chart
    sentimentbar('#sentimentbar', 400);

    // Chart setup
    function sentimentbar(element, height) {

      // Basic setup
      // ------------------------------

      // Define main variables
      var d3Container = d3.select(element),
          margin = {top: 5, right: 50, bottom: 20, left: 60},
          width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right,
          height = height - margin.top - margin.bottom - 5;

         var formatPercent = d3.format("");

      // Construct scales
      // ------------------------------

      // Horizontal
      var y = d3.scale.ordinal()
          .rangeRoundBands([height,0], .6, .8);

      // Vertical
      var x = d3.scale.linear()
          .range([0,width]);

      // Color
      var color = d3.scale.category20c();



      // Create axes
      // ------------------------------

      // Horizontal
      var xAxis = d3.svg.axis()
          .scale(x)
          .orient("bottom")
          .ticks(6);

      // Vertical
      var yAxis = d3.svg.axis()
          .scale(y)
          .orient("left")
          //.tickFormat(formatPercent);



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


      //         // Create tooltip
      //             // ------------------------------
      //
      //
      //
      // // Load data
      // // ------------------------------
      //
      //
      //
      data = [
            {letter:"Negative", frequency:<%=negsentiment%>},
            {letter:"Positive", frequency:<%=possentiment%>}
        ];
      //
      //
      //   // Create tooltip
        var tip = d3.tip()
               .attr('class', 'd3-tip')
               .offset([-10, 0])
               .html(function(d) {
                   return d.letter+" ("+d.frequency+")";
               });

           // Initialize tooltip
           svg.call(tip);

           var color = d3.scale.linear()
                   .domain([0,1])
                   .range(["#FF7D7D", "#72c28e"]);


      //
      //     // Pull out values
      //     data.forEach(function(d) {
      //         d.frequency = +d.frequency;
      //     });
      //
      //
      //
      //     // Set input domains
      //     // ------------------------------
      //
      //     // Horizontal
          y.domain(data.map(function(d) { return d.letter; }));

          // Vertical
          x.domain([0,d3.max(data, function(d) { return d.frequency; })]);
      //
      //
      //     //
      //     // Append chart elements
      //     //
      //
      //     // Append axes
      //     // ------------------------------
      //
          // Horizontal
          svg.append("g")
              .attr("class", "d3-axis d3-axis-horizontal d3-axis-strong")
              .attr("transform", "translate(0," + height + ")")
              .call(xAxis);

          // Vertical
          var verticalAxis = svg.append("g")
              .attr("class", "d3-axis d3-axis-vertical d3-axis-strong")
              .style("color","yellow")
              .call(yAxis);
      //
      //
      //     // Add text label
      //     verticalAxis.append("text")
      //         .attr("transform", "rotate(-90)")
      //         .attr("y", 10)
      //         .attr("dy", ".71em")
      //         .style("text-anchor", "end")
      //         .style("fill", "#999")
      //         .style("font-size", 12)
      //         // .text("Frequency")
      //         ;
      //
      //
      //     // Add bars
          svg.selectAll(".d3-bar")
              .data(data)
              .enter()
              .append("rect")
                  .attr("class", "d3-bar")
                  .attr("y", function(d) { return y(d.letter); })
                  .attr("height", y.rangeBand())
                  .attr("x", function(d) { return 0; })
                  .attr("width", function(d) { return x(d.frequency); })
                  .style("fill", function(d,i) { return color(i);   })
                  .on('mouseover', tip.show)
                  .on('mouseout', tip.hide);


                  // svg.selectAll(".d3-bar")
                  //     .data(data)
                  //     .enter()
                  //     .append("rect")
                  //         .attr("class", "d3-bar")
                  //         .attr("x", function(d) { return x(d.letter); })
                  //         .attr("width", x.rangeBand())
                  //         .attr("y", function(d) { return y(d.frequency); })
                  //         .attr("height", function(d) { return height - y(d.frequency); })
                  //         .style("fill", function(d) { return "#58707E"; })
                  //         .on('mouseover', tip.show)
                  //         .on('mouseout', tip.hide);





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


            // // Layout
            // // -------------------------
            //
            // // Main svg width
            container.attr("width", width + margin.left + margin.right);

            // Width of appended group
            svg.attr("width", width + margin.left + margin.right);
            //
            //
            // // Axes
            // // -------------------------
            //
            // // Horizontal range
           x.range([0,width]);
            //
            // // Horizontal axis
            svg.selectAll('.d3-axis-horizontal').call(xAxis);
             // svg.selectAll('.d3-bar-vertical').call(yAxis);

            //
            // // Chart elements
            // // -------------------------
            //
            // // Line path
           svg.selectAll('.d3-bar').attr("width", function(d) { return x(d.frequency); });
        }
    }
});
</script>

	<script type="text/javascript">
// map data
var gdpData = {
  "AF": 16.63,
  "AL": 11.58,
  "DZ": 158.97,
  "AO": 85.81,
  "AG": 1.1,
  "AR": 351.02,
  "AM": 8.83,
  "AU": 1219.72,
  "AT": 366.26,
  "AZ": 52.17,
  "BS": 7.54,
  "BH": 21.73,
  "BD": 105.4,
  "BB": 3.96,
  "BY": 52.89,
  "BE": 461.33,
  "BZ": 1.43,
  "BJ": 6.49,
  "BT": 1.4,
  "BO": 19.18,
  "BA": 16.2,
  "BW": 12.5,
  "BR": 2023.53,
  "BN": 11.96,
  "BG": 44.84,
  "BF": 8.67,
  "BI": 1.47,
  "KH": 11.36,
  "CM": 21.88,
  "CA": 1563.66,
  "CV": 1.57,
  "CF": 2.11,
  "TD": 7.59,
  "CL": 199.18,
  "CN": 5745.13,
  "CO": 283.11,
  "KM": 0.56,
  "CD": 12.6,
  "CG": 11.88,
  "CR": 35.02,
  "CI": 22.38,
  "HR": 59.92,
  "CY": 22.75,
  "CZ": 195.23,
  "DK": 304.56,
  "DJ": 1.14,
  "DM": 0.38,
  "DO": 50.87,
  "EC": 61.49,
  "EG": 216.83,
  "SV": 21.8,
  "GQ": 14.55,
  "ER": 2.25,
  "EE": 19.22,
  "ET": 30.94,
  "FJ": 3.15,
  "FI": 231.98,
  "FR": 2555.44,
  "GA": 12.56,
  "GM": 1.04,
  "GE": 11.23,
  "DE": 3305.9,
  "GH": 18.06,
  "GR": 305.01,
  "GD": 0.65,
  "GT": 40.77,
  "GN": 4.34,
  "GW": 0.83,
  "GY": 2.2,
  "HT": 6.5,
  "HN": 15.34,
  "HK": 226.49,
  "HU": 132.28,
  "IS": 12.77,
  "IN": 1430.02,
  "ID": 695.06,
  "IR": 337.9,
  "IQ": 84.14,
  "IE": 204.14,
  "IL": 201.25,
  "IT": 2036.69,
  "JM": 13.74,
  "JP": 5390.9,
  "JO": 27.13,
  "KZ": 129.76,
  "KE": 32.42,
  "KI": 0.15,
  "KR": 986.26,
  "UNDEFINED": 5.73,
  "KW": 117.32,
  "KG": 4.44,
  "LA": 6.34,
  "LV": 23.39,
  "LB": 39.15,
  "LS": 1.8,
  "LR": 0.98,
  "LY": 77.91,
  "LT": 35.73,
  "LU": 52.43,
  "MK": 9.58,
  "MG": 8.33,
  "MW": 5.04,
  "MY": 218.95,
  "MV": 1.43,
  "ML": 9.08,
  "MT": 7.8,
  "MR": 3.49,
  "MU": 9.43,
  "MX": 1004.04,
  "MD": 5.36,
  "MN": 5.81,
  "ME": 3.88,
  "MA": 91.7,
  "MZ": 10.21,
  "MM": 35.65,
  "NA": 11.45,
  "NP": 15.11,
  "NL": 770.31,
  "NZ": 138,
  "NI": 6.38,
  "NE": 5.6,
  "NG": 206.66,
  "NO": 413.51,
  "OM": 53.78,
  "PK": 174.79,
  "PA": 27.2,
  "PG": 8.81,
  "PY": 17.17,
  "PE": 153.55,
  "PH": 189.06,
  "PL": 438.88,
  "PT": 223.7,
  "QA": 126.52,
  "RO": 158.39,
  "RU": 1476.91,
  "RW": 5.69,
  "WS": 0.55,
  "ST": 0.19,
  "SA": 434.44,
  "SN": 12.66,
  "RS": 38.92,
  "SC": 0.92,
  "SL": 1.9,
  "SG": 217.38,
  "SK": 86.26,
  "SI": 46.44,
  "SB": 0.67,
  "ZA": 354.41,
  "ES": 1374.78,
  "LK": 48.24,
  "KN": 0.56,
  "LC": 1,
  "VC": 0.58,
  "SD": 65.93,
  "SR": 3.3,
  "SZ": 3.17,
  "SE": 444.59,
  "CH": 522.44,
  "SY": 59.63,
  "TW": 426.98,
  "TJ": 5.58,
  "TZ": 22.43,
  "TH": 312.61,
  "TL": 0.62,
  "TG": 3.07,
  "TO": 0.3,
  "TT": 21.2,
  "TN": 43.86,
  "TR": 729.05,
  "TM": 0,
  "UG": 17.12,
  "UA": 136.56,
  "AE": 239.65,
  "GB": 2258.57,
  "US": 0,
  "UY": 40.71,
  "UZ": 37.72,
  "VU": 0.72,
  "VE": 285.21,
  "VN": 101.99,
  "YE": 30.02,
  "ZM": 15.69,
  "ZW": 5.57
};
// add the list of location of craweled blog here
/*
    
    /*
    {latLng: [39.092, -94.575], name: 'Kansas City'},
    {latLng: [25.782, -80.231], name: 'Miami'},
    {latLng: [8.967, -79.458], name: 'Panama City'},
    {latLng: [19.400, -99.124], name: 'Mexico City'},
    {latLng: [40.705, -73.978], name: 'New York'},
    {latLng: [33.98, -118.132], name: 'Los Angeles'},
    {latLng: [47.614, -122.335], name: 'Seattle'},
    {latLng: [44.97, -93.261], name: 'Minneapolis'},
    {latLng: [39.73, -105.015], name: 'Denver'},
    {latLng: [41.833, -87.732], name: 'Chicago'},
    {latLng: [29.741, -95.395], name: 'Houston'},
    {latLng: [23.05, -82.33], name: 'Havana'},
    {latLng: [45.41, -75.70], name: 'Ottawa'},
    {latLng: [53.555, -113.493], name: 'Edmonton'},
    {latLng: [-0.23, -78.52], name: 'Quito'},
    {latLng: [18.50, -69.99], name: 'Santo Domingo'},
    {latLng: [4.61, -74.08], name: 'Bogotá'},
    {latLng: [14.08, -87.21], name: 'Tegucigalpa'},
    {latLng: [17.25, -88.77], name: 'Belmopan'},
    {latLng: [14.64, -90.51], name: 'New Guatemala'},
    {latLng: [-15.775, -47.797], name: 'Brasilia'},
    {latLng: [-3.790, -38.518], name: 'Fortaleza'},
    {latLng: [50.402, 30.532], name: 'Kiev'},
    {latLng: [53.883, 27.594], name: 'Minsk'},
    {latLng: [52.232, 21.061], name: 'Warsaw'},
    {latLng: [52.507, 13.426], name: 'Berlin'},
    {latLng: [50.059, 14.465], name: 'Prague'},
    {latLng: [47.481, 19.130], name: 'Budapest'},
    {latLng: [52.374, 4.898], name: 'Amsterdam'},
    {latLng: [48.858, 2.347], name: 'Paris'},
    {latLng: [40.437, -3.679], name: 'Madrid'},
    {latLng: [39.938, 116.397], name: 'Beijing'},
    {latLng: [28.646, 77.093], name: 'Delhi'},
    {latLng: [25.073, 55.229], name: 'Dubai'},
    {latLng: [35.701, 51.349], name: 'Tehran'},
    {latLng: [7.11, 171.06], name: 'Marshall Islands'},
    {latLng: [17.3, -62.73], name: 'Saint Kitts and Nevis'},
    {latLng: [3.2, 73.22], name: 'Maldives'},
    {latLng: [35.88, 14.5], name: 'Malta'},
    {latLng: [12.05, -61.75], name: 'Grenada'},
    {latLng: [13.16, -61.23], name: 'Saint Vincent and the Grenadines'},
    {latLng: [13.16, -59.55], name: 'Barbados'},
    {latLng: [17.11, -61.85], name: 'Antigua and Barbuda'},
    {latLng: [-4.61, 55.45], name: 'Seychelles'},
    {latLng: [7.35, 134.46], name: 'Palau'},
    {latLng: [42.5, 1.51], name: 'Andorra'},
    {latLng: [14.01, -60.98], name: 'Saint Lucia'},
    {latLng: [6.91, 158.18], name: 'Federated States of Micronesia'},
    {latLng: [1.3, 103.8], name: 'Singapore'},
    {latLng: [1.46, 173.03], name: 'Kiribati'},
    {latLng: [-21.13, -175.2], name: 'Tonga'},
    {latLng: [15.3, -61.38], name: 'Dominica'},
    {latLng: [-20.2, 57.5], name: 'Mauritius'},
    {latLng: [26.02, 50.55], name: 'Bahrain'},
    
    {latLng: [0.33, 6.73], name: 'São Tomé and Príncipe'}
    */ 

<%JSONObject location = new JSONObject();
					location.put("null", "0, 0");
					location.put("unknown", "0, 0");
					location.put("Vatican City", "41.90, 12.45");
					location.put("Monaco", "43.73, 7.41");
					location.put("Salt Lake City", "40.726, -111.778");
					location.put("Kansas City", "39.092, -94.575");
					location.put("US", "37.0902, -95.7129");
					location.put("DE", "51.165691, 10.451526");
					location.put("LT", "55.1694, 23.8813");
					location.put("GB", "55.3781, -3.4360");
					location.put("NL", "52.132633, 5.291266");
					location.put("VE", "6.423750, -66.589729");
					location.put("LV", "56.8796, 24.6032");
					location.put("UA", "48.379433, 31.165581");
					location.put("RU", "61.524010, 105.318756");
					location.put("PA", "8.967, -79.458");
					location.put("TR", "38.9637, 35.2433");
					location.put("FR", "46.2276, 2.2137");
					location.put("PL", "51.9194, 19.1451");
					location.put("EE", "58.5953, 25.0136");
					location.put("ZW", "19.0154, 29.1549");
					location.put("SK", "48.6690, 19.6990");
					location.put("IE", "53.4129, 8.2439");
					location.put("IT","41.871941,12.567380");
					location.put("ES","40.463669,-3.749220");
					%>
// map marker location by longitude and latitude
var mymarker = [
	<%if (blogs.size() > 0) {
						String bres = null;
						JSONObject bresp = null;
						String bresu = null;
						JSONObject bobj = null;
						for (int k = 0; k < blogs.size(); k++) {
							bres = blogs.get(k).toString();
							bresp = new JSONObject(bres);
							bresu = bresp.get("_source").toString();
							bobj = new JSONObject(bresu);
							if (location.has(bobj.get("location").toString())) {%>
	 		{latLng: [<%=location.get(bobj.get("location").toString())%>], name: '<%=bobj.get("location").toString()%>'},
			<%}
						}
					}%>
]
  </script>
	<script type="text/javascript"
		src="assets/vendors/maps/jvectormap/jvectormap.min.js"></script>
	<script type="text/javascript"
		src="assets/vendors/maps/jvectormap/map_files/world.js"></script>
	<script type="text/javascript"
		src="assets/vendors/maps/jvectormap/map_files/countries/usa.js"></script>
	<script type="text/javascript"
		src="assets/vendors/maps/jvectormap/map_files/countries/germany.js"></script>
	<script type="text/javascript"
		src="assets/vendors/maps/vector_maps_demo.js"></script>

	<!--word cloud  -->
	<script>
	
	wordtagcloud("#tagcloudcontainer",450);
	
	function wordtagcloud(element, height) {
		
		var d3Container = d3.select(element),
        margin = {top: 5, right: 50, bottom: 20, left: 60},
        width = d3Container.node().getBoundingClientRect().width,
        height = height - margin.top - margin.bottom - 5;
		
		var container = d3Container.append("svg");

     var frequency_list = [
    	 <%if (topterms.length() > 0) {
						for (int i = 0; i < topterms.length(); i++) {
							JSONObject jsonObj = topterms.getJSONObject(i);
							int size = Integer.parseInt(jsonObj.getString("frequency")) * 5;%>
    		{"text":"<%=jsonObj.getString("key")%>","size":<%=size%>},
    	 <%}
					}%>
    	
    
    	 ];
	

     var color = d3.scale.linear()
             .domain([0,1,2,3,4,5,6,10,12,15,20])
             .range(["#0080CC", "#FFBB78", "#CE0202", "#0080CC", "#72C28E", "#D6A78D", "#FF7E7E", "#666", "#555", "#444"]);
     var svg =  container;
     d3.layout.cloud().size([450,400])
             .words(frequency_list)
             .rotate(0)
             .fontSize(function(d) { return d.size * 0.9; })
             .on("end", draw)
             .start();
    
     
    	  /* var zoom = d3.behavior.zoom()
     		//.x(x)
    		//.y(y)
            .scaleExtent([1, 10])
            .on("zoom", zoomed);   
     
             function zoomed() {
                /* svg.select(".d3-axis-horizontal").call(xAxis);
                svg.select(".d3-axis-vertical").call(yAxis);   
                svg.selectAll('.d3-line').attr('d', line); 

                points.selectAll('.d3-dot').attr("transform", function(d) { 
                    return "translate(" + x(d.point.x) + "," + y(d.point.y) + ")"; } */
                
              /*   var g = svg.selectAll("g"); 
            	//g.attr("transform", "translate(165,180)" + " scale(" + d3.event.scale + ")")
            	
            	g.attr("transform", function(d) { 
                    return "translate(" + x(d.point.x) + "," + y(d.point.y) + ")"; }
            	
                );  
            } */  
     function draw(words) {
    	 		svg
                 .attr("width", width)
                 .attr("height", height)
                 //.attr("class", "wordcloud")
                 .append("g")
                 /* .call(d3.behavior.zoom().on("zoom", function () {
                	 
                	    svg.attr("transform", "translate(" + d3.event.translate + ")" + " scale(" + d3.event.scale + ")")
                	    
                 })) */
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
                 .style("font-size", function(d) { return d.size * 0.93 + "px"; })
                 .style("fill", function(d, i) { return color(i); })
                 .call(d3.behavior.drag()
         		.origin(function(d) { return d; })
         		.on("dragstart", dragstarted) 
         		.on("drag", dragged)			
         		)
                 .attr("transform", function(d) {
                     return "translate(" + [d.x + 12, d.y + 3] + ")rotate(" + d.rotate + ")";
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
 </script>
<!-- End of Tag Cloud  -->
	<!-- Blogger Bubble Chart -->
	<script>


$(function () {

    // Initialize chart
    bubblesblogger('#bubblesblogger', 470);

    // Chart setup
    function bubblesblogger(element, diameter) {


        // Basic setup
        // ------------------------------

        // Format data
        var format = d3.format(",d");

        // Color scale
        color = d3.scale.category10();

        // Define main variables
        var d3Container = d3.select(element),
            margin = {top: 5, right: 20, bottom: 20, left: 50},
            width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right,
            height = height - margin.top - margin.bottom;
            diamter = height;




            // Add SVG element
            var container = d3Container.append("svg");

            // Add SVG group
            var svg = container
                .attr("width", diameter + margin.left + margin.right)
                .attr("height",diameter + margin.top + margin.bottom)
                .attr("class", "bubble");

        // Create chart
        // ------------------------------

        // var svg = d3.select(element).append("svg")
        //     .attr("width", diameter)
        //     .attr("height", diameter)
        //     .attr("class", "bubble");



        // Create chart
        // ------------------------------

        // Add tooltip
        var tip = d3.tip()
            .attr('class', 'd3-tip')
            .offset([-5, 0])
            .html(function(d) {
                return d.label+"<br/>"+d.className + ": " + format(d.value);;
            });

        // Initialize tooltip
        svg.call(tip);



        // Construct chart layout
        // ------------------------------

        // Pack
        var bubble = d3.layout.pack()
            .sort(null)
            .size([diameter, diameter])
            .padding(15);



        // Load data
        // ------------------------------



data = {
 "name":"flare",
 "bloggers":[
	 <%if (bloggers.length() > 0) {
			int k = 0;
			//System.out.println("Bloggers here:"+bloggers);
			for (int y = 0; y < bloggers.length(); y++) {

				String key = looper.get(y).toString();
				JSONObject resu = bloggers.getJSONObject(key);
				int size = Integer.parseInt(resu.get("totalposts").toString());
				if (size > 0 && k < 15) {
					k++;%>
{"label":"<%=resu.get("blogger")%>","name":"<%=resu.get("blog")%>", "size":<%=resu.get("value")%>},
<%}
			}
		}%>
 /* {"label":"Blogger 2","name":"Obadimu Adewale", "size":2500},
 {"label":"Blogger 3","name":"Oluwaseun Walter", "size":2800},
 {"label":"Blogger 4","name":"Kiran Bandeli", "size":900},
 {"label":"Blogger 5","name":"Adekunle Mayowa", "size":1400},
 {"label":"Blogger 6","name":"Nihal Hussain", "size":200},
 {"label":"Blogger 7","name":"Adekunle Mayowa", "size":500},
 {"label":"Blogger 8","name":"Adekunle Mayowa", "size":300},
 {"label":"Blogger 9","name":"Adekunle Mayowa", "size":350},
 {"label":"Blogger 10","name":"Adekunle Mayowa", "size":1400}
 */
 ]
}


            //
            // Append chart elements
            //
 			
            // Bind data
            var node = svg.selectAll(".d3-bubbles-node")
                .data(bubble.nodes(classes(data))
                .filter(function(d) { return !d.children; }))
                .enter()
                .append("g")
                    .attr("class", "d3-bubbles-node")
                    .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });
        
			var color = d3.scale.linear()
			.domain([0,1,2,3,4,5,6,10,15,20])
			.range(["#17394C", "#FFBB78", "#CE0202", "#0080CC", "#72C28E", "#D6A78D", "#FF7E7E", "#666", "#555", "#444"]);


            // Append circles
            node.append("circle")
                .attr("r", function(d) { return d.r; })
                .style("fill", function(d,i) {
                   return color(i);
                  // customize Color
                 /*  if(i<5)
                  {
                    return "#0080cc";
                  }
                  else if(i>=5)
                  {
                    return "#78bce4";
                  } */
                })
                .on('mouseover', tip.show)
                .on('mouseout', tip.hide);

            // Append text
            node.append("text")
                .attr("dy", ".3em")
                .style("fill", "#fff")
                .style("font-size", 12)
                .style("text-anchor", "middle")
                .text(function(d) { return d.label.substring(0, d.r / 3); });



        // Returns a flattened hierarchy containing all leaf nodes under the root.
        function classes(root) {
            var classes = [];

            function recurse(name, node) {
                if (node.bloggers) node.bloggers.forEach(function(child) { recurse(node.name, child); });
                else classes.push({packageName: name, className: node.name, value: node.size,label:node.label});
            }

            recurse(null, root);
            return {children: classes};
        }
    }
});
</script>
	<script>


    var color = d3.scale.linear()
            .domain([0,1,2,3,4,5,6,10,15,20,80])
            .range(["#17394C", "#F5CC0E", "#CE0202", "#aaa", "#999", "#888", "#777", "#666", "#555", "#444", "#333", "#222"]);

</script>
	<!-- end of blogger bubble chart -->


	<!-- Blog Bubble Chart -->
	<script>


$(function () {

    // Initialize chart
    bubblesblog('#bubblesblog', 470);

    // Chart setup
    function bubblesblog(element, diameter) {


        // Basic setup
        // ------------------------------

        // Format data
        var format = d3.format(",d");

        // Color scale
        color = d3.scale.category10();

        // Define main variables
        var d3Container = d3.select(element),
            margin = {top: 5, right: 20, bottom: 20, left: 50},
            width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right,
            height = height - margin.top - margin.bottom;
            diamter = height;




            // Add SVG element
            var container = d3Container.append("svg");

            // Add SVG group
            var svg = container
                .attr("width", diameter + margin.left + margin.right)
                .attr("height",diameter + margin.top + margin.bottom)
                .attr("class", "bubble");

        // Create chart
        // ------------------------------

        // var svg = d3.select(element).append("svg")
        //     .attr("width", diameter)
        //     .attr("height", diameter)
        //     .attr("class", "bubble");



        // Create chart
        // ------------------------------

        // Add tooltip
        var tip = d3.tip()
            .attr('class', 'd3-tip')
            .offset([-5, 0])
            .html(function(d) {
                return d.label+"<br/>"+d.className + ": " + format(d.value);;
            });

        // Initialize tooltip
        svg.call(tip);



        // Construct chart layout
        // ------------------------------

        // Pack
        var bubble = d3.layout.pack()
            .sort(null)
            .size([diameter, diameter])
            .padding(15);



        // Load data
        // ------------------------------



data = {
 "name":"flare",
 "bloggers":[
	 <%if (bloggers.length() > 0) {
			//System.out.println(bloggers);
			int k = 0;
			for (int y = 0; y < bloggers.length(); y++) {
				String key = looper.get(y).toString();
				JSONObject resu = bloggers.getJSONObject(key);
				int size = Integer.parseInt(resu.get("totalposts").toString());
				if (size > 0 && k < 15) {
					k++;%>
{"label":"<%=resu.get("blogger")%>","name":"<%=resu.get("blogger")%>", "size":<%=resu.get("totalposts")%>},
<%}
			}
		}%>
 ]
}


            //
            // Append chart elements
            //

            // Bind data
            var node = svg.selectAll(".d3-bubbles-node")
                .data(bubble.nodes(classes(data))
                .filter(function(d) { return !d.children; }))
                .enter()
                .append("g")
                    .attr("class", "d3-bubbles-node")
                    .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });
        
			var color = d3.scale.linear()
			.domain([0,1,2,3,4,5,6,10,15,20])
			.range(["#17394C", "#FFBB78", "#CE0202", "#0080CC", "#72C28E", "#D6A78D", "#FF7E7E", "#666", "#555", "#444"]);
			
            // Append circles
            node.append("circle")
                .attr("r", function(d) { return d.r; })
                .style("fill", function(d,i) {
                  //return color(i);
                  /* if(i<5)
                  {
                    return "#0080cc";
                  }
                  else if(i>=5)
                  {
                    return "#78bce4";
                  } */
                  //console.log(d.r * 2);
                 // console.log("afde");
                  return color(i);
                
                })
                .on('mouseover',tip.show)
                .on('mouseout', tip.hide);
           
            // Append text
            node.append("text")
                .attr("dy", ".3em")
                .style("fill", "#fff")
                .style("font-size", 12)
                .style("text-anchor", "middle")
                .text(function(d) { return d.label.substring(0, d.r / 3); });



        // Returns a flattened hierarchy containing all leaf nodes under the root.
        function classes(root) {
            var classes = [];

            function recurse(name, node) {
                if (node.bloggers) node.bloggers.forEach(function(child) { recurse(node.name, child); });
                else classes.push({packageName: name, className: node.name, value: node.size,label:node.label});
            }

            recurse(null, root);
            return {children: classes};
        }
    }
});
</script>
	<script>
$(".option-only").on("change",function(e){
	console.log("only changed ");
	var valu =  $(this).val();
	$("#single_date").val(valu);
	$('form#customformsingle').submit();
});

$(".option-only").on("click",function(e){
	console.log("only Click ");
	$("#single_date").val($(this).val());
	//$('form#customformsingle').submit();
});

$(".option-lable").on("click",function(e){
	console.log("Label Click ");
	
	$("#single_date").val($(this).val());
	//$('form#customformsingle').submit();
});
</script>
	<!-- End of blog bubble chart -->

	<!-- posting frequency -->
	<script>

 $(function () {

     // Initialize chart
     lineBasic('#postingfrequency', 300);

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

         data = [	
        	[<% for(int q=0; q<sortedyearsarray.length(); q++){ 
     		  		String yer=sortedyearsarray.get(q).toString(); 
     		  		int vlue = Integer.parseInt(graphyears.get(yer).toString());
     		  %>
     		  			{"date":"<%=yer%>","close":<%=vlue%>},
     		<% } %>
     		]
     	  
        	 /*
           [{"date":"2014","close":400},{"date":"2015","close":600},{"date":"2016","close":1300},{"date":"2017","close":1700},{"date":"2018","close":2100}],
           [{"date":"2014","close":350},{"date":"2015","close":700},{"date":"2016","close":1500},{"date":"2017","close":1600},{"date":"2018","close":1250}],
         	*/
           ];

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
                                      .on("click",function(d){console.log(d.date)});
                                 //                         svg.call(tip)

                               //console.log(newi);


                                     svg.selectAll(".circle-point").data(mergedarray)
                                     .on("mouseover",tip.show)
                                     .on("mouseout",tip.hide)
                                     .on("click",function(d){console.log(d.date)});
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
 <script>

	
 $(document).ready(function() {
		$('#top-sorttype').on("change",function(e){	
			loadDomain();
		});
		
		$('#top-sortdate').on("change",function(e){
			loadDomain();
		});
		
		$('#top-listtype').on("change",function(e){
			loadDomain();		
		});
		
		
		$('.sortbytimerange').on("change",function(e){	
			var valu =  $(this).val();
			$("#single_date").val(valu);
			$('form#customformsingle').submit();
		});
		
		
		$('#swapBlogger').on("change",function(e){
				
			console.log("blogger busta");
			var type = $('#swapBlogger').val();
			var blgss = $("#bloggers").val();
			if(type=="blogs"){
				blgss = $("#blogs").val();
			}else{
				blgss = $("#bloggers").val();
			}
			
			console.log("type"+type);
			$("#postingfrequencybar").html('<div style="text-align:center"><img src="'+app_url+'images/preloader.gif"/><br/></div>');
			console.log(blgss);
			$.ajax({
				url: app_url+'subpages/postingfrequencybar.jsp',
				method: 'POST',
				data: {
					tid:$("#alltid").val(),
					sortby:$('#swapBlogger').val(),
					sortdate:$("#active-sortdate").val(),
					bloggers:blgss,
				},
				error: function(response)
				{						
					console.log(response);		
				},
				success: function(response)
				{   
					$("#postingfrequencycontainer").html(response);
				}
			});
			
		});
	});

 
 
 function loadDomain(){
	 $("#top-domain-box").html('<tr><td colspan="2"><div style="text-align:center"><img src="'+app_url+'images/preloader.gif"/><br/></div></td></tr>');
		
		$.ajax({
			url: app_url+'subpages/topdomain.jsp',
			method: 'POST',
			data: {
				tid:$("#alltid").val(),
				sortby:$("#top-sorttype").val(),
				sortdate:$("#top-sortdate").val(),
				listtype:$("#top-listtype").val(),
			},
			error: function(response)
			{						
				console.log(response);		
			},
			success: function(response)
			{   
				$("#top-domain-box").html(response);
			}
		});
	}
 </script>
 <!-- <script src="pagedependencies/dashboard.js?v=09"></script> -->
 
</body>
</html>

<% }} %>
