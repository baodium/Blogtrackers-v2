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
/* Terms term  = new Terms(); */
Blogger bloggerss = new Blogger();
Blogpost_entitysentiment blogpostsentiment  = new Blogpost_entitysentiment();
ArrayList allterms = new ArrayList(); 
ArrayList allentitysentiments = new ArrayList(); 


userinfo = new DbConnection().query("SELECT * FROM usercredentials where Email = '"+email+"'");

if (user == null || user == "") {
	System.out.println("user--"+user);
	response.sendRedirect("index.jsp");
}
else{
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
	}catch(Exception e){}
	
	

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
	
/* 	if (!isowner) {
		response.sendRedirect("index.jsp");
	}
 */
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
			
							
		} else if (single.equals("month")) {
			dt = year + "-" + month + "-01";
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
			
			allauthors = post._getBloggerByBlogId("date",dt, dte,ids,"influence_score","DESC");
			ArrayList bloggerPostFrequency = bloggerss._getBloggerPostFrequency(ids);
		
		
	String allpost = "0";
	float totalinfluence = 0;
	String mostactiveblog="";
	String toplocation="";
	String mostactivebloglink="";
	String mostactiveblogposts="0";
	String mostactiveblogid="0";
	
	String mostactiveblogger="";
	String secondactiveblogger="";
	
	String secondactiveblog = "";
	String secondactiveid = "";
	
	String mostusedkeyword = "";
	String fsid = "";


	ArrayList mostactive= blog._getMostactive(ids);
	if(mostactive.size()>0){
		mostactiveblog = mostactive.get(0).toString();
		mostactivebloglink = mostactive.get(1).toString();
		mostactiveblogposts = mostactive.get(2).toString();
		mostactiveblogid = mostactive.get(3).toString();
		fsid = mostactiveblogid;
		if(mostactive.size()>4){
			secondactiveblog = mostactive.get(4).toString();
			secondactiveid = mostactive.get(7).toString();
			fsid = mostactiveblogid+","+secondactiveid;
		}
	}
	

	toplocation = blog._getTopLocation(mostactiveblogid);

	/* ArrayList allposts = new ArrayList(); */
	JSONObject allposts = new JSONObject();
	
	JSONObject authoryears = new JSONObject();
	JSONObject years = new JSONObject();
	JSONArray yearsarray = new JSONArray();
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Blogtrackers-Posting Frequency</title>
  <link rel="shortcut icon" href="images/favicons/favicon-48x48.png">
  <link rel="apple-touch-icon" href="images/favicons/favicon-48x48.png">
  <link rel="apple-touch-icon" sizes="96x96" href="images/favicons/favicon-96x96.png">
  <link rel="apple-touch-icon" sizes="144x144" href="images/favicons/favicon-144x144.png">
  <!-- start of bootsrap -->
  <link href="https://fonts.googleapis.com/css?family=Open+Sans:600,700" rel="stylesheet">
  <link rel="stylesheet" href="assets/bootstrap/css/bootstrap-grid.css"/>
  <link rel="stylesheet" href="assets/bootstrap/css/bootstrap.css"/>
  <link rel="stylesheet" href="assets/fonts/fontawesome/css/fontawesome-all.css" />
  <link rel="stylesheet" href="assets/fonts/iconic/css/open-iconic.css" />
 <link rel="stylesheet" href="assets/vendors/bootstrap-daterangepicker/daterangepicker.css" />
 <link rel="stylesheet" href="assets/css/table.css" />
 <link rel="stylesheet" href="assets/vendors/DataTables/dataTables.bootstrap4.min.css" />

<link rel="stylesheet" href="assets/css/daterangepicker.css" />
  <link rel="stylesheet" href="assets/css/style.css" />
  
  <link rel="stylesheet" type="text/css" href="multiline.css">

  <!--end of bootsrap -->
  <script src="assets/js/jquery-3.2.1.slim.min.js"  ></script>
<script src="assets/js/popper.min.js" ></script>
<script src="pagedependencies/googletagmanagerscript.js"></script>
</head>
<body>
<%@include file="subpages/loader.jsp" %>
<%@include file="subpages/googletagmanagernoscript.jsp" %>
    <div class="modal-notifications">
<div class="row">
<div class="col-lg-10 closesection">
	
	</div>
  <div class="col-lg-2 col-md-12 notificationpanel">
    <div id="closeicon" class="cursor-pointer"><i class="fas fa-times-circle"></i></div>
  <div class="profilesection col-md-12 mt50">
  <% if(userinfo.size()>0){ %>
    <div class="text-center mb10" ><img src="<%=profileimage%>" width="60" height="60" onerror="this.src='images/default-avatar.png'" alt="" /></div>
    <div class="text-center" style="margin-left:0px;">
      <h6 class="text-primary m0 bolder profiletext"><%=name%></h6>
      <p class="text-primary profiletext"><%=email%></p>
    </div>
  <%} %>
  </div>
  <div id="othersection" class="col-md-12 mt10" style="clear:both">
  <% if(userinfo.size()>0){ %>
  <%-- <a class="cursor-pointer profilemenulink" href="<%=request.getContextPath()%>/notifications.jsp"><h6 class="text-primary">Notifications <b id="notificationcount" class="cursor-pointer">12</b></h6> </a> --%>
   <a class="cursor-pointer profilemenulink" href="<%=request.getContextPath()%>/addblog.jsp"><h6 class="text-primary">Add Blog</h6></a>
  <a class="cursor-pointer profilemenulink" href="<%=request.getContextPath()%>/profile.jsp"><h6 class="text-primary">Profile</h6></a>
  <a
						class="cursor-pointer profilemenulink"
						href="https://addons.mozilla.org/en-US/firefox/addon/blogtrackers/" target="_blank"><h6
							class="text-primary">Plugin</h6></a>
  <a class="cursor-pointer profilemenulink" href="<%=request.getContextPath()%>/logout"><h6 class="text-primary">Log Out</h6></a>
  <%}else{ %>
  <a class="cursor-pointer profilemenulink" href="<%=request.getContextPath()%>/login"><h6 class="text-primary">Login</h6></a>
  
  <%} %>
  </div>
  </div>
</div>
</div>
      <nav class="navbar navbar-inverse bg-primary">
        <div class="container-fluid mt10 mb10">

          <div class="navbar-header d-none d-lg-inline-flex d-xl-inline-flex  col-lg-3">
          <a class="navbar-brand text-center logohomeothers" href="./">
  </a>
          </div>
          <!-- Mobile Menu -->
          <nav class="navbar navbar-dark bg-primary float-left d-md-block d-sm-block d-xs-block d-lg-none d-xl-none" id="menutoggle">
          <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarToggleExternalContent" aria-controls="navbarToggleExternalContent" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
          </button>
          </nav>
          <!-- <div class="navbar-header ">
          <a class="navbar-brand text-center" href="#"><img src="images/blogtrackers.png" /></a>
          </div> -->
          <!-- Mobile menu  -->
          <div class="col-lg-6 themainmenu"  align="center">
            <ul class="nav main-menu2" style="display:inline-flex; display:-webkit-inline-flex; display:-mozkit-inline-flex;">
              <li><a class="bold-text" href="<%=request.getContextPath()%>/blogbrowser.jsp"><i class="homeicon"></i> <b class="bold-text ml30">Home</b></a></li>
          <li><a class="bold-text" href="<%=request.getContextPath()%>/trackerlist.jsp"><i class="trackericon"></i><b class="bold-text ml30">Trackers</b></a></li>
          <li><a class="bold-text" href="<%=request.getContextPath()%>/favorites.jsp"><i class="favoriteicon"></i> <b class="bold-text ml30">Favorites</b></a></li>
         
                 </ul>
          </div>

       <div class="col-lg-3">
  	 <% if(userinfo.size()>0){ %>
  		
	  <ul class="nav navbar-nav" style="display:block;">
		  <li class="dropdown dropdown-user cursor-pointer float-right">
		  <a class="dropdown-toggle " id="profiletoggle" data-toggle="dropdown">
		    <!-- <i class="fas fa-circle" id="notificationcolor"></i> -->
		   
		  <img src="<%=profileimage%>" width="50" height="50" onerror="this.src='images/default-avatar.png'" alt="" class="" />
		  <span><%=username%></span></a>
			
		   </li>
	    </ul>
         <% }else{ %>
         <ul class="nav main-menu2 float-right" style="display:inline-flex; display:-webkit-inline-flex; display:-mozkit-inline-flex;">
        
        	<li class="cursor-pointer"><a href="login.jsp">Login</a></li>
         </ul>
        <% } %>
      </div>

          </div>
          <div class="col-md-12 bg-dark d-md-block d-sm-block d-xs-block d-lg-none d-xl-none p0 mt20">
          <div class="collapse" id="navbarToggleExternalContent">
            <ul class="navbar-nav mr-auto mobile-menu">
                          <li class="nav-item active">
                <a class="" href="<%=request.getContextPath()%>/blogbrowser.jsp">Home <span class="sr-only">(current)</span></a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="<%=request.getContextPath()%>/trackerlist.jsp">Trackers</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="<%=request.getContextPath()%>/favorites.jsp">Favorites</a>
              </li>
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
  <a class="breadcrumb-item active text-primary" href="<%=request.getContextPath()%>/postingfrequency.jsp?tid=<%=tid%>">Posting Frequency</a>
  </nav>
<!-- <div><button class="btn btn-primary stylebutton1 " id="printdoc">SAVE AS PDF</button></div> -->
</div>

<div class="col-md-6 text-right mt10">
<div class="text-primary demo"><h6 id="reportrange">Date: <span><%=dispfrom%> - <%=dispto%></span></h6></div>
<div>
  <div class="btn-group mt5" data-toggle="buttons">
  <!-- <label class="btn btn-primary btn-sm daterangebutton legitRipple nobgnoborder"> <input type="radio" name="options" value="day" autocomplete="off" > Day
  	</label>
    <label class="btn btn-primary btn-sm nobgnoborder"> <input type="radio" name="options" value="week" autocomplete="off" >Week
  	</label>
     <label class="btn btn-primary btn-sm nobgnoborder nobgnoborder"> <input type="radio" name="options" value="month" autocomplete="off" > Month
  	</label>
    <label class="btn btn-primary btn-sm text-center nobgnoborder">Year <input type="radio" name="options" value="year" autocomplete="off" >
  	</label> -->
  <!--   <label class="btn btn-primary btn-sm nobgnoborder " id="custom">Custom</label> -->
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
    <h5 class="mt20 mb20">Bloggers</h5>
    <div style="padding-right:10px !important;">
      <input id="searchInput" type="search" class="form-control stylesearch mb20 searchbloggers inputportfolio2 searchkeywords" placeholder="Search Bloggers" />  
      <!-- <i class="fas fa-times searchiconinputclose cursor-pointer resetsearch"></i>  -->
     </div>
      	
      	<div style="height: 250px; padding-right: 10px !important;" id="scroll_list_loader" class="">
			<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />
		</div>
      
    	<div id="scroll_list" class="hidden scrolly" style="height:270px; padding-right:10px !important;">
    
					<%
					String dselected = "";
					String selectedid="";
					String activew = "";
					String post_counter = "";
					String pids = null;
					int total = 0;
					
					if (bloggerPostFrequency.size() > 0) {
						int p = 0;
						for (int m = 0; m < bloggerPostFrequency.size(); m++) {
							ArrayList<?> bloggerFreq = (ArrayList<?>) bloggerPostFrequency.get(m);
							String bloggerName = bloggerFreq.get(0).toString();
							String bloggerPostFreq = bloggerFreq.get(1).toString();
							String blogsiteId = bloggerFreq.get(2).toString();
								if (p < 10) {
									p++;
									
									
									//total += Integer.parseInt(bloggerPostFreq);
									post_counter = post._searchRangeTotalByBlogger("date", dt, dte, bloggerName);
									total +=  Integer.parseInt(post_counter);
									
									String formatedtotalpost_counter = NumberFormat.getNumberInstance(Locale.US).format(Integer.parseInt(post_counter));
									
										if(m==0){
												dselected = "abloggerselected";
												activew = "thanks";
												mostactiveblogger = bloggerName;
												pids = post._getPostIdsByBloggerName("date",dt, dte,"'"+bloggerName+"'","date","DESC");
												//allterms = term._searchByRange("blogsiteid", dt, dte, blogsiteId);//_searchByRange("blogpostid",dt, dte,postids);
												//System.out.println("Most active blogger:"+mostactiveblogger);
												try{
													allentitysentiments = blogpostsentiment._searchByRange(dt, dte, pids);
													
												}catch(Exception e){
													
												}
												
												//System.out.println("entity--" + allentitysentiments.size());
												//System.out.println("pids--" + pids);
												selectedid=blogsiteId; 
												
												
												//allposts = post._getBloggerByBloggerName("date",dt, dte,bloggerName,"date","DESC");	
												allposts = post._newGetBloggerByBloggerName("date", dt, dte, bloggerName, "DESC");
												//System.out.println("date---"+allposts+ dte+bloggerName+"date"+"DESC"+blogsiteId);
												
												
										}else{
												dselected = "";
												activew = "";
										}
			    	%>
					<input type="hidden" id="postby<%=bloggerName.replaceAll(" ","__")%>" value="" 
					/>
	    			<a name="<%=bloggerName%>" value="<%=post_counter %>"
	    			data-toggle="tooltip" data-placement="top" data-original-title="<%=bloggerName%>"
	    			 class="load_active_line topics topics1 blogger-select btn btn-primary select-term form-control bloggerinactive mb20 <%=activew %> <%=dselected%>" style="overflow:hidden;"  id="<%=blogsiteId%>" ><b><%=bloggerName%></b></a>
	    			<% 
					//JSONObject jsonObj = bloggersort.getJSONObject(m);
				}
			}
		}
			//System.out.println(allauthors);					
	%>
        <!--  
    <a class="btn form-control stylebuttoninactive opacity53 text-primary mb20"><b>Matt Fincane</b></a>
     <a class="btn form-control stylebuttoninactive opacity53 text-primary mb20"><b>Abel Danger</b></a>
     <a class="btn form-control stylebuttoninactive opacity53 text-primary mb20"><b>Matt Fincane</b></a>
     <a class="btn form-control stylebuttoninactive opacity53 text-primary mb20"><b>Matt Fincane</b></a>
     <a class="btn form-control stylebuttoninactive opacity53 text-primary mb20"><b>Matt Fincane</b></a>
     <a class="btn form-control stylebuttoninactive opacity53 text-primary mb20"><b>Matt Fincane</b></a>
     <a class="btn form-control stylebuttoninactive opacity53 text-primary mb20"><b>Matt Fincane</b></a>
-->
   </div>


  </div>
</div>
</div>

<%

/* int highestfrequency = 0;
JSONArray topterms = new JSONArray();
JSONObject keys = new JSONObject();
System.out.println("All terms: "+allterms);
JSONObject positions = new JSONObject();
int termsposition = 0;
if (allterms.size() > 0) {
	for (int p = 0; p < allterms.size(); p++) {
		String bstr = allterms.get(p).toString();
		JSONObject bj = new JSONObject(bstr);
		bstr = bj.get("_source").toString();
		bj = new JSONObject(bstr);
		String frequency = bj.get("frequency").toString();
		int freq = Integer.parseInt(frequency);
		
		String tm = bj.get("term").toString();
		if(freq>highestfrequency){
			highestfrequency = freq;
			mostusedkeyword = tm;
		}
		
		JSONObject cont = new JSONObject();
		
		if(keys.has(tm)){
			String allfreq = keys.get(tm).toString();
			String pos = positions.get(tm).toString();
			int fr1 = Integer.parseInt(frequency);
			int fr2 = Integer.parseInt(allfreq);
			
			cont.put("key", tm);
			cont.put("frequency", (fr1+fr2));
			topterms.put(Integer.parseInt(pos),cont);
		}else{
			cont.put("key", tm);
			cont.put("frequency", frequency);
			keys.put(tm,frequency);
			positions.put(tm,termsposition);
			topterms.put(cont);
		}
		
		/*
		cont.put("key", tm);
		cont.put("frequency", frequency);
		if(!keys.has(tm)){
			keys.put(tm,tm);
			topterms.put(cont);
		}
		*/
/* 	}
}  */



if (bloggerPostFrequency.size() > 0) {

	for (int n=0; n<1;n++) {
		ArrayList<?> bloggerFreq = (ArrayList<?>) bloggerPostFrequency.get(n);
		String bloggerName = bloggerFreq.get(0).toString();
		String bloggerPostFreq = bloggerFreq.get(1).toString();
		String blogsiteId = bloggerFreq.get(2).toString();
		
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
				   String totu = post._searchRangeTotalByBlogger("date",dtu, dtue,mostactiveblogger);
				  // totu = post._searchRangeTotalByBlogger("date",dtu, dtue,blogger.toString());
					
				   if(!years.has(y+"")){
			    		years.put(y+"",y);
			    		yearsarray.put(b,y);
			    		b++;
			    	}
				   
				   postyear.put(y+"",totu);
		}
		authoryears.put(bloggerName,postyear);
	}
}


