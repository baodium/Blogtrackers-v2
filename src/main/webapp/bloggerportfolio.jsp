<%@page import="authentication.*"%>
<%@page import="java.util.*"%>
<%@page import="util.*"%>
<%@page import="java.io.File"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.net.URI"%>
<%@page import="java.text.NumberFormat" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.time.LocalDateTime"%>
	
<%
	Object email = (null == session.getAttribute("email")) ? "" : session.getAttribute("email");
	Object tid = (null == request.getParameter("tid")) ? "" : request.getParameter("tid");

	Object user = (null == session.getAttribute("username")) ? "" : session.getAttribute("username");
	Object date_start = (null == request.getParameter("date_start")) ? "" : request.getParameter("date_start");
	Object date_end = (null == request.getParameter("date_end")) ? "" : request.getParameter("date_end");
	Object single = (null == request.getParameter("single_date")) ? "" : request.getParameter("single_date");
	String sort =  (null == request.getParameter("sortby")) ? "blog" : request.getParameter("sortby").toString().replaceAll("[^a-zA-Z]", " ");
	String attachedblogger =  (null == request.getParameter("blogger")) ? "" : request.getParameter("blogger");

	
	//System.out.println(date_start);
	if (user == null || user == "") {
		response.sendRedirect("index.jsp");
	} else {

		ArrayList<?> userinfo = null;
		String profileimage = "";
		String username = "";
		String name = "";
		String phone = "";
		String date_modified = "";
		ArrayList detail = new ArrayList();
		ArrayList termss = new ArrayList();
		ArrayList outlinks = new ArrayList();
		ArrayList liwcpost = new ArrayList();

		Trackers tracker = new Trackers();
		Terms term = new Terms();
		Outlinks outl = new Outlinks();
		if (tid != "") {
			detail = tracker._fetch(tid.toString());	
		} else {
			detail = tracker._list("DESC", "", user.toString(), "1");
		}
		
		boolean isowner = false;
		JSONObject obj = null;
		String ids = "";
		String trackername="";
		if (detail.size() > 0) {
			//String res = detail.get(0).toString();
			ArrayList resp = (ArrayList<?>)detail.get(0);

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
		
		userinfo = new DbConnection().query("SELECT * FROM usercredentials where Email = '" + email + "'");
		if (userinfo.size() < 1 || !isowner) {
			response.sendRedirect("index.jsp");
		} else {
			userinfo = (ArrayList<?>) userinfo.get(0);
			try {
					username = (null == userinfo.get(0)) ? "" : userinfo.get(0).toString();
	
					name = (null == userinfo.get(4)) ? "" : (userinfo.get(4).toString());
					email = (null == userinfo.get(2)) ? "" : userinfo.get(2).toString();
					phone = (null == userinfo.get(6)) ? "" : userinfo.get(6).toString();
					String userpic = userinfo.get(9).toString();
					String path = application.getRealPath("/").replace('\\', '/') + "images/profile_images/";
					String filename = userinfo.get(9).toString();
	
					profileimage = "images/default-avatar.png";
					if (userpic.indexOf("http") > -1) {
						profileimage = userpic;
					}
	
					File f = new File(filename);
					if (f.exists() && !f.isDirectory()) {
						profileimage = "images/profile_images/" + userinfo.get(2).toString() + ".jpg";
					}
			} catch (Exception e) {
			
			}

			String[] user_name = name.split(" ");
			Blogposts post = new Blogposts();
			Blogs blog = new Blogs();
			Blogger bloggerss = new Blogger();
			Sentiments senti = new Sentiments();

			//Date today = new Date();
			SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("MMM d, yyyy");
			SimpleDateFormat DATE_FORMAT2 = new SimpleDateFormat("yyyy-MM-dd");

			SimpleDateFormat DAY_ONLY = new SimpleDateFormat("dd");
			SimpleDateFormat MONTH_ONLY = new SimpleDateFormat("MM");
			SimpleDateFormat SMALL_MONTH_ONLY = new SimpleDateFormat("mm");
			SimpleDateFormat WEEK_ONLY = new SimpleDateFormat("dd");
			SimpleDateFormat YEAR_ONLY = new SimpleDateFormat("yyyy");
			
			SimpleDateFormat DAY_NAME_ONLY = new SimpleDateFormat("EEEE");
			
			String stdate = post._getDate(ids,"first");
			String endate = post._getDate(ids,"last");
			
			Date dstart = new SimpleDateFormat("yyyy-MM-dd").parse(stdate);
			Date today = new SimpleDateFormat("yyyy-MM-dd").parse(endate);

			Date nnow = new Date();  
			  
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

			//ArrayList posts = post._list("DESC","");
			ArrayList sentiments = senti._list("DESC", "", "id");
			 
		 	/* Liwc liwc = new Liwc();
			
			ArrayList liwcSent = liwc._list("DESC", ""); 
			
			String test = post._searchRangeTotal("date", "2013-04-01", "2018-04-01", "1");
			
			System.out.println(test);  */
		
			
			String totalpost = "0";
			
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
			//System.out.println(s)
			//System.out.println("start date"+date_start+"end date "+date_end);
			if (!date_start.equals("") && !date_end.equals("")) {
				totalpost = post._searchRangeTotal("date", date_start.toString(), date_end.toString(), ids);

				//possentiment = post._searchRangeTotal("sentiment", "0", "10", ids);
				//negsentiment = post._searchRangeTotal("sentiment", "-10", "-1", ids);
								

				Date start = new SimpleDateFormat("yyyy-MM-dd").parse(date_start.toString());
				Date end = new SimpleDateFormat("yyyy-MM-dd").parse(date_end.toString());
				
				dt = date_start.toString();
				dte = date_end.toString();
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
				
				
			} else {
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
			
			String month_start = yst[1];
			String month_end = yend[1];
			
			
			dispfrom = DATE_FORMAT.format(new SimpleDateFormat("yyyy-MM-dd").parse(dt));
			dispto = DATE_FORMAT.format(new SimpleDateFormat("yyyy-MM-dd").parse(dte));
			
			
			String[] idss = ids.split(",");
			String selectedblogid = idss[0];
			
			String mostactiveblogger ="";
			String mostactiveblogurl ="";
			
			ArrayList activeblogposts = post._getBloggerByBlogId("date", dt, dte, selectedblogid, "influence_score", "DESC");
			String mostactiveterm = "";
			ArrayList bloggerPostFrequency = bloggerss._getBloggerPostFrequency(ids);
			//System.out.println("Terms here:"+termss);
			
			ArrayList blogs = blog._fetch(ids);
			int totalblog = blogs.size();
			
			JSONObject graphyears = new JSONObject();
		    JSONArray yearsarray = new JSONArray();
		    
		    JSONObject authors = new JSONObject();
		    JSONObject blgers = new JSONObject();
		    JSONArray sentimentpost = new JSONArray();
		    
		    JSONArray authorcount = new JSONArray();
		    JSONObject language = new JSONObject();
		    ArrayList langlooper = new ArrayList();
		    
		    int sun=0;
		    int mon=0;
		    int tue=0;
		    int wed =0;
		    int thur =0;
		    int fri=0;
		    int sat =0;
		    

			int highestpost = 0;
			if (bloggerPostFrequency.size() > 0) {
				int p = 0;
				for (int m = 0; m < 1; m++) {
					ArrayList<?> bloggerFreq = (ArrayList<?>) bloggerPostFrequency.get(m);
					String bloggerName = bloggerFreq.get(0).toString();
					String blogsiteId = bloggerFreq.get(2).toString();
					mostactiveblogger = bloggerName;
					selectedblogid = blogsiteId;
				}
			}
			
			if(activeblogposts.size()>0){
				String tres = null;
				JSONObject tresp = null;
				String tresu = null;
				JSONObject tobj = null;
				int j=0;
				int k=0;
				int n = 0;
			for(int i=0; i< activeblogposts.size(); i++){
						tres = activeblogposts.get(i).toString();			
						tresp = new JSONObject(tres);
					    tresu = tresp.get("_source").toString();
					    tobj = new JSONObject(tresu);
					    
					    String auth = tobj.get("blogger").toString();
					    String lang = tobj.get("language").toString();
					    String blogsite_id = tobj.get("blogsite_id").toString();
					    String btoty = post._getTotalByBlogger(auth,"date",dt, dte);
						int totalcounter = Integer.parseInt(btoty);
						URI uri = new URI(tobj.get("permalink").toString());							
						
						if(totalcounter>highestpost){
							highestpost = totalcounter;
							//mostactiveblogger = auth;							
							mostactiveblogurl = uri.getHost();
						}
					    
					    
					    if(attachedblogger.equals(auth)){
					    	mostactiveblogger = auth;
					    	mostactiveblogurl = uri.getHost();
					    }
					    
					    JSONObject content = new JSONObject();
					   
					  	String[] dateyear=tobj.get("date").toString().split("-");
					    String yy= dateyear[0];
					    
					    if(mostactiveblogger.equals(tobj.get("blogger").toString())){
					    	sentimentpost.put(tobj.get("blogpost_id").toString());
					    	
					    	Date rawdaydate = new SimpleDateFormat("yyyy-mm-dd").parse(tobj.get("date").toString());
						    String rawday = DAY_NAME_ONLY.format(rawdaydate);
						   
						    if(rawday.equals("Sunday")){
						    	sun++;
						    }else if(rawday.equals("Monday")){
						    	mon++;
						    }else if(rawday.equals("Tuesday")){
						    	tue++;
						    }else if(rawday.equals("Wednesday")){
						    	wed++;
						    }else if(rawday.equals("Thursday")){
						    	thur++;
						    }else if(rawday.equals("Friday")){
						    	fri++;
						    }else if(rawday.equals("Saturday")){
						    	sat++;
						    }
					    }
					   
				}
			} 
			
			
			
			
			
			
			if(single.equals("month")){
				//int diff = post.monthsBetweenDates(DATE_FORMAT2.parse(dt), DATE_FORMAT2.parse(dte));
				//ystint=0;
				//yendint = diff;
			}
			int b=0;
			int jan=0;
			int feb=0;
			int march=0;
			int apr=0;
			int may=0;
			int june=0;
			int july=0;
			int aug=0;
			int sep=0;
			int oct=0;
			int nov=0;
			int dec=0;
			
			for(int y=ystint; y<=yendint; y++){ 
					   String dtu = y + "-01-01";

					   String dtue = y + "-12-31";
					   
					   if(b==0){
							dtu = dt;
						}else if(b==yendint){
							dtue = dte;
						}
					   
					   
					   String totu = post._searchRangeTotal("date",dtu, dtue,selectedblogid);
					    
					   jan += Integer.parseInt(post._searchRangeTotalByBlogger("date",y + "-01-01", y + "-01-31",mostactiveblogger));
					    feb += Integer.parseInt(post._searchRangeTotalByBlogger("date",y + "-02-01", y + "-02-29",mostactiveblogger));
					    march += Integer.parseInt(post._searchRangeTotalByBlogger("date",y + "-03-01", y + "-03-31",mostactiveblogger));
					   	apr += Integer.parseInt(post._searchRangeTotalByBlogger("date",y + "-04-01", y + "-04-30",mostactiveblogger));
					    may += Integer.parseInt(post._searchRangeTotalByBlogger("date",y + "-05-01", y + "-05-31",mostactiveblogger));
					    june += Integer.parseInt(post._searchRangeTotalByBlogger("date",y + "-06-01", y + "-06-30",mostactiveblogger));
					   	july += Integer.parseInt(post._searchRangeTotalByBlogger("date",y + "-07-01", y + "-07-31",mostactiveblogger));
					   	aug += Integer.parseInt(post._searchRangeTotalByBlogger("date",y + "-08-01", y + "-08-31",mostactiveblogger));
					    sep += Integer.parseInt(post._searchRangeTotalByBlogger("date",y + "-09-01", y + "-09-30",mostactiveblogger));
					   oct += Integer.parseInt(post._searchRangeTotalByBlogger("date",y + "-10-01", y + "-10-31",mostactiveblogger));
					   nov += Integer.parseInt(post._searchRangeTotalByBlogger("date",y + "-11-01", y + "-11-30",mostactiveblogger));
					   dec += Integer.parseInt(post._searchRangeTotalByBlogger("date",y + "-12-01", y + "-12-31",mostactiveblogger));
					   
					   graphyears.put(y+"",totu);
			    	   yearsarray.put(b,y);	
			    	   b++;
			}
			

			
			possentiment=new Liwc()._searchRangeAggregate("date", yst[0]+"-01-01", yend[0]+"-12-31", sentimentpost,"posemo");
			negsentiment=new Liwc()._searchRangeAggregate("date", yst[0]+"-01-01", yend[0]+"-12-31", sentimentpost,"negemo");
			
			JSONArray sortedyearsarray = yearsarray;//post._sortJson(yearsarray);
			int highestfrequency = 0;
			 String blogids = "";

outlinks = outl._searchByRange("date", dt, dte, selectedblogid);

JSONObject outerlinks = new JSONObject();
ArrayList outlinklooper = new ArrayList();
if (outlinks.size() > 0) {
	int mm=0;
	for (int p = 0; p < outlinks.size(); p++) {
		String bstr = outlinks.get(p).toString();
		JSONObject bj = new JSONObject(bstr);
		bstr = bj.get("_source").toString();
		bj = new JSONObject(bstr);
		String link = bj.get("link").toString();
		
		JSONObject content = new JSONObject();
		String maindomain="";
		try {
			URI uri = new URI(link);
			String domain = uri.getHost();
			if (domain.startsWith("www.")) {
				maindomain = domain.substring(4);
			} else {
				maindomain = domain;
			}
		} catch (Exception ex) {}

		
		if (outerlinks.has(maindomain)) {
			content = new JSONObject(outerlinks.get(maindomain).toString());
			
			int valu = Integer.parseInt(content.get("value").toString());
			valu++;
			
			content.put("value", valu);
			content.put("link", link);
			content.put("domain", maindomain);
			outerlinks.put(maindomain, content);
		} else {
			int valu = 1;
			content.put("value", valu);
			content.put("link", link);
			content.put("domain", maindomain);
			outerlinks.put(maindomain, content);
			outlinklooper.add(mm, maindomain);
			mm++;
		}				
	
	}
}


mostactiveterm = term._getMostActiveByBlogger(dt, dte, mostactiveblogger);;
String totalinfluence ="";

try{			
	totalpost = post._searchRangeTotalByBlogger("date", dt, dte, mostactiveblogger);
	Double influence =  Double.parseDouble(post._searchRangeMaxByBloggers("date",dt, dte,mostactiveblogger));
	totalinfluence = influence+"";
}
catch(Exception e){
	totalinfluence = "0";
	totalpost = "0";
}

%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Blogtrackers - Blogger Portfolio</title>
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
  <link href="assets/vendors/animations/animate.min.css" rel="stylesheet" type="text/css" />

<link rel="stylesheet" href="assets/css/daterangepicker.css" />
  <link rel="stylesheet" href="assets/css/style.css" />

  <!--end of bootsrap -->
  <script src="assets/js/jquery-3.2.1.slim.min.js" ></script>
<script src="assets/js/popper.min.js"></script>
<script type="text/javascript" src="assets/vendors/animations/animations_css3.js"></script>
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
		  <span><%=user_name[0]%></span></a>
			
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
<div class="row">
<div class="col-md-6 paddi">

 <nav class="breadcrumb">
					<a class="breadcrumb-item text-primary"
						href="<%=request.getContextPath()%>/trackerlist.jsp">Trackers</a> 
						<a class="breadcrumb-item text-primary"	href="<%=request.getContextPath()%>/edittracker.jsp?tid=<%=tid%>"><%=trackername%></a>
					<a class="breadcrumb-item active text-primary" href="<%=request.getContextPath()%>/dashboard.jsp?tid=<%=tid%>">Dashboard</a>
					<a class="breadcrumb-item active text-primary" href="<%=request.getContextPath()%>/blogportfolio.jsp?tid=<%=tid%>">Blogger Portfolio</a>
				</nav>
<div><button class="btn btn-primary stylebutton1 " id="printdoc">SAVE AS PDF</button></div>
</div>

<div class="col-md-6 text-right mt10">
<div class="text-primary demo">
					<h6 id="reportrange">
						Date: <span><%=dispfrom%> - <%=dispto%></span>
					</h6>
				</div>
<div>
  <div class="btn-group mt5" data-toggle="buttons">
  <!-- <label class="btn btn-primary btn-sm daterangebutton legitRipple nobgnoborder"> <input type="radio" name="options" value="day" autocomplete="off" > Day
  	</label>
    <label class="btn btn-primary btn-sm nobgnoborder"> <input type="radio" name="options" value="week" autocomplete="off" >Week
  	</label>
     <label class="btn btn-primary btn-sm nobgnoborder nobgnoborder"> <input type="radio" name="options" value="month" autocomplete="off" > Month
  	</label>
    <label class="btn btn-primary btn-sm text-center nobgnoborder">Year <input type="radio" name="options" value="year" autocomplete="off" >
  	</label> -->
   <!--  <label class="btn btn-primary btn-sm nobgnoborder " id="custom">Custom</label> -->
  </div>

  <!-- Day Week Month Year <b id="custom" class="text-primary">Custom</b> -->

</div>
</div>
</div>

<div class="row p0 pt20 pb20 border-top-bottom mt20 mb20">
  <div class="col-md-2 animated fadeInLeft">
  <div class="card nocoloredcard mt10 mb10">
					<div class="card-body p0 pt5 pb5">
<!-- <small class="text-primary">Select Blogger</small> -->
<h5 class="text-primary mb0">
							<i class="icondash"></i>Select Blogger
						</h5>
<h6 class="mt5">
<select id="blogger-changed" class="custom-select">
 <%
 if (bloggerPostFrequency.size() > 0) {
		int p = 0;
		for (int m = 0; m < bloggerPostFrequency.size(); m++) {
			ArrayList<?> bloggerFreq = (ArrayList<?>) bloggerPostFrequency.get(m);
			String bloggerName = bloggerFreq.get(0).toString();
			String bloggerPostFreq = bloggerFreq.get(1).toString();
			String blogsiteId = bloggerFreq.get(2).toString();
				if(p==0){
					mostactiveblogger = bloggerName;
				}
				if (p < 10) {
					%>
					<option value="<%=blogsiteId%>_<%=bloggerName%>" <% if(mostactiveblogger.equals(bloggerName)){ %> selected <% } %>><%=bloggerName%></option>
 
				<%	p++;
					
				}
		}
 }
 %>
</select>

</h6>
<!-- <h2 class="textblue styleheading">AdNovum <div class="circle"></div></h2> -->
</div>
</div>
</div>
<div class="col-md-2">
				<div class="card nocoloredcard mt10 mb10">
					<div class="card-body p0 pt5 pb5">
						<h5 class="text-primary mb0">
							<i class="fas fa-exchange-alt icondash"></i>Influence
						</h5>
						<h3 class="text-blue mb0 countdash dash-label total-influence"><%=NumberFormat.getNumberInstance(Locale.US).format(Float.parseFloat(totalinfluence))%></h3>				
					</div>
				</div>
			</div>

			<div class="col-md-2">
				<div class="card nocoloredcard mt10 mb10">
					<div class="card-body p0 pt5 pb5">
						<h5 class="text-primary mb0">
							<i class="fas fa-search icondash"></i>Top Keyword
						</h5>
						<h3 class="text-blue mb0 countdash dash-label top-keyword"><%=mostactiveterm%></h3>
					</div>
				</div>
			</div>

			<div class="col-md-2">
				<div class="card nocoloredcard mt10 mb10">
					<div class="card-body p0 pt5 pb5">
						<h5 class="text-primary mb0">
							<i class="fas fa-file-alt icondash"></i>Posts
						</h5>	
						<h3 class="text-blue mb0 countdash dash-label total-post"><%= NumberFormat.getNumberInstance(Locale.US).format(Integer.parseInt(totalpost)) %></h3>
					
					</div>
				</div>
			</div>

			<div class="col-md-2">
				<div class="card nocoloredcard mt10 mb10">
					<div class="card-body p0 pt5 pb5">
						<h5 class="text-primary mb0">
							<i class="fas fa-adjust icondash"></i>Sentiment
						</h5>
						<h3 class="text-blue mb0 countdash dash-label total-sentiment"><%=NumberFormat.getNumberInstance(Locale.US).format(Integer.parseInt(possentiment)+Integer.parseInt(negsentiment))%></h3>
					</div>
				</div>
			</div>
<div class="col-md-2 text-right">
<div class="card nocoloredcard mt10 mb10">
					<div class="card-body p0 pt5 pb5">
<!-- <small class="text-primary">Blogsite of <b class="text-blue"><u>Advonum</u></b></small><br/> -->
<h5 class="text-primary mb0 active-blog"><%=mostactiveblogger%></h5>
<h3><a href="http://<%=mostactiveblogurl%>" target="_blank"><button class="btn buttonportfolio"><b class="float-left">Visit Site</b> <b class="far fa-file-alt float-right iconportfolio"></b></button></a></h3>
</div>
</div>
</div>
  <!-- <div class="col-md-3">
  <small class="text-primary">Find Blogger</small>
  <input class="form-control inputboxstyle opacity53 inputportfolio" placeholder="| Search" /><i class="fas fa-search searchiconinput"></i>
  </div>-->
</div> 

<div class="row mt40">
<!-- <div class="col-md-3">
  <div class="card card-style mt20 opacity53 cursor-pointer">
    <div class="card-body  p30 pt10 pb10">
      <h6 class="card-title mb0">Maximum Influence</h6>
      <h2 class="mb0">649</h2>

        </div>
  </div>
  <a href="">
  <div class="card card-style mt20 opacity53 cursor-pointer">
    <div class="card-body  p30 pt10 pb10">
      <h6 class="card-title mb0">Top Keyword</h6>
      <h2 class="mb0">Krymu</h2>

        </div>
  </div>
</a>
  <div class="card card-style mt20 activebar cursor-pointer" style="">
    <div class="card-body  p30 pt10 pb10">
      <h6 class="card-title mb0">Posts</h6>
      <h2 class="mb0">70</h2>

        </div>
  </div>

  <div class="card card-style mt20 opacity53 cursor-pointer">
    <div class="card-body  p30 pt10 pb10">
      <h6 class="card-title mb0">Overall Sentiment</h6>
      <h2 class="mb0">Positive</h2>

        </div>
  </div>

</div> -->
<div class="col-md-12">
  <div class="card card-style mt20">
    <div class="card-body  p30 pt5 pb5">
      <div style="min-height: 365px;">
<div><p class="text-primary mt10 float-left"><b class="text-green">Posts</b> Published by <b class="textblue"><u class="active-blog"><%=mostactiveblogger%></u></b> <!-- of Past <select class="text-primary filtersort sortbytimerange"><option value="week">Week</option><option value="month">Month</option><option value="year">Year</option></select> --></p></div>
<!-- <svg class="linesvg" width="960" height="400"></svg> -->
<!-- <div id="lineplot" style="min-height: 380px;"></div> -->
<div id="overall-chart">
<div class="chart-container">
  <div class="chart" id="d3-line-basic"></div>
</div>
</div>

      </div>
        </div>
  </div>
</div>


</div>

 
<form action="" name="customform" id="customform" method="post">
<input type="hidden" id="term" value="<%=mostactiveterm%>" />
<input type="hidden" id="date_start" value="<%=dt%>" />
<input type="hidden" id="date_end" value="<%=dte%>" />

</form>

<div class="row mb0">
  <div class="col-md-6 mt20 ">
    <div class="card card-style mt20">
      <div class="card-body  p5 pt10 pb10">

        <div style="min-height: 420px;">
          <div><p class="text-primary p15 pb5 pt0"><b class="text-blue"><u class="active-blog"><%=mostactiveblogger %></u></b> Day of the Week Posting Pattern <!-- of Past <select class="text-primary filtersort sortbytimerange"><option value="week">Week</option><option value="month">Month</option><option value="year">Year</option></select> --></p></div>
          
          <div id="day-chart">
	          <div class="chart" id="d3-bar-horizontal"></div>
          </div>
        </div>
          </div>
    </div>
  </div>

  <div class="col-md-6 mt20">
    <div class="card card-style mt20">
      <div class="card-body  p5 pt10 pb10">
        <div class="min-height-table" style="min-height: 420px;">
          <div><p class="text-primary p15 pb5 pt0"><b class="text-blue"><u class="active-blog"><%=mostactiveblogger %></u></b> Yearly Posting Pattern <!-- of Past <select class="text-primary filtersort sortbytimerange"><option value="week">Week</option><option value="month">Month</option><option value="year">Year</option></select> --></p></div>
         <div class="chart-container" id="year-chart" >
          <div class="chart" id="yearlypattern">

          </div>
          </div>
        </div>
          </div>
    </div>
  </div>
</div>

<div class="row mb50">
  <div class="col-md-12 mt20 ">
    <div class="card card-style mt20">
      <div class="card-body  p5 pt10 pb10">
        <p class="p15 pb5 pt0 text-primary">List of <select id="top-listtype"  
										class="text-primary filtersort sortbydomainsrls"><option
											value="domains">Domains</option>
										<option value="urls">URLs</option></select> of <b class="textblue active-blog"><%=mostactiveblogger %></b></p>
        <div style="min-height: 420px;">
         <!--  <div class="p15 pb5 pt0" role="group">
          Export
          </div> -->
               <div id="url-table">
                <table id="DataTables_Table_0_wrapper" class="display" style="width:100%">
                        <thead>
                            <tr>
                                <th>Domain</th>
                                <th>Frequency</th>


                            </tr>
                        </thead>
                        <tbody>
                            <%
										if (outlinklooper.size() > 0) {
													//System.out.println(bloggers);
													for (int y = 0; y < outlinklooper.size(); y++) {
														String key = outlinklooper.get(y).toString();
														JSONObject resu = outerlinks.getJSONObject(key);
									%>
									<tr>
										<td class=""><a href="http://<%=resu.get("domain")%>" target="_blank"><%=resu.get("domain")%></a></td>
										<td><%=resu.get("value")%></td>
									</tr>
									<%
										}
									}
									%>                     
                        </tbody>
                    </table>
                   </div>
               
        </div>
          </div>
    </div>
  </div>
  
</div>
</div>


<!-- <footer class="footer">
  <div class="container-fluid bg-primary mt60">
<p class="text-center text-medium pt10 pb10 mb0">Copyright &copy; 2017 All Rights Reserved.</p>
</div>
  </footer> -->
<form action="" name="customformsingle" id="customformsingle" method="post">
		<input type="hidden" name="tid" id="alltid" value="<%=tid%>" />
		
		<input type="hidden" id="blogger" value="<%=selectedblogid%>" /> 
		<input type="hidden" name="single_date" id="single_date" value="" />
		
		<input type="hidden" name="date_start" id="date_start" value="<%=dt%>" /> 
		<input type="hidden" name="date_end" id="date_end" value="<%=dte%>" />	
</form>
	


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
	 
	 $('#printdoc').on('click',function(){
			print();
		}) ;
   // datatable setup
     $('#DataTables_Table_1_wrapper').DataTable( {
         "scrollY": 430,
         "scrollX": false,
          "pagingType": "simple"
    /*       ,
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
       } */
     } );

// table set up 2
     $('#DataTables_Table_0_wrapper').DataTable( {
         "scrollY": 430,
         "scrollX": false,
          "pagingType": "simple"
     /*      ,
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
       } */
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
          // $('#reportrange span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
           $('#reportrange input').val(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY')).trigger('change');
         };

         var optionSet1 =
       	      {   startDate: moment().subtract(29, 'days'),
       	          endDate: moment(),
       	          minDate: '01/01/1947',
       	          maxDate: moment(),
       	          linkedCalendars: false,
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
       //$('#reportrange span').html(moment().subtract( 500, 'days').format('MMMM D, YYYY') + ' - ' + moment().format('MMMM D, YYYY'))
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
   					 console
   							.log("apply event fired, start/end dates are "
   									+ picker.startDate
   											.format('MMMM D, YYYY')
   									+ " to "
   									+ picker.endDate
   											.format('MMMM D, YYYY'));
   					var start = picker.startDate.format('YYYY-MM-DD');
   	            	var end = picker.endDate.format('YYYY-MM-DD');
   	            console.log("End:"+end);

   	            	
   	            	$("#date_start").val(start);
   	            	$("#date_end").val(end);
   	            	//toastr.success('Date changed!','Success');

   	            	$("form#customform").submit();
   					 
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
 <script type="text/javascript" src="assets/vendors/d3/d3_tooltip.js"></script>
 <script>

 $(function () {

     // Initialize chart
     lineBasic('#d3-line-basic', 400);

     // Chart setup
     function lineBasic(element, height) {


         // Basic setup
         // ------------------------------

         // Define main variables
         var d3Container = d3.select(element),
             margin = {top: 10, right: 10, bottom: 20, left: 80},
             width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right,
             height = height - margin.top - margin.bottom;


         var formatPercent = d3.format("");
         // Format data
         // var parseDate = d3.time.format("%d-%b-%y").parse,
         //     bisectDate = d3.bisector(function(d) { return d.date; }).left,
         //     formatValue = d3.format(",.0f"),
         //     formatCurrency = function(d) { return formatValue(d); }



         // Construct scales
         // ------------------------------

         // Horizontal
         var x = d3.scale.ordinal()
             .rangeRoundBands([0, width]);

         // Vertical
         var y = d3.scale.linear()
             .range([height, 0]);



         // Create axes
         // ------------------------------

         // Horizontal
         var xAxis = d3.svg.axis()
             .scale(x)
             .orient("bottom")
            .ticks(9)

           // .tickFormat(formatPercent);


         // Vertical
         var yAxis = d3.svg.axis()
             .scale(y)
             .orient("left")
             .ticks(6);



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



         // Construct chart layout
         // ------------------------------

         // Line


         // Load data
         // ------------------------------

 // data = [[{"date": "Jan","close": 120},{"date": "Feb","close": 140},{"date": "Mar","close":160},{"date": "Apr","close": 180},{"date": "May","close": 200},{"date": "Jun","close": 220},{"date": "Jul","close": 240},{"date": "Aug","close": 260},{"date": "Sep","close": 280},{"date": "Oct","close": 300},{"date": "Nov","close": 320},{"date": "Dec","close": 340}],
 // [{"date":"Jan","close":10},{"date":"Feb","close":20},{"date":"Mar","close":30},{"date": "Apr","close": 40},{"date": "May","close": 50},{"date": "Jun","close": 60},{"date": "Jul","close": 70},{"date": "Aug","close": 80},{"date": "Sep","close": 90},{"date": "Oct","close": 100},{"date": "Nov","close": 120},{"date": "Dec","close": 140}],
 // ];

 // data = [
 //   [{"date":"2016","close":1300},{"date":"2017","close":1700},{"date":"2018","close":2100}],
 //   [{"date":"2016","close":1500},{"date":"2017","close":1800}],
 //   [{"date":"2014","close":500},{"date":"2015","close":900},{"date":"2016","close":1200}]
 // ];

 data = [[<% for(int q=0; q<sortedyearsarray.length(); q++){ 
	  		String yer=sortedyearsarray.get(q).toString(); 
	  		int vlue = Integer.parseInt(graphyears.get(yer).toString()); %>
	  			{"date":"<%=yer%>","close":<%=vlue%>},
	<% } %>]];

 //console.log(data);
 // data = [];

 // data = [
 // [
 //   {
 //     "date": "Jan",
 //     "close": 1000
 //   },
 //   {
 //     "date": "Feb",
 //     "close": 1800
 //   },
 //   {
 //     "date": "Mar",
 //     "close": 1600
 //   },
 //   {
 //     "date": "Apr",
 //     "close": 1400
 //   },
 //   {
 //     "date": "May",
 //     "close": 2500
 //   },
 //   {
 //     "date": "Jun",
 //     "close": 500
 //   },
 //   {
 //     "date": "Jul",
 //     "close": 100
 //   },
 //   {
 //     "date": "Aug",
 //     "close": 500
 //   },
 //   {
 //     "date": "Sep",
 //     "close": 2300
 //   },
 //   {
 //     "date": "Oct",
 //     "close": 1500
 //   },
 //   {
 //     "date": "Nov",
 //     "close": 1900
 //   },
 //   {
 //     "date": "Dec",
 //     "close": 4170
 //   }
 // ]
 // ];

 // console.log(data);
 var line = d3.svg.line()
 .interpolate("monotone")
      //.attr("width", x.rangeBand())
     .x(function(d) { return x(d.date); })
     .y(function(d) { return y(d.close); });
     // .x(function(d){d.forEach(function(e){return x(d.date);})})
     // .y(function(d){d.forEach(function(e){return y(d.close);})});



 // Create tooltip
 var tip = d3.tip()
        .attr('class', 'd3-tip')
        .offset([-10, 0])
        .html(function(d) {
        if(d === null)
        {
          return "No Information Available";
        }
        else if(d !== null) {
         return d.date+" ("+d.close+")<br/> Click for more information";
          }
        // return "here";
        });

    // Initialize tooltip
    //svg.call(tip);




           // Vertical
 // extract max value from list of json object
 // console.log(data.length)
     var maxvalue =
     data.map(function(d){
       var mvalue = [];
       if(data.length > 1)
     {
       d.forEach(function(f,i){
       mvalue[i] = f.close;

       })
     return d3.max(mvalue);
     }

     //console.log(mvalue);
     });



 ////console.log(data)
 if(data.length == 1)
 {
   var returnedvalue = data[0].map(function(e){
   return e.date
   });

 // for single json data
 x.domain(returnedvalue);
 // rewrite x domain

 var maxvalue2 =
 data.map(function(d){
 return d3.max(d,function(t){return t.close});
 });
 y.domain([0,maxvalue2]);
 }
 else if(data.length > 1)
 {
 //console.log(data.length);
 //console.log(data);

 var returnedata = data.map(function(e){
 // console.log(k)
 var all = []
 e.forEach(function(f,i){
 all[i] = f.date;
 //console.log(all[i])
 })
 return all
 //console.log(all);
 });
 // console.log(returnedata);
 // combines all the array
 var newArr = returnedata.reduce((result,current) => {
 return result.concat(current);
 });

 //console.log(newArr);
 var set = new Set(newArr);
 var filteredArray = Array.from(set);
 //console.log(filteredArray.sort());
 // console.log(returnedata);
 x.domain(filteredArray);
 y.domain([0, d3.max(maxvalue)]);
 }




             //
             // Append chart elements
             //




 // svg.call(tip);
              // data.map(function(d){})
              if(data.length == 1)
              {
                // Add line
              var path = svg.selectAll('.d3-line')
                        .data(data)
                        .enter()
                        .append("g")
                        .attr("class","linecontainer")
                        .append("path")
                        .attr("class", "d3-line d3-line-medium")
                        .attr("d", line)
                        // .style("fill", "rgba(0,0,0,0.54)")
                        .style("stroke-width", 2)
                        .style("stroke", "0080CC")

               // add point
                circles = svg.append("g").attr("class","circlecontainer").selectAll(".circle-point")
                          .data(data[0])
                          .enter();


                      circles
                      .append("circle")
                      .attr("class","circle-point")
                      .attr("r",3.4)
                      .style("stroke", "#0080CC")
                      .style("fill","#0080CC")
                      .attr("cx",function(d) { return x(d.date); })
                      .attr("cy", function(d){return y(d.close)})

                     /*  .attr("transform", "translate("+margin.left/4.7+",0)"); */



                      svg.selectAll(".circle-point").data(data[0])
                      .on("mouseover",tip.show)
                      .on("mouseout",tip.hide)
                      .on("click",function(d){
                    	  console.log(d.date);
                    	  var d1 = 	  d.date + "-01-01";
                   	      var d2 = 	  d.date + "-12-31";
          				
                   	      loadUrls(d1,d2);
                    	  
                      });
                                         svg.call(tip)
              }
              // handles multiple json parameter
              else if(data.length > 1)
              {
                // add multiple line

                var path = svg.selectAll('.d3-line')
                          .data(data)
                          .enter()
                          .append("path")
                          .attr("class", "d3-line d3-line-medium")
                          .attr("d", line)
                          // .style("fill", "rgba(0,0,0,0.54)")
                          .style("stroke-width", 2)
                          .style("stroke", "17394C")
                          /* .attr("transform", "translate("+margin.left/4.7+",0)"); */




               // add multiple circle points

                   // data.forEach(function(e){
                   // console.log(e)
                   // })

                   console.log(data);

                      var mergedarray = [].concat(...data);
                       console.log(mergedarray)
                         circles = svg.selectAll(".circle-point")
                             .data(mergedarray)
                             .enter();

                               circles
                               // .enter()
                               .append("circle")
                               .attr("class","circle-point")
                               .attr("r",3.4)
                               .style("stroke", "#4CAF50")
                               .style("fill","#4CAF50")
                               .attr("cx",function(d) { return x(d.date)})
                               .attr("cy", function(d){return y(d.close)})

                               /* .attr("transform", "translate("+margin.left/4.7+",0)"); */
                               svg.selectAll(".circle-point").data(mergedarray)
                              .on("mouseover",tip.show)
                              .on("mouseout",tip.hide)
                              .on("click",function(d){console.log(d.date)});
                         //                         svg.call(tip)

                       //console.log(newi);


                             svg.selectAll(".circle-point").data(mergedarray)
                             .on("mouseover",tip.show)
                             .on("mouseout",tip.hide)
                             .on("click",function(d){
                            	 console.log(d.date);
                            	 var d1 = 	  d.date + "-01-01";
                          	      var d2 = 	  d.date + "-12-31";
                 				
                          	      loadUrls(d1,d2);
                           	  	 
                             });
                                                svg.call(tip)










              }


 // show data tip


             // Append axes
             // ------------------------------

             // Horizontal
             svg.append("g")
                 .attr("class", "d3-axis d3-axis-horizontal d3-axis-strong")
                 .attr("transform", "translate(0," + height + ")")
                 .call(xAxis);

             // Vertical
             var verticalAxis = svg.append("g")
                 .attr("class", "d3-axis d3-axis-vertical d3-axis-strong")
                 .call(yAxis);





             // Add text label
             verticalAxis.append("text")
                 .attr("transform", "rotate(-90)")
                 .attr("y", 10)
                 .attr("dy", ".71em")
                 .style("text-anchor", "end")
                 .style("fill", "#999")
                 .style("font-size", 12)
                 // .text("Frequency")
                 ;

             if(data.length == 1 )
        	 {
        	 var tick = svg.select(".d3-axis-horizontal").select(".tick");
            transformfirsttick =  tick[0][0].attributes[1].value;
            //transformfirsttick = "translate(31.5,0)"
            //console.log(transformfirsttick);
            svg.select(".circlecontainer").attr("transform", transformfirsttick);
            svg.select(".linecontainer").attr("transform", transformfirsttick);
        	 }




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
           x.rangeRoundBands([0, width],.72,.5);
           //
           // // Horizontal axis
           svg.selectAll('.d3-axis-horizontal').call(xAxis);
           //
           //
           // // Chart elements
           // // -------------------------
           //
           // // Line path
           svg.selectAll('.d3-line').attr("d", line);


           if(data.length == 1)
           {
             svg.selectAll(".circle-point").attr("circle",circles)
             .attr("cx",function(d) { return x(d.date);})
             .attr("cy", function(d){return y(d.close)});
           }
           else if(data.length > 1)
           {
             svg.selectAll(".circle-point").attr("circle",circles)
             .attr("cx",function(d) { return x(d.date);})
             .attr("cy", function(d){return y(d.close)});
           }
           if(data.length == 1 )
      	 {
      	 var tick = svg.select(".d3-axis-horizontal").select(".tick");
          transformfirsttick =  tick[0][0].attributes[1].value;
          //transformfirsttick = "translate(31.5,0)"
          console.log(transformfirsttick);
          svg.select(".circlecontainer").attr("transform", transformfirsttick);
          svg.select(".linecontainer").attr("transform", transformfirsttick);
      	 }
             // Crosshair
             //svg.selectAll('.d3-crosshair-overlay').attr("width", width);
         }
     }
 });
 </script>





 <script>
 $(function () {

     // Initialize chart
     barHorizontal('#d3-bar-horizontal', 390);

     // Chart setup
     function barHorizontal(element, height) {

       // Basic setup
       // ------------------------------

       // Define main variables
       var d3Container = d3.select(element),
           margin = {top: 5, right: 50, bottom: 20, left: 70},
           width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right,
           height = height - margin.top - margin.bottom - 5;

          var formatPercent = d3.format("");

       // Construct scales
       // ------------------------------

       // Horizontal
       var y = d3.scale.ordinal()
           .rangeRoundBands([height,0], .02, .7);

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
    	   {letter:"Sat", frequency:<%=sat%>},
    	   {letter:"Fri", frequency:<%=fri%>},
             {letter:"Wed", frequency:<%=wed%>},
             {letter:"Thu", frequency:<%=thur%>},
             {letter:"Tue", frequency:<%=tue%>},
             {letter:"Mon", frequency:<%=mon%>},
             {letter:"Sun", frequency:<%=sun%>}
                     
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
                   //.attr("height", y.rangeBand())
                   .attr("height",30)
                   .attr("x", function(d) { return 0; })
                   .attr("width", function(d) { return x(d.frequency); })
                   .attr('transform', 'translate(0, '+(y.rangeBand()/2-14.5)+')')
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

<!-- Yearly patterns  -->
 <script>
 $(function () {

     // Initialize chart
     yearlypattern('#yearlypattern', 385);

     // Chart setup
     function yearlypattern(element, height) {


         // Basic setup
         // ------------------------------

         // Define main variables
         var d3Container = d3.select(element),
             margin = {top: 10, right: 10, bottom: 20, left: 50},
             width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right,
             height = height - margin.top - margin.bottom;


         var formatPercent = d3.format("");
         // Format data
         // var parseDate = d3.time.format("%d-%b-%y").parse,
         //     bisectDate = d3.bisector(function(d) { return d.date; }).left,
         //     formatValue = d3.format(",.0f"),
         //     formatCurrency = function(d) { return formatValue(d); }



         // Construct scales
         // ------------------------------

         // Horizontal
         var x = d3.scale.ordinal()
             .rangeRoundBands([0, width]);

         // Vertical
         var y = d3.scale.linear()
             .range([height, 0]);



         // Create axes
         // ------------------------------

         // Horizontal
         var xAxis = d3.svg.axis()
             .scale(x)
             .orient("bottom")
            .ticks(9)

           // .tickFormat(formatPercent);


         // Vertical
         var yAxis = d3.svg.axis()
             .scale(y)
             .orient("left")
             .ticks(6);



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



         // Construct chart layout
         // ------------------------------

         // Line


         // Load data
         // ------------------------------

 // data = [[{"date": "Jan","close": 120},{"date": "Feb","close": 140},{"date": "Mar","close":160},{"date": "Apr","close": 180},{"date": "May","close": 200},{"date": "Jun","close": 220},{"date": "Jul","close": 240},{"date": "Aug","close": 260},{"date": "Sep","close": 280},{"date": "Oct","close": 300},{"date": "Nov","close": 320},{"date": "Dec","close": 340}],
 // [{"date":"Jan","close":10},{"date":"Feb","close":20},{"date":"Mar","close":30},{"date": "Apr","close": 40},{"date": "May","close": 50},{"date": "Jun","close": 60},{"date": "Jul","close": 70},{"date": "Aug","close": 80},{"date": "Sep","close": 90},{"date": "Oct","close": 100},{"date": "Nov","close": 120},{"date": "Dec","close": 140}],
 // ];

 // data = [
 //   [{"date":"2016","close":1300},{"date":"2017","close":1700},{"date":"2018","close":2100}],
 //   [{"date":"2016","close":1500},{"date":"2017","close":1800}],
 //   [{"date":"2014","close":500},{"date":"2015","close":900},{"date":"2016","close":1200}]
 // ];

 // data = [[
 //
 //  {
 //    "date": "2015",
 //    "close": 500
 //  },
 //  {
 //    "date": "2016",
 //    "close": 100
 //  },
 //  {
 //    "date": "2017",
 //    "close": 300
 //  },
 //  {
 //    "date": "2018",
 //    "close": 500
 //  }
 // ]];

 //console.log(data);
 // data = [];

 data = [
 [{"date": "Jan","close": <%=jan%>},{"date": "Feb","close": <%=feb%>},{"date": "Mar","close":<%=march%>},{"date": "Apr","close": <%=jan%>},{"date": "May","close": <%=may%>},{"date": "Jun","close": <%=june%>},{"date": "Jul","close": <%=july%>},{"date": "Aug","close": <%=aug%>},{"date": "Sep","close": <%=sep%>},{"date": "Oct","close": <%=oct%>},{"date": "Nov","close": <%=nov%>},{"date": "Dec","close": <%=dec%>}],
 ];

 // console.log(data);
 var line = d3.svg.line()
 .interpolate("monotone")
      //.attr("width", x.rangeBand())
     .x(function(d) { return x(d.date); })
     .y(function(d) { return y(d.close); });
     // .x(function(d){d.forEach(function(e){return x(d.date);})})
     // .y(function(d){d.forEach(function(e){return y(d.close);})});



 // Create tooltip
 var tip = d3.tip()
        .attr('class', 'd3-tip')
        .offset([-10, 0])
        .html(function(d) {
        if(d === null)
        {
          return "No Information Available";
        }
        else if(d !== null) {
         return d.date+" ("+d.close+")<br/> Click for more information";
          }
        // return "here";
        });

    // Initialize tooltip
    //svg.call(tip);




           // Vertical
 // extract max value from list of json object
 // console.log(data.length)
     var maxvalue =
     data.map(function(d){
       var mvalue = [];
       if(data.length > 1)
     {
       d.forEach(function(f,i){
       mvalue[i] = f.close;

       })
     return d3.max(mvalue);
     }

     //console.log(mvalue);
     });



 ////console.log(data)
 if(data.length == 1)
 {
   var returnedvalue = data[0].map(function(e){
   return e.date
   });

 // for single json data
 x.domain(returnedvalue);
 // rewrite x domain

 var maxvalue2 =
 data.map(function(d){
 return d3.max(d,function(t){return t.close});
 });
 y.domain([0,maxvalue2]);
 }
 else if(data.length > 1)
 {
 //console.log(data.length);
 //console.log(data);

 var returnedata = data.map(function(e){
 // console.log(k)
 var all = []
 e.forEach(function(f,i){
 all[i] = f.date;
 //console.log(all[i])
 })
 return all
 //console.log(all);
 });
 // console.log(returnedata);
 // combines all the array
 var newArr = returnedata.reduce((result,current) => {
 return result.concat(current);
 });

 //console.log(newArr);
 var set = new Set(newArr);
 var filteredArray = Array.from(set);
 //console.log(filteredArray.sort());
 // console.log(returnedata);
 x.domain(filteredArray);
 y.domain([0, d3.max(maxvalue)]);
 }




             //
             // Append chart elements
             //




 // svg.call(tip);
              // data.map(function(d){})
              if(data.length == 1)
              {
                // Add line
              var path = svg.selectAll('.d3-line')
                        .data(data)
                        .enter()
                        .append("g")
                        .attr("class","linecontainer")
                        .append("path")
                        .attr("class", "d3-line d3-line-medium")
                        .attr("d", line)
                        // .style("fill", "rgba(0,0,0,0.54)")
                        .style("stroke-width", 2)
                        .style("stroke", "0080CC")
                         //.attr("transform", "translate("+margin.left/4.7+",0)");
                        // .datum(data)

               // add point
                circles = svg.append("g").attr("class","circlecontainer").selectAll(".circle-point")
                          .data(data[0])
                          .enter();


                      circles
                      // .enter()
                      .append("circle")
                      .attr("class","circle-point")
                      .attr("r",3.4)
                      .style("stroke", "#0080CC")
                      .style("fill","#0080CC")
                      .attr("cx",function(d) { return x(d.date); })
                      .attr("cy", function(d){return y(d.close)})

                      //.attr("transform", "translate("+margin.left/4.7+",0)");



                      svg.selectAll(".circle-point").data(data[0])
                      .on("mouseover",tip.show)
                      .on("mouseout",tip.hide)
                      .on("click",function(d){
                    	  console.log(d.date);

                   	  	  var d1 = 	  d.date + "-01-01";
                  	      var d2 = 	  d.date + "-12-31";              					
                  	      loadUrls(d1,d2);  
                      });
                                         svg.call(tip)
                                         
                       
              }
              // handles multiple json parameter
              else if(data.length > 1)
              {
                // add multiple line

                var path = svg.selectAll('.d3-line')
                          .data(data)
                          .enter()
                          .append("path")
                          .attr("class", "d3-line d3-line-medium")
                          .attr("d", line)
                          // .style("fill", "rgba(0,0,0,0.54)")
                          .style("stroke-width", 2)
                          .style("stroke", "17394C")
                          .attr("transform", "translate("+margin.left/4.7+",0)");




               // add multiple circle points

                   // data.forEach(function(e){
                   // console.log(e)
                   // })

                   console.log(data);

                      var mergedarray = [].concat(...data);
                       console.log(mergedarray)
                         circles = svg.selectAll(".circle-point")
                             .data(mergedarray)
                             .enter();

                               circles
                               // .enter()
                               .append("circle")
                               .attr("class","circle-point")
                               .attr("r",3.4)
                               .style("stroke", "#4CAF50")
                               .style("fill","#4CAF50")
                               .attr("cx",function(d) { return x(d.date)})
                               .attr("cy", function(d){return y(d.close)})

                               .attr("transform", "translate("+margin.left/4.7+",0)");
                                svg.selectAll(".circle-point").data(mergedarray)
                              .on("mouseover",tip.show)
                              .on("mouseout",tip.hide)
                              .on("click",function(d){
                            	  console.log(d.date);

                           	  	  var d1 = 	  d.date + "-01-01";
                          	      var d2 = 	  d.date + "-12-31";              					
                          	      loadUrls(d1,d2); 
                              });
                         //                         svg.call(tip)

                       //console.log(newi);


                             svg.selectAll(".circle-point").data(mergedarray)
                             .on("mouseover",tip.show)
                             .on("mouseout",tip.hide)
                             .on("click",function(d){console.log(d.date)});
                                                svg.call(tip)










              }


 // show data tip


             // Append axes
             // ------------------------------

             // Horizontal
             svg.append("g")
                 .attr("class", "d3-axis d3-axis-horizontal d3-axis-strong")
                 .attr("transform", "translate(0," + height + ")")
                 .call(xAxis);

             // Vertical
             var verticalAxis = svg.append("g")
                 .attr("class", "d3-axis d3-axis-vertical d3-axis-strong")
                 .call(yAxis);





             // Add text label
             verticalAxis.append("text")
                 .attr("transform", "rotate(-90)")
                 .attr("y", 10)
                 .attr("dy", ".71em")
                 .style("text-anchor", "end")
                 .style("fill", "#999")
                 .style("font-size", 12)
                 // .text("Frequency")
                 ;


             if(data.length == 1 )
        	 {
        	 var tick = svg.select(".d3-axis-horizontal").select(".tick");
            transformfirsttick =  tick[0][0].attributes[1].value;
            //transformfirsttick = "translate(31.5,0)"
            //console.log(transformfirsttick);
            svg.select(".circlecontainer").attr("transform", transformfirsttick);
            svg.select(".linecontainer").attr("transform", transformfirsttick);
        	 }



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
           x.rangeRoundBands([0, width],.72,.5);
           //
           // // Horizontal axis
           svg.selectAll('.d3-axis-horizontal').call(xAxis);
           //
           //
           // // Chart elements
           // // -------------------------
           //
           // // Line path
           svg.selectAll('.d3-line').attr("d", line);


           if(data.length == 1)
           {
             svg.selectAll(".circle-point").attr("circle",circles)
             .attr("cx",function(d) { return x(d.date);})
             .attr("cy", function(d){return y(d.close)});
           }
           else if(data.length > 1)
           {
             svg.selectAll(".circle-point").attr("circle",circles)
             .attr("cx",function(d) { return x(d.date);})
             .attr("cy", function(d){return y(d.close)});
           }
           
           if(data.length == 1 )
      	 {
      	 var tick = svg.select(".d3-axis-horizontal").select(".tick");
          transformfirsttick =  tick[0][0].attributes[1].value;
          //transformfirsttick = "translate(31.5,0)"
          console.log(transformfirsttick);
          svg.select(".circlecontainer").attr("transform", transformfirsttick);
          svg.select(".linecontainer").attr("transform", transformfirsttick);
      	 }
             // Crosshair
             //svg.selectAll('.d3-crosshair-overlay').attr("width", width);
         }
     }
 });


 </script>

<script src="pagedependencies/baseurl.js?v=93"></script>
<script src="pagedependencies/bloggerportfolio.js"></script>
<script>
$(document).ready(function() {
	
	$('#top-listtype').on("change",function(e){
		var date_start = $("#date_start").val();
		var date_end = $("#date_end").val();
		loadUrls(date_start,date_end);
	});
	

});
</script>
</body>
</html>
<% }} %>