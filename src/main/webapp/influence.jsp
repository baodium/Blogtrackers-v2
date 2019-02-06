<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%@page import="authentication.*"%>
<%@page import="java.util.*"%>
<%@page import="util.*"%>
<%@page import="java.io.File"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
try{
	
Object email = (null == session.getAttribute("email")) ? "" : session.getAttribute("email");
Object tid = (null == request.getParameter("tid")) ? "" : request.getParameter("tid");

Object user = (null == session.getAttribute("username")) ? "" : session.getAttribute("username");
Object date_start = (null == request.getParameter("date_start")) ? "" : request.getParameter("date_start");
Object date_end = (null == request.getParameter("date_end")) ? "" : request.getParameter("date_end");
Object single = (null == request.getParameter("single_date")) ? "" : request.getParameter("single_date");
String sort =  (null == request.getParameter("sortby")) ? "blog" : request.getParameter("sortby").toString().replaceAll("[^a-zA-Z]", " ");


ArrayList<?> userinfo = new ArrayList();

String profileimage= "";
String username ="";
String name="";
String phone="";
String date_modified = "";
String trackername="";
Trackers tracker  = new Trackers();
Blogposts post  = new Blogposts();
Blogs blog  = new Blogs();
Terms term  = new Terms();
Blogpost_entitysentiment blogpostsentiment  = new Blogpost_entitysentiment();
ArrayList allterms = new ArrayList(); 
ArrayList allentitysentiments = new ArrayList(); 



userinfo = new DbConnection().query("SELECT * FROM usercredentials where Email = '"+email+"'");
if (userinfo.size()<1) {
	response.sendRedirect("login.jsp");
}else{
userinfo = (ArrayList<?>)userinfo.get(0);
	try{
	username = (null==userinfo.get(0))?"":userinfo.get(0).toString();
	
	name = (null==userinfo.get(4))?"":(userinfo.get(4).toString());
	
	
	email = (null==userinfo.get(2))?"":userinfo.get(2).toString();
	phone = (null==userinfo.get(6))?"":userinfo.get(6).toString();
	//date_modified = userinfo.get(11).toString();
	
	String userpic = userinfo.get(9).toString();
	String[] user_name = name.split(" ");
	username = user_name[0];
	
	String path=application.getRealPath("/").replace('\\', '/')+"images/profile_images/";
	String filename = userinfo.get(9).toString();
	
	profileimage = "images/default-avatar.png";
	if(userpic.indexOf("http")>-1){
		profileimage = userpic;
	}
	
	
	
	File f = new File(filename);
	if(f.exists() && !f.isDirectory()) { 
		profileimage = "images/profile_images/"+userinfo.get(2).toString()+".jpg";
	}
	}catch(Exception e){}
	
	}

	ArrayList detail =new ArrayList();
	if (tid != "") {
		detail = tracker._fetch(tid.toString());
	} else {
		detail = tracker._list("DESC", "", user.toString(), "1");
	}
	
	boolean isowner = false;
	JSONObject obj =null;
	String ids = "";
	if (detail.size() > 0) {
		//String res = detail.get(0).toString();
		ArrayList resp = (ArrayList<?>)detail.get(0);
		//System.out.println("details here-"+resp);

		String tracker_userid = resp.get(1).toString();
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
	

	SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("MMM d, yyyy");
	SimpleDateFormat DATE_FORMAT2 = new SimpleDateFormat("yyyy-MM-dd");

	SimpleDateFormat DAY_ONLY = new SimpleDateFormat("dd");
	SimpleDateFormat MONTH_ONLY = new SimpleDateFormat("MM");
	SimpleDateFormat SMALL_MONTH_ONLY = new SimpleDateFormat("mm");
	SimpleDateFormat WEEK_ONLY = new SimpleDateFormat("dd");
	SimpleDateFormat YEAR_ONLY = new SimpleDateFormat("yyyy");
	
	String stdate = post._getDate(ids,"first");
	String endate = post._getDate(ids,"last");
	
	
	
	Date dstart = new Date();
	Date today = new Date();
	
	
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

		//ArrayList posts = post._list("DESC","");
		
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
			int dd = Integer.parseInt(day)-7;
			
			Calendar cal = Calendar.getInstance();
			cal.add(Calendar.DATE, -7);
			Date dateBefore7Days = cal.getTime();
			dt = YEAR_ONLY.format(dateBefore7Days) + "-" + MONTH_ONLY.format(dateBefore7Days) + "-" + DAY_ONLY.format(dateBefore7Days);
			
							
		} else if (single.equals("month")) {
			dt = year + "-" + month + "-01";
			dte = year + "-" + month + "-"+day;	
			
		} else if (single.equals("year")) {
			dt = year + "-01-01";
			dte = year + "-12-"+ddey;
			
		}else {
			dt = dst;
			dte = dend;
			
		}  
		
		String[] yst = dt.split("-");
		String[] yend = dte.split("-");
		year_start = yst[0];
		year_end = yend[0];
		int ystint = new Double(year_start).intValue();
		int yendint = new Double(year_end).intValue();
		
		if(yendint>Integer.parseInt(YEAR_ONLY.format(new Date()))){
			dte = DATE_FORMAT2.format(new Date()).toString();	
			yendint = Integer.parseInt(YEAR_ONLY.format(new Date()));
		}
		
		if(ystint<2000){
			ystint = 2000;
			dt = "2000-01-01";
		}
		
		dispfrom = DATE_FORMAT.format(new SimpleDateFormat("yyyy-MM-dd").parse(dt));
		dispto = DATE_FORMAT.format(new SimpleDateFormat("yyyy-MM-dd").parse(dte));
		
		
		allauthors=post._getBloggerByBlogId("date",dt, dte,ids,"influence_score","DESC");
		
	String allpost = "0";
	float totalinfluence = 0;
	String mostactiveblog="";
	String mostactivebloglink="";
	String mostactiveblogposts="0";
	String mostactiveblogid="0";
	
	String mostactiveblogger="";
	
	
	String mostusedkeyword = "";
	String fsid = "";


	ArrayList mostactive= blog._getMostactive(ids);
	if(mostactive.size()>0){
		mostactiveblog = mostactive.get(0).toString();
		mostactivebloglink = mostactive.get(1).toString();
		mostactiveblogposts = mostactive.get(2).toString();
		mostactiveblogid = mostactive.get(3).toString();
		fsid = mostactiveblogid;
		
	}
	

	ArrayList allposts = new ArrayList();
	


//System.out.println(topterms);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Blogtrackers-Influence</title>
<link rel="shortcut icon" href="images/favicons/favicon-48x48.png">
<link rel="apple-touch-icon" href="images/favicons/favicon-48x48.png">
<link rel="apple-touch-icon" sizes="96x96" href="images/favicons/favicon-96x96.png">
<link rel="apple-touch-icon" sizes="144x144" href="images/favicons/favicon-144x144.png">
<!-- start of bootsrap -->
<link href="https://fonts.googleapis.com/css?family=Open+Sans:600,700" rel="stylesheet">
<link rel="stylesheet" href="assets/bootstrap/css/bootstrap-grid.css" />
<link rel="stylesheet" href="assets/bootstrap/css/bootstrap.css" />
<link rel="stylesheet" href="assets/fonts/fontawesome/css/fontawesome-all.css" />
<link rel="stylesheet" href="assets/fonts/iconic/css/open-iconic.css" />
<link rel="stylesheet" href="assets/vendors/bootstrap-daterangepicker/daterangepicker.css" />
<link rel="stylesheet" href="assets/css/table.css" />
<link rel="stylesheet" href="assets/vendors/DataTables/dataTables.bootstrap4.min.css" />

<link rel="stylesheet" href="assets/css/daterangepicker.css" />
<link rel="stylesheet" href="assets/css/style.css" />

<!--end of bootsrap -->
<script src="assets/js/jquery-3.2.1.slim.min.js"></script>
<script src="assets/js/popper.min.js"></script>
</head>
<body>

	<div class="modal-notifications">
		<div class="row">
			<div class="col-lg-10 closesection"></div>
			<div class="col-lg-2 col-md-12 notificationpanel">
				<div id="closeicon" class="cursor-pointer">
					<i class="fas fa-times-circle"></i>
				</div>
				<div class="profilesection col-md-12 mt50">
					<% if(userinfo.size()>0){ %>
					<div class="text-center mb10">
						<img src="<%=profileimage%>" width="60" height="60"
							onerror="this.src='images/default-avatar.png'" alt="" />
					</div>
					<div class="text-center" style="margin-left: 0px;">
						<h6 class="text-primary m0 bolder profiletext"><%=name%></h6>
						<p class="text-primary profiletext"><%=email%></p>
					</div>
					<%} %>
				</div>
				<div id="othersection" class="col-md-12 mt10" style="clear: both">
					<% if(userinfo.size()>0){ %>
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
					<%}else{ %>
					<a class="cursor-pointer profilemenulink"
						href="<%=request.getContextPath()%>/login"><h6
							class="text-primary">Login</h6></a>

					<%} %>
				</div>
			</div>
		</div>
	</div>
	<nav class="navbar navbar-inverse bg-primary">
		<div class="container-fluid mt10 mb10">

			<div
				class="navbar-header d-none d-lg-inline-flex d-xl-inline-flex col-lg-3">
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
				<% if(userinfo.size()>0){ %>

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
				<% }else{ %>
				<ul class="nav main-menu2 float-right"
					style="display: inline-flex; display: -webkit-inline-flex; display: -mozkit-inline-flex;">

					<li class="cursor-pointer"><a href="login.jsp">Login</a></li>
				</ul>
				<% } %>
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
		<div class="row bottom-border pb20">
			<div class="col-md-6 paddi">
				<nav class="breadcrumb">

					<a class="breadcrumb-item text-primary" href="<%=request.getContextPath()%>/trackerlist.jsp">Trackers</a> 
				<a class="breadcrumb-item text-primary" href="<%=request.getContextPath()%>/edittracker.jsp?tid=<%=tid%>"><%=trackername%></a>
				<a class="breadcrumb-item active text-primary" href="<%=request.getContextPath()%>/dashboard.jsp?tid=<%=tid%>">Dashboard</a>
						 <a class="breadcrumb-item active text-primary"	href="<%=request.getContextPath()%>influence.jsp?tid=<%=tid%>">Influence Analysis</a>

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

		<div class="row mt20">
			<div class="col-md-3">

				<div class="card card-style mt20">
					<div class="card-body  p30 pt5 pb5 mb20">
						<h6 class="mt20 mb20">Top Bloggers</h6>
						<div style="padding-right: 10px !important;">
							<input type="search" class="form-control stylesearch mb20"
								placeholder="Search Bloggers" />
						</div>
						<div class="scrolly"
							style="height: 270px; padding-right: 10px !important;">
   <!-- 
							<a class="btn btn-primary form-control stylebuttonactive mb20"><b>Advonum</b></a>
							<a
								class="btn form-control stylebuttoninactive opacity53 text-primary mb20"><b>Matt
									Fincane</b></a>
									-->
							    
							<%
								JSONObject influecechart = new JSONObject();
								JSONObject authors = new JSONObject();
								JSONObject authoryears = new JSONObject();
								JSONArray authorcount = new JSONArray();
								JSONArray posttodisplay = new JSONArray();
								JSONObject years = new JSONObject();
								JSONArray yearsarray = new JSONArray();
								JSONObject locations = new JSONObject();
								JSONObject authorposts = new JSONObject();
								JSONObject bloggersort = new JSONObject();
								int tcomment = 0;
								JSONObject bloggersortdet = new JSONObject();
								JSONArray bloggerarr = new JSONArray();
								
								
								JSONArray bloggertosort = new JSONArray();
								
								int influencecount=0;
								
								String selectedid="";
								JSONArray sentimentpost = new JSONArray();
								String postidss = "";
								
								int l=0;
								int qc=0;
								int tloc =0;
								if(allauthors.size()>0){
									
									String tres = null;
									JSONObject tresp = null;
									String tresu = null;
									JSONObject tobj = null;
									int j=0;
									int k=0;
									for(int i=0; i< allauthors.size(); i++){
										tres = allauthors.get(i).toString();	
										tresp = new JSONObject(tres);
										tresu = tresp.get("_source").toString();
										tobj = new JSONObject(tresu);
										
										String auth  = tobj.get("blogger").toString();
										String posttitle  = tobj.get("title").toString();
										String posturl = tobj.get("permalink").toString();
										String postid  = tobj.get("blogpost_id").toString();
										String blogid  = tobj.get("blogsite_id").toString();
										String body  = tobj.get("post").toString();
										String dat  = tobj.get("date").toString();
										String num_comment  = tobj.get("num_comments").toString();
										num_comment = num_comment.equals("null")?"0":num_comment;
										
										
										tcomment+=Integer.parseInt(num_comment);

									    sentimentpost.put(tobj.get("blogpost_id").toString());
									    postidss+=tobj.get("blogpost_id").toString()+",";
										
									   

									    if(i==0){
											postidss+=tobj.get("blogpost_id").toString()+",";
											
											// Double influence =  Double.parseDouble(post._searchRangeMaxByBloggers("date",dt, dte,auth));
											 //totalinfluence+=influence;
										}
									    
										
										String[] dateyear=tobj.get("date").toString().split("-");
										String yy= dateyear[0];
									    String mm = dateyear[1];
									    
									    JSONArray postauth = new JSONArray();
								    	if(!authorposts.has(auth)){
								    		postauth.put(postid);
										}else{
											
											postauth = new JSONArray(authorposts.get(auth).toString());
											postauth.put(postid);
											
										}
								    	
								    	authorposts.put(auth,postauth);
									    
									    String bloggerselect="";
									    
									    if(!authors.has(auth)){
									    	String postcount = post._searchRangeTotalByBlogger("date", dt, dte, auth);
									    	
											JSONObject xy = new JSONObject();
									    	
									    	String x =  postcount;//post._searchRangeTotal("date", dt, dte, blogid);
									    	int val = new Double(post._searchRangeMaxByBloggers("date",dt, dte,auth)).intValue(); 
									    		
									    	String y = val+"";
									    	xy.put("x",y);
									    	xy.put("y",x);
											
									    	influencecount+=val;
									    	
											l++;
											bloggersort.put(auth, new Double(postcount).intValue());
											JSONObject bloggerj = new JSONObject();
											bloggerj.put("blogger",auth);
											bloggerj.put("blogid",blogid);
											bloggerj.put("influence",val);
											bloggerj.put("selected",bloggerselect);
											bloggerj.put("totalpost",postcount);
											bloggerj.put("postarray",postauth);
											bloggerarr.put(val+"___"+auth);
											
											//bloggertosort.put(auth,val);
										    bloggersortdet.put(auth,bloggerj);
									    	authors.put(auth, auth);
									    	authorcount.put(j, auth);
									    	
									    	bloggertosort.put(bloggerj);
									    	influecechart.put(auth,xy);
									    	
									    	j++;
									    	
									    	 }  
										   // System.out.println(authoryears);
										}
									} 
								
				//System.out.println("authors"+bloggerarr);
				//bloggertosort =  post._sortJson2(bloggertosort);
			    bloggerarr = post._sortJson2(bloggerarr);
				//System.out.println("hello"+bloggerarr);

				for(int m=0; m<bloggerarr.length(); m++){
					String key = bloggerarr.get(m).toString();
					String[] splitter = key.split("___");
					String au = splitter[1];
			  		JSONObject det= new JSONObject(bloggersortdet.get(au).toString());
					String dselected = "";
					
					JSONArray selposts = new JSONArray(det.get("postarray").toString());
					String postids = "";
					for(int r=0; r<selposts.length(); r++){
						postids += selposts.get(r).toString()+",";
					}
					
					if(m==0){
						dselected = "abloggerselected";
							mostactiveblogger = au;
							
							selectedid=det.get("blogid").toString();
							allposts =  post._getBloggerByBloggerName("date",dt, dte,au,"influence_score","DESC");
									
					}
			    	%>
					<input type="hidden" id="postby<%=au.replaceAll(" ","_")%>" value="<%=postids%>" />
	    			<a class="blogger-select btn btn-primary form-control bloggerinactive mb20 <%=dselected%>"  id="<%=au.replaceAll(" ","_")%>***<%=det.get("blogid")%>" ><b><%=det.get("blogger")%></b></a>
	    			<% 
					//JSONObject jsonObj = bloggersort.getJSONObject(m);
				}
								
			%>

						</div>


					</div>
				</div>
	</div>

<!--  Populate terms and influence score json for chart-->
<%
/*
JSONArray sentimentpost = new JSONArray();
String postidss = "";
		
ArrayList allauthors2 = post._getBloggerByBloggerName("date", dt, dte, mostactiveblogger, "influence_score", "DESC");
if(allauthors2.size()>0){
	String tres = null;
	JSONObject tresp = null;
	String tresu = null;
	JSONObject tobj = null;
	int j=0;
	int k=0;
	int n = 0;
	for(int i=0; i< allauthors2.size(); i++){
				tres = allauthors2.get(i).toString();			
				tresp = new JSONObject(tres);
			    tresu = tresp.get("_source").toString();
			    tobj = new JSONObject(tresu);				    
			    sentimentpost.put(tobj.get("blogpost_id").toString());
			    postidss+=tobj.get("blogpost_id").toString()+",";
		}
} 	
*/

String possentiment2 =new Liwc()._searchRangeAggregate("date", dt, dte, sentimentpost,"posemo");
String negsentiment2 =new Liwc()._searchRangeAggregate("date", dt, dte, sentimentpost,"negemo");

int comb = new Double(possentiment2).intValue() + new Double(negsentiment2).intValue();
String totalcomment = tcomment+"";// post._searchRangeAggregate("date", dt, dte,ids,"num_comments");
totalinfluence  = influencecount;// Float.parseFloat(post._searchRangeAggregate("date", dt, dte, ids,"influence_score"));

totalpost = post._searchRangeTotal("date", dt, dte,ids);
//totalpost = post._searchRangeAggregateByBloggers("date", dt, dte, mostactiveblogger);

String totalsenti  = comb+"";
//System.out.println("Post ids ="+postidss);
allterms = term._searchByRange("date", dt, dte,postidss,"blogpostid","50");



int highestfrequency = 0;
JSONArray topterms = new JSONArray();
JSONObject keys = new JSONObject();
if (allterms.size() > 0) {
	for (int p = 0; p < allterms.size(); p++) {
		String bstr = allterms.get(p).toString();
		JSONObject bj = new JSONObject(bstr);
		bstr = bj.get("_source").toString();
		bj = new JSONObject(bstr);
		String frequency = bj.get("frequency").toString();
		int freq = new Double(frequency).intValue();
		
		String tm = bj.get("term").toString();
		if(freq>highestfrequency){
			highestfrequency = freq;
			mostusedkeyword = tm;
		}
		JSONObject cont = new JSONObject();
		cont.put("key", tm);
		cont.put("frequency", frequency);
		if(!keys.has(tm)){
			keys.put(tm,tm);
			topterms.put(cont);
		}
	}
}



int base = 0;

JSONObject postyear =new JSONObject();
if(authorcount.length()>0){
	for(int n=0; n<1;n++){
		int b=0;

		for(int y=ystint; y<=yendint; y++){ 
				   String dtu = y + "-01-01";
				   String dtue = y + "-12-31";
				   if(b==0){
						dtu = dt;
					}else if(b==yendint){
						dtue = dte;
					}
				   String totu = post._searchRangeAggregateByBloggers("date",dtu, dtue,mostactiveblogger,"influence_score");
				   //String totu = post._searchRangeMaxByBloggers("date",dt, dte,mostactiveblogger);
			    	
				   if(new Double(totu).intValue() <base){
					   base = new Double(totu).intValue();
				   }
				   
				   if(!years.has(y+"")){
			    		years.put(y+"",y);
			    		yearsarray.put(b,y);
			    		b++;
			    	}
				   
				   postyear.put(y+"",totu);
		}
		//authoryears.put(mostactiveblogger,postyear);
	}
}


base = Math.abs(base);
if(postyear.length()>0){
		for(int y=ystint; y<=yendint; y++){ 
				   String v1 = postyear.get(y+"").toString();
				   int re = new Double(v1).intValue()+base;
				   postyear.put(y+"",re+"");
		}
		
}
authoryears.put(mostactiveblogger,postyear);
//System.out.println(authoryears);
%>



	<div class="col-md-9">
				<div class="card card-style mt20">
					<div class="card-body  p30 pt5 pb5">
						<div style="min-height: 250px;">
							<div>
								<p class="text-primary mt10">
									<b class="text-primary">Individual</b> Influence Score of
									Bloggers <!-- of  Past <select
										class="text-primary filtersort sortbytimerange"><option
											value="week">Week</option>
										<option value="month">Month</option>
										<option value="year">Year</option></select> -->
								</p>
							</div>
							<div id="chart-container">
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
								<h6 class="card-title mb0">Influence Score</h6>
								<h2 class="mb0 bold-text total-influence"><%=totalinfluence%></h2>
								<!-- <small class="text-success">+5% from <b>Last Week</b></small> -->
							</div>

							<div class="col-md-3 mt5 mb5">
								<h6 class="card-title mb0">Total Posts</h6>
								<h2 class="mb0 bold-text total-post"><%=totalpost%></h2>
								<!-- <small class="text-success">+5% from <b>Last Week</b></small> -->
							</div>

							<%-- <div class="col-md-3 mt5 mb5">
								<h6 class="card-title mb0">Most Used Keyword</h6>
								<h2 class="mb0 bold-text most-used-keyword"><%=mostusedkeyword%></h2>
								<!-- <small class="text-success">+5% from <b>Last Week</b></small> -->
							</div> --%>
							
							<div class="col-md-3 mt5 mb5">
								<h6 class="card-title mb0">Overall Sentiment</h6>
								<h2 class="mb0 bold-text total-sentiment"><%=totalsenti%></h2>
								<!-- <small class="text-success">+5% from <b>Last Week</b></small> -->
							</div> 

							<%-- <div class="col-md-3  mt5 mb5">
								<h6 class="card-title mb0">Most Active Blog</h6>
								<h2 class="mb0 bold-text"><%=mostactiveblog%></h2>
								<small class="text-success"><a href="<%=mostactivebloglink%>" target="_blank"><b>View Blog</b></a></small>
							</div> --%>
							<div class="col-md-3 mt5 mb5">
								<h6 class="card-title mb0">Comments</h6>
								<h2 class="mb0 bold-text total-comments"><%= totalcomment%></h2>
								<!-- <small class="text-success">+5% from <b>Last Week</b></small> -->
							</div> 

						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="row mb0">
			<div class="col-md-6 mt20 ">
				<div class="card card-style mt20">
					<div class="card-body  p30 pt5 pb5">
						<div>
							<p class="text-primary mt10">
								Keywords of <b class="text-blue activeblogger"><%=mostactiveblogger%></b>
							</p>
						</div>
						
						 <div id="tagcloudbox">
	        					<div class="chart-container">
									<div class="chart tagcloudcontainer" id="tagcloudcontainer" style="min-height: 420px;">
									<div class="jvectormap-zoomin zoombutton" id="zoom_in">+</div>
								<div class="jvectormap-zoomout zoombutton" id="zoom_out" >−</div> 
									</div>
								</div>
        				 </div>
						
					</div>
				</div>
			</div>

			<div class="col-md-6 mt20">
				<div class="card card-style mt20">
					<div class="card-body  p30 pt5 pb5">
						<div>
							<p class="text-primary mt10">Blogger in Tracker Activity Vs
								Influence</p>
						</div>
						<div style="min-height: 420px;">
							<div class="chart-container">
								<div class="chart" id="scatterplot"></div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="row m0 mt20 mb50 d-flex align-items-stretch">
			<div class="col-md-6 mt20 card card-style nobordertopright noborderbottomright">
				<div class="card-body p0 pt20 pb20" style="min-height: 420px;" id="influential-post-box">
					<p>
						Influential Blog Posts of <b class="text-blue activeblogger"><%=mostactiveblogger%></b>
					</p>
					<!--   <div class="p15 pb5 pt0" role="group">
          Export Options
          </div> -->
          <div id="influence_table">
					<table id="DataTables_Table_0_wrapper" class="display"
						style="width: 100%">
						<thead>
							<tr>
								<th class="bold-text text-primary">Post title</th>
								<th class="bold-text text-primary">Influence Score</th>


							</tr>
						</thead>
						  <tbody>
                            
						<%
                                if(allposts.size()>0){							
									String tres = null;
									JSONObject tresp = null;
									String tresu = null;
									JSONObject tobj = null;
									int j=0;
									int k=0;
									for(int i=0; i< allposts.size(); i++){
										tres = allposts.get(i).toString();	
										tresp = new JSONObject(tres);
										tresu = tresp.get("_source").toString();
										tobj = new JSONObject(tresu);
										k++;
									%>
                                    <tr>
                                   <td><a class="blogpost_link cursor-pointer" id="<%=tobj.get("blogpost_id")%>" ><%=tobj.get("title") %></a><br/>
								<a class="mt20 viewpost makeinvisible" href="<%=tobj.get("permalink") %>" target="_blank"><buttton class="btn btn-primary btn-sm mt10 visitpost">Visit Post &nbsp;<i class="fas fa-external-link-alt"></i></button></buttton></a></td>
								<td align="center"><%=tobj.get("influence_score") %></td>
                                     </tr>
                                    <% }} %>
						
						 </tbody>
					</table>
					</div>
				</div>

			</div>

			<div
				class="col-md-6 mt20 card card-style nobordertopleft noborderbottomleft">
				<div style="" class="pt20" id="blogpost_detail">

					<%
                                if(allposts.size()>0){							
									String tres = null;
									JSONObject tresp = null;
									String tresu = null;
									JSONObject tobj = null;
									int j=0;
									int k=0;
									for(int i=0; i< 1; i++){
										tres = allposts.get(i).toString();	
										tresp = new JSONObject(tres);
										tresu = tresp.get("_source").toString();
										tobj = new JSONObject(tresu);
										String dat = tobj.get("date").toString().substring(0,10);
										LocalDate datee = LocalDate.parse(dat);
										DateTimeFormatter dtf = DateTimeFormatter.ofPattern("MMM dd, yyyy");
										String date = dtf.format(datee);
										
										
										k++;
									%>                                    
                                    <h5 class="text-primary p20 pt0 pb0"><%=tobj.get("title")%></h5>
										<div class="text-center mb20 mt20">
											<a href="<%=request.getContextPath()%>/bloggerportfolio.jsp?tid=<%=tid%>&blogger=<%=tobj.get("blogger")%>">
											<button class="btn stylebuttonblue">
												<b class="float-left ultra-bold-text"><%=tobj.get("blogger")%></b> <i
													class="far fa-user float-right blogcontenticon"></i>
											</button>
											</a>
											<button class="btn stylebuttonnocolor"><%=date%></button>
											<button class="btn stylebuttonnocolor">
												<b class="float-left ultra-bold-text"><%=tobj.get("num_comments")%> comments</b><i
													class="far fa-comments float-right blogcontenticon"></i>
											</button>
										</div>
										<div class="p20 pt0 pb20 text-blog-content text-primary"
											style="height: 600px; overflow-y: scroll;">
											<%=tobj.get("post")%>
										</div>                      
                     		<% }} %>

				</div>
				
			</div>
		</div>





	</div>

	<form action="" name="customform" id="customform" method="post">
		<input type="hidden" name="tid" id="alltid" value="<%=tid%>" />
		<input type="hidden" name="blogid" id="blogid" value="<%=selectedid%>" />
		<input type="hidden" name="author" id="author" value="<%=mostactiveblogger%>" /> 
		<input type="hidden" name="single_date" id="single_date" value="" />
		
		<input type="hidden" name="date_start" id="date_start" value="<%=dt%>" /> 
		<input type="hidden" name="date_end" id="date_end" value="<%=dte%>" />	
	</form>
	
	
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
	 
	 $('#printdoc').on('click',function(){
			print();
		}) ;
	 
     $('#DataTables_Table_1_wrapper').DataTable( {
         "scrollY": 430,
          "pagingType": "simple"
        /*   ,
          dom: 'Bfrtip',
       buttons:{
         buttons: [
             { extend: 'pdfHtml5',orientation: 'potrait', pageSize: 'LEGAL', className: 'btn-primary stylebutton1'},
             {extend:'csv',className: 'btn-primary stylebutton1'},
             {extend:'excel',className: 'btn-primary stylebutton1'},
            // {extend:'copy',className: 'btn-primary stylebutton1', text: 'Copy to Clipboard'},
             {extend:'print',className: 'btn-primary stylebutton1'},
         ]
       },
       "columnDefs": [
    { "width": "80%", "targets": 0 }
  ] */
     } );

     $('#DataTables_Table_0_wrapper').DataTable( {
         "scrollY": 430,
         // "scrollX": false,
          "pagingType": "simple"
    /*       ,
          "columnDefs": [
       { "width": "80%", "targets": 0 }
     ],
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
       	      {   startDate: moment().subtract(29, 'days'),
       	          endDate: moment(),
       	          minDate: '01/01/1947',
       	          maxDate: moment(),
       	      	 linkedCalendars: false,
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
   					 

   	            	var start = picker.startDate.format('YYYY-MM-DD');
   	            	var end = picker.endDate.format('YYYY-MM-DD');
   	            console.log("End:"+end);
   	            	
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
	<script type="text/javascript" src="assets/js/jquery.inview.js"></script>	
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
             margin = {top: 5, right: 10, bottom: 20, left: 50},
             width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right,
             height = height - margin.top - margin.bottom;


         var formatPercent = d3.format("");
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
            //  .tickPadding(10)
            // .tickSize(-width)
            // .tickSubdivide(true)
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
		/*
         data = [
           [{"date":"2014","close":400},{"date":"2015","close":600},{"date":"2016","close":1300},{"date":"2017","close":1700},{"date":"2018","close":2100}],
           [{"date":"2014","close":350},{"date":"2015","close":700},{"date":"2016","close":1500},{"date":"2017","close":1600},{"date":"2018","close":1250}],
           [{"date":"2014","close":500},{"date":"2015","close":900},{"date":"2016","close":1200},{"date":"2017","close":1200},{"date":"2018","close":2600}]
         ];
		*/
		  data = [<% 
		  		String auu = mostactiveblogger;
		  		JSONObject specific_auth= new JSONObject(authoryears.get(auu).toString());
		  %>[<% for(int q=0; q<yearsarray.length(); q++){ 
			  		String yearr=yearsarray.get(q).toString(); 
			  		if(specific_auth.has(yearr)){ %>
			  			{"date":"<%=yearr%>","close":<%=specific_auth.get(yearr) %>},
				<%
			  		}else{ %>
			  			{"date":"<%=yearr%>","close":0},
		   		<% } %>
			<%  
		  		}%>]
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
                                .style("stroke-width", 2)
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
                              .on("click",function(d){
                            	  console.log(d.date);
                            	  });
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
                         				
                                   	   loadInfluence(d1,d2); 
                                   	   console.log("reloaded");  
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
                        				
                                  	   loadInfluence(d1,d2); 
                                  	   console.log("reloaded");
                                    	 
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
                         .attr("transform", "translate(0," + y(0) + ")")
                         .call(xAxis);

                     // Vertical
                     var verticalAxis = svg.append("g")
                         .attr("class", "d3-axis d3-axis-vertical d3-axis-strong")
                         .call(yAxis);





                     // Add text label
                     verticalAxis.append("text")
                         .attr("transform", "rotate(-90)")
                         .attr("y", 10)
                         .attr("dy", ".31em")
                         .style("text-anchor", "end")
                         .style("fill", "#999")
                         .style("font-size", 12)
                         // .text("Influence")
                         ;


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


           if(data.length == 1)
           {
             svg.selectAll(".circle-point").attr("circle",circles)
             .attr("cx",function(d) { return x(d.date);})
             .attr("cy", function(d){return y(d.close)});
           }
           else if(data.length > 1)
           {
             svg.selectAll(".circle-point").attr("circle",circles)
             .attr("cx",function(d) { return x(d.date);})
             .attr("cy", function(d){return y(d.close)});
           }
         }
     }
 });
 </script>

	<!-- Scattert Plot -->
	<script>

 $(function () {

     // Initialize chart
     lineBasic('#scatterplot', 400);

     // Chart setup
     function lineBasic(element, height) {


         // Basic setup
         // ------------------------------

         // Define main variables
         var d3Container = d3.select(element),
             margin = {top: 5, right: 20, bottom: 20, left: 50},
             width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right,
             height = height - margin.top - margin.bottom;


         var formatPercent = d3.format("");
         // Format data
         // var parseDate = d3.time.format("%d-%b-%y").parse,
         //     bisectDate = d3.bisector(function(d) { return d.date; }).left,
         //     formatValue = d3.format(",.0f"),
         //     formatCurrency = function(d) { return formatValue(d); }



         // Construct scales
         // ------------------------------

         // Horizontal
         var x = d3.scale.linear()
             .range([0, width],.72,.5);

         // Vertical
         var y = d3.scale.linear()
                .range([height, 0]);



         // Create axes
         // ------------------------------

         // Horizontal
         var xAxis = d3.svg.axis()
             .scale(x)
             .orient("bottom")
            .ticks(7);

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
             // .attr("transform", "translate(0," + y(0) + ")");
                 .attr("transform", "translate(" + margin.left + "," + margin.top + ")");



         // Construct chart layout
         // ------------------------------

         // Line


         // Load data
         // ------------------------------
         //
         data = [[<% if(authorcount.length()>0){ for(int p=0; p<authorcount.length(); p++){ 
   					String au = authorcount.get(p).toString();
   			  		JSONObject jxy = new JSONObject(influecechart.get(au).toString());
   			  		int x = new Double(jxy.get("x").toString()).intValue();
   			  		int y = new Double(jxy.get("y").toString()).intValue(); %>{"x":<%=x%>,"y":<%=y%>},<% }} %>]   		
         ];

         // data = [];
		
         /*
	           [{"x":12,"y":40},{"x":15,"y":30},{"x":18,"y":12.5},{"x":11,"y":22},{"x":5,"y":19}],
	           [{"x":8,"y":35},{"x":14,"y":22},{"x":27,"y":33},{"x":11.5,"y":-16},{"x":-12,"y":-11}],
	            [{"x":17,"y":50},{"x":18,"y":30},{"x":19,"y":17.7},{"x":10,"y":25},{"x":9,"y":15},{"x":23,"y":20},{"x":1,"y":20},{"x":20,"y":23},{"x":11.5,"y":-11},{"x":-11,"y":-15},{"x":7,"y":40},{"x":20,"y":30},{"x":8,"y":-12.5},{"x":6,"y":15},{"x":15,"y":25},{"x":-8,"y":14},{"x":-14,"y":25}]
	   		*/

         // data = [
         //   [{"x":12,"y":40},{"x":15,"y":30},{"x":18,"y":12.5},{"x":11,"y":22},{"x":5,"y":19},{"x":8,"y":35},{"x":14,"y":22},{"x":27,"y":33},{"x":11.5,"y":-16},{"x":-12,"y":-11},{"x":17,"y":50},{"x":18,"y":30},{"x":19,"y":17.7},{"x":10,"y":25},{"x":9,"y":15},{"x":23,"y":20},{"x":1,"y":20},{"x":20,"y":23},{"x":11.5,"y":-11},{"x":-11,"y":-15},{"x":7,"y":40},{"x":20,"y":30},{"x":8,"y":-12.5},{"x":6,"y":15},{"x":15,"y":25},{"x":-8,"y":14},{"x":-14,"y":25}]
         // ];

         var line = d3.svg.line()
                     .interpolate("basis")
                     .x(function(d, i) { return x(i); })
                     .y(function(d, i) { return y(d); });

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
                 return "("+d.x+","+d.y+")<br/> Click for more information";
                  }

                });






                   // Vertical
         // extract max value from list of json object
         // console.log(data.length)
             var maxYvalue =
             data.map(function(d){
               var mvalue = [];
               if(data.length > 1)
             {
               d.forEach(function(f,i){
               mvalue[i] = f.y;

               })
             return d3.max(mvalue);
             }

             //console.log(mvalue);
             });


             var minYvalue =
             data.map(function(d){
               var mvalue = [];
               if(data.length > 1)
             {
               d.forEach(function(f,i){
               mvalue[i] = f.y;

               })
               if(d3.min(mvalue) < 0 )
               {
                 return d3.min(mvalue);
               }
               else{
                 return 0;
               }

             }

             //console.log(mvalue);
             });


             var maxXvalue =
             data.map(function(d){
               var mvalue = [];
               if(data.length > 1)
             {
               d.forEach(function(f,i){
               mvalue[i] = f.x;

               })
             return d3.max(mvalue);
             }

             //console.log(mvalue);
             });


             var minXvalue =
             data.map(function(d){
               var mvalue = [];
               if(data.length > 1)
             {
               d.forEach(function(f,i){
               mvalue[i] = f.x;

               })

             if(d3.min(mvalue) < 0)
             {
               return d3.min(mvalue);
             }
             else
             {
               return 0;
             }

             }

             //console.log(mvalue);
             });


             // color = d3.scale.linear()
             //          .domain([0,1,2,3,4,5,6,10,15,20,80])
             //          .range(["#17394C", "#F5CC0E", "#CE0202", "#aaa", "#999", "#888", "#777", "#666", "#555", "#444", "#333", "#222"]);
                         var color = d3.scale.category20();


         ////console.log(data)
         if(data.length == 1)
         {
           // var returnedvalue = data[0].map(function(e){
           // return e.date
           // });

           var maxXvalue2 =
           data.map(function(d){
           return d3.max(d,function(t){return t.x});
           });

           var minXvalue2 =
           data.map(function(d){
           return d3.min(d,function(t){return t.x});
           });

         // for single json data
         x.domain([minXvalue2,maxXvalue2]);
         // rewrite x domain

         var maxYvalue2 =
         data.map(function(d){
         return d3.max(d,function(t){return t.y});
         });

         var minYvalue2 =
         data.map(function(d){
         return d3.min(d,function(t){return t.y});
         });

         y.domain([minYvalue2,maxYvalue2]);
         }
         else if(data.length > 1)
         {

          x.domain([d3.min(minXvalue), d3.max(maxXvalue)]);
         y.domain([d3.min(minYvalue), d3.max(maxYvalue)]);
          }




                     //
                     // Append chart elements
                     //




                    // svg.call(tip);
                      // data.map(function(d){})
                      if(data.length == 1)
                      {

                         // add scatter points
                        var circles = svg.selectAll(".circle-point")
                                  .data(data[0])
                                  .enter();


                              circles
                              // .enter()
                              .append("circle")
                              .attr("class","circle-point")
                              .attr("r",3.4)
                              // .style("stroke", "#4CAF50")
                              .style("fill",function(e,i){return color(i)})
                              .attr("cx",function(d) { return x(d.x); })
                              .attr("cy", function(d){return y(d.y)})

                              .attr("transform", "translate("+margin.left/4.7+",0)");

                              svg.selectAll(".circle-point").data(data[0])
                              .on("mouseover",tip.show)
                              .on("mouseout",tip.hide)
                              .on("click",function(d){
                                // console.log(d.date)
                                // sconsole.log(d.y);
                               var d1 = 	  d.date + "-01-01";
                           	   var d2 = 	  d.date + "-12-31";
                  				
                           	   loadInfluence(d1,d2);
                                
                              });
                                                 svg.call(tip)
                      }
                      // handles multiple json parameter
                      else if(data.length > 1)
                      {

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
                                       // .style("stroke", "#4CAF50")
                                       .style("fill",function(d,i){return color(i);})
                                       .attr("cx",function(d) { return x(d.x)})
                                       .attr("cy", function(d){return y(d.y)})

                                       .attr("transform", "translate("+margin.left/4.7+",0)");
                                      //  svg.selectAll(".circle-point").data(mergedarray)
                                      // .on("mouseover",tip.show)
                                      // .on("mouseout",tip.hide)
                                      // .on("click",function(d){
                                      //   console.log(d.y)});
                                 //                         svg.call(tip)

                               //console.log(newi);


                                     svg.selectAll(".circle-point").data(mergedarray)
                                     .on("mouseover",tip.show)
                                     .on("mouseout",tip.hide)
                                     .on("click",function(d){
                                    	 console.log(d.y);
                                    	 });
                                                        svg.call(tip)

                      }


         // show data tip


                     // Append axes
                     // ------------------------------

                     // Horizontal
                    var horizontalAxis =   svg.append("g")
                         .attr("class", "d3-axis d3-axis-horizontal d3-axis-strong")
                         // .attr("transform", "translate(0," + height + ")")
                         .attr("transform", "translate(0," + y(0) + ")")
                         .call(xAxis);

                     // Vertical
                     var verticalAxis = svg.append("g")
                         .attr("class", "d3-axis d3-axis-vertical d3-axis-strong")
                          .attr("transform", "translate("+ x(0) + "," + "0)")
                         .call(yAxis);


                         svg.selectAll(".tick text")
                      .each(function (d) {
                      if ( d === 0 ) {
                          this.remove();
                      }
                      });


                     // Add text label
                     verticalAxis.append("text")
                         // .attr("transform", "rotate(-90)")
                         .attr("y", 10)
                         .attr("dy", ".71em")
                         .style("text-anchor", "end")
                         .style("fill", "#999")
                         .style("font-size", 12)
                         .text("Influence")
                         ;

                         horizontalAxis.append("text")
                             // .attr("transform", "rotate(-90)")
                             .attr("y", 10)
                             .attr("dy", ".71em")
                             .style("text-anchor", "end")
                             .style("fill", "#999")
                             .style("font-size", 12)
                             .text("Activity")
                             ;

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
           x.range([0, width],.72,.5);
           //
           // // Horizontal axis
           svg.select('.d3-axis-horizontal').attr("transform", "translate(0," + y(0) + ")").call(xAxis);
           svg.select('.d3-axis-vertical').attr("transform", "translate("+ x(0) + "," + "0)").call(yAxis);
           //
           //
           // // Chart elements
           // // -------------------------
           //

           svg.selectAll(".tick text")
        .each(function (d) {
        if ( d === 0 ) {
            this.remove();
        }
        });

           if(data.length == 1)
           {
             svg.selectAll(".circle-point").attr("circle",circles)
             .attr("cx",function(d) { return x(d.x);})
             .attr("cy", function(d){return y(d.y)});
           }
           else if(data.length > 1)
           {
             svg.selectAll(".circle-point").attr("circle",circles)
             .attr("cx",function(d) { return x(d.x);})
             .attr("cy", function(d){return y(d.y)});
           }
         }
     }
 });
 </script>

	<!--word cloud  -->
	<script>
