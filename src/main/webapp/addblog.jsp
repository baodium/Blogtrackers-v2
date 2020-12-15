<%@page import="javax.servlet.jsp.tagext.TryCatchFinally"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@page import="org.json.JSONArray"%>
<%@page import="authentication.*"%>
<%@page import="util.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.File"%>
<%@page import="util.Blogposts"%>
<%@page import="util.FileUpload"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>

<%
	Object email = (null == session.getAttribute("email")) ? "" : session.getAttribute("email");
String userid = (null == session.getAttribute("username")) ? "" : session.getAttribute("username").toString();

ArrayList<?> userinfo = new ArrayList();
String profileimage = "";
String username = "";
String name = "";
String phone = "";
String date_modified = "";

Weblog new_blog = new Weblog();
ArrayList results_blogadded = null;

userinfo = new DbConnection().query("SELECT * FROM usercredentials where Email = '" + email + "'");
if (userinfo.size() < 1) {
	response.sendRedirect("login.jsp");
} else {
	userinfo = (ArrayList<?>) userinfo.get(0);
	try {
		username = (null == userinfo.get(0)) ? "" : userinfo.get(0).toString();

		name = (null == userinfo.get(4)) ? "" : (userinfo.get(4).toString());

		email = (null == userinfo.get(2)) ? "" : userinfo.get(2).toString();
		phone = (null == userinfo.get(6)) ? "" : userinfo.get(6).toString();

		String userpic = userinfo.get(9).toString();
		String[] user_name = name.split(" ");
		username = user_name[0];

		String path = application.getRealPath("/").replace('\\', '/') + "images/profile_images/";
		String filename = userinfo.get(9).toString();

		profileimage = "images/default-avatar.png";
		if (userpic.indexOf("http") > -1) {
	profileimage = userpic;
		}

		File f = new File(filename);
		File path_new = new File(application.getRealPath("/").replace('/', '/') + "images/profile_images");
		if (f.exists() && !f.isDirectory()) {
	profileimage = "images/profile_images/" + userinfo.get(2).toString() + ".jpg";
		} else {
	path_new.mkdirs();
	System.out.println("pathhhhh1--" + path_new);
	profileimage = "images/default-avatar.png";
		}

		if (path_new.exists()) {

	String t = "/images/profile_images";
	int p = userpic.indexOf(t);
	System.out.println(p);
	if (p != -1) {

		System.out.println("pic path---" + userpic);
		System.out.println("path exists---" + userpic.substring(0, p));
		String path_update = userpic.substring(0, p);
		if (!path_update.equals(path_new.toString())) {
			profileimage = "images/profile_images/" + userinfo.get(2).toString() + ".jpg";
			String new_file_path = path_new.toString().replace("\\images\\profile_images", "") + "/"
					+ profileimage;
			System.out.println("ready to be updated--" + new_file_path);
		}
	} else {
		path_new.mkdirs();
		profileimage = "images/profile_images/" + userinfo.get(2).toString() + ".jpg";
		String new_file_path = path_new.toString().replace("\\images\\profile_images", "") + "/" + profileimage;
		System.out.println("ready to be updated--" + new_file_path);

		new DbConnection()
				.updateTable("UPDATE usercredentials SET profile_picture  = '" + "images/profile_images/"
						+ userinfo.get(2).toString() + ".jpg" + "' WHERE Email = '" + email + "'");
		System.out.println("updated");
	}
		} else {
	profileimage = "images/default-avatar.png";
	System.out.println("path doesnt exist");
		}
	} catch (Exception e) {
	}

	String term = (null == request.getParameter("term")) ? "" : request.getParameter("term").toString();//.replaceAll("[^a-zA-Z]", " ");

	String results = "";
	String status = "pending";

	if (term.equals("")) {

	} else {
		results = new_blog._addBlog(userid, term, status);

	}
	results_blogadded = new_blog._fetchBlog(userid);
	System.out.println("userid--" + userid);
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Blogtrackers - Add New Blog to Track</title>
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
<script src="https://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>
<script src="assets/js/popper.min.js"></script>
<script src="pagedependencies/googletagmanagerscript.js"></script>
</head>
<body class="bgwhite">
	<%@include file="subpages/googletagmanagernoscript.jsp"%>
	<div class="modal-notifications">
		<div class="row">
			<div class="col-lg-10 closesection"></div>
			<div class="col-lg-2 col-md-12 notificationpanel">
				<div id="closeicon" class="cursor-pointer">
					<i class="fas fa-times-circle"></i>
				</div>
				<div class="profilesection col-md-12 mt50">
					<%
						if (userinfo.size() > 0) {
					%>
					<div class="text-center mb10">
						<img src="<%=profileimage%>" width="60" height="60"
							onerror="this.src='images/default-avatar.png'" alt="" />
					</div>
					<div class="text-center" style="margin-left: 0px;">
						<h6 class="text-primary m0 bolder profiletext"><%=name%></h6>
						<p class="text-primary profiletext"><%=email%></p>
					</div>
					<%
						}
					%>
				</div>
				<div id="othersection" class="col-md-12 mt10" style="clear: both">
					<%
						if (userinfo.size() > 0) {
					%>
					<a class="cursor-pointer profilemenulink"
						href="<%=request.getContextPath()%>/profile.jsp"><h6
							class="text-primary">Profile</h6></a> <a
						class="cursor-pointer profilemenulink"
						href="<%=request.getContextPath()%>/logout"><h6
							class="text-primary">Log Out</h6></a>
					<%
						} else {
					%>
					<a class="cursor-pointer profilemenulink"
						href="<%=request.getContextPath()%>/login"><h6
							class="text-primary">Login</h6></a>

					<%
						}
					%>
					<a class="cursor-pointer profilemenulink"
						href="https://addons.mozilla.org/en-US/firefox/addon/blogtrackers/"><h6
							class="text-primary">Plugin</h6></a>
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
				<%
					if (userinfo.size() > 0) {
				%>

				<ul class="nav navbar-nav" style="display: block;">
					<li class="dropdown dropdown-user cursor-pointer float-right">
						<a class="dropdown-toggle " id="profiletoggle"
						data-toggle="dropdown"> <!-- <i class="fas fa-circle"
							id="notificationcolor"> --> </i> <img src="<%=profileimage%>"
							width="50" height="50"
							onerror="this.src='images/default-avatar.png'" alt="" class="" />
							<span><%=username%></span></a>

					</li>
				</ul>
				<%
					} else {
				%>
				<ul class="nav main-menu2 float-right"
					style="display: inline-flex; display: -webkit-inline-flex; display: -mozkit-inline-flex;">

					<li class="cursor-pointer"><a href="login.jsp">Login</a></li>
				</ul>
				<%
					}
				%>
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
	</nav>
	<div class="container">

		<div class="col-lg-12 col-md-12 pt0 pb10  mt10 mb10 notification">


		</div>



		<div class="col-lg-12 col-md-12 pt0 pb10  mt10 mb10 notification ">
			<form enctype="multipart/form-data" id="file-form" name="blog_form"
				action="FileUploads" method="POST">
				<h1 class="text-primary addblogtitle">Add Blogs</h1>

				<div
					class="card noborder curved-card mb30 containerdropfile pt40 pb40 mt20 createblog ">
					<h5 class="text-primary text-center">Click here to add blog</h5>
					<div>
						<button type="button"
							class="offset-md-4 col-md-4 mt10 form-control text-primary bold-text cursor-pointer btn createtrackerbtn bgwhite addblogbtn">+</button>
					</div>
					<div class="offset-md-4 col-md-4 mt20">
						<a class="orcontainer pt10">or</a>
						<hr />
					</div>
					<h5 class="text-primary text-center">Drag in or choose a .txt
						file</h5>
					<input type="file" accept=".txt" id="selected_file"
						name="blog_file" class="offset-md-4 col-md-4 form-control"
						multiple />&nbsp;
					<button id="submit_blog" type="submit"
						class="hidden btn btn-success submitbtn">Submit</button>
				</div>

				<div
					class="card noborder curved-card mb30 containeraddblog pt60 pb60 mt20 hidesection">
					<div class="createblogsection">
						<h5 class="text-primary text-center mt20 mb20">Enter Blog's
							Name and URL</h5>

						<div class="form-group">
							<input
								class="form-control offset-md-2 col-md-8 col-md-2 blogtitle pt10 pb10 mb20"
								id="blog_name" type="text" placeholder="Enter Blog Name" />
						</div>
						<div class="form-group mt20">
							<input
								class=" form-control offset-md-2 col-md-8 col-md-2 blogurl pt10 pb10"
								id="blog_url" placeholder="http://example.com" type="url" />
						</div>
						<div class="text-center">
							<button type="button" class="btn text-primary cancelbtn">Cancel</button>
							&nbsp;
							<button id="create_blog" type="button"
								class="btn btn-success createbtn">Create</button>
						</div>
			</form>
		</div>
	</div>
	<div>
		<h2 class="text-primary addblogtitle bold-text">Blogs Added</h2>
		<div class="col-md-12 mt10 mb50 pl0 pr0">
			<!-- START TABLE -->
			<table class=" " id="bloglist" style="width: 100%">
				<thead>
					<tr>
						<th class="text-primay" style="text-align: center;">id</th>
						<th class="text-primay" style="text-align: center;">Blog Name</th>

						<th class="text-priary" style="text-align: center;">Status</th>
						<th class="text-priary" style="text-align: center;">No. of
							Posts</th>
						<th class="text-priary" style="text-align: center;">Latest
							Update</th>
						<th>Function</th>
					</tr>
				</thead>
				<tbody id="tbody">
					<%
						int k_count = 0;
					try {

						if (results_blogadded.size() > 0) {
							for (int k = 0; k < results_blogadded.size(); k++) {

						ArrayList blog = (ArrayList) results_blogadded.get(k);
						String total_post = "";
						String last_crawled = "";

						String id = (String) blog.get(0);
						String blogname = (String) blog.get(2);

						ArrayList results_blogs = null;

						/* ArrayList results_blogfinder = null;
						results_blogfinder = new_blog._fetchPipeline("https://tacticalinvestor.com/blog/");
						results_blogfinder = (ArrayList<?>) results_blogfinder.get(0); */

						/* ArrayList results_blogs.get(0); */
						try {

							results_blogs = new_blog._fetchCrawlerBlogs(blogname);
							results_blogs = (ArrayList<?>) results_blogs.get(0);
							total_post = (null == results_blogs.get(15)) ? "--" : (results_blogs.get(15).toString());
							last_crawled = (null == results_blogs.get(10)) ? "--" : (results_blogs.get(10).toString());
							System.out.println("blogs" + total_post);
						} catch (Exception e) {
							total_post = "--";
							last_crawled = "--";
						}

						String status = (String) blog.get(3);
						System.out.println("id--" + blog.get(0));
						String statusstyle = "";
						if (status.equalsIgnoreCase("crawled")) {
							statusstyle = "table-success";
						} else if (status.equalsIgnoreCase("crawling")) {
							statusstyle = "table-warning";
						} else if (status.equalsIgnoreCase("not_crawled")) {
							statusstyle = "table-info";
						} else if (status.equalsIgnoreCase("not_crawlable")) {
							statusstyle = "table-danger";
						} else {
							statusstyle = "defaultstatus";
						}

						//testing git
						String blogname1 = blogname;
						Integer maxSize = 28;
						if (blogname.length() > maxSize) {
							blogname = blogname.substring(0, maxSize);
							blogname = blogname + "....";

						} else {

						}
					%>

					<tr class="<%=statusstyle%>"
						style="width: 20%; word-wrap: break-word; text-align: center; vertical-align: middle;">
						<td class="text-left pl2 blogcount "
							style="word-wrap: break-word; text-align: center; vertical-align: middle;"><%=k + 1%></td>
						<%-- <td class="text-primary text-left nameofblog"><%=blogname%></td> --%>
						<td class="text-primary  nameofblog " data-toggle="tooltip"
							data-placement="top" title="<%=blogname1%>"
							style="width: 10%; word-wrap: break-word; text-align: center; vertical-align: middle;"><a
							href="<%=blogname%>" target="_blank"><%=blogname%></a></td>
						<td class="text-primary  blogstatus"
							style="width: 20%; word-wrap: break-word; text-align: center; vertical-align: middle;"><%=status%></td>
						<td class="text-primary "
							style="width: 20%; word-wrap: break-word; text-align: center; vertical-align: middle;"><%=total_post%></td>
						<td class="text-primary "
							style="width: 20%; word-wrap: break-word; text-align: center; vertical-align: middle;"><%=last_crawled%></td>
						<td><i
							class="text-primary icontrackersize cursor-pointer deleteblog text-center"
							data-toggle="tooltip" id="<%=blog.get(0)%>" data-placement="top"
							title="Delete Blog"></i></td>
						<%-- <td class="text-primary text-center"><i id="<%=k + 1%>"
						class="text-primary icontrackersize cursor-pointer deleteblog deletebtn text-center"
						onclick= "<%  %>"
						data-toggle="tooltip" data-placement="top" title="Delete Blog"></i></td> --%>
						<%-- <td class="text-center"><i class="text-primary icontrackersize cursor-pointer deleteblog text-center" onclick= "<% new_blog._deleteBlog(username, Integer.parseInt(id)); %>" data-toggle="tooltip" id="<%=id%>_select" data-placement="top" title="Delete Blog"></i></td> --%>
					</tr>

					<%
						k_count = k_count + 1;
					}
					}
					} catch (Exception e) {
					}
					%>
				</tbody>
			</table>

			<!-- END TABLE -->
		</div>
	</div>
	</div>
	</div>




	<script src="https://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>
	<script src="assets/bootstrap/js/bootstrap.js">
		
	</script>
	<script>
		$(document).ready(function () {
			

			$('#bloglist').DataTable({
		        
		          "pagingType": "simple",
		          "targets": 'no-sort',
		          "bSort": false
		        
		        	  
		     });

		
		});
	</script>
	<!--end for table  -->
	<script type="text/javascript"
		src="assets/vendors/DataTables/datatables.min.js"></script>
	<script type="text/javascript"
		src="assets/vendors/DataTables/dataTables.bootstrap4.min.js"></script>
	<script type="text/javascript" src="assets/js/toastr.js"></script>

	<script type="text/javascript" src="pagedependencies/baseurl.js"></script>
	<script src="assets/js/generic.js">
	
	 
		
	</script>
	<script src="pagedependencies/addblog.js?v=148906">
		
	</script>
	<script type="text/javascript">
	
	$(document).ready(function () {
		
		
		
		
	

	    $("#selected_file").change(function (event) {
	    	
	    	console.log("")

	        //stop submit the form, we will post it manually.
	        event.preventDefault();

	        // Get form
	        var form = $('#file-form')[0];

			// Create an FormData object 
	        var data = new FormData(form);

			// If you want to add an extra field for the FormData
	        //data.append("CustomField", "This is some extra data, testing");

			// disabled the submit button
			//$(".submitbtn").removeClass("hidden");
	        //$(".submitbtn").prop("disabled", true);
	        
				<%-- <tr class="<%%>">
					<td class="text-left pl0 blogcount"><%=k + 1%></td>
					<td class="text-primary text-left nameofblog"><%=std.get(k)%></td>
					<td class="text-primary text-left blogstatus">not_crawled</td>
					<td class="text-primary text-left"></td>
					<td class="text-primary text-left"></td>
					<td class="text-primary text-center"><i id="<%=k+1%>"
						class="text-primary icontrackersize cursor-pointer deleteblog deletebtn text-center"
						data-toggle="tooltip" data-placement="top" title="Delete Blog"></i></td>
					<td class="text-center"><i class="text-primary icontrackersize cursor-pointer deleteblog text-center" onclick= "<% new_blog._deleteBlog(username, Integer.parseInt(id)); %>" data-toggle="tooltip" id="<%=id%>_select" data-placement="top" title="Delete Blog"></i></td>
				</tr> --%>

	        $.ajax({
	            type: "POST",
	            enctype: 'multipart/form-data',
	            url: "FileUploads",
	            data: data,
	            processData: false,
	            contentType: false,
	            dataType: 'json',
	            //cache: false,
	            //timeout: 600000,
	            success: function (data) {
	            	$("#selected_file").val('')
	                //$("#result").text(data);
	                
	                console.log("DATA : ", data);
	                if("success" in data){	         
	                	var table_data =''
	                		"success" in data ? console.log('success_key exists') : console.log('unknown key')
	    	                for(var i = 0; i < data.success.url.length; i++){
	    	                	console.log(i)

	    	                	statusstyle = "";
	    	                	status=data.success.status[i]
	    						if (status=="crawled"){
	    							statusstyle = "table-success";
	    						} else if (status=="crawling") {
	    							statusstyle = "table-warning";
	    						}
	    						else if (status=="not_crawled") {
	    							statusstyle = "table-info";
	    						}
	    						else if (status=="not_crawlable") {
	    							statusstyle = "table-danger";
	    						}else {
	    							statusstyle = "defaultstatus";
	    						}
	    						
	    	                	
	    	                	table_data +="<tr class="+statusstyle+">"
	    	                	/* (null == userinfo.get(6)) ? "" : userinfo.get(6).toString(); */
	    	                	/* try{results_blogadded.size();}catch(Exception e){} */
	    	                	
	    	                	table_data +='<td>'+(<%=k_count%>+i+1)+'</td>'
	    	                	table_data +='<td>'+data.success.url[i]+'</td>'
	    	                	table_data +='<td>'+status+'</td>'
	    	                	table_data +='<td>'+'</td>'
	    	                	table_data +='<td>'+'</td>'
	    	                	table_data +='<td>'+'</td>'
	    	                	table_data +='</tr>'
	    	                	console.log(data[i]);
	    	                }
	                		$('#tbody').append(table_data); 
	                		location.reload();
	    					/* document.getElementById("tbody").appendChild(table_data); */
	                }
	                if("exists" in data){
	                	"exists" in data ? console.log('exists_key exists') : console.log('exists key not found')
	                	toastr.error('Blog already exists', 'Error','hideDuration:10000');
	                }
	                if("error" in data){
	                	"error" in data ? console.log('error_key exists') : console.log('error key not found')
	                	toastr.error('Invalid Blog URL', 'Invalid','hideDuration:10000');
	                }
	                //$(".submitbtn").prop("disabled", false);
	                
	            },
	            error: function (e) {

	                //$("#result").text(e.responseText);
	                console.log("ERROR : ", e);
	            }
	        });

	    });

	});
	<%-- <td><i class="text-primary icontrackersize cursor-pointer deleteblog text-center" data-toggle="tooltip" id="<%=blog.get(0)%>_select" data-placement="top" title="Delete Blog"></i></td> --%>
	$('.deleteblog').on("click",function(e){
		
		console.log( $(this).attr('id'))
			
	})

	</script>
</body>
</html>

