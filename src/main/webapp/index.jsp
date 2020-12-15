<%@page import="java.net.HttpURLConnection"%>
<%@page import="authentication.*"%>
<%@page import="java.util.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.File"%>
<%@page import="util.*"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%

Object email = (null == session.getAttribute("email")) ? "" : session.getAttribute("email");
Object error_message = (null == session.getAttribute("error_message")) ? "" : session.getAttribute("error_message");
Object success_message = (null == session.getAttribute("success_message")) ? "" : session.getAttribute("success_message");
String pi = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();



System.out.println("INDEX--" + request.getHeader("referer"));
//request.getHeader("referer").toString();

/*  if(request.getHeader("referer").equals(null)){
	session.invalidate();
	response.sendRedirect("login.jsp");
} */
/* else if(!request.getHeader("referer").equals(p +"/")){*/
	/* session.invalidate(); */
	/* response.sendRedirect(p +"/"); 

/* System.out.println("success__ 1--" + success_message); */

ArrayList<?> userinfo = new ArrayList();
String profileimage= "";
String username ="";
String name="";
String phone="";
String date_modified = "";

DbConnection dbconn = new DbConnection();
userinfo = dbconn.query("SELECT * FROM usercredentials where Email = '"+email+"'");
if (userinfo.size()<1) {
	//response.sendRedirect("dashboard.jsp");
}
else{
/* else if(!request.getHeader("referer").equals(p +"/forgotpassword.jsp") || !request.getHeader("referer").equals(p +"/ChangePassword.jsp") || ! request.getHeader("referer").equals(p+"/")){ */
	/* System.out.println("success__ 1--" + success_message); */
	/* System.out.println("COMI"+request.getHeader("referer"));
	System.out.println(p +"/forgotpassword.jsp");
	System.out.println(!request.getHeader("referer").equals(p +"/forgotpassword.jsp")); */
	System.out.println("INDEX--" + request.getHeader("referer"));
	System.out.println("INDEX--" + pi+"/");
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
				System.out.println("ready to be updated not an issue--"+ new_file_path);
				/*new DbConnection().updateTable("UPDATE usercredentials SET profile_picture  = '" + pass + "' WHERE Email = '" + email + "'"); */											
			}
		}else{
			path_new.mkdirs();
			profileimage = "images/default-avatar.png";
			/* profileimage = "images/profile_images/" + userinfo.get(2).toString() + ".jpg"; */
			/* profileimage=userpic.replace(userpic.substring(0, p), path_new.toString()); */
			String new_file_path = path_new.toString().replace("\\images\\profile_images", "")+"/"+profileimage;
			System.out.println("ready to be updated--"+ new_file_path);
			
			new DbConnection().updateTable("UPDATE usercredentials SET profile_picture  = '" + "images/profile_images/" + userinfo.get(2).toString() + ".jpg" + "' WHERE Email = '" + email + "'");
			System.out.println("updated");
		}				
	}else{
		System.out.println("path doesnt exist");
	}
	}catch(Exception e){
		profileimage = "images/default-avatar.png";
	}
}


%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Blogtrackers</title>
  <link rel="shortcut icon" href="images/favicons/favicon-48x48.png">
  <link rel="apple-touch-icon" href="images/favicons/favicon-48x48.png">
  <link rel="apple-touch-icon" sizes="96x96" href="images/favicons/favicon-96x96.png">
  <link rel="apple-touch-icon" sizes="144x144" href="images/favicons/favicon-144x144.png">
  <!-- start of bootsrap -->
  <link href="https://fonts.googleapis.com/css?family=Open+Sans:600,700" rel="stylesheet">
  <link rel="stylesheet" href="assets/bootstrap/css/bootstrap-grid.css"/>
  <link rel="stylesheet" href="assets/bootstrap/css/bootstrap.css"/>
  <link rel="stylesheet" href="assets/fonts/fontawesome/css/fontawesome-all.css" />
  <link rel="stylesheet" href="assets/fonts/fontawesome/css/font-awesome-animation.min.css" />
  <link rel="stylesheet" href="assets/fonts/iconic/css/open-iconic.css" />
 <link rel="stylesheet" href="assets/vendors/bootstrap-daterangepicker/daterangepicker.css" />
 <link rel="stylesheet" href="assets/css/table.css" />
 <link rel="stylesheet" href="assets/vendors/DataTables/dataTables.bootstrap4.min.css" />
