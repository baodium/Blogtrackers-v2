package util;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;



import authentication.*;
import java.util.*;
import util.*;
import java.io.File;
import util.Blogposts;
import java.text.NumberFormat;
import java.util.Locale;
import java.util.ArrayList;
import org.json.JSONArray;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Servlet implementation class Influence
 */
@WebServlet("/PostingFrequencyTest")
public class PostingFrequency1 extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
 

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		PrintWriter out = response.getWriter();
		
		
		
		
		
		Object date_start = (null == request.getParameter("date_start")) ? "" : request.getParameter("date_start");
		Object date_end = (null == request.getParameter("date_end")) ? "" : request.getParameter("date_end");
		Object blogger = (null == request.getParameter("blogger")) ? "" : request.getParameter("blogger");
		Object blog_id = (null == request.getParameter("blog_id")) ? "" : request.getParameter("blog_id");
		Object index = (null == request.getParameter("index")) ? "" : request.getParameter("index");
		Object sort = (null == request.getParameter("sort")) ? "" : request.getParameter("sort");
		Object action = (null == request.getParameter("action")) ? "" : request.getParameter("action");
		Object all_blog_ids = (null == request.getParameter("all_blog_ids")) ? "" : request.getParameter("all_blog_ids");
		

		String bloggerstr = blogger.toString().replaceAll("_"," ");

		Trackers tracker  = new Trackers();
		Blogposts post  = new Blogposts();
		Blogs blog  = new Blogs();
				String dt = date_start.toString();
				String dte = date_end.toString();
				String year_start="";
				String year_end="";		
				
				JSONObject authoryears = new JSONObject();
				JSONObject years = new JSONObject();
				JSONArray yearsarray = new JSONArray();
				
				JSONObject result = new JSONObject();
				
				String[] yst = dt.split("-");
				String[] yend = dte.split("-");
				year_start = yst[0];
				year_end = yend[0];
				int ystint = Integer.parseInt(year_start);
				int yendint = Integer.parseInt(year_end);
				
				
				
				JSONArray line_data = new JSONArray();
				try {
				line_data = post._getGetDateAggregate1(blogger.toString(),"date","yyyy-MM-dd","post","month","date_histogram", dt, dte, all_blog_ids.toString());

				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
				result.put("hahaha",line_data);
				System.out.println("my_line_data");
				System.out.println(line_data);
				
						int b=0;
						JSONObject postyear =new JSONObject();
						JSONObject postyear1 =new JSONObject();
						for(int y=ystint; y<=yendint; y++){ 
								   String dtu = y + "-01-01";
								   String dtue = y + "-12-31";
								   String totu = "0";
								   if(b==0){
										dtu = dt;
									}else if(b==yendint){
										dtue = dte;
									}
								   
								   //if(sort.toString().equals("influence_score")){
									
								   	 try {
								   		
										totu = post._searchRangeTotalByBlogger("date",dtu, dtue,blogger.toString());
										
										line_data = post._getGetDateAggregate1(blogger.toString(),"date","yyyy-MM-dd","post","month","date_histogram", dtu, dtue, all_blog_ids.toString());
										
									} catch (Exception e) {
										// TODO Auto-generated catch block
										e.printStackTrace();
									}
								   //}
								   
								   if(!years.has(y+"")){
							    		years.put(y+"",y);
							    		yearsarray.put(b,y);
							    		b++;
							    	}
								   
								   postyear.put(y+"",totu);
								   postyear1.put(y+"",line_data);
								  
						}
						authoryears.put(bloggerstr,postyear);
						
						
						
						
						
						String name =  bloggerstr;
						String au = bloggerstr;
						JSONObject specific_auth= new JSONObject(authoryears.get(au).toString());
						
						
						Iterator x = specific_auth.keys();
						JSONArray jsonArray = new JSONArray();

						while (x.hasNext()){
						    String key = (String) x.next();
						    jsonArray.put(specific_auth.get(key));
						}
						
						if (action.toString().equals("getchart")) {
							JSONArray line_data1 = new JSONArray();
							 try {
								// line_data = post._getGetDateAggregate1("BLOGGER","date","yyyy-MM-dd","post","month","date_histogram",  dt, dte, blogger.toString());
								 line_data1 = post._getGetDateAggregate1("BLOGGER","date","yyyy-MM-dd","post","month","date_histogram", dt, dte, blogger.toString());
									
										System.out.println("line_datarr");
										System.out.println(line_data1);
										
										result.put("name", line_data1);
										result.put("hahahaha", blogger);
								} catch (Exception e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								}
							 
							
						}else {
							
							result.put("name", blogger);
							result.put("values", specific_auth);
							result.put("yearsarray", yearsarray);
							result.put("index", index);
							result.put("identify", blog_id);
							result.put("line_Data", line_data);
							result.put("post_years1", postyear1);
							
						}
						
						
						
						System.out.println(index);
						System.out.println("line_data11");
						
						out.println(result);
						
//				  		for(int q=0; q<yearsarray.length(); q++){ 
//					  
//					  		String yearr=yearsarray.get(q).toString(); 
//					  		if(specific_auth.has(yearr)){ 
//					  			{"date":yearr,"price":specific_auth.get(yearr) },
//						
//					  		}else{ 
//					  			{"date":yearr,"price":0},
//				   		 } 
//					 
//				  		}
		
		
		
		
		
		
		
		
	}

}
