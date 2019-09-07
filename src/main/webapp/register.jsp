<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Blogtrackers - Register</title>
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

<link rel="stylesheet" href="assets/css/toastr.css">
<!--end of bootsrap -->
<script src="assets/js/jquery.min.js"></script>
<script src="assets/js/popper.min.js"></script>

<!-- JavaScript to be reviewed thouroughly by me -->
<script type="text/javascript" src="assets/js/validate.min.js"></script>
	<script type="text/javascript" src="assets/js/uniform.min.js"></script>
	
<script type="text/javascript" src="assets/js/toastr.js"></script>
 <script src="https://apis.google.com/js/platform.js" async defer></script>
  <meta name="google-signin-client_id" content="600561618290-lmbuo5mamod25msuth4tutqvkbn91d6v.apps.googleusercontent.com">

<!-- Base URL  -->
  <script src="pagedependencies/baseurl.js">
  </script>
  
<script type="text/javascript" src="js/login_validation.js?v=89"></script>

  <link rel="stylesheet" href="assets/css/style.css" />

  <!--end of bootsrap -->
 <!--   <script src="assets/js/jquery-3.2.1.slim.min.js"></script>-->
<script src="assets/js/popper.min.js" ></script>
<script src="pagedependencies/googletagmanagerscript.js"></script>
</head>

<body class="bgwhite">
<%@include file="subpages/loader.jsp" %>
<%@include file="subpages/googletagmanagernoscript.jsp" %>
  <nav class="navbar navbar-inverse bg-primary d-md-block d-sm-block d-xs-block d-lg-none d-xl-none">
    <div class="container-fluid">

  <div class="navbar-header col-md-12 text-center">

  <a class="navbar-brand text-center col-md-12 logohome" href="./">
<!--   <img src="images/blogtrackers.png"  /> -->
  </a>

  </div>


    </div>
    </nav>


    <div class="registerbox">
      <div class="row d-flex align-items-stretch">
      <div class="col-md-7 card m0 p0 borderradiusround nobordertopright noborderbottomright noborder">
          <div class="card-body p40 pt40 pb5 borderradiusround nobordertopright noborderbottomright" style="background-color:#F3F4F5;">
          <p class="text-primary text-left mb30 mt30" style="font-size:26px;">Welcome to <b>Blogtrackers</b></p>
      <form id="register_form"  class=""  method="post">
      <div class="form-group">
		<div class="form-login-error">
             <p id="error_message-box" style="color:red"></p>
		</div>
        <input type="text" id="name" required="required" class="form-control curved-form-login text-primary"   placeholder="Full Name">
        <!-- <small id="emailHelp" class="form-text text-muted">We'll never share your email with anyone else.</small> -->
      </div>
      <div class="form-group">
        <input type="email" id="email" required="required" class="form-control curved-form-login text-primary"  placeholder="Email">
      </div>

      <div class="form-group">
        <input type="password" id="password" required="required" class="form-control curved-form-login text-primary"  placeholder="Password">
      </div>
      <div class="form-group">
        <input type="password" id="password2" required="required" class="form-control curved-form-login text-primary"  placeholder="Re-type Password">
      </div>

    <p class="text-center float-left">
    <button type="submit" class="btn btn-primary loginformbutton mt10" style="background:#28a745;">Register</button>
  <!--   &nbsp;&nbsp; or Register with &nbsp;&nbsp; -->
   <!--  <button class="btn btn-rounded big-btn2"><i class="fab fa-google icon-small text-primary"></i></button> -->
    <!-- <button class="btn buttonportfolio3 mt10 pt10 pb10 pl40">
							<b class="float-left bold-text">Sign up with Google </b></button> -->
    </p>
        
        <p class="pb20 text-primary text-center" style="clear:both;">Already have an account yet? <a href="login.jsp"><b>Login Now</b></a></small></p>
        </form>

      </div>

      </div>
    <div class="col-md-5 card m0 p0 bg-primary borderradiusround nobordertopleft noborderbottomleft othersection noborder">
      <div class="card-body borderradiusround nobordertopleft noborderbottomleft p10 pt20 pb5 robotcontainer2 text-center">
<a class="navbar-brand text-center logohome" href="./">
				
				</a>
</div>
    </div>

  </div>
</div>

</body>
</html>