<link rel="stylesheet" href="assets/vendors/DataTables/Buttons-1.5.1/css/buttons.dataTables.min.css" />
<link rel="stylesheet" href="assets/css/daterangepicker.css" />


	<link rel="stylesheet" href="assets/css/hover.css" />
	<link rel="stylesheet" href="assets/css/custom.css"  />
	<style>
	
	</style>
	
  <link rel="stylesheet" href="assets/css/style.css" />
  <!--end of bootstrap -->
  <script src="https://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>
<script src="assets/js/popper.min.js" ></script>
<script src="pagedependencies/googletagmanagerscript.js"></script>

</head>
<body style="background-color:none;">

<noscript>
<%@include file="subpages/googletagmanagernoscript.jsp" %>
</noscript>
<!-- End Google Tag Manager (noscript) -->
<div class="container-fluid home-top" style="min-height:500px;">

<% if(userinfo.size()>0){%>
<div class="modal-notifications">
<div class="row">
<div class="col-lg-10 closesection">
	
	</div>
  <div class="col-lg-2 col-md-12 notificationpanel">
    <div id="closeicon" class="cursor-pointer"><i class="fas fa-times-circle"></i></div>
  <div class="profilesection col-md-12 mt50">
    <div class="text-center mb10" ><img src="<%=profileimage%>" onerror="this.src='images/default-avatar.png'"  width="60" height="60" onerror="this.src='images/default-avatar.png'" alt="BlogTrackers Background" /></div>
    <div class="text-center" style="margin-left:0px;">
      <h6 class="text-primary m0 bolder profiletext"><%=name%></h6>
      <p class="text-primary profiletext"><%=email%></p>
    </div><!-- notificationcolor -->

  </div>
  <div id="othersection" class="col-md-12 mt10" style="clear:both">
  <%-- <a class="cursor-pointer profilemenulink" href="<%=request.getContextPath()%>/notifications.jsp"><h6 class="text-primary">Notifications <b id="notificationcount" class="cursor-pointer">12</b></h6> </a>
  --%> <a class="cursor-pointer profilemenulink" href="<%=request.getContextPath()%>/addblog.jsp"><h6 class="text-primary">Add Blog</h6></a>
  <a class="cursor-pointer profilemenulink" href="<%=request.getContextPath()%>/profile.jsp"><h6 class="text-primary">Profile</h6></a>
  <a
						class="cursor-pointer profilemenulink" target="_blank"
						href="https://addons.mozilla.org/en-US/firefox/addon/blogtrackers/"><h6
							class="text-primary">Plugin</h6></a>
  <a class="cursor-pointer profilemenulink" href="<%=request.getContextPath()%>/logout"><h6 class="text-primary">Log Out</h6></a>
  </div>
  </div>

</div>
</div>
  <nav class="navbar navbar-inverse">
    <div class="container-fluid mt10">

      <div class="navbar-header d-none d-lg-inline-flex d-xl-inline-flex  col-lg-3">
      <a class="navbar-brand text-center logohome" href="./">
   
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
  <ul class="nav navbar-nav" style="display:block;">
  <li class="dropdown dropdown-user cursor-pointer float-right">
  <a class="dropdown-toggle profiletoggle"  data-toggle="dropdown">
   <!--  <i class="fas fa-circle" id=""></i> -->
  <img src="<%=profileimage%>" width="50" height="50" alt="" class="" />
  <span><%=username%></span>
  <!-- <ul class="profilemenu dropdown-menu dropdown-menu-left">
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
    
    <!-- Sticky Menu  -->

<% }else{ %>

<nav class="navbar navbar-inverse">
<!-- Logo -->
  <div class="navbar-header float-left">
  <a class="navbar-brand text-center logohome" href="./">
  </a>
  </div>

  <nav class="navbar navbar-dark bg-primary float-right d-md-block d-sm-block d-xs-block d-lg-none d-xl-none" >
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarToggleExternalContent" aria-controls="navbarToggleExternalContent" aria-expanded="false" aria-label="Toggle navigation">
  <span class="navbar-toggler-icon"></span>
  </button>
  </nav>
  
  <!-- Desktop Menu -->
<div class="themainmenu"  align="center">
  <ul class="nav main-menu2 homemainmenuoveride" style="display:inline-flex; display:-webkit-inline-flex; display:-mozkit-inline-flex;">
    <li><a class="bold-text" href="#whatyoucando">Features</a></li>
    <li><a class="bold-text" href="#sponsors">Sponsors</a></li>
	<li><a class="bold-text" href="<%=request.getContextPath()%>/documentation.jsp">Learn</a></li>
	<li class="bg-white loginmenu"><a class="bold-text text-primary" href="<%=request.getContextPath()%>/login.jsp">Login</a></li>
	
  </ul>
</div>

<!-- Mobile menu -->
  <div class="col-md-12 bg-dark d-md-block d-sm-block d-xs-block d-lg-none d-xl-none p0 mt20">
  <div class="collapse" id="navbarToggleExternalContent">
    <ul class="navbar-nav mr-auto mobile-menu">
          <li class="nav-item active">
            <a class="bold-text" href="#whatyoucando">Features <span class="sr-only">(current)</span></a>
          </li>
          <li class="nav-item">
            <a class="nav-link bold-text" href="#sponsors">Sponsors</a>
          </li>
     <li class="nav-item">
            <a class="nav-link bold-text" href="<%=request.getContextPath()%>/documentation.jsp">Learn</a>
          </li>

		   <li class="nav-item">
				<a class="nav-link bold-text" href="login.jsp">Login</a>
			</li>         
        </ul>
</div>
</div>
</nav>

<!-- STICKY MENU  -->
<div class="navsticky container-fluid ">
<nav class="navbar navbar-inverse">
 <div class="navbar-header float-left">
  <a class="navbar-brand text-center logohome" href="./">
  </a>
  </div>
  
   <nav class="navbar navbar-dark bg-primary float-right d-md-block d-sm-block d-xs-block d-lg-none d-xl-none" >
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarToggleExternalContent" aria-controls="navbarToggleExternalContent" aria-expanded="false" aria-label="Toggle navigation">
  <span class="navbar-toggler-icon"></span>
  </button>
  </nav>
  
<div class="themainmenu"  align="center">
  <ul class="nav main-menu2 homemainmenuoveride" style="display:inline-flex; display:-webkit-inline-flex; display:-mozkit-inline-flex;">
    <li><a class="bold-text" href="#whatyoucando">Features</a></li>
    <li><a class="bold-text" href="#sponsors">Sponsors</a></li>
	<li><a class="bold-text" href="<%=request.getContextPath()%>/documentation.jsp">Learn</a></li>
	<li class="bg-white loginmenu"><a class="bold-text text-primary" href="<%=request.getContextPath()%>/login.jsp">Login</a></li>
	
  </ul>
</div>
<!-- Mobile menu -->
  <div class="col-md-12 bg-dark d-md-block d-sm-block d-xs-block d-lg-none d-xl-none p0 mt20">
  <div class="collapse" id="navbarToggleExternalContent">
    <ul class="navbar-nav mr-auto mobile-menu">
          <li class="nav-item active">
            <a class="bold-text" href="#whatyoucando">Features <span class="sr-only">(current)</span></a>
          </li>
          <li class="nav-item">
            <a class="nav-link bold-text" href="#sponsors">Sponsors</a>
          </li>
     

		   <li class="nav-item">
				<a class="nav-link bold-text" href="login.jsp">Login</a>
			</li>         
        </ul>
</div>
</div>
</nav>
</div>

<% } %>


