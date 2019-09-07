<%@page import="authentication.*"%>
<%@page import="java.util.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.File"%>
<%@page import="util.Blogposts"%>
<%@page import="java.text.NumberFormat" %>
<%@page import="java.util.Locale" %>
<%@page import="java.util.ArrayList"%>
<%@page import="org.json.JSONObject"%>
<%
Object email = (null == session.getAttribute("email")) ? "" : session.getAttribute("email");

//if (email == null || email == "") {
	//response.sendRedirect("login.jsp");
//}else{

ArrayList<?> userinfo = new ArrayList();//null;
String profileimage= "";
String username ="";
String name="";
String phone="";
String date_modified = "";

userinfo = new DbConnection().query("SELECT * FROM usercredentials where Email = '"+email+"'");
 //System.out.println(userinfo);
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

%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Blogtrackers - Notifications</title>
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
<script src="pagedependencies/googletagmanagerscript.js"></script>
</head>
<body>
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
  <a class="cursor-pointer profilemenulink" href="<%=request.getContextPath()%>/notifications.jsp"><h6 class="text-primary">Notifications <b id="notificationcount" class="cursor-pointer">12</b></h6> </a>
   <a class="cursor-pointer profilemenulink" href="<%=request.getContextPath()%>/addblog.jsp"><h6 class="text-primary">Add Blog</h6></a>
  <a class="cursor-pointer profilemenulink" href="<%=request.getContextPath()%>/profile.jsp"><h6 class="text-primary">Profile</h6></a>
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
		    <i class="fas fa-circle" id="notificationcolor"></i>
		   
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
      <div class="col-md-12 mt0">
      <input type="search" class="form-control p30 pt5 pb5 icon-big border-none bottom-border text-center blogbrowsersearch nobackground" placeholder="Search Notifications">
      </div>

      

    </nav>
<div class="container">


<!-- <div class="row mt10">
<div class="col-md-12 ">
<h6 class="text-center pt20 pb20 notificationsfont">2018</h6>
</div>
</div> -->

<div class="row mt30">
<div class="col-md-12 pl30 pr30">
<h6 class="float-left text-primary">30 Notifications</h6>
<h6 class="float-right text-primary"><select class="text-primary filtersort sortby"  id="sortbyselect"><option>Recent</option><option>Latest</option></select></h6><h6>
</h6></div>
</div>

<div class="col-lg-12 col-md-12 pt0 pb10  mt10 mb10 notification">
<div class="card noborder curved-card mb30">
<div class="text-center closeicon"><i class="fas fa-circle text-danger icon-big3 cursor-pointer " class="close" title="New"></i></div>
<a href="blogpostpage"><h2 class="text-primary p30 pt30 pb0">Hayder Kadhim saved a product from Tyler Stepanie Stead's post.</h2></a>
<p class="p30 pt10 pb10"><button class="btn btn-primary stylebuttonnotifications">Walter Richard</button> <button class="btn btn-primary stylebuttonnotifications">02-01-2018&nbsp;.&nbsp;5:30pm</button></p>
  <div class="card-body pt0">
    <h5 class="text-primary p10 pt20">
Think of Squarespace as your very own IT department, with free, unlimited hosting, top-of-the-line security, an enterprise-grade infrastructure, and around-the-clock support.
</h5>


  </div>

</div>

</div>

<div class="col-lg-12 col-md-12 pt0 pb10  mt10 mb10 notification">
<div class="card noborder curved-card mb30 " >
<div class="text-center closeicon"><i class="fas fa-circle text-primary icon-big3 cursor-pointer " class="close" title="New"></i></div>
<a href="blogpostpage"><h2 class="text-primary p30 pt30 pb0">Hayder Kadhim saved a product from Tyler Stepanie Stead's post.</h2></a>
<p class="p30 pt10 pb10"><button class="btn btn-primary stylebuttonnotifications">Walter Richard</button> <button class="btn btn-primary stylebuttonnotifications">02-01-2018&nbsp;.&nbsp;5:30pm</button></p>
  <div class="card-body pt0">
    <h5 class="text-primary p10 pt20">
Stephanie Think of Squarespace as your very own IT department, with free, unlimited hosting, top-of-the-line security, an enterprise-grade infrastructure,
and around-the-clock support. Get personalized support from our Customer Care Team via email or live chat, or join a live webinar. Reach out any time — we’re here 24/7...
</h5>


  </div>

</div>
</div>

<div class="col-lg-12 col-md-12 pt0 pb10  mt10 mb10 notification">
<div class="card noborder curved-card mb30  selected" >
<div class="text-center closeicon"><i class="fas fa-circle text-danger icon-big3 cursor-pointer " class="close" title="New"></i></div>
<a href="blogpostpage"><h2 class="text-primary p30 pt30 pb0">Hayder Kadhim saved a product from Tyler Stepanie Stead's post.</h2></a>
<p class="p30 pt10 pb10"><button class="btn btn-primary stylebuttonnotifications">Walter Richard</button> <button class="btn btn-primary stylebuttonnotifications">02-01-2018&nbsp;.&nbsp;5:30pm</button></p>
  <div class="card-body pt0">
    <h5 class="text-primary p10 pt20">
  Think of Squarespace as your very own IT department, with free, unlimited hosting, top-of-the-line security, an enterprise-grade infrastructure, and around-the-clock support.
</h5>


  </div>

</div>
</div>

<div class="col-lg-12 col-md-12 pt0 pb10  mt10 mb10 notification">
<div class="card noborder curved-card mb30  selected" >
<div class="text-center closeicon"><i class="fas fa-circle text-primary icon-big3 cursor-pointer " class="close" title="New"></i></div>
<a href="blogpostpage"><h2 class="text-primary p30 pt30 pb0">Hayder Kadhim saved a product from Tyler Stepanie Stead's post.</h2></a>
<p class="p30 pt10 pb10"><button class="btn btn-primary stylebuttonnotifications">Walter Richard</button> <button class="btn btn-primary stylebuttonnotifications">02-01-2018&nbsp;.&nbsp;5:30pm</button></p>
  <div class="card-body pt0">
    <h5 class="text-primary p10 pt10">
Think of Squarespace as your very own IT department, with free, unlimited hosting, top-of-the-line security, an enterprise-grade infrastructure, and around-the-clock support.
</h5>

  </div>

</div>
</div>

<div class="text-center mb50"><button class="btn btn-danger deletebtn"><b>Delete All</b></button></div>







</div>





<!-- <footer class="footer">
  <div class="container-fluid bg-primary mt60">
<p class="text-center text-medium pt10 pb10 mb0">Copyright &copy; Blogtrackers 2017 All Rights Reserved.</p>
</div>
  </footer> -->


 <script type="text/javascript" src="assets/js/jquery-1.11.3.min.js"></script>
<script src="assets/bootstrap/js/bootstrap.js">
</script>



<script>
$(document).ready(function() {

} );
</script>
<!--end for table  -->


<script src="assets/js/generic.js">
</script>

</body>
</html>
