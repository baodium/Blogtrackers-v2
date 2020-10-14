<%@page import="java.io.PrintWriter"%>
<%@page import="authentication.*"%>
<%@page import="java.util.*"%>
<%@page import="util.*"%>
<%@page import="java.io.File"%>
<%@page import="util.Blogposts"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
Object action = (null == request.getParameter("action")) ? "" : request.getParameter("action");
Object entity = (null == request.getParameter("entity")) ? "" : request.getParameter("entity");
Object offset = (null == request.getParameter("entity")) ? "" : request.getParameter("offset");
Object level = (null == request.getParameter("level")) ? "" : request.getParameter("level");
Object tid = (null == request.getParameter("tid")) ? "" : request.getParameter("tid");


PrintWriter out_ = response.getWriter();


if(action.toString().equals("load_more_narrative")){
	
	System.out.println(action+"--->"+entity.toString()+"--->"+level.toString()+"--->"+tid.toString()+"--->"+offset.toString());

	%>
	
	
	<!-- start -->
	<link rel="stylesheet" href="assets/presentation/narrative-analysis.css"/>
        
    <script src="assets/behavior/narrative-analysis.js"></script>
	
	<!-- Getting Narratives for each entities-->
                
                <%
                String blogpost_narratives_query = "select n.narrative, group_concat(n.blogpost_id separator ',') blogpost_id_concatenated, count(n.blogpost_id) c " + 
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
                		  "limit 1 offset "+ offset +";";
                		
                ArrayList blogpost_narratives = new ArrayList();
                try{
                	blogpost_narratives = db.queryJSON(blogpost_narratives_query);
                	
                }catch(Exception e){
                	System.out.println(e);
                }
                
                
        		 for(int i = 0; i < blogpost_narratives.size(); i++){ 
        			JSONObject narratives_data = new JSONObject(blogpost_narratives.get(i).toString());
        			Object narrative = narratives_data.getJSONObject("_source").get("narrative");
        			Object blogpost_ids = narratives_data.getJSONObject("_source").get("blogpost_id_concatenated");
        			
        		 String replace = "<span style=background:red;color:#fff>" + entity + "</span>";
        		 if(narrative.toString().toLowerCase().indexOf(entity.toLowerCase()) != -1){
        			 
        		 }
        		 //String narrative_replaced = narrative.replace(entity, replace);
        		
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
                                    <textarea name="narrativeTextInput" class="narrativeText"><%=narrative.toString() %></textarea>
                                    <div id="editControls">
                                        <button id="editButton"></button>
                                    </div>
                                </div>
                                <p class="counter"><span class="number">32</span>Posts</p>
                            </div>
                        </div>
                        <div class="bottomSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                            </div>
                            <div class="posts">
                            
                             <%
                            //Getting posts related to narrative
                            //String blogposts_query = "SELECT JSON_SEARCH(blogpost_narratives, 'all', '" + narrative + "') AS j from narratives where tid = " + tid;
                            /* String blogposts_query = "SELECT JSON_SEARCH(blogpost_narratives, 'all', '" + narrative + "', NULL, '$.*.\"" + entity + "\"[*]') AS j from tracker_narratives where tid = " + tid;
                            ArrayList blogposts = new ArrayList();
                            JSONArray blogpost_source_array = new JSONArray();
                            JSONArray blogposts_data = new JSONArray();
                            try{
                            	blogposts = db.query(blogposts_query);
                            	blogpost_source_array = new JSONArray(blogposts.get(0).toString());
                            	String temp = blogpost_source_array.get(0).toString();
                            	if(temp.charAt(0) == "[".charAt(0)){
                            		blogposts_data = new JSONArray(temp);
                            	}else{
                            		blogposts_data = new JSONArray("[\"" + temp.replaceAll("\"","\\\\\"") + "\"]");
                            	}

                        		
                            }catch(Exception e){
                            	System.out.println(e);
                            }
                             */
                            
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
                                        	<input type="hidden" class="post-image" id="<%=bp_id%>" name="pic" value="<%=permalink.toString()%>">
                                        </div> 
                                        
                                        <h2 id="post_title_<%=bp_id %>" class="postTitle"><%=title.toString() %></h2>
                                        <p id="post_date_<%=bp_id %>" class="postDate"><%=date.toString() %></p>
                                        <p id="post_source_<%=bp_id %>" post_permalink="<%=permalink.toString()%>" class="postSource"><%=domain %></p>
                                        <input id="post_detail_<%=bp_id %>" type="hidden" value="<%=post_detail.toString() %>" >
                                        <%-- <input type="hidden" class="post-image" id="<%=bp_id%>" name="pic" value="<%=permalink.toString()%>"> --%>
                                        <%-- <p class="postSource"><%=bp_id %></p> --%>
                                    </div>
                                    
                               <!--  </a> -->
                                <!-- <a href="#">
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/2.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
                                    </div>
                                </a> -->
                               
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
                    <li class="narrative last more">
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
                                <p entity="<%=entity %>" level="<%=level+1 %>" class="narrativeText load_more_entity">More...</p>
                            </div>
                        </div>
                    </li>
                
	
	<!-- end -->
	
<% } %>
	

	