<div class="text-center mt60 offset-lg-3 col-lg-6 col-md-12" style="font-size:20px;">
<h1 class="text-white text-center bold-text" style="font-size:55px;">Track Blogs</h1>
<p class="text-white text-center mt20" style="width:90%; margin:0 auto;">Monitor and suggest valuable insights in a drill down fashion using content analysis and social network analysis</p>
<form method="search" method="post" autocomplete="off" action="<%=request.getContextPath()%>/blogbrowser.jsp">
<input type="search" placeholder="Search" name="term" class="form-control searchhome bold-text"/>
<button type="submit" class="btn btn-success homebutton mt0 p40 pt10 pb10 mb60 mt40">Start Tracking</button>
</form>
</div>


<div class="robotcontainer">

</div>
</div>

<div class="container bggreyhome mt50 mb50" id="featuresection">
<div class="offset-md-2 col-md-8 offset-md-2">
<h3 class="whyfont text-primary text-center pt30">Why Blogtrackers?</h3>
<p class="text-center text-primary p40 pt10 pb10">Blogtrackers helps sociologists to track and analyze blogs of particular interests by designing and integrating unique features. </p>
</div>
<div class="row">
<div class="col-md-3"><p class="text-center"><i class="navbar-brand text-primary icontrackersize researchbased pt10"></i></p>
<p class="text-center text-primary textwhy mb10">Research Based</p>
<p class="text-center text-primary p20 pt0 pb0">Built to review user behavior in the blogosphere.</p>
</div>
<div class="col-md-3"><p class="text-center"><i class="navbar-brand text-primary icontrackersize userfriendly pt10"></i></p>
<p class="text-center text-primary textwhy mb10">User Friendly</p>
<p class="text-center text-primary p20 pt0 pb0">Easy-to-use interface for the user.</p></div>
<div class="col-md-3"><p class="text-center"><i class="navbar-brand text-primary icontrackersize insights pt10"></i></p>
<p class="text-center text-primary textwhy mb10">Actionable Insights</p>
<p class="text-center text-primary p20 pt0 pb0">Track Blogs at your tips.</p></div>