String sentimentval = "Positive";
String sentimentcolor = "";
if(sentimentval.equalsIgnoreCase("negative"))
{
	sentimentcolor = "#FF7D7D";
}
else if(sentimentval.equalsIgnoreCase("positive"))
{
	sentimentcolor = "#72C28E";
}

totalpost =  post._searchRangeTotalByBlogger("date", dt, dte, mostactiveblogger);

//String formatedtotalpost = NumberFormat.getNumberInstance(Locale.US).format((Integer.parseInt(totalpost)/total) * 100);
String formatedtotalpost = String.format("%.0f",(Double.parseDouble(totalpost)/(double)total) * 100) + "%";
%>


<div class="col-md-9">



  <div class="card card-style mt20">
    <div class="card-body  p30 pt5 pb5">
      <div style="min-height: 250px;">
<div><p class="text-primary mt10"> Posting Trend of selected Blogger <!-- of Past <select class="text-primary filtersort sortbytimerange"><option value="week">Week</option><option value="month">Month</option><option value="year">Year</option></select> --></p></div>
		<div id="chart-container">
		<div class="chart-container">
		
		 	<!--   <div class="chart" id="d3-line-basic"></div> -->
		  
		  	<div id="line_graph_loader" class="hidden">
				<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />
			</div>
		  
		   <div id="newy_chart"></div>
		</div>
		</div>
      </div>
      
    
      
      
      
        </div>
  </div>
  <div class="card card-style mt20">
    <div class="card-body  p30 pt20 pb20">
      <div class="row">
     <div class="col-md-3 mt5 mb5">
       <h6 class="card-title mb0">Total Post</h6>
       <h3 class="mb0 bold-text total-post"><%=formatedtotalpost%></h3>
       <!-- <small class="text-success">+5% from <b>Last Week</b></small> -->
     </div>

     <div class="col-md-3 mt5 mb5">
      <h6 class="card-title mb0">Overall Sentiment</h6>

       <h3 class="mb0 bold-text" style="color:<%=sentimentcolor %>;"><%=sentimentval%></h3>

     </div>

     <div class="col-md-3 mt5 mb5">
       <h6 class="card-title mb0">Top Post Location</h6>
       <h3 class="mb0 bold-text top-location"><%=(null == toplocation || toplocation == "") ? "N/A" : toplocation%></h3> 
       <!-- <small class="text-success">+5% from <b>Last Week</b></small> -->
     </div>

     <div class="col-md-3  mt5 mb5">
       <h6 class="card-title mb0">Most Used Keyword</h6>
       <h3 class="mb0 bold-text most-used-keyword"><%=mostusedkeyword%></h3>
     </div>

      </div>
        </div>
  </div>
