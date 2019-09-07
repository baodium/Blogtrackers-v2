<%@page import="java.util.*"%>
<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>
<%@page import="authentication.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>



<%
//
   File file ;
   int maxFileSize = 5000 * 1024;
   int maxMemSize = 5000 * 1024;
   String path=application.getRealPath("/").replace('\\', '/')+"images/profile_images/";
   path = path.replace("build/", "");
  
   String filePath = path;//"c:/apache-tomcat/"; 
   String contentType = request.getContentType();

   if ((contentType.indexOf("multipart/form-data") >= 0)) {

      DiskFileItemFactory factory = new DiskFileItemFactory();
      factory.setSizeThreshold(maxMemSize);
      factory.setRepository(new File("c:\\temp"));
      ServletFileUpload upload = new ServletFileUpload(factory);
      
     
      upload.setSizeMax( maxFileSize );
      
     // String t_number=request.getParameter("t_number_");
      try{ 
         List fileItems = upload.parseRequest(request);
         Iterator i = fileItems.iterator();
          String email = session.getAttribute("email").toString();
          String file_name= email+".jpg";

          
         while ( i.hasNext () ) 
         {
            FileItem fi = (FileItem)i.next();
            if ( !fi.isFormField () )  {
                String fieldName = fi.getFieldName();
                String fileName = fi.getName();
                boolean isInMemory = fi.isInMemory();
                long sizeInBytes = fi.getSize();
               // t_number=t_number+".jpg";
				//
                file = new File( filePath + email+".jpg") ;
                fi.write( file ) ;
                //System.out.println("Uploaded Filename: " + filePath + file_name + "<br>");
              new DbConnection().updateTable("UPDATE usercredentials SET profile_picture ='"+filePath + file_name+"' WHERE Email='"+email+"'");
           }
         }
         
         
         response.sendRedirect("profile.jsp");
         
      }catch(Exception ex) {
         out.println("<p>No file uploaded</p>"); 
      }
   }else{
     
       response.sendRedirect("index.jsp"); 
   }

%>
