
package handler;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;

import org.json.JSONObject;

import authentication.*;
import util.Blogposts;
import util.Trackers;

import java.util.*;

import org.json.JSONArray;

/**
 * 
 * Servlet implementation class Login
 * @author Adewale
 * 
 */

@WebServlet("/api/add")
public class AddTracker extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	String user;	    
	   
	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public AddTracker() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {           
		HttpSession session = request.getSession();
		String usession = (null==request.getHeader("session"))?"":request.getHeader("session").trim();
		String key= (null == session.getAttribute("key")) ? "" : session.getAttribute("key").toString();
		//String data = (null == request.getParameter("data"))? "" : request.getParameter("data").trim();
		String userid= (null == session.getAttribute("userid")) ? "" : session.getAttribute("userid").toString();
		
		PrintWriter pww = response.getWriter();
		
		pww.write("In add tracker endpoint \n");
		  	String data = "";   
		    StringBuilder builder = new StringBuilder();
		    BufferedReader reader = request.getReader();
		    String line;
		    while ((line = reader.readLine()) != null) {
		        builder.append(line);
		    }
		    data = builder.toString();
		    JSONObject object = null;
		    try {
		    	object = new JSONObject(data);	
		    }catch (Exception e) {
				// TODO: handle exception
			}
		    
	
		    pww.write("The input JSON Object is "+ object+"\n");
		    
		if(usession.equals(key) && !key.equals("")){ //chk if supplied session key is valid
			pww.write("\n Validated the user session \n");
			try {
			
				ArrayList tracker =null;
				ArrayList blogsite = null;
				
				DbConnection db = new DbConnection();
				AutomatedCrawlerConnect automatedCrawler = new AutomatedCrawlerConnect();


				String id = object.get("id").toString();
				JSONArray ids = new JSONArray(id);
				
				if(ids.length()>0) {
					for(int k=0; k<ids.length(); k++) {
					String selectedid = ids.get(k).toString();
					 tracker = db.query("SELECT * FROM trackers WHERE tid='"+selectedid+"' AND userid= '"+userid+"'");
					 if(tracker.size()>0){
						 	
						 	 ArrayList hd = (ArrayList)tracker.get(0);
						 	 String que = hd.get(5).toString();
						 	 String tracker_id = hd.get(0).toString();
						 	
							 que = que.replaceAll("blogsite_id in ", "");
							 que = que.replaceAll("\\(", "");			 
							 que = que.replaceAll("\\)", "");
							 System.out.println(que+"at this point is " );
							 String[] blogs = que.replaceAll(", $", "").split(",");
						
							 String site = object.get("site").toString();
							
							 LocalDateTime now = LocalDateTime.now();
							 
							 String checkBlog = "SELECT * FROM blogsites WHERE blogsite_url='"+site+"'";
							 ArrayList result = db.query(checkBlog);
							 ArrayList crawlerResult = automatedCrawler.query(checkBlog);
				
							 if(result.size()<1) {
								 String query="INSERT INTO blogsites(blogsite_name,blogsite_url,site_type) VALUES('"+site+"', '"+site+"', 11)";
								 db.updateTable(query);
								 if(crawlerResult.size()<1) {
								 automatedCrawler.updateTable("INSERT INTO blogsites(blogsite_name,blogsite_url,site_type) VALUES('"+site+"', '"+site+"', 20)");
								 automatedCrawler.updateTable("INSERT INTO crawler_pipeline (blogsite_name,priority,status,added_at, user_crawling_status) VALUES ('"+site+"', 'low', 'not_crawled', '"+now+"', -2)");
								 }
							 }else {
								 pww.write(site+ "\n Site has already been added to our list of blogsites \n");
							 }
							 blogsite = db.query("SELECT * FROM blogsites WHERE blogsite_url='"+site+"'");
							 ArrayList blog_result = (ArrayList)blogsite.get(0);
							 String blog_id = blog_result.get(0).toString();
							 
							 
							 
							 if(!que.contains(blog_id) && que.length() > 1) {
								que+=","+blog_id;
							 }else {
								que = blog_id; 
							 }
							 	que = "blogsite_id in ("+que+")";
							 	db.updateTable("UPDATE trackers SET query='"+ que +"', date_modified='"+now+"' WHERE tid='"+tracker_id+"'");
							 
							 
						
					 }else {
						 pww.write("Invalid tracker id \n");
					 }
					}
				}
				pww.write("Request completed \n");
			
			}catch(Exception ex) {
				ex.printStackTrace();
				pww.write("Invalid request \n");
			}
		}
		response.setContentType("text/plain");

		
	}

	//User Login
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		
	}
	
}
