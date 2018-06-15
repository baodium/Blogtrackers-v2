<%@page import="authentication.*"%>
<%@page import="java.util.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.File"%>
<%
Object email = (null == session.getAttribute("email")) ? "" : session.getAttribute("email");

if (email == null || email == "") {
	response.sendRedirect("index.jsp");
}

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
//pimage = pimage.replace("build/", "");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Blogtrackers</title>
  <!-- start of bootsrap -->
  <link rel="shortcut icon" href="images/favicons/favicon.ico">
  <link rel="apple-touch-icon" href="images/favicons/favicon-48x48.png">
  <link rel="apple-touch-icon" sizes="96x96" href="images/favicons/favicon-96x96.png">
  <link rel="apple-touch-icon" sizes="144x144" href="images/favicons/favicon-144x144.png">

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
<!-- <link rel="stylesheet" href="assets/css/bar.css" /> -->
  <!--end of bootsrap -->
  <script src="assets/js/jquery-3.2.1.slim.min.js"></script>
<script src="assets/js/popper.min.js"></script>
</head>
<body>

<div class="modal-notifications">
<div class="row">
  <div class="offset-lg-10 col-lg-2 col-md-12 notificationpanel">
    <div id="closeicon" class="cursor-pointer"><i class="fas fa-times-circle"></i></div>
  <div class="profilesection col-md-12 mt50">
    <div class="text-center mb10" ><img src="<%=profileimage%>" width="60" height="60" onerror="this.src='images/default-avatar.png'" alt="" /></div>
    <div class="text-center" style="margin-left:0px;">
      <h6 class="text-primary m0 bolder profiletext"><%=name%></h6>
      <p class="text-primary profiletext"><%=email%></p>
    </div>

  </div>
  <div id="othersection" class="col-md-12 mt10" style="clear:both">
  <a class="cursor-pointer profilemenulink" href="notifications.html"><h6 class="text-primary">Notifications <b id="notificationcount" class="cursor-pointer">12</b></h6> </a>
  <a class="cursor-pointer profilemenulink" href="<%=request.getContextPath()%>/profile.jsp"><h6  class="text-primary">Profile</h6></a>
  <a class="cursor-pointer profilemenulink" href="<%=request.getContextPath()%>/logout"><h6 class="text-primary">Log Out</h6></a>
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
  <img src="<%=profileimage%>" width="50" height="50" onerror="this.src='images/default-avatar.png'" alt="" class="" />
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
<!-- <div class="profilenavbar" style="visibility:hidden;"></div> -->


    </nav>
 

<div class="container">
<div class="row">
<div class="col-md-6 paddi">
<nav class="breadcrumb">
  <a class="breadcrumb-item text-primary" href="trackerlist.html">MY TRACKER</a>
  <a class="breadcrumb-item text-primary" href="#">Second Tracker</a>
  <a class="breadcrumb-item active text-primary" href="#">Dashboard</a>
  </nav>
<div>Tracking: <button class="btn btn-primary stylebutton1">All Blogs</button></div>
</div>

<div class="col-md-6 text-right mt10">
<div class="text-primary demo"><h6 id="reportrange">Date: <span>02/21/18 - 02/28/18</span></h6></div>
<div>
  <div class="btn-group mt5" data-toggle="buttons">
  <label class="btn btn-primary btn-sm daterangebutton legitRipple nobgnoborder"> <input type="radio" name="options" value="day" autocomplete="off" > Day
  	</label>
    <label class="btn btn-primary btn-sm nobgnoborder"> <input type="radio" name="options" value="week" autocomplete="off" >Week
  	</label>
     <label class="btn btn-primary btn-sm nobgnoborder"> <input type="radio" name="options" value="month" autocomplete="off" > Month
  	</label>
    <label class="btn btn-primary btn-sm text-center nobgnoborder">Year <input type="radio" name="options" value="year" autocomplete="off" >
  	</label>
    <label class="btn btn-primary btn-sm nobgnoborder" id="custom">Custom</label>
  </div>

</div>
</div>

</div>

<div class="row p0 pt20 pb20 border-top-bottom mt20 mb20">
<div class="col-md-2">
<div class="card nocoloredcard mt10 mb10">
<div class="card-body p0 pt5 pb5">
<h5 class="text-primary mb0"><i class="fas fa-file-alt icondash"></i>Blogs</h5>
<h3 class="text-blue mb0 countdash">200</h3>
</div>
</div>
</div>

<div class="col-md-2">
<div class="card nocoloredcard mt10 mb10">
<div class="card-body p0 pt5 pb5">
<h5 class="text-primary mb0"><i class="fas fa-user icondash"></i>Bloggers</h5>
<h3 class="text-blue mb0 countdash">58</h3>
</div>
</div>
</div>

<div class="col-md-2">
<div class="card nocoloredcard mt10 mb10">
<div class="card-body p0 pt5 pb5">
<h5 class="text-primary mb0"><i class="fas fa-file-alt icondash"></i>Posts</h5>
<h3 class="text-blue mb0 countdash">40,0000</h3>
</div>
</div>
</div>

<div class="col-md-2">
<div class="card nocoloredcard mt10 mb10">
<div class="card-body p0 pt5 pb5">
<h5 class="text-primary mb0"><i class="fas fa-comment icondash"></i>Comments</h5>
<h3 class="text-blue mb0 countdash">16,0000</h3>
</div>
</div>
</div>


<div class="col-md-4">
  <div class="card nocoloredcard mt10 mb10">
  <div class="card-body p0 pt5 pb5">
<h5 class="text-primary mb0"><i class="fas fa-clock icondash"></i>History</h5>
<h3 class="text-blue mb0 countdash">Feb 2, 2016 - Jun 6, 2018 </h3>
</div>
</div>
</div>

</div>

<div class="row mb0">
  <div class="col-md-6 mt20 ">
    <div class="card card-style mt20">
      <div class="card-body  p15 pt15 pb15">
        <div><p class="text-primary mt0 float-left">Most Active Location <b >Blogs</b> of Past <b>Week</b></p></div>
        <div style="min-height: 490px;">
<div class="map-container map-choropleth"></div>
        </div>
          </div>
    </div>
  </div>

  <div class="col-md-6 mt20">
    <div class="card  card-style  mt20">
      <div class="card-body  p30 pt5 pb5">
        <div><p class="text-primary mt10 float-left">Language Usage of <b >Blogs</b> of Past <b>Week</b></p></div>
        <div class="min-height-table" style="min-height: 500px;">
        <div class="chart-container">
        <div class="chart" id="languageusage">
                      </div>
        </div>
      </div>
          </div>
    </div>
  </div>
</div>

<div class="row mb0">
  <div class="col-md-6 mt20 ">
    <div class="card card-style mt20">
      <div class="card-body  p30 pt5 pb5">
        <div><p class="text-primary mt10">Top Keywords of <b class="text-primary">Blog</b> of Past <b class="text-primary">Week</b></p></div>
        <div class="tagcloudcontainer" style="min-height: 420px;">

        </div>
          </div>
    </div>
    <div class="float-right"><a href=""><button class="btn buttonportfolio2 mt10"><b class="float-left semi-bold-text">Keyword Trend Analysis </b> <b class="fas fa-search float-right icondash2"></b></button></a></div>
  </div>

  <div class="col-md-6 mt20">
    <div class="card card-style mt20">
      <div class="card-body  p30 pt5 pb5">
        <div><p class="text-primary mt10">Sentiment Usage of <b>Blogs</b> of Past <b>Week</b></p></div>
        <div style="min-height: 420px;">
          <div class="chart-container">
            <div class="chart" id="sentimentbar"></div>
          </div>
        </div>
          </div>
    </div>
    <div class="float-right"><a href=""><button class="btn buttonportfolio2 mt10"><b class="float-left semi-bold-text">Sentiment Analysis </b> <b class="fas fa-adjust float-right icondash2"></b></button></a></div>
  </div>
