<%@page import="authentication.*"%>
<%@page import="java.util.*"%>
<%@page import="util.*"%>
<%@page import="java.io.File"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.net.URI"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="javafx.util.Pair"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	Object action = (null == session.getAttribute("action")) ? "" : session.getAttribute("action");
	Object cluster = (null == request.getParameter("cluster_number")) ? "" : request.getParameter("cluster_number");
	//Object cluster = (null == request.getParameter("cluster")) ? "" : request.getParameter("cluster");

	Object tid = (null == request.getParameter("tid")) ? "" : request.getParameter("tid");
	Object distances = (null == session.getAttribute(tid.toString() + "cluster_distances")) ? ""
			: session.getAttribute(tid.toString() + "cluster_distances");
	Object result_key_val = (null == session.getAttribute(tid.toString() + "cluster_result_key_val")) ? ""
			: session.getAttribute(tid.toString() + "cluster_result_key_val");
	
	
	
	ArrayList<JSONObject> postData = new ArrayList<JSONObject>();
	Pair<String, String> key_val = new Pair<String, String>(null, null);
	String cluster_ = "cluster_"+cluster.toString();
	
	HashMap<String, String> key_val_posts = (HashMap<String, String>) result_key_val;
	String post_ids = key_val_posts.get(cluster_);
	
	

	key_val = new Pair<String, String>(cluster_, post_ids);
	
	
	Object result = (null == session.getAttribute(tid.toString() + "cluster_result")) ? ""
			: session.getAttribute(tid.toString() + "cluster_result");
	HashMap<Pair<String, String>, ArrayList<JSONObject>> clusterResult = (HashMap<Pair<String, String>, ArrayList<JSONObject>>) result;
	
	
	postData = clusterResult.get(key_val);
	
	JSONObject post_distances_all = new JSONObject();
	//post_distances_all.put("distances", new JSONObject(distances.toString()));
	//post_distances_all.put("post_data", new JSONArray(postData.toString()));
	//out.write(post_distances_all.toString());
	
	
	//System.out.println("ppp----"+cluster+"ppp"+post_distances_all.toString());
	System.out.println("ppp----"+cluster+"ppp"+tid.toString()+"ppp22"+post_distances_all.length());
	
	String selectedblog_id="";
	
	JSONArray nodes = new JSONArray();
	JSONArray links = new JSONArray();
	
	JSONObject center = new JSONObject();
	center.put("id", "center");
	center.put("group", 0);
	center.put("label", "center".toUpperCase());
	center.put("level", 1);
	nodes.put(center);
	
	String [] post_split = post_ids.split(",");
	//for(int i = 0; i < post_split.length; i++){
		for(int i = 0; i < 1000; i++){
			
		if(i < post_split.length){
		String p = post_split[i];
		JSONObject data = new JSONObject();
		
		data.put("id", p);
		data.put("group", cluster);
		data.put("label", cluster.toString().toUpperCase());
		data.put("level", 1);
		
		nodes.put(data);
		}
	}
	
	JSONObject d = new JSONObject(distances.toString());
	//for(int i = 0; i < post_split.length; i++){
		for(int i = 0; i < 1000; i++){
			if(i < post_split.length){
		String p = post_split[i];
		JSONObject data = new JSONObject();
		
		data.put("target", "center");
		data.put("source", p);
		data.put("strength", 50 - Double.parseDouble(d.get(p).toString()));
		
		
		links.put(data);
			}
	}
	
	JSONObject final_data = new JSONObject();
	final_data.put("nodes", nodes);
	final_data.put("links", links);
	JSONObject final_result = new JSONObject();
	final_result.put("final_data",final_data);
	final_result.put("cluster_id",cluster);

%>
<%=final_result %>