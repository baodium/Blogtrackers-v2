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
	//response.sendRedirect("login.jsp");
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
	<title>Blogtrackers - Edit Tracker</title>
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

<script src="assets/js/popper.min.js" ></script>


</head>
<body style="background-color:#ffffff;">
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

          <div class="navbar-header d-none d-lg-inline-flex d-xl-inline-flex col-lg-3">
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

         

        </nav>
        
<div class="container mb50">


<div class="row m50 mt40">
<div class="col-md-9">
<h1 class="text-primary edittrackertitle mb0" style="">Middle East Tracker</h1>
<p><button class="btn metadata text-primary mt10">Created  |  22-07-2018 . 05:30pm</button> <button class="btn metadata text-primary mt10">Modified |  22-07-2018 . 05:30pm</button> <button class="btn metadata text-primary mt10">Crawled |  22-07-2018 . 05:30pm</button></p>
</div>
<div class="col-md-3 text-right pt10">
<button class="btn btn-rounded iconedittrackerpage"><i title="Proceed to Analytics" data-toggle="tooltip" data-placement="top" class="proceedtoanalytics icon-small text-primary"></i></button>
<button class="btn btn-rounded iconedittrackerpage"><i title="Edit Tracker" data-toggle="tooltip" data-placement="top" class="edittracker icon-small text-primary"></i></button>
<button class="btn btn-rounded iconedittrackerpage"><i title="Refresh Tracker" data-toggle="tooltip" data-placement="top" class="refreshtracker icon-small text-primary"></i></button>
<button class="btn btn-rounded iconedittrackerpage"><i title="Delete Tracker" data-toggle="tooltip" data-placement="top" class="deletetracker icon-small text-primary"></i></button>
</div>

<div class="col-md-12 trackerdescription">
<p>National Public Radio is an American privately and publicly funded non-profit membership media organization based in Washington DC. It serves as a national syndicator to a network of over 1,000 public radio stations in the United States.</p>
</div>

<div class="col-md-12">
<div class="float-left statcontainer">
<b class="stattext">334K</b>
<h6 class="text-primary labeltext">Blogs</h6>
</div>
<div class="float-left statcontainer">
<b class="stattext">43M</b>
<h6 class="text-primary labeltext">Posts</h6>
</div>

<div class="float-left statcontainer">
<b class="stattext">11B</b>
<h6 class="text-primary labeltext">Comments</h6>
</div>
</div>

<div class="col-md-12 mt30">
<form class="form-inline">
<div class="input-group col-md-10" style="padding-left:0 !important;">
<i class="searchiconinputblog cursor-pointer" aria-hidden="true"></i>
<input class="form-control searchblogsites text-primary" placeholder="Search Blogs" type="text" />

</div>
 <select class="form-control col-md-2 allthistracker text-primary" size="1">
 <option>This</option>
 <option>All</option>
 </select>
 </form>
 
</div>

<div class="col-md-12 mt10 mb50">

<div class="form-control btn styleallblog selectallblog text-left text-primary">
<div class="checkblogleft">
<i class="navbar-brand text-primary icontrackersize checkallblog cursor-pointer" data-toggle="tooltip" data-placement="top" title="Select All Blog"></i>
</div>
13,192 Items 
<div class="selectsets">
 <select class="form-control sortby text-primary">
 <option>Recent</option>

 </select>
</div>
</div>

<div id="bloglist">
<div class="form-control btn generalstyle btndefaultlook edittrackerblogindividual text-left text-primary">
<div class="checkblogleft">
<i class="navbar-brand text-primary icontrackersize checkuncheckblog cursor-pointer uncheckblog" data-toggle="tooltip" data-placement="top" title="Select Blog"></i>
</div>
National Public Radio 
<div class="iconsetblogs">
<div class="setoficons float-left makeinvisible">
<i class="navbar-brand text-primary icontrackersize cursor-pointer proceedtoanalytics" data-toggle="tooltip" data-placement="top" title="Proceed to Analytics"></i>
<i class="text-primary icontrackersize cursor-pointer refreshblog" data-toggle="tooltip" data-action="reload" data-placement="top" title="Refresh Blog"></i>
<i class="text-primary icontrackersize cursor-pointer deleteblog" data-toggle="tooltip" data-placement="top" title="Delete Blog"></i>
</div>
<i class="text-primary icontrackersize cursor-pointer trackblogindividual trackbloggrey" data-toggle="tooltip" data-placement="top" title="Track Blog"></i>
</div>
</div>