</div>

<div class="row mb0">
  <div class="col-md-6 mt20">
    <div class="card card-style mt20">
      <div class="card-body   p30 pt5 pb5">
        <div><p class="text-primary mt10 float-left">Blog Distribution of Past <b>Week</b></p></div>
        <div class="min-height-table" style="min-height: 500px;">
        <div class="chart-container">
        <div class="chart" id="bubblesblog">
                      </div>
        </div>
      </div>
          </div>
    </div>
    <div class="float-right"><a href=""><button class="btn buttonportfolio2 mt10"><b class="float-left semi-bold-text">Blog Portfolio Analysis</b> <b class="fas fa-file-alt float-right icondash2"></b></button></a></div>

  </div>

  <div class="col-md-6 mt20">
    <div class="card card-style mt20">
      <div class="card-body p30 pt5 pb5">
          <div><p class="text-primary mt10 float-left">Blogger Distribution of Past <b>Week</b></p></div>
        <div class="min-height-table" style="min-height: 450px;">
        <div class="chart-container">
        <div class="chart" id="bubblesblogger">
                      </div>
        </div>
      </div>
          </div>
    </div>
    <div class="float-right"><a href=""><button class="btn buttonportfolio2 mt10"><b class="float-left semi-bold-text">Blogger Portfolio Analysis </b> <b class="fas fa-user float-right icondash2"></b></button></a></div>

  </div>

</div>

<div class="row mb0">
  <div class="col-md-6 mt20">
    <div class="card card-style mt20">
      <div class="card-body   p30 pt5 pb5">
        <div><p class="text-primary mt10 float-left">Most Active <b>Blogs</b> of Past <b>Week</b></p></div>
        <div class="min-height-table" style="min-height: 500px;">
        <div class="chart-container">
        <div class="chart" id="postingfrequencybar">
                      </div>
        </div>
      </div>
          </div>
    </div>
    <div class="float-right"><a href=""><button class="btn buttonportfolio2 mt10"><b class="float-left semi-bold-text">Posting Frequency Analysis</b> <b class="fas fa-comment-alt float-right icondash2"></b></button></a></div>

  </div>

  <div class="col-md-6 mt20">
    <div class="card card-style mt20">
      <div class="card-body p30 pt5 pb5">
        <div><p class="text-primary mt10 float-left">Most Influential <b>Blogs</b> of Past <b>Week</b></p></div>
        <div class="min-height-table" style="min-height: 500px;">
        <div class="chart-container">
        <div class="chart" id="influencebar">
                      </div>
        </div>
      </div>
          </div>
    </div>
    <div class="float-right"><a href=""><button class="btn buttonportfolio2 mt10"><b class="float-left semi-bold-text">Sentiment Analysis </b> <b class="fas fa-exchange-alt float-right icondash2"></b></button></a></div>

  </div>

</div>

<div class="row mb50">
  <div class="col-md-6 mt20 ">
    <div class="card card-style mt20">
      <div class="card-body  p5 pt10 pb10">

        <div style="min-height: 420px;">
          <div><p class="text-primary p15 pb5 pt0">List of Top Domains of <b >Blogs</b> of Past <b>Week</b></p></div>
          <div class="p15 pb5 pt0" role="group">
          Export Options
          </div>
                <table id="DataTables_Table_0_wrapper" class="display" style="width:100%">
                        <thead>
                            <tr>
                                <th>Domain</th>
                                <th>Frequency</th>

                            </tr>
                        </thead>
                        <tbody>
                          <tr>
                              <td>blogtrackers.com</td>
                              <td>1</td>


                          </tr>
                          <tr>
                              <td>notonato.com</td>
                              <td>3</td>


                          </tr>
                          <tr>
                              <td>notonato.com</td>
                              <td>6</td>


                          </tr>
                          <tr>
                              <td>notonato.com</td>
                              <td>5</td>


                          </tr>
                          <tr>
                              <td>notonato.com</td>
                              <td>3</td>


                          </tr>
                          <tr>
                              <td>notonato.com</td>
                              <td>1</td>


                          </tr>
                          <tr>
                              <td>notonato.com</td>
                              <td>2</td>


                          </tr>
                          <tr>
                              <td>notonato.com</td>
                              <td>4</td>


                          </tr>
                          <tr>
                              <td>notonato.com</td>
                              <td>1</td>


                          </tr>
                          <tr>
                              <td>notonato.com</td>
                              <td>2</td>


                          </tr>

                        </tbody>
                    </table>
        </div>
          </div>
    </div>
  </div>

  <div class="col-md-6 mt20">
    <div class="card card-style mt20">
      <div class="card-body  p5 pt10 pb10">
        <div class="min-height-table"style="min-height: 420px;">
          <!-- <div class="dropdown show"><p class="text-primary p15 pb5 pt0">List of Top URLs of <a class=" dropdown-toggle" data-toggle="dropdown" href="#" aria-expanded="false" id="blogbloggermenu1" role="button">Blogs</a> of Past <b>Week</b></p>
            <div class="dropdown-menu" aria-labelledby="blogbloggermenu1">
               <a class="dropdown-item" href="#">Action</a>
               <a class="dropdown-item" href="#">Another action</a>
               <a class="dropdown-item" href="#">Something else here</a>
             </div>
          </div> -->

<div class="dropdown show text-primary p15 pb20 pt0">List of Top URLs of
  <b class="dropdown-toggle cursor-pointer" href="#" role="button" id="blogbloggermenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
    Blogs</b> of Past <b class="dropdown-toggle cursor-pointer" href="#" role="button" id="timerange1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">Week</b>

  <div class="dropdown-menu submenudashwidth" aria-labelledby="blogbloggermenu1">
    <a class="dropdown-item" href="#">Blog</a>
    <a class="dropdown-item" href="#">Bloggers</a>
  </div>

  <div class="dropdown-menu submenudashwidth" aria-labelledby="timerange1">
    <a class="dropdown-item" href="#">Week</a>
    <a class="dropdown-item" href="#">Month</a>
  </div>

</div>

          <!-- Example split danger button -->

          <div class="p15 pb5 pt0" role="group">
          Export Options
          </div>
                <table id="DataTables_Table_1_wrapper" class="display" style="width:100%">
                        <thead>
                            <tr>
                                <th>URL</th>
                                <th>Frequency</th>


                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>URL</td>
                                <td>1</td>


                            </tr>
                            <tr>
                                <td>URL</td>
                                <td>3</td>


                            </tr>
                            <tr>
                                <td>URL</td>
                                <td>6</td>


                            </tr>
                            <tr>
                                <td>URL</td>
                                <td>5</td>


                            </tr>
                            <tr>
                                <td>URL</td>
                                <td>3</td>


                            </tr>
                            <tr>
                                <td>URL</td>
                                <td>1</td>


                            </tr>
                            <tr>
                                <td>URL</td>
                                <td>2</td>


                            </tr>
                            <tr>
                                <td>URL</td>
                                <td>4</td>


                            </tr>
                            <tr>
                                <td>URL</td>
                                <td>1</td>


                            </tr>
                            <tr>
                                <td>URL</td>
                                <td>2</td>


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
<!-- date range scripts -->
<script src="assets/vendors/bootstrap-daterangepicker/moment.js"></script>
<script src="assets/vendors/bootstrap-daterangepicker/daterangepicker.js"></script>
<!--End of date range scripts  -->
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
  // datatable setup
    $('#DataTables_Table_1_wrapper').DataTable( {
        "scrollY": 430,
        "scrollX": false,
         "pagingType": "simple",
         dom: 'Bfrtip',
         "columnDefs": [
      { "width": "80%", "targets": 0 }
    ],
      buttons:{
        buttons: [
            { extend: 'pdfHtml5',orientation: 'potrait', pageSize: 'LEGAL', className: 'btn-primary stylebutton1'},
            {extend:'csv',className: 'btn-primary stylebutton1'},
            {extend:'excel',className: 'btn-primary stylebutton1'},
           // {extend:'copy',className: 'btn-primary stylebutton1', text: 'Copy to Clipboard'},
            {extend:'print',className: 'btn-primary stylebutton1'},
        ]
      }
    } );

