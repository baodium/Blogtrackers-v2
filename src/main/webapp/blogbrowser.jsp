<%@page import="authentication.*"%>
<%@page import="java.util.*"%>
<%@page import="util.*"%>
<%@page import="java.io.File"%>

<%@page import="util.*"%>
<%@page import="java.text.NumberFormat" %>
<%@page import="java.util.Locale" %>

<%@page import="java.util.ArrayList"%>
<%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
Object email = (null == session.getAttribute("email")) ? "" : session.getAttribute("email");

ArrayList<?> userinfo = new ArrayList();//null;
String profileimage= "";
String username ="";
String name="";
String phone="";
String firstname ="";
String date_modified = "";
JSONObject myblogs = new JSONObject();
ArrayList mytrackers = new ArrayList();
Trackers trackers  = new Trackers();
Blogs blogs  = new Blogs();

userinfo = DbConnection.query("SELECT * FROM usercredentials where Email = '"+email+"'");
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
myblogs = trackers.getMyTrackedBlogs(username);
mytrackers = trackers._list("DESC","",username,"100");
	
String userpic = userinfo.get(9).toString();
String[] names = name.split(" ");
firstname = names[0];

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



Blogposts post  = new Blogposts();
String term =  (null == request.getParameter("term")) ? "" : request.getParameter("term").toString();//.replaceAll("[^a-zA-Z]", " ");

String sort =  (null == request.getParameter("sortby")) ? "date" : request.getParameter("sortby").toString();

ArrayList results = null;

if(term.equals("")){
	results = post._list("DESC","0",sort);
}else{
	results = post._search(term,"0",sort);
}

String total = NumberFormat.getNumberInstance(Locale.US).format(Integer.parseInt(post._getTotal()));
//NumberFormat.getNumberInstance(Locale.US).format(Integer.parseInt(post._getTotal()));

//pimage = pimage.replace("build/", "");
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Blogtrackers - Blog Browser</title>
  <link rel="shortcut icon" href="images/favicons/favicon-48x48.png" />
  <link rel="apple-touch-icon" href="images/favicons/favicon-48x48.png">
  <link rel="apple-touch-icon" sizes="96x96" href="images/favicons/favicon-96x96.png">
  <link rel="apple-touch-icon" sizes="144x144" href="images/favicons/favicon-144x144.png">
  <!-- start of bootstrap -->
<link rel="stylesheet" href="https://cdn.linearicons.com/free/1.0.0/icon-font.min.css">
  <link href="assets/fonts/icomoon/styles.css" rel="stylesheet" type="text/css">
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
<style>
	.no-display{
		display:none;
		padding:10px;
	}
</style>
<!-- bootstrap  -->
  <link rel="stylesheet" href="assets/css/style.css" />
<link rel="stylesheet" href="assets/css/toastr.css" />
<!--end of bootsrap -->

<script src="assets/js/jquery.min.js"></script>
<script src="assets/js/popper.min.js" ></script>

<script type="text/javascript" src="assets/js/uniform.min.js"></script>
<script type="text/javascript" src="assets/js/toastr.js"></script>

  <script src="pagedependencies/baseurl.js">
  </script>
    <script src="pagedependencies/googletagmanagerscript.js"></script>
</head>
<body >
<%@include file="subpages/loader.jsp" %>
<%@include file="subpages/googletagmanagernoscript.jsp" %>
<%-- <%@ include file="templates/profilepanel.jsp" %> --%>

