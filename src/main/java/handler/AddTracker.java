
package handler;
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

import authentication.DbConnection;
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
		String data = (null == request.getParameter("data"))? "" : request.getParameter("data").trim();
		
		PrintWriter pww = response.getWriter();
		
		if(usession.equals(key) && !key.equals("")){ //check if supplied session key is valid
			
			try {
			
				JSONObject resp = new JSONObject(data);
				ArrayList tracker =null;
				ArrayList blogsite = null;
				
				
				DbConnection db = new DbConnection();
					 tracker = db.query("SELECT * FROM trackers WHERE tid='"+resp.get("id")+"' ");
					 			 
					 if(tracker.size()>0){
						 
						 	 ArrayList hd = (ArrayList)tracker.get(0);
						 	 String que = hd.get(5).toString();
						 	 
						 	 String tracker_id = hd.get(0).toString();
						 	
						 	 
							 que = que.replaceAll("blogsite_id in ", "");
							 que = que.replaceAll("\\(", "");			 
							 que = que.replaceAll("\\)", "");
							 
							 String[] blogs = que.replaceAll(", $", "").split(",");
							
							 JSONObject jblog = new JSONObject();
							 
							 String mergedblogs = "";
							 
							 jblog.put(resp.get("site").toString(), resp.get("site").toString());
							 
							 String[] allblogs = mergedblogs.replaceAll(",$", "").split(",");
							 
							 
							int blognum = allblogs.length;

							String addendum = "blogsite_id in ("+mergedblogs+")";
							 
							String site = resp.getString("site");
							String id = resp.getString("id");
							
							LocalDateTime now = LocalDateTime.now();
						
					
							String checkBlog = "SELECT * FROM blogsites WHERE blogsite_url='"+site+"'";
							ArrayList result = db.query(checkBlog);
							
							if(result.size()<1) {
							String query="INSERT INTO blogsites(blogsite_name,blogsite_url,site_type) VALUES('"+site+"', '"+site+"', 11)";
							db.updateTable(query);
							
							pww.write("Successfully inserted "+site+" to the blogsite table\n");
							
							pww.write("Updating the tracker table ...\n");
							}
							//blogsite = db.query("SELECT * FROM blogsites ORDER BY blogsite_id DESC LIMIT 1");
							blogsite = db.query("SELECT * FROM blogsites WHERE blogsite_url='"+site+"'");
							System.out.println(blogsite);
							ArrayList blog_result = (ArrayList)blogsite.get(0);
							System.out.println(blog_result);
							String blog_id = blog_result.get(0).toString();
							
							for(int j=0; j<blogs.length; j++) {
								 if(!jblog.has(blogs[j])) {
									 mergedblogs+=blogs[j]+",";
								 }
							 }
							 mergedblogs+=blog_id;
							 String updatedQuery = "blogsite_id in ("+mergedblogs+")";
							
							db.updateTable("UPDATE trackers SET query='"+ updatedQuery +"', date_modified='"+now+"' WHERE tid='"+tracker_id+"'");
							
					 }
				pww.write("successful request");
			
			}catch(Exception ex) {
				ex.printStackTrace();
				pww.write("invalid request");
			}
		}

		
	}


	//User Login
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		
	}
	
}
