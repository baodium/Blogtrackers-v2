<%@page import="authentication.*"%>
<%
	Object email = (null == session.getAttribute("email")) ? "" : session.getAttribute("email");
	Object success_message = (null == session.getAttribute("success_message")) ? "" : "";
	if (email != null && email != "") {
		System.out.println("email is "+ email);
	}
%>

<html>
<head>API test for Mike
</head>

<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Blogtrackers - Login</title>
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
<script src="pagedependencies/baseurl.js"></script>
<script type="text/javascript" src="js/request.js?v=97"></script>
<body>
	<form id="request_form" class="" method="post">
		<div>
			<input type="email" id="username" placeholder="Email"> 
			<input type="password" id="password" placeholder="Password">
			<button type="submit" class="btn btn-primary loginformbutton mt10 bold-text" style="background: #28a745;">Login</button>
		</div>
		
		<div>
		
		<p><%=email%> is logged in</p>
		
		<p>His trackers</p>
		
		
		</div>
	</form>
</body>
</html>