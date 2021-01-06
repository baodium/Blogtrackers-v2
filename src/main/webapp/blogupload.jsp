<%@page import="java.util.*"%>
<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>
<%@page import="authentication.*"%>
<%-- <%@page import="authentication.Blogsite"%> --%>
<%@page import="util.Weblog"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.regex.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
//
String username = (null == session.getAttribute("username")) ? "" : session.getAttribute("username").toString();
if(username.equals("")){
	response.sendRedirect("index.jsp"); 
}else{
   File file ;
   int maxFileSize = 1000 * 1024;
   int maxMemSize = 1000 * 1024;
   String path=application.getRealPath("/").replace('\\', '/')+"blogfiles/";
   path = path.replace("build/", "");
  

   String validator = "/^[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\\.[a-zA-Z]{2,}$/";
   
   Pattern p = Pattern.compile(validator);//. represents single character  
  
   Weblog wblog =new Weblog();
   //Blogsite bs =new Blogsite();
   
   String filePath = path;//"c:/apache-tomcat/"; 
   String contentType = request.getContentType();

   if ((contentType.indexOf("multipart/form-data") >= 0)) {

     
      try{ 
    	  DiskFileItemFactory factory = new DiskFileItemFactory();
          factory.setSizeThreshold(maxMemSize);
          factory.setRepository(new File("c:\\temp"));
          ServletFileUpload upload = new ServletFileUpload(factory);
        
          upload.setSizeMax( maxFileSize );
          
         List fileItems = upload.parseRequest(request);
         Iterator i = fileItems.iterator();
          
          
         while ( i.hasNext () ) 
         {
            FileItem fi = (FileItem)i.next();
            if ( !fi.isFormField () )  {
                String fieldName = fi.getFieldName();
                String fileName = fi.getName();
                boolean isInMemory = fi.isInMemory();
                long sizeInBytes = fi.getSize();
               
                file = new File( filePath +"blogs.txt") ;
                fi.write( file ) ;
               
				BufferedReader br = null;	
				try {
					br = new BufferedReader(new FileReader(filePath +"blogs.txt"));  	// Read the config file
					String temp = "";														// Temporary variable to loop through the content of the file
					String[] arr;
					while((temp = br.readLine()) != null) {
						temp = temp.trim();  											 	// Strip the whitespaces
						/* System.out.println(temp); */
						if(temp.isEmpty()) { 						
							continue;														// Skip the comments, for example the author, created on and document type
						}
						else {
							 String blogsite_url = temp;
							 Matcher m = p.matcher(blogsite_url);  
							 if(m.matches()){  
								 //blogsite_url = bs.cleanUrl(blogsite_url);
								 String output = wblog._addBlog(username, blogsite_url, "not_crawled");						
					         }
						}	
					}
				} catch(IOException ex) {
			
				}          
              
            }
         }
         
         
         response.sendRedirect("addblog.jsp");
         
      }catch(Exception ex) {
    	  response.sendRedirect("addblog.jsp");
      }
   }else{  
       response.sendRedirect("index.jsp"); 
   }
}
%>
