<%@page import="authentication.*"%>
<%@page import="java.util.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
Object email = (null == session.getAttribute("email")) ? "" : session.getAttribute("email");

if (email == null || email == "") {
	response.sendRedirect("index.jsp");
}

ArrayList<?> userinfo = null;
String profileimage= "";
String username ="";
String name="";
String phone="";
String date_modified = "";

 userinfo = new DbConnection().query("SELECT * FROM usercredentials where Email = '"+email+"'");
 //System.out.println(userinfo);
if (userinfo.size()<1) {
	response.sendRedirect("index.jsp");
}else{
userinfo = (ArrayList<?>)userinfo.get(0);
try{
username = (null==userinfo.get(0))?"":userinfo.get(0).toString();

name = (null==userinfo.get(4))?"":(userinfo.get(4).toString());
email = (null==userinfo.get(2))?"":userinfo.get(2).toString();
phone = (null==userinfo.get(6))?"":userinfo.get(6).toString();
//date_modified = userinfo.get(11).toString();

String userpic = userinfo.get(9).toString();

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

String[] user_name = name.split(" ");
//pimage = pimage.replace("build/", "");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Blogtrackers - Analytics</title>
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
<link rel="stylesheet" href="assets/vendors/DataTables/Buttons-1.5.1/css/buttons.dataTables.min.css" />
<link rel="stylesheet" href="assets/css/daterangepicker.css" />

  <link rel="stylesheet" href="assets/css/style.css" />

  <!--end of bootsrap -->
  <script src="assets/js/jquery-3.2.1.slim.min.js"></script>
<script src="assets/js/popper.min.js" ></script>
</head>
<body>
  <div class="modal-notifications">
<div class="row">
<div class="col-lg-10 closesection">
	
	</div>
  <div class="col-lg-2 col-md-12 notificationpanel">
    <div id="closeicon" class="cursor-pointer"><i class="fas fa-times-circle"></i></div>
  <div class="profilesection col-md-12 mt50">
    <div class="text-center mb10" ><img src="<%=profileimage%>" width="60" height="60" onerror="this.src='images/default-avatar.png'" alt="" /></div>
    <div class="text-center" style="margin-left:0px;">
      <h6 class="text-primary m0 bolder profiletext"><%=name%></h6>
      <p class="text-primary profiletext"><%=email%></p>
    </div>

  </div>
  <div id="othersection" class="col-md-12 mt10" style="clear:both">
  <a class="cursor-pointer profilemenulink" href="<%=request.getContextPath()%>/notifications.jsp"><h6 class="text-primary">Notifications <b id="notificationcount" class="cursor-pointer">12</b></h6> </a>
  <a class="cursor-pointer profilemenulink" href="<%=request.getContextPath()%>/profile.jsp"><h6  class="text-primary">Profile</h6></a>
  <a class="cursor-pointer profilemenulink" href="<%=request.getContextPath()%>/logout"><h6 class="text-primary">Log Out</h6></a>
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
           <li><a class="bold-text" href="<%=request.getContextPath()%>/blogbrowser.jsp"><i class="fas fa-home"></i> Home</a></li>
          <li><a class="bold-text" href="<%=request.getContextPath()%>/trackerlist.jsp"><i class="far fa-dot-circle"></i> Trackers</a></li>
          <li><a class="bold-text" href="<%=request.getContextPath()%>/favorites.jsp"><i class="far fa-heart"></i> Favorites</a></li>
           
              </ul>
      </div>

  <div class="col-lg-3">
  <ul class="nav navbar-nav" style="display:block;">
  <li class="dropdown dropdown-user cursor-pointer float-right">
  <a class="dropdown-toggle " id="profiletoggle" data-toggle="dropdown">
    <i class="fas fa-circle" id="notificationcolor"></i>
  <img src="<%=profileimage%>" width="50" height="50" onerror="this.src='images/default-avatar.png'" alt="" class="" />
  <span><%=user_name[0]%></span>
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
<!-- <div class="profilenavbar" style="visibility:hidden;"></div> -->


    </nav>
  
 
<div class="container">



<!-- For large devices  -->
<div class="row pt40 pb50 m20 mt0 mb30">
  <div class="col-md-12 bottom-border">
  <h5>Analytics Features</h5>
  <p class="float-left text-primary">Blogtrackers offers range of tools</p>
  <p class="float-right text-primary">Layout <i class="fas fa-th-list cursor-pointer" id="listtoggle"></i> &nbsp;<i id="gridtoggle" class="fas fa-th cursor-pointer" ></i></p>
  </div>

<div class="row m0 listcontainer">
  <div class="col-md-12 p0 pt30">
  <div class="row m0 border-bottom">
  <div class="col-md-2 text-center">
      <div class="analytics-button2"><button class="btn btn-rounded big-btn"><i class="fas fa-chart-bar icon-small text-primary"></i></button></div>
  </div>
  <div class="col-md-10">
<h6 class="text-primary">Dashboard</h6>
<p>The dashboard provides an overview of the selected tracker. It displays the number of blogs, bloggers, blog posts, total positive and negative sentiments. It also shows blog sites' hosting location and language distribution.</p>
<div class="collapse" id="toggle-1" >
<ul>
<li>Number of Blogs</li>
<li>Number of Blog Posts</li>
<li>Number of Bloggers</li>
</ul>
</div>
<div class="pb30"><a href="<%=request.getContextPath()%>/dashboard.jsp"><button class="btn btn-primary stylebutton4">View</button></a> <a class="cursor-pointer text-primary linktextsize" data-toggle="collapse" data-target="#toggle-1"><i class="fas fa-plus"></i><b>More Details</b></a></div>

</div>
</div>
</div>

<div class="col-md-12 p0 pt30">
<div class="row m0 border-bottom">
<div class="col-md-2 text-center">
    <div class="analytics-button2"><button class="btn btn-rounded big-btn"><i class="fas fa-comment-alt icon-small text-primary"></i></button></div>
</div>
<div class="col-md-10">
<h6 class="text-primary">Posting Frequency</h6>
<p>It can be utilized to identify any unusual patterns in blog postings. This aids in detecting real-time events that interested the blogging community. This feature also displays a list of active bloggers with number of posts. User can click on any data point on the graph to get a detailed list of the named-entities that were mentioned in blogs during that time-period.
</p>
<div class="collapse" id="toggle-2" >
<ul>
<li>Number of Blogs</li>
<li>Number of Blog Posts</li>
<li>Number of Bloggers</li>
</ul>
</div>
<div class="pb30"><a href="<%=request.getContextPath()%>/postingfrequency.jsp"><button class="btn btn-primary stylebutton4">View</button></a> <a class="cursor-pointer text-primary linktextsize" data-toggle="collapse" data-target="#toggle-2"><i class="fas fa-plus"></i><b>More Details</b></a></div>

</div>
</div>
</div>

<div class="col-md-12 p0 pt30">
<div class="row m0 border-bottom">
<div class="col-md-2 text-center">
    <div class="analytics-button2"><button class="btn btn-rounded big-btn"><i class="fas fa-search icon-small text-primary"></i></button></div>
</div>
<div class="col-md-10">
<h6 class="text-primary">Keywords Trend</h6>
<p>It provides an overall trend of keywords of interest. It helps track changes in topics of interest in the blogging community. An analyst can correlate keyword trends with events to examine discussion topics and themes relating to that event. The analyst can select any data point on the trend line to view all the blogs.</p>
<div class="collapse" id="toggle-3" >
<ul>
<li>Number of Blogs</li>
<li>Number of Blog Posts</li>
<li>Number of Bloggers</li>
</ul>
</div>
<div class="pb30"><a href="<%=request.getContextPath()%>/keywordtrend.jsp"><button class="btn btn-primary stylebutton4">View</button></a> <a class="cursor-pointer text-primary linktextsize" data-toggle="collapse" data-target="#toggle-3"><i class="fas fa-plus"></i><b>More Details</b></a></div>

</div>
</div>
</div>

<div class="col-md-12 p0 pt30">
<div class="row m0 border-bottom">
<div class="col-md-2 text-center">
    <div class="analytics-button2"><button class="btn btn-rounded big-btn"><i class="fas fa-adjust icon-small text-primary"></i></button></div>
</div>
<div class="col-md-10">
<h6 class="text-primary">Sentiment Analysis</h6>
<p>It displays the trend of positive and negative sentiments of blogs for any selected time-period. This helps in understanding the effect an event has on the blogosphere. Additionally, data analyst can drill down by clicking on any point of interest and view radar charts displaying tonality attributes such as personal concerns, time orientation, core drives, cognitive process.</p>
<div class="collapse" id="toggle-4" >
<ul>
<li>Number of Blogs</li>
<li>Number of Blog Posts</li>
<li>Number of Bloggers</li>
</ul>
</div>
<div class="pb30"><a href="<%=request.getContextPath()%>/sentiment.jsp"><button class="btn btn-primary stylebutton4">View</button></a> <a class="cursor-pointer text-primary linktextsize" data-toggle="collapse" data-target="#toggle-4"><i class="fas fa-plus"></i><b>More Details</b></a></div>

</div>
</div>
</div>

<div class="col-md-12 p0 pt30">
<div class="row m0 border-bottom">
<div class="col-md-2 text-center">
    <div class="analytics-button2"><button class="btn btn-rounded big-btn"><i class="fas fa-exchange-alt icon-small text-primary"></i></button></div>
</div>
<div class="col-md-10">
<h6 class="text-primary">Influence</h6>
<p>This feature helps identify the influence a blogger or blog post has on the blogosphere. Blogtrackers finds the posts that are authoritative by assigning a score calculated using the iFinder model. This feature lists top 5 influential bloggers and displays a trend line to show the variation in bloggers' influence.</p>
<div class="collapse" id="toggle-5" >
<ul>
<li>Number of Blogs</li>
<li>Number of Blog Posts</li>
<li>Number of Bloggers</li>
</ul>
</div>
<div class="pb30"><a href="<%=request.getContextPath()%>/influence.jsp"><button class="btn btn-primary stylebutton4">View</button></a> <a class="cursor-pointer text-primary linktextsize" data-toggle="collapse" data-target="#toggle-5"><i class="fas fa-plus"></i><b>More Details</b></a></div>

</div>
</div>
</div>


<div class="col-md-12 p0 pt30">
<div class="row m0 border-bottom">
<div class="col-md-2 text-center">
    <div class="analytics-button2"><button class="btn btn-rounded big-btn"><i class="fas fa-database icon-small text-primary"></i></button></div>
</div>
<div class="col-md-10">
<h6 class="text-primary">Data Presentation</h6>
<p>This feature helps identify the influence a blogger or blog post has on the blogosphere. Blogtrackers finds the posts that are authoritative by assigning a score calculated using the iFinder model. This feature lists top 5 influential bloggers and displays a trend line to show the variation in bloggers' influence.</p>
<div class="collapse" id="toggle-6" >
<ul>
<li>Number of Blogs</li>
<li>Number of Blog Posts</li>
<li>Number of Bloggers</li>
</ul>
</div>
<div class="pb30"><button class="btn btn-primary stylebutton4">View</button> <a class="cursor-pointer text-primary linktextsize" data-toggle="collapse" data-target="#toggle-6"><i class="fas fa-plus"></i><b>More Details</b></a></div>

</div>
</div>
</div>


<div class="col-md-12 p0 pt30">
<div class="row m0 border-bottom">
<div class="col-md-2 text-center">
    <div class="analytics-button2"><button class="btn btn-rounded big-btn"><i class="fas fa-info-circle icon-small text-primary"></i></button></div>
</div>
<div class="col-md-10">
<h6 class="text-primary">Blog Portfolio</h6>
<p>This feature provides more in depth-details about the blog. It gives a between day and of average trend of a blog that helps in determining if the blog is a professional blog or a hobby blog. Also provided are monthly posting trend and sentiments for the past three years to determine the variation in activity and emotions. A list of URLs and domains mentioned in the blog is provided to know the source of information.</p>
<div class="collapse" id="toggle-7" >
<ul>
<li>Number of Blogs</li>
<li>Number of Blog Posts</li>
<li>Number of Bloggers</li>
</ul>
</div>
<div class="pb30"><a href="<%=request.getContextPath()%>/blogportfolio.jsp"><button class="btn btn-primary stylebutton4">View</button></a> <a class="cursor-pointer text-primary linktextsize" data-toggle="collapse" data-target="#toggle-7"><i class="fas fa-plus"></i><b>More Details</b></a></div>

</div>
</div>
</div>

<div class="col-md-12 p0 pt30">
<div class="row m0 border-bottom">
<div class="col-md-2 text-center">
    <div class="analytics-button2"><button class="btn btn-rounded big-btn"><i class="fas fa-user icon-small text-primary"></i></button></div>
</div>
<div class="col-md-10">
<h6 class="text-primary">Blogger Portfolio</h6>
<p>You can use the feature to export all your tracker information and download them in json format This will give you the flexibility to perform further computation using our dataset.</p>
<div class="collapse" id="toggle-8" >
<ul>
<li>Number of Blogs</li>
<li>Number of Blog Posts</li>
<li>Number of Bloggers</li>
</ul>
</div>
<div class="pb30"><a href="<%=request.getContextPath()%>/bloggerportfolio.jsp"><button class="btn btn-primary stylebutton4">View</button></a> <a class="cursor-pointer text-primary linktextsize" data-toggle="collapse" data-target="#toggle-8"><i class="fas fa-plus"></i><b>More Details</b></a></div>

</div>
</div>
</div>


<div class="col-md-12 p0 pt30">
<div class="row m0 border-bottom">
<div class="col-md-2 text-center">
    <div class="analytics-button2"><button class="btn btn-rounded big-btn"><i class="fas fa-share-alt icon-small text-primary"></i></button></div>
</div>
<div class="col-md-10">
<h6 class="text-primary">Blog Network</h6>
<p>A blog network is a group of blogs that are owned by the same entity. A blog network can either be a group of loosely connected blogs, or a group of blogs that are owned by the same company.</p>
<div class="collapse" id="toggle-9" >
<ul>
<li>Number of Blogs</li>
<li>Number of Blog Posts</li>
<li>Number of Bloggers</li>
</ul>
</div>
<div class="pb30"><button class="btn btn-primary stylebutton4">View</button> <a class="cursor-pointer text-primary linktextsize" data-toggle="collapse" data-target="#toggle-9"><i class="fas fa-plus"></i><b>More Details</b></a></div>

</div>
</div>
</div>

</div>

<div class="row hidden gridcontainer" >
<div class="col-md-4 mt10">

  <div class="card card-style mt20">
    <div class="heading-element bg-primary"></div>
    <div class="analytics-button"><button class="btn btn-rounded big-btn"><i class="fas fa-chart-bar icon-small text-primary"></i></button></div>
    <div class="card-body  p30 pt10 pb5">
  <h4 class="text-primary analytics-title">Dashboard</h4>
<div style="min-height: 170px;">
<p>-Number of Blogs</p>
<p>-Number of Blog Posts</p>
<p>-Number of Bloggers</p>
<div class="collapse pb20" id="toggle1" >
The dashboard provides an overview of the selected tracker. It displays the number of blogs, bloggers, blog posts, total positive and negative sentiments. It also shows blog sites' hosting location and language distribution.
</div>

<div class="pb20"><a href="<%=request.getContextPath()%>/dashboard.jsp"><button class="btn btn-primary stylebutton4">View</button></a> <a class="cursor-pointer text-primary linktextsize" data-toggle="collapse" data-target="#toggle1"><i class="fas fa-plus"></i><b>More Details</b></a></div>
  </div>
        </div>
  </div>



</div>


<div class="col-md-4 mt10">

  <div class="card card-style mt20">
    <div class="heading-element bg-primary"></div>
    <div class="analytics-button"><button class="btn btn-rounded big-btn"><i class="fas fa-comment-alt icon-small text-primary"></i></button></div>
    <div class="card-body  p30 pt10 pb5">
  <h4 class="text-primary analytics-title">Posting Frequency</h4>
<div style="min-height: 170px;">
<p>-Number of Blogs</p>
<p>-Number of Blog Posts</p>
<p>-Number of Bloggers</p>
<div class="collapse pb20" id="toggle2" >
It can be utilized to identify any unusual patterns in blog postings. This aids in detecting real-time events that interested the blogging community. This feature also displays a list of active bloggers with number of posts. User can click on any data point on the graph to get a detailed list of the named-entities that were mentioned in blogs during that time-period.
</div>

<div class="pb20"><a href="<%=request.getContextPath()%>/postingfrequency.jsp"><button class="btn btn-primary stylebutton4">View</button></a> <a class="cursor-pointer text-primary linktextsize" data-toggle="collapse" data-target="#toggle2"><i class="fas fa-plus"></i><b>More Details</b></a></div>
  </div>
        </div>
  </div>



</div>

<div class="col-md-4 mt10">

  <div class="card card-style mt20">
    <div class="heading-element bg-primary"></div>
    <div class="analytics-button"><button class="btn btn-rounded big-btn"><i class="fas fa-search icon-small text-primary"></i></button></div>
    <div class="card-body  p30 pt10 pb5">
  <h4 class="text-primary analytics-title">Keyword Trend</h4>
<div style="min-height: 170px;">
<p>-Number of Blogs</p>
<p>-Number of Blog Posts</p>
<p>-Number of Bloggers</p>
<div class="collapse pb20" id="toggle3" >
It provides an overall trend of keywords of interest. It helps track changes in topics of interest in the blogging community. An analyst can correlate keyword trends with events to examine discussion topics and themes relating to that event. The analyst can select any data point on the trend line to view all the blogs.
</div>

<div class="pb20"><a href="<%=request.getContextPath()%>/keywordtrend.jsp"><button class="btn btn-primary stylebutton4">View</button></a> <a class="cursor-pointer text-primary linktextsize" data-toggle="collapse" data-target="#toggle3"><i class="fas fa-plus"></i><b>More Details</b></a></div>
  </div>
        </div>
  </div>



</div>

<div class="col-md-4 mt10">

  <div class="card card-style mt20">
    <div class="heading-element bg-primary"></div>
    <div class="analytics-button"><button class="btn btn-rounded big-btn"><i class="fas fa-adjust icon-small text-primary" style="font-size:35px;"></i></button></div>
    <div class="card-body  p30 pt10 pb5">
  <h4 class="text-primary analytics-title">Sentiment Analysis</h4>
<div style="min-height: 170px;">
<p>-Number of Blogs</p>
<p>-Number of Blog Posts</p>
<p>-Number of Bloggers</p>
<div class="collapse pb20" id="toggle4" >
It displays the trend of positive and negative sentiments of blogs for any selected time-period. This helps in understanding the effect an event has on the blogosphere. Additionally, data analyst can drill down by clicking on any point of interest and view radar charts displaying tonality attributes such as personal concerns, time orientation, core drives, cognitive process.
</div>

<div class="pb20"><a href="<%=request.getContextPath()%>/sentiment.jsp"><button class="btn btn-primary stylebutton4">View</button></a><a class="cursor-pointer text-primary linktextsize" data-toggle="collapse" data-target="#toggle4"><i class="fas fa-plus"></i><b>More Details</b></a></div>
  </div>
        </div>
  </div>



</div>


<div class="col-md-4 mt10">

  <div class="card card-style mt20">
    <div class="heading-element bg-primary"></div>
    <div class="analytics-button"><button class="btn btn-rounded big-btn"><i class="fas fa-exchange-alt icon-small text-primary" style="font-size:35px;"></i></button></div>
    <div class="card-body  p30 pt10 pb5">
  <h4 class="text-primary analytics-title">Influence</h4>
<div style="min-height: 170px;">
<p>-Number of Blogs</p>
<p>-Number of Blog Posts</p>
<p>-Number of Bloggers</p>
<div class="collapse pb20" id="toggle5" >
This feature helps identify the influence a blogger or blog post has on the blogosphere. Blogtrackers finds the posts that are authoritative by assigning a score calculated using the iFinder model. This feature lists top 5 influential bloggers and displays a trend line to show the variation in bloggers' influence.
</div>

<div class="pb20"><a href="<%=request.getContextPath()%>/influence.jsp"><button class="btn btn-primary stylebutton4">View</button></a> <a class="cursor-pointer text-primary linktextsize" data-toggle="collapse" data-target="#toggle5"><i class="fas fa-plus"></i><b>More Details</b></a></div>
  </div>
        </div>
  </div>



</div>


<div class="col-md-4 mt10" >

  <div class="card card-style mt20">
    <div class="heading-element bg-primary"></div>
    <div class="analytics-button"><button class="btn btn-rounded big-btn"><i class="fas fa-database icon-small text-primary" style="font-size:35px;"></i></button></div>
    <div class="card-body  p30 pt10 pb5">
  <h4 class="text-primary analytics-title">Data Presentation</h4>
<div style="min-height: 170px;">
<p>-Number of Blogs</p>
<p>-Number of Blog Posts</p>
<p>-Number of Bloggers</p>
<div class="collapse pb20" id="toggle6" >
You can use the feature to export all your tracker information and download them in json format This will give you the flexibility to perform further computation using our dataset.
</div>

<div class="pb20"><button class="btn btn-primary stylebutton4">View</button> <a class="cursor-pointer text-primary linktextsize" data-toggle="collapse" data-target="#toggle6"><i class="fas fa-plus"></i><b>More Details</b></a></div>
  </div>
        </div>
  </div>

</div>


<div class="col-md-4 mt10" >

  <div class="card card-style mt20">
    <div class="heading-element bg-primary"></div>
    <div class="analytics-button"><button class="btn btn-rounded big-btn"><i class="fas fa-info-circle icon-small text-primary" style="font-size:35px;"></i></button></div>
    <div class="card-body  p30 pt10 pb5">
  <h4 class="text-primary analytics-title">Blog Portfolio</h4>
<div style="min-height: 170px;">
<p>-Number of Blogs</p>
<p>-Number of Blog Posts</p>
<p>-Number of Bloggers</p>
<div class="collapse pb20" id="toggle7" >
This feature provides more in depth-details about the blog. It gives a between day and of average trend of a blog that helps in determining if the blog is a professional blog or a hobby blog. Also provided are monthly posting trend and sentiments for the past three years to determine the variation in activity and emotions. A list of URLs and domains mentioned in the blog is provided to know the source of information.
</div>

<div class="pb20"><a href="<%=request.getContextPath()%>/blogportfolio.jsp"><button class="btn btn-primary stylebutton4">View</button></a> <a class="cursor-pointer text-primary linktextsize" data-toggle="collapse" data-target="#toggle7"><i class="fas fa-plus"></i><b>More Details</b></a></div>
  </div>
        </div>
  </div>

</div>


<div class="col-md-4 mt10" >

  <div class="card card-style mt20">
    <div class="heading-element bg-primary"></div>
    <div class="analytics-button"><button class="btn btn-rounded big-btn"><i class="fas fa-user icon-small text-primary" style="font-size:35px;"></i></button></div>
    <div class="card-body  p30 pt10 pb5">
  <h4 class="text-primary analytics-title">Blogger Portfolio</h4>
<div style="min-height: 170px;">
<p>-Number of Blogs</p>
<p>-Number of Blog Posts</p>
<p>-Number of Bloggers</p>
<div class="collapse pb20" id="toggle8" >
You can use the feature to export all your tracker information and download them in json format This will give you the flexibility to perform further computation using our dataset.
</div>

<div class="pb20"><a href="<%=request.getContextPath()%>/bloggerportfolio.jsp"><button class="btn btn-primary stylebutton4">View</button></a> <a class="cursor-pointer text-primary linktextsize" data-toggle="collapse" data-target="#toggle8"><i class="fas fa-plus"></i><b>More Details</b></a></div>
  </div>
        </div>
  </div>

</div>


<div class="col-md-4 mt10" >

  <div class="card card-style mt20">
    <div class="heading-element bg-primary"></div>
    <div class="analytics-button"><button class="btn btn-rounded big-btn"><i class="fas fa-share-alt icon-small text-primary" style="font-size:35px;"></i></button></div>
    <div class="card-body  p30 pt10 pb5">
  <h4 class="text-primary analytics-title">Blog Network</h4>
<div style="min-height: 170px;">
<p>-Number of Blogs</p>
<p>-Number of Blog Posts</p>
<p>-Number of Bloggers</p>
<div class="collapse pb20" id="toggle9" >
A blog network is a group of blogs that are owned by the same entity. A blog network can either be a group of loosely connected blogs, or a group of blogs that are owned by the same company.
</div>

<div class="pb20"><button class="btn btn-primary stylebutton4">View</button> <a class="cursor-pointer text-primary linktextsize" data-toggle="collapse" data-target="#toggle9"><i class="fas fa-plus"></i><b>More Details</b></a></div>
  </div>
        </div>
  </div>

</div>

</div>


</div>
<!--end  -->












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
<script>
$(document).ready(function(){
$('#gridtoggle').click(function(){
$('.gridcontainer').css("display","inherit").animate(3000);
$('.listcontainer').css("display","none");
})

$('#listtoggle').click(function(){
$('.listcontainer').css("display","inherit");
$('.gridcontainer').css("display","none");
})

})
</script>




</body>
</html>
<% } %>
