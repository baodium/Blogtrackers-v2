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
Object action = (null == request.getParameter("action")) ? "" : request.getParameter("action");
Object entity = (null == request.getParameter("entity")) ? "" : request.getParameter("entity");
Object offset = (null == request.getParameter("entity")) ? "" : request.getParameter("offset");
Object level = (null == request.getParameter("level")) ? "" : request.getParameter("level");
Object tid = (null == request.getParameter("tid")) ? "" : request.getParameter("tid");
Object search_value = (null == request.getParameter("search_value")) ? "" : request.getParameter("search_value");
Object blog_ids = (null == request.getParameter("blog_ids")) ? "" : request.getParameter("blog_ids");



DbConnection db = new DbConnection();
Narrative n = new Narrative();


if(action.toString().equals("search_narrative")){
	List<Narrative.Entity> res = Narrative.search(search_value.toString());
	//JSONObject result = Narrative.search(search_value.toString());
	//Object hits = result.getJSONObject("hits").getJSONArray("hits");
	//JSONArray hit = new JSONArray(hits.toString());

	String entity_string;
	%>

<!-- Narrative Tree -->
<link rel="stylesheet" href="assets/presentation/narrative-analysis.css" />
<script src="assets/behavior/narrative-analysis.js"></script>

<ul id="narrativeTree">
	<%
        //for(Narrative.Entity x: res){
        	//System.out.println(res);
        //for(int k = 0; k < hit.length(); k++) {
        	//JSONObject x = new JSONObject(hit.get(k).toString());
        	//entity_string = x.getJSONObject("_source").get("entity").toString();
			//Object data = x.getJSONObject("_source").getJSONArray("data");
		for(int k = 0; k < res.size(); k++){	
        	Narrative.Entity x = res.get(k);
			entity_string = x.getEntity();
        %>
	<li class="level level1">
		<div class="keyword keyword1">
			<div class="collapseIcon"></div>
			<p class="text"><%= entity_string%></p>
		</div> <!-- Getting Narratives for each entities-->
		<ul id="narrative_list_<%=entity %>" class="narratives">

			<%
                //JSONArray narratives = new JSONArray(x.toString().split("-------")[1]);
			    //JSONArray narratives = new JSONArray(data.toString());
				List<Narrative.Data> narratives = x.getData();
                for(int i = 0; i < narratives.size(); i++){
                	if(i == 5){
                		break;
                	}
                
                	//JSONObject narr = new JSONObject(narratives.get(i).toString());
                	String narrative = narratives.get(i).getNarrative();
                	//String narrative = narr.get("narrative").toString();
                	List<Integer> blogpost_ids = narratives.get(i).getBlogpostIds();
                	//JSONArray blogpost_ids = new JSONArray(narr.get("blogpost_ids").toString());
                %>
			<!-- <ul class="narratives"> -->
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
						<p class="narrativeText narrative_text_input"><%=narrative %></p>
						<p class="counter">
							<span class="number"><%=blogpost_ids.size() %></span>Posts
						</p>
					</div>
				</div>
				<div class="bottomSection">
					<div class="connectorBox">
						<div class="connector"></div>
					</div>
					<div class="posts">
						<%
                            		String [] blogposts_data = blogpost_ids.toString().split(",");
                                    Object permalink = "";
                                    Object date = "";
                     				Object title = "";
                     				Object post_detail = "";
                     				String domain = "";
                     				String bp_id = "";
                     				
                     				List<?> permalink_data = new ArrayList<>();
                                    
                     				String post_ids = "";
                     				post_ids = blogpost_ids.toString().replace("[", "").replace("]","");
                                    int length = post_ids.length();
                                    post_ids = (post_ids.substring(length - 1).equals(",")) ?post_ids.substring(0,length -1) : post_ids;
                                    try{
                                   	 	//String query = "SELECT blogpost_id, permalink, title, date, post from blogposts where blogpost_id in ("+post_ids+") and blogsite_id in ("+blog_ids.toString()+") order by date desc;";
                                   	 	String query = "SELECT blogpost_id, permalink, title, date, post from blogposts where blogpost_id in ("+post_ids+") order by date desc;";
                                        permalink_data = db.queryJSON(query);
                                    }catch(Exception e){
                                   	 System.out.println("here");
                                    }
                                    
                            		for(int j = 0; j < permalink_data.size(); j++){
                            			//System.out.println("fffffffffffffff"+blogpost_ids.get(j));
                            			//String bp_id = blogpost_ids.get(j).toString();
                            			if(j == 10){
                            				break;
                            			}
                            			try{
                            				//ArrayList permalink_data = db.queryJSON("SELECT permalink, title, date, post from blogposts where blogpost_id = " + bp_id);
                            				if(permalink_data.size() > 0){
                            					JSONObject permalink_data_index = new JSONObject(permalink_data.get(j).toString());
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
						<div post_id=<%=bp_id %>
							class="post missingImage post_id_<%=bp_id%>">
							<!-- <img class="postImage" src="assets/images/posts/1.jpg"> -->
							<div class="<%=bp_id%>">
								<input type="hidden" class="post-image new_search_image"
									id="<%=bp_id%>" name="pic" value="<%=permalink.toString()%>">
							</div>

							<h2 id="post_title_<%=bp_id %>" class="postTitle"><%=title.toString() %></h2>
							<p id="post_date_<%=bp_id %>" class="postDate"><%=date.toString()%></p>
							<p id="post_source_<%=bp_id %>"
								post_permalink="<%=permalink.toString()%>" class="postSource"><%=domain %></p>
							<input id="post_detail_<%=bp_id %>" type="hidden"
								value="<%=post_detail.toString() %>">
							<%-- <input type="hidden" class="post-image" id="<%=bp_id%>" name="pic" value="<%=permalink.toString()%>"> --%>
							<%-- <p class="postSource"><%=bp_id %></p> --%>
						</div>
						<%} %>
					</div>
				</div>
			</li>
			<%} %>
			<!-- <li class="narrative last">
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
                                <p class="narrativeText">Chinese senior officials alleged without evidence that the us army brought the virus.</p>
                                <p class="counter"><span class="number">55</span>Posts</p>
                            </div>
                        </div>
                        <div class="bottomSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                            </div>
                            <div class="posts">
                                
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/1.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                                      
                                
                            </div>
                        </div>
                    </li> -->
		</ul>
	</li>
	<%} %>
</ul>





<% } %>


