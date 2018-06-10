<%@page import="authentication.*"%>
<%@page import="util.Blogposts"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.json.JSONObject"%>
<%@ page import="java.io.*,java.util.*, javax.servlet.*"%>
<%
Object email = (null == session.getAttribute("email")) ? "" : session.getAttribute("email");

if (email == null || email == "") {
	response.sendRedirect("index.jsp");
}else{

  int perpage =12;
  PrintWriter pww = response.getWriter();
 
	try {
		System.out.println("b4");
		String submitted = request.getParameter("load");
	    if(submitted!=null && submitted.equals("yes")){	
	        
	        String cpage = request.getParameter("from");
	        int from = Integer.parseInt(cpage);
	       
			Blogposts post  = new Blogposts();
			String term =  request.getParameter("term");
			ArrayList results = null;
			if(term.equals("")){
				results = post._list("DESC",cpage);
			}else{
				results = post._search(term,cpage);
			}
			
			if(results.size()>0){
				for(int i=0; i< results.size(); i++){
					String res = results.get(i).toString();
					
					JSONObject resp = new JSONObject(res);
				    String resu = resp.get("_source").toString();
				     JSONObject obj = new JSONObject(resu);
				     
				     String pst = obj.get("post").toString();
				     if(pst.length()>120){
				    	 pst = pst.substring(0,120);
				     }
					
		%>
		<div class="card noborder curved-card mb30" >
		<div class="text-center"><i class="fas text-medium pt40 fa-check text-light-color icon-big2 cursor-pointer" title="Select to Track Blog"></i></div>
		<h4 class="text-primary text-center pt20"><a href="<%=request.getContextPath()%>/blogpostpage.jsp?p=<%=obj.getString("blogpost_id")%>"><%=obj.getString("title") %></a></h4>
		<div class="text-center"><button class="btn btn-primary stylebutton3">TRACKING</button> <button class="btn btn-primary stylebutton2">0 Tracks</button></div>
		  <div class="card-body">
		    <a href="<%=request.getContextPath()%>/blogpostpage.jsp?p=<%=obj.getString("blogpost_id")%>"><h4 class="card-title text-primary text-center pb20"><%=pst+"..."%></h4></a>
		    <p class="card-text text-center author mb0 light-text"><%=obj.getString("blogger") %></p>
		    <p class="card-text text-center postdate light-text"><%=obj.getString("date") %></p>
		  </div>
		  <img class="postimage card-img-top pt30 pb30" id="<%=obj.getString("blogpost_id")%>" src="https://i.pinimg.com/736x/31/74/48/3174480c49cee70bd03627255f136b83--fat-girls-girls-hbo.jpg" onerror="this.src'https://i.pinimg.com/736x/31/74/48/3174480c49cee70bd03627255f136b83--fat-girls-girls-hbo.jpg'" alt="<%=obj.getString("permalink") %>">
		  <div class="text-center"><i class="far fa-heart text-medium pb30  light-text icon-big"></i></div>
		</div>
		<%}
		}else{ 
			pww.write("empty");
	  }
	}
	} catch (Exception ex) {}		
}
%>            
