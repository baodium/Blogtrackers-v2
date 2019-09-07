
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

import org.json.JSONObject;

import util.Trackers;
import util.Blogposts;
import authentication.DbConnection;
import java.util.*;

/**
 * 
 * Servlet implementation class Tracker
 * @author Adedayo Ayodele
 * 
 */
@WebServlet("/tracker")
public class Tracker extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Tracker() {
		super();

	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {           
		response.setContentType("text/html");    
		response.sendRedirect("trackerlist.jsp");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		 Trackers trk = new Trackers();  
		 Blogposts bp = new Blogposts();  
		 
		 PrintWriter pww = response.getWriter();
		 HttpSession session = request.getSession();
			
		String username = (null == session.getAttribute("username")) ? "" : session.getAttribute("username").toString();
		
        String tracker_name = (null==request.getParameter("name"))?"":request.getParameter("name").replaceAll("\\<.*?\\>", "");
        String description = (null==request.getParameter("description"))?"":request.getParameter("description").replaceAll("\\<.*?\\>", "");
        String blogs = (null==request.getParameter("blogs"))?"":request.getParameter("blogs").replaceAll("\\<.*?\\>", "");
        String tracker_id = (null==request.getParameter("tracker_id"))?"":request.getParameter("tracker_id").replaceAll("\\<.*?\\>", "");
		
        String query = "";
		String action = (null==request.getParameter("action"))?"":request.getParameter("action");
		String userid = username;//(String) session.getAttribute("user");
		
		if(action.equals("create"))
		{	
			/*
			if(blogs.length()<1) {
				 response.setContentType("text/html");				 
			     pww.write("blog cannot be empty"); 
			}else {
			 			
			 JSONObject param = new JSONObject();
			 param.put("trackername", tracker_name);
			 param.put("description", description);
			 param.put("blogs", blogs);			 
			 String output =  "false";
			 try {
				 output = trk._add(username, param);
				 response.setContentType("text/html");				 
			     pww.write(output); 
			 }catch(Exception e) {}		 
				 response.setContentType("text/html");				 
			     pww.write(output); 
			}       
			*/
			String userName = (String) session.getAttribute("username");
			//String keyword = request.getParameter("keyword");
			String trackerName=tracker_name.trim();//request.getParameter("title");
			if(!trackerName.trim().isEmpty()){

				String trackerDescription=description;//request.getParameter("descr");
				String createdDate= getDateTime();
				String selected = blogs;//request.getParameter("sites");
				//session.setAttribute("searched", "about "+keyword);
				//selected = selected.tr
				String[] selectedSite = selected.split(","); 
				String listString = "";
				if(selectedSite.length>0){
					for (int i = 0; i < selectedSite.length; i++) { 
						listString += selectedSite[i] + ",";
					}
					listString="blogsite_id in ("+listString.substring(0, listString.length()-1)+")";
				}else{
					listString="blogsite_id in (0)";
				}
				//TrackerDialog dialog= new TrackerDialog();
				//dialog.addTracker(userName, trackerName, createdDate, null, listString, trackerDescription, selectedSite.length);
				ArrayList prev = new DbConnection().query("SELECT * FROM trackers WHERE tracker_name='"+trackerName+"' AND userid= '"+userid+"'");
				//System.out.println("Previous:"+trackerName+" "+userid+"User-"+prev);
				if(prev!=null && prev.size()>0) {
					pww.write("tracker already exist");
				}else {	
				   query="INSERT INTO trackers(userid,tracker_name,date_created,date_modified,query,description,blogsites_num) VALUES('"+userid+"', '"+trackerName+"', '"+createdDate+"', "+ null+", '"+listString+"', '"+trackerDescription+"', '"+selectedSite.length+"')";
					boolean done = new DbConnection().updateTable(query);
					if(done) {
					  	ArrayList trackers = new DbConnection().query("SELECT * FROM trackers WHERE userid='"+userid+"' ORDER BY tid DESC LIMIT 1");
	                	session.setAttribute("trackers", trackers+"");
	                	session.setAttribute("initiated_search_term", "");
						response.setContentType("text/html");
						
						if(trackers.size()>0){
						 	ArrayList hd = (ArrayList)trackers.get(0);
							String que = hd.get(0).toString();
							pww.write(que);
						}else {
							pww.write("error creating tracker");
						}
					}else {
						response.setContentType("text/html");
						pww.write("error creating tracker");
					}
				}
			}
			else{
				response.setContentType("text/html");
				pww.write("Trackername cannot be empty");
			}
		}else if(action.equals("update")) {
			String[] bloggs = blogs.replaceAll(", $", "").split(",");
			
			try {
				ArrayList tracker =null;
				
				DbConnection db = new DbConnection();
				String addendum="";
					 tracker = db.query("SELECT * FROM trackers WHERE tid='"+tracker_id+"' AND userid='"+userid+"'");
					 
					 if(tracker.size()>0){
						 	ArrayList hd = (ArrayList)tracker.get(0);
							String que = hd.get(5).toString();
							
							 que = que.replaceAll("blogsite_id in ", "");
							 que = que.replaceAll("\\(", "");			 
							 que = que.replaceAll("\\)", "");
							 String[] blogs2 = que.replaceAll(", $", "").split(",");
							 
							 JSONObject jblog = new JSONObject();
								
							
							 if(tracker_name.equals("")) {
								 tracker_name = hd.get(2).toString();
							 }
							
							 if(description.equals("")) {
								 description = hd.get(6).toString();
							 }
							
							 
							 String mergedblogs = "";//this.mergeArrays(bloggs, blogs2);
							 
							 for(int k=0; k<bloggs.length; k++) {
								 jblog.put(bloggs[k], bloggs[k]);
									mergedblogs+=bloggs[k]+",";								
							 }
					 
							 for(int j=0; j<blogs2.length; j++) {
								 if(!jblog.has(blogs2[j])) {
									 if(j != blogs2.length - 1) {
										 mergedblogs+=blogs2[j]+","; 
									 }
									 else if(j == blogs2.length - 1)
									 {
										 mergedblogs+=blogs2[j]; 
									 }
									
									
								 }
							 }
							 
							 String[] allblogs = mergedblogs.replaceAll(",$", "").split(",");
							 int blognum = allblogs.length;
							// System.out.println("Blog during update ajax request "+  mergedblogs);
							 addendum = "blogsite_id in ("+mergedblogs+")";//"blogsite_id in ("+addendum+blog_id+")";
							 
							 String modifiedDate= getDateTime();
							db.updateTable("UPDATE trackers SET query='"+addendum+"', tracker_name='"+tracker_name+"', description='"+description+"', date_modified='"+modifiedDate+"', blogsites_num = '"+blognum+"' WHERE  tid='"+tracker_id+"'");	
							pww.write("success");
					 }else {
						 	pww.write("invalid tracker");
					 }

			}catch(Exception ex) {
				pww.write("false"); 
			}
		}else if(action.equals("updatedetail")) {
			
			try {
				ArrayList tracker =null;
				
					DbConnection db = new DbConnection();
					 tracker = db.query("SELECT * FROM trackers WHERE tid='"+tracker_id+"' AND userid='"+userid+"'");
					
					 if(tracker.size()>0){
						 String modifiedDate= getDateTime();
							
						 db.updateTable("UPDATE trackers SET tracker_name='"+tracker_name+"', description='"+description+"', date_modified='"+modifiedDate+"' WHERE  tid='"+tracker_id+"'");	
						 //tracker = db.query("SELECT * FROM trackers WHERE tid='"+tracker_id+"' AND userid='"+userid+"'");
						 //System.out.println("tracker here :"+tracker_name+"-"+tracker);
						 
						 pww.write("success");
					 }else {
						 pww.write("invalid tracker");
					 }

			}catch(Exception ex) {
				pww.write("false"); 
			}
		}else if(action.equals("setselected")) {
			
			try {
				String ids= request.getParameter("blog_ids").replaceAll("\\<.*?\\>", "");
				JSONObject jblog = new JSONObject();
				String output = "false";
				String[] bloggs = ids.split(",");
				for(int k=0; k<bloggs.length; k++) {
					jblog.put(bloggs[k], bloggs[k]);
				}
				session.setAttribute("selected",jblog.toString());
				pww.write("added"); 
			}catch(Exception ex) {
				pww.write("false"); 
			}
		}else if(action.equals("delete")) {	
			try {
					String tid = request.getParameter("tracker_id");
					new DbConnection().updateTable("DELETE FROM trackers WHERE  tid='"+tracker_id+"' AND userid='"+userid+"'");						
					pww.write("success");
				}catch(Exception ex) {
					 pww.write("error"); 
				}			
				
		}else if(action.equals("removeblog")) {
			String ids= request.getParameter("blog_ids").replaceAll("\\<.*?\\>", "");
			//System.out.println(ids);
			/*
			try {
				String output = trk._removeBlogs(tracker_id,ids,username);
				pww.write(output);
			}catch(Exception e) {
				 pww.write("false"); 
			 }	
			 */
			try {
			DbConnection db = new DbConnection();
//			String[] bloggs = ids.split(",");
			String[] bloggs = new String[1];
			bloggs[0] = ids;
			//System.out.println(bloggs[0].toString());
			JSONObject jblog = new JSONObject();
			String output = "false";
			
			for(int k=0; k<bloggs.length; k++) {
				jblog.put(bloggs[k], bloggs[k]);
			}
			
//			System.out.println();
			ArrayList detail = new DbConnection().query("SELECT * FROM trackers WHERE tid='"+tracker_id+"' AND userid='"+userid+"'");
        	
			 if(detail.size()>0){
				 	ArrayList hd = (ArrayList)detail.get(0);
					String que = hd.get(5).toString();
					
					 que = que.replaceAll("blogsite_id in ", "");
					 que = que.replaceAll("\\(", "");			 
					 que = que.replaceAll("\\)", "");
					 String[] blogs2 = que.split(",");
					 String idToCheck = ids.toString();
					
					 
					 String mergedblogs = "";	
					 int blogcounter=0;
					 for(int j=0; j<blogs2.length; j++) {
						 //System.out.println(ids);
						 //if(!jblog.has(blogs2[j].toString())) {
						 if(blogs2[j].equalsIgnoreCase(idToCheck)) {
							 //System.out.println(idToCheck);
							 //System.out.println(blogs2[j].equalsIgnoreCase(idToCheck)+"equals");
							 //blogcounter++;
							 //continue;
							
						 }
						 else if(!blogs2[j].equalsIgnoreCase(idToCheck)) {
//							 System.out.println(idToCheck);
//							 System.out.println(!blogs2[j].equalsIgnoreCase(idToCheck)+"not equals");
							 if(j<(blogs2.length-1))
								 mergedblogs+=blogs2[j]+",";
							 else
								 mergedblogs+=blogs2[j];
							 blogcounter++;
						 }
					 }
					 	//System.out.println(mergedblogs);		
					que =  "blogsite_id in ("+mergedblogs+")";	
					String modifiedDate= getDateTime();
					
					db.updateTable("UPDATE trackers SET query='"+que+"', blogsites_num = '"+blogcounter+"', date_modified='"+modifiedDate+"' WHERE  tid='"+tracker_id+"'");	
					pww.write("success");
			 }else {
				 pww.write("false");
			 }
			}catch(Exception e) {
				 pww.write("false"); 
			}	
			 
			 			
		}else if(action.equals("fetchpost")) {
			String key= request.getParameter("key").replaceAll("\\<.*?\\>", "");
			String value= request.getParameter("value").replaceAll("\\<.*?\\>", "");
			String source = request.getParameter("source").replaceAll("\\<.*?\\>", "");
			String section = request.getParameter("section").replaceAll("\\<.*?\\>", "");
			String output="";
			try {
				ArrayList posts = bp._getPost(key,value);
				if(posts.size()>0){
					//pww.write(posts+"");
					if(source.equals("influence") && section.equals("detail_table")) {

						for (int p = 0; p < posts.size(); p++) {
							String bstr = posts.get(p).toString();
							JSONObject bj = new JSONObject(bstr);
							bstr = bj.get("_source").toString();
							bj = new JSONObject(bstr);
							String dat = bj.get("date").toString().substring(0,10);
							LocalDate datee = LocalDate.parse(dat);
							DateTimeFormatter dtf = DateTimeFormatter.ofPattern("MMM dd, yyyy");
							String date = dtf.format(datee);
							//System.out.println(bj.get("body"));
							
							output+="<h5 class='text-primary p20 pt0 pb0'>#1: "+bj.get("title").toString().replaceAll("[^a-zA-Z]", " ")+"</h5>" + 
									"					<div class='text-center mb20 mt20'><a href='"+request.getContextPath()+"bloggerportfolio.jsp?tid=<%=tid%>&blogger=<%=tobj.get(\"blogger\")%>\">\r\n" + 
									"											" + 
									"						<button class='btn stylebuttonblue'>" + 
									"							<b class='float-left ultra-bold-text'>"+bj.get("blogger").toString()+"</b> <i" + 
									"								class='far fa-user float-right blogcontenticon'></i>" + 
									"						</button></a>" + 
									"						<button class='btn stylebuttonnocolor'>"+date+"</button>" + 
									"						<button class='btn stylebuttonnocolor'>" + 
									"							<b class='float-left ultra-bold-text'>"+bj.get("num_comments").toString()+" comments</b><i" + 
									"								class='far fa-comments float-right blogcontenticon'></i>" + 
									"						</button>" + 
									"					</div>" + 
									
									"					<div style=\"height: 600px;\"><div class='p20 pt0 pb20 text-blog-content text-primary'" + 
									"						style='height: 550px; overflow-y: scroll;'>" + 
									"						"+bj.get("post").toString().replaceAll("[^a-zA-Z]", " ")+""+ 
									"						</div></div>";
									
							
						}
						
						
						pww.write(output+"");
					}else if(source.equals("keywordtrend") && section.equals("detail_table")) {

						for (int p = 0; p < posts.size(); p++) {
							String bstr = posts.get(p).toString();
							JSONObject bj = new JSONObject(bstr);
							bstr = bj.get("_source").toString();
							bj = new JSONObject(bstr);
							//System.out.println(bj.get("body"));
							
							String mostactiveterm = (null==request.getParameter("term"))?"":request.getParameter("term").toString();
							String body = bj.get("post").toString().replaceAll("[^a-zA-Z]", " ");
							String title = bj.get("title").toString().replaceAll("[^a-zA-Z]", " ");
							String dat = bj.get("date").toString().substring(0,10);
							LocalDate datee = LocalDate.parse(dat);
							DateTimeFormatter dtf = DateTimeFormatter.ofPattern("MMM dd, yyyy");
							String date = dtf.format(datee);
							
							String replace = 	"<span style=background:red;color:#fff>"+mostactiveterm+"</span>";
							
							
							output+="<h5 class='text-primary p20 pt0 pb0'>#1: "+title.replaceAll(mostactiveterm,replace)+"</h5>" + 
									"					<div class='text-center mb20 mt20'>" + 
									"						<button class='btn stylebuttonblue'>" + 
									"							<b class='float-left ultra-bold-text'>"+bj.get("blogger").toString()+"</b> <i" + 
									"								class='far fa-user float-right blogcontenticon'></i>" + 
									"						</button>" + 
									"						<button class='btn stylebuttonnocolor'>"+date+"</button>" + 
									"						<button class='btn stylebuttonnocolor'>" + 
									"							<b class='float-left ultra-bold-text'>"+bj.get("num_comments").toString()+" comments</b><i" + 
									"								class='far fa-comments float-right blogcontenticon'></i>" + 
									"						</button>" + 
									"					</div>" + 
									
									"					<div style=\"height: 600px;\"><div class='p20 pt0 pb20 text-blog-content text-primary'" + 
									"						style='height: 550px; overflow-y: scroll;'>" + 
									"						"+body.replaceAll(mostactiveterm,replace)+""+ 
									"						</div></div>";
									
							
						}
						
						
						pww.write(output+"");
					}else if(source.equals("influence") && section.equals("influential_table")) {
						output+="<p>\r\n" + 
								"Influential Blog Posts of <b class=\"text-blue\">"+value+"</b> and <b\r\n" + 
								"					</p>\r\n" + 
								"					<table id=\"DataTables_Table_0_wrapper\" class=\"display\"\r\n" + 
								"						style=\"width: 100%\">\r\n" + 
								"						<thead>\r\n" + 
								"							<tr>\r\n" + 
								"								<th class=\"bold-text text-primary\">Post title</th>\r\n" + 
								"								<th class=\"bold-text text-primary\">Influence Score</th>\r\n" + 
								"\r\n" + 
								"\r\n" + 
								"		</tr>\r\n" + 
								"	</thead>\r\n" + 
								"<tbody>";
						for (int p = 0; p < posts.size(); p++) {
							String bstr = posts.get(p).toString();
							JSONObject bj = new JSONObject(bstr);
							bstr = bj.get("_source").toString();
							bj = new JSONObject(bstr);
							
							output+="<tr>\r\n" + 
									"	<td><a href=\"#\" class=\"blogpost_link\" id=\""+bj.get("blogpost_id")+"\" >#"+(p+1)+": "+bj.get("title")+"</a></td>\r\n" + 
									"	<td align=\"center\">"+bj.get("influence_score")+"</td>\r\n" + 
									"</tr>";
						}
						
						output+="</tbody></table>";
						pww.write(output+"");
					}
				}else {
					pww.write("No Post found");
				}	
			}catch(Exception e) {
				 pww.write("error"); 
			 }	
			
		}

	}
	
	private String mergeArrays(String[] arr1, String[] arr2){
		String bracketed_result = "";
		String[] merged = new String[arr1.length + arr2.length];
	    System.arraycopy(arr1, 0, merged, 0, arr1.length);
	    System.arraycopy(arr2, 0, merged, arr1.length, arr2.length);
	
	    Set<String> nodupes = new HashSet<String>();
	
	    for(int i=0;i<merged.length;i++){
	        nodupes.add(merged[i]);
	        bracketed_result+=merged[i].trim()+",";
	    }
	
	    String[] nodupesarray = new String[nodupes.size()];
	    int i = 0;
	    Iterator<String> it = nodupes.iterator();
	    while(it.hasNext()){
	        nodupesarray[i] = it.next();
	        
	        i++;
	    }
	
		    return bracketed_result.replaceAll(",$", "");
	}
	
	private String getDateTime() {
		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date = new Date();
		return dateFormat.format(date);
	}
	

	
}