// table set up 2
    $('#DataTables_Table_0_wrapper').DataTable( {
        "scrollY": 430,
        "scrollX": false,
         "pagingType": "simple",
         dom: 'Bfrtip',

         "columnDefs": [
      { "width": "80%", "targets": 0 }
    ],
      buttons:{
        buttons: [
            { extend: 'pdfHtml5',orientation: 'potrait', pageSize: 'LEGAL', className: 'btn-primary stylebutton1'},
            {extend:'csv',className: 'btn-primary stylebutton1'},
            {extend:'excel',className: 'btn-primary stylebutton1'},
           // {extend:'copy',className: 'btn-primary stylebutton1', text: 'Copy to Clipboard'},
            {extend:'print',className: 'btn-primary stylebutton1'},
        ]
      }
    } );
} );

</script>
<!--end for table  -->
<script>
$(document).ready(function() {
  $(document)
             .ready(
                 function() {
                   // date range configuration
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
<!-- <script src="http://d3js.org/d3.v3.min.js"></script> -->
<script type="text/javascript" src="assets/vendors/d3/d3.min.js"></script>
 <script src="assets/vendors/wordcloud/d3.layout.cloud.js"></script>
<script type="text/javascript" src="assets/vendors/d3/d3_tooltip.js"></script>
<!--start of language bar chart  -->
<script>
$(function () {

    // Initialize chart
    languageusage('#languageusage', 455);

    // Chart setup
    function languageusage(element, height) {

      // Basic setup
      // ------------------------------

      // Define main variables
      var d3Container = d3.select(element),
          margin = {top: 5, right: 50, bottom: 20, left: 60},
          width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right,
          height = height - margin.top - margin.bottom - 5;

         var formatPercent = d3.format("");

      // Construct scales
      // ------------------------------

      // Horizontal
      var y = d3.scale.ordinal()
          .rangeRoundBands([height,0], .4, .10);

      // Vertical
      var x = d3.scale.linear()
          .range([0,width]);

      // Color
      var color = d3.scale.category20c();



      // Create axes
      // ------------------------------

      // Horizontal
      var xAxis = d3.svg.axis()
          .scale(x)
          .orient("bottom")
          .ticks(6);

      // Vertical
      var yAxis = d3.svg.axis()
          .scale(y)
          .orient("left")
          //.tickFormat(formatPercent);



      // Create chart
      // ------------------------------

      // Add SVG element
      var container = d3Container.append("svg");

      // Add SVG group
      var svg = container
          .attr("width", width + margin.left + margin.right)
          .attr("height", height + margin.top + margin.bottom)
          .append("g")
              .attr("transform", "translate(" + margin.left + "," + margin.top + ")");


      //         // Create tooltip
      //             // ------------------------------
      //
      //
      //
      // // Load data
      // // ------------------------------
      //
      //
      //
      data = [
            {letter:"English", frequency:2550},
            {letter:"Russian", frequency:800},
            {letter:"Spanish", frequency:500},
            {letter:"French", frequency:1700},
            {letter:"Arabic", frequency:1900},
            {letter:"Unknown", frequency:1500}
        ];
      //
      //
      //   // Create tooltip
        var tip = d3.tip()
               .attr('class', 'd3-tip')
               .offset([-10, 0])
               .html(function(d) {
                   return d.letter+" ("+d.frequency+")";
               });

           // Initialize tooltip
           svg.call(tip);

      //
      //     // Pull out values
      //     data.forEach(function(d) {
      //         d.frequency = +d.frequency;
      //     });
      //
      //
      //
      //     // Set input domains
      //     // ------------------------------
      //
      //     // Horizontal
          y.domain(data.map(function(d) { return d.letter; }));

          // Vertical
          x.domain([0,d3.max(data, function(d) { return d.frequency; })]);
      //
      //
      //     //
      //     // Append chart elements
      //     //
      //
      //     // Append axes
      //     // ------------------------------
      //
          // Horizontal
          svg.append("g")
              .attr("class", "d3-axis d3-axis-horizontal d3-axis-strong")
              .attr("transform", "translate(0," + height + ")")
              .call(xAxis);

          // Vertical
          var verticalAxis = svg.append("g")
              .attr("class", "d3-axis d3-axis-vertical d3-axis-strong")
              .style("color","yellow")
              .call(yAxis);
      //
      //
      //     // Add text label
      //     verticalAxis.append("text")
      //         .attr("transform", "rotate(-90)")
      //         .attr("y", 10)
      //         .attr("dy", ".71em")
      //         .style("text-anchor", "end")
      //         .style("fill", "#999")
      //         .style("font-size", 12)
      //         // .text("Frequency")
      //         ;
      //
      //
      //     // Add bars
          svg.selectAll(".d3-bar")
              .data(data)
              .enter()
              .append("rect")
                  .attr("class", "d3-bar")
                  .attr("y", function(d) { return y(d.letter); })
                  .attr("height", y.rangeBand())
                  .attr("x", function(d) { return 0; })
                  .attr("width", function(d) { return x(d.frequency); })
                  .style("fill", function(d) {
                  maxvalue = d3.max(data, function(d) { return d.frequency; });
                  if(d.frequency == maxvalue)
                  {
                    return "0080CC";
                  }
                  else
                  {
                    return "#78BCE4";
                  }

                })
                  .on('mouseover', tip.show)
                  .on('mouseout', tip.hide);


                  // svg.selectAll(".d3-bar")
                  //     .data(data)
                  //     .enter()
                  //     .append("rect")
                  //         .attr("class", "d3-bar")
                  //         .attr("x", function(d) { return x(d.letter); })
                  //         .attr("width", x.rangeBand())
                  //         .attr("y", function(d) { return y(d.frequency); })
                  //         .attr("height", function(d) { return height - y(d.frequency); })
                  //         .style("fill", function(d) { return "#58707E"; })
                  //         .on('mouseover', tip.show)
                  //         .on('mouseout', tip.hide);





        // Resize chart
        // ------------------------------

        // Call function on window resize
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


            // // Layout
            // // -------------------------
            //
            // // Main svg width
            container.attr("width", width + margin.left + margin.right);

            // Width of appended group
            svg.attr("width", width + margin.left + margin.right);
            //
            //
            // // Axes
            // // -------------------------
            //
            // // Horizontal range
           x.range([0,width]);
            //
            // // Horizontal axis
            svg.selectAll('.d3-axis-horizontal').call(xAxis);
             // svg.selectAll('.d3-bar-vertical').call(yAxis);

            //
            // // Chart elements
            // // -------------------------
            //
            // // Line path
           svg.selectAll('.d3-bar').attr("width", function(d) { return x(d.frequency); });
        }
    }
});
</script>

<!-- End of language bar chart  -->

<!-- start of influence bar chart  -->
<script>
$(function () {

    // Initialize chart
    influencebar('#influencebar', 450);

    // Chart setup
    function influencebar(element, height) {

      // Basic setup
      // ------------------------------

      // Define main variables
      var d3Container = d3.select(element),
          margin = {top: 5, right: 50, bottom: 20, left: 60},
          width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right,
          height = height - margin.top - margin.bottom - 5;

         var formatPercent = d3.format("");

      // Construct scales
      // ------------------------------

      // Horizontal
      var y = d3.scale.ordinal()
          .rangeRoundBands([height,0], .5, .40);

      // Vertical
      var x = d3.scale.linear()
          .range([0,width]);

      // Color
      var color = d3.scale.category20c();



      // Create axes
      // ------------------------------

      // Horizontal
      var xAxis = d3.svg.axis()
          .scale(x)
          .orient("bottom")
          .ticks(6);

      // Vertical
      var yAxis = d3.svg.axis()
          .scale(y)
          .orient("left")
          //.tickFormat(formatPercent);



      // Create chart
      // ------------------------------

      // Add SVG element
      var container = d3Container.append("svg");

      // Add SVG group
      var svg = container
          .attr("width", width + margin.left + margin.right)
          .attr("height", height + margin.top + margin.bottom)
          .append("g")
              .attr("transform", "translate(" + margin.left + "," + margin.top + ")");


      //         // Create tooltip
      //             // ------------------------------
      //
      //
      //
      // // Load data
      // // ------------------------------
      //
      //
      //
      data = [
            {letter:"Blog 5", frequency:2550, name:"Obadimu Adewale", type:"blogger"},
            {letter:"Blog 4", frequency:800, name:"Matt Finnace", type:"blogger"},
            {letter:"Blog 3", frequency:500, name:"notonato", type:"blogger"},
            {letter:"Blog 2", frequency:1700, name:"Nihal Hussain", type:"blogger"},
            {letter:"Blog 1", frequency:1900, name:"Test Test", type:"blogger"}
        ];
      //
      //
      //   // Create tooltip
        var tip = d3.tip()
               .attr('class', 'd3-tip')
               .offset([-10, 0])
               .html(function(d) {
                 if(d.type === "blogger")
                 {
                   return d.letter+" ("+d.frequency+")<br/> Blogger: "+d.name;
                 }

                 if(d.type === "blog")
                 {
                   return d.letter+" ("+d.frequency+")<br/> Blog: "+d.name;
                 }

               });

           // Initialize tooltip
           svg.call(tip);

      //
      //     // Pull out values
      //     data.forEach(function(d) {
      //         d.frequency = +d.frequency;
      //     });
      //
      //
      //
      //     // Set input domains
      //     // ------------------------------
      //
      //     // Horizontal
          y.domain(data.map(function(d) { return d.letter; }));

          // Vertical
          x.domain([0,d3.max(data, function(d) { return d.frequency; })]);
      //
      //
      //     //
      //     // Append chart elements
      //     //
      //
      //     // Append axes
      //     // ------------------------------
      //
          // Horizontal
          svg.append("g")
              .attr("class", "d3-axis d3-axis-horizontal d3-axis-strong")
              .attr("transform", "translate(0," + height + ")")
              .call(xAxis);

          // Vertical
          var verticalAxis = svg.append("g")
              .attr("class", "d3-axis d3-axis-vertical d3-axis-strong")
              .style("color","yellow")
              .call(yAxis);
      //
      //
      //     // Add text label
      //     verticalAxis.append("text")
      //         .attr("transform", "rotate(-90)")
      //         .attr("y", 10)
      //         .attr("dy", ".71em")
      //         .style("text-anchor", "end")
      //         .style("fill", "#999")
      //         .style("font-size", 12)
      //         // .text("Frequency")
      //         ;
      //
      //
      //     // Add bars
          svg.selectAll(".d3-bar")
              .data(data)
              .enter()
              .append("rect")
                  .attr("class", "d3-bar")
                  .attr("y", function(d) { return y(d.letter); })
                  .attr("height", y.rangeBand())
                  .attr("x", function(d) { return 0; })
                  .attr("width", function(d) { return x(d.frequency); })
                  .style("fill", function(d) {
                  maxvalue = d3.max(data, function(d) { return d.frequency; });
                  if(d.frequency == maxvalue)
                  {
                    return "0080CC";
                  }
                  else
                  {
                    return "#78BCE4";
                  }

                })
                  .on('mouseover', tip.show)
                  .on('mouseout', tip.hide);


                  // svg.selectAll(".d3-bar")
                  //     .data(data)
                  //     .enter()
                  //     .append("rect")
                  //         .attr("class", "d3-bar")
                  //         .attr("x", function(d) { return x(d.letter); })
                  //         .attr("width", x.rangeBand())
                  //         .attr("y", function(d) { return y(d.frequency); })
                  //         .attr("height", function(d) { return height - y(d.frequency); })
                  //         .style("fill", function(d) { return "#58707E"; })
                  //         .on('mouseover', tip.show)
                  //         .on('mouseout', tip.hide);





        // Resize chart
        // ------------------------------

        // Call function on window resize
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


            // // Layout
            // // -------------------------
            //
            // // Main svg width
            container.attr("width", width + margin.left + margin.right);

            // Width of appended group
            svg.attr("width", width + margin.left + margin.right);
            //
            //
            // // Axes
            // // -------------------------
            //
            // // Horizontal range
           x.range([0,width]);
            //
            // // Horizontal axis
            svg.selectAll('.d3-axis-horizontal').call(xAxis);
             // svg.selectAll('.d3-bar-vertical').call(yAxis);

            //
            // // Chart elements
            // // -------------------------
            //
            // // Line path
           svg.selectAll('.d3-bar').attr("width", function(d) { return x(d.frequency); });
        }
    }
});
</script>

<!--  End of influence bar -->

<!-- start of posting frequency  -->
<script>
$(function () {

    // Initialize chart
    postingfrequencybar('#postingfrequencybar', 450);

    // Chart setup
    function postingfrequencybar(element, height) {

      // Basic setup
      // ------------------------------

      // Define main variables
      var d3Container = d3.select(element),
          margin = {top: 5, right: 50, bottom: 20, left: 60},
          width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right,
          height = height - margin.top - margin.bottom - 5;

         var formatPercent = d3.format("");

      // Construct scales
      // ------------------------------

      // Horizontal
      var y = d3.scale.ordinal()
          .rangeRoundBands([height,0], .5, .40);

      // Vertical
      var x = d3.scale.linear()
          .range([0,width]);

      // Color
      var color = d3.scale.category20c();



      // Create axes
      // ------------------------------

      // Horizontal
      var xAxis = d3.svg.axis()
          .scale(x)
          .orient("bottom")
          .ticks(6);

      // Vertical
      var yAxis = d3.svg.axis()
          .scale(y)
          .orient("left")
          //.tickFormat(formatPercent);



      // Create chart
      // ------------------------------

      // Add SVG element
      var container = d3Container.append("svg");

      // Add SVG group
      var svg = container
          .attr("width", width + margin.left + margin.right)
          .attr("height", height + margin.top + margin.bottom)
          .append("g")
              .attr("transform", "translate(" + margin.left + "," + margin.top + ")");


      //         // Create tooltip
      //             // ------------------------------
      //
      //
      //
      // // Load data
      // // ------------------------------
      //
      //
      //
      data = [
            {letter:"Blog 5", frequency:2550, name:"Obadimu Adewale", type:"blogger"},
            {letter:"Blog 4", frequency:800, name:"Matt Finnace", type:"blogger"},
            {letter:"Blog 3", frequency:500, name:"notonato", type:"blogger"},
            {letter:"Blog 2", frequency:1700, name:"Nihal Hussain", type:"blogger"},
            {letter:"Blog 1", frequency:1900, name:"Test Test", type:"blogger"}
        ];
      //
      //
      //   // Create tooltip
        var tip = d3.tip()
               .attr('class', 'd3-tip')
               .offset([-10, 0])
               .html(function(d) {
                 if(d.type === "blogger")
                 {
                   return d.letter+" ("+d.frequency+")<br/> Blogger: "+d.name;
                 }

                 if(d.type === "blog")
                 {
                   return d.letter+" ("+d.frequency+")<br/> Blog: "+d.name;
                 }

               });

           // Initialize tooltip
           svg.call(tip);

      //
      //     // Pull out values
      //     data.forEach(function(d) {
      //         d.frequency = +d.frequency;
      //     });
      //
      //
      //
      //     // Set input domains
      //     // ------------------------------
      //
      //     // Horizontal
          y.domain(data.map(function(d) { return d.letter; }));

          // Vertical
          x.domain([0,d3.max(data, function(d) { return d.frequency; })]);
      //
      //
      //     //
      //     // Append chart elements
      //     //
      //
      //     // Append axes
      //     // ------------------------------
      //
          // Horizontal
          svg.append("g")
              .attr("class", "d3-axis d3-axis-horizontal d3-axis-strong")
              .attr("transform", "translate(0," + height + ")")
              .call(xAxis);

          // Vertical
          var verticalAxis = svg.append("g")
              .attr("class", "d3-axis d3-axis-vertical d3-axis-strong")
              .style("color","yellow")
              .call(yAxis);
      //
      //
      //     // Add text label
      //     verticalAxis.append("text")
      //         .attr("transform", "rotate(-90)")
      //         .attr("y", 10)
      //         .attr("dy", ".71em")
      //         .style("text-anchor", "end")
      //         .style("fill", "#999")
      //         .style("font-size", 12)
      //         // .text("Frequency")
      //         ;
      //
      //
      //     // Add bars
          svg.selectAll(".d3-bar")
              .data(data)
              .enter()
              .append("rect")
                  .attr("class", "d3-bar")
                  .attr("y", function(d) { return y(d.letter); })
                  .attr("height", y.rangeBand())
                  .attr("x", function(d) { return 0; })
                  .attr("width", function(d) { return x(d.frequency); })
                  .style("fill", function(d) {
                  maxvalue = d3.max(data, function(d) { return d.frequency; });
                  if(d.frequency == maxvalue)
                  {
                    return "0080CC";
                  }
                  else
                  {
                    return "#78BCE4";
                  }

                })
                  .on('mouseover', tip.show)
                  .on('mouseout', tip.hide);


                  // svg.selectAll(".d3-bar")
                  //     .data(data)
                  //     .enter()
                  //     .append("rect")
                  //         .attr("class", "d3-bar")
                  //         .attr("x", function(d) { return x(d.letter); })
                  //         .attr("width", x.rangeBand())
                  //         .attr("y", function(d) { return y(d.frequency); })
                  //         .attr("height", function(d) { return height - y(d.frequency); })
                  //         .style("fill", function(d) { return "#58707E"; })
                  //         .on('mouseover', tip.show)
                  //         .on('mouseout', tip.hide);





        // Resize chart
        // ------------------------------

        // Call function on window resize
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


            // // Layout
            // // -------------------------
            //
            // // Main svg width
            container.attr("width", width + margin.left + margin.right);

            // Width of appended group
            svg.attr("width", width + margin.left + margin.right);
            //
            //
            // // Axes
            // // -------------------------
            //
            // // Horizontal range
           x.range([0,width]);
            //
            // // Horizontal axis
            svg.selectAll('.d3-axis-horizontal').call(xAxis);
             // svg.selectAll('.d3-bar-vertical').call(yAxis);

            //
            // // Chart elements
            // // -------------------------
            //
            // // Line path
           svg.selectAll('.d3-bar').attr("width", function(d) { return x(d.frequency); });
        }
    }
});
</script>
<!-- end of posting frequency  -->
<!--  Start of sentiment Bar Chart -->
<script>
$(function () {

    // Initialize chart
    sentimentbar('#sentimentbar', 400);

    // Chart setup
    function sentimentbar(element, height) {

      // Basic setup
      // ------------------------------

      // Define main variables
      var d3Container = d3.select(element),
          margin = {top: 5, right: 50, bottom: 20, left: 60},
          width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right,
          height = height - margin.top - margin.bottom - 5;

         var formatPercent = d3.format("");

      // Construct scales
      // ------------------------------

      // Horizontal
      var y = d3.scale.ordinal()
          .rangeRoundBands([height,0], .6, .8);

      // Vertical
      var x = d3.scale.linear()
          .range([0,width]);

      // Color
      var color = d3.scale.category20c();



      // Create axes
      // ------------------------------

      // Horizontal
      var xAxis = d3.svg.axis()
          .scale(x)
          .orient("bottom")
          .ticks(6);

      // Vertical
      var yAxis = d3.svg.axis()
          .scale(y)
          .orient("left")
          //.tickFormat(formatPercent);



      // Create chart
      // ------------------------------

      // Add SVG element
      var container = d3Container.append("svg");

      // Add SVG group
      var svg = container
          .attr("width", width + margin.left + margin.right)
          .attr("height", height + margin.top + margin.bottom)
          .append("g")
              .attr("transform", "translate(" + margin.left + "," + margin.top + ")");


      //         // Create tooltip
      //             // ------------------------------
      //
      //
      //
      // // Load data
      // // ------------------------------
      //
      //
      //
      data = [
            {letter:"Negative", frequency:1200},
            {letter:"Positive", frequency:2550}
        ];
      //
      //
      //   // Create tooltip
        var tip = d3.tip()
               .attr('class', 'd3-tip')
               .offset([-10, 0])
               .html(function(d) {
                   return d.letter+" ("+d.frequency+")";
               });

           // Initialize tooltip
           svg.call(tip);

           var color = d3.scale.linear()
                   .domain([0,1])
                   .range(["#FF7D7D", "#72c28e"]);


      //
      //     // Pull out values
      //     data.forEach(function(d) {
      //         d.frequency = +d.frequency;
      //     });
      //
      //
      //
      //     // Set input domains
      //     // ------------------------------
      //
      //     // Horizontal
          y.domain(data.map(function(d) { return d.letter; }));

          // Vertical
          x.domain([0,d3.max(data, function(d) { return d.frequency; })]);
      //
      //
      //     //
      //     // Append chart elements
      //     //
      //
      //     // Append axes
      //     // ------------------------------
      //
          // Horizontal
          svg.append("g")
              .attr("class", "d3-axis d3-axis-horizontal d3-axis-strong")
              .attr("transform", "translate(0," + height + ")")
              .call(xAxis);

          // Vertical
          var verticalAxis = svg.append("g")
              .attr("class", "d3-axis d3-axis-vertical d3-axis-strong")
              .style("color","yellow")
              .call(yAxis);
      //
      //
      //     // Add text label
      //     verticalAxis.append("text")
      //         .attr("transform", "rotate(-90)")
      //         .attr("y", 10)
      //         .attr("dy", ".71em")
      //         .style("text-anchor", "end")
      //         .style("fill", "#999")
      //         .style("font-size", 12)
      //         // .text("Frequency")
      //         ;
      //
      //
      //     // Add bars
          svg.selectAll(".d3-bar")
              .data(data)
              .enter()
              .append("rect")
                  .attr("class", "d3-bar")
                  .attr("y", function(d) { return y(d.letter); })
                  .attr("height", y.rangeBand())
                  .attr("x", function(d) { return 0; })
                  .attr("width", function(d) { return x(d.frequency); })
                  .style("fill", function(d,i) { return color(i);   })
                  .on('mouseover', tip.show)
                  .on('mouseout', tip.hide);


                  // svg.selectAll(".d3-bar")
                  //     .data(data)
                  //     .enter()
                  //     .append("rect")
                  //         .attr("class", "d3-bar")
                  //         .attr("x", function(d) { return x(d.letter); })
                  //         .attr("width", x.rangeBand())
                  //         .attr("y", function(d) { return y(d.frequency); })
                  //         .attr("height", function(d) { return height - y(d.frequency); })
                  //         .style("fill", function(d) { return "#58707E"; })
                  //         .on('mouseover', tip.show)
                  //         .on('mouseout', tip.hide);





        // Resize chart
        // ------------------------------

        // Call function on window resize
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


            // // Layout
            // // -------------------------
            //
            // // Main svg width
            container.attr("width", width + margin.left + margin.right);

            // Width of appended group
            svg.attr("width", width + margin.left + margin.right);
            //
            //
            // // Axes
            // // -------------------------
            //
            // // Horizontal range
           x.range([0,width]);
            //
            // // Horizontal axis
            svg.selectAll('.d3-axis-horizontal').call(xAxis);
             // svg.selectAll('.d3-bar-vertical').call(yAxis);

            //
            // // Chart elements
            // // -------------------------
            //
            // // Line path
           svg.selectAll('.d3-bar').attr("width", function(d) { return x(d.frequency); });
        }
    }
});
</script>

