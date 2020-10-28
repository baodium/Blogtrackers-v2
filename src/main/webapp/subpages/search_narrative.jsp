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


<%
Object action = (null == request.getParameter("action")) ? "" : request.getParameter("action");
Object entity = (null == request.getParameter("entity")) ? "" : request.getParameter("entity");
Object offset = (null == request.getParameter("entity")) ? "" : request.getParameter("offset");
Object level = (null == request.getParameter("level")) ? "" : request.getParameter("level");
Object tid = (null == request.getParameter("tid")) ? "" : request.getParameter("tid");
Object search_value = (null == request.getParameter("search_value")) ? "" : request.getParameter("search_value");


DbConnection db = new DbConnection();
Narrative n = new Narrative();


if(action.toString().equals("search_narrative")){
	List<Narrative.Entity> res = Narrative.search(search_value.toString());
	String entity_string;
	%>
	
	<!-- Narrative Tree -->
        <ul id="narrativeTree">
        <%
        for(Narrative.Entity x: res){
        	//System.out.println(res);
        	entity_string = x.toString().split("-------")[0];
        %>
            <li class="level">
                <div class="keyword">
                    <div class="collapseIcon"></div>
                    <p class="text"><%= entity_string%></p>
                </div>
                
                <%
                JSONArray narratives = new JSONArray(x.toString().split("-------")[1]);
                for(int i = 0; i < narratives.length(); i++){
                	if(i == 5){
                		break;
                	}
                
                	JSONObject narr = new JSONObject(narratives.get(i).toString());
                	String narrative = narr.get("narrative").toString();
                	
                	JSONArray blogpost_ids = new JSONArray(narr.get("blogpost_ids").toString());
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
                                <p class="narrativeText"><%=narrative %></p>
                                <p class="counter"><span class="number">2</span>Posts</p>
                            </div>
                        </div>
                        <div class="bottomSection">
                            <div class="connectorBox">
                                <div class="connector"></div>
                            </div>
                            <div class="posts">
                            		 <%
                            		for(int j = 0; j < blogpost_ids.length(); j++){
                            			if(j == 10){
                            				break;
                            			}
                            		%> 
                                    <div class="post">
                                        <img class="postImage" src="assets/images/posts/1.jpg">
                                        <h2 class="postTitle">Russia Belatedly Begins to Awaken to the Coronavirus Awaken to the Coronavirus</h2>
                                        <p class="postDate">Sep 12 2020 - 9:00 PM</p>
                                        <p class="postSource">www.cnn.net</p>
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
	

	