</div>
</div>

<div class="row mb0">
  <div class="col-md-6 mt20 ">
    <div class="card card-style mt20" style="min-height: 480px;">
      <div class="card-body  p30 pt5 pb5">
        <div><p class="text-primary mt10">Keywords of <b class="text-blue activeblogger"><%=mostactiveblogger%></b></p></div>
        
        <div id="keyword_loader" class="hidden">
			<img style='position: absolute;top: 50%;left: 50%;' src='images/loading.gif' />
		</div>
        
        <div class="keyword_chart" id="tagcloudbox">
        <div class="chart-container">
			<div class="chart" id="tagcloudcontainer"></div>
			<div class="jvectormap-zoomin zoombutton" id="zoom_in">+</div>
			<div class="jvectormap-zoomout zoombutton" id="zoom_out" >−</div> 
		</div>
        </div>
       </div>

    </div>
  </div>

  <div class="col-md-6 mt20">
    <div class="card card-style mt20">


          <div class="card-body p0 pt0 pb20" style="min-height: 480px;">
              <!-- <div><p class="text-primary p15 pt0 pb0 mt10">Top 5 Entities</p></div> -->

                  <div class="p15 pb5 pt20" role="group">
                
                  </div> 
                  <div id="entity_table">
                        <table id="DataTables_Table_15_wrapper" class="display table_over_cover" style="width:100%">
                                <thead>
                                    <tr>
                                        <th>Entity</th>
                                        <th>Type</th>
                                      <!--   <th>Frequency</th> -->
                                       <!--   <th>Sentiment</th> -->

                                    </tr>
                                </thead>
                                <tbody>
                               <% if(allentitysentiments.size()>0){							
									String tres = null;
									JSONObject tresp = null;
									String tresu = null;
									JSONObject tobj = null;
									int j=0;
									int k=0;
									for(int i=0; i< allentitysentiments.size(); i++){
										tres = allentitysentiments.get(i).toString();	
										tresp = new JSONObject(tres);
										tresu = tresp.get("_source").toString();
										tobj = new JSONObject(tresu);
									%>
                                    <tr>
                                        <td><%=tobj.get("entity").toString()%></td>
                                        <td><%=tobj.get("type").toString()%></td>
                                   <!--      <td></td> -->
                                          <%-- <td><%=tobj.get("sentiment").toString() %></td>  --%>
                                    </tr>
                                    <% }} %>
                                </tbody>
                            </table>
                          </div>
                </div>

    </div>
  </div>