<div class="modal-notifications">
<div class="row">
<div class="col-lg-10 closesection">

	</div>
  <div class=" col-lg-2 col-md-12 notificationpanel">
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
  
  <%-- <a class="cursor-pointer profilemenulink" href="<%=request.getContextPath()%>/notifications.jsp"><h6 class="text-primary">Notifications <b id="notificationcount" class="cursor-pointer">12</b></h6> </a>
   --%> <a class="cursor-pointer profilemenulink" href="<%=request.getContextPath()%>/addblog.jsp"><h6 class="text-primary">Add Blog</h6></a>
  <a class="cursor-pointer profilemenulink" href="<%=request.getContextPath()%>/profile.jsp"><h6 class="text-primary">Profile</h6></a>
  <a
						class="cursor-pointer profilemenulink"
						href="https://addons.mozilla.org/en-US/firefox/addon/blogtrackers/"><h6
							class="text-primary">Plugin</h6></a>
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

      <div class="navbar-header d-none d-lg-inline-flex d-xl-inline-flex  col-lg-3">
      <a class="navbar-brand text-left logohomeothers" href="./">
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
		  <span ><%=firstname%></span></a>

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
<!-- <div class="profilenavbar" style="visibility:hidden;"></div> -->
	   <div class="col-md-12 mt0">

      <form method="search" method="post" autocomplete="off" action="<%=request.getContextPath()%>/blogbrowser.jsp">
      	<input type="search" autocomplete="off"  name="term" class="form-control p30 pt5 pb5 icon-big border-none bottom-border text-center blogbrowsersearch nobackground <% if(!term.equals("")){ %> whiteplaceholder <%} %>" <% if(!term.equals("")){ %> placeholder="Searching for <%=term%>" <% } else { %>placeholder="Search for a keyword"<% } %> />
      </form>
      </div>

    </nav>

<!-- <div class="text-center pt20 pb20 tracksection hidden" style="background:#ffffff;"><button type="submit" class="btn btn-success homebutton p50 pt10 pb10" id="initiatetrack"><b>Track</b> <b class="trackscount" id="trackscount">0</b> </button> <i style="font-size:30px;" class="cursor-pointer lnr lnr-cross float-right pr20 mt10" id="closetracks" data-toggle="tooltip" data-placement="top" title="Close"></i></div>
 -->
<div class="text-center pt20 pb20 tracksection hidden" style="background:#ffffff;"><button type="submit" class="btn btn-success homebutton p50 pt10 pb10" id="initiatetrack"><b>Track</b> <b id="trackscount">0</b> <b>Blog(s)</b></button> <i style="font-size:30px;" class="cursor-pointer lnr lnr-cross float-right pr20 mt10" id="closetracks" data-toggle="tooltip" data-placement="top" title="Close"></i></div>

<div class="text-center pt10 pb10 informationselectblogtotrack" style="background:#00B361;"><p class="mb0 text-white"><b>Select blogs to track</b></p> </div>

<div class="bg-success"></div>
<!-- Backdrop for modal -->
<div class="modalbackdrop hidden">

</div>
<div class="container-fluid hidden trackinitiated">

<!-- <div class="container-fluid"> -->
<div class="row bg-primary">
<input type="hidden" name="_selected" id="selected_blogs_" value="" />
<div class="offset-md-1 col-md-6 pl150 pt100 pb100">
<h1 class="text-white trackertitlesize"><b class="greentext total_selected">0</b> Blog(s)</h1>
<div class="mt30" id="selected_blog_list" style="overflow: auto; height: 400px;">
<!-- <button class="col-md-6 btn text-left text-white bold-text blogselection mt10 pt10 pb10">Engadget <i class="fas fa-trash float-right hidden deleteblog"></i></button> -->
</div>
</div>
<div class="col-md-5 pt100 pb100 pl50 pr50 bg-white">
<div class="trackcreationsection1">
<i class="cursor-pointer lnr lnr-cross float-right closedialog" data-toggle="tooltip" data-placement="top" title="Close Dialog"></i>
<h3 class="text-primary bold-text">Track the selected blogs using the following list of trackers: </h3>

<button class="col-md-10 mt30 form-control text-primary bold-text cursor-pointer btn createtrackerbtn">+</button>
<div class="trackerlist mt20" style="position: relative; overflow: auto; height: 250px;">
<%
ArrayList resut = new ArrayList();
if(mytrackers.size()>0){
	for(int i=0; i< mytrackers.size(); i++){
			resut = (ArrayList)mytrackers.get(i);				
%>
<button class="btn form-control col-md-10 text-primary text-left trackerindividual pt10 pb10 pl10 resetdefaultfocus bold-text" id="<%=resut.get(0).toString()%>"><%=resut.get(2).toString()%> <i class="fas fa-check float-right hidden checktracker"></i></button>
<% }
} %>
<!-- 
<button class="btn form-control col-md-10 text-primary text-left trackerindividual pt10 pb10 pl10 resetdefaultfocus bold-text">Technology <i class="fas fa-check float-right hidden checktracker"></i></button>
-->
</div>
<div class="col-md-12 mt20 text-primary">
<b class="selectedtrackercount text-primary">0</b> Tracker(s) selected
</div>
<br/><br/>
<div id="added-info" class="no-display"> <a href="trackerlist.jsp" style="text-decoration:underline">Go to trackerlist page</a>
</div>
</div>

