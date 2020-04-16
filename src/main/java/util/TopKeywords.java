package util;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import scala.Tuple2;

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
		
		
		
		
		Object blogger = (null == request.getParameter("blogger")) ? "" : request.getParameter("blogger");
		Object all_bloggers = (null == request.getParameter("all_bloggers")) ? ""
				: request.getParameter("all_bloggers");
		Object ids = (null == request.getParameter("ids")) ? "" : request.getParameter("ids");
		
		Blogposts post = new Blogposts();
		String dt = date_start.toString();
		String dte = date_end.toString();
		String selectedblogid=blog_id.toString();
		PrintWriter out = response.getWriter();
		
		JSONObject sql = new JSONObject();
		String sql_= null;
		String result = null;
		
		Map<String, Integer> result_dashboard = new HashMap<String, Integer>();
		
		if(action.toString().equals("gethighestterms")){
			try {
				System.out.println("looking for blog id"+selectedblogid);
				System.out.println("looking for dt"+dt);
				System.out.println("looking for dte"+dte);
			sql = post._getBloggerPosts("___NO__TERM___","NOBLOGGER",dt,dte,selectedblogid,1000); 
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
		
		
		

		else if (action.toString().equals("getkeyworddashboard")) {
			Terms terms = new Terms();
			System.out.println("action is getkeyworddashboard and ids are " +ids.toString());
			try {
				terms._getTerms("___NO__TERM___", "__NOBLOGGER__", date_start.toString(), date_end.toString(),
						ids.toString());
				List<Tuple2<String, Integer>> data = terms.getTupleData();
				String output = terms.mapReduce(data, "dashboard");
				for (Tuple2<String, Integer> x : data) {
					result_dashboard.put(x._1, x._2);
				}
			} catch (Exception e) {

			}
			out.write(result_dashboard.toString());
		}
	}

}