wordtagcloud("#tagcloudcontainer",450);
	
	function wordtagcloud(element, height) {
		
		var d3Container = d3.select(element),
        margin = {top: 5, right: 50, bottom: 20, left: 60},
        width = d3Container.node().getBoundingClientRect().width,
        height = height - margin.top - margin.bottom - 5;
		
		var container = d3Container.append("svg");
     //var frequency_list = [{"text":"study","size":40},{"text":"motion","size":15},{"text":"forces","size":10},{"text":"electricity","size":15},{"text":"movement","size":10},{"text":"relation","size":5},{"text":"things","size":10},{"text":"force","size":5},{"text":"ad","size":5},{"text":"energy","size":85},{"text":"living","size":5},{"text":"nonliving","size":5},{"text":"laws","size":15},{"text":"speed","size":45},{"text":"velocity","size":30},{"text":"define","size":5},{"text":"constraints","size":5},{"text":"universe","size":10},{"text":"distinguished","size":5},{"text":"chemistry","size":5},{"text":"biology","size":5},{"text":"includes","size":5},{"text":"radiation","size":5},{"text":"sound","size":5},{"text":"structure","size":5},{"text":"atoms","size":5},{"text":"including","size":10},{"text":"atomic","size":10},{"text":"nuclear","size":10},{"text":"cryogenics","size":10},{"text":"solid-state","size":10},{"text":"particle","size":10},{"text":"plasma","size":10},{"text":"deals","size":5},{"text":"merriam-webster","size":5},{"text":"dictionary","size":10},{"text":"analysis","size":5},{"text":"conducted","size":5},{"text":"order","size":5},{"text":"understand","size":5},{"text":"behaves","size":5},{"text":"en","size":5},{"text":"wikipedia","size":5},{"text":"wiki","size":5},{"text":"physics-","size":5},{"text":"physical","size":5},{"text":"behaviour","size":5},{"text":"collinsdictionary","size":5},{"text":"english","size":5},{"text":"time","size":35},{"text":"distance","size":35},{"text":"wheels","size":5},{"text":"revelations","size":5},{"text":"minute","size":5},{"text":"acceleration","size":20},{"text":"torque","size":5},{"text":"wheel","size":5},{"text":"rotations","size":5},{"text":"resistance","size":5},{"text":"momentum","size":5},{"text":"measure","size":10},{"text":"direction","size":10},{"text":"car","size":5},{"text":"add","size":5},{"text":"traveled","size":5},{"text":"weight","size":5},{"text":"electrical","size":5},{"text":"power","size":5}];
	     var frequency_list = [ <%if (topterms.length() > 0) {
				for (int i = 0; i < topterms.length(); i++) {
					JSONObject jsonObj = topterms.getJSONObject(i);
					int size = new Double(jsonObj.getString("frequency")).intValue();
					%>
	{"text":"<%=jsonObj.getString("key")%>","size":<%=size*2%>},
 <%}
			}%>];

     var color = d3.scale.linear()
             .domain([0,1,2,3,4,5,6,10,15,20,80])
             .range(["#17394C", "#F5CC0E", "#CE0202", "#1F90D0", "#999", "#888", "#777", "#666", "#555", "#444", "#333", "#222"]);
     var svg =  container;
     d3.layout.cloud().size([450, 300])
             .words(frequency_list)
             .rotate(0)
             .fontSize(function(d) { return d.size; })
             .on("end", draw)
             .start();

     function draw(words) {
    		svg
            .attr("width", width)
            .attr("height", height)
            //.attr("class", "wordcloud")
            .append("g")
            .attr("transform", "translate("+ width/2 +",180)")
             .on("wheel", function() { d3.event.preventDefault(); })
             .call(d3.behavior.zoom().on("zoom", function () {
           	var g = svg.selectAll("g"); 
             g.attr("transform", "translate("+(width/2-10) +",180)" + " scale(" + d3.event.scale + ")").style("cursor","zoom-out")
            }))
            
            
            
            
           
    		
            .selectAll("text")
            .data(words)
            .enter().append("text")
            .style("font-size", 0)
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
	 		
	 		// animation effect for tag cloud
	 		 $(element).bind('inview', function (event, visible) {
       	  if (visible == true) {
       		  svg.selectAll("text").transition()
                 .delay(200)
                 .duration(1000)
                 .style("font-size", function(d) { return d.size * 1.10 + "px"; })
       	  } else {
       		  svg.selectAll("text")
                 .style("font-size", 0)
       	  }
       	});
	 		
	 		d3.selectAll('.zoombutton').on("click",zoomClick);
	 		
	 		var zoom = d3.behavior.zoom().scaleExtent([1, 20]).on("zoom", zoomed);
	 		
	 		function zoomed() {
	 			var g = svg.selectAll("g"); 
              g.attr("transform",
	 		        "translate(" + (width/2-10) + ",180)" +
	 		        "scale(" + zoom.scale() + ")"
	 		    );
	 		}
	 		
	 	// trasnlate and scale the zoom	
	 	function interpolateZoom (translate, scale) {
	 	    var self = this;
	 	    return d3.transition().duration(350).tween("zoom", function () {
	 	        var iTranslate = d3.interpolate(zoom.translate(), translate),
	 	            iScale = d3.interpolate(zoom.scale(), scale);
	 	        return function (t) {
	 	            zoom
	 	                .scale(iScale(t))
	 	                .translate(iTranslate(t));
	 	            zoomed();
	 	        };
	 	    });
	 	}
	 	
	 	// respond to click efffect on the zoom
	 	function zoomClick() {
	 	    var clicked = d3.event.target,
	 	        direction = 1,
	 	        factor = 0.2,
	 	        target_zoom = 1,
	 	        center = [width / 2-10, "180"],
	 	        extent = zoom.scaleExtent(),
	 	        translate = zoom.translate(),
	 	        translate0 = [],
	 	        l = [],
	 	        view = {x: translate[0], y: translate[1], k: zoom.scale()};

	 	    d3.event.preventDefault();
	 	    direction = (this.id === 'zoom_in') ? 1 : -1;
	 	    target_zoom = zoom.scale() * (1 + factor * direction);

	 	    if (target_zoom < extent[0] || target_zoom > extent[1]) { return false; }

	 	    translate0 = [(center[0] - view.x) / view.k, (center[1] - view.y) / view.k];
	 	    view.k = target_zoom;
	 	    l = [translate0[0] * view.k + view.x, translate0[1] * view.k + view.y];

	 	    view.x += center[0] - l[0];
	 	    view.y += center[1] - l[1];

	 	    interpolateZoom([view.x, view.y], view.k);
	 	}
	 		
	 		
	 		
           	function dragged(d) {
           	 var movetext = svg.select("g").selectAll("text");
           	 movetext.attr("dx",d3.event.x)
           	 .attr("dy",d3.event.y)
           	 .style("cursor","move"); 
           	 /* g.attr("transform","translateX("+d3.event.x+")")
           	 .attr("transform","translateY("+d3.event.y+")")
           	 .attr("width", width)
                .attr("height", height); */
           	} 
           	function dragstarted(d){
   				d3.event.sourceEvent.stopPropagation();
   			}
     }
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
       //x.rangeRoundBands([0, width]);
       //
       // // Horizontal axis
      // svg.selectAll('.d3-axis-horizontal').call(xAxis);
       //
       //
       // // Chart elements
       // // -------------------------
       //
       // // Line path
      

       //
       // // Crosshair
       // svg.selectAll('.d3-crosshair-overlay').attr("width", width);

     }
	}
 </script>
<script src="pagedependencies/baseurl.js?v=38"></script>
 
<script src="pagedependencies/influence.js?v=8979"></script>
	
</body>
</html>
<%

}catch(Exception e){
	
	//response.sendRedirect("index.jsp");
}

%>

