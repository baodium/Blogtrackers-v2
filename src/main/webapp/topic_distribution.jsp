<%@page import="authentication.*"%>
<%@page import="java.util.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.File"%>
<%@page import="util.Blogposts"%>
<%@page import="java.text.NumberFormat" %>
<%@page import="java.util.Locale" %>
<%@page import="java.util.ArrayList"%>
<%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
	<title>Blogtrackers-Posting Frequecy</title>
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

<link rel="stylesheet" href="assets/css/daterangepicker.css" />
  <link rel="stylesheet" href="assets/css/style.css" />

  <!--end of bootsrap -->
  <script src="assets/js/jquery-3.2.1.slim.min.js"  ></script>
<script src="assets/js/popper.min.js" ></script>
<script src="pagedependencies/googletagmanagerscript.js"></script>
</head>
<body>
<%@include file="subpages/loader.jsp" %>
<%@include file="subpages/googletagmanagernoscript.jsp" %>
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
   <a class="cursor-pointer profilemenulink" href="<%=request.getContextPath()%>/addblog.jsp"><h6 class="text-primary">Add Blog</h6></a>
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

          <!-- <div class="col-md-12 mt0">
          <input type="search" class="form-control p30 pt5 pb5 icon-big border-none bottom-border text-center blogbrowsersearch nobackground" placeholder="Search Trackers" />
          </div> -->

        </nav>
<div class="container analyticscontainer">
<div class="row bottom-border pb20">
<div class="col-md-6 paddi">
<nav class="breadcrumb">
  <a class="breadcrumb-item text-primary" href="trackerlist.html">MY TRACKER</a>
  <a class="breadcrumb-item text-primary" href="#">Second Tracker</a>
  <a class="breadcrumb-item active text-primary" href="postingfrequency.html">Topic Distribution</a>
  </nav>
<div>Tracking: <button class="btn btn-primary stylebutton1">All Blogs</button></div>
</div>

<div class="col-md-6 text-right mt10">
<div class="text-primary demo"><h6 id="reportrange">Date: <span>02/21/18 - 02/28/18</span></h6></div>
<div>
  <div class="btn-group mt5" data-toggle="buttons">
 <!--  <label class="btn btn-primary btn-sm daterangebutton legitRipple nobgnoborder"> <input type="radio" name="options" value="day" autocomplete="off" > Day
  	</label>
    <label class="btn btn-primary btn-sm nobgnoborder"> <input type="radio" name="options" value="week" autocomplete="off" >Week
  	</label>
     <label class="btn btn-primary btn-sm nobgnoborder nobgnoborder"> <input type="radio" name="options" value="month" autocomplete="off" > Month
  	</label>
    <label class="btn btn-primary btn-sm text-center nobgnoborder">Year <input type="radio" name="options" value="year" autocomplete="off" >
  	</label>
    <label class="btn btn-primary btn-sm nobgnoborder " id="custom">Custom</label> -->
  </div>

  <!-- Day Week Month Year <b id="custom" class="text-primary">Custom</b> -->

</div>
</div>
</div>

<!-- <div class="row p40 border-top-bottom mt20 mb20">
  <div class="col-md-2">
<small class="text-primary">Selected Blogger</small>
<h2 class="text-primary styleheading">AdNovum <div class="circle"></div></h2>
</div>
  <div class="col-md-10">
  <small class="text-primary">Find Blogger</small>
  <input class="form-control inputboxstyle" placeholder="| Search" />
  </div>
</div> -->

<div class="row mt20">
<div class="col-md-3">

<div class="card card-style mt20">
  <div class="card-body  p30 pt5 pb5 mb20">
    <h5 class="mt20 mb20">Topics</h5>
    <div style="padding-right:10px !important;">
      <input type="search" class="form-control stylesearch mb20" placeholder="Search " /></div>
    <div class="scrolly" style="height:270px; padding-right:10px !important;">
    <a class="btn btn-primary form-control stylebuttonactive mb20 activebar"> <b>Topic 1</b></a>
    <a class="btn form-control stylebuttoninactive opacity53 text-primary mb20"><b>Topic 2</b></a>
     <a class="btn form-control stylebuttoninactive opacity53 text-primary mb20"><b>Topic 3</b></a>
     <a class="btn form-control stylebuttoninactive opacity53 text-primary mb20"><b>Topic 4</b></a>
     <a class="btn form-control stylebuttoninactive opacity53 text-primary mb20"><b>Topic 5</b></a>
     <a class="btn form-control stylebuttoninactive opacity53 text-primary mb20"><b>Topic 6</b></a>
     <a class="btn form-control stylebuttoninactive opacity53 text-primary mb20"><b>Topic 7</b></a>
     <a class="btn form-control stylebuttoninactive opacity53 text-primary mb20"><b>Topic 8</b></a>

   </div>


  </div>
</div>
</div>

<div class="col-md-9">
  <div class="card card-style mt20">
    <div class="card-body  p30 pt5 pb5">
      <div style="min-height: 250px;">
<div><p class="text-primary mt10"> <b>Individual</b> Number of Blog Post of Past <select class="text-primary filtersort sortbytimerange"><option value="week">Week</option><option value="month">Month</option><option value="year">Year</option></select></p></div>
<div class="chart-container">
  <div class="chart" id="topicstream"></div>
</div>
      </div>
        </div>
  </div>
  <div class="card card-style mt20">
    <div class="card-body  p30 pt20 pb20">
      <div class="row">
     <div class="col-md-3 mt5 mb5">
       <h6 class="card-title mb0">Blog Distribution</h6>
       <h3 class="mb0 text-primary text-statistics">95%</h3>
       <!-- <small class="text-success">+5% from <b>Last Week</b></small> -->
     </div>

     <div class="col-md-3 mt5 mb5">
      <h6 class="card-title mb0">Bloggers Mentioned</h6>
       <h3 class="mb0 text-primary text-statistics">20</h3>
       <!-- <small class="text-success">+5% from <b>Last Week</b></small> -->
     </div>

     <div class="col-md-3 mt5 mb5">
       <h6 class="card-title mb0">Post Mentioned</h6>
       <h3 class="mb0 text-primary text-statistics">400</h3>
       <!-- <small class="text-success">+5% from <b>Last Week</b></small> -->
     </div>

     <div class="col-md-3  mt5 mb5">
       <h6 class="card-title mb0">Top Posting Location</h6>
       <h3 class="mb0 text-primary text-statistics">United States</h3>
     </div>

      </div>
        </div>
  </div>
</div>
</div>

<div class="row mb0">
  <div class="col-md-4 mt20 ">
    <div class="card card-style mt20">
      <div class="card-body  p20 pt5 pb5">
        <div><p class="text-primary mt10">Keywords of <b class="text-blue">Topic 1</b> of Past <b class="text-success">Abel Danger</b></p></div>
        <div class="tagcloudcontainer" style="min-height: 300px;">

        </div>
          </div>
    </div>
  </div>

  <div class="col-md-4 mt20">
    <div class="card card-style mt20">


          <div class="card-body p20 pt0 pb20" style="min-height: 300px;">
            <div><p class="text-primary mt10"><b class="text-blue">Topic 1</b> of Past <b class="text-success">Week</b></p></div>
            <div class="chart-container">
            <div class="chart svg-center" id="chorddiagram">

            </div>


          </div>
                </div>

    </div>
  </div>

  <div class="col-md-4 mt20">
    <div class="card card-style mt20">


          <div class="card-body p0 pt0 pb20" style="min-height: 300px;">
              <!-- <div><p class="text-primary p15 pt0 pb0 mt10">Top 5 Entities</p></div> -->
              <div class="chart-container">
              <div class="chart svg-center" id="clusterdiagram">

              </div>


            </div>

                </div>

    </div>
  </div>




</div>

