<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%@page import="authentication.*"%>
<%@page import="java.util.*"%>
<%@page import="util.*"%>
<%@page import="java.io.File"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
try{
	
Object email = (null == session.getAttribute("email")) ? "" : session.getAttribute("email");
Object tid = (null == request.getParameter("tid")) ? "" : request.getParameter("tid");

Object user = (null == session.getAttribute("username")) ? "" : session.getAttribute("username");
Object date_start = (null == request.getParameter("date_start")) ? "" : request.getParameter("date_start");
Object date_end = (null == request.getParameter("date_end")) ? "" : request.getParameter("date_end");
Object single = (null == request.getParameter("single_date")) ? "" : request.getParameter("single_date");
String sort =  (null == request.getParameter("sortby")) ? "blog" : request.getParameter("sortby").toString();//.replaceAll("[^a-zA-Z]", " ");


ArrayList<?> userinfo = new ArrayList();

String profileimage= "";
String username ="";
String name="";
String phone="";
String date_modified = "";
String trackername="";
Trackers tracker  = new Trackers();
Blogposts post  = new Blogposts();
Blogs blog  = new Blogs();
Terms term  = new Terms();
Blogpost_entitysentiment blogpostsentiment  = new Blogpost_entitysentiment();
ArrayList allterms = new ArrayList(); 
ArrayList allentitysentiments = new ArrayList(); 
Comment comment = new Comment();
Blogger blg = new Blogger();

userinfo = new DbConnection().query("SELECT * FROM usercredentials where Email = '"+email+"'");
if (userinfo.size()<1) {
	response.sendRedirect("login.jsp");
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
	}catch(Exception e){}
	
	}

	ArrayList detail =new ArrayList();
	if (tid != "") {
		detail = tracker._fetch(tid.toString());
	} else {
		detail = tracker._list("DESC", "", user.toString(), "1");
	}
	
	boolean isowner = false;
	JSONObject obj =null;
	String ids = "";
	if (detail.size() > 0) {
		//String res = detail.get(0).toString();
		ArrayList resp = (ArrayList<?>)detail.get(0);
		//System.out.println("details here-"+resp);

		String tracker_userid = resp.get(1).toString();
		trackername = resp.get(2).toString();
		if (tracker_userid.equals(user.toString())) {
			isowner = true;
			String query = resp.get(5).toString();//obj.get("query").toString();
			query = query.replaceAll("blogsite_id in ", "");
			query = query.replaceAll("\\(", "");
			query = query.replaceAll("\\)", "");
			ids = query;
		}
	}
	
	if (!isowner) {
		response.sendRedirect("index.jsp");
	}
	
	SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("MMM d, yyyy");
	SimpleDateFormat DATE_FORMAT2 = new SimpleDateFormat("yyyy-MM-dd");

	SimpleDateFormat DAY_ONLY = new SimpleDateFormat("dd");
	SimpleDateFormat MONTH_ONLY = new SimpleDateFormat("MM");
	SimpleDateFormat SMALL_MONTH_ONLY = new SimpleDateFormat("mm");
	SimpleDateFormat WEEK_ONLY = new SimpleDateFormat("dd");
	SimpleDateFormat YEAR_ONLY = new SimpleDateFormat("yyyy");
	
	String stdate = post._getDate(ids,"first");
	String endate = post._getDate(ids,"last");
	
	
	
	Date dstart = new Date();
	Date today = new Date();
	
	
	Date nnow = new Date(); 
	

	try{
		dstart = new SimpleDateFormat("yyyy-MM-dd").parse(stdate);
	}catch(Exception ex){
		dstart = nnow;//new SimpleDateFormat("yyyy-MM-dd").parse(nnow);
	}
	
	try{
		today = new SimpleDateFormat("yyyy-MM-dd").parse(endate);
	}catch(Exception ex){
		today = nnow;//new SimpleDateFormat("yyyy-MM-dd").parse(nnow);
	}
	  
	String day = DAY_ONLY.format(today);
	
	String month = MONTH_ONLY.format(today);
	
	String smallmonth = SMALL_MONTH_ONLY.format(today);

	String year = YEAR_ONLY.format(today);

	String dispfrom = DATE_FORMAT.format(dstart);
	String dispto = DATE_FORMAT.format(today);
	
	String historyfrom = DATE_FORMAT.format(dstart);
	String historyto = DATE_FORMAT.format(today);

	String dst = DATE_FORMAT2.format(dstart);
	String dend = DATE_FORMAT2.format(today);

		String totalpost = "0";
		ArrayList allauthors = new ArrayList();

		String possentiment = "0";
		String negsentiment = "0";
		String ddey = "31";
		String dt = dst;
		String dte = dend;
		String year_start="";
		String year_end="";
		if(!single.equals("")){
			month = MONTH_ONLY.format(nnow); 
			day = DAY_ONLY.format(nnow); 
			year = YEAR_ONLY.format(nnow); 
			//System.out.println("Now:"+month+"small:"+smallmonth);
			if(month.equals("02")){
				ddey = (Integer.parseInt(year)%4==0)?"28":"29";
			}else if(month.equals("09") || month.equals("04") || month.equals("05") || month.equals("11")){
				ddey = "30";
			}
		}
		
		if (!date_start.equals("") && !date_end.equals("")) {
			
			possentiment = post._searchRangeTotal("sentiment", "0", "10", ids);
			negsentiment = post._searchRangeTotal("sentiment", "-10", "-1", ids);
							
			Date start = new SimpleDateFormat("yyyy-MM-dd").parse(date_start.toString());
			Date end = new SimpleDateFormat("yyyy-MM-dd").parse(date_end.toString());
			
			dt = date_start.toString();
			dte = date_end.toString();
			
			historyfrom = DATE_FORMAT.format(start);
			historyto = DATE_FORMAT.format(end);

			
		} else if (single.equals("day")) {
			 dt = year + "-" + month + "-" + day;
			
				
		} else if (single.equals("week")) {
			
			 dte = year + "-" + month + "-" + day;
			int dd = Integer.parseInt(day)-7;
			
			Calendar cal = Calendar.getInstance();
			cal.add(Calendar.DATE, -7);
			Date dateBefore7Days = cal.getTime();
			dt = YEAR_ONLY.format(dateBefore7Days) + "-" + MONTH_ONLY.format(dateBefore7Days) + "-" + DAY_ONLY.format(dateBefore7Days);
			
							
		} else if (single.equals("month")) {
			dt = year + "-" + month + "-01";
			dte = year + "-" + month + "-"+day;	
			
		} else if (single.equals("year")) {
			dt = year + "-01-01";
			dte = year + "-12-"+ddey;
			
		}else {
			dt = dst;
			dte = dend;
			
		}  
		
		String[] yst = dt.split("-");
		String[] yend = dte.split("-");
		year_start = yst[0];
		year_end = yend[0];
		int ystint = new Double(year_start).intValue();
		int yendint = new Double(year_end).intValue();
		
		if(yendint>Integer.parseInt(YEAR_ONLY.format(new Date()))){
			dte = DATE_FORMAT2.format(new Date()).toString();	
			yendint = Integer.parseInt(YEAR_ONLY.format(new Date()));
		}
		
		if(ystint<2000){
			ystint = 2000;
			dt = "2000-01-01";
		}
		
		dispfrom = DATE_FORMAT.format(new SimpleDateFormat("yyyy-MM-dd").parse(dt));
		dispto = DATE_FORMAT.format(new SimpleDateFormat("yyyy-MM-dd").parse(dte));
			
		ArrayList influenceBlogger = blog._getInfluencialBlogger(ids);
		
	   // allauthors= post._getBloggerByBlogId("date", dt, dte, ids, "influence_score", "DESC");
		
	String allpost = "0";
	float totalinfluence = 0;
	
	String mostactiveblogger="";
	String mostactivebloggerId ="";

	String mostusedkeyword = "";
	String fsid = "";



	ArrayList allposts = new ArrayList();

