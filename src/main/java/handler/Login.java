
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
@WebServlet("/api/login")
public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	String user;	    
	   
	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Login() {
		
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

		String uid = (null==request.getHeader("uid"))?"":request.getHeader("uid").trim();
		String hash = (null==request.getHeader("hash"))?"":request.getHeader("hash").trim();
		
		PrintWriter pww = response.getWriter();
		pww.write("in login");
		if(!uid.equals("") && !hash.equals("")){
			DbConnection dbinstance = new DbConnection();
			String sessionkey =dbinstance.md5Funct(Math.random()+"");
			ArrayList login = new DbConnection().query("SELECT * FROM usercredentials where Email = '"+uid+"' AND MessageDigest = '"+hash+"'");		
			
			pww.write("The user id is " + uid +"\n");
			pww.write("the hash is " + hash + "\n");
			
			if(login.size()>0)
			{		  		
				HttpSession session = request.getSession();
				ArrayList userinfo = (ArrayList<?>)login.get(0);
				String user = (null==userinfo.get(0))?"":userinfo.get(0).toString();
				
				session.setAttribute("key",sessionkey);
				pww.write("The session attribute key contains " + session.getAttribute("key") +"\n");
				session.setAttribute("userid",user);
				session.setAttribute(sessionkey,user);
				//pww.write("The parameter sessionkey is "+ sessionkey + "\n");
				JSONObject resp = new JSONObject();
				resp.put("key",sessionkey);
				resp.put("userid",user);
				response.setStatus(200);
				pww.write(resp.toString());
				
			}else {
				pww.write("invalid credentials");	
			}
		}
		response.setContentType("text/plain");
	}
	
}
