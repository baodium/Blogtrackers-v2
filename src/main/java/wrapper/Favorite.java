
package wrapper;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import org.apache.commons.lang3.ArrayUtils;
import org.json.JSONObject;

import util.Trackers;
import util.Favorites;
import util.Blogposts;
import authentication.DbConnection;
import java.util.*;

/**
 * 
 * Servlet implementation class Register
 * @author Adekunle Adigun
 * 
 */

@WebServlet("/favorites")
public class Favorite extends HttpServlet{
	
	private static final long serialVersionUID = 1L;
	
	public Favorite()
	{
		super();
	}
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	response.setContentType("text/html");
	response.sendRedirect("blogbrowser.jsp");
	}
	
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		Favorites favorite = new Favorites();
		PrintWriter pww = response.getWriter();
		HttpSession session = request.getSession();
		String username = (null == session.getAttribute("username")) ? "" : session.getAttribute("username").toString();
	
		String blogpostids = (null==request.getParameter("allblogpost"))?"":request.getParameter("allblogpost").replaceAll("\\<.*?\\>", "");
		String blogpostid = (null==request.getParameter("bloposttoadd"))?"":request.getParameter("bloposttoadd").replaceAll("\\<.*?\\>", "");
		String action = (null==request.getParameter("action"))?"":request.getParameter("action").replaceAll("\\<.*?\\>", "");
		
		// for non logged in users
		if(username.equalsIgnoreCase("") || username.equalsIgnoreCase(null))
		{
		response.setContentType("text/html");
		pww.write("notloggedin");	
		}
		// if user is logged in
		else
		{
		// add to favorites	
		if(action.equalsIgnoreCase("addtofavorites"))
		{
		pww.write(favorite.insertPostInFavorite(username,blogpostid));	
		}
		// remove from favorites
		if(action.equalsIgnoreCase("removefromfavorites"))
		{
			pww.write(favorite.removePostFromFavorites(username, blogpostid));	
		}
		
		}
		System.out.println(blogpostids);
		//System.out.println(username);
	}
	
}