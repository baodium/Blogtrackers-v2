
package wrapper;
<<<<<<< HEAD
=======

>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
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

import util.Mailing;
import authentication.DbConnection;

/**
 * Servlet implementation class Login
<<<<<<< HEAD
=======
 * 
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
 * @author Adewale
 */
@SuppressWarnings("unused")
@WebServlet("/forgotpassword")
public class Resetpassword extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Resetpassword() {
		super();

	}

	/**
<<<<<<< HEAD
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
=======
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
		response.setContentType("text/html");
		response.sendRedirect("forgotpassword.jsp");
	}

	/**
<<<<<<< HEAD
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{

		
		//authentication.Login auth = new authentication.Login();
		DbConnection dbinstance = new DbConnection();
		String submitted = request.getParameter("recover");
		PrintWriter pww = response.getWriter();
        HttpSession session = request.getSession();
		String app_url = request.getContextPath();
		
                //pww.write(email+":"+username+":"+pass+":"+submitted);
                    if(submitted!=null && submitted.equals("yes")){
                    	try {
			String email = request.getParameter("email");
			//System.out.println(email);
                        ArrayList prev = dbinstance.query("SELECT * FROM usercredentials WHERE Email = '"+email+"'");
                       // prev = (ArrayList)prev.get(0);
                      //  System.out.println(prev);
                        String[] receivers = {email};
                        if(prev.size()>0){
                        	prev = (ArrayList)prev.get(0);
                            double ran = Math.random();
                            String pass = dbinstance.md5Funct(ran+"");
                            pass = pass.substring(0,8);
                            boolean updated = dbinstance.updateTable("UPDATE usercredentials SET password  = '"+pass+"' WHERE Email = '"+email+"'");
                                if(updated){
                                session.setAttribute("success_message","A mail has been sent to "+email+" containing your login information");
                                try{
                                    Mailing.postMail(receivers, "Blogtrackers - Password Reset Information", "Hello "+prev.get(0)+", <br/><br/> Please note that your password has been changed to <b>"+pass+"</b>. <br/>You are strongly advised to change your password after first login. <br/>Kindly login at <a href='http://blogtrackers.host.ualr.edu/Blogtrackers/login.jsp'> Blogtrackers </a><br/><br/> Thanks for using Blogtrackers"); 
                                    response.sendRedirect("forgotpassword.jsp");
                                }catch(Exception e){
                                	response.setContentType("text/html");
                                    response.sendRedirect("login.jsp");
                                }
                            }else{
                                 session.setAttribute("error_message","invalid operation");
                                 response.sendRedirect("forgotpassword.jsp");
                                
                            }
                        }else{
                            session.setAttribute("error_message","invalid email address");
                            response.sendRedirect("forgotpassword.jsp");
 
                        }
                        
                    	}catch(Exception e) {
                    		session.setAttribute("error_message","invalid operation");
                    		response.setContentType("text/html");
                            response.sendRedirect("forgotpassword.jsp");
                    	}
                        
                    }
                    

		
=======
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// authentication.Login auth = new authentication.Login();
		DbConnection dbinstance = new DbConnection();
		String submitted = request.getParameter("recover");
		PrintWriter pww = response.getWriter();
		HttpSession session = request.getSession();
		String app_url = request.getContextPath();
//		String change = request.getParameter("changepword");
		
//System.out.println(change);
		// pww.write(email+":"+username+":"+pass+":"+submitted);
		if (submitted != null && submitted.equals("yes")) {
			try {
				String email = request.getParameter("email");
				session.setAttribute("email",email);
				// System.out.println(email);
				ArrayList prev = dbinstance.query("SELECT * FROM usercredentials WHERE Email = '" + email + "'");
				// prev = (ArrayList)prev.get(0);
				// System.out.println(prev);
				String[] receivers = { email };
				if (prev.size() > 0) {
					prev = (ArrayList) prev.get(0);
					double ran = Math.random();
					String pass = dbinstance.md5Funct(ran + "");
					pass = pass.substring(0, 8);
					boolean updated = dbinstance.updateTable(
							"UPDATE usercredentials SET password  = '" + pass + "' WHERE Email = '" + email + "'");
					if (updated) {
						
						session.setAttribute("success_message",
								"A mail has been sent to " + email + " containing your login information");
						
						try {
							
							Mailing.postMail(receivers, "Blogtrackers - Password Reset Information", "Hello "
									+ prev.get(0) +"YOU ARE A BIG BOY"
									+ ", <br/><br/> Please note that your password has been changed to <b>" + pass
									+ "</b>. <br/>You are strongly advised to change your password after first login. <br/>Kindly login at <a href='http://localhost:8080/Blogtrackers/login.jsp'> Blogtrackers </a><br/><br/> Thanks for using Blogtrackers");
							request.setAttribute("email", email);
							request.getRequestDispatcher("ChangePassword.jsp").forward(request, response);
							response.sendRedirect("forgotpassword.jsp");
							
						} catch (Exception e) {
							response.setContentType("text/html");
							response.sendRedirect("login.jsp");
						}
					} else {
						session.setAttribute("error_message", "invalid operation");
						response.sendRedirect("forgotpassword.jsp");

					}
				} else {
					session.setAttribute("error_message", "invalid email address");
					response.sendRedirect("forgotpassword.jsp");

				}

			} catch (Exception e) {
				session.setAttribute("error_message", "invalid operation");
				response.setContentType("text/html");
				response.sendRedirect("forgotpassword.jsp");
			}

		}
//		
		String action = (null==request.getParameter("action"))?"":request.getParameter("action");
		if (action != null && action.equals("update_password")) {

//			String password1 = request.getParameter("password");
//			System.out.println("NEW1"+password1);
			try {
				
//				String email = (String)session.getAttribute("email");
				String email = (null==request.getParameter("email"))?"":request.getParameter("email");
				String password = (null==request.getParameter("password"))?"":request.getParameter("password");
				String oldpassword = (null==request.getParameter("oldpassword"))?"":request.getParameter("oldpassword");
				
				boolean exi = false;
				
				if(!password.equals("") && !oldpassword.equals("")){
					ArrayList ex = dbinstance.query("SELECT Email FROM usercredentials where Email = '"+email+"' AND password ='"+oldpassword+"' ");
					
					if(ex.size()<1){
						exi = true;
						response.setContentType("text/html");
			            pww.write("nomatch"); 
					}
				}
				
				if(!exi){
					String keys = "UPDATE usercredentials SET ";
					String vals = "";

					if(!password.equals("")) {
						vals+="Password = '"+password+"',";
					}
					
					vals = vals.replaceAll(",$", "");
					
					String query_string=  keys+""+vals+" WHERE Email = '"+email+"'";
					
					boolean updated = dbinstance.updateTable(query_string); 
					if(updated && !email.equals("")) {
//						session.setAttribute("email",email);
						session.setAttribute("passwordupdated","yes");
//						response.setContentType("text/html");
			            pww.write("success"); 
			            
//			            session.invalidate();
			            
			            
					}
				}
				
				System.out.println("NEW"+password);
//				pww.write("success"); 
				
//				response.sendRedirect("ChangePassword.jsp");
				
//				session.setAttribute("email", email);
//				response.sendRedirect("index.jsp");
//				response.sendRedirect("login.jsp");
			} catch (Exception e) {
				// TODO: handle exception
			}
			
//			System.out.println("NEW"+email);
//			response.sendRedirect("login.jsp");
//		}
		}
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
	}
}
