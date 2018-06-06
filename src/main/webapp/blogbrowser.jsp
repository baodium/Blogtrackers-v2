<%@page import="util.Blogposts"%>
<%@page import="java.util.ArrayList"%>

<%@page import="org.json.JSONObject"%>

<%
Blogposts post  = new Blogposts();
ArrayList results = post._list("DESC");
String total = post._getTotal();
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Blogtrackers - Blog Browser</title>
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
<body >
<div class="modal-notifications">
<div class="row">
  <div class="offset-lg-9 col-lg-3 col-md-12 notificationpanel">
    <div id="closeicon" class="cursor-pointer"><i class="fas fa-times-circle"></i></div>
  <div class="profilesection col-md-12 mt50">
    <img src="https://i.pinimg.com/736x/31/74/48/3174480c49cee70bd03627255f136b83--fat-girls-girls-hbo.jpg" width="60" height="60" alt="" class="float-left" />
    <div class="float-left" style="margin-left:20px;">
      <h4 class="text-primary m0 bolder">Adigun Adekunle</h4>
      <p class="text-primary">adigon2006@gmail.com</p>
    </div>

  </div>
  <div id="othersection" class="col-md-12 mt100" style="clear:both">
  <a class="cursor-pointer profilemenulink" href="notifications.html"><h3 class="text-primary">Notifications <b id="notificationcount" class="cursor-pointer">12</b></h3> </a>
  <a class="cursor-pointer profilemenulink" href="profile.html"><h3  class="text-primary">Profile</h3></a>
  <a class="cursor-pointer profilemenulink" href="#"><h3 class="text-primary">Log Out</h3></a>
  </div>
  </div>
</div>
</div>
  <nav class="navbar navbar-inverse bg-primary">
    <div class="container-fluid mt10">

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
          <li><a href="./"><i class="fas fa-home"></i> Home</a></li>
          <li><a href="trackerlist.html"><i class="far fa-dot-circle"></i> Trackers</a></li>
          <li><a href="#"><i class="far fa-heart"></i> Favorites</a></li>
        </ul>
      </div>

  <div class="col-lg-4">
  <ul class="nav navbar-nav" style="display:block;">
  <li class="dropdown dropdown-user cursor-pointer float-right">
  <a class="dropdown-toggle " id="profiletoggle" data-toggle="dropdown">
    <i class="fas fa-circle" id="notificationcolor"></i>
  <img src="https://i.pinimg.com/736x/31/74/48/3174480c49cee70bd03627255f136b83--fat-girls-girls-hbo.jpg" width="50" height="50" alt="" class="" />
  <span>Hayder</span>
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

      <div class="col-md-12 mt0">
      <input type="search" class="form-control p30 pt5 pb5 icon-big border-none bottom-border text-center blogbrowsersearch nobackground" placeholder="Search Posts" />
      </div>

    </nav>
<div class="container">


<div class="row mt50">
<div class="col-md-12 ">
<h6 class="float-left text-primary"><%=total%> posts in our knowlede database</h6>
<h6 class="float-right text-primary">Recent <i class="fas fa-chevron-down"></i><h6/>
</div>
</div>


<div class="card-columns pt0 pb10  mt20 mb50 ">

<% if(results.size()>0){
		for(int i=0; i< results.size(); i++){
			String res = results.get(i).toString();
			
			JSONObject resp = new JSONObject(res);
		    String resu = resp.getString("_source");
		     JSONObject obj = new JSONObject(resu);
		     
		     String pst = obj.getString("post");
			
%>
<div class="card noborder curved-card mb30" >
<div class="text-center"><i class="fas text-medium pt40 fa-check text-light-color icon-big2 cursor-pointer" title="Select to Track Blog"></i></div>
<h4 class="text-primary text-center pt20"><%=obj.getString("title") %></h4>
<div class="text-center"><button class="btn btn-primary stylebutton3">TRACKING</button> <button class="btn btn-primary stylebutton2">0 Tracks</button></div>
  <div class="card-body">
    <a href="blogpostpage"><h4 class="card-title text-primary text-center pb20"><%=pst.substring(0,120)+"..."%></h4></a>
    <p class="card-text text-center author mb0 light-text"><%=obj.getString("blogger") %></p>
    <p class="card-text text-center postdate light-text">January 12, 2018 3:11pm</p>
  </div>
  <img class="card-img-top pt30 pb30" src="https://i.pinimg.com/736x/31/74/48/3174480c49cee70bd03627255f136b83--fat-girls-girls-hbo.jpg" alt="Card image cap">
  <div class="text-center"><i class="far fa-heart text-medium pb30  light-text icon-big"></i></div>
</div>

<% }
} %>





</div>









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
