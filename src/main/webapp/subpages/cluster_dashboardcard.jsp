<%@page import="java.io.PrintWriter"%>
<%@page import="authentication.*"%>
<%@page import="java.util.*"%>
<%@page import="util.*"%>
<%@page import="java.io.File"%>
<%@page import="util.Blogposts"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>


<%@page import="javafx.util.Pair"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
Object date_start = (null == request.getParameter("date_start")) ? "" : request.getParameter("date_start");
Object date_end = (null == request.getParameter("date_end")) ? "" : request.getParameter("date_end");
Object action = (null == request.getParameter("action")) ? "" : request.getParameter("action");
Object tid = (null == request.getParameter("tid")) ? "" : request.getParameter("tid");

PrintWriter out_ = response.getWriter();


Trackers tracker  = new Trackers();
Blogposts post  = new Blogposts();
Blogs blog  = new Blogs();

Terms term  = new Terms();

if(action.toString().equals("getkeywordstatus")){
	
	
	ArrayList details = DbConnection.query("select status, status_percentage from clusters where tid = " + tid);
	ArrayList res = (ArrayList)details.get(0);
	
	String status = res.get(0).toString();
	String status_percentage = res.get(1).toString();
	
	JSONObject final_result = new JSONObject();
	final_result.put("status_percentage",status_percentage);
	final_result.put("status",status);
	
	
	if(status.equals("1")){
		
		//start before
		/* ArrayList response_terms = DbConnection.query("select terms from clusters where tid = " + tid);
		ArrayList result = (ArrayList)response_terms.get(0);
		//System.out.println("terms_result" + res.get(0));
		
		JSONObject final_terms = new JSONObject(result.get(0).toString());
		final_result.put("final_terms",final_terms); */
		///end before
		
		//start clustering data gathering
			Clustering cluster = new Clustering();
				String tracker_id = tid.toString();
	//get postids from each cluster in tracker and save in JSONObject
	ArrayList result = cluster._getClusters(tracker_id);
	System.out.println("done with clusters");
	JSONObject final_centroids = new JSONObject();
	JSONObject source = new JSONObject();
try{
	JSONObject ress = new JSONObject(result.get(0).toString());
	System.out.println("done with res");
	
	
	source = new JSONObject(ress.get("_source").toString());
	
	HashMap<Pair<String, String>, ArrayList<JSONObject>> clusterResult = new HashMap<Pair<String, String>, ArrayList<JSONObject>>();

	Pair<String, String> key_val = new Pair<String, String>(null, null);

	HashMap<String, String> key_val_posts = new HashMap<String, String>();
	ArrayList<JSONObject> scatterplotfinaldata = new ArrayList<JSONObject>();
	
	JSONObject distances = new JSONObject();
	HashMap<String, String> topterms = new HashMap<String, String>();
			String find = "";
	int [][] termsMatrix = new int[10][10];
	//int count = 0;
	JSONArray links_centroids = new JSONArray();
	JSONArray nodes_centroids = new JSONArray();
	//start main foor loop
	for (int i = 1; i < 11; i++) {

		String cluster_ = "cluster_" + String.valueOf(i);
		String centroids = "C" + String.valueOf(i) + "xy";
		JSONObject cluster_data = new JSONObject(source.get(cluster_).toString());
		
		String post_ids = cluster_data.get("post_ids").toString();
	
		String centroid = source.get(centroids).toString().replace("[", "").replace("]", "");
		String centroid_x = centroid.split(",")[0].trim();
		String centroid_y = centroid.split(",")[1].trim();
		
		JSONObject data_centroids_ = new JSONObject();
		
		data_centroids_.put("id","Cluster_" + i);
	   	data_centroids_.put("group", i);
	   	data_centroids_.put("label","CLUSTER_" + i);
	   	data_centroids_.put("level",post_ids.split(",").length);
	
	   	nodes_centroids.put(data_centroids_);
		
		for(int k = 1; k < 11; k++){
			if(k != i){
				String centroids_ = "C" + String.valueOf(k) + "xy";
				String centroid_ = source.get(centroids_).toString().replace("[", "").replace("]", "");
				String centroid_x_ = centroid_.split(",")[0].trim();
				String centroid_y_ = centroid_.split(",")[1].trim();
				
				JSONObject data_centroids = new JSONObject();
				data_centroids.put("target","Cluster_" + i);
				data_centroids.put("source","Cluster_" + k);
				
				double left_ = Math.pow((double)Double.parseDouble(centroid_x_) - (double)Double.parseDouble(centroid_x), 2);
				double right_ = Math.pow((double)Double.parseDouble(centroid_y_) - (double)Double.parseDouble(centroid_y), 2);
				String distance_ = String.valueOf(Math.pow((left_ + right_), 0.5));
				 
				data_centroids.put("strength", 50 - Double.parseDouble(distance_));
				links_centroids.put(data_centroids);
				
			}
			
		}
		
		JSONObject svd_ = new JSONObject(source.get("svd").toString());
		
		int counter = 0;
		String [] post_split = post_ids.split(",");
		
		for(int j = 0; j < post_split.length; j++){
			
			
			
			JSONObject scatter_plot = new JSONObject();
			String p_id = post_split[j];
			Object x_y = svd_.get(p_id);
					
			x_y = x_y.toString().replace("[","").replace("]","").trim().replaceAll("\\s+", " ");
			
			String x = x_y.toString().split(" ")[0];
			String y = x_y.toString().split(" ")[1];
			
			String postid = p_id.toString();
			
			scatter_plot.put("cluster",String.valueOf(i));
			
			scatter_plot.put("",String.valueOf(counter));
			scatter_plot.put("new_x",x);
			scatter_plot.put("new_y",y);
			counter++;
			
			double left = Math.pow((double)Double.parseDouble(x) - (double)Double.parseDouble(centroid_x), 2);
			double right = Math.pow((double)Double.parseDouble(y) - (double)Double.parseDouble(centroid_y), 2);
			String distance = String.valueOf(Math.pow((left + right), 0.5));
			distances.put(postid, distance); 
			scatterplotfinaldata.add(scatter_plot);
			
		}
		
		ArrayList<JSONObject> postDataAll = DbConnection.queryJSON("select date,post,num_comments, blogger,permalink, title, blogpost_id, location, blogsite_id from blogposts where blogpost_id in ("+post_ids+") limit 500" );
		System.out.println("done with query --");
		
		String terms = cluster_data.get("topterms").toString();
		String str1 = null;
		str1 = terms.replace("),", "-").replace("(", "").replace(")", "").replaceAll("[0-9]","").replace("-", "");
		List<String> t1 = Arrays.asList(str1.replace("[","").replace("]","").split(","));
		termsMatrix[i - 1][i - 1] = t1.size();
		
		//CREATING CHORD MATRIX
		
		String str2 = null;
		
		for(int k = (i + 1); k < 11; k++)
		{
		String cluster_matrix  = "cluster_" + String.valueOf(k);
		JSONObject cluster_data_matrix = new JSONObject(source.get(cluster_matrix).toString());
		String terms_matrix = cluster_data_matrix.get("topterms").toString();
		
		str2 = terms_matrix.replace("),", "-").replace("(", "").replace(")", "").replaceAll("[0-9]","").replace("-", "");
	
		List<String> t2 = Arrays.asList(str2.replace("[","").replace("]","").split(","));
	
		int count = 0;
		for (int i_ = 0; i_ < t1.size(); i_++)
        {
            for (int j_ = 0; j_ < t2.size(); j_++)
            {
                if(t1.get(i_).contentEquals(t2.get(j_)))
                {
                 
                 count ++;
                 }
            }
        }
		
		termsMatrix[i-1][k-1] = count;
		termsMatrix[k-1][i-1] = count;
		 }
		//DONE CREATING CHORD MATRIX
		
		topterms.put(cluster_,terms);
		
		key_val = new Pair<String, String>(cluster_, post_ids);
		
		key_val_posts.put(cluster_, post_ids);
		
		clusterResult.put(key_val, postDataAll);
		
		

	}
//end main for loop

	
	
	final_centroids.put("nodes",nodes_centroids);
	final_centroids.put("links",links_centroids);
			
		
	final_result.put("final_terms",final_centroids);
			//end clustering data ghathering
}catch (Exception e){
	
}
//end try catch		
		
	}else if(status.equals("0")){
		
		
		final_result.put("final_terms","");
	}
%>
	
<%=final_result.toString()%>
	
<% } %>	