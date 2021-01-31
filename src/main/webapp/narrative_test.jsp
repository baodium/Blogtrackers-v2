<%@page import="authentication.*"%>
<%@page import="java.util.*"%>
<%@page import="util.*"%>
<%@page import="java.io.File"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.net.URI"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.net.URI"%>

<%
	Object email = (null == session.getAttribute("email")) ? "" : session.getAttribute("email");
	Object tid = (null == request.getParameter("tid")) ? "" : request.getParameter("tid");
	Object user = (null == session.getAttribute("username")) ? "" : session.getAttribute("username");
	Object date_start = (null == request.getParameter("date_start")) ? "" : request.getParameter("date_start");
	Object date_end = (null == request.getParameter("date_end")) ? "" : request.getParameter("date_end");
	Object single = (null == request.getParameter("single_date")) ? "" : request.getParameter("single_date");
	String sort = (null == request.getParameter("sortby"))
			? "blog"
			: request.getParameter("sortby").toString().replaceAll("[^a-zA-Z]", " ");

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
		ArrayList influentialp = new ArrayList();

		Trackers tracker = new Trackers();
		Terms term = new Terms();
		Outlinks outl = new Outlinks();
		if (tid != "") {
			detail = tracker._fetch(tid.toString());
			//System.out.println(detail);
		} else {
			detail = tracker._list("DESC", "", user.toString(), "1");
			//System.out.println("List:"+detail);
		}

		boolean isowner = false;
		JSONObject obj = null;
		String ids = "";
		String trackername = "";
		if (detail.size() > 0) {
			//String res = detail.get(0).toString();
			ArrayList resp = (ArrayList<?>) detail.get(0);

			String tracker_userid = resp.get(0).toString();
			trackername = resp.get(2).toString();
			//if (tracker_userid.equals(user.toString())) {
			isowner = true;
			String query = resp.get(5).toString();//obj.get("query").toString();
			query = query.replaceAll("blogsite_id in ", "");
			query = query.replaceAll("\\(", "");
			query = query.replaceAll("\\)", "");
			ids = query;
			//}
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
			} catch (Exception e) {

			}

			String[] user_name = name.split(" ");
			Blogposts post = new Blogposts();
			Blogs blog = new Blogs();
			Sentiments senti = new Sentiments();

			//Date today = new Date();
			SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("MMM d, yyyy");
			SimpleDateFormat DATE_FORMAT2 = new SimpleDateFormat("yyyy-MM-dd");

			SimpleDateFormat DAY_ONLY = new SimpleDateFormat("dd");
			SimpleDateFormat MONTH_ONLY = new SimpleDateFormat("MM");
			SimpleDateFormat SMALL_MONTH_ONLY = new SimpleDateFormat("mm");
			SimpleDateFormat WEEK_ONLY = new SimpleDateFormat("dd");
			SimpleDateFormat YEAR_ONLY = new SimpleDateFormat("yyyy");

			/* String stdate = post._getDate(ids, "first");
			String endate = post._getDate(ids, "last"); */
			String stdate = "2020-01-01";
			String endate = "2020-08-01";

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
			//ArrayList sentiments = senti._list("DESC", "", "id");
			String totalpost = "0";
			ArrayList allauthors = new ArrayList();

			String possentiment = "0";
			String negsentiment = "0";
			String ddey = "31";
			String dt = dst;
			String dte = dend;
			String year_start = "";
			String year_end = "";


			if (!date_start.equals("") && !date_end.equals("")) {
				//totalpost = post._searchRangeTotal("date", date_start.toString(), date_end.toString(), ids);
				//possentiment = post._searchRangeTotal("sentiment", "0", "10", ids);
				//negsentiment = post._searchRangeTotal("sentiment", "-10", "-1", ids);

				Date start = new SimpleDateFormat("yyyy-MM-dd").parse(date_start.toString());
				Date end = new SimpleDateFormat("yyyy-MM-dd").parse(date_end.toString());

				dt = date_start.toString();
				dte = date_end.toString();

				historyfrom = DATE_FORMAT.format(start);
				historyto = DATE_FORMAT.format(end);

			}
			
			DbConnection db = new DbConnection();
			//Getting high-level entities for tracker
			List<Narrative.Entity_> slice = Narrative.get_narratives(ids, dt, dte, "10", "entity", "date");
			
			
			
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Blogtrackers - Narrative Analysis</title>
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