<div class="row m0 mt20 mb20 d-flex align-items-stretch" >
  <div class="col-md-6 mt20 card card-style nobordertopright noborderbottomright">
  <div class="card-body p0 pt20 pb20" style="min-height: 420px;">
      <p> Posts from <b class="text-success">Topic 1</b></p>
          <!-- <div class="p15 pb5 pt0" role="group">
          Export Options
          </div> -->
                <table id="DataTables_Table_0_wrapper" class="display" style="width:100%">
                        <thead>
                            <tr>
                                <th>Post title</th>
                                <th>Topic weight</th>


                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>URL</td>
                                <td>Frequency</td>


                            </tr>
                            <tr>
                                <td>URL</td>
                                <td>Frequency</td>


                            </tr>
                            <tr>
                                <td>URL</td>
                                <td>Frequency</td>


                            </tr>
                            <tr>
                                <td>URL</td>
                                <td>Frequency</td>


                            </tr>
                            <tr>
                                <td>URL</td>
                                <td>Frequency</td>


                            </tr>
                            <tr>
                                <td>URL</td>
                                <td>Frequency</td>


                            </tr>
                            <tr>
                                <td>URL</td>
                                <td>Frequency</td>


                            </tr>
                            <tr>
                                <td>URL</td>
                                <td>Frequency</td>


                            </tr>
                            <tr>
                                <td>URL</td>
                                <td>Frequency</td>


                            </tr>
                            <tr>
                                <td>URL</td>
                                <td>Frequency</td>


                            </tr>

                        </tbody>
                    </table>
        </div>

  </div>

  <div class="col-md-6 mt20 card card-style nobordertopleft noborderbottomleft">
        <div style="" class="pt20">
          <h5 class="text-primary p20 pt0 pb0">#1809: Marine Links Clinton Yellen SBA women to MI-3 War Rooms, Serco Base One Pentagon bomb</h5>
          <div class="text-center mb20 mt20"><button class="btn stylebuttonblue"><b class="float-left ultra-bold-text">Michael J Fox</b> <i class="far fa-user float-right blogcontenticon"></i></button> <button class="btn stylebuttonnocolor">02-01-2018, 5:30pm</button> <button class="btn stylebuttonorange"><b class="float-left ultra-bold-text">32 comments</b><i class="far fa-comments float-right blogcontenticon"></i></button></div>
			<div style="height: 600px;">
          <div class="p20 pt0 pb20 text-blog-content text-primary" style="height:550px; overflow-y:scroll; ">
          You can create Slideshows and Stacked galleries with Post Format: Gallery. Also you can manage - add/edit/delete
          images any time you want. Hyper-X comes with huge amount of gallery options, which could be previewed from Theme Customizer.
           Praesent nibh
           You can create Slideshows and Stacked galleries with Post Format: Gallery. Also you can manage - add/edit/delete images any time you want. Hyper-X comes with huge amount of gallery options, which could be previewed from Theme Customizer. Praesent nibh...
           You can create Slideshows and Stacked galleries with Post Format: Gallery. Also you can manage - add/edit/delete images any time you want. Hyper-X comes with huge amount of gallery options, which could be previewed from Theme Customizer. Praesent nibh...
           You can create Slideshows and Stacked galleries with Post Format: Gallery. Also you can manage - add/edit/delete images any time you want. Hyper-X comes with huge amount of gallery options, which could be previewed from Theme Customizer. Praesent nibh...
           You can create Slideshows and Stacked galleries with Post Format: Gallery. Also you can manage - add/edit/delete images any time you want. Hyper-X comes with huge amount of gallery options, which could be previewed from Theme Customizer. Praesent nibh...
           You can create Slideshows and Stacked galleries with Post Format: Gallery. Also you can manage - add/edit/delete images any time you want. Hyper-X comes with huge amount of gallery options, which could be previewed from Theme Customizer. Praesent nibh...
           You can create Slideshows and Stacked galleries with Post Format: Gallery. Also you can manage - add/edit/delete images any time you want. Hyper-X comes with huge amount of gallery options, which could be previewed from Theme Customizer. Praesent nibh...
           You can create Slideshows and Stacked galleries with Post Format: Gallery. Also you can manage - add/edit/delete images any time you want. Hyper-X comes with huge amount of gallery options, which could be previewed from Theme Customizer. Praesent nibh...
         </div>
         </div>
    </div>
  </div>
</div>


<div class="row mb50 d-flex align-items-stretch">
  <div class="col-md-12 mt20 ">
    <div class="card card-style mt20">
      <div class="card-body p10 pt20 pb5">

        <div style="min-height: 420px;">
      <!-- <p class="text-primary">Top keywords of <b>Past Week</b></p> -->
          <div class="p15 pb5 pt0" role="group">
          </div>
                <table id="DataTables_Table_1_wrapper" class="display" style="width:100%">
                        <thead>
                            <tr>
                                <th>Topic 1</th>
                                <th>Topic 2</th>
                                <th>Topic 3</th>
<th>Topic 4</th>
<th>Topic 5</th>
<th>Topic 6</th>
<th>Topic 7 </th>
<th>Topic 8</th>

                            </tr>
                        </thead>
                        <tbody>
                          <tr>
                          <td>Word 1</td>
                          <td>Word 1</td>
                          <td>Word 1</td>
                          <td>Word 1</td>
                          <td>Word 1</td>
                          <td>Word 1</td>
                          <td>Word 1</td>
                          <td>Word 1</td>
                        </tr>
                        <tr>
                        <td>Word 2</td>
                        <td>Word 2</td>
                        <td>Word 2</td>
                        <td>Word 2</td>
                        <td>Word 2</td>
                        <td>Word 2</td>
                        <td>Word 2</td>
                        <td>Word 2</td>
                        </tr>
                        <tr>
                        <td>Word 3</td>
                        <td>Word 3</td>
                        <td>Word 3</td>
                        <td>Word 3</td>
                        <td>Word 3</td>
                        <td>Word 3</td>
                        <td>Word 3</td>
                        <td>Word 3</td>
                        </tr>
                        <tr>