<script type="text/javascript">
// map data
var gdpData = {
  "AF": 16.63,
  "AL": 11.58,
  "DZ": 158.97,
  "AO": 85.81,
  "AG": 1.1,
  "AR": 351.02,
  "AM": 8.83,
  "AU": 1219.72,
  "AT": 366.26,
  "AZ": 52.17,
  "BS": 7.54,
  "BH": 21.73,
  "BD": 105.4,
  "BB": 3.96,
  "BY": 52.89,
  "BE": 461.33,
  "BZ": 1.43,
  "BJ": 6.49,
  "BT": 1.4,
  "BO": 19.18,
  "BA": 16.2,
  "BW": 12.5,
  "BR": 2023.53,
  "BN": 11.96,
  "BG": 44.84,
  "BF": 8.67,
  "BI": 1.47,
  "KH": 11.36,
  "CM": 21.88,
  "CA": 1563.66,
  "CV": 1.57,
  "CF": 2.11,
  "TD": 7.59,
  "CL": 199.18,
  "CN": 5745.13,
  "CO": 283.11,
  "KM": 0.56,
  "CD": 12.6,
  "CG": 11.88,
  "CR": 35.02,
  "CI": 22.38,
  "HR": 59.92,
  "CY": 22.75,
  "CZ": 195.23,
  "DK": 304.56,
  "DJ": 1.14,
  "DM": 0.38,
  "DO": 50.87,
  "EC": 61.49,
  "EG": 216.83,
  "SV": 21.8,
  "GQ": 14.55,
  "ER": 2.25,
  "EE": 19.22,
  "ET": 30.94,
  "FJ": 3.15,
  "FI": 231.98,
  "FR": 2555.44,
  "GA": 12.56,
  "GM": 1.04,
  "GE": 11.23,
  "DE": 3305.9,
  "GH": 18.06,
  "GR": 305.01,
  "GD": 0.65,
  "GT": 40.77,
  "GN": 4.34,
  "GW": 0.83,
  "GY": 2.2,
  "HT": 6.5,
  "HN": 15.34,
  "HK": 226.49,
  "HU": 132.28,
  "IS": 12.77,
  "IN": 1430.02,
  "ID": 695.06,
  "IR": 337.9,
  "IQ": 84.14,
  "IE": 204.14,
  "IL": 201.25,
  "IT": 2036.69,
  "JM": 13.74,
  "JP": 5390.9,
  "JO": 27.13,
  "KZ": 129.76,
  "KE": 32.42,
  "KI": 0.15,
  "KR": 986.26,
  "UNDEFINED": 5.73,
  "KW": 117.32,
  "KG": 4.44,
  "LA": 6.34,
  "LV": 23.39,
  "LB": 39.15,
  "LS": 1.8,
  "LR": 0.98,
  "LY": 77.91,
  "LT": 35.73,
  "LU": 52.43,
  "MK": 9.58,
  "MG": 8.33,
  "MW": 5.04,
  "MY": 218.95,
  "MV": 1.43,
  "ML": 9.08,
  "MT": 7.8,
  "MR": 3.49,
  "MU": 9.43,
  "MX": 1004.04,
  "MD": 5.36,
  "MN": 5.81,
  "ME": 3.88,
  "MA": 91.7,
  "MZ": 10.21,
  "MM": 35.65,
  "NA": 11.45,
  "NP": 15.11,
  "NL": 770.31,
  "NZ": 138,
  "NI": 6.38,
  "NE": 5.6,
  "NG": 206.66,
  "NO": 413.51,
  "OM": 53.78,
  "PK": 174.79,
  "PA": 27.2,
  "PG": 8.81,
  "PY": 17.17,
  "PE": 153.55,
  "PH": 189.06,
  "PL": 438.88,
  "PT": 223.7,
  "QA": 126.52,
  "RO": 158.39,
  "RU": 1476.91,
  "RW": 5.69,
  "WS": 0.55,
  "ST": 0.19,
  "SA": 434.44,
  "SN": 12.66,
  "RS": 38.92,
  "SC": 0.92,
  "SL": 1.9,
  "SG": 217.38,
  "SK": 86.26,
  "SI": 46.44,
  "SB": 0.67,
  "ZA": 354.41,
  "ES": 1374.78,
  "LK": 48.24,
  "KN": 0.56,
  "LC": 1,
  "VC": 0.58,
  "SD": 65.93,
  "SR": 3.3,
  "SZ": 3.17,
  "SE": 444.59,
  "CH": 522.44,
  "SY": 59.63,
  "TW": 426.98,
  "TJ": 5.58,
  "TZ": 22.43,
  "TH": 312.61,
  "TL": 0.62,
  "TG": 3.07,
  "TO": 0.3,
  "TT": 21.2,
  "TN": 43.86,
  "TR": 729.05,
  "TM": 0,
  "UG": 17.12,
  "UA": 136.56,
  "AE": 239.65,
  "GB": 2258.57,
  "US": 14624.18,
  "UY": 40.71,
  "UZ": 37.72,
  "VU": 0.72,
  "VE": 285.21,
  "VN": 101.99,
  "YE": 30.02,
  "ZM": 15.69,
  "ZW": 5.57
};