<link rel="stylesheet" href="assets/css/daterangepicker.css" />
<link rel="stylesheet" href="assets/css/style.css" />
<link href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700,900" rel="stylesheet">
<link rel="stylesheet" href="assets/presentation/index.css"/>
        
        <script src="assets/behavior/index.js"></script>
<!--end of bootsrap -->
<script src="https://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>
<script src="assets/js/popper.min.js"></script>
<script src="pagedependencies/googletagmanagerscript.js"></script>
<style>
	.selected {
	    background-color: #FFF;
	}
</style>
</head>
<body> 
<%@include file="subpages/loader.jsp" %>
	<noscript>
		<%@include file="subpages/googletagmanagernoscript.jsp"%>
	</noscript>
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
					<%-- <a class="cursor-pointer profilemenulink"
						href="<%=request.getContextPath()%>/notifications.jsp"><h6
							class="text-primary">
							Notifications <b id="notificationcount" class="cursor-pointer">12</b>
						</h6> </a> --%>  <a class="cursor-pointer profilemenulink" href="<%=request.getContextPath()%>/addblog.jsp"><h6 class="text-primary">Add Blog</h6></a>
						<a class="cursor-pointer profilemenulink"
						href="<%=request.getContextPath()%>/profile.jsp"><h6
							class="text-primary">Profile</h6></a> 
							
							<a
						class="cursor-pointer profilemenulink"
						href="https://addons.mozilla.org/en-US/firefox/addon/blogtrackers/"><h6
							class="text-primary">Plugin</h6></a>
							
							<a
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
			<!-- <div class="navbar-header ">
          <a class="navbar-brand text-center" href="#"><img src="images/blogtrackers.png" /></a>
          </div> -->
			<!-- Mobile menu  -->
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
							id="notificationcolor"> --></i> <img src="<%=profileimage%>"
							width="50" height="50"
							onerror="this.src='images/default-avatar.png'" alt="" class="" />
							<span><%=user_name[0]%></span></a>

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
	<div class="container analyticscontainer">
		<!-- start of print section  -->



		<div class="row bottom-border pb20">
			<div class="col-md-6 ">
				<nav class="breadcrumb">
					<a class="breadcrumb-item text-primary"
						href="<%=request.getContextPath()%>/trackerlist.jsp">Trackers</a> <a class="breadcrumb-item text-primary"
						href="<%=request.getContextPath()%>/edittracker.jsp?tid=<%=tid%>"><%=trackername%></a>
						<a class="breadcrumb-item active text-primary" href="<%=request.getContextPath()%>/dashboard.jsp?tid=<%=tid%>">Dashboard</a>
					<a class="breadcrumb-item active text-primary" href="<%=request.getContextPath()%>/narrative.jsp?tid=<%=tid%>">Narrative Analysis</a>
				</nav>
				<!-- <div>
					<button class="btn btn-primary stylebutton1 " id="printdoc">SAVE
						AS PDF</button>
				</div> -->
			</div>
			<div class="col-md-6 text-right mt10">
				<div class="text-primary demo">
					<h6 id="reportrange">
						Date: <span><%=dispfrom%> - <%=dispto%></span>
					</h6>
				</div>
				<div>
					<div class="btn-group mt5" data-toggle="buttons">
						<!-- <label
							class="btn btn-primary btn-sm daterangebutton legitRipple nobgnoborder">
							<input type="radio" name="options" value="day" autocomplete="off">
							Day
						</label> <label class="btn btn-primary btn-sm nobgnoborder"> <input
							type="radio" name="options" value="week" autocomplete="off">Week
						</label> <label class="btn btn-primary btn-sm nobgnoborder nobgnoborder">
							<input type="radio" name="options" value="month"
							autocomplete="off"> Month
						</label> <label class="btn btn-primary btn-sm text-center nobgnoborder">Year
							<input type="radio" name="options" value="year"
							autocomplete="off">
						</label> -->
						<!--  <label class="btn btn-primary btn-sm nobgnoborder " id="custom">Custom</label> -->
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

	
		
	<!-- Search -->
        <form id="search">
            <label for="searchBox">Search Website</label>
            <input id="searchBox" type="text" placeholder="Search..." autocomplete="off">
            <input type="hidden" value="<%=tid%>" name="tracker_id" id="tracker_id">
            <input type="hidden" name="all_blog_ids" id="all_blog_ids" value="<%=ids%>" />
        </form>

        <!-- Narrative Tree -->
        <ul class="current_narrative_tree" id="narrativeTree">
        
	        <%
	        for(int i = 0; i < slice.size(); i++){
				Narrative.Entity_ x = slice.get(i);
				String entity = x.getEntity();
				if(entity != null){
					
				
				String temp_entity = entity.split(":")[0].trim();
				
				entity = temp_entity.replace(".", "");
			%>
		
        
        	<!-- start displaying narrative entity -->
            <li class="level">
                <div  id="keywordWrapper" >
                    <div id="precisionWrapper">
                        <div id="collapseIcon"></div>
                        <div  id="keywordList  ">
                            <div entity="<%=entity %>" class="keyword entity_radio1 entity_unselected">
                                <p style="margin-bottom: 0;" class="text"><%=temp_entity%></p>
                                <button id="removeKeyword"></button>
                            </div>
                        </div>
                        <button id="ungroupButton"></button>
                    </div>
                </div>
                
                <ul id="narrative_list_<%=entity %>" class="narratives">
                
                	<%
                	List<Narrative.Data_> narratives = x.getData();
    	            for(int j = 0; j < narratives.size(); j++){
    	               	if(j == 5){
    	               		break;
    	               	}
    	               	String narrative = narratives.get(j).getNarrative();
    	               	Set<String> blogpost_ids = narratives.get(j).getBlogpostIds();
            			String total_narrative_count = String.valueOf(blogpost_ids.size());
            			
            		 String replace = "<span style=background:red;color:#fff>" + entity + "</span>";
            		 if(narrative.toString().toLowerCase().indexOf(entity.toLowerCase()) != -1){
            			 
            		 }
		        		
		                %>
                
                
                
                
                
                    <li class="narrative">
                        <div class="topSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                            </div>
                        </div>
                        <div class="middleSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                                <div class="dot"></div>
                            </div>
                            <div class="narrativeTextWrapper">
                                <div id="editWrapper">
                                    <p id="<%=entity %>" entity="<%=entity %>" class="narrativeText"><%=narrative.toString() %></p>
                                    <div id="editControls">
                                        <button id="editButton" class="editButtons" entity="<%=entity %>" title="Edit"></button>
                                        <button id="cancelButton" class="editButtons cancel_narrative" entity="<%=entity %>" title="Cancel"></button>
                                        <button id="confirmButton" class="editButtons confirm_narrative" entity="<%=entity %>" title="Confirm"></button>
                                    </div>
                                </div>
                                <p class="counter"><span class="number"><%=total_narrative_count.toString() %></span>Posts</p>
                            </div>
                        </div>
                        <div class="bottomSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                            </div>
                            <div id="narrative_posts_<%=entity %>" style="overflow-y:hidden;" class="posts">
                            
                            
                            	<!-- start narrative post display -->
                            	<%
                            //Getting posts related to narrative
                             
                             String [] blogposts_data = blogpost_ids.toString().split(",");
                             List<?> permalink_data = new ArrayList<>();
                             
                             int length = blogpost_ids.toString().length();
                             String post_ids = (blogpost_ids.toString().substring(length - 1).equals(",")) ? blogpost_ids.toString().substring(0,length -1) : blogpost_ids.toString();
                             try{
                            	 String query = "SELECT blogpost_id, permalink, title, date, post from blogposts where blogpost_id in ("+post_ids.replace("[","").replace("]","")+") and blogsite_id in ("+ids+") order by date desc;";
                                 permalink_data = db.queryJSON(query);
                             }catch(Exception e){
                            	 System.out.println("here");
                             }
                             
                             Object permalink = "";
                             Object date = "";
             				Object title = "";
             				Object post_detail = "";
             				String domain = "";
             				String bp_id = "";
             			       
                    		for(int b = 0; b < permalink_data.size(); b++){
                    				//Extract blogposts and entities
									if(b == 10){
										break;
									}
                    				try{
                    				
                    				if(permalink_data.size() > 0){
                    					JSONObject permalink_data_index = new JSONObject(permalink_data.get(b).toString());
                        				permalink = permalink_data_index.getJSONObject("_source").get("permalink");
                        				
                        				bp_id = permalink_data_index.getJSONObject("_source").get("blogpost_id").toString();
                        				
                        				date = permalink_data_index.getJSONObject("_source").get("date");
                        				LocalDate datee = LocalDate.parse(date.toString().split(" ")[0]);
										DateTimeFormatter dtf = DateTimeFormatter.ofPattern("MMM dd, yyyy");
										date = dtf.format(datee);
                        				
                        				title = permalink_data_index.getJSONObject("_source").get("title");
                        				post_detail = permalink_data_index.getJSONObject("_source").get("post");
                        				URI uri = new URI(permalink.toString());
                        				domain = uri.getHost();
                    				}
                    				
                    				}catch(Exception e){
                    					System.out.println(e);
                    				}
                            %> 
                                
                                    <div post_id=<%=bp_id %> class="post missingImage post_id_<%=bp_id%>">
                                        <div class="<%=bp_id%>">
                                        	<input type="hidden" class="post-image" id="<%=bp_id%>" name="pic" value="<%=permalink.toString()%>">
                                        </div>
                                        
                                        <h2 id="post_title_<%=bp_id %>" class="postTitle"><%=title.toString() %></h2>
                                        <p id="post_date_<%=bp_id %>" class="postDate"><%=date.toString()%></p>
                                        <p id="post_source_<%=bp_id %>" post_permalink="<%=permalink.toString()%>" class="postSource"><%=domain %></p>
                                        <input id="post_detail_<%=bp_id %>" type="hidden" value="<%=post_detail.toString() %>" >
                                    </div>
                                    
                                    <%
                                b++;
                    		} 
                    		
                    		%>   
                                	
                                <!-- end narrative post display -->
                                
                            </div>
                        </div>
                    </li>
                    
                    
                    <%} %>
                    
                    
                    <li id="secondli_<%=entity %>" class="narrative last more">
                        <div class="topSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                            </div>
                        </div>
                        <div class="middleSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                                <div class="dot"></div>
                            </div>
                            <div class="narrativeTextWrapper">
                                <p id="load_more_<%=entity %>" total_narrative_count="<%=entity %>" entity="<%=entity %>" level="1" class="narrativeText load_more_entity">More...</p>
                            </div>
                        </div>
                    </li>
                </ul>
            </li>
            <!-- end displaying narraitve entity -->
           	
           	
           	<%}}%>
           	
         
           
        </ul>
        
        <div id="current_narrative_loader" class="hidden">
			<img style='position: absolute; top: 50%; left: 50%;'
				src='images/loading.gif' />
		</div>
        
       	<div id="search_narrative_tree"></div>
        
        </div>
        

        <!-- Notifications -->
        <section id="notifications">
                <button id="editKeywords" title="Edit Tree"><div id="counter">0</div></button>
                <button id="cancelEditing" title="Exit Editing"></button>
            
        </section>

        <!-- More Info Modal -->
        <section id="moreInfoModal" class="">
            <div id="shadow"></div>
            <div id="messageBox">
                <button id="closeButton"></button>
                <div id="messageContent">
                    <img class="modal_pic postImageModal hidden" src="assets/images/posts/37.jpg">
                    <div class="detailsWrapper">
                        <p id="title"><span class="modal_title" id="text">Pentagon watchdog tapped to lead committee overseeing $2 trillion coronavirus package</span></p>
                        <ul id="details">
                            <li id="Source">
                                <div id="icon" class="detailsIcon"></div>
                                <p id="label">Source : </p>
                                <a class="modal_link" href="https://www.cdc.gov/" target="_blank">
                                    <p class="modal_source" id="value">www.cnet.net</p>
                                </a>
                            </li>
                            <li id="published">
                                <div id="icon" class="detailsIcon"></div>
                                <p id="label">Published : </p>
                                <p class="modal_detail" id="value">04/03/2020</p>
                            </li>
                            <li id="location">
                                <div id="icon" class="detailsIcon"></div>
                                <p id="label">Location : </p>
                                <p id="value">China</p>
                            </li>
                        </ul>
                        <p class="modal_detail" id="description">The nation's top <span class="highlighter">government watchdogs on Monday appointed Glenn Fine</span>, the acting inspector general for the Pentagon, to lead the newly created committee that oversees implementation of the $2 trillion coronavirus relief bill signed by President Donald Trump last week.<br><br>

                            Fine will lead a panel of fellow inspectors general, dubbed the Pandemic Response Accountability Committee, and command an $80 million budget meant to <span class="highlighter">"promote transparency and support oversight" of the massive disaster response legislation. His appointment was made by a fellow committee of inspectors general</span>, assigned by the new law to pick a chairman of the committee.<br><br>
                            
                            Fine, who served as Justice Department inspector general from 2000 to 2011 — spanning parts of the Clinton, Bush and Obama presidencies — will join nine other inspectors general on the new committee. They include the IGs of the Departments of Defense, Education, Health and Human Services, Homeland Security, Justice, Labor, and the Treasury; the inspector general of the Small Business Administration; and the Treasury inspector general for Tax Administration.</p>
                    </div>
                </div>
            </div>
        </section>


	<!-- <footer class="footer">
  <div class="container-fluid bg-primary mt60">
