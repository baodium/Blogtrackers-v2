<%@page import="authentication.*"%>
<%@page import="java.util.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.File"%>
<%@page import="util.Blogposts"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.json.JSONObject"%>
<%
Object email = (null == session.getAttribute("email")) ? "" : session.getAttribute("email");

if (email == null || email == "") {
	response.sendRedirect("index.jsp");
}else{

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

Blogposts post  = new Blogposts();
String term =  (null == request.getParameter("term")) ? "" : request.getParameter("term");
ArrayList results = null;
if(term.equals("")){
	results = post._list("DESC","");
}else{
	results = post._search(term,"");
}
String total = post._getTotal();
//pimage = pimage.replace("build/", "");
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
  
<link rel="stylesheet" href="assets/css/toastr.css">
<!--end of bootsrap -->
<script src="assets/js/jquery.min.js"></script>
<script src="assets/js/popper.min.js" ></script>
  <script>
  <!-- update system url here -->
  var app_url = "http://localhost:8080/Blogtrackers/";
  </script>
</head>
<body >
<div class="modal-notifications">
<div class="row">
  <div class="offset-lg-9 col-lg-3 col-md-12 notificationpanel">
    <div id="closeicon" class="cursor-pointer"><i class="fas fa-times-circle"></i></div>
  <div class="profilesection col-md-12 mt50">
    <img src="<%=profileimage%>" width="60" height="60" onerror="this.src='images/default-avatar.png'" alt="" class="float-left" />
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
	   <div class="col-md-12 mt0">
      <form name="serach-form" method="post" action=""><input type="search" name="term" class="form-control p30 pt5 pb5 icon-big border-none bottom-border text-center blogbrowsersearch nobackground" placeholder="Search Posts" /></form>
      </div>

    </nav>
	
	
<div class="container">


<div class="row mt50">
<div class="col-md-12 ">
<% if(!term.equals("")){ %>
<h6 class="float-left text-primary"><%=total%> posts found for "<%=term%>"</h6>
<%}else{%>
<h6 class="float-left text-primary"><%=total%> posts in our knowledge database</h6>

<%}%>
<h6 class="float-right text-primary">Recent <i class="fas fa-chevron-down"></i><h6/>
</div>
</div>


<div class="card-columns pt0 pb10  mt20 mb50 " id="appendee">

<% if(results.size()>0){
		for(int i=0; i< results.size(); i++){
			String res = results.get(i).toString();
			
			JSONObject resp = new JSONObject(res);
		    String resu = resp.get("_source").toString();
		     JSONObject obj = new JSONObject(resu);
		     
		     String pst = obj.get("post").toString();
		     if(pst.length()>120){
		    	 pst = pst.substring(0,120);
		     }
			
%>
<div class="card noborder curved-card mb30" >
<div class="text-center"><i class="fas text-medium pt40 fa-check text-light-color icon-big2 cursor-pointer" title="Select to Track Blog"></i></div>
<h4 class="text-primary text-center pt20"><a href="<%=request.getContextPath()%>/blogpostpage.jsp?p=<%=obj.getString("blogpost_id")%>"><%=obj.getString("title") %></a></h4>
<div class="text-center"><button class="btn btn-primary stylebutton3">TRACKING</button> <button class="btn btn-primary stylebutton2">0 Tracks</button></div>
  <div class="card-body">
    <a href="<%=request.getContextPath()%>/blogpostpage.jsp?p=<%=obj.getString("blogpost_id")%>"><h4 class="card-title text-primary text-center pb20"><%=pst+"..."%></h4></a>
    <p class="card-text text-center author mb0 light-text"><%=obj.getString("blogger") %></p>
    <p class="card-text text-center postdate light-text"><%=obj.getString("date") %></p>
  </div>
  <img class="postimage card-img-top pt30 pb30" id="<%=obj.getString("blogpost_id")%>" src="https://i.pinimg.com/736x/31/74/48/3174480c49cee70bd03627255f136b83--fat-girls-girls-hbo.jpg" onerror="this.src'https://i.pinimg.com/736x/31/74/48/3174480c49cee70bd03627255f136b83--fat-girls-girls-hbo.jpg'" alt="<%=obj.getString("permalink") %>">
  <div class="text-center"><i class="far fa-heart text-medium pb30  light-text icon-big"></i></div>
</div>

<% }
}else{ %>

<div >No post found</div>


<% } %>
</div>

<% if(results.size()>0){ %>
<div class="loadmoreimg" id="loading-img" style="text-align:center"><img src='images/preloader.gif' /><br/></div>	
<% } %>






</div>

<form name="page_form" id="page_form" method="post" action="">
    <input type="hidden" id="page_id" name="page_id" value="0" />
	<input type="hidden" name="negative_page" id="negative_page" value="1" />
	<input type="hidden" id="hasmore" name="hasmore" value="1" />
	<input type="hidden" id="current_page" name="current_page" value="blogbrowser" />
	<input type="hidden" id="term" name="term" value="<%=term%>" />
 </form>



<!-- <footer class="footer">
  <div class="container-fluid bg-primary mt60">
<p class="text-center text-medium pt10 pb10 mb0">Copyright &copy; Blogtrackers 2017 All Rights Reserved.</p>
</div>
  </footer> -->


<script type="text/javascript" src="assets/js/jquery-1.11.3.min.js"></script>
<script src="assets/bootstrap/js/bootstrap.js">
</script>

<!--end for table  -->


<script src="assets/js/generic.js">

</script>

<script src="pagedependencies/imageloader.js?v=8789898"></script>
<script src="js/functions.js?v=90"></script>
<script>
$(window).scroll(function() {
	if($(window).scrollTop() + $(window).height() > $(document).height() - 200) {
		loadMoreResult();
	}
});

</script>
</body>
</html>
<% }} %>