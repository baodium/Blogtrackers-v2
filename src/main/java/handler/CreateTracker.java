package handler;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;

import authentication.DbConnection;
import util.Trackers;

/**
 * Servlet implementation class CreateTracker
 */
@WebServlet("/api/create")
public class CreateTracker extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CreateTracker() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}
	

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 * @ params
	 * 
	 String trackerName
	 String description 
	 String blogs //blog ids
	 String userid 
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		String usession = (null==request.getHeader("session"))?"":request.getHeader("session").trim();
		String key= (null == session.getAttribute("key")) ? "" : session.getAttribute("key").toString();
		String userid= (null == session.getAttribute("userid")) ? "" : session.getAttribute("userid").toString();
		JSONArray tracker_names = null;
		PrintWriter pww = response.getWriter();

		String data = "";   
	    StringBuilder builder = new StringBuilder();
	    BufferedReader reader = request.getReader();
	    String line;
	    while ((line = reader.readLine()) != null) {
	        builder.append(line);
	    }
	    data = builder.toString();
	    JSONObject object = null;
/*
	    pww.write(userid);*/
	    try {
	    	object = new JSONObject(data);	
	    	 tracker_names = object.getJSONArray("tracker_name");
	    	
	    	for(int i =0; i < tracker_names.length(); i++) {
	    		pww.write(tracker_names.getString(i));
	    	}
	    	
	    }catch (Exception e) {
			// TODO: handle exception
	    	e.printStackTrace();
		}
	    
	    if(usession.equals(key) && !key.equals("")){ //check if supplied session key is valid
			pww.write("\n Validated the user session \n");

	    pww.write("The userid is "+userid);
	    
	    try {
	    	object = new JSONObject(data);

	    	for(int i =0; i < tracker_names.length(); i++) {
	    		
	    		insertToDB(userid, tracker_names.getString(i));
	    
	    	}
	    }catch (Exception e) {
	    	pww.write("error");
		}

	    //ArrayList prev = new DbConnection().query("SELECT * FROM trackers WHERE tracker_name='"+trackerName+"' AND userid= '"+userid+"'");
	    }
	}
	public void insertToDB(String userid, String tracker_names) {
		ArrayList prev = DbConnection.query("SELECT * FROM trackers WHERE tracker_name='"+tracker_names+"'");
		String output = "false";
		String blogsites = "blogsite_id in ()";
		LocalDateTime now = LocalDateTime.now();
		if(prev!=null && prev.size()>0) {
			output = "Tracker name already exists";
		}else {	
			String query="INSERT INTO trackers(userid,tracker_name,date_created,date_modified,query,description,blogsites_num) VALUES('"+userid+"', '"+tracker_names+"', '"+now+"', '"+now+"', '"+blogsites+"', '"+null+"', 0)";
			boolean done = new DbConnection().updateTable(query);
			if(done) {
			  	output = "Tracker successfully created";
			  	System.out.println(output);
			}else {
				output = "Tracker creation failed";
				System.out.println(output);
			}
		}
		System.out.println(userid+" "+tracker_names);
	}

}