<p class="text-center text-medium pt10 pb10 mb0">Copyright &copy; Blogtrackers 2017 All Rights Reserved.</p>
</div>
  </footer> -->


	<script src="https://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>
	<script src="assets/bootstrap/js/bootstrap.js">
 </script>
	<script src="assets/js/generic.js">
 </script>

	<script src="assets/vendors/bootstrap-daterangepicker/moment.js"></script>
	<script
		src="assets/vendors/bootstrap-daterangepicker/daterangepicker.js"></script>
	<!-- Start for tables  -->
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

	<script src="pagedependencies/baseurl.js?v=3"></script>
	<script src="pagedependencies/narrative.js?v=09"></script>
	<script src="pagedependencies/sentiment.js?v=140"></script>
 
	<script>
 $(document).ready(function() {
	 
	 
	 
	/*  function PrintElem(elem)
	 {
	     var mywindow = window.open('', 'PRINT', 'height=400,width=600');

	     mywindow.document.write('<html><head><title>' + document.title  + '</title>');
	     mywindow.document.write('</head><body >');
	     mywindow.document.write('<h1>' + document.title  + '</h1>');
	     mywindow.document.write(document.getElementById(elem).innerHTML);
	     mywindow.document.write('</body></html>');

	     mywindow.document.close(); // necessary for IE >= 10
	     mywindow.focus(); // necessary for IE >= 10*/

	   /*  mywindow.print();
	     mywindow.close();

	     return true;
	 } */
 
	$('#printdoc').on('click',function(){
		print();
	}) 
	
	 $(function () {
		    $('[data-toggle="tooltip"]').tooltip()
		  })
		  
     $('#DataTables_Table_1_wrapper').DataTable( {
         "scrollY": 430,
          "pagingType": "simple",
         /*  dom: 
        	   'Bfrtip', 
                    "columnDefs": [
                 { "width": "80%", "targets": 0 }
               ]  */
  /*    ,
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


	 
     $('#DataTables_Table_0_wrapper').DataTable( {
         "scrollY": 370,
         "order": [[ 0, "asc" ]],
         "pagingType": "simple",
         "ordering": false
        /*   dom: 'Bfrtip',

                    "columnDefs": [
                 { "width": "80%", "targets": 0 }
               ] */
    /*  ,
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
   	var cb = function(start, end, label) {
           //console.log(start.toISOString(), end.toISOString(), label);
          // $('#reportrange span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
           $('#reportrange input').val(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY')).trigger('change');
         };

         var optionSet1 =
       	      {   startDate: moment().subtract(29, 'days'),
       	          endDate: moment(),
       	          minDate: '01/01/1947',
       	       	  linkedCalendars: false,
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
      // $('#reportrange span').html(moment().subtract( 500, 'days').format('MMMM D, YYYY') + ' - ' + moment().format('MMMM D, YYYY'))
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
   									+ picker.startDate.format('MMMM D, YYYY')
   									+ " to "
   									+ picker.endDate.format('MMMM D, YYYY')); 
   					var date_start = picker.startDate.format('YYYY-MM-DD');
   	            	var date_end1 = picker.endDate.format('YYYY-MM-DD');
   	            	//console.log("End:"+end);
   	            	//alert(date_start + " to "+ date_end1)
   	            	$("#date_start").val(date_start);
   	            	$("#date_end").val(date_end1);
   	            	
   	            	fetch_custom_narrative(date_start, date_end1)
   	            	
   	            	
   	            	
   	            	
   	            	//toastr.success('Date changed!','Success');
   	            	//$("form#customform").submit();
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
$(".option-only").on("change",function(e){
	//console.log("only changed ");
	var valu =  $(this).val();
	$("#single_date").val(valu);
	$('form#customformsingle').submit();
});

$(".option-only").on("click",function(e){
	//console.log("only Click ");
	$("#single_date").val($(this).val());
	//$('form#customformsingle').submit();
});

$(".option-lable").on("click",function(e){
	//console.log("Label Click ");
	
	$("#single_date").val($(this).val());
	//$('form#customformsingle').submit();
});
</script>
	<script>
  $('.carousel').carousel({
      interval: false
  });
  </script>



</body>
</html>

<% }} %>