<!-- tracker section for creatio of new  -->
<div class="trackcreationsection2 hidden">
<i class="cursor-pointer lnr lnr-cross float-right closedialog" data-toggle="tooltip" data-placement="top" title="" data-original-title="Close Dialog"></i>
<h1 class="text-primary">Create a Tracker</h1>
<input type="text" class="form-control trackerinput blogbrowsertrackername" placeholder="Title" />
<textarea placeholder="Description" class="form-control mt20 trackerdescription blogbrowsertrackerdescription" rows="8">
</textarea>
<div class="form-group mt20">
<!-- <input type="text" class="form-control tokenfield-primary" value="Engadget,National Public Radio,Crooks and Liars,Tech Crunch" />-->
</div>
<div class="mt30">
<button class="btn btn-default cancelbtn canceltrackercreation text-primary">Cancel</button> <button class=" btn btn-success trackercreatebutton">Create</button>
</div>

</div>

<!-- end   -->

</div>




</div>

</div>


<div class="container analyticscontainer">


<div class="row mt50">
<div class="col-md-12 ">
<% if(!term.equals("")){ %>
<h6 class="float-left text-primary bold-text"><%=total %> posts found for "<%=term%>"</h6>
<%}else{%>
<h6 class="float-left text-primary bold-text"><%=total %> posts in our knowledge database</h6>

<%}%>

<h6 class="float-right text-primary">
  <select class="text-primary filtersort sortby"  id="sortbyselect"><option value="date" <%=(sort.equals("date"))?"selected":"" %>>Recent</option><option <%=(sort.equals("influence_score"))?"selected":"" %> value="influence_score">Influence Score</option></select>
</h6>
<p class="float-right text-primary mr20"><i data-toggle="tooltip" data-placement="top" title="" data-original-title="List View" class="fas fa-bars cursor-pointer" id="listtoggle"></i> &nbsp;<i data-toggle="tooltip" data-placement="top" title="" data-original-title="Grid View" id="gridtoggle" class="fas fa-th cursor-pointer"></i></p>
</div>
</div>

<div class="col-md-12 p0 pt0 pb10  mt20 mb50 listlook hidden">
<table id="blogbrowser" style="width:100%">
     <thead>
      <tr>
        <td></td>
        <td><b>Blog Name</b></td>
        <td><b>Title</b></td>
        <td><b>Blogger</b></td>
        <td><b>Posted</b></td>
      </tr> 
     </thead> 
      <tbody id="appendee2">
<% 
if(results.size()>0){
	String res = null;
	JSONObject resp = null;
	String resu = null;
	JSONObject obj = null;
	int totalpost = 0;
	String bres = null;
	JSONObject bresp = null;
	String bresu =null;
	JSONObject bobj =null;
	

		for(int i=0; i< results.size(); i++){

			 String blogtitle="";		
			 res = results.get(i).toString();
			 resp = new JSONObject(res);
		     resu = resp.get("_source").toString();
		     obj = new JSONObject(resu);
		     String blogid = obj.get("blogsite_id").toString();
		     String[] dt = obj.get("date").toString().split("T");
		     

			
			 ArrayList blog = blogs._fetch(blogid); 
			 if( blog.size()>0){
						 bres = blog.get(0).toString();			
						 bresp = new JSONObject(bres);
						 bresu = bresp.get("_source").toString();
						 bobj = new JSONObject(bresu);
						 blogtitle = bobj.get("blogsite_name").toString();			 
			}
		     String totaltrack  = trackers.getTotalTrack(blogid);		     
%>      
        <tr class="curve_<%=blogid%>">
          <td class="noborderright borders-white"><i class="fas text-medium fa-check text-light-color icon-big2 cursor-pointer trackblog blog_id_<%=blogid%>" data-toggle="tooltip" data-placement="top"  title="Select to Track Blog"></i></td>
          <td class="noborderleft noborderright borders-white blogsitename"><h6 class="text-primary myposttitle"><a class="blogname-<%=blogid%>" href="<%=request.getContextPath()%>/blogpostpage.jsp?p=<%=obj.get("blogpost_id")%>">
          <%=blogtitle%></a></h6></td>
          <td class="noborderleft noborderright borders-white"><h6 class="text-primary"><a class="blogname-<%=blogid%>" href="<%=request.getContextPath()%>/blogpostpage.jsp?p=<%=obj.get("blogpost_id")%>">
          <%=obj.get("title").toString()%></a></h6></td>
          <td class="noborderleft noborderright borders-white"><%=obj.get("blogger") %></td>
          <td class="noborderleft borders-white"><%=dt[0]%></td>
        </tr>
        
<% } }%>        

  <!--       <tr>
            <td><i class="fas text-medium fa-check text-light-color icon-big2 cursor-pointer trackblog" data-toggle="tooltip" data-placement="top" title="Select to Track Blog"></i></td>
            <td class="blogsitename"><h6 class="text-primary">Crooks and Liars</h6></td>
            <td><h6 class="text-primary">Bpple Employees forced to phone 911 for workers injured after walking into glass walls</h6></td>
            <td>Richard Young</td>
            <td>February 20, 2019</td>
        </tr> -->

      </tbody>   