</div>

<div class="row m0 mt20 mb50 d-flex align-items-stretch" >
  <div class="col-md-6 mt20 card card-style nobordertopright noborderbottomright">
  <div class="card-body p0 pt20 pb20" style="min-height: 420px;">
      <p>Blog Posts of <b class="text-blue activeblogger"><%=mostactiveblogger%></b></p>
         <!--  <div class="p15 pb5 pt0" role="group">
          Export Options
          </div> -->
          <div id="influence_table">
                <table id="DataTables_Table_0_wrapper" class="display" style="width:100%">
                        <thead>
                            <tr>
                                <th>Post title</th>
                                <th>Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            
						<%
/*                                 if(allposts.size()>0){	
                                
									String tres = null;
									JSONObject tresp = null;
									String tresu = null;
									JSONObject tobj = null;
									String date =null;
									int j=0;
									int k=0;
									for(int i=0; i< allposts.size(); i++){
 										tres = allposts.get(i).toString();	
										tresp = new JSONObject(tres);
										tresu = tresp.get("_source").toString();
										tobj = new JSONObject(tresu);
										String dat = tobj.get("date").toString().substring(0,10);
										LocalDate datee = LocalDate.parse(dat);
										DateTimeFormatter dtf = DateTimeFormatter.ofPattern("MMM dd, yyyy");
										date = dtf.format(datee);
										
										k++;  */
										
										Object hits_array = allposts.getJSONArray("hit_array");
										  String resul = null;
										  
										  resul = hits_array.toString();
										  JSONArray all = new JSONArray(resul);
										if(all.length()>0){	  
										  	String tres = null;
											JSONObject tresp = null;
											String tresu = null;
											JSONObject tobj = null;
											String date =null;
											int j=0;
											int k=0;
											String activeDef = "";
											String activeDefLink = "";
											
											
											for(int i=0; i< all.length(); i++){
												tres = all.get(i).toString();	
												tresp = new JSONObject(tres);
												
												tresu = tresp.get("_source").toString();
												tobj = new JSONObject(tresu);
												
												Object date_ = tresp.getJSONObject("fields").getJSONArray("date").get(0);
												String dat = date_.toString().substring(0,10);
												LocalDate datee = LocalDate.parse(dat);
												DateTimeFormatter dtf = DateTimeFormatter.ofPattern("MMM dd, yyyy");
												date = dtf.format(datee);
												
												if(i == 0){
													activeDef = "activeselectedblog";
													activeDefLink = "";
												}else{
													activeDefLink = "makeinvisible";
													activeDef = "";
												}
									%>
                                    <tr>
                                   <td><a class="blogpost_link cursor-pointer <%=activeDef %>" id="<%=tobj.get("blogpost_id")%>" ><%=tobj.get("title") %></a><br/>
								<a class="mt20 viewpost <%=activeDefLink %>" href="<%=tobj.get("permalink") %>" target="_blank"><buttton class="btn btn-primary btn-sm mt10 visitpost">Visit Post &nbsp;<i class="fas fa-external-link-alt"></i></buttton></a></td>
								<td align="center"><%=date %></td>
                                     </tr>
                                    <% }} %>
						
						 </tbody>
                    </table>
        </div>
        </div>

  </div>

  <div class="col-md-6 mt20 card card-style nobordertopleft noborderbottomleft">
       <div style="" class="pt20" id="blogpost_detail">
  		
				<%
                  /*               if(allposts.size()>0){							
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
										
										k++; */
										
										
										if(all.length()>0){	  
										  	String tres = null;
											JSONObject tresp = null;
											String tresu = null;
											JSONObject tobj = null;
											String date =null;
											int j=0;
											int k=0;
											
											
											for(int i=0; i< 1; i++){
												tres = all.get(i).toString();	
												tresp = new JSONObject(tres);
												
												tresu = tresp.get("_source").toString();
												tobj = new JSONObject(tresu);
												
												Object date_ = tresp.getJSONObject("fields").getJSONArray("date").get(0);
												String dat = date_.toString().substring(0,10);
												LocalDate datee = LocalDate.parse(dat);
												DateTimeFormatter dtf = DateTimeFormatter.ofPattern("MMM dd, yyyy");
												date = dtf.format(datee);
										
									%>                                    
                                    <h5 class="text-primary p20 pt0 pb0"><%=tobj.get("title")%></h5>
										<div class="text-center mb20 mt20">
											
											<button onclick="window.location.href = '<%=request.getContextPath()%>/bloggerportfolio.jsp?tid=<%=tid%>&blogger=<%=tobj.get("blogger")%>'"  class="btn stylebuttonblue">
												<b class="float-left ultra-bold-text"><%=tobj.get("blogger")%></b> <i
													class="far fa-user float-right blogcontenticon"></i>
											</button>
											
											<button class="btn stylebuttonnocolor nocursor"><%=date %></button>
									
											<button class="btn stylebuttonnocolor nocursor">
												<b class="float-left ultra-bold-text"><%=tobj.get("num_comments")%> comments</b><i
													class="far fa-comments float-right blogcontenticon"></i>
											</button>
										</div>
										<div style="height: 600px;">
										<div class="p20 pt0 pb20 text-blog-content text-primary"
											style="height: 550px; overflow-y: scroll;">

											<%=tobj.get("post").toString()%>

										</div>
										</div>       
                     		<% }} %>
                               
			</div>
    </div>
    
  </div>