// map marker location by longitude and latitude
var mymarker = [
    {latLng: [41.90, 12.45], name: 'Vatican City'},
    {latLng: [43.73, 7.41], name: 'Monaco'},
    {latLng: [40.726, -111.778], name: 'Salt Lake City'},
    {latLng: [39.092, -94.575], name: 'Kansas City'},
    {latLng: [25.782, -80.231], name: 'Miami'},
    {latLng: [8.967, -79.458], name: 'Panama City'},
    {latLng: [19.400, -99.124], name: 'Mexico City'},
    {latLng: [40.705, -73.978], name: 'New York'},
    {latLng: [33.98, -118.132], name: 'Los Angeles'},
    {latLng: [47.614, -122.335], name: 'Seattle'},
    {latLng: [44.97, -93.261], name: 'Minneapolis'},
    {latLng: [39.73, -105.015], name: 'Denver'},
    {latLng: [41.833, -87.732], name: 'Chicago'},
    {latLng: [29.741, -95.395], name: 'Houston'},
    {latLng: [23.05, -82.33], name: 'Havana'},
    {latLng: [45.41, -75.70], name: 'Ottawa'},
    {latLng: [53.555, -113.493], name: 'Edmonton'},
    {latLng: [-0.23, -78.52], name: 'Quito'},
    {latLng: [18.50, -69.99], name: 'Santo Domingo'},
    {latLng: [4.61, -74.08], name: 'Bogot�'},
    {latLng: [14.08, -87.21], name: 'Tegucigalpa'},
    {latLng: [17.25, -88.77], name: 'Belmopan'},
    {latLng: [14.64, -90.51], name: 'New Guatemala'},
    {latLng: [-15.775, -47.797], name: 'Brasilia'},
    {latLng: [-3.790, -38.518], name: 'Fortaleza'},
    {latLng: [50.402, 30.532], name: 'Kiev'},
    {latLng: [53.883, 27.594], name: 'Minsk'},
    {latLng: [52.232, 21.061], name: 'Warsaw'},
    {latLng: [52.507, 13.426], name: 'Berlin'},
    {latLng: [50.059, 14.465], name: 'Prague'},
    {latLng: [47.481, 19.130], name: 'Budapest'},
    {latLng: [52.374, 4.898], name: 'Amsterdam'},
    {latLng: [48.858, 2.347], name: 'Paris'},
    {latLng: [40.437, -3.679], name: 'Madrid'},
    {latLng: [39.938, 116.397], name: 'Beijing'},
    {latLng: [28.646, 77.093], name: 'Delhi'},
    {latLng: [25.073, 55.229], name: 'Dubai'},
    {latLng: [35.701, 51.349], name: 'Tehran'},
    {latLng: [7.11, 171.06], name: 'Marshall Islands'},
    {latLng: [17.3, -62.73], name: 'Saint Kitts and Nevis'},
    {latLng: [3.2, 73.22], name: 'Maldives'},
    {latLng: [35.88, 14.5], name: 'Malta'},
    {latLng: [12.05, -61.75], name: 'Grenada'},
    {latLng: [13.16, -61.23], name: 'Saint Vincent and the Grenadines'},
    {latLng: [13.16, -59.55], name: 'Barbados'},
    {latLng: [17.11, -61.85], name: 'Antigua and Barbuda'},
    {latLng: [-4.61, 55.45], name: 'Seychelles'},
    {latLng: [7.35, 134.46], name: 'Palau'},
    {latLng: [42.5, 1.51], name: 'Andorra'},
    {latLng: [14.01, -60.98], name: 'Saint Lucia'},
    {latLng: [6.91, 158.18], name: 'Federated States of Micronesia'},
    {latLng: [1.3, 103.8], name: 'Singapore'},
    {latLng: [1.46, 173.03], name: 'Kiribati'},
    {latLng: [-21.13, -175.2], name: 'Tonga'},
    {latLng: [15.3, -61.38], name: 'Dominica'},
    {latLng: [-20.2, 57.5], name: 'Mauritius'},
    {latLng: [26.02, 50.55], name: 'Bahrain'},
    {latLng: [0.33, 6.73], name: 'S�o Tom� and Pr�ncipe'}
]
  </script>
