
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
@WebServlet("/api/list")
public class ListTrackers extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	String user;	    
	   
	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public ListTrackers() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {           

		
	}


	//User Login
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		
		HttpSession session = request.getSession();
		String usession = (null==request.getHeader("session"))?"":request.getHeader("session").trim();
		String key= (null == session.getAttribute("key")) ? "" : session.getAttribute("key").toString();
		PrintWriter pww = response.getWriter();
		
		if(usession.equals(key) && !key.equals("")){ //check if supplied session key is valid
			Trackers tracker = new Trackers();
			try {
				ArrayList trackers = tracker._list("DESC", "", session.getAttribute(key).toString(), "100");
				JSONObject resp = new JSONObject();
				resp.put("session",key);
				JSONArray trackerjson= new JSONArray();
				if(trackers.size()>0){
					for (int i = 0; i < trackers.size(); i++) {
						ArrayList resut = (ArrayList)trackers.get(i);
						String trackerid = resut.get(0).toString();
						String trackername = resut.get(2).toString();
						String query = resut.get(5).toString();//obj.get("query").toString();
						
						query = query.replaceAll("blogsite_id in ", "");
						query = query.replaceAll("\\(", "");
						query = query.replaceAll("\\)", "");
						String[] blogs = query.replaceAll(", $", "").split(",");
						
						JSONObject detail = new JSONObject();
						
						detail.put("id",trackerid);
						detail.put("name",trackername);
						
						JSONArray sites= new JSONArray(); 
						for(int j=0; j<blogs.length; j++) {
								 sites.put(blogs[j]);
						 }
						detail.put("sites",sites);
						trackerjson.put(detail);
					}
					
				}
				
				resp.put("trackers",trackerjson);
				pww.write(resp.toString());
			
			}catch(Exception ex) {
				pww.write("invalid request");
			}
			
		}else {
			System.out.println("you are here");
		}
		response.setContentType("text/plain");

	}
	
}