<td>Word 4</td>
<td>Word 4</td>
<td>Word 4</td>
<td>Word 4</td>
<td>Word 4</td>
<td>Word 4</td>
<td>Word 4</td>
<td>Word 4</td>
</tr>
<tr>
<td>Word 5</td>
<td>Word 5</td>
<td>Word 5</td>
<td>Word 5</td>
<td>Word 5</td>
<td>Word 5</td>
<td>Word 5</td>
<td>Word 5</td>
</tr>
<tr>
<td>Word 6</td>
<td>Word 6</td>
<td>Word 6</td>
<td>Word 6</td>
<td>Word 6</td>
<td>Word 6</td>
<td>Word 6</td>
<td>Word 6</td>
</tr>
<tr>
<td>Word 7</td>
<td>Word 7</td>
<td>Word 7</td>
<td>Word 7</td>
<td>Word 7</td>
<td>Word 7</td>
<td>Word 7</td>
<td>Word 7</td>
</tr>
<tr>
<td>Word 8</td>
<td>Word 8</td>
<td>Word 8</td>
<td>Word 8</td>
<td>Word 8</td>
<td>Word 8</td>
<td>Word 8</td>
<td>Word 8</td>
</tr>


                        </tbody>
                    </table>
        </div>
          </div>
    </div>
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
 <script src="assets/js/generic.js">
 </script>
 <script src="assets/vendors/bootstrap-daterangepicker/moment.js"></script>
 <script src="assets/vendors/bootstrap-daterangepicker/daterangepicker.js"></script>
 <!-- Start for tables  -->
 <script type="text/javascript" src="assets/vendors/DataTables/datatables.min.js"></script>
 <script type="text/javascript" src="assets/vendors/DataTables/dataTables.bootstrap4.min.js"></script>
 <script src="assets/vendors/DataTables/Buttons-1.5.1/js/buttons.flash.min.js"></script>
 <script src="assets/vendors/DataTables/Buttons-1.5.1/js/dataTables.buttons.min.js"></script>
 <script src="assets/vendors/DataTables/pdfmake-0.1.32/pdfmake.min.js"></script>
 <script src="assets/vendors/DataTables/pdfmake-0.1.32/vfs_fonts.js"></script>
 <script src="assets/vendors/DataTables/Buttons-1.5.1/js/buttons.html5.min.js"></script>
 <script src="assets/vendors/DataTables/Buttons-1.5.1/js/buttons.print.min.js"></script>

 <script>
 $(document).ready(function() {
     $('#DataTables_Table_1_wrapper').DataTable( {
         "scrollY": 450,
         "scrollX": true,
          "pagingType": "simple",
           // dom: 'Bfrtip'
       //    ,
       // buttons:{
       //   buttons: [
       //       { extend: 'pdfHtml5',orientation: 'potrait', pageSize: 'LEGAL', className: 'btn-primary stylebutton1'},
       //       {extend:'csv',className: 'btn-primary stylebutton1'},
       //       {extend:'excel',className: 'btn-primary stylebutton1'},
       //      // {extend:'copy',className: 'btn-primary stylebutton1', text: 'Copy to Clipboard'},
       //       {extend:'print',className: 'btn-primary stylebutton1'},
       //   ]
       // }
     } );

     $('#DataTables_Table_0_wrapper').DataTable( {
         "scrollY": 460,
         "scrollX": true,
          "pagingType": "simple",
          // dom: 'Bfrtip'
       //    ,
       // buttons:{
       //   buttons: [
       //       { extend: 'pdfHtml5',orientation: 'potrait', pageSize: 'LEGAL', className: 'btn-primary stylebutton1'},
       //       {extend:'csv',className: 'btn-primary stylebutton1'},
       //       {extend:'excel',className: 'btn-primary stylebutton1'},
       //      // {extend:'copy',className: 'btn-primary stylebutton1', text: 'Copy to Clipboard'},
       //       {extend:'print',className: 'btn-primary stylebutton1'},
       //   ]
       // }
     } );
 } );
 </script>
 <!--end for table  -->
 <script>
 $(document).ready(function() {
   $(document)
   						.ready(
   								function() {
   	var cb = function(start, end, label) {
           //console.log(start.toISOString(), end.toISOString(), label);
           $('#reportrange span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
           $('#reportrange input').val(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY')).trigger('change');
         };

         var optionSet1 =
       	      {   startDate: moment().subtract(29, 'days'),
       	          endDate: moment(),
       	          minDate: '01/01/1947',
       	          maxDate: moment(),
       			  showDropdowns: true,
       			linkedCalendars: false,
       	          showWeekNumbers: true,
       	          timePicker : false,
   				  timePickerIncrement : 1,
   				  timePicker12Hour : true,
   				  dateLimit: { days: 50000 },
          	          ranges: {

          	        	'This Year' : [
   						moment()
   								.startOf('year'),
   						moment() ],
   				'Last Year' : [
   						moment()
   								.subtract(1,'year').startOf('year'),
   						moment().subtract(1,'year').endOf('year') ]
       	          },
       	          opens: 'left',
       	          applyClass: 'btn-small bg-slate-600 btn-block',
       	          cancelClass: 'btn-small btn-default btn-block',
       	          format: 'MM/DD/YYYY',
       			  locale: {
       	          applyLabel: 'Submit',
       	          //cancelLabel: 'Clear',
       	          fromLabel: 'From',
       	          toLabel: 'To',
       	          customRangeLabel: 'Custom',
       	          daysOfWeek: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'],
       	          monthNames: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
       	          firstDay: 1
       	        }

       	      };


   	// if('${datepicked}' == '')
   	// {
     //   $('#reportrange span').html(moment().subtract('days', 500).format('MMMM D') + ' - ' + moment().format('MMMM D'));
     //   $('#reportrange').daterangepicker(optionSet1, cb);
   	// }
     //
   	// else{
   		// $('#reportrange span').html('${datepicked}');
       $('#reportrange span').html(moment().subtract( 500, 'days').format('MMMM D, YYYY') + ' - ' + moment().format('MMMM D, YYYY'))
   		$('#reportrange, #custom').daterangepicker(optionSet1, cb);
   		$('#reportrange')
   		.on(
   				'show.daterangepicker',
   				function() {
   				/* 	console
   							.log("show event fired"); */
   				});
   $('#reportrange')
   		.on(
   				'hide.daterangepicker',
   				function() {
   					/* console
   							.log("hide event fired"); */
   				});
   $('#reportrange')
   		.on(
   				'apply.daterangepicker',
   				function(ev, picker) {
   					/* console
   							.log("apply event fired, start/end dates are "
   									+ picker.startDate
   											.format('MMMM D, YYYY')
   									+ " to "
   									+ picker.endDate
   											.format('MMMM D, YYYY')); */
   				});
   $('#reportrange')
   		.on(
   				'cancel.daterangepicker',
   				function(ev, picker) {
   					/* console
   							.log("cancel event fired"); */
   				});
   $('#options1').click(
   		function() {
   			$('#reportrange').data(
   					'daterangepicker')
   					.setOptions(
   							optionSet1,
   							cb);
   		});
   $('#options2').click(
   		function() {
   			$('#reportrange').data(
   					'daterangepicker')
   					.setOptions(
   							optionSet2,
   							cb);
   		});
   $('#destroy').click(
   		function() {
   			$('#reportrange').data(
   					'daterangepicker')
   					.remove();
   		});
   		//}
   								});
                 // set attribute for the form
       //$('#trackerform').attr("action","ExportJSON");
       //$('#dateform').attr("action","ExportJSON");


   //$('#config-demo').daterangepicker(options, function(start, end, label) { console.log('New date range selected: ' + start.format('YYYY-MM-DD') + ' to ' + end.format('YYYY-MM-DD') + ' (predefined range: ' + label + ')'); });
 });
 </script>
 <script type="text/javascript" src="assets/vendors/d3/d3.min.js"></script>
 <script src="assets/vendors/wordcloud/d3.layout.cloud.js"></script>
 <script type="text/javascript" src="assets/vendors/d3/d3_tooltip.js"></script>
 <script>

 $(function () {

	    streamgraph('#topicstream', 230); // initialize chart

	    // Chart setup
	    function streamgraph(element, height) {


	        // Basic setup
	        // ------------------------------

	        // Define main variables
	        var d3Container = d3.select(element),
	            margin = {top: 5, right: 50, bottom: 40, left: 50},
	            width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right,
	            height = height - margin.top - margin.bottom,
	            tooltipOffset = 30;

	        // Tooltip
	        var tooltip = d3Container
	            .append("div")
	            .attr("class", "d3-tip e")
	            .style("display", "none")

	        // Format date
	        var format = d3.time.format("%m/%d/%y %H:%M");
	        var formatDate = d3.time.format("%H:%M");

	        // Colors
	        var colorrange = ['#03A9F4', '#29B6F6', '#4FC3F7', "#17394C", "#F5CC0E", "#CE0202"];



	        // Construct scales
	        // ------------------------------

	        // Horizontal
	        var x = d3.time.scale().range([0, width]);

	        // Vertical
	        var y = d3.scale.linear().range([height, 0]);

	        // Colors
	        var z = d3.scale.ordinal().range(colorrange);



	        // Create axes
	        // ------------------------------

	        // Horizontal
	        var xAxis = d3.svg.axis()
	            .scale(x)
	            .orient("bottom")
	            .ticks(d3.time.date, 2)
	            .innerTickSize(4)
	            .tickPadding(8)
	            .tickFormat(d3.time.format("%m/%d/%y")); // Display date in month day and year

	        // Left vertical
	        var yAxis = d3.svg.axis()
	            .scale(y)
	            .ticks(6)
	            .innerTickSize(4)
	            .outerTickSize(0)
	            .tickPadding(8)
	            // remove comma seperator
	             // .tickFormat(function (d) { return (d); });

	        // Right vertical
	        var yAxis2 = yAxis;

	        // Dash lines
	        var gridAxis = d3.svg.axis()
	            .scale(y)
	            .orient("left")
	            .ticks(6)
	            .tickPadding(8)
	            .tickFormat("")
	            .tickSize(-width, 0, 0);



	        // Create chart
	        // ------------------------------

	        // Container
	        var container = d3Container.append("svg")

	        // SVG element
	        var svg = container
	            .attr('width', width + margin.left + margin.right)
	            .attr("height", height + margin.top + margin.bottom)
	            .append("g")
	            .attr("transform", "translate(" + margin.left + "," + margin.top + ")");



	        // Construct chart layout
	        // ------------------------------

	        // Stack
	        var stack = d3.layout.stack()
	            .offset("silhouette")
	            .values(function(d) { return d.values; })
	            .x(function(d) { return d.date; })
	            .y(function(d) { return d.value; });

	        // Nest
	        var nest = d3.nest()
	            .key(function(d) { return d.key; });

	        // Area
	        var area = d3.svg.area()
	            .interpolate("cardinal")
	            .x(function(d) { return x(d.date); })
	            .y0(function(d) { return y(d.y0); })
	            .y1(function(d) { return y(d.y0 + d.y); });



	        // Load data
	        // ------------------------------

	        // d3.json("convertcsv.json", function (error, data){
	data = [
	 {
	   "key": "Financial impact migrants",
	   "value": 0.221,
	   "date": "03/01/15 0:00"
	 },
	 {
	   "key": "Financial impact migrants",
	   "value": 0.226,
	   "date": "03/02/15 0:00"
	 },
	 {
	   "key": "Financial impact migrants",
	   "value": 0.22,
	   "date": "03/05/15 0:00"
	 },
	 {
	   "key": "Financial impact migrants",
	   "value": 0.266,
	   "date": "03/07/15 0:00"
	 },
	 {
	   "key": "Financial impact migrants",
	   "value": 0.266,
	   "date": "03/10/15 0:00"
	 },
	 {
	   "key": "Financial impact migrants",
	   "value": 0.245,
	   "date": "3/12/15 00:00"
	 },
	 {
	   "key": "Financial impact migrants",
	   "value": 0.241,
	   "date": "3/13/15 00:00"
	 },
	 {
	   "key": "Financial impact migrants",
	   "value": 0.4,
	   "date": "3/14/15 00:00"
	 },
	 {
	   "key": "Financial impact migrants",
	   "value": 0.269,
	   "date": "3/15/15 00:00"
	 },
	 {
	   "key": "Financial impact migrants",
	   "value": 0.211,
	   "date": "03/18/15 00:00"
	 },
	 {
	   "key": "EU migrant crisis",
	   "value": 0.152,
	   "date": "03/01/15 00:00"
	 },
	 {
	   "key": "EU migrant crisis",
	   "value": 0.17,
	   "date": "03/02/15 00:00"
	 },
	 {
	   "key": "EU migrant crisis",
	   "value": 0.168,
	   "date": "03/05/15 00:00"
	 },
	 {
	   "key": "EU migrant crisis",
	   "value": 0.159,
	   "date": "03/07/15 00:00"
	 },
	 {
	   "key": "EU migrant crisis",
	   "value": 0,
	   "date": "03/10/15 00:00"
	 },
	 {
	   "key": "EU migrant crisis",
	   "value": 0.152,
	   "date": "03/12/15 00:00"
	 },
	 {
	   "key": "EU migrant crisis",
	   "value": 0.171,
	   "date": "03/13/15 00:00"
	 },
	 {
	   "key": "EU migrant crisis",
	   "value": 0.154,
	   "date": "03/14/15 00:00"
	 },
	 {
	   "key": "EU migrant crisis",
	   "value": 0.166,
	   "date": "03/15/15 00:00"
	 },
	 {
	   "key": "EU migrant crisis",
	   "value": 0.166,
	   "date": "03/18/15 00:00"
	 }
	]
	            // Pull out values
	            data.forEach(function (d) {
	                d.date = format.parse(d.date);
	                d.value = +d.value;
	            });

	            // // Stack and nest layers
	           var layers = stack(nest.entries(data));



	            // Set input domains
	            // ------------------------------

	            // Horizontal
	            x.domain(d3.extent(data, function(d, i) { return d.date; }));

	            // Vertical
	           y.domain([0, d3.max(data, function(d) { return d.y0+d.y; })]);



	            // Add grid
	            // ------------------------------

	            // Horizontal grid. Must be before the group
	            svg.append("g")
	                .attr("class", "d3-grid-dashed")
	                .call(gridAxis);



	            // //
	            // // Append chart elements
	            // //
	            //
	            // // Stream layers
	            // // ------------------------------
	            //
	            // Create group
	            var group = svg.append('g')
	                .attr('class', 'streamgraph-layers-group');

	            // And append paths to this group
	            var layer = group.selectAll(".streamgraph-layer")
	                .data(layers)
	                .enter()
	                    .append("path")
	                    .attr("class", "streamgraph-layer")
	                    .attr("d", function(d) { return area(d.values); })
	                    .style('stroke', '#fff')
	                    .style('stroke-width', 0.5)
	                    .style("fill", function(d, i) { return z(i); });

	            // Add transition
	            var layerTransition = layer
	                .style('opacity', 0)
	                .transition()
	                    .duration(750)
	                    .delay(function(d, i) { return i * 50; })
	                    .style('opacity', 1)



	            // // Append axes
	            // // ------------------------------
	            //
	            // //
	            // // Left vertical
	            // //
	            //
	            svg.append("g")
	                .attr("class", "d3-axis d3-axis-left d3-axis-solid")
	                .call(yAxis.orient("left"));

	            // // Hide first tick
	            d3.select(svg.selectAll('.d3-axis-left .tick text')[0][0])
	                .style("visibility", "hidden");

	            //
	            // //
	            // // Right vertical
	            // //
	            //
	            svg.append("g")
	                .attr("class", "d3-axis d3-axis-right d3-axis-solid")
	                .attr("transform", "translate(" + width + ", 0)")
	                .call(yAxis2.orient("right"));

	            // // Hide first tick
	            d3.select(svg.selectAll('.d3-axis-right .tick text')[0][0])
	                .style("visibility", "hidden");


	            // //
	            // // Horizontal
	            // //
	            //
	            var xaxisg = svg.append("g")
	                .attr("class", "d3-axis d3-axis-horizontal d3-axis-solid")
	                .attr("transform", "translate(0," + height + ")")
	                .call(xAxis);

	            // Add extra subticks for hidden hours
	            xaxisg.selectAll(".d3-axis-subticks")
	                .data(x.ticks(d3.time.date), function(d) { return d; })
	                .enter()
	                .append("line")
	                .attr("class", "d3-axis-subticks")
	                .attr("y1", 0)
	                .attr("y2", 4)
	                .attr("x1", x)
	                .attr("x2", x);



	            // Add hover line and pointer
	            // ------------------------------

	            // Append group to the group of paths to prevent appearance outside chart area
	            var hoverLineGroup = group.append("g")
	                .attr("class", "hover-line");

	            // Add line
	            var hoverLine = hoverLineGroup
	                .append("line")
	                .attr("y1", 0)
	                .attr("y2", height)
	                .style('fill', 'none')
	                .style('stroke', '#fff')
	                .style('stroke-width', 1)
	                .style('pointer-events', 'none')
	                .style('shape-rendering', 'crispEdges')
	                .style("opacity", 0);

	            // Add pointer
	            var hoverPointer = hoverLineGroup
	                .append("rect")
	                .attr("x", 2)
	                .attr("y", 2)
	                .attr("width", 6)
	                .attr("height", 6)
	                .style('fill', '#03A9F4')
	                .style('stroke', '#fff')
	                .style('stroke-width', 1)
	                .style('shape-rendering', 'crispEdges')
	                .style('pointer-events', 'none')
	                .style("opacity", 0);



	            // Append events to the layers group
	            // ------------------------------

	            layerTransition.each("end", function() {
	                layer
	                    .on("mouseover", function (d, i) {
	                        svg.selectAll(".streamgraph-layer")
	                            .transition()
	                            .duration(250)
	                            .style("opacity", function (d, j) {
	                                return j != i ? 0.75 : 1; // Mute all except hovered
	                            });
	                    })

	                    .on("mousemove", function (d, i) {
	                        mouse = d3.mouse(this);
	                        mousex = mouse[0];
	                        mousey = mouse[1];
	                        datearray = [];
	                        var invertedx = x.invert(mousex);
	                        invertedx = invertedx.getDate();
	                        var selected = (d.values);
	                        for (var k = 0; k < selected.length; k++) {
	                            datearray[k] = selected[k].date
	                            datearray[k] = datearray[k].getDate();
	                        }
	                        mousedate = datearray.indexOf(invertedx);
	                        pro = d.values[mousedate].value;


	                        // Display mouse pointer
	                        hoverPointer
	                            .attr("x", mousex - 3)
	                            .attr("y", mousey - 6)
	                            .style("opacity", 1);

	                        hoverLine
	                            .attr("x1", mousex)
	                            .attr("x2", mousex)
	                            .style("opacity", 1);


	                        // Tooltip


	                        // Tooltip data
	                        tooltip.html(
	                            "<ul class='list-unstyled mb-5'>" +
	                                "<li>" + "<div class='text-size-base mt-5 mb-5'><i class='icon-circle-left2 position-left'></i>" + d.key + "</div>" + "</li>" +
	                                "<li>" + "Percentage: &nbsp;" + "<span class='text-semibold pull-right'>" + pro + "</span>" + "</li>" +
	                                "<li>" + "Date: &nbsp; " + "<span class='text-semibold pull-right'>" + format(d.values[mousedate].date) + "</span>" + "</li>" +
	                            "</ul>"
	                        )
	                        .style("display", "block");

	                        // Tooltip arrow
	                        tooltip.append('div').attr('class', 'd3-tip-arrow');
	                    })

	                    .on("mouseout", function (d, i) {

	                        // Revert full opacity to all paths
	                        svg.selectAll(".streamgraph-layer")
	                            .transition()
	                            .duration(250)
	                            .style("opacity", 1);

	                        // Hide cursor pointer
	                        hoverPointer.style("opacity", 0);

	                        // Hide tooltip
	                        tooltip.style("display", "none");

	                        hoverLine.style("opacity", 0);
	                    });
	                });


	            // Append events to the chart container
	            // ------------------------------
	            d3Container
	                .on("mousemove", function (d, i) {
	                    mouse = d3.mouse(this);
	                    mousex = mouse[0];
	                    mousey = mouse[1];

	                    // Display hover line
	                    // .style("opacity", 1);


	                    // Move tooltip vertically
	                    tooltip.style("top", (mousey - ($('.d3-tip').outerHeight() / 2)) - 2 + "px") // Half tooltip height - half arrow width

	                    // Move tooltip horizontally
	                    if(mousex >= ($(element).outerWidth() - $('.d3-tip').outerWidth() - margin.right - (tooltipOffset * 2))) {
	                        tooltip
	                            .style("left", (mousex - $('.d3-tip').outerWidth() - tooltipOffset) + "px") // Change tooltip direction from right to left to keep it inside graph area
	                            .attr("class", "d3-tip w");
	                    }
	                    else {
	                        tooltip
	                            .style("left", (mousex + tooltipOffset) + "px" )
	                            .attr("class", "d3-tip e");
	                    }
	                });

	        //});



	        // Resize chart
	        // ------------------------------

	        // Call function on window resize
	        $(window).on('resize', resizeStream);

	        // Call function on sidebar width change
	        // $('.sidebar-control').on('click', resizeStream);

	        // Resize function
	        //
	        // Since D3 doesn't support SVG resize by default,
	        // we need to manually specify parts of the graph that need to
	        // be updated on window resize
	        function resizeStream() {

	            // Layout
	            // -------------------------

	            // Define width
	            width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right;

	            // Main svg width
	            container.attr("width", width + margin.left + margin.right);

	            // Width of appended group
	            svg.attr("width", width + margin.left + margin.right);

	            // Horizontal range
	            x.range([0, width]);


	            // Chart elements
	            // -------------------------

	            // Horizontal axis
	            svg.selectAll('.d3-axis-horizontal').call(xAxis);

	            // Horizontal axis subticks
	            svg.selectAll('.d3-axis-subticks').attr("x1", x).attr("x2", x);

	            // Grid lines width
	            svg.selectAll(".d3-grid-dashed").call(gridAxis.tickSize(-width, 0, 0))

	            // Right vertical axis
	            svg.selectAll(".d3-axis-right").attr("transform", "translate(" + width + ", 0)");

	            // Area paths
	            svg.selectAll('.streamgraph-layer').attr("d", function(d) { return area(d.values); });
	        }
	    }

	});
 </script>
<script type="text/javascript" src="assets/vendors/d3/d3.v4.min.js"></script>
 <script>
 $(function () {

clusterdiagram('#clusterdiagram', 330);

// Chart setup
function clusterdiagram(element, height) {

  var nodes = [
    { id: "mammal", group: 0, label: "Mammals", level: 1 },
    { id: "dog"   , group: 0, label: "Dogs"   , level: 2 },
    { id: "cat"   , group: 0, label: "Cats"   , level: 2 },
    { id: "fox"   , group: 0, label: "Foxes"  , level: 2 },
    { id: "elk"   , group: 0, label: "Elk"    , level: 2 },
    { id: "insect", group: 1, label: "Insects", level: 1 },
    { id: "ant"   , group: 1, label: "Ants"   , level: 2 },
    { id: "bee"   , group: 1, label: "Bees"   , level: 2 },
    { id: "fish"  , group: 2, label: "Fish"   , level: 1 },
    { id: "carp"  , group: 2, label: "Carp"   , level: 2 },
    { id: "pike"  , group: 2, label: "Pikes"  , level: 2 }
  ]

  var links = [
  	{ target: "mammal", source: "dog" , strength: 3.0 },
  	{ target: "mammal", source: "dog" , strength: 3.0 },
    { target: "mammal", source: "fox" , strength: 3.0 },
    { target: "mammal", source: "dog" , strength: 3.0 },
    { target: "insect", source: "ant" , strength: 0.7 },
    { target: "insect", source: "bee" , strength: 0.7 },
    { target: "fish"  , source: "carp", strength: 0.7 },
    { target: "fish"  , source: "pike", strength: 0.7 },
    { target: "cat"   , source: "elk" , strength: 0.1 },
    { target: "carp"  , source: "ant" , strength: 0.1 },
    { target: "elk"   , source: "bee" , strength: 0.1 },
    { target: "dog"   , source: "cat" , strength: 0.1 },
    { target: "fox"   , source: "ant" , strength: 0.1 },
  	{ target: "pike"  , source: "cat" , strength: 0.1 }
  ]

     // Define main variables
     var d3Container = d3v4.select(element),
         margin = {top: 10, right: 10, bottom: 20, left: 20},
         width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right,
         height = height - margin.top - margin.bottom;

    var colors = d3v4.scaleOrdinal(d3v4.schemeCategory10);

     // Add SVG element
     var container = d3Container.append("svg");

     // Add SVG group
     var svg = container
         .attr("width", width + margin.left + margin.right)
         .attr("height", height + margin.top + margin.bottom);
        //.append("g")
      //   .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

      // simulation setup with all forces
   var linkForce = d3v4
  .forceLink()
  .id(function (link) { return link.id })
  .strength(function (link) { return link.strength })

      // simulation setup with all forces
      var simulation = d3v4
        .forceSimulation()
        .force('link', linkForce)
        .force('charge', d3v4.forceManyBody().strength(-50))
        .force('center', d3v4.forceCenter(width / 2, height / 2))

        var linkElements = svg.append("g")
          .attr("class", "links")
          .selectAll("line")
          .data(links)
          .enter().append("line")
            .attr("stroke-width", 0)
        	  .attr("stroke", "rgba(50, 50, 50, 0.2)")

      function getNodeColor(node) {
        return node.level === 1 ? 'red' : 'gray'
      }

      var nodeElements = svg.append("g")
        .attr("class", "nodes")
        .selectAll("circle")
        .data(nodes)
        .enter().append("circle")
          .attr("r", 5)
          .attr("fill", function (d, i) {return colors(d.group);})

      var textElements = svg.append("g")
        .attr("class", "texts")
        .selectAll("text")
        .data(nodes)
        .enter().append("text")
          .text(function (node) { return  node.label })
      	  .attr("font-size", 15)
      	  .attr("dx", 15)
          .attr("dy", 4)

        simulation.nodes(nodes).on('tick', () => {
          nodeElements
            .attr('cx', function (node) { return node.x })
            .attr('cy', function (node) { return node.y })
          textElements
            .attr('x', function (node) { return node.x })
            .attr('y', function (node) { return node.y })
            linkElements
    .attr('x1', function (link) { return link.source.x })
    .attr('y1', function (link) { return link.source.y })
    .attr('x2', function (link) { return link.target.x })
    .attr('y2', function (link) { return link.target.y })
        })


simulation.force("link").links(links)
}

});
 </script>

<!--word cloud  -->
 <script>

     var frequency_list = [{"text":"study","size":40},{"text":"motion","size":15},{"text":"forces","size":10},{"text":"electricity","size":15},{"text":"movement","size":10},{"text":"relation","size":5},{"text":"things","size":10},{"text":"force","size":5},{"text":"ad","size":5},{"text":"energy","size":85},{"text":"living","size":5},{"text":"nonliving","size":5},{"text":"laws","size":15},{"text":"speed","size":45},{"text":"velocity","size":30},{"text":"define","size":5},{"text":"constraints","size":5},{"text":"universe","size":10},{"text":"distinguished","size":5},{"text":"chemistry","size":5},{"text":"biology","size":5},{"text":"includes","size":5},{"text":"radiation","size":5},{"text":"sound","size":5},{"text":"structure","size":5},{"text":"atoms","size":5},{"text":"including","size":10},{"text":"atomic","size":10},{"text":"nuclear","size":10},{"text":"cryogenics","size":10},{"text":"solid-state","size":10},{"text":"particle","size":10},{"text":"plasma","size":10},{"text":"deals","size":5},{"text":"merriam-webster","size":5},{"text":"dictionary","size":10},{"text":"analysis","size":5},{"text":"conducted","size":5},{"text":"order","size":5},{"text":"understand","size":5},{"text":"behaves","size":5},{"text":"en","size":5},{"text":"wikipedia","size":5},{"text":"wiki","size":5},{"text":"physics-","size":5},{"text":"physical","size":5},{"text":"behaviour","size":5},{"text":"collinsdictionary","size":5},{"text":"english","size":5},{"text":"time","size":35},{"text":"distance","size":35},{"text":"wheels","size":5},{"text":"revelations","size":5},{"text":"minute","size":5},{"text":"acceleration","size":20},{"text":"torque","size":5},{"text":"wheel","size":5},{"text":"rotations","size":5},{"text":"resistance","size":5},{"text":"momentum","size":5},{"text":"measure","size":10},{"text":"direction","size":10},{"text":"car","size":5},{"text":"add","size":5},{"text":"traveled","size":5},{"text":"weight","size":5},{"text":"electrical","size":5},{"text":"power","size":5}];


     var color = d3.scale.linear()
             .domain([0,1,2,3,4,5,6,10,15,20,50])
             .range(["#17394C", "#F5CC0E", "#CE0202", "#1F90D0", "#999", "#888", "#777", "#666", "#555", "#444", "#333", "#222"]);

     d3.layout.cloud().size([300, 300])
             .words(frequency_list)
             .rotate(0)
             .fontSize(function(d) { return d.size; })
             .on("end", draw)
             .start();

     function draw(words) {
         d3.select(".tagcloudcontainer").append("svg")
                 .attr("width", 300)
                 .attr("height", 300)
                 .attr("class", "wordcloud")
                 .append("g")
                 // without the transform, words words would get cutoff to the left and top, they would
                 // appear outside of the SVG area
                 .attr("transform", "translate(80,150)")
                 .selectAll("text")
                 .data(words)
                 .enter().append("text")
                 .style("font-size", function(d) { return d.size + "px"; })
                 .style("fill", function(d, i) { return color(i); })
                 .attr("transform", function(d) {
                     return "translate(" + [d.x + 2, d.y + 3] + ")rotate(" + d.rotate + ")";
                 })

                 .text(function(d) { return d.text; });
     }
 </script>
 <script>
 /*//////////////////////////////////////////////////////////
 ////////////////// Set up the Data /////////////////////////
 //////////////////////////////////////////////////////////*/

 $(function () {

 chordDiagram("#chorddiagram", 300)

 function chordDiagram(element, height) {

 var NameProvider = ["Apple","HTC","Huawei","LG","Nokia","Samsung","Sony","Other"];

 var matrix = [
 [9.6899,0.8859,0.0554,0.443,2.5471,2.4363,0.5537,2.5471], /*Apple 19.1584*/
 [0.1107,1.8272,0,0.4983,1.1074,1.052,0.2215,0.4983], /*HTC 5.3154*/
 [0.0554,0.2769,0.2215,0.2215,0.3876,0.8306,0.0554,0.3322], /*Huawei 2.3811*/
 [0.0554,0.1107,0.0554,1.2182,1.1628,0.6645,0.4983,1.052], /*LG 4.8173*/
 [0.2215,0.443,0,0.2769,10.4097,1.2182,0.4983,2.8239], /*Nokia 15.8915*/
 [1.1628,2.6024,0,1.3843,8.7486,16.8328,1.7165,5.5925], /*Samsung 38.0399*/
 [0.0554,0.4983,0,0.3322,0.443,0.8859,1.7719,0.443], /*Sony 4.4297*/
 [0.2215,0.7198,0,0.3322,1.6611,1.495,0.1107,5.4264] /*Other 9.9667*/
 ];
 /*Sums up to exactly 100*/

 var colors = ["#C4C4C4","#69B40F","#EC1D25","#C8125C","#008FC8","#10218B","#134B24","#737373"];

 // Define main variables of the container
 var d3Container = d3.select(element),
     margin = {top: 30, right: 10, bottom: 20, left: 25},
     width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right,
     height = height - margin.top - margin.bottom;

 /*Initiate the color scale*/
 var fill = d3.scale.ordinal()
     .domain(d3.range(NameProvider.length))
     .range(colors);

 /*//////////////////////////////////////////////////////////
 /////////////// Initiate Chord Diagram /////////////////////
 //////////////////////////////////////////////////////////*/
 // var margin = {top: 30, right: 25, bottom: 20, left: 25},
 //     width = 650 - margin.left - margin.right,
 //     height = 600 - margin.top - margin.bottom,
   var innerRadius = Math.min(width, height) * .38,
     outerRadius = innerRadius * 1.03;

      var container = d3Container.append("svg:svg");

 /*Initiate the SVG*/
 // var svg = d3.select("#chart").append("svg:svg")
 var svg = container
     .attr("width", width + margin.left + margin.right)
     .attr("height", height + margin.top + margin.bottom)
 	.append("svg:g")
     .attr("transform", "translate(" + (margin.left + width/2) + "," + (margin.top + height/2) + ")");


 var chord = d3.layout.chord()
     .padding(.04)
     .sortSubgroups(d3.descending) /*sort the chords inside an arc from high to low*/
     .sortChords(d3.descending) /*which chord should be shown on top when chords cross. Now the biggest chord is at the bottom*/
 	.matrix(matrix);


 /*//////////////////////////////////////////////////////////
 ////////////////// Draw outer Arcs /////////////////////////
 //////////////////////////////////////////////////////////*/

 var arc = d3.svg.arc()
     .innerRadius(innerRadius)
     .outerRadius(outerRadius);

 var g = svg.selectAll("g.group")
 	.data(chord.groups)
 	.enter().append("svg:g")
 	.attr("class", function(d) {return "group " + NameProvider[d.index];});

 g.append("svg:path")
 	  .attr("class", "arc")
 	  .style("stroke", function(d) { return fill(d.index); })
 	  .style("fill", function(d) { return fill(d.index); })
 	  .attr("d", arc)
 	  .style("opacity", 0)
 	  .transition().duration(1000)
 	  .style("opacity", 0.4);

 /*//////////////////////////////////////////////////////////
 ////////////////// Initiate Ticks //////////////////////////
 //////////////////////////////////////////////////////////*/

 var ticks = svg.selectAll("g.group").append("svg:g")
 	.attr("class", function(d) {return "ticks " + NameProvider[d.index];})
 	.selectAll("g.ticks")
 	.attr("class", "ticks")
     .data(groupTicks)
 	.enter().append("svg:g")
     .attr("transform", function(d) {
       return "rotate(" + (d.angle * 180 / Math.PI - 90) + ")"
           + "translate(" + outerRadius+40 + ",0)";
     });

 /*Append the tick around the arcs*/
 ticks.append("svg:line")
 	.attr("x1", 1)
 	.attr("y1", 0)
 	.attr("x2", 5)
 	.attr("y2", 0)
 	.attr("class", "ticks")
 	.style("stroke", "#FFF");

 /*Add the labels for the %'s*/
 ticks.append("svg:text")
 	.attr("x", 8)
 	.attr("dy", ".35em")
 	.attr("class", "tickLabels")
 	.attr("transform", function(d) { return d.angle > Math.PI ? "rotate(180)translate(-16)" : null; })
 	.style("text-anchor", function(d) { return d.angle > Math.PI ? "end" : null; })
 	.text(function(d) { return d.label; })
 	.attr('opacity', 0);

 /*//////////////////////////////////////////////////////////
 ////////////////// Initiate Names //////////////////////////
 //////////////////////////////////////////////////////////*/

 g.append("svg:text")
   .each(function(d) { d.angle = (d.startAngle + d.endAngle) / 2; })
   .attr("dy", ".35em")
   .attr("class", "titles")
   .attr("text-anchor", function(d) { return d.angle > Math.PI ? "end" : null; })
   .attr("transform", function(d) {
 		return "rotate(" + (d.angle * 180 / Math.PI - 90) + ")"
 		+ "translate(" + (innerRadius + 55) + ")"
 		+ (d.angle > Math.PI ? "rotate(180)" : "");
   })
   .attr('opacity', 0)
   .text(function(d,i) { return NameProvider[i]; });

 /*//////////////////////////////////////////////////////////
 //////////////// Initiate inner chords /////////////////////
 //////////////////////////////////////////////////////////*/

 var chords = svg.selectAll("path.chord")
 	.data(chord.chords)
 	.enter().append("svg:path")
 	.attr("class", "chord")
 	.style("stroke", function(d) { return d3.rgb(fill(d.source.index)).darker(); })
 	.style("fill", function(d) { return fill(d.source.index); })
 	.attr("d", d3.svg.chord().radius(innerRadius))
 	.attr('opacity', 0);

 /*//////////////////////////////////////////////////////////
 ///////////// Initiate Progress Bar ////////////////////////
 //////////////////////////////////////////////////////////*/
 /*Initiate variables for bar*/
 var progressColor = ["#D1D1D1","#949494"],
 	progressClass = ["prgsBehind","prgsFront"],
 	prgsWidth = 0.4*650,
 	prgsHeight = 3;
 /*Create SVG to visualize bar in*/
 var progressBar = d3.select("#progress").append("svg")
 	.attr("width", prgsWidth)
 	.attr("height", 3*prgsHeight);
 /*Create two bars of which one has a width of zero*/
 progressBar.selectAll("rect")
 	.data([prgsWidth, 0])
 	.enter()
 	.append("rect")
 	.attr("class", function(d,i) {return progressClass[i];})
 	.attr("x", 0)
 	.attr("y", 0)
 	.attr("width", function (d) {return d;})
 	.attr("height", prgsHeight)
 	.attr("fill", function(d,i) {return progressColor[i];});

 /*//////////////////////////////////////////////////////////
 /////////// Initiate the Center Texts //////////////////////
 //////////////////////////////////////////////////////////*/
 /*Create wrapper for center text*/
 var textCenter = svg.append("g")
 					.attr("class", "explanationWrapper");

 /*Starting text middle top*/
 var middleTextTop = textCenter.append("text")
 	.attr("class", "explanation")
 	.attr("text-anchor", "middle")
 	.attr("x", 0 + "px")
 	.attr("y", -24*10/2 + "px")
 	.attr("dy", "1em")
 	.attr("opacity", 1)
 	.text("")
 	.call(wrap, 350);

 /*Starting text middle bottom*/
 var middleTextBottom = textCenter.append("text")
 	.attr("class", "explanation")
 	.attr("text-anchor", "middle")
 	.attr("x", 0 + "px")
 	.attr("y", 24*3/2 + "px")
 	.attr("dy", "1em")
 	.attr('opacity', 1)
 	.text("")
 	.call(wrap, 350);

 /*//////////////////////////////////////////////////////////
 //////////////// Storyboarding Steps ///////////////////////
 //////////////////////////////////////////////////////////*/

 var counter = 1,
 	buttonTexts = ["Ok","Go on","Continue","Okay","Go on","Continue","Okay","Continue",
 				   "Continue","Continue","Continue","Continue","Continue","Finish"],
 	opacityValueBase = 0.8,
 	opacityValue = 0.4;

 /*Reload page*/
 d3.select("#reset")
 	.on("click", function(e) {location.reload();});

 /*Skip to final visual right away*/
 d3.select("#skip")
 	.on("click", finalChord);


 /*Order of steps when clicking button*/
 d3.select("#clicker")
 	.on("click", function(e){

 		if(counter == 1) Draw1();
 		else if(counter == 2) Draw2();
 		else if(counter == 3) Draw3();
 		else if(counter == 4) Draw4();
 		else if(counter == 5) Draw5();
 		else if(counter == 6) Draw6();
 		else if(counter == 7) Draw7();
 		else if(counter == 8) Draw8();
 		else if(counter == 9) Draw9();
 		else if(counter == 10) Draw10();
 		else if(counter == 11) Draw11();
 		else if(counter == 12) Draw12();
 		else if(counter == 13) Draw13();
 		else if(counter == 14) Draw14();
 		else if(counter == 15) finalChord();

 		counter = counter + 1;
 	});

   /*///////////////////////////////////////////////////////////
   //Draw the original Chord diagram
   ///////////////////////////////////////////////////////////*/
   /*Go to the final bit*/


   function finalChord() {

   	/*Remove button*/
   	d3.select("#clicker")
   		.style("visibility", "hidden");
   	d3.select("#skip")
   		.style("visibility", "hidden");
   	d3.select("#progress")
   		.style("visibility", "hidden");

   	/*Remove texts*/
   	changeTopText(newText = "",
   		loc = 0, delayDisappear = 0, delayAppear = 1);
   	changeBottomText(newText = "",
   		loc = 0, delayDisappear = 0, delayAppear = 1);

   	/*Create arcs or show them, depending on the point in the visual*/
   	if (counter <= 4 ) {
   		g.append("svg:path")
   		  .style("stroke", function(d) { return fill(d.index); })
   		  .style("fill", function(d) { return fill(d.index); })
   		  .attr("d", arc)
   		  .style("opacity", 0)
   		  .transition().duration(1000)
   		  .style("opacity", 1);

   	} else {
   		 /*Make all arc visible*/
   		svg.selectAll("g.group").select("path")
   			.transition().duration(1000)
   			.style("opacity", 1);
   	};

   	/*Make mouse over and out possible*/
   	// d3.selectAll(".group")
   	// 	.on("mouseover", fade(.02))
   	// 	.on("mouseout", fade(.80));

   	/*Show all chords*/
   	chords.transition().duration(1000)
   		.style("opacity", opacityValueBase);

   	/*Show all the text*/
   	d3.selectAll("g.group").selectAll("line")
   		.transition().duration(100)
   		.style("stroke","#000");
   	/*Same for the %'s*/

   	svg.selectAll("g.group")
   		.transition().duration(100)
   		.selectAll(".tickLabels").style("opacity",1);
   	/*And the Names of each Arc*/

   	svg.selectAll("g.group")
   		.transition().duration(100)
   		.selectAll(".titles").style("opacity",1);

   };
   /*finalChord*/
   /*//////////////////////////////////////////////////////////
   ////////////////// Extra Functions /////////////////////////
   //////////////////////////////////////////////////////////*/

   /*Returns an event handler for fading a given chord group*/
   function fade(opacity) {
     return function(d, i) {
       svg.selectAll("path.chord")
           .filter(function(d) { return d.source.index != i && d.target.index != i; })
   		.transition()
           .style("stroke-opacity", opacity)
           .style("fill-opacity", opacity);
     };
   };/*fade*/

   /*Returns an array of tick angles and labels, given a group*/
   function groupTicks(d) {
     var k = (d.endAngle - d.startAngle) / d.value;
     return d3.range(0, d.value, 1).map(function(v, i) {
       return {
         angle: v * k + d.startAngle,
         label: i % 5 ? null : v + "%"
       };
     });
   };/*groupTicks*/

   /*Taken from https://groups.google.com/forum/#!msg/d3-js/WC_7Xi6VV50/j1HK0vIWI-EJ
   //Calls a function only after the total transition ends*/
   function endall(transition, callback) {
       var n = 0;
       transition
           .each(function() { ++n; })
           .each("end", function() { if (!--n) callback.apply(this, arguments); });
   };/*endall*/

   /*Taken from http://bl.ocks.org/mbostock/7555321
   //Wraps SVG text*/
   function wrap(text, width) {
       var text = d3.select(this)[0][0],
           words = text.text().split(/\s+/).reverse(),
           word,
           line = [],
           lineNumber = 0,
           lineHeight = 1.4,
           y = text.attr("y"),
   		x = text.attr("x"),
           dy = parseFloat(text.attr("dy")),
           tspan = text.text(null).append("tspan").attr("x", x).attr("y", y).attr("dy", dy + "em");

       while (word = words.pop()) {
         line.push(word);
         tspan.text(line.join(" "));
         if (tspan.node().getComputedTextLength() > width) {
           line.pop();
           tspan.text(line.join(" "));
           line = [word];
           tspan = text.append("tspan").attr("x", x).attr("y", y).attr("dy", ++lineNumber * lineHeight + dy + "em").text(word);
         };
       };
   };

   /*Transition the top circle text*/
   function changeTopText (newText, loc, delayDisappear, delayAppear, finalText, xloc, w) {

   	/*If finalText is not provided, it is not the last text of the Draw step*/
   	if(typeof(finalText)==='undefined') finalText = false;

   	if(typeof(xloc)==='undefined') xloc = 0;
   	if(typeof(w)==='undefined') w = 350;

   	middleTextTop
   		/*Current text disappear*/
   		.transition().delay(700 * delayDisappear).duration(700)
   		.attr('opacity', 0)
   		/*New text appear*/
   		.call(endall,  function() {
   			middleTextTop.text(newText)
   			.attr("y", -24*loc + "px")
   			.attr("x", xloc + "px")
   			.call(wrap, w);
   		})
   		.transition().delay(700 * delayAppear).duration(700)
   		.attr('opacity', 1)
   		.call(endall,  function() {
   			if (finalText == true) {
   				d3.select("#clicker")
   					.text(buttonTexts[counter-2])
   					.style("pointer-events", "auto")
   					.transition().duration(400)
   					.style("border-color", "#363636")
   					.style("color", "#363636");
   				};
   		});
   };/*changeTopText */

   /*Transition the bottom circle text*/
   function changeBottomText (newText, loc, delayDisappear, delayAppear) {
   	middleTextBottom
   		/*Current text disappear*/
   		.transition().delay(700 * delayDisappear).duration(700)
   		.attr('opacity', 0)
   		/*New text appear*/
   		.call(endall,  function() {
   			middleTextBottom.text(newText)
   			.attr("y", 24*loc + "px")
   			.call(wrap, 350);
   		})
   		.transition().delay(700 * delayAppear).duration(700)
   		.attr('opacity', 1);
   ;}/*changeTopText*/

   /*Stop clicker from working*/
   function stopClicker() {
   	d3.select("#clicker")
   		.style("pointer-events", "none")
   		.transition().duration(400)
   		.style("border-color", "#D3D3D3")
   		.style("color", "#D3D3D3");
   };/*stopClicker*/

   /*Run the progress bar during an animation*/
   function runProgressBar(time) {

   	/*Make the progress div visible*/
   	d3.selectAll("#progress")
   		.style("visibility", "visible");

   	/*Linearly increase the width of the bar
   	//After it is done, hide div again*/
   	d3.selectAll(".prgsFront")
   		.transition().duration(time).ease("linear")
   		.attr("width", prgsWidth)
   		.call(endall,  function() {
   			d3.selectAll("#progress")
   				.style("visibility", "hidden");
   		});

   	/*Reset to zero width*/
   	d3.selectAll(".prgsFront")
   		.attr("width", 0);

   };/*runProgressBar*/

 $(window).on("load",finalChord);
 $(window).on('resize', resize);

 // Call function on sidebar width change
 $('.sidebar-control').on('click', resize);

 // Resize function
 //
 // Since D3 doesn't support SVG resize by default,
 // we need to manually specify parts of the graph that need to
 // be updated on window resize
 function resize() {

   // Layout variables
   width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right;
   //
   //
   // // Layout
   // // -------------------------
   //
   // // Main svg width
   container.attr("width", width + margin.left + margin.right);
   //
   // // Width of appended group
   svg.attr("width", width + margin.left + margin.right);
   //
   //
   // // Axes
   // // -------------------------
   //
   // // Horizontal range
   // x.rangeRoundBands([0, width],.72,.5);
   //
   // // Horizontal axis
   // svg.selectAll('.d3-axis-horizontal').call(xAxis);
   // svg.selectAll("circle")
   //
   //
   // // Chart elements
   // // -------------------------
   //
   // // Line path
   // svg.selectAll('.d3-line').attr("d", line);



     // svg.selectAll(".circle-point")
     // .attr("cx",function(d) { return x(d.date);})
     // .attr("cy", function(d){return y(d.close)});


   //
   // // Crosshair
   // svg.selectAll('.d3-crosshair-overlay').attr("width", width);

 }
 }

});
 </script>
</body>
</html>