<script type="text/javascript" src="assets/vendors/maps/jvectormap/jvectormap.min.js"></script>
<script type="text/javascript" src="assets/vendors/maps/jvectormap/map_files/world.js"></script>
<script type="text/javascript" src="assets/vendors/maps/jvectormap/map_files/countries/usa.js"></script>
<script type="text/javascript" src="assets/vendors/maps/jvectormap/map_files/countries/germany.js"></script>
<script type="text/javascript" src="assets/vendors/maps/vector_maps_demo.js"></script>

<!--word cloud  -->
 <script>

     var frequency_list = [{"text":"study","size":40},{"text":"motion","size":15},{"text":"forces","size":10},{"text":"electricity","size":15},{"text":"movement","size":10},{"text":"relation","size":5},{"text":"things","size":10},{"text":"force","size":5},{"text":"ad","size":5},{"text":"energy","size":85},{"text":"living","size":5},{"text":"nonliving","size":5},{"text":"laws","size":15},{"text":"speed","size":45},{"text":"velocity","size":30},{"text":"define","size":5},{"text":"constraints","size":5},{"text":"universe","size":10},{"text":"distinguished","size":5},{"text":"chemistry","size":5},{"text":"biology","size":5},{"text":"includes","size":5},{"text":"radiation","size":5},{"text":"sound","size":5},{"text":"structure","size":5},{"text":"atoms","size":5},{"text":"including","size":10},{"text":"atomic","size":10},{"text":"nuclear","size":10},{"text":"cryogenics","size":10},{"text":"solid-state","size":10},{"text":"particle","size":10},{"text":"plasma","size":10},{"text":"deals","size":5},{"text":"merriam-webster","size":5},{"text":"dictionary","size":10},{"text":"analysis","size":5},{"text":"conducted","size":5},{"text":"order","size":5},{"text":"understand","size":5},{"text":"behaves","size":5},{"text":"en","size":5},{"text":"wikipedia","size":5},{"text":"wiki","size":5},{"text":"physics-","size":5},{"text":"physical","size":5},{"text":"behaviour","size":5},{"text":"collinsdictionary","size":5},{"text":"english","size":5},{"text":"time","size":35},{"text":"distance","size":35},{"text":"wheels","size":5},{"text":"revelations","size":5},{"text":"minute","size":5},{"text":"acceleration","size":20},{"text":"torque","size":5},{"text":"wheel","size":5},{"text":"rotations","size":5},{"text":"resistance","size":5},{"text":"momentum","size":5},{"text":"measure","size":10},{"text":"direction","size":10},{"text":"car","size":5},{"text":"add","size":5},{"text":"traveled","size":5},{"text":"weight","size":5},{"text":"electrical","size":5},{"text":"power","size":5}];


     var color = d3.scale.linear()
             .domain([0,1,2,3,4,5,6,10,15,20,80])
             .range(["#17394C", "#F5CC0E", "#CE0202", "#1F90D0", "#999", "#888", "#777", "#666", "#555", "#444", "#333", "#222"]);

     d3.layout.cloud().size([450, 300])
             .words(frequency_list)
             .rotate(0)
             .fontSize(function(d) { return d.size; })
             .on("end", draw)
             .start();

     function draw(words) {
         d3.select(".tagcloudcontainer").append("svg")
                 .attr("width", 450)
                 .attr("height", 300)
                 .attr("class", "wordcloud")
                 .append("g")
                 // without the transform, words words would get cutoff to the left and top, they would
                 // appear outside of the SVG area
                 .attr("transform", "translate(155,180)")
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

<!-- Blogger Bubble Chart -->
<script>


$(function () {

    // Initialize chart
    bubblesblogger('#bubblesblogger', 470);

    // Chart setup
    function bubblesblogger(element, diameter) {


        // Basic setup
        // ------------------------------

        // Format data
        var format = d3.format(",d");

        // Color scale
        color = d3.scale.category10();

        // Define main variables
        var d3Container = d3.select(element),
            margin = {top: 5, right: 20, bottom: 20, left: 50},
            width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right,
            height = height - margin.top - margin.bottom;
            diamter = height;




            // Add SVG element
            var container = d3Container.append("svg");

            // Add SVG group
            var svg = container
                .attr("width", diameter + margin.left + margin.right)
                .attr("height",diameter + margin.top + margin.bottom)
                .attr("class", "bubble");

        // Create chart
        // ------------------------------

        // var svg = d3.select(element).append("svg")
        //     .attr("width", diameter)
        //     .attr("height", diameter)
        //     .attr("class", "bubble");



        // Create chart
        // ------------------------------

        // Add tooltip
        var tip = d3.tip()
            .attr('class', 'd3-tip')
            .offset([-5, 0])
            .html(function(d) {
                return d.label+"<br/>"+d.className + ": " + format(d.value);;
            });

        // Initialize tooltip
        svg.call(tip);



        // Construct chart layout
        // ------------------------------

        // Pack
        var bubble = d3.layout.pack()
            .sort(null)
            .size([diameter, diameter])
            .padding(15);



        // Load data
        // ------------------------------



data = {
 "name":"flare",
 "bloggers":[
 {"label":"Blogger 1","name":"Adigun Adekunle", "size":3245},
 {"label":"Blogger 2","name":"Obadimu Adewale", "size":2500},
 {"label":"Blogger 3","name":"Oluwaseun Walter", "size":2800},
 {"label":"Blogger 4","name":"Kiran Bandeli", "size":900},
 {"label":"Blogger 5","name":"Adekunle Mayowa", "size":1400},
 {"label":"Blogger 6","name":"Nihal Hussain", "size":200},
 {"label":"Blogger 7","name":"Adekunle Mayowa", "size":500},
 {"label":"Blogger 8","name":"Adekunle Mayowa", "size":300},
 {"label":"Blogger 9","name":"Adekunle Mayowa", "size":350},
 {"label":"Blogger 10","name":"Adekunle Mayowa", "size":1400}
 ]
}


            //
            // Append chart elements
            //

            // Bind data
            var node = svg.selectAll(".d3-bubbles-node")
                .data(bubble.nodes(classes(data))
                .filter(function(d) { return !d.children; }))
                .enter()
                .append("g")
                    .attr("class", "d3-bubbles-node")
                    .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });

            // Append circles
            node.append("circle")
                .attr("r", function(d) { return d.r; })
                .style("fill", function(d,i) {
                  // return color(i);
                  // customize Color
                  if(i<5)
                  {
                    return "#0080cc";
                  }
                  else if(i>=5)
                  {
                    return "#78bce4";
                  }
                })
                .on('mouseover', tip.show)
                .on('mouseout', tip.hide);

            // Append text
            node.append("text")
                .attr("dy", ".3em")
                .style("fill", "#fff")
                .style("font-size", 12)
                .style("text-anchor", "middle")
                .text(function(d) { return d.label.substring(0, d.r / 3); });



        // Returns a flattened hierarchy containing all leaf nodes under the root.
        function classes(root) {
            var classes = [];

            function recurse(name, node) {
                if (node.bloggers) node.bloggers.forEach(function(child) { recurse(node.name, child); });
                else classes.push({packageName: name, className: node.name, value: node.size,label:node.label});
            }

            recurse(null, root);
            return {children: classes};
        }
    }
});
</script>
<script>


    var color = d3.scale.linear()
            .domain([0,1,2,3,4,5,6,10,15,20,80])
            .range(["#17394C", "#F5CC0E", "#CE0202", "#aaa", "#999", "#888", "#777", "#666", "#555", "#444", "#333", "#222"]);

