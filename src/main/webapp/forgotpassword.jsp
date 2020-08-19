<%@page import="authentication.*"%>
<%@page import="java.util.*"%>
<%

	Object email = (null == session.getAttribute("email")) ? "" : session.getAttribute("email");
	Object error_message = (null == session.getAttribute("error_message")) ? "" : session.getAttribute("error_message");
	Object success_message = (null == session.getAttribute("success_message")) ? "" : session.getAttribute("success_message");
	String p = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();

	
	String previous_page = request.getHeader("referer").toString();
	String [] prev_page_split = previous_page.split("/");
	if(!prev_page_split[prev_page_split.length -1].equals("forgotpassword.jsp")){
		error_message =  "";
		success_message = "";
	}
	System.out.println(prev_page_split[prev_page_split.length -1]);
	
	System.out.println("FORGOT--" + request.getHeader("referer"));
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Blogtrackers - Forgot Password</title>
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
  
  
<script type="text/javascript" src="js/login_validation.js?v=909090"></script>

</head>
<script src="pagedependencies/googletagmanagerscript.js"></script>
<body class="bgwhite">

	<nav class="navbar navbar-inverse bg-primary">
		<div class="container-fluid">

			<div class="navbar-header col-md-12 text-center">
				<a class="navbar-brand text-center logohome" href="./">
  </a>
			</div>

		</div>
	</nav>
	
	<div class="loginbox">
		<div class="row d-flex align-items-stretch">
			<div		class="col-md-12 card m0 p0 borderradiusround">
				 <% if(success_message.equals("")){ %>
				<div
					class="card-body p40 pt40 pb40 borderradiusround "
					style="background-color: #f4f5f6;">
					<p class="text-primary mb30" style="font-size: 28px;">
						Forgot Password?</b>
					</p>
					
					<form id="password_form"  class="form-validate" action="<%=request.getContextPath()%>/forgotpassword"  method="post">
						<div class="form-group">
							<div class="form-login-error">
							
                                <p id="error_message-box" style="color:red"><%=(error_message!="")?error_message:""%></p>
							</div>
							<input type="email"
								class="form-control curved-form-login text-primary"
								 id="username" required="required" name="email" required aria-describedby="emailHelp"
								placeholder="Provide  your email">
						</div>
						<br />
						
						<div class=""  id="loggin">
							<button type="submit" name="recover" value="yes" class="btn btn-primary loginformbutton"
								style="background: #28a745;">Submit</button> <a href="<%=request.getContextPath()%>/login.jsp"> Back to login? </a></small>				
 						</div> 			
						
					</form>
					
				</div>
				 <% }else{ %>
						<div class="panel panel-body login-form pb10">
						<div class="text-center">
							<div class="icon-object border-warning text-warning"><i class="icon-spinner11"></i></div>
							<h5 class="content-group pt20"><%=success_message%></h5>
						</div>
						
						<a href="<%=request.getContextPath()%>/ChangePassword.jsp" class="btn bg-blue-400 btn-block">Click here to proceed <i class="icon-arrow-left52 position-right"></i></a>
                                </div>
                                
                <% } %>
			</div>
			<!-- <div class="col-md-4 card m0 p0 bg-primary borderradiusround nobordertopleft noborderbottomleft othersection">
				<div
					class="card-body borderradiusround nobordertopleft noborderbottomleft p10 pt20 pb5 ">

				</div>
			</div> -->

		</div>
	</div>

</body>
<script>
<% if(!success_message.equals("")){ 
	 /* session.invalidate();   */
	 System.out.println(session.getId());
	/* response.sendRedirect("profile.jsp");  */
	%>
<%-- alert("<%=success_message%>") --%>
toastr.success('<%=success_message%>','Success','hideDuration:10000');
<%} else if(!error_message.equals("")) {%>
//alert('this is you2')
toastr.error('<%=error_message%>','Error','hideDuration:10000');
<%}%>
$(document).ready(function () {
	email = $('#email').val();
})

</script>
</html>
