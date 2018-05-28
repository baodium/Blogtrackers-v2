
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
		
		//System.out.println("post request");
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
				//session.setAttribute("user",username);
				//session.setAttribute("user",login.get(0));               
               // session.setAttribute("username",login.get(0));
                session.setAttribute("email",username);
                
				/*
                Object selected = (null == session.getAttribute("pre-selected-blogs")) ? "" : session.getAttribute("pre-selected-blogs");
                
                Common c = new Common();
                try{
                	ArrayList trackers = new DBConnector().query("SELECT * FROM trackers WHERE userid='"+login.get(0)+"'");
                	session.setAttribute("trackers", trackers);
                }catch(Exception ex){}
                */
                
                response.setContentType("text/html");
                //if(selected!="") {
                	//pww.write("confirmed");
                //}else {
                	pww.write("success");
                //}                              
			}
			else
			{
				response.setContentType("text/html");
				pww.write("invalid");
			}
                        
		}


	}
}