</div>





</div>

	<form action="" name="customformsingle" id="customformsingle" method="post">
		<input type="hidden" name="tid" id="alltid" value="<%=tid%>" />
		<input type="hidden" name="blogid" id="blogid" value="<%=selectedid%>" />
		<input type="hidden" name="author" id="author" value="<%=mostactiveblogger%>" /> 
		<input type="hidden" name="single_date" id="single_date" value="" />
	</form>

	<form action="" name="customform" id="customform" method="post">
		<input type="hidden" name="tid" id="tid" value="<%=tid%>" /> 
		<input type="hidden" name="date_start" id="date_start" value="<%=dt%>" /> 
		<input type="hidden" name="date_end" id="date_end" value="<%=dte%>" />
		<input type="hidden" name="all_blog_ids" id="all_blog_ids" value="<%=ids%>" />
		<input type="hidden" name="total_post_count" id="total_post_count" value="<%=total%>" />
			
	</form>


<!-- <footer class="footer">
  <div class="container-fluid bg-primary mt60">
<p class="text-center text-medium pt10 pb10 mb0">Copyright &copy; Blogtrackers 2017 All Rights Reserved.</p>
</div>
  </footer> -->


  <script src="https://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>
 <script src="assets/bootstrap/js/bootstrap.js">
 </script>

 <script src="assets/vendors/bootstrap-daterangepicker/moment.js"></script>
 <script src="assets/vendors/bootstrap-daterangepicker/daterangepicker.js"></script>
 <!-- Start for tables  -->
 <script type="text/javascript" src="assets/vendors/DataTables/datatables.min.js"></script>
 <script type="text/javascript" src="assets/vendors/DataTables/dataTables.bootstrap4.min.js"></script>
 <script src="assets/vendors/DataTables/Buttons-1.5.1/js/buttons.flash.min.js"></script>
 <script src="assets/vendors/DataTables/Buttons-1.5.1/js/dataTables.buttons.min.js"></script>