</table>
</div>

<div class="card-columns pt0 pb10  mt20 mb50 gridlook hidden" id="appendee">

<% 
if(results.size()>0){
	String res = null;
	JSONObject resp = null;
	String resu = null;
	JSONObject obj = null;
	int totalpost = 0;
	String bres = null;
	JSONObject bresp = null;
	String bresu =null;
	JSONObject bobj =null;
	

		for(int i=0; i< results.size(); i++){

			 String blogtitle="";		
			 res = results.get(i).toString();
			 resp = new JSONObject(res);
		     resu = resp.get("_source").toString();
		     obj = new JSONObject(resu);
		     String blogid = obj.get("blogsite_id").toString();
		     String[] dt = obj.get("date").toString().split("T");
		     
			 ArrayList blog = blogs._fetch(blogid); 
			 if( blog.size()>0){
						 bres = blog.get(0).toString();			
						 bresp = new JSONObject(bres);
						 bresu = bresp.get("_source").toString();
						 bobj = new JSONObject(bresu);
						 blogtitle = bobj.get("blogsite_name").toString();			 
			}
		     String totaltrack  = trackers.getTotalTrack(blogid);		     
%>
<div class="card noborder curved-card mb30" >
<div class="curved-card selectcontainer borders-white curve_<%=blogid%>">
<% if(!username.equals("") || username.equals("")){ %>
 <div class="text-center"><i class="fas text-medium pt40 fa-check text-light-color icon-big2 cursor-pointer trackblog blog_id_<%=blogid%>" data-toggle="tooltip" data-placement="top"  title="Select to Track Blog"></i></div>
<% } %>
<h4 class="text-primary text-center p10 pt20 posttitle"><a class="blogname-<%=blogid%>" href="<%=request.getContextPath()%>/blogpostpage.jsp?p=<%=obj.get("blogpost_id")%>"><%=blogtitle%></a></h4>

<div class="text-center mt10 mb10 trackingtracks">
<% if(myblogs.has(blogid)){ %><button class="btn btn-primary stylebutton7">TRACKING</button><% } %> <button class="btn btn-primary stylebutton8"><%=totaltrack%> Tracks</button>
  </div>


 

  <div class="card-body">

    <a href="<%=request.getContextPath()%>/blogpostpage.jsp?p=<%=obj.get("blogpost_id")%>"><h4 class="card-title text-primary text-center pb20 bold-text post-title"><%=obj.get("title").toString()%></h4></a>

    <p class="card-text text-center author mb0 light-text"><%=obj.get("blogger") %></p>
    <p class="card-text text-center postdate light-text"><%=dt[0]%></p>
  </div>
  <div class="<%=obj.get("blogpost_id")%>">
  <input type="hidden" class="post-image" id="<%=obj.get("blogpost_id")%>" name="pic" value="<%=obj.get("permalink") %>">
  </div>
<%
String favoritestatus = "far";
String title = "Add to Favorites";
if(!email.equals(""))
{
Favorites favorites = new Favorites();
String allblogstring = favorites.checkIfFavoritePost(username);

String[] allblogarray = allblogstring.split(",");
String blogpostid = obj.get("blogpost_id").toString(); 
//favoritestatus = "far";
//System.out.println(allblogarray.length);
if(!allblogstring.equalsIgnoreCase(""))
{	
for(int j=0; j<allblogarray.length; j++)
{
	if(allblogarray[j].equals(blogpostid))
	{
		favoritestatus = "fas";
		title = "Remove from Favorites";
		break;
	}
	//System.out.println(allblogarray[i]);	
} 

} 
}  
%>
  <div class="text-center"><i id="blogpostt_<%=obj.get("blogpost_id").toString() %>" class="<%=favoritestatus %> fa-heart text-medium pb30  favorites-text icon-big favoritestoggle cursor-pointer" data-toggle="tooltip" data-placement="top" title="<%=title %>"></i></div>
</div>
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
<input type="hidden" id="selected_tracker" name="selected_tracker" value="" />
<form name="page_form" id="page_form" method="post" action="">
    <input type="hidden" id="page_id" name="page_id" value="0" />
	<input type="hidden" name="negative_page" id="negative_page" value="1" />
	<input type="hidden" id="hasmore" name="hasmore" value="1" />
	<input type="hidden" id="current_page" name="current_page" value="blogbrowser" />
	<input type="hidden" id="term" name="term" value="<%=term%>" />
 </form>
<form action="" name="sortform" id="sortform" method="post">
	<input type="hidden" name="term" value="<%=term %>" />
	<input type="hidden" name="sortby" id="sortby" value="date" />
</form>


<!-- <footer class="footer">
  <div class="container-fluid bg-primary mt60">
<p class="text-center text-medium pt10 pb10 mb0">Copyright &copy; Blogtrackers 2017 All Rights Reserved.</p>
</div>
  </footer> -->


<script type="text/javascript" src="assets/js/jquery-1.11.3.min.js"></script>
<script src="assets/bootstrap/js/bootstrap.js">
</script>
<script src="js/jscookie.js">
</script>
<script type="text/javascript" src="assets/vendors/tags/tagsinput.min.js"></script>
<script type="text/javascript" src="assets/vendors/tags/tokenfield.min.js"></script>
<script type="text/javascript" src="assets/vendors/ui/prism.min.js"></script>
<script type="text/javascript" src="assets/vendors/typeahead/typeahead.bundle.min.js"></script>
<script type="text/javascript" src="assets/js/form_tags_input.js"></script>
<script type="text/javascript"
src="assets/vendors/DataTables/datatables.min.js"></script>
<script type="text/javascript"
src="assets/vendors/DataTables/dataTables.bootstrap4.min.js"></script>
<script
src="assets/vendors/DataTables/Buttons-1.5.1/js/buttons.flash.min.js"></script>
<script
src="assets/vendors/DataTables/Buttons-1.5.1/js/dataTables.buttons.min.js"></script>
<script src="assets/vendors/DataTables/pdfmake-0.1.32/pdfmake.min.js"></script>
<script src="assets/vendors/DataTables/pdfmake-0.1.32/vfs_fonts.js"></script>
<script
src="assets/vendors/DataTables/Buttons-1.5.1/js/buttons.html5.min.js"></script>
<script
src="assets/vendors/DataTables/Buttons-1.5.1/js/buttons.print.min.js"></script>
<script type="text/javascript">
  $(document).ready(function() {
      $('#blogbrowser').DataTable({
      "paging":false,
      "bInfo" : false,
      "searching": false,
      "columnDefs": [ {"targets": 0,"width":"1%"},{"targets": 2,"width":"40%"},{"targets": 1,"width":"25%"}]
      });
  } );
  </script>
<!--end for table  -->
<!-- Added for interactivity for selecting tracker and add to favorite actions  -->


<script src="pagedependencies/blogbrowser3.js">
</script>
<!-- Added for interactivity for selecting tracker and favorites actions -->

<script src="assets/js/generic.js">

</script>

<script src="pagedependencies/imageloader.js?v=09"></script>

<script src="js/functions.js"></script>
<script>
$(window).scroll(function() {
	if($(window).scrollTop() + $(window).height() > $(document).height() - 200) {
		loadMoreResult();
	}
});




</script>
</body>
</html>