<div class="col-md-3"><p class="text-center"><i class="navbar-brand text-primary icontrackersize plugin-icon pt10"></i></p>
<p class="text-center text-primary textwhy mb10">Blogtrackers plugin</p>
<p class="text-center text-primary p20 pt0 pb0">Sign up to download.</p></div>

</div>
<div class="col-md-12 text-center"><button type="submit" class="btn btn-success homebutton mt0 p40 pt10 pb10 mb60 mt40 starttracking2">Start Tracking</button></div>
</div>
<div class="bgwhite">
<div class="container-fluid pb80 pt80" id="whatyoucando">
<div class="offset-md-2 col-md-8 offset-md-2">
<h3 class="sectiontitle text-primary text-center pt30">What Can You Do With It?</h3>
<!-- <p cl
ass="text-center text-primary p40 pt10 pb10">Blogtrackers helps sociologists to track and analyze blogs of particular interests by designing and integrating unique features. </p> -->
</div>

<!-- START OLD -->
<!-- <div id="featuresslides" class="carousel slide" data-ride="carousel">
  <div class="carousel-inner">
    <div class="carousel-item active">
     <div class="offset-md-2 col-md-8 offset-md-2">
<div class="row mt100 mb100">
<div class="col-md-4 borderleftprimary">
<h1 class="text-primary headertextwhatcanyoudo">Posting Frequency</h1>
<p class="text-primary whatcanyoudodesc">Analyze Traffic Pattern</p>
</div>
<div class="col-md-4 borderleftprimary">
<h1 class="text-primary headertextwhatcanyoudo">Keyword<br/> Trends</h1>
<p class="text-primary whatcanyoudodesc">Search Top Keywords</p>
</div>
<div class="col-md-4 borderleftprimary">
<h1 class="text-primary headertextwhatcanyoudo">Influence <br/>Analysis</h1>
<p class="text-primary whatcanyoudodesc">Check influence of Blogs, Posts, and Bloggers</p>
</div>
</div>
</div>
    </div>
    <div class="carousel-item">
      <div class="offset-md-2 col-md-8 offset-md-2">