<div class="form-control btn generalstyle btndefaultlook edittrackerblogindividual text-left text-primary">
<div class="checkblogleft">
<i class="navbar-brand text-primary icontrackersize checkuncheckblog cursor-pointer uncheckblog" data-toggle="tooltip" data-placement="top" title="Select Blog"></i>
</div>
Engadget
<div class="iconsetblogs ">
<div class="setoficons float-left makeinvisible">
<i class="navbar-brand text-primary icontrackersize cursor-pointer proceedtoanalytics" data-toggle="tooltip" data-placement="top" title="Proceed to Analytics"></i>
<i class="text-primary icontrackersize cursor-pointer refreshblog" data-toggle="tooltip" data-action="reload" data-placement="top" title="Refresh Blog"></i>
<i class="text-primary icontrackersize cursor-pointer deleteblog" data-toggle="tooltip" data-placement="top" title="Delete Blog"></i>
</div>
<i class="text-primary icontrackersize cursor-pointer trackblogindividual trackbloggrey" data-toggle="tooltip" data-placement="top" title="Track Blog"></i>
</div>
</div>

<div class="form-control btn generalstyle btndefaultlook edittrackerblogindividual text-left text-primary">
<div class="checkblogleft">
<i class="navbar-brand text-primary icontrackersize checkuncheckblog cursor-pointer uncheckblog" data-toggle="tooltip" data-placement="top" title="Select Blog"></i>
</div>
TechCrunch
<div class="iconsetblogs">
<div class="setoficons float-left  makeinvisible">
<i class="navbar-brand text-primary icontrackersize cursor-pointer proceedtoanalytics" data-toggle="tooltip" data-placement="top" title="Proceed to Analytics"></i>
<i class="text-primary icontrackersize cursor-pointer refreshblog" data-toggle="tooltip" data-action="reload" data-placement="top" title="Refresh Blog"></i>
<i class="text-primary icontrackersize cursor-pointer deleteblog" data-toggle="tooltip" data-placement="top" title="Delete Blog"></i>
</div>
<i class="text-primary icontrackersize cursor-pointer trackblogindividual trackbloggrey" data-toggle="tooltip" data-placement="top" title="Track Blog"></i>
</div>
</div>

<div class="form-control btn generalstyle btndefaultlook edittrackerblogindividual text-left text-primary">
<div class="checkblogleft">
<i class="navbar-brand text-primary icontrackersize checkuncheckblog cursor-pointer uncheckblog" data-toggle="tooltip" data-placement="top" title="Select Blog"></i>
</div>
CNET
<div class="iconsetblogs">
<div class="setoficons float-left  makeinvisible">
<i class="navbar-brand text-primary icontrackersize cursor-pointer proceedtoanalytics" data-toggle="tooltip" data-placement="top" title="Proceed to Analytics"></i>
<i class="text-primary icontrackersize cursor-pointer refreshblog" data-toggle="tooltip" data-action="reload" data-placement="top" title="Refresh Blog"></i>
<i class="text-primary icontrackersize cursor-pointer deleteblog" data-toggle="tooltip" data-placement="top" title="Delete Blog"></i>
</div>
<i class="text-primary icontrackersize cursor-pointer trackblogindividual trackbloggrey" data-toggle="tooltip" data-placement="top" title="Track Blog"></i>
</div>
</div>

<div class="form-control btn generalstyle btndefaultlook edittrackerblogindividual text-left text-primary">
<div class="checkblogleft">
<i class="navbar-brand text-primary icontrackersize checkuncheckblog cursor-pointer uncheckblog" data-toggle="tooltip" data-placement="top" title="Select Blog"></i>
</div>
Republic
<div class="iconsetblogs">
<div class="setoficons float-left  makeinvisible">
<i class="navbar-brand text-primary icontrackersize cursor-pointer proceedtoanalytics" data-toggle="tooltip" data-placement="top" title="Proceed to Analytics"></i>
<i class="text-primary icontrackersize cursor-pointer refreshblog" data-toggle="tooltip" data-action="reload" data-placement="top" title="Refresh Blog"></i>
<i class="text-primary icontrackersize cursor-pointer deleteblog" data-toggle="tooltip" data-placement="top" title="Delete Blog"></i>
</div>
<i class="text-primary icontrackersize cursor-pointer trackblogindividual trackbloggrey" data-toggle="tooltip" data-placement="top" title="Track Blog"></i>
</div>
</div>

