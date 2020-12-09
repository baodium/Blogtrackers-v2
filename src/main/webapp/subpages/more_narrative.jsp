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
<%@page import="java.net.URI"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.DateTimeFormatter"%>

<%
Object action = (null == request.getParameter("action")) ? "" : request.getParameter("action");
Object entity = (null == request.getParameter("entity")) ? "" : request.getParameter("entity");
Object offset = (null == request.getParameter("entity")) ? "" : request.getParameter("offset");
Object level = (null == request.getParameter("level")) ? "" : request.getParameter("level");
Object tid = (null == request.getParameter("tid")) ? "" : request.getParameter("tid");
Object blog_ids = (null == request.getParameter("blog_ids")) ? "" : request.getParameter("blog_ids");
Object search_value = (null == request.getParameter("search_value")) ? "" : request.getParameter("search_value");

Object all_selected_entities = (null == request.getParameter("all_selected_entities")) ? "" : request.getParameter("all_selected_entities");
Object selected_entity_names = (null == request.getParameter("selected_entity_names")) ? "" : request.getParameter("selected_entity_names");




DbConnection db = new DbConnection();


if(action.toString().equals("load_more_narrative")){
	
	System.out.println(action+"--->"+entity.toString()+"--->level"+level+"--->"+tid.toString()+"--->"+offset.toString());

	%>
	
	
	<!-- start -->
	<link rel="stylesheet" href="assets/presentation/narrative-analysis.css"/>
    
	<!-- Getting Narratives for each entities-->
                
                <%
                String blogpost_narratives_query = "select COUNT(n.narrative) AS total_narrative_count, n.narrative, group_concat(n.blogpost_id separator ',') blogpost_id_concatenated, count(n.blogpost_id) c " + 
                		"from tracker_narratives, " +
                		"json_table(blogpost_narratives," +
                		  "'$.*.\""+ entity +"\"[*]' columns(" +
                		     "narrative varchar(128) path '$.narrative'," +
                		    "blogpost_id int(11) path '$.blogpost_id'" +
                		    ")" +
                		  ") " +
                		  "as n " +
                		  "where tid ="+ tid +" and n.narrative is not null " +
                		  "group by n.narrative " +
                		  "order by c desc " +
                		  "limit 5 offset "+ offset +";";
                		
                ArrayList blogpost_narratives = new ArrayList();
                try{
                	blogpost_narratives = db.queryJSON(blogpost_narratives_query);
                	System.out.println(blogpost_narratives);
                }catch(Exception e){
                	System.out.println(e);
                }
                
                
        		 for(int i = 0; i < blogpost_narratives.size(); i++){ 
        			JSONObject narratives_data = new JSONObject(blogpost_narratives.get(i).toString());
        			Object narrative = narratives_data.getJSONObject("_source").get("narrative");
        			Object blogpost_ids = narratives_data.getJSONObject("_source").get("blogpost_id_concatenated");
        			Object total_narrative_count = narratives_data.getJSONObject("_source").get("total_narrative_count");
        			System.out.println(total_narrative_count);
        		 String replace = "<span style=background:red;color:#fff>" + entity + "</span>";
        		// if(narrative.toString().toLowerCase().indexOf(entity.toString().toLowerCase()) != -1){
        			 
        		// }
        		 //String narrative_replaced = narrative.replace(entity, replace);
        		
                %>
                    <li id="narrative_pop_<%=i %>" class="narrative">
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
                                    <textarea count="<%=i %>" name="narrativeTextInput" class="narrativeText narrative_text_input"><%=narrative.toString() %></textarea>
                                    <div id="editControls">
                                        <button id="editButton"></button>
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
                            
                             <%
                            
                            
                             String [] blogposts_data = blogpost_ids.toString().split(",");
                             Object permalink = null;
                             Object date = null;
             				Object title = null;
             				Object post_detail = null;
             				String domain = null;
             				int b = 0;
                    		for(String bp_id : blogposts_data){                              			
                    				//Extract blogposts and entities
									if(b == 10){
										break;
									}
                    				try{
                    				ArrayList permalink_data = db.queryJSON("SELECT permalink, title, date, post from blogposts where blogpost_id = " + bp_id);
                    				if(permalink_data.size() > 0){
                    					JSONObject permalink_data_index = new JSONObject(permalink_data.get(0).toString());
                        				permalink = permalink_data_index.getJSONObject("_source").get("permalink");
                        				date = permalink_data_index.getJSONObject("_source").get("date");
                        				title = permalink_data_index.getJSONObject("_source").get("title");
                        				post_detail = permalink_data_index.getJSONObject("_source").get("post");
                        				URI uri = new URI(permalink.toString());
                        				domain = uri.getHost();
                    				}
                    				
                    				}catch(Exception e){
                    					System.out.println(e);
                    				}
                    				//System.out.println(permalink.toString());
                            %> 
                                <%-- <a href=<%=permalink.toString()%> target="_blank" idy="<%=bp_id%>"> --%>
                                    <div post_id=<%=bp_id %> class="post missingImage post_id_<%=bp_id%>">
                                         <!-- <img class="postImage" src="assets/images/posts/1.jpg"> -->
                                        <div class="<%=bp_id%>">
                                        	<input type="hidden" class="post-image <%=entity %>_image new_image" id="<%=bp_id%>" name="pic" value="<%=permalink.toString()%>">
                                        </div> 
                                        
                                        <h2 id="post_title_<%=bp_id %>" class="postTitle"><%=title.toString() %></h2>
                                        <p id="post_date_<%=bp_id %>" class="postDate"><%=date.toString() %></p>
                                        <p id="post_source_<%=bp_id %>" post_permalink="<%=permalink.toString()%>" class="postSource"><%=domain %></p>
                                        <input id="post_detail_<%=bp_id %>" type="hidden" value="<%=post_detail.toString() %>" >
                                        <%-- <input type="hidden" class="post-image" id="<%=bp_id%>" name="pic" value="<%=permalink.toString()%>"> --%>
                                        <%-- <p class="postSource"><%=bp_id %></p> --%>
                                    </div>
                                    
                               
                                <%
                                b++;
                    		} 
                    		
                    		%>                            
                            </div>
                        </div>
                    </li>
                    <%} %>
                    <li class="narrative hidden">
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
                                <p class="narrativeText">the coronavirus pandemic are crushing demand for new pipeline projects.</p>
                                <p class="counter"><span class="number">3</span>Posts</p>
                            </div>
                        </div>
                        <div class="bottomSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                            </div>
                            <div class="posts">
                                
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/38.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                
                                
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/39.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                
                                
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/40.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                
                            </div>
                        </div>
                    </li>
                    <li class="narrative hidden">
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
                                <p class="narrativeText">Last year a mysterious shipment was caught smuggling coronavirus from canada.</p>
                                <p class="counter"><span class="number">1</span>Posts</p>
                            </div>
                        </div>
                        <div class="bottomSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                            </div>
                            <div class="posts">
                                
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/41.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                
                            </div>
                        </div>
                    </li>
                    <li id="secondli_<%=entity %>" class="narrative last1 more1">
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
                                <p id="load_more_<%=entity %>" entity="<%=entity %>" level="<%=level %>" class="narrativeText load_more_entity">More...</p>
                            </div>
                        </div>
                    </li>
                
	<script src="assets/behavior/narrative-analysis.js"></script>
	<!-- end -->
<% }else if(action.toString().equals("merge_narrative")){ %>

<li class="level level1">
                <div id="keywordWrapper" class="group keyword1">
                    <button id="radioButton" title="Select"></button>
                    <div class="keyword ">
                        <div class="collapseIcon"></div>
                        <p class="text"><%=selected_entity_names.toString() %></p>
                    </div>
                    <button id="ungroupButton" title="Ungroup Keywords"></button>
                </div>
                <%
                List<Narrative.Data> merged_narrative =  Narrative.merge(all_selected_entities.toString());
                int limit = 5;
                for(int i = 0; i < limit; i++){
                	Narrative.Data narr = merged_narrative.get(i);
                	List<Integer> blogpost_ids = narr.getBlogpostIds();
                %>
                <ul class="narratives">
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
                                <p class="narrativeText narrative_text_input"><%=narr.getNarrative() %></p>
                                <p class="counter"><span class="number"><%=narr.getBlogpostIds().size() %></span>Posts</p>
                            </div>
                        </div>
                        <div class="bottomSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                            </div>
                            <div class="posts">
                                <%
                                String [] blogposts_data = blogpost_ids.toString().split(",");
                                List<?> permalink_data = new ArrayList<>();
                                
                                int length = blogpost_ids.toString().length();
                                String post_ids = (blogpost_ids.toString().substring(length - 1).equals(",")) ? blogpost_ids.toString().substring(0,length -1) : blogpost_ids.toString();
                                try{
                               	 String query = "SELECT blogpost_id, permalink, title, date, post from blogposts where blogpost_id in ("+post_ids.toString().replace("]","").replace("[","")+") and blogsite_id in ("+blog_ids+") order by date desc;";
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
                            </div>
                        </div>
                    </li>
                <%
               /* if(limit > 5){
        		break; 
                	 } 
                	limit++; */
                }
                %>
                </ul>
            </li>

	
	
	
<% }else if(action.toString().equals("search_narrative_post")){ 
	
	String bp_id = ""; 
	String permalink = "";
	String title = "";
	String domain ="";
	String post_detail ="";
	String date="";
	
	JSONObject res = Narrative.search_narratives_post(blog_ids.toString(), search_value.toString(), "10");
	JSONArray x = new JSONArray(res.getJSONObject("hits").getJSONArray("hits").toString());
	//for(Object x: res) {
	for(int i = 0; i < x.length(); i++) {
		try{
			JSONObject source = new JSONObject(x.get(i).toString());
			
			bp_id = source.getJSONObject("_source").get("blogpost_id").toString();
			permalink = source.getJSONObject("_source").get("permalink").toString();
			title = source.getJSONObject("_source").get("title").toString();
			
			URI uri = new URI(permalink.toString());
			domain = uri.getHost();
			
			
			date = source.getJSONObject("_source").get("date").toString();
			LocalDate datee = LocalDate.parse(date.toString().split("T")[0]);
			DateTimeFormatter dtf = DateTimeFormatter.ofPattern("MMM dd, yyyy");
			date = dtf.format(datee);
			
			post_detail = source.getJSONObject("_source").get("post").toString();
		}catch(Exception e){ 
			System.out.println("");
		}
	/* }
	
	for (int i = 1; i <= 10; i++){
		
		 bp_id = ""; 
		 permalink = "https://www.globalresearch.ca/trumps-alliance-with-body-choppers-death-squads-and-child-killers-saudi-arabia-brazil-and-israel/5657201";
		 title = "this is a dummy title";
		 domain = "www.juga.com";
		 post_detail = "htis is the informations for the post";
		 date = "31/09/2012"; */
		
	%>

	<div post_id=<%=bp_id %> class="post missingImage post_id_<%=bp_id%>">
        <!-- <img class="postImage" src="assets/images/posts/1.jpg"> -->
       <div class="<%=bp_id%>">
       	<input type="hidden" class="post-image <%=entity %>_image new_narrative_image" id="<%=bp_id%>" name="pic" value="<%=permalink.toString()%>">
       </div> 
         
         <h2 id="post_title_<%=bp_id %>" class="postTitle"><%=title.toString() %></h2>
         <p id="post_date_<%=bp_id %>" class="postDate"><%=date.toString() %></p>
         <p id="post_source_<%=bp_id %>" post_permalink="<%=permalink.toString()%>" class="postSource"><%=domain %></p>
         <input id="post_detail_<%=bp_id %>" type="hidden" value="<%=post_detail.toString() %>" >
         <%-- <input type="hidden" class="post-image" id="<%=bp_id%>" name="pic" value="<%=permalink.toString()%>"> --%>
         <%-- <p class="postSource"><%=bp_id %></p> --%>
     </div>
	
	
<%  }}
	
	%>
	

	