<script src="assets/vendors/DataTables/pdfmake-0.1.32/pdfmake.min.js"></script>
 <script src="assets/vendors/DataTables/pdfmake-0.1.32/vfs_fonts.js"></script>
 <script src="assets/vendors/DataTables/Buttons-1.5.1/js/buttons.html5.min.js"></script>
 <script src="assets/vendors/DataTables/Buttons-1.5.1/js/buttons.print.min.js"></script>
 
 <script type="text/javascript" src="assets/vendors/d3/d3.min.js"></script>
 
  <script src="assets/js/generic.js"></script>
<script src="pagedependencies/postingfrequency1.js?v=789166990"></script>


<script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>

<script>
      window.Promise ||
        document.write(
          '<script src="https://cdn.jsdelivr.net/npm/promise-polyfill@8/dist/polyfill.min.js"><\/script>'
        )
      window.Promise ||
        document.write(
          '<script src="https://cdn.jsdelivr.net/npm/eligrey-classlist-js-polyfill@1.2.20171210/classList.min.js"><\/script>'
        )
      window.Promise ||
        document.write(
          '<script src="https://cdn.jsdelivr.net/npm/findindex_polyfill_mdn"><\/script>'
        )
    </script>
<script src="irregular-data-series.js"></script>
<script src="irregular-data.js"></script>
 <script>
    
 /////////////////////////////////////////////////////
 
 
 //////start time converting function
 	
 function convertTime(str) {
  var date = new Date(str);
  return [date.getFullYear()];
}
 
 
 ///////end time converting function
    
 
    var uche = [];
    var data = [];
    

  function color1(i, id, name){
    	
    	var t = parseFloat(i);
		
    	switch(t) {
    	//colors: ["#E377C2","#8C564B", "#9467BD", "#D62728", "#", "#", "#", "#","#", "#"],
        //case 0:
          //var hex = 'yellow';
        /* case 1:
          var hex = '#E377C2'; 
          break; */
        case 1:
          var hex = '#8C564B';
          break;
        case 2:
          var hex = '#9467BD';
          break;
        case 3:
          var hex = '#D62728';
          break;
        case 4:
          var hex = '#2CA02C';
          break;
        case 5:
          var hex = '#FF7F0E';
          break;
        case 6:
          var hex = '#1F77B4';
          break;
        case 7:
          var hex = '#7F7F7F';
          break;
        case 8:
          var hex = '#17B890';
          break;
        case 9:
          var hex = '#D35269';
          break;
        default:
          var hex = '#E377C2';

      }


    
    $('.thanks').each(function() {
    	
    	var g = $(this).attr('name');
    	
        if ( $(this).attr('name') == ''+name+'' ) {
        	$(this).css('background-color', hex);
        	$(this).removeClass('bloggerinactive ');
        	$(this).addClass('selectionactive');
        	$(this).css('font-weight', 'bold');
        };
        
    });
    return hex;


    }


    //////////////////////////////////////////////////////////////
    
    $(document).ready(function(){
    	
    	$('.line_graph').addClass('hidden');
        $('#line_graph_loader').removeClass('hidden');
        
        finalGraph();
    });
    
      
      
////////START APEX CHART
  	var chart;
  	
  	function beginApexChartBuild(data){
  		
	    var ts2 = 1484418600000;
	    var dates = [];
	    var spikes = [5, -5, 3, -3, 8, -8]
	    for (var i = 0; i < 7; i++) {
	      ts2 = ts2 + 86400000;
	      //var innerArr = [ts2, dataSeries[i].value];
	      var innerArr = [dataSeries[0][i].date, dataSeries[0][i].value];
	      dates.push(innerArr)
	    }
	    
	    
	    var ts2 = 1484418600000;
	    var dates1 = [];
	    var spikes = [5, -5, 3, -3, 8, -8]
	    for (var i = 0; i < 7; i++) {
	      ts2 = ts2 + 86400000;
	      //var innerArr = [ts2, dataSeries1[i].value];
	      var innerArr = [dataSeries1[0][i].date, dataSeries1[0][i].value];
	      dates1.push(innerArr)
	    }
   
      var options = {
        series: data,
      chart: {
          type: 'area',
          stacked: false,
          height: 222,
          zoom: {
            type: 'x',
            enabled: true,
            autoScaleYaxis: true
          },
          toolbar: {
            autoSelected: 'zoom'
          }
        },
        colors: ["#E377C2","#8C564B", "#9467BD", "#D62728", "#2CA02C", "#FF7F0E", "#1F77B4", "#7F7F7F","#17B890", "#D35269"],
        dataLabels: {
          enabled: false
        },
        markers: {
          size: 0,
        },
        title: {
          align: 'left'
        },
        fill: {
          type: 'gradient',
          gradient: {
            shadeIntensity: 1,
            inverseColors: false,
            opacityFrom: 0.5,
            opacityTo: 0,
            stops: [0, 90, 100]
          },
        },
        yaxis: {
          labels: {
            formatter: function (val) {
              //return (val / 10000).toFixed(0);
          	  return parseInt(val);
            },
          },
          title: {
            text: 'Post Count'
          },
        },
        xaxis: {
          type: 'datetime',
        },
        tooltip: {
          shared: false,
          y: {
            formatter: function (val) {
              //return (val / 10000).toFixed(0)
              return val
            }
          },
        
            x: {
              format: 'yyyy'
            },
         
        }
        };

      chart = new ApexCharts(document.querySelector("#newy_chart"), options);
      chart.render();
      $('.line_graph').removeClass('hidden');
      $('#line_graph_loader').addClass('hidden');
      
      $("#scroll_list_loader").addClass("hidden");
  	  $("#scroll_list").removeClass("hidden");
	   	  
	   	   
  	}
  ////END APEX CHART
  
