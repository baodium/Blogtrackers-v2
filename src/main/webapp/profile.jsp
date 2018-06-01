<%@page import="authentication.*"%>
<%@page import="java.util.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.File"%>
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
try{
 userinfo = new DbConnection().query("SELECT * FROM usercredentials where Email = '"+email+"'");
userinfo = (ArrayList<?>)userinfo.get(0);

username = userinfo.get(0).toString();
name = userinfo.get(4).toString()+" "+userinfo.get(5).toString();
email = userinfo.get(2).toString();
phone = userinfo.get(6).toString();
date_modified = userinfo.get(11).toString();


String path=application.getRealPath("/").replace('\\', '/')+"images/profile_images/";
String filename = path+userinfo.get(3).toString()+".jpg";
profileimage = "images/default-avatar.png";

File f = new File(filename);
if(f.exists() && !f.isDirectory()) { 
	profileimage = "images/profile_images/"+userinfo.get(3).toString()+".jpg";
}

}catch(Exception x){}
//pimage = pimage.replace("build/", "");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Blogtrackers</title>
  <link rel="shortcut icon" href="images/favicons/favicon.ico">
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
  <div class="offset-lg-9 col-lg-3 col-md-12 notificationpanel">
    <div id="closeicon" class="cursor-pointer"><i class="fas fa-times-circle"></i></div>
  <div class="profilesection col-md-12 mt50">
    <img src="<%=profileimage%>" width="60" height="60" alt="" class="float-left" />
    <div class="float-left" style="margin-left:20px;">
      <h4 class="text-primary m0 bolder"><%=name%></h4>
      <p class="text-primary"><%=email%></p>
    </div>

  </div>
  <div id="othersection" class="col-md-12 mt100" style="clear:both">
  <a class="cursor-pointer profilemenulink" href="notifications.html"><h3 class="text-primary">Notifications <b id="notificationcount" class="cursor-pointer">12</b></h3> </a>
  <a class="cursor-pointer profilemenulink" href="<%=request.getContextPath()%>/profile.jsp"><h3  class="text-primary">Profile</h3></a>
  <a class="cursor-pointer profilemenulink" href="<%=request.getContextPath()%>/logout"><h3 class="text-primary">Log Out</h3></a>
  </div>
  </div>
</div>
</div>
  <nav class="navbar navbar-inverse bg-primary">
    <div class="container-fluid mt10 mb10">

      <div class="navbar-header d-none d-lg-inline-flex d-xl-inline-flex  col-lg-4">
      <a class="navbar-brand text-center" href="#"><img src="images/blogtrackers.png" /></a>
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
      <div class="col-lg-4 themainmenu"  align="center">
        <ul class="nav main-menu2" style="display:inline-flex; display:-webkit-inline-flex; display:-mozkit-inline-flex;">
          <li><a href="<%=request.getContextPath()%>/dashboard.jsp"><i class="fas fa-home"></i> Home</a></li>
          <li><a href="trackerlist.html"><i class="far fa-dot-circle"></i> Trackers</a></li>
          <li><a href="#"><i class="far fa-heart"></i> Favorites</a></li>
        </ul>
      </div>

  <div class="col-lg-4">
  <ul class="nav navbar-nav" style="display:block;">
  <li class="dropdown dropdown-user cursor-pointer float-right">
  <a class="dropdown-toggle " id="profiletoggle" data-toggle="dropdown">
    <i class="fas fa-circle" id="notificationcolor"></i>
  <img src="<%=profileimage%>" width="50" height="50" alt="" class="" />
  <span><%=userinfo.get(0)%></span>
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
                <a class="" href="./">Home <span class="sr-only">(current)</span></a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="trackerlist.html">Trackers</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="#">Favorites</a>
              </li>
            </ul>
    </div>
      </div>
<div class="profilenavbar" style="visibility:hidden;">></div>
      <!-- <div class="col-md-12 mt0">
      <input type="search" class="form-control p30 pt5 pb5 icon-big border-none bottom-border text-center blogbrowsersearch nobackground" placeholder="Search Trackers" />
      </div> -->

    </nav>
<div class="container">


<div class="row mt10">
<div class="col-md-12">
<img class="rounded mx-auto d-block profilepageimg" src="<%=profileimage%>" width="150" height="150" alt="" />
<h1 class="text-center pt20 pb0 text-primary super-bold-text"><%=name%></h1>
<h6 class="text-center text-primary mb0 pb10">Email: <%=email%></h6>
<h6 class="text-center text-primary mb0 pb10">Phone: <%=phone%> </h6>
<p class="text-center "><button class="btn btn-primary stylebutton2"><%=date_modified%></button></p>


</div>
</div>

<div class="text-center mt90 mb50"><button class="btn btn-primary deletebtn"><b>Edit Account</b></button>&nbsp;&nbsp; <button class="btn btn-danger deletebtn"><b>Close Account</b></button></div>







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