<div class="row mt100 mb100">
<div class="col-md-4 borderleftprimary">
<h1 class="text-primary headertextwhatcanyoudo">Sentiments Analysis</h1>
<p class="text-primary whatcanyoudodesc">Analyze General Perception</p>
</div>
<div class="col-md-4 borderleftprimary">
<h1 class="text-primary headertextwhatcanyoudo">Network Analysis<br/> Trends</h1>
<p class="text-primary whatcanyoudodesc">Analyze Trends on Graphs<br/><br/></p>
</div>
<div class="col-md-4 borderleftprimary">
<h1 class="text-primary headertextwhatcanyoudo">Cross Media Analysis</h1>
<p class="text-primary whatcanyoudodesc">Analyze Social Media</p>
</div>
</div>
</div>
</div>
</div>
 <a class="carousel-control-prev" href="#featuresslides" role="button" data-slide="prev">
    <span class="carousel-control-prev-icon prevfeatures" aria-hidden="true"></span>
    <span class="sr-only">Previous</span>
  </a>
  <a class="carousel-control-next" href="#featuresslides" role="button" data-slide="next">
    <span class="carousel-control-next-icon nextfeatures" aria-hidden="true"></span>
    <span class="sr-only">Next</span>
  </a>
</div> -->
<!-- END OLD-->
<!-- START NEW -->
<div class="row" style="padding-bottom: 30px; padding-top: 30px;">
    <div class="hover-desc col-md-2 hvr-bob"><p class="text-center"><i class="navbar-brand text-primary icontrackersize sentiment-analysis pt10"></i></p>
    <p class="text-center text-primary textwhy mb10">Sentiments Analysis</p>
    <p class="text-center text-primary p20 pt0 pb0">Analyze General Perception</p>
    </div>
    <div class="hover-desc col-md-2 hvr-bob"><p class="text-center"><i class="navbar-brand text-primary icontrackersize network-analysis pt10"></i></p>
    <p class="text-center text-primary textwhy mb10">Network Analysis Trend</p>
    <p class="text-center text-primary p20 pt0 pb0">Analyze Trends on Graphs</p></div>
    <div class="hover-desc col-md-2 hvr-bob"><p class="text-center"><i class="navbar-brand text-primary icontrackersize cross-analysis pt10"></i></p>
    <p class="text-center text-primary textwhy mb10">Cross Media Analysis</p>
    <p class="text-center text-primary p20 pt0 pb0">Analyze Social Media.</p></div>
    <div class="hover-desc col-md-2 hvr-bob"><p class="text-center"><i class="navbar-brand text-primary icontrackersize data pt10"></i></p>
    <p class="text-center text-primary textwhy mb10">Posting Frequency</p>
    <p class="text-center text-primary p20 pt0 pb0">Analyze Traffic Pattern</p></div>
    <div class="hover-desc col-md-2 hvr-bob"><p class="text-center"><i class="navbar-brand text-primary icontrackersize data-analytics pt10"></i></p>
    <p class="text-center text-primary textwhy mb10">Keyword Trends</p>
    <p class="text-center text-primary p20 pt0 pb0">Search Top Keywords</p></div>
    <div class="hover-desc col-md-2 hvr-bob"><p class="text-center"><i class="navbar-brand text-primary icontrackersize planning pt10"></i></p>
    <p class="text-center text-primary textwhy mb10">Influence Analysis</p>
    <p class="text-center text-primary p20 pt0 pb0">Check Influence of Blogs, Posts and Bloggers</p></div>
</div>
<!-- END NEW -->


<!-- <div class="row mt100 mb100">
<div class="col-md-4 borderleftprimary">
<h1 class="text-primary headertextwhatcanyoudo">Traffic <br/>Pattern Analysis</h1>
<p class="text-primary whatcanyoudodesc">Search top keywords</p>
</div>
<div class="col-md-4 borderleftprimary">
<h1 class="text-primary headertextwhatcanyoudo">Keyword Trends Exploration</h1>
<p class="text-primary whatcanyoudodesc">Search top keywords</p>
</div>
<div class="col-md-4 borderleftprimary">
<h1 class="text-primary headertextwhatcanyoudo">Influence Detection</h1>
<p class="text-primary whatcanyoudodesc">Check influence of Blogs, Blog Posts and Bloggers</p>
</div>
</div> -->
<div class="col-md-12 text-center"><button type="submit" class="btn btn-success homebutton mt0 mb20 p40 pt10 pb10 starttracking2">Start Tracking</button></div>
</div>
</div>
<div class="bggrey">
<div class="container pb80 pt80" id="sponsors">
<div class="row">