////////START APEX CHART UPDATE
	function updateApexChartBuild(graph_data){
			
	
    var ts2 = 1484418600000;
    var dates = [];
    var spikes = [5, -5, 3, -3, 8, -8]
    for (var i = 0; i < 7; i++) {
      ts2 = ts2 + 86400000;
      //var innerArr = [ts2, dataSeries[i].value];
      var innerArr = [dataSeries[0][i].date, dataSeries[0][i].value];
      dates.push(innerArr)
    }
    
    
    var ts2 = 1484418600000;
    var dates1 = [];
    var spikes = [5, -5, 3, -3, 8, -8]
    for (var i = 0; i < 7; i++) {
      ts2 = ts2 + 86400000;
      //var innerArr = [ts2, dataSeries1[i].value];
      var innerArr = [dataSeries1[0][i].date, dataSeries1[0][i].value];
      dates1.push(innerArr)
    }
  
    var options = {
      series: graph_data,
    chart: {
        type: 'area',
        stacked: false,
        height: 350,
        zoom: {
          type: 'x',
          enabled: true,
          autoScaleYaxis: true
        },
        toolbar: {
          autoSelected: 'zoom'
        }
      },
      colors: ["#E377C2","#8C564B", "#9467BD", "#D62728", "#2CA02C", "#FF7F0E", "#1F77B4", "#7F7F7F","#17B890", "#D35269"],
      dataLabels: {
        enabled: false
      },
      markers: {
        size: 0,
      },
      title: {
        align: 'left'
      },
      fill: {
        type: 'gradient',
        gradient: {
          shadeIntensity: 1,
          inverseColors: false,
          opacityFrom: 0.5,
          opacityTo: 0,
          stops: [0, 90, 100]
        },
      },
      yaxis: {
        labels: {
          formatter: function (val) {
            //return (val / 10000).toFixed(0);
        	  return parseInt(val);
          },
        },
        title: {
          text: 'Post Count'
        },
      },
      xaxis: {
        type: 'datetime',
      },
      tooltip: {
        shared: false,
        y: {
          formatter: function (val) {
            //return (val / 10000).toFixed(0)
            return val
          }
        },
      
          x: {
            format: 'yyyy'
          },
       
      }
      };

    //var chart = new ApexCharts(document.querySelector("#newy_chart"), options);
    chart.updateOptions(options);
    $('.line_graph').removeClass('hidden');
	       $('#line_graph_loader').addClass('hidden');
	       
	      $("#scroll_list_loader").addClass("hidden");
	   	   $("#scroll_list").removeClass("hidden");
	   	  
	}