</script>
<!-- end of blogger bubble chart -->


<!-- Blog Bubble Chart -->
<script>


$(function () {

    // Initialize chart
    bubblesblog('#bubblesblog', 470);

    // Chart setup
    function bubblesblog(element, diameter) {


        // Basic setup
        // ------------------------------

        // Format data
        var format = d3.format(",d");

        // Color scale
        color = d3.scale.category10();

        // Define main variables
        var d3Container = d3.select(element),
            margin = {top: 5, right: 20, bottom: 20, left: 50},
            width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right,
            height = height - margin.top - margin.bottom;
            diamter = height;




            // Add SVG element
            var container = d3Container.append("svg");

            // Add SVG group
            var svg = container
                .attr("width", diameter + margin.left + margin.right)
                .attr("height",diameter + margin.top + margin.bottom)
                .attr("class", "bubble");

        // Create chart
        // ------------------------------

        // var svg = d3.select(element).append("svg")
        //     .attr("width", diameter)
        //     .attr("height", diameter)
        //     .attr("class", "bubble");



        // Create chart
        // ------------------------------

        // Add tooltip
        var tip = d3.tip()
            .attr('class', 'd3-tip')
            .offset([-5, 0])
            .html(function(d) {
                return d.label+"<br/>"+d.className + ": " + format(d.value);;
            });

        // Initialize tooltip
        svg.call(tip);



        // Construct chart layout
        // ------------------------------

        // Pack
        var bubble = d3.layout.pack()
            .sort(null)
            .size([diameter, diameter])
            .padding(15);



        // Load data
        // ------------------------------



data = {
 "name":"flare",
 "bloggers":[
 {"label":"Blog 1","name":"Adigun Adekunle", "size":3245},
 {"label":"Blog 2","name":"Obadimu Adewale", "size":2500},
 {"label":"Blog 3","name":"Oluwaseun Walter", "size":2800},
 {"label":"Blog 4","name":"Kiran Bandeli", "size":900},
 {"label":"Blog 5","name":"Adekunle Mayowa", "size":1400},
 {"label":"Blog 6","name":"Nihal Hussain", "size":200},
 {"label":"Blog 7","name":"Adekunle Mayowa", "size":500},
 {"label":"Blog 8","name":"Adekunle Mayowa", "size":300},
 {"label":"Blog 9","name":"Adekunle Mayowa", "size":350},
 {"label":"Blog 10","name":"Adekunle Mayowa", "size":1400}
 ]
}


            //
            // Append chart elements
            //

            // Bind data
            var node = svg.selectAll(".d3-bubbles-node")
                .data(bubble.nodes(classes(data))
                .filter(function(d) { return !d.children; }))
                .enter()
                .append("g")
                    .attr("class", "d3-bubbles-node")
                    .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });

            // Append circles
            node.append("circle")
                .attr("r", function(d) { return d.r; })
                .style("fill", function(d,i) {
                  //return color(i);
                  if(i<5)
                  {
                    return "#0080cc";
                  }
                  else if(i>=5)
                  {
                    return "#78bce4";
                  }
                })
                .on('mouseover',tip.show)
                .on('mouseout', tip.hide);

            // Append text
            node.append("text")
                .attr("dy", ".3em")
                .style("fill", "#fff")
                .style("font-size", 12)
                .style("text-anchor", "middle")
                .text(function(d) { return d.label.substring(0, d.r / 3); });



        // Returns a flattened hierarchy containing all leaf nodes under the root.
        function classes(root) {
            var classes = [];

            function recurse(name, node) {
                if (node.bloggers) node.bloggers.forEach(function(child) { recurse(node.name, child); });
                else classes.push({packageName: name, className: node.name, value: node.size,label:node.label});
            }

            recurse(null, root);
            return {children: classes};
        }
    }
});
</script>
<script>


    var color = d3.scale.linear()
            .domain([0,1,2,3,4,5,6,10,15,20,80])
            .range(["#17394C", "#F5CC0E", "#CE0202", "#aaa", "#999", "#888", "#777", "#666", "#555", "#444", "#333", "#222"]);

</script>

<!-- End of blog bubble chart -->
</body>
</html>

<% } %>