<div class="col-md-12" align="center">
<div class="row sponsor-region">
            <div class="col-md-2">
             <!--  <div class="card mb-4 box-shadow"> -->
              <!-- <div class="logocontainer"> -->
                <img class="card-img-top" alt="National Science Foundation" style="width: 80%; display: block;" src="images/sponsors/nationalsciencefoundation.png" data-holder-rendered="true">
               <!--  </div> -->
                 <div class="card-body"> 
         <p class="logo-text">National Science <br/>Foundation</p>
                  </div> 
             <!--  </div> -->
            </div>
            
              <div class="col-md-2">
             <!--  <div class="card mb-4 box-shadow"> -->
               <!-- <div class="logocontainer"> -->
                <img class="card-img-top" alt="Office of Naval Research" style="width: 80%; display: block;" src="images/sponsors/officeofnavalresearch.png" data-holder-rendered="true">
               <!-- </div> -->
                <div class="card-body">
                 <p class="logo-text">Office of Naval <br/>Research</p>
                </div>
              <!-- </div> -->
            </div>
            
            <div class="col-md-2">
             <!--  <div class="card mb-4 box-shadow"> -->
               <!-- <div class="logocontainer"> -->
                <img class="card-img-top" alt="Air Force Research Laboratory" style="width: 80%; display: block;" src="images/sponsors/airforceresearch.png" data-holder-rendered="true">
               <!-- </div> -->
                <div class="card-body">
                <p class="logo-text">Air Force Research Laboratory</p>
                </div>
              <!-- </div> -->
            </div>
            
            <div class="col-md-2">
              <!-- <div class="card mb-4 box-shadow"> -->
              <!--  <div class="logocontainer"> -->
                <img class="card-img-top" alt="Defense Advanced Research Project Agency" style="width: 80%; display: block;" src="images/sponsors/darpa.png" data-holder-rendered="true">
               <!-- </div> -->
                <div class="card-body">
                <p class="logo-text">Defense Advanced Research <br/>Projects Agency</p>
                </div>
             <!--  </div> -->
            </div>
            
             <div class="col-md-2">
              <!-- <div class="card mb-4 box-shadow"> -->
               <!-- <div class="logocontainer"> -->
                <img class="card-img-top" alt="Army Research Office" style="width: 80%; display: block;" src="images/sponsors/armyresearchoffice.png" data-holder-rendered="true">
               <!-- </div> -->
                <div class="card-body">
             <p class="logo-text">Army Research <br/>Office</p>
                </div>
              <!-- </div> -->
            </div>
            
            <div class="col-md-2">
              <!-- <div class="card mb-4 box-shadow"> -->
               <!-- <div class="logocontainer"> -->
                <img class="card-img-top" alt="Department of Homeland Security" style="width: 80%; display: block;" src="images/sponsors/departmentofhomeland.png" data-holder-rendered="true">
               <!-- </div> -->
                <div class="card-body">
            <p class="logo-text">Department of <br/>Homeland Security</p>
                </div>
              <!-- </div> -->
            </div>
            
            
           
            

            
           

           
            
           
          </div>

<!-- <div class="eachlogo text-center">
<div class="logocontainer mb10">
<img class="" src="images/sponsors/nationalsciencefoundation.png" />
</div>
<p class="logo-text">National Science <br/>Foundation</p>
</div>

<div class="eachlogo text-center">
<div class="logocontainer mb10">
<img class="" src="images/sponsors/officeofnavalresearch.png" /></div>
<p class="logo-text">Office of Naval <br/>Research</p>
</div>


<div class="eachlogo text-center">
<div class="logocontainer mb10">
<img src="images/sponsors/airforceresearch.png" />
</div>
<p class="logo-text">Air Force<br/> Research Laboratory</p>
</div>