////END APEX CHART UPDATE
  
  
  //start buildNewfinalGraph
    function buildNewfinalGraph(){
     	
     	 var count = $('.thanks').length;
     	 
     	 graph_data = []
     	 
     	 if(count > 0){
     		 
     		 var t = 0;
     		
     		 $( ".thanks" ).each(function( index ) {
     			 
        		  	var ind = index;
     		    	blog_name = $(this).attr('name');
     		    	blog_id = 	this.id;
     		    	color1(t, blog_id, blog_name)
     		    	let obj = data.find(obj => obj.name == blog_name);
     		    	graph_data.push(obj)
     		    	t++;
     		    });
     		 /////end for each for active
     		 updateApexChartBuild(graph_data);
     	 }
     	
     }
  //end buildNewfinalGraph
  
  
  
      
    
      
   
  
   function finalGraph(){
    	
    	var data1 = [];
    	
    	var highest_date_index = 0;
   		var highest_price_index = 0;
   		
   		var highest_date_name = '';
   		var highest_price_name = '';
    		
  		var highest_date = 0;
  		var highest_price = 0;
    	
    	 var count = $('.load_active_line').length;
    	 
    
    	 
    	 if(count > 0){
    		 
    		 var t = 0;
    		
    		 $( ".load_active_line" ).each(function( index ) {
    			 
       		  		var ind = index;
       		  		
    		    	blog_name = 	$(this).attr('name');
    		    	
    		    	blog_id = 	this.id;
    		    	
    		    		
    		    		
    		    ////start ajax
    		    	
    		    	$.ajax({
    		    		
    		  			url: app_url + "PostingFrequencyTest",
    		  			method: 'POST',
    		  			dataType: 'json',
    		  			data: {
    		  				action:"getchart",
    		  				blogger:blog_name,
    		  				blog_id:blog_id,
    		  				index:ind,
    		  				async: false,
    		  				all_blog_ids:$("#all_blog_ids").val(),
    		  				sort:"date",
    		  				date_start:$("#date_start").val(),
    		  				date_end:$("#date_end").val(),
    		  			},
    		  			error: function(response)
    		  			{						
    		  				alert('error');
    		  				console.log(response);
    		  			//	$("#chart-container").html(response);
    		  			},
    		  			success: function(response)
    		  			{   
    		  				var arr1 = [];
    		  				var ts2 = 1484418600000;
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
    		  				
    		  					//var string3 = value.toString();
    		  					
    		  					//var string2 = key;
        		  				
    		  					var string3 = value;
    		  					var dateee = new Date(""+string2+"-01-01").getTime() / 1000
    		  					//arr1.push({date: string2 ,close: string3, name:response.name});
    		  					//arr1.push({date: ""+string2+"" ,value: parseInt(string3), name:response.name});
    		  					//var temp_date_in = ""+string2+"-01-01;
    		  					ts2 = ts2 + 86400000;
    		  					var innerArr = [string2+"-01-01T00:00:00.000Z", parseInt(string3)];
    		  					//var innerArr = [dateee, parseInt(string3)];
    		  					arr1.push(innerArr)
    				  		});
    		  				
    		  				
    		  				//data1.push({name: response.name,identify: response.identify,values:  arr1 });
    		  				data1.push({name: response.name,identify: response.identify,data:  arr1 });
    		  				
    		  				t++;
    	    		    	
    			    		if(count == t){
    			    			data1.forEach((arrayItem) => {data.push(arrayItem) });
    			    			graph_data = []
	    			    		/////start calling instantiate function
	    			    			
	    			    		/////end for each for active
	    			    		$( ".thanks" ).each(function( index ) {
	     			 
				        		  	var ind = index;
				     		    	blog_name = $(this).attr('name');
				     		    	blog_id = 	this.id;
				     		    	color1(t, blog_id, blog_name)
				     		    	let obj = data.find(obj => obj.name == blog_name);
				     		    	graph_data.push(obj)
				     		    	t++;
				     		    	
				     		    });
			     		 		/////end for each for active
			     		 
			     				beginApexChartBuild(graph_data)
    			    			////end calling in=stantiate function
    			    			
    		  				}
    		  				
    		  				
    				  			}
    		  			//end ajax success
    				  		});
    		    ///////end ajax
    		    		
    		    	
    		    
    		    });
    		 /////end for each for active
    		 
    	 }else{
    		 alert("no active selection");
    	 }
    	
    	
    	
    	
    }
    
    </script>
    
    
    
    
    
    

 <script>
 $(document).ready(function() {
	 
	 $('#printdoc').on('click',function(){
			print();
		}) ;
	 
     $('#DataTables_Table_15_wrapper').DataTable( {
         "scrollY": 250,
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
         "scrollX": true,
         "ordering": false,
          "pagingType": "simple",
        	  "columnDefs": [
        	      { "width": "65%", "targets": 0 },
        	      { "width": "25%", "targets": 0 }
        	    ]
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
       	      {   startDate: moment().subtract(3500, 'days'),
       	          endDate: moment(),
       	          minDate: '01/01/1947',
       	       	  linkedCalendars: false,
       	          maxDate: moment(),
       			  showDropdowns: true,
       	          showWeekNumbers: false,
       	          //timePicker : false,
   				  //timePickerIncrement : 1,
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
   	            	
   	            	//$("form#customform").submit();
   	            	
   	            	////start submit new date
   	            	var date_start = $("#date_start").val();
   	         	var date_end = $("#date_end").val();
   	         	
   	         	///////////////start collecting names
   	         	 var count = $('.thanks').length;
   	         	 
   	         	 if(count > 0){
   	         		 
   	         		 var all_selected_names = '';
   	         		 var all_selected_names1 = '';
   	         		 var i = 1;
   	         		 var total_post_counter = 0;
   	         		 $( ".thanks" ).each(function( index ) {
   	         			 
   	         			 
   	         			 if(i > 1){
   	         				 all_selected_names += ' , ';
   	         				 all_selected_names1 += ' , ';
   	         			 }
   	         			 
   	         	    	blog_name = 	$(this).attr('name');
   	         	    	
   	         	    	blog_id = 	this.id;
   	         	    	
   	         	    	all_selected_names += '"'+blog_name+'"';
   	         	    	all_selected_names1 += blog_name;
   	         	    		
   	         	    	i++;
   	         	    	
   	         	    	//getting total post count from each blogger
   	         	    	total_post_counter+=parseInt($(this).attr('value'));
   	         	    	
   	         		});
   	         		 
   	         		 
   	         	 }
   	         	////////////end collecting names
   	         	 
   	         	$(".activeblogger").html(all_selected_names1);
   	         	
   	         	loadTerms(all_selected_names,$("#all_blog_ids").val(),date_start,date_end, all_selected_names1);
   	         	loadInfluence(all_selected_names,date_start,date_end);
   	         	var total_post_count = $("#total_post_count").val();
   	         	total_post_percentage = (total_post_counter/parseInt(total_post_count) * 100);
   	         	$(".total-post").html(Math.round(total_post_percentage).toString() + "%");
   	         	getTopLocation(all_selected_names,$("#all_blog_ids").val(),date_start,date_end);
   	         	loadSentiments(all_selected_names,$("#all_blog_ids").val(),date_start,date_end);

   	            	////end  submiting new date
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
 
 <script src="assets/vendors/wordcloud/d3.layout.cloud.js"></script>
 <script type="text/javascript" src="assets/vendors/d3/d3_tooltip.js"></script>
 <script type="text/javascript" src="assets/js/jquery.inview.js"></script>

 
<script type="text/javascript"
		src="chartdependencies/keywordtrendd3.js"></script>
<!--word cloud  -->
 <script>
 
$(document).ready(function(){
	var blogger = "<%=mostactiveblogger%>"
	var temp_blog = '"'+blogger+'"';
	
	loadTerms(temp_blog,$("#blogid").val(),"<%=dt%>","<%=dte%>");
})
	
	//console.log(word_count2);
	<%
	
	

/* /* 	String sql = post._getMostKeywordDashboard(mostactiveblogger,dt,dte,ids);
	JSONObject res=post._keywordTermvctors(sql);	
	System.out.println("--->"+res); */ 
	
	//String sql = post._getMostKeywordDashboard(mostactiveblogger,dt,dte,ids);
	//Map<String, Integer> res = new HashMap<String, Integer>();

	//res=post._keywordTermvctors(sql);
	/* /* JSONObject res=post._keywordTermvctors(sql); */ 
	//JSONObject d = new JSONObject(res);
	//String s = res.toString();
	//JSONObject o = new JSONObject(res);
	
	/* Map<String, Integer> json = (HashMap<String, Integer>)json_type_2; */
						
	//System.out.println("testing w" + d);
	%>
	
	<%-- wordtagcloud("#tagcloudcontainer",450,<%=res%>);  --%>
	<%-- wordtagcloud("#tagcloudcontainer",450,<%=d%>); 
	 --%>
	 /* wordtagcloud("#tagcloudcontainer",450,word_count2); */

 </script>
<script src="pagedependencies/baseurl.js?v=93"></script>



</body>
</html>
<%} %>
