<%@page import="java.util.*"%>
<%@ page import="javax.servlet.http.*" %>
<%@page import="util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% 
	Object url = (null == request.getParameter("url")) ? "" : request.getParameter("url");
	//System.out.println("Url:"+url);
   if (url!="") {
	 // url="https://justiceinconflict.org/2017/07/21/good-politics-or-bad-law-the-international-criminal-court-bashir-and-south-africa/"; //"http://hojja-nusreddin.livejournal.com/542676.html?nojs=1";//"https://www.lindaikejisblog.com/2018/6/kim-kardashians-birthday-message-to-kanye-west-acknowledges-all-hes-been-through-this-year.html";
	   String res = new ImageLoader().getUrl(url.toString());
 %>
 <%=res%>
 <%
   }else{ %>
   empty
 <%          
   }
%>