//System.out.println(topterms);
%>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <title>COSMOS Demo | JS</title>
    <!-- Favicon-->
    <link rel="icon" href="favicon.ico" type="image/x-icon">


    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,700&subset=latin,cyrillic-ext" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet" type="text/css">

    <!-- Bootstrap Core Css -->
    <link href="material/plugins/bootstrap/css/bootstrap.css" rel="stylesheet">

    <!-- Waves Effect Css -->
    <link href="material/plugins/node-waves/waves.css" rel="stylesheet" />

    <!-- Animation Css -->
    <link href="material/plugins/animate-css/animate.css" rel="stylesheet" />

    <!-- Morris Chart Css-->
    <link href="material/plugins/morrisjs/morris.css" rel="stylesheet" />

    <!-- Custom Css -->
    <link href="material/css/style.css" rel="stylesheet">

    <!-- AdminBSB Themes. You can choose a theme from css/themes instead of get all themes -->
    <link href="material/css/themes/all-themes.css" rel="stylesheet" />

     <script src="https://d3js.org/d3.v5.min.js"></script>
    <link rel="stylesheet" type="text/css" href="multiline.css">

    <style type="text/css">
        section.content {
            margin: 100px 10px 0 15px;
            -moz-transition: 0.5s;
            -o-transition: 0.5s;
            -webkit-transition: 0.5s;
            transition: 0.5s;
        }
    </style>

</head>

<body class="theme-red">
    <!-- Page Loader -->
 <!--    <div class="page-loader-wrapper">
        <div class="loader">
            <div class="preloader">
                <div class="spinner-layer pl-red">
                    <div class="circle-clipper left">
                        <div class="circle"></div>
                    </div>
                    <div class="circle-clipper right">
                        <div class="circle"></div>
                    </div>
                </div>
            </div>
            <p>Please wait...</p>
        </div>
    </div> -->
    <!-- #END# Page Loader -->
    <!-- Overlay For Sidebars -->
    <div class="overlay"></div>
    <!-- #END# Overlay For Sidebars -->
    <!-- Search Bar -->
    <div class="search-bar">
        <div class="search-icon">
            <i class="material-icons">search</i>
        </div>
        <input type="text" placeholder="START TYPING...">
        <div class="close-search">
            <i class="material-icons">close</i>
        </div>
    </div>
    <!-- #END# Search Bar -->
    <!-- Top Bar -->
    <nav class="navbar">
        <div class="container-fluid">
            <div class="navbar-header">
                <a href="javascript:void(0);" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar-collapse" aria-expanded="false"></a>
                <a href="javascript:void(0);" class="bars"></a>
                <a class="navbar-brand" href="index.html">COSMOS - DEMO DESIGN</a>
            </div>
            <div class="collapse navbar-collapse" id="navbar-collapse">
                <ul class="nav navbar-nav navbar-right">
                    <!-- Call Search -->
                    <li><a href="javascript:void(0);" class="js-search" data-close="true"><i class="material-icons">search</i></a></li>
                    <!-- #END# Call Search -->
                    <!-- Notifications -->
                    <li class="dropdown">
                        <a href="javascript:void(0);" class="dropdown-toggle" data-toggle="dropdown" role="button">
                            <i class="material-icons">notifications</i>
                            <span class="label-count">7</span>
                        </a>
                        <ul class="dropdown-menu">
                            <li class="header">NOTIFICATIONS</li>
                            <li class="body">
                                <ul class="menu">
                                    <li>
                                        <a href="javascript:void(0);">
                                            <div class="icon-circle bg-light-green">
                                                <i class="material-icons">person_add</i>
                                            </div>
                                            <div class="menu-info">
                                                <h4>12 new members joined</h4>
                                                <p>
                                                    <i class="material-icons">access_time</i> 14 mins ago
                                                </p>
                                            </div>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="javascript:void(0);">
                                            <div class="icon-circle bg-cyan">
                                                <i class="material-icons">add_shopping_cart</i>
                                            </div>
                                            <div class="menu-info">
                                                <h4>4 sales made</h4>
                                                <p>
                                                    <i class="material-icons">access_time</i> 22 mins ago
                                                </p>
                                            </div>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="javascript:void(0);">
                                            <div class="icon-circle bg-red">
                                                <i class="material-icons">delete_forever</i>
                                            </div>
                                            <div class="menu-info">
                                                <h4><b>Nancy Doe</b> deleted account</h4>
                                                <p>
                                                    <i class="material-icons">access_time</i> 3 hours ago
                                                </p>
                                            </div>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="javascript:void(0);">
                                            <div class="icon-circle bg-orange">
                                                <i class="material-icons">mode_edit</i>
                                            </div>
                                            <div class="menu-info">
                                                <h4><b>Nancy</b> changed name</h4>
                                                <p>
                                                    <i class="material-icons">access_time</i> 2 hours ago
                                                </p>
                                            </div>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="javascript:void(0);">
                                            <div class="icon-circle bg-blue-grey">
                                                <i class="material-icons">comment</i>
                                            </div>
                                            <div class="menu-info">
                                                <h4><b>John</b> commented your post</h4>
                                                <p>
                                                    <i class="material-icons">access_time</i> 4 hours ago
                                                </p>
                                            </div>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="javascript:void(0);">
                                            <div class="icon-circle bg-light-green">
                                                <i class="material-icons">cached</i>
                                            </div>
                                            <div class="menu-info">
                                                <h4><b>John</b> updated status</h4>
                                                <p>
                                                    <i class="material-icons">access_time</i> 3 hours ago
                                                </p>
                                            </div>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="javascript:void(0);">
                                            <div class="icon-circle bg-purple">
                                                <i class="material-icons">settings</i>
                                            </div>
                                            <div class="menu-info">
                                                <h4>Settings updated</h4>
                                                <p>
                                                    <i class="material-icons">access_time</i> Yesterday
                                                </p>
                                            </div>
                                        </a>
                                    </li>
                                </ul>
                            </li>
                            <li class="footer">
                                <a href="javascript:void(0);">View All Notifications</a>
                            </li>
                        </ul>
                    </li>
                    <!-- #END# Notifications -->
                    <!-- Tasks -->
                    <li class="dropdown">
                        <a href="javascript:void(0);" class="dropdown-toggle" data-toggle="dropdown" role="button">
                            <i class="material-icons">flag</i>
                            <span class="label-count">9</span>
                        </a>
                        <ul class="dropdown-menu">
                            <li class="header">TASKS</li>
                            <li class="body">
                                <ul class="menu tasks">
                                    <li>
                                        <a href="javascript:void(0);">
                                            <h4>
                                                Footer display issue
                                                <small>32%</small>
                                            </h4>
                                            <div class="progress">
                                                <div class="progress-bar bg-pink" role="progressbar" aria-valuenow="85" aria-valuemin="0" aria-valuemax="100" style="width: 32%">
                                                </div>
                                            </div>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="javascript:void(0);">
                                            <h4>
                                                Make new buttons
                                                <small>45%</small>
                                            </h4>
                                            <div class="progress">
                                                <div class="progress-bar bg-cyan" role="progressbar" aria-valuenow="85" aria-valuemin="0" aria-valuemax="100" style="width: 45%">
                                                </div>
                                            </div>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="javascript:void(0);">
                                            <h4>
                                                Create new dashboard
                                                <small>54%</small>
                                            </h4>
                                            <div class="progress">
                                                <div class="progress-bar bg-teal" role="progressbar" aria-valuenow="85" aria-valuemin="0" aria-valuemax="100" style="width: 54%">
                                                </div>
                                            </div>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="javascript:void(0);">
                                            <h4>
                                                Solve transition issue
                                                <small>65%</small>
                                            </h4>
                                            <div class="progress">
                                                <div class="progress-bar bg-orange" role="progressbar" aria-valuenow="85" aria-valuemin="0" aria-valuemax="100" style="width: 65%">
                                                </div>
                                            </div>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="javascript:void(0);">
                                            <h4>
                                                Answer GitHub questions
                                                <small>92%</small>
                                            </h4>
                                            <div class="progress">
                                                <div class="progress-bar bg-purple" role="progressbar" aria-valuenow="85" aria-valuemin="0" aria-valuemax="100" style="width: 92%">
                                                </div>
                                            </div>
                                        </a>
                                    </li>
                                </ul>
                            </li>
                            <li class="footer">
                                <a href="javascript:void(0);">View All Tasks</a>
                            </li>
                        </ul>
                    </li>
                    <!-- #END# Tasks -->
                    <li class="pull-right"><a href="javascript:void(0);" class="js-right-sidebar" data-close="true"><i class="material-icons">more_vert</i></a></li>
                </ul>
            </div>
        </div>
    </nav>
    <!-- #Top Bar -->

     <section style="display: none;">
        <!-- Left Sidebar -->
        <aside id="leftsidebar" class="sidebar">
            <!-- User Info -->
            <div class="user-info">
                <div class="image">
                    <img src="images/user.png" width="48" height="48" alt="User" />
                </div>
                <div class="info-container">
                    <div class="name" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Wale Thomas</div>
                    <div class="email">wale.thomas@example.com</div>
                    <div class="btn-group user-helper-dropdown">
                        <i class="material-icons" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">keyboard_arrow_down</i>
                        <ul class="dropdown-menu pull-right">
                            <li><a href="javascript:void(0);"><i class="material-icons">person</i>Profile</a></li>
                            <li role="seperator" class="divider"></li>
                            <li><a href="javascript:void(0);"><i class="material-icons">group</i>Followers</a></li>
                            <li><a href="javascript:void(0);"><i class="material-icons">shopping_cart</i>Sales</a></li>
                            <li><a href="javascript:void(0);"><i class="material-icons">favorite</i>Likes</a></li>
                            <li role="seperator" class="divider"></li>
                            <li><a href="javascript:void(0);"><i class="material-icons">input</i>Sign Out</a></li>
                        </ul>
                    </div>
                </div>
            </div>
            <!-- #User Info -->
            <!-- Menu -->
            <div class="menu">
                <ul class="list">
                    <li class="header">MAIN NAVIGATION</li>
                  
                   
                    
                    
                    
                    <li class="active">
                        <a href="javascript:void(0);" class="menu-toggle">
                            <i class="material-icons">pie_chart</i>
                            <span>Charts</span>
                        </a>
                        <ul class="ml-menu">
                            <li class="active">
                                <a href="pages/charts/morris.html">Morris</a>
                            </li>
                            <li>
                                <a href="pages/charts/flot.html">Flot</a>
                            </li>
                            <li>
                                <a href="pages/charts/chartjs.html">ChartJS</a>
                            </li>
                            <li>
                                <a href="pages/charts/sparkline.html">Sparkline</a>
                            </li>
                            <li>
                                <a href="pages/charts/jquery-knob.html">Jquery Knob</a>
                            </li>
                        </ul>
                    </li>
                   
                    
                    
                    <li class="header">LABELS</li>
                    
                    
                    
                </ul>
            </div>
            <!-- #Menu -->
            <!-- Footer -->
            <div class="legal">
                <div class="copyright">
                    &copy; 2016 - 2017 <a href="javascript:void(0);">AdminBSB - Material Design</a>.
                </div>
                <div class="version">
                    <b>Version: </b> 1.0.5
                </div>
            </div>
            <!-- #Footer -->
        </aside>
        <!-- #END# Left Sidebar -->
        
    </section>
   

    <section class="content">
        <div class="container-fluid">
            

            <!-- Widgets -->
            <div class="row clearfix">

                <!-- Linked Items -->
                <div class="col-lg-3 col-md-3 col-sm-12 col-xs-12">
                    <div class="card">
                        <div class="header">
                            <h2 id="topic_selected">
                                TOPICS
                                
                               <input type="hidden" value="2008-10-18" id="date_start"	/>
                               <input type="hidden" value="2019-10-14" id="date_end"	/>
                              
                               
                            </h2>
                            <ul class="header-dropdown m-r--5">
                                <li class="dropdown">
                                    <a href="javascript:void(0);" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                        <i class="material-icons">more_vert</i>
                                    </a>
                                    <ul class="dropdown-menu pull-right">
                                        <li><a href="javascript:void(0);">Action</a></li>
                                        <li><a href="javascript:void(0);">Another action</a></li>
                                        <li><a href="javascript:void(0);">Something else here</a></li>
                                    </ul>
                                </li>
                            </ul>
                        </div>
                        <div class="body">
                            <div class="list-group">
                            
                         
                            
                            
                            
                            
                            
                               	<%
							System.out.println("0-1");
								JSONObject influecechart = new JSONObject();
								JSONObject authors = new JSONObject();
								JSONObject authoryears = new JSONObject();
								JSONObject years = new JSONObject();
								JSONArray yearsarray = new JSONArray();
								JSONObject locations = new JSONObject();
								
								int influencecount=0;
								
								String selectedid="";
								
								String postidss = "";
							
							    if (influenceBlogger.size() > 0) {
									int k = 0;
									for (int y = 0; y < 10; y++) {
									ArrayList<?> bloggerInfluence = (ArrayList<?>) influenceBlogger.get(y);
									String bloggerInf = bloggerInfluence.get(0).toString();
									String bloggerInfFreq = bloggerInfluence.get(1).toString();
									String blogsiteid = bloggerInfluence.get(2).toString();
								
									
									String dselected = "";
									String activew = "";
								
									String postids = "";					
										if (k < 10) {
												
												//String postcount = post._searchRangeTotalByBlogger("date", dt, dte, bloggerInf);		
												String postcount = blg._getpostByBlogger(bloggerInf);
												
												String freq = "";
												
												JSONObject xy = new JSONObject();
										    	
										    	String xaxis =  postcount;//post._searchRangeTotal("date", dt, dte, blogid);
										    	int val = new Double(blg._getInfluenceByBlogger(bloggerInf)).intValue(); 
										    	
										    	String yaxis = val+"";
										    	xy.put("x",yaxis);
										    	xy.put("y",xaxis);
												
												
										    	influecechart.put(bloggerInf,xy);
										    	
											if(k==0){
												
												activew = "thanks";
												
												dselected = "abloggerselected";
												mostactiveblogger = bloggerInf;	
												mostactivebloggerId = blogsiteid;
												
												allposts =  post._getBloggerByBloggerName("date",dt, dte,bloggerInf,"influence_score","DESC");
												
											}
											%>
											<input type="hidden" id="postby<%=bloggerInf.replaceAll(" ","__")%>" value="<%=postids%>" />
<a href="javascript:void(0);" name="<%=bloggerInf%>" class="topics  topics1 blogger-select list-group-item  bloggerinactive mb20 <%=dselected%> <%=activew%>"  id="<%=blogsiteid%>" ><%=bloggerInf%></a>
					    			
					    			
					    			
											<%
											k++;
														
										}
									}
							    }	
							%>
                            
                            
                            </div>
                        </div>
                    </div>
                </div>
                <!-- #END# Linked Items -->

            <div class="col-md-9">
                    
                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                    
                    <div class="card">
                        <div class="header">
                            <h2>AREA CHART</h2>
                            <ul class="header-dropdown m-r--5">
                                <li class="dropdown">
                                    <a href="javascript:void(0);" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                        <i class="material-icons">more_vert</i>
                                    </a>
                                    <ul class="dropdown-menu pull-right">
                                        <li><a href="javascript:void(0);">Action</a></li>
                                        <li><a href="javascript:void(0);">Another action</a></li>
                                        <li><a href="javascript:void(0);">Something else here</a></li>
                                    </ul>
                                </li>
                            </ul>
                        </div>
                        <div class="body">
                            <!-- <div id="area_chart" class="graph"></div> -->


                            <div style="width: 100%;" class="graph" id="chart"></div>
                        </div>
                    </div>

                </div>



                </div>
				
				

            </div>
            

            
        </div>
    </section>

    <!-- Jquery Core Js -->
    <script src="material/plugins/jquery/jquery.min.js"></script>

    <!-- Bootstrap Core Js -->
    <script src="material/plugins/bootstrap/js/bootstrap.js"></script>

    <!-- Select Plugin Js -->
    <script src="material/plugins/bootstrap-select/js/bootstrap-select.js"></script>

    <!-- Slimscroll Plugin Js -->
    <script src="material/plugins/jquery-slimscroll/jquery.slimscroll.js"></script>

    <!-- Waves Effect Plugin Js -->
    <script src="material/plugins/node-waves/waves.js"></script>

    <!-- Jquery CountTo Plugin Js -->
    <script src="material/plugins/jquery-countto/jquery.countTo.js"></script>

     <!-- Morris Plugin Js -->
    <script src="material/plugins/raphael/raphael.min.js"></script>
    <script src="material/plugins/morrisjs/morris.js"></script>

    <!-- Custom Js -->
    <script src="material/js/admin.js"></script>
    <!-- <script src="js/pages/charts/morris.js"></script> -->

     <!-- <script type="text/javascript" src="test.js"></script> -->

    <!-- ChartJs -->
    <script src="material/plugins/chartjs/Chart.bundle.js"></script>
    
    
    
    <script src="pagedependencies/baseurl.js"></script>
    
    
    
    
    
    
    
    <script>
    
 /////////////////////////////////////////////////////
    
    
    
    <%

    Liwc liwc = new Liwc();
    //String possentiment2 =new Liwc()._searchRangeAggregate("date", dt, dte, sentimentpost,"posemo");
    //String negsentiment2 =new Liwc()._searchRangeAggregate("date", dt, dte, sentimentpost,"negemo");

    String possentiment2= liwc._getPosEmotionByBlogger(mostactiveblogger);
    String negsentiment2  = liwc._getNegEmotionByBlogger(mostactiveblogger);


    int comb = new Double(possentiment2).intValue() + new Double(negsentiment2).intValue();
    String totalcomment =  comment._getCommentByBlogger(mostactiveblogger);

    String formattedtotalcomment = NumberFormat.getNumberInstance(Locale.US).format(Integer.parseInt(totalcomment));
    System.out.println("hi 20");
    totalinfluence  = Float.parseFloat(post._searchRangeMaxTotalByBloggers(mostactiveblogger));

    Float highestinfluence = Float.parseFloat(post._searchMaxInfluence());
    Float lowestinfluence = Float.parseFloat(post._searchMinInfluence());
    System.out.println("hi 10");

    Float highestsentiment = Float.parseFloat(liwc._getHighestPosSentiment());
    Float lowestsentiment = Float.parseFloat(liwc._getLowestNegSentiment());
    Float totalsentiment = Float.parseFloat(comb+"");
    System.out.println("hi 11");
    System.out.println("highest:"+highestsentiment);
    System.out.println("lowest:"+lowestsentiment);
    System.out.println("real:"+totalsentiment);

    int normalizedinfluence =  Math.round((2-(-2))*((totalinfluence-lowestinfluence)/(highestinfluence-lowestinfluence))+(-2));
    int normalizedsentiment =  Math.round((2-(-2))*((totalsentiment-lowestsentiment)/(highestsentiment-lowestsentiment))+(-2));

    String formatedtotalinfluence = NumberFormat.getNumberInstance(Locale.US).format(totalinfluence);
    System.out.println("hi 1");
    totalpost = post._searchRangeTotalByBlogger("date",dt, dte, mostactiveblogger);
    System.out.println("hi 2");
    String formattedtotalpost = NumberFormat.getNumberInstance(Locale.US).format(Integer.parseInt(totalpost));
    System.out.println("hi 3");
    String totalsenti  = comb+"";

    //allterms = term._searchByRange("blogpostid", dt, dte,postidss);
    //allterms = term.getTermsByBlogger(mostactiveblogger, dt, dte);
    System.out.println("Starting terms stuff");
    allterms = term._getBloggerTermById("blogsiteid", dt, dte, mostactivebloggerId);
    System.out.println("Ending terms stuff");
    int highestfrequency = 0;
    System.out.println("7");
    Map<String, Integer> topterms = new HashMap<String, Integer>();
    if (allterms.size() > 0) {
    	for (int p = 0; p < allterms.size(); p++) {
    		String bstr = allterms.get(p).toString();
    		JSONObject bj = new JSONObject(bstr);
    		bstr = bj.get("_source").toString();
    		bj = new JSONObject(bstr);
    		String tm = bj.get("term").toString();
    		String frequency = bj.get("frequency").toString();
    		int frequency2 = Integer.parseInt(frequency);
    		
    		int freq = frequency2;
    		if (topterms.containsKey(tm)) {
    			topterms.put(tm, topterms.get(tm) + frequency2);
    			freq= topterms.get(tm) + frequency2;
    		} else {
    			topterms.put(tm, frequency2);
    		}
    		
    		if(freq>highestfrequency){
    			highestfrequency = freq;
    			mostusedkeyword = tm;
    		}
    		
    	}
    }



    int base = 0;

    JSONObject postyear =new JSONObject();
    if(influenceBlogger.size()>0){
    	for(int n=0; n<1;n++){
    		int b=0;

    		for(int y=ystint; y<=yendint; y++){ 
    				   String dtu = y + "-01-01";
    				   String dtue = y + "-12-31";
    				   if(b==0){
    						dtu = dt;
    					}else if(b==yendint){
    						dtue = dte;
    					}
    				   String totu = post._searchRangeMaxByBloggers("date",dtu, dtue,mostactiveblogger);
    				   
    				   if(new Double(totu).intValue() <base){
    					   base = new Double(totu).intValue();
    				   }
    				   
    				   if(!years.has(y+"")){
    			    		years.put(y+"",y);
    			    		yearsarray.put(b,y);
    			    		b++;
    			    	}
    				   
    				   postyear.put(y+"",totu);
    		}
    		//authoryears.put(mostactiveblogger,postyear);
    	}
    }


    base = Math.abs(base);
    if(postyear.length()>0){
    		for(int y=ystint; y<=yendint; y++){ 
    				   String v1 = postyear.get(y+"").toString();
    				   int re = new Double(v1).intValue()+base;
    				   postyear.put(y+"",re+"");
    		}
    		
    }
    authoryears.put(mostactiveblogger,postyear);
    %>
 
    var uche = [];
     
    

    function color1(i, id, name){
    	
    	var t = parseFloat(i);

    switch(t) {

      //case 0:
        //var hex = 'yellow';
      case 1:
        var hex = 'green'; 
        break;
      case 2:
        var hex = '#c18fb6';
        break;
      case 3:
        var hex = '#8fc199';
        break;
      case 4:
        var hex = '#c1958f';
        break;
      case 5:
        var hex = '#e17d70';
        break;
      case 6:
        var hex = '#b770e1';
        break;
      case 7:
        var hex = '#1fa701';
        break;
      case 8:
        var hex = '#011aa7';
        break;
      case 9:
        var hex = '#a78901';
        break;
      case 10:
        var hex = '#981010';
        break;
      default:
        var hex = 'red';

    }


    
    $('.thanks').each(function() {
    	
    	var g = $(this).attr('name');
    	
        if ( $(this).attr('name') == ''+name+'' ) {
        	$(this).css('background-color', hex);
        };
        
    });
    return hex;


    }


    //////////////////////////////////////////////////////////////
    
    $(document).ready(function(){
    	  setTimeout(
     			  function() 
     			  { 
           finalGraph();
        }, 1000)
    });
    
    
    $(document).delegate('.topics1', 'click', function(){

        var id = this.id;
        var name = $(this).attr('name');
        
       
       $('#chart').html('');

       if ( $(this).hasClass("thanks") ) {
            
          $(this).removeClass("thanks"); 

          $(this).addClass('nobccolor');


        }else{

          $(this).removeClass('nobccolor');

          $(this).addClass("thanks"); 
          

        }

      	
       setTimeout(
 			  function() 
 			  { 
       finalGraph();
    }, 2000)
      
      

      })
      
      $(document).delegate('#test_click', 'click', function(){
    	  
    	  
    	  setTimeout(
     			  function() 
     			  { 
           finalGraph();
        }, 2000)
      })
      
    
   function finalGraph(){
    	
    	var data1 = [];
    	
    	var data = [];
    	
    	var highest_date_index = 0;
   		var highest_price_index = 0;
    		
  		var highest_date = 0;
  		var highest_price = 0;
    	
    	 var count = $('.thanks').length;
    	 
    	 //alert(count);
    	 
    	 if(count > 0){
    		 
    		 
    		 
    		 $( ".thanks" ).each(function( index ) {
    			 
       		  		var ind = index;
       		  		
    		    	blog_name = 	$(this).attr('name');
    		    	
    		    	blog_id = 	this.id;
    		    		
    		    		
    		    ////start ajax
    		    	
    		        
    		    	$.ajax({
    		  			url: app_url + "InfluenceTest",
    		  			method: 'POST',
    		  			dataType: 'json',
    		  			data: {
    		  				action:"getchart",
    		  				blogger:blog_name,
    		  				blog_id:blog_id,
    		  				index:ind,
    		  				async: false,
    		  				sort:"influence_score",
    		  				date_start:$("#date_start").val(),
    		  				date_end:$("#date_end").val(),
    		  			},
    		  			error: function(response)
    		  			{						
    		  				alert('error');
    		  				console.log(response);
    		  			//	$("#chart-container").html(response);
    		  			},
    		  			success: function(response)
    		  			{   
    		  				var arr1 = [];
    		  	
    		  				$.each(response.values, function( key, value ) {
    		  					
    		  				
    		  					var d = parseFloat(key);
    		  					var p = parseFloat(value);
    		  					
    		  					if(d > highest_date){
    		  						highest_date = key;
    		  						highest_date_index = response.index;
    		  						
    		  					}
    		  					
    		  					if(p > highest_price){
    		  						highest_price = value;
    		  						highest_price_index = response.index;
    		  						
    		  					}
    		  					
    		  					
    		  					var string2 = key.toString();
    		  				
    		  					var string3 = value.toString();
    		  				
    		  					arr1.push({date: string2 ,price: string3});
    		  					
    			  				
    				  		});
    		  				
    		  				
    		  				data1.push(
    		  						      
    		  						      {
    		  						        name: response.name,
    		  						      	identify: response.identify,
    		  						        values: 
    		  						          
    		  						        	  arr1
    		  						        	
    		  						      }
    		  						    );
    		  				 
    		  				
    		    	
    				  			}
    		  			
    		  			
    		  			
    				  		});
    		    	
    		  
    		    ///////end ajax
    		    		
    		    		
    		    		
    		    		});
    		 
    		 
    		 
    		 
    	    	
    	    	
    	    	  setTimeout(
    	    			  function() 
    	    			  {
    	    					
    	    				  data1.forEach((arrayItem) => {
    	    				    data.push(arrayItem)
    	    				  });
    	    				  
    	    			/////////start graph stuff

    	    				
    	    				 			var width = $('#chart').width();
    	    							//var width = 700;
    	    				 		    var height = 400;
    	    				 		    var margin = 50;
    	    				 		    var duration = 250;

    	    				 		    var lineOpacity = "0.5";
    	    				 		    var lineOpacityHover = "0.85";
    	    				 		    var otherLinesOpacityHover = "0.1";
    	    				 		    var lineStroke = "1.5px";
    	    				 		    var lineStrokeHover = "2.5px";

    	    				 		    var circleOpacity = '0.85';
    	    				 		    var circleOpacityOnLineHover = "0.25"
    	    				 		    var circleRadius = 3;
    	    				 		    var circleRadiusHover = 6;


    	    				 		    /* Format Data */
    	    				 		    var parseDate = d3.timeParse("%Y");
    	    				 		    data.forEach(function(d, i) {
    	    				 		    	
    	    				 		      d.values.forEach(function(d) {
    	    				 		        d.date = parseDate(d.date);
    	    				 		        d.price = +d.price;    
    	    				 		      });
    	    				 		      
    	    				 		    });


    	    				 		    /* Scale */
    	    				 		    var xScale = d3.scaleTime()
    	    				 		      .domain(d3.extent(data[highest_date_index].values, d => d.date))
    	    				 		      .range([0, width-margin]);

    	    				 		   //var yScale = d3.scaleLinear()
 	    				 		      //.domain([0, d3.max(data[highest_price_index].values, d => d.price)])
 	    				 		     // .range([height-margin, 0]);
    	    				 		   
    	    				 		    var yScale = d3.scaleLinear()
    	    				 		      .domain([0, highest_price])
    	    				 		      .range([height-margin, 0]);
    	    				 		  
    	    				 		     

    	    				 		    var color = d3.scaleOrdinal(d3.schemeCategory10);

    	    				 		    /* Add SVG */
    	    				 		    var svg = d3.select("#chart").append("svg")
    	    				 		      .attr("width", width+margin)
    	    				 		      .attr("height", (height+margin)+"px")
    	    				 		      .append('g')
    	    				 		      .attr("transform", `translate(${margin}, ${margin})`);


    	    				 		    /* Add line into SVG */
    	    				 		    var line = d3.line()
    	    				 		      .x(d => xScale(d.date))
    	    				 		      .y(d => yScale(d.price));

    	    				 		    let lines = svg.append('g')
    	    				 		      .attr('class', 'lines');


    	    				 		    lines.selectAll('.line-group')
    	    				 		      .data(data).enter()
    	    				 		      .append('g')
    	    				 		      .attr('class', 'line-group')  
    	    				 		      .on("mouseover", function(d, i) {
    	    				 		    	  
    	    				 		          svg.append("text")
    	    				 		            .attr("class", "title-text")
    	    				 		            .style("fill", color1(i, d.identify, d.name))        
    	    				 		            .text(d.name)
    	    				 		            .attr("text-anchor", "middle")
    	    				 		            .attr("x", (width-margin)/2)
    	    				 		            .attr("y", 5);
    	    				 		        })
    	    				 		      .on("mouseout", function(d) {
    	    				 		          svg.select(".title-text").remove();
    	    				 		        })
    	    				 		      .append('path')
    	    				 		      .attr('class', 'line')  
    	    				 		      .attr('d', d => line(d.values))
    	    				 		      .style('stroke', (d, i) => color1(i, d.identify, d.name))
    	    				 		      .style('opacity', lineOpacity)
    	    				 		      .on("mouseover", function(d) {
    	    				 		          d3.selectAll('.line')
    	    				 		              .style('opacity', otherLinesOpacityHover);
    	    				 		          d3.selectAll('.circle')
    	    				 		              .style('opacity', circleOpacityOnLineHover);
    	    				 		          d3.select(this)
    	    				 		            .style('opacity', lineOpacityHover)
    	    				 		            .style("stroke-width", lineStrokeHover)
    	    				 		            .style("cursor", "pointer");
    	    				 		        })
    	    				 		      .on("mouseout", function(d) {
    	    				 		          d3.selectAll(".line")
    	    				 		              .style('opacity', lineOpacity);
    	    				 		          d3.selectAll('.circle')
    	    				 		              .style('opacity', circleOpacity);
    	    				 		          d3.select(this)
    	    				 		            .style("stroke-width", lineStroke)
    	    				 		            .style("cursor", "none");
    	    				 		        });


    	    				 		    /* Add circles in the line */
    	    				 		    lines.selectAll("circle-group")
    	    				 		      .data(data).enter()
    	    				 		      .append("g")
    	    				 		      .style("fill", (d, i) => color1(i, d.identify, d.name))
    	    				 		      .selectAll("circle")
    	    				 		      .data(d => d.values).enter()
    	    				 		      .append("g")
    	    				 		      .attr("class", "circle")  
    	    				 		      .on("mouseover", function(d) {
    	    				 		          d3.select(this)     
    	    				 		            .style("cursor", "pointer")
    	    				 		            .append("text")
    	    				 		            .attr("class", "text")
    	    				 		            .text(`${d.price}`)
    	    				 		            .attr("x", d => xScale(d.date) + 5)
    	    				 		            .attr("y", d => yScale(d.price) - 10);
    	    				 		        })
    	    				 		      .on("mouseout", function(d) {
    	    				 		          d3.select(this)
    	    				 		            .style("cursor", "none")  
    	    				 		            .transition()
    	    				 		            .duration(duration)
    	    				 		            .selectAll(".text").remove();
    	    				 		        })
    	    				 		      .append("circle")
    	    				 		      .attr("cx", d => xScale(d.date))
    	    				 		      .attr("cy", d => yScale(d.price))
    	    				 		      .attr("r", circleRadius)
    	    				 		      .style('opacity', circleOpacity)
    	    				 		      .on("mouseover", function(d) {
    	    				 		            d3.select(this)
    	    				 		              .transition()
    	    				 		              .duration(duration)
    	    				 		              .attr("r", circleRadiusHover);
    	    				 		          })
    	    				 		        .on("mouseout", function(d) {
    	    				 		            d3.select(this) 
    	    				 		              .transition()
    	    				 		              .duration(duration)
    	    				 		              .attr("r", circleRadius);  
    	    				 		          });


    	    				 		    /* Add Axis into SVG */
    	    				 		    var xAxis = d3.axisBottom(xScale).ticks(5);
    	    				 		    var yAxis = d3.axisLeft(yScale).ticks(5);

    	    				 		    svg.append("g")
    	    				 		      .attr("class", "x axis")
    	    				 		      .attr("transform", `translate(0, ${height-margin})`)
    	    				 		      .call(xAxis);

    	    				 		    svg.append("g")
    	    				 		      .attr("class", "y axis")
    	    				 		      .call(yAxis)
    	    				 		      .append('text')
    	    				 		      .attr("y", 15)
    	    				 		      .attr("transform", "rotate(-90)")
    	    				 		      .attr("fill", "#000")
    	    				 		      .text("Total values");
    	    				 		
    	    				 	/////////end graph stuff	
    	    				  
    	    				  
    	    				  
    	    			  }, 3000)
    	    			  
    		 
    		 
    		 
    		 
    		 
    		 
    	 }else{
    		 alert("no active selection");
    	 }
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	

    	
    	
    }
    
    </script>
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
   

    

    <!-- Sparkline Chart Plugin Js -->
    <script src="material/plugins/jquery-sparkline/jquery.sparkline.js"></script>

    <!-- Custom Js -->
    <script src="material/js/admin.js"></script>
 

    <!-- Demo Js -->
    <script src="material/js/demo.js"></script>
</body>

</html>
<%

}catch(Exception e){
	
	//response.sendRedirect("index.jsp");
}

%>