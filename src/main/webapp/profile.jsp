<%@page import="authentication.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.File"%>
<%
	Object email = (null == session.getAttribute("email")) ? "" : session.getAttribute("email");

	/* if (email == null || email == "") {
		response.sendRedirect("index.jsp");
	} */
	
	/* System.out.println("EMAIL -- "+email); */
	
	ArrayList<?> userinfo = null;
	String profileimage = "";
	String username = "";
	String name = "";
	String phone = "";
	String date_modified = "";

	userinfo = new DbConnection().query("SELECT * FROM usercredentials where Email = '" + email + "'");
	
	/* System.out.println("USERINFO -- "+userinfo); */
	
	if (userinfo.size() < 1) {
		response.sendRedirect("index.jsp");
	} else {
		userinfo = (ArrayList<?>) userinfo.get(0);
		
		try {
			
			username = (null == userinfo.get(0)) ? "" : userinfo.get(0).toString();

			name = (null == userinfo.get(4)) ? "" : (userinfo.get(4).toString());
			email = (null == userinfo.get(2)) ? "" : userinfo.get(2).toString();
			phone = (null == userinfo.get(6)) ? "" : userinfo.get(6).toString();
			//date_modified = userinfo.get(11).toString();

			String userpic = (null == userinfo.get(9)) ? "" : userinfo.get(9).toString();
			System.out.println("USERINFO1 -- "+userinfo);
			String path = application.getRealPath("/").replace('\\', '/') + "images/profile_images/";
			
			String filename = (null == userinfo.get(9)) ? "" : userinfo.get(9).toString();

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
			
		} catch (Exception e) {
			e.printStackTrace(); 
			System.out.println(e);
		}

		String[] user_name = name.split(" ");
		//pimage = pimage.replace("build/", "");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Blogtrackers - Profile</title>
<link rel="shortcut icon" href="images/favicons/favicon-48x48.png">
<link rel="apple-touch-icon" href="images/favicons/favicon-48x48.png">
<link rel="apple-touch-icon" sizes="96x96"
	href="images/favicons/favicon-96x96.png">
<link rel="apple-touch-icon" sizes="144x144"
	href="images/favicons/favicon-144x144.png">
<!-- start of bootsrap -->
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


<link rel="stylesheet" href="assets/css/toastr.css">
<!--end of bootsrap -->
<script src="assets/js/jquery.min.js"></script>
<script src="assets/js/popper.min.js"></script>

<!-- JavaScript to be reviewed thouroughly by me -->
<script type="text/javascript" src="assets/js/validate.min.js"></script>
<script type="text/javascript" src="assets/js/uniform.min.js"></script>

<script type="text/javascript" src="assets/js/toastr.js"></script>

<!-- Base URL  -->
<script src="pagedependencies/baseurl.js">
	
</script>
<script src="pagedependencies/googletagmanagerscript.js"></script>
</head>
<body>
	<%@include file="subpages/loader.jsp"%>
	<%@include file="subpages/googletagmanagernoscript.jsp"%>
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
						<h6 class="text-primary m0 bolder profiletext myname"><%=name%></h6>
						<p class="text-primary profiletext myemail"><%=email%></p>
					</div>

				</div>
				<div id="othersection" class="col-md-12 mt10" style="clear: both">
					<%-- <a class="cursor-pointer profilemenulink" href="<%=request.getContextPath()%>/notifications.jsp"><h6 class="text-primary">Notifications <b id="notificationcount" class="cursor-pointer">12</b></h6> </a>
  --%>
					<a class="cursor-pointer profilemenulink"
						href="<%=request.getContextPath()%>/addblog.jsp"><h6
							class="text-primary">Add Blog</h6></a> <a
						class="cursor-pointer profilemenulink"
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

			<div
				class="navbar-header d-none d-lg-inline-flex d-xl-inline-flex  col-lg-3">
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
						data-toggle="dropdown"> <!-- <i class="fas fa-circle"
							id="notificationcolor"> --></i> <img src="<%=profileimage%>"
							width="50" height="50"
							onerror="this.src='images/default-avatar.png'" alt="" class="" />
							<span class="myname"><%=user_name[0]%></span> <!-- <ul class="profilemenu dropdown-menu dropdown-menu-left">
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
		<div class="profilenavbar" style="visibility: hidden;">></div>
		<!-- <div class="col-md-12 mt0">
      <input type="search" class="form-control p30 pt5 pb5 icon-big border-none bottom-border text-center blogbrowsersearch nobackground" placeholder="Search Trackers" />
      </div> -->

	</nav>
	<div class="container">


		<div class="row mt10">

			<div class="col-md-12 text-center">
				<form class="form-horizontal" id="image-form" name="upload_form"
					enctype="multipart/form-data" action="" method="POST">

					<div class="custom-file profileimgupload">
						<input type="file" name="userfile" accept="image/*"
							class="custom-file-input" id="customFileLang" lang="es">
						<label class="custom-file-label" for="customFileLang"> <img
							class="rounded mx-auto d-block profilepageimg"
							src="<%=profileimage%>?v=6"
							onerror="this.src='images/default-avatar.png'" width="150"
							height="150" alt="" />
						</label>
					</div>

					<!--  <button type="submit" class="btn btn-primary profilebtn" >Submit</button> -->
				</form>

				<form class="">
					<div class="mt10 form-group col-md-12 ">
						<input
							class="text-center mt20 mb0 text-primary super-bold-text fullname inputnobg profileinput"
							name="name" type="text" id="fullname" readonly value="<%=name%>" />
					</div>
					<!-- <h6 class="text-center text-primary mb0 pb10">Email: adekunleadigun@yahoo.com</h6> -->
					<div class="mb0 pb10 form-group  col-md-12">
						<label class="text-center text-primary mb0 labelprofile">Email:
							&nbsp;</label><input
							class="mt0 mb0 text-primary inputnobg inputprofile profileinput"
							type="email" name="Email" id="email" readonly value="<%=email%>" />
					</div>
					<div class="mb0 pb10 form-group  col-md-12">
						<label class="text-center text-primary mb0 labelprofile">Phone:
							&nbsp;</label><input
							class="mt0 mb0 text-primary inputnobg inputprofile profileinput"
							type="text" name="phone" id="phone" readonly value="<%=phone%>" />
					</div>
					<!-- <h6 class="text-center text-primary mb0 pb10">Phone: +1-512-567-2783</h6> -->
					<p class="text-center">
						<button class="btn btn-primary stylebutton2" id="changepassword">
							Change Password <i class="fas fa-lock"></i>
						</button>
					</p>
					<div class="passwordsection">
						<div class="mb0 pb10">
							<label class="text-center text-primary mb0 labelprofile">Old
								Password: &nbsp;</label><input
								class="mt0 mb0 text-primary inputnobg inputprofile passinput"
								type="password" id="password" readonly value="" />
						</div>
						<div class="mb0 pb10">
							<label class="text-center text-primary mb0 labelprofile"
								name="Password">New Password: &nbsp;</label><input
								class="mt0 mb0 text-primary inputnobg inputprofile passinput"
								type="password" id="newpassword" readonly value="" />
						</div>
						<div class="mb0 pb10">
							<label class="text-center text-primary mb0 labelprofile">Confirm
								Password: &nbsp;</label><input
								class="mt0 mb0 text-primary inputnobg inputprofile passinput"
								type="password" id="confirmpassword" readonly value="" />
						</div>
					</div>
			</div>
		</div>

		<div class="text-center mt50 mb50">
			<button type="button" class="btn btn-primary profilebtn"
				id="editaccount">Edit Account</button>
			&nbsp;&nbsp;
			<button class="btn btn-danger profilebtn" id="deleteaccount">Delete
				Account</button>
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



	<script src="pagedependencies/profile.js?v=799089809999901">
		
	</script>
	<!--end for table  -->


	<script src="assets/js/generic.js">
		
	</script>
	<script>
		$(document).ready(function() {

			$("#customFileLang").change(function(event) {

				event.preventDefault();

				var form = $('#image-form')[0];

				var data = new FormData(form);

				$.ajax({
					type : "POST",
					url : "FileUploads",
					data : data,
					processData : false,
					contentType : false,

					//cache: false,
					//timeout: 600000,
					success : function(data) {

						console.log("TYPE : ", data);

					},
					error : function(e) {

						//$("#result").text(e.responseText);
						console.log("ERROR : ", e);
						//$(".submitbtn").prop("disabled", false);

					}
				});

			});

		});
	</script>

</body>
</html>
<% } %>
