<%@page import="authentication.*"%>
<%@page import="util.*"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>


<%@ page import="java.io.*,java.util.*, javax.servlet.*"%>
<%
  Object email = (null == session.getAttribute("email")) ? "" : session.getAttribute("email");
  Object username = (null == session.getAttribute("username")) ? "" : session.getAttribute("username");
  String sort =  (null == request.getParameter("sortby")) ? "date" : request.getParameter("sortby");
  Object selected = (null == session.getAttribute("selected")) ? "" : session.getAttribute("selected");
  
  JSONObject jblog = new JSONObject();
  if(!selected.equals("")){
	  jblog = new JSONObject(session.getAttribute("selected"));
  }
  Trackers trackers  = new Trackers();
  JSONObject myblogs = new JSONObject();
  Blogs blogs  = new Blogs();
  int perpage =12;
  PrintWriter pww = response.getWriter();
 System.out.println("Here");
	//try {

		String submitted = request.getParameter("load");		
	    if(submitted!=null && submitted.equals("yes")){	
	        String viewtype = request.getParameter("viewtype");
	        System.out.println("View Type: "+viewtype);
	        String cpage = request.getParameter("from");
	        int from = Integer.parseInt(cpage);
			Blogposts post  = new Blogposts();
			String term =  request.getParameter("term");
			ArrayList results = null;
						
			if(term.equals("")){

				results = post._list("DESC",cpage,sort);		

			}else{
				results = post._search(term,cpage,sort);
			}
			
			//System.out.println("username:"+username.toString());
			myblogs = trackers.getMyTrackedBlogs(username.toString());
			//System.out.println("Myblogs here"+myblogs);
			if(results.size()>0){
				String res = null;
				JSONObject resp = null;
				String resu = null;
				JSONObject obj = null;
				int totalpost = 0;
				String bres = null;
				JSONObject bresp = null;
				String bresu =null;
				JSONObject bobj =null;
					for(int i=0; i< results.size(); i++){
						String blogtitle="";
					
						 res = results.get(i).toString();
						
						 resp = new JSONObject(res);
					     resu = resp.get("_source").toString();
					     obj = new JSONObject(resu);
					     String blogid = obj.get("blogsite_id").toString();
					     String[] dt = obj.get("date").toString().split("T");
					     
					     String pst = obj.get("post").toString();//.replaceAll("[^a-zA-Z]", " ");
					     if(pst.length()>120){
					    	 pst = pst.substring(0,120);
					     }

						 ArrayList blog = blogs._fetch(blogid);

						 if( blog.size()>0){
									 bres = blog.get(0).toString();			
									 bresp = new JSONObject(bres);
									 bresu = bresp.get("_source").toString();
									 bobj = new JSONObject(bresu);
									 blogtitle = bobj.get("blogsite_name").toString();
									 
							 }
					     String totaltrack  = trackers.getTotalTrack(blogid);
					     %>
<% if (viewtype.equalsIgnoreCase("grid") || viewtype.equalsIgnoreCase("")){ %>					     
<!-- Start of grid look  --> 
		<div class="card noborder curved-card mb30" >
			<div class="curved-card selectcontainer borders-white curve_<%=blogid%> <%=jblog.has(blogid)?"border-selected":""%>">
			<% if(!username.equals("") || username.equals("")){ %>
			 <div class="text-center"><i class="fas text-medium pt40 fa-check text-light-color icon-big2 cursor-pointer trackblog blog_id_<%=blogid%>" data-toggle="tooltip" data-placement="top"  title="<%=jblog.has(blogid)?"Remove Blog from Tracker":"Select to Track Blog"%>"></i></div>
			<% } %>
			<h4 class="text-primary text-center p10 pt20 posttitle <%=jblog.has(blogid)?"text-selected":""%>"><a class="blogname-<%=blogid%>" href="<%=request.getContextPath()%>/blogpostpage.jsp?p=<%=obj.get("blogpost_id")%>"><%=blogtitle%></a></h4>
			
			<div class="text-center mt10 mb10 trackingtracks <%=jblog.has(blogid)?"makeinvisible":""%>">
			<% if(myblogs.has(blogid)){ %><button class="btn btn-primary stylebutton7">TRACKING</button><% } %> <button class="btn btn-primary stylebutton8"><%=totaltrack%> Tracks</button>
			  </div>
			
			

			
			  <div class="card-body">
			
			    <a href="<%=request.getContextPath()%>/blogpostpage.jsp?p=<%=obj.get("blogpost_id")%>"><h4 class="card-title text-primary text-center pb20 bold-text post-title"><%=obj.get("title").toString()%></h4></a>
			
			    <p class="card-text text-center author mb0 light-text"><%=obj.get("blogger") %></p>
			    <p class="card-text text-center postdate light-text"><%=dt[0]%></p>
			  </div>
			  <div class="<%=obj.get("blogpost_id")%>">
			  <input type="hidden" class="post-image" id="<%=obj.get("blogpost_id")%>" name="pic" value="<%=obj.get("permalink") %>">
			  </div>
<%
String favoritestatus = "far";
String title = "Add to Favorites";
if(!email.equals("") || !email.equals(null))
{
Favorites favorites = new Favorites();
String allblogstring = favorites.checkIfFavoritePost(username.toString());
String[] allblogarray = allblogstring.split(",");
String blogpostid = obj.get("blogpost_id").toString(); 
//favoritestatus = "far";
//System.out.println(allblogarray.length);
for(int j=0; j<allblogarray.length; j++)
{
	if(allblogarray[j].equals(blogpostid))
	{
		favoritestatus = "fas";
		title = "Remove from Favorites";
		break;
	}
	//System.out.println(allblogarray[i]);	
} 
}  
%>
			  <div class="text-center"><i id="blogpostt_<%=obj.get("blogpost_id").toString() %>" class="<%=favoritestatus %> fa-heart text-medium pb30  favorites-text icon-big favoritestoggle cursor-pointer" data-toggle="tooltip" data-placement="top" title="<%=title %>"></i></div>
			</div>
			</div>
<!-- grid look  -->
<%}%>
<% if (viewtype.equalsIgnoreCase("list")){ %>	
  <tr class="curve_<%=blogid%>">
          <td class="noborderright borders-white <%=jblog.has(blogid)?"border-selected":""%>"><i class="fas text-medium fa-check text-light-color icon-big2 cursor-pointer trackblog blog_id_<%=blogid%>" data-toggle="tooltip" data-placement="top"  title="Select to Track Blog"></i></td>
          <td class="noborderleft noborderright borders-white blogsitename <%=jblog.has(blogid)?"border-selected":""%>"><h6 class="text-primary myposttitle"><a class="blogname-<%=blogid%>" href="<%=request.getContextPath()%>/blogpostpage.jsp?p=<%=obj.get("blogpost_id")%>">
          <%=blogtitle%></a></h6></td>
          <td class="noborderleft noborderright borders-white <%=jblog.has(blogid)?"border-selected":""%>"><h6 class="text-primary"><a class="blogname-<%=blogid%>" href="<%=request.getContextPath()%>/blogpostpage.jsp?p=<%=obj.get("blogpost_id")%>">
          <%=obj.get("title").toString()%></a></h6></td>
          <td class="noborderleft noborderright borders-white <%=jblog.has(blogid)?"border-selected":""%>"><%=obj.get("blogger") %></td>
          <td class="noborderleft borders-white"><%=dt[0]%></td>
        </tr>
<%} %>

			
			
		<%}
		}else{ 
			pww.write("empty");
	  }
			
			
	}// end of check submitted 
//} catch (Exception ex) {}		

%>  
