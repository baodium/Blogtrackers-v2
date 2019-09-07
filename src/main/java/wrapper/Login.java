
package wrapper;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import authentication.DbConnection;

/**
 * 
 * Servlet implementation class Login
 * @author Adewale
 * 
 */
/*  login servlet*/
@WebServlet("/login")
public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Login() {
		super();

	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {           
	//	System.out.println("get request");
		response.setContentType("text/html");    
		response.sendRedirect("login.jsp");
	}

	//hello there
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{

		String username = request.getParameter("email").replaceAll("\\<.*?\\>", "");
		String pass = request.getParameter("password").replaceAll("\\<.*?\\>", "");
		boolean remember = request.getParameter("remember") != null;
		String submitted = request.getParameter("login");
		

		PrintWriter pww = response.getWriter();

		if(submitted.equals("yes"))
		{			
			ArrayList login = new DbConnection().query("SELECT * FROM usercredentials where Email = '"+username+"' AND Password = '"+pass+"'");


			if(login.size()>0)
			{
			  		
				HttpSession session = request.getSession();
				ArrayList userinfo = (ArrayList<?>)login.get(0);
				String user = (null==userinfo.get(0))?"":userinfo.get(0).toString();
				session.setAttribute("email",username);
				session.setAttribute("username",user);
				pww.write("success");		
				if(remember) {
					Cookie ckUsername = new Cookie("username", username);
					ckUsername.setMaxAge(3600);
					response.addCookie(ckUsername);
				}
			}
			else
			{
				response.setContentType("text/html");
				pww.write("invalid");
			}

		}


	}
	
	private String checkCookie(HttpServletRequest request) {
		Cookie[] cookies = request.getCookies();
		if(cookies == null)
			return null;
		else {
			String username = "", password ="";
			for (Cookie ck: cookies) {
				if(ck.getName().equalsIgnoreCase("username"))
					username = ck.getValue();
				if(ck.getName().equalsIgnoreCase("password"))
					password = ck.getValue();
			}
		}
		
		return null;
		
	}
}
