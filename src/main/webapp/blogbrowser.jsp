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

Blogposts post  = new Blogposts();
String term =  (null == request.getParameter("term")) ? "" : request.getParameter("term");
ArrayList results = null;
if(term.equals("")){
	results = post._list("DESC","");
}else{
	results = post._search(term,"");
}
String total = NumberFormat.getNumberInstance(Locale.US).format(Integer.parseInt(post._getTotal()));
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
</head>
<body >

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
          <li><a class="bold-text" href="<%=request.getContextPath()%>/blogbrowser.jsp"><i class="fas fa-home"></i> Home</a></li>
          <li><a class="bold-text" href="<%=request.getContextPath()%>/trackerlist.jsp"><i class="far fa-dot-circle"></i> Trackers</a></li>
          <li><a class="bold-text" href="<%=request.getContextPath()%>/favorites.jsp"><i class="far fa-heart"></i> Favorites</a></li>

        </ul>
      </div>

  <div class="col-lg-3">
  	 <% if(userinfo.size()>0){ %>

	  <ul class="nav navbar-nav" style="display:block;">
		  <li class="dropdown dropdown-user cursor-pointer float-right">
		  <a class="dropdown-toggle " id="profiletoggle" data-toggle="dropdown">
		    <i class="fas fa-circle" id="notificationcolor"></i>

		  <img src="<%=profileimage%>" width="50" height="50" onerror="this.src='images/default-avatar.png'" alt="" class="" />
		  <span ><%=username%></span></a>

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
      <form name="serach-form" method="post" action=""><input type="search" autocomplete="off" name="term" class="form-control p30 pt5 pb5 icon-big border-none bottom-border text-center blogbrowsersearch nobackground"
     <% if(!term.equals("")){ %>
      placeholder="Searching for <%=term%>"
     <% } else { %>
     placeholder="Search Posts"
     <% } %>
      />

      </form>
      </div>

    </nav>

<div class="text-center pt20 pb20 tracksection hidden" style="background:#ffffff;"><button type="submit" class="btn btn-success homebutton p50 pt10 pb10" id="initiatetrack"><b>Tracks</b> <b class="trackscount" id="trackscount">0</b> </button> <i style="font-size:30px;" class="cursor-pointer lnr lnr-cross float-right pr20 mt10" id="closetracks" data-toggle="tooltip" data-placement="top" title="Close"></i></div>

<!-- Backdrop for modal -->
<div class="modalbackdrop hidden">

</div>
<div class="container-fluid hidden trackinitiated">

<!-- <div class="container-fluid"> -->
<div class="row bg-primary">

<div class="offset-md-1 col-md-6 pl100 pt100 pb100">
<h1 class="text-white trackertitlesize"><b class="greentext">4</b> Blogs</h1>
<div class="mt30">
<button class="col-md-6 btn text-left text-white bold-text blogselection mt10 pt10 pb10">Engadget <i class="fas fa-trash float-right hidden deleteblog"></i></button>
<button class="col-md-6 btn text-left text-white bold-text blogselection mt10 pt10 pb10">National Public Radio <i class="fas fa-trash float-right hidden deleteblog"></i></button>
<button class="col-md-6 btn text-left text-white bold-text blogselection mt10 pt10 pb10">Crooks and Liars <i class="fas fa-trash float-right hidden deleteblog"></i></button>
<button class="col-md-6 btn text-left text-white bold-text blogselection mt10 pt10 pb10">Tech Crunch <i class="fas fa-trash float-right hidden deleteblog"></i></button>
</div>
</div>
<div class="col-md-5 pt100 pb100 pl50 pr50 bg-white">
<div class="trackcreationsection1">
<i class="cursor-pointer lnr lnr-cross float-right closedialog" data-toggle="tooltip" data-placement="top" title="Close Dialog"></i>
<h3 class="text-primary bold-text">Track the selected blogs using the following list of trackers: </h3>
<button class="col-md-10 mt30 form-control text-primary bold-text cursor-pointer btn createtrackerbtn">+</button>
<div class="trackerlist mt20">
<button class="btn form-control col-md-10 text-primary text-left trackerindividual pt10 pb10 pl10 resetdefaultfocus bold-text">Science <i class="fas fa-check float-right hidden checktracker"></i></button>
<button class="btn form-control col-md-10 text-primary text-left trackerindividual pt10 pb10 pl10 resetdefaultfocus bold-text">Technology <i class="fas fa-check float-right hidden checktracker"></i></button>
<button class="btn form-control col-md-10 text-primary text-left trackerindividual pt10 pb10 pl10 resetdefaultfocus bold-text">Politics <i class="fas fa-check float-right hidden checktracker"></i></button>
<button class="btn form-control col-md-10 text-primary text-left trackerindividual pt10 pb10 pl10 resetdefaultfocus bold-text">Russia <i class="fas fa-check float-right hidden checktracker"></i></button>
<button class="btn form-control col-md-10 text-primary text-left trackerindividual pt10 pb10 pl10 resetdefaultfocus bold-text">Spare <i class="fas fa-check float-right hidden checktracker"></i></button>
</div>
<div class="col-md-12 mt20 text-primary">
<b class="selectedtrackercount text-primary">0</b> Tracker(s) selected
</div>
</div>

<!-- tracker section for creatio of new  -->
<div class="trackcreationsection2 hidden">
<i class="cursor-pointer fas fa-times float-right closedialog" data-toggle="tooltip" data-placement="top" title="" data-original-title="Close Dialog"></i>
<h1 class="text-primary">Create a Tracker</h1>
<input type="text" class="form-control trackerinput blogbrowsertrackername" placeholder="Title" />
<textarea placeholder="Description" class="form-control mt20 trackerdescription blogbrowsertrackerdescription" rows="8">
</textarea>
<div class="form-group mt20">
<input type="text" class="form-control tokenfield-primary" value="Engadget,National Public Radio,Crooks and Liars,Tech Crunch" />
</div>
<div class="mt30">
<button class="btn btn-default cancelbtn canceltracker text-primary">Cancel</button> <button class=" btn btn-success trackercreatebutton">Create</button>
</div>

</div>

<!-- end   -->

</div>




</div>

</div>


<div class="container">


<div class="row mt50">
<div class="col-md-12 ">
<% if(!term.equals("")){ %>
<h6 class="float-left text-primary bold-text"><%=total %> posts found for "<%=term%>"</h6>
<%}else{%>
<h6 class="float-left text-primary bold-text"><%=total %> posts in our knowledge database</h6>

<%}%>
<h6 class="float-right text-primary">
  <select class="text-primary filtersort sortby"><option>Recent</option><option>Influence Score</option></select>
</h6>
</div>
</div>


<div class="card-columns pt0 pb10  mt20 mb50 " id="appendee">

<% if(results.size()>0){
		for(int i=0; i< results.size(); i++){
			String res = results.get(i).toString();

			JSONObject resp = new JSONObject(res);
		    String resu = resp.get("_source").toString();
		     JSONObject obj = new JSONObject(resu);

		     String pst = obj.get("post").toString().replaceAll("[^a-zA-Z]", " ");
		     if(pst.length()>120){
		    	 pst = pst.substring(0,120);
		     }

%>
<div class="card noborder curved-card mb30" >
<div class="curved-card selectcontainer">
 <div class="text-center"><i class="fas text-medium pt40 fa-check text-light-color icon-big2 cursor-pointer trackblog" data-toggle="tooltip" data-placement="top" title="Select to Track Blog"></i></div>
<h4 class="text-primary text-center p10 pt20 posttitle"><a class="" href="<%=request.getContextPath()%>/blogpostpage.jsp?p=<%=obj.get("blogpost_id")%>"><%=obj.get("title").toString().replaceAll("[^a-zA-Z]", " ") %></a></h4>
<div class="text-center mt10 mb10 trackingtracks"><button class="btn btn-primary stylebutton7">TRACKING</button> <button class="btn btn-primary stylebutton8">0 Tracks</button></div>
  </div>
  <div class="card-body">
    <a href="<%=request.getContextPath()%>/blogpostpage.jsp?p=<%=obj.get("blogpost_id")%>"><h4 class="card-title text-primary text-center pb20 bold-text post-title"><%=pst+"..."%></h4></a>
    <p class="card-text text-center author mb0 light-text"><%=obj.get("blogger") %></p>
    <p class="card-text text-center postdate light-text"><%=obj.get("date") %></p>
  </div>
  <div class="<%=obj.get("blogpost_id")%>">
  <input type="hidden" class="post-image" id="<%=obj.get("blogpost_id")%>" name="pic" value="<%=obj.get("permalink") %>">
  </div>
  <div class="text-center"><i class="far fa-heart text-medium pb30  favorites-text icon-big favoritestoggle cursor-pointer" data-toggle="tooltip" data-placement="top" title="Add to Favorites"></i></div>
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
<script type="text/javascript" src="assets/vendors/tags/tagsinput.min.js"></script>
<script type="text/javascript" src="assets/vendors/tags/tokenfield.min.js"></script>
<script type="text/javascript" src="assets/vendors/ui/prism.min.js"></script>
<script type="text/javascript" src="assets/vendors/typeahead/typeahead.bundle.min.js"></script>
<script type="text/javascript" src="assets/js/form_tags_input.js"></script>

<!--end for table  -->
<!-- Added for interactivity for selecting tracker and add to favorite actions  -->

<script src="pagedependencies/blogbrowser.js">
</script>
<!-- Added for interactivity for selecting tracker and favorites actions -->

<script src="assets/js/generic.js">

</script>

<script src="pagedependencies/imageloader.js?v=189908998"></script>
<script src="js/functions.js?v=0990"></script>
<script>
$(window).scroll(function() {
	if($(window).scrollTop() + $(window).height() > $(document).height() - 200) {
		loadMoreResult();
	}
});

</script>
</body>
</html>
