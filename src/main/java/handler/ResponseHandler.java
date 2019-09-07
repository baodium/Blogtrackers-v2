
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

import org.json.JSONObject;
import org.json.JSONArray;

/**
 * 
 * Servlet implementation class Login
 * @author Adewale
 * 
 */
@WebServlet("/request")
public class ResponseHandler extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	String user;	    
	   
	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public ResponseHandler() {
		
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {           

		String username = (null==request.getParameter("email"))?"":request.getParameter("email").trim();
		String pass = (null==request.getParameter("password"))?"":request.getParameter("password").trim();
		String action = (null==request.getParameter("action"))?"":request.getParameter("action").trim();
		
		PrintWriter pww = response.getWriter();
		if(action.equals("login")){			
			ArrayList login = new DbConnection().query("SELECT * FROM usercredentials where Email = '"+username+"' AND Password = '"+pass+"'");		
			if(login.size()>0)
			{
			  		
				HttpSession session = request.getSession();
				ArrayList userinfo = (ArrayList<?>)login.get(0);
				String user = (null==userinfo.get(0))?"":userinfo.get(0).toString();
				session.setAttribute("email",username);
				session.setAttribute("username",user);
				response.setStatus(200);
				pww.write("success");		
			}
		}else if(action.equals("list")){			
			if(!this.validateRequest(username,pass))
			{
				showError(pww,"301", "authentication required");		
			}else {
				this.list(pww);
			}
		}
		else if(action.equals("add")){			
			if(!this.validateRequest(username,pass))
			{
				showError(pww,"301", "authentication required");		
			}else {
				this.list(pww);
			}
		}
		else if(action.equals("login")){			
			if(!this.validateRequest(username,pass))
			{
				showError(pww,"301", "authentication required");		
			}else {
				this.list(pww);
			}
		}
		else{		
			showError(pww,"401", "invalid request ");	
		}
	
	}
	
	private boolean validateRequest(String username, String password) {
		ArrayList login = new DbConnection().query("SELECT * FROM usercredentials where Email = '"+username+"' AND Password = '"+password+"'");		
		if(login.size()>0)
		{
			ArrayList userinfo = (ArrayList<?>)login.get(0);
			String user = (null==userinfo.get(0))?"":userinfo.get(0).toString();
			this.user = user;
			return true;
		}
		return false;
	}
	
	
	private void list(PrintWriter pww) {
		Trackers tracker = new Trackers();
		try {
			ArrayList trackers = tracker._list("DESC", "", this.user, "100");
			JSONObject resp = new JSONObject();
			resp.put("User_id",this.user);
			JSONArray trackerjson= new JSONArray();
			if(trackers.size()>0){
				for (int i = 0; i < trackers.size(); i++) {
				ArrayList resut = (ArrayList)trackers.get(i);
				String trackerid = resut.get(0).toString();
				String trackername = resut.get(2).toString();
				JSONObject detail = new JSONObject();
	
				detail.put("tid",trackerid);
				detail.put("tname",trackername);
				trackerjson.put(detail);
				}
				
			}
			
			resp.put("trackers",trackerjson);
			pww.write(resp.toString());
		
		}catch(Exception ex) {
			showError(pww,"404", "not found");
		}
	}	
	private void add(PrintWriter pww) {
		HttpServletResponse  httpServletResponse = null;
		httpServletResponse.setHeader("Access-Control-Allow-Origin", "*");
		httpServletResponse.setHeader("Access-Control-Allow-Methods", "GET, OPTIONS");
		httpServletResponse.setHeader("Access-Control-Allow-Headers","Origin, X-Requested-With, Content-Type, Accept, X-Auth-Token, X-Csrf-Token, WWW-Authenticate, Authorization");
		httpServletResponse.setHeader("Access-Control-Allow-Credentials", "false");
		httpServletResponse.setHeader("Access-Control-Max-Age", "3600");	
		pww.write("hello");
	}
	
	private void showError(PrintWriter pww, String code, String message) {
		JSONObject error = new JSONObject();
		error.put("status","error");
		error.put("code",code);
		error.put("message", message);
		pww.write(error.toString());
	}

	//hello there
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{

	}
	
	
}
