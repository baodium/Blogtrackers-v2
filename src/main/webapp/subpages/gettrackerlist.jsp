<%@page import="authentication.*"%>
<%@page import="java.util.*"%>
<%@page import="util.*"%>
<%@page import="java.io.File"%>

<%@page import="util.*"%>
<%@page import="java.text.NumberFormat" %>
<%@page import="java.util.Locale" %>

<%@page import="java.util.ArrayList"%>
<%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%

Object email = (null == session.getAttribute("email")) ? "" : session.getAttribute("email");

ArrayList<?> userinfo = new ArrayList();//null;
String profileimage= "";
String username ="";
String name="";
String phone="";
String date_modified = "";
JSONObject myblogs = new JSONObject();
ArrayList mytrackers = new ArrayList();
Trackers trackers  = new Trackers();
Blogs blogs  = new Blogs();

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
myblogs = trackers.getMyTrackedBlogs(username);
mytrackers = trackers._list("DESC","",username,"100");
	
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
 <%
ArrayList resut = new ArrayList();
if(mytrackers.size()>0){
for(int i=0; i< mytrackers.size(); i++){
			resut = (ArrayList)mytrackers.get(i);				
%>
<button class="btn form-control col-md-10 text-primary text-left trackerindividual pt10 pb10 pl10 resetdefaultfocus bold-text" id="<%=resut.get(0).toString()%>"><%=resut.get(2).toString()%> <i class="fas fa-check float-right hidden checktracker"></i></button>
<% }} %>

<script src="pagedependencies/blogbrowser3.js">
</script>