<div class="eachlogo text-center">
<div class="logocontainer mb10">
<img class="" src="images/sponsors/darpa.png" />
</div>
<p class="logo-text">Defense Advanced Research <br/>Projects Agency</p>
</div>

<div class="eachlogo text-center">
<div class="logocontainer mb10">
<img class="" src="images/sponsors/armyresearchoffice.png" />
</div>
<p class="logo-text">Army Research <br/>Office</p>
</div>


<div class="eachlogo text-center">
<div class="logocontainer mb10">
<img class="" src="images/sponsors/departmentofhomeland.png" /></div>
<p class="logo-text">Department of <br/>Homeland Security</p>
</div> -->


</div>
</div>
</div>
</div>
<!-- <div class="bgmaroon">
<div class="container-fluid pb150 pt150" id="testimonials">
<p class="text-white text-center mb0 testmonialheadingtext">Testimonials</p>
<div id="testimonialslides" class="carousel slide" data-ride="carousel">
  <div class="carousel-inner">
    <div class="carousel-item active">
     <div class="offset-md-3 col-md-6 offset-md-3">
<h1 class="text-center quote-text">”</h1>
<h1 class="text-center testimonial-text">
Design is not just what it looks like and feels like. Design is how it works.
</h1>
</div>
    </div>
    <div class="carousel-item">
      <div class="offset-md-3 col-md-6 offset-md-3">
<h1 class="text-center quote-text">”</h1>
<h1 class="text-center testimonial-text">
Design is not just what it looks like and feels like. Design is how it works.
</h1>
</div
    </div>
    <div class="carousel-item">
      <div class="offset-md-3 col-md-6 offset-md-3">
<h1 class="text-center quote-text">”</h1>
<h1 class="text-center testimonial-text">
Design is not just what it looks like and feels like. Design is how it works.
</h1>
</div>
    </div>
  </div>
   <a class="carousel-control-prev" href="#testimonialslides" role="button" data-slide="prev">
    <span class="carousel-control-prev-icon prevtestimonial" aria-hidden="true"></span>
    <span class="sr-only">Previous</span>
  </a>
  <a class="carousel-control-next" href="#testimonialslides" role="button" data-slide="next">
    <span class="carousel-control-next-icon nexttestimonial" aria-hidden="true"></span>
    <span class="sr-only">Next</span>
  </a>
</div>
<div class="offset-md-3 col-md-6 offset-md-3">
<h1 class="text-center quote-text">”</h1>
<h1 class="text-center testimonial-text">
Design is not just what it looks like and feels like. Design is how it works.
</h1>
</div>
</div>
</div> -->
<div class="bgwhite">
<a target="_blank" href="http://cosmos.ualr.edu/">
<div class="container-fluid pb50 pt50" id="testimonials">
<p class="text-center mb0 copyrighttext">Developed By</p>

<p class="text-center mb0"><i class="navbar-brand text-primary icontrackersize cosmoslogo mt30 mb10"></i></p>
</div>
</div>
<%
Date d=new Date();  
int year=d.getYear();  
System.out.println("Year for date object is : "+year);  
System.out.println("***To get current year add 1900 to the value of year obtained from this date object***");  
int currentYear=year+1900;  
%>
<div class="bg-primary">
<div class="container-fluid pb10 pt10">
<p class="mb0 text-center copyrighttext text-white">Copyright &copy; <%=currentYear %>, COSMOS. All Rights Reserved.</p>
</div>
</div>
</a>

<div class="text-center cursor-pointer helpcontainer">
<a href="<%=request.getContextPath()%>/documentation.jsp" class="navbar-brand cursor-pointer helpicon">
<!-- <i class="text-white" ></i> -->

</a>
 </div>




<script src="https://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>
<script src="assets/bootstrap/js/bootstrap.js">
</script>
<script src="js/jscookie.js"></script>
<%@include file="templates/checkloginstatus.jsp" %>
<script src="assets/js/generic.js"></script>
<script src="assets/js/smoothscroll.js">

</script>
<script>
$(document).ready(function(){
$('.starttracking2').on("click", function(){
location = "blogbrowser.jsp";	
});	
});
</script>
</body>
</html>