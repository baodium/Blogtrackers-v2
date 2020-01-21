package util;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

/**
 * Servlet implementation class TopKeywords
 */
@WebServlet("/TopKeywrds")
public class TopKeywords extends HttpServlet {
	private static final long serialVersionUID = 1L;


	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//doGet(request, response);
		Object date_start = (null == request.getParameter("date_start")) ? "" : request.getParameter("date_start");
		Object date_end = (null == request.getParameter("date_end")) ? "" : request.getParameter("date_end");
		Object blog_id = (null == request.getParameter("blog_id")) ? "" : request.getParameter("blog_id");

		Object all_blogs = (null == request.getParameter("all_blogs")) ? "" : request.getParameter("all_blogs");

		Object sort = (null == request.getParameter("sort")) ? "" : request.getParameter("sort");
		Object action = (null == request.getParameter("action")) ? "" : request.getParameter("action");
		Object post_ids = (null == request.getParameter("post_ids")) ? "" : request.getParameter("post_ids");
		
		Blogposts post = new Blogposts();
		String dt = date_start.toString();
		String dte = date_end.toString();
		String selectedblogid=blog_id.toString();
		PrintWriter out = response.getWriter();
		
		JSONObject sql = new JSONObject();
		String sql_= null;
		String result = null;
		
		if(action.toString().equals("gethighestterms")){
			try {
				System.out.println("looking for blog id"+selectedblogid);
				System.out.println("looking for dt"+dt);
				System.out.println("looking for dte"+dte);
			sql = post._getBloggerPosts("___NO__TERM___","NOBLOGGER",dt,dte,selectedblogid); 
			sql_ = sql.get("posts").toString();
			
			}catch(Exception e) {
				e.printStackTrace();
			}
			
			try {
				result = post.getHighestTerm(sql_);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			System.out.println("looking for result"+result);
			out.write(result);
			
			//JSONObject
		}
	}

}
