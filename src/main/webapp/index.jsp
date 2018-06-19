<%@page import="java.util.*"%>
<%@page import="java.io.File"%>
<%
Object email = (null == session.getAttribute("email")) ? "" : session.getAttribute("email");
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
  <link rel="stylesheet" href="assets/fonts/fontawesome/css/font-awesome-animation.min.css" />
  <link rel="stylesheet" href="assets/fonts/iconic/css/open-iconic.css" />
 <link rel="stylesheet" href="assets/vendors/bootstrap-daterangepicker/daterangepicker.css" />
 <link rel="stylesheet" href="assets/css/table.css" />
 <link rel="stylesheet" href="assets/vendors/DataTables/dataTables.bootstrap4.min.css" />
<link rel="stylesheet" href="assets/vendors/DataTables/Buttons-1.5.1/css/buttons.dataTables.min.css" />
<link rel="stylesheet" href="assets/css/daterangepicker.css" />

  <link rel="stylesheet" href="assets/css/style.css" />
  <!--end of bootstrap -->
  <script src="assets/js/jquery-3.2.1.slim.min.js"></script>
<script src="assets/js/popper.min.js" ></script>
</head>
<body>
<div class="container-fluid home-top" style="min-height:500px;">
  <nav class="navbar navbar-inverse">



  <div class="navbar-header float-left">
  <a class="navbar-brand text-center" href="#"><img src="images/blogtrackers.png" /></a>
  </div>

  <nav class="navbar navbar-dark bg-primary float-right d-md-block d-sm-block d-xs-block d-lg-none d-xl-none" >
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarToggleExternalContent" aria-controls="navbarToggleExternalContent" aria-expanded="false" aria-label="Toggle navigation">
  <span class="navbar-toggler-icon"></span>
  </button>
  </nav>
<div class="themainmenu"  align="center">
  <ul class="nav main-menu2" style="display:inline-flex; display:-webkit-inline-flex; display:-mozkit-inline-flex;">
    <li><a href="#">Features</a></li>
    <li><a href="#">Sponsors</a></li>
    <li><a href="login.jsp">Login</a></li>
  </ul>
</div>

  <div class="col-md-12 bg-dark d-md-block d-sm-block d-xs-block d-lg-none d-xl-none p0 mt20">
  <div class="collapse" id="navbarToggleExternalContent">
    <ul class="navbar-nav mr-auto mobile-menu">
          <li class="nav-item active">
            <a class="" href="#">Features <span class="sr-only">(current)</span></a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="#">Sponsors</a>
          </li>
         <% if(email == "") { %>
			  <li class="nav-item">
				<a class="nav-link" href="login.jsp">Login</a>
			  </li>
          <% }else{ %>
           
			  <li class="nav-item">
	            <a class="nav-link" href="<%=request.getContextPath()%>/profile.jsp">My Profile</a>
	         </li>
	 		<li class="nav-item">
	            <a class="nav-link" href="<%=request.getContextPath()%>/logout">Logout</a>
	         </li>
          <% } %>
        </ul>
</div>
  </div>

</nav>

<div class="text-center mt60 offset-lg-3 col-lg-6 col-md-12" style="font-size:20px;">
<h1 class="text-white text-center">Track Internet Blogs</h1>
<p class="text-white text-center">Monitor and suggest valuable insights in a drilled-down fashion using content analysis and social network analysis</p>
<form method="search">
<input type="search" placeholder="Search Post" class="form-control searchhome"/>
<a href="<%=request.getContextPath()%>/blogbrowser.jsp"><button class="btn btn-success homebutton mt30 p40 pt10 pb10 mb50"><b>Start Tracking</b></button></a>
</form>

<div class="robotcontainer">

</div>

</div>




<script type="text/javascript" src="assets/js/jquery-1.11.3.min.js"></script>
<script src="assets/bootstrap/js/bootstrap.js">
</script>

</body>
</html>
