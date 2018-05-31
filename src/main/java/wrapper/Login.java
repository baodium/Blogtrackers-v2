
package wrapper;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import authentication.DbConnection;

/**
 * 
 * Servlet implementation class Login
 * @author Ayodele
 * 
 */
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
		System.out.println("get request");
		response.setContentType("text/html");    
		response.sendRedirect("login.jsp");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{

		String username = request.getParameter("email").replaceAll("\\<.*?\\>", "");
		String pass = request.getParameter("password").replaceAll("\\<.*?\\>", "");
		String submitted = request.getParameter("login");


		PrintWriter pww = response.getWriter();

		if(submitted.equals("yes"))
		{			
			ArrayList login = new DbConnection().query("SELECT * FROM usercredentials where Email = '"+username+"' AND Password = '"+pass+"'");

			if(login.size()>0)
			{
				HttpSession session = request.getSession();

				session.setAttribute("email",username);
				pww.write("success");

			}
			else
			{
				response.setContentType("text/html");
				pww.write("invalid");
			}

		}


	}
}