<div class="form-control btn generalstyle btndefaultlook edittrackerblogindividual text-left text-primary">
<div class="checkblogleft">
<i class="navbar-brand text-primary icontrackersize checkuncheckblog cursor-pointer uncheckblog" data-toggle="tooltip" data-placement="top" title="Select Blog"></i>
</div>
Crooks and Liars
<div class="iconsetblogs">
<div class="setoficons float-left  makeinvisible">
<i class="navbar-brand text-primary icontrackersize cursor-pointer proceedtoanalytics" data-toggle="tooltip" data-placement="top" title="Proceed to Analytics"></i>
<i class="text-primary icontrackersize cursor-pointer refreshblog" data-toggle="tooltip" data-action="reload" data-placement="top" title="Refresh Blog"></i>
<i class="text-primary icontrackersize cursor-pointer deleteblog" data-toggle="tooltip" data-placement="top" title="Delete Blog"></i>
</div>
<i class="text-primary icontrackersize cursor-pointer trackblogindividual trackbloggrey" data-toggle="tooltip" data-placement="top" title="Track Blog"></i>
</div>
</div>

<div class="form-control btn generalstyle btndefaultlook edittrackerblogindividual text-left text-primary">
<div class="checkblogleft">
<i class="navbar-brand text-primary icontrackersize checkuncheckblog cursor-pointer uncheckblog" data-toggle="tooltip" data-placement="top" title="Select Blog"></i>
</div>
Crooks and Liars
<div class="iconsetblogs">
<div class="setoficons float-left  makeinvisible">
<i class="navbar-brand text-primary icontrackersize cursor-pointer proceedtoanalytics" data-toggle="tooltip" data-placement="top" title="Proceed to Analytics"></i>
<i class="text-primary icontrackersize cursor-pointer refreshblog" data-toggle="tooltip" data-action="reload" data-placement="top" title="Refresh Blog"></i>
<i class="text-primary icontrackersize cursor-pointer deleteblog" data-toggle="tooltip" data-placement="top" title="Delete Blog"></i>
</div>
<i class="text-primary icontrackersize cursor-pointer trackblogindividual trackbloggrey" data-toggle="tooltip" data-placement="top" title="Track Blog"></i>
</div>
</div>

<div class="form-control btn generalstyle btndefaultlook edittrackerblogindividual text-left text-primary">
<div class="checkblogleft">
<i class="navbar-brand text-primary icontrackersize checkuncheckblog cursor-pointer uncheckblog" data-toggle="tooltip" data-placement="top" title="Select Blog"></i>
</div>
Adekunle Blog
<div class="iconsetblogs">
<div class="setoficons float-left makeinvisible">
<i class="navbar-brand text-primary icontrackersize cursor-pointer proceedtoanalytics" data-toggle="tooltip" data-placement="top" title="Proceed to Analytics"></i>
<i class="text-primary icontrackersize cursor-pointer refreshblog" data-toggle="tooltip" data-action="reload" data-placement="top" title="Refresh Blog"></i>
<i class="text-primary icontrackersize cursor-pointer deleteblog" data-toggle="tooltip" data-placement="top" title="Delete Blog"></i>
</div>
<i class="text-primary icontrackersize cursor-pointer trackblogindividual trackbloggrey" data-toggle="tooltip" data-placement="top" title="Track Blog"></i>
</div>
</div>

</div>

</div>

</div>









</div>


<div class="text-center pt10 pb10 trackingfixededittracker" style="background:#00B361;">
  <div class="container">
<div class="row" style="margin-left: 50px; margin-right:50px;">  <p  class="mb0 text-white fixedbottomedittrackerlefttext float-left text-left">22 item(s) selected</p>
  <p class="mb0 float-left fixedbottomedittrackerrighttext text-right" >
    <i title="Track Blog Selected" data-toggle="tooltip" data-placement="top"  class="trackblogiconedittrackerwhite icon-small text-primary cursor-pointer"></i>
    <i title="Disable Tracking" data-toggle="tooltip" data-placement="top"  class="disabletrackwhite icon-small text-primary cursor-pointer"></i>
    <i title="Refresh Selected Blog" data-toggle="tooltip" data-placement="top"  class="refreshtrackerwhite icon-small text-primary cursor-pointer"></i>
    <i title="Delete Selected Blog" data-toggle="tooltip" data-placement="top"  class="deleteblogwhite icon-small text-primary cursor-pointer"></i>
  </p>
</div>

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
<script type="text/javascript" src="assets/js/toastr.js"></script>

<script src="assets/js/generic.js">
</script>
<script src="pagedependencies/edittrackerpage.js">
</script>
<script>
$(document).ready(function() {
	  $(function () {
	    $('[data-toggle="tooltip"]').tooltip()
	  })
});
</script>

</body>
</html>
