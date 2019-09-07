package util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL; 
import org.json.JSONObject;

import authentication.DbConnection;

import org.json.JSONArray;

import java.io.OutputStreamWriter;


import java.util.ArrayList;
import java.util.HashMap;

public class Liwc {

	HashMap<String, String> hm = DbConnection.loadConstant();		

//	String base_url = hm.get("elasticIndex")+"liwc2/";
	String base_url = hm.get("elasticIndex")+"liwc/";

	String totalpost;		    

	public ArrayList _list(String order, String from, String sortby) throws Exception {	 
		 int size = 100;
		 int fr = 0;
		 JSONObject jsonObj = new JSONObject("{\r\n" + 
			 		"    \"query\": {\r\n" + 
			 		"        \"match_all\": {}\r\n" + 
			 		"    },\r\n" + 
			 		"	\"sort\":{\r\n" + 
			 		"		\""+sortby+"\":{\r\n" + 
			 		"			\"order\":\""+order+"\"\r\n" + 
			 		"			}\r\n" + 
			 		"		}\r\n" + 
			 		"}");
		 
		 if(!from.equals("")) {
			 fr = Integer.parseInt(from)*size;
			  jsonObj = new JSONObject("{\r\n" + 
				  		"    \"query\": {\r\n" + 
				  		"        \"match_all\": {}\r\n" + 
				  		"    },\r\n" + 	  		
		     			"  	\"from\":"+fr+"," + 
		     			"	\"size\":"+size+"," + 
		     			"   \"sort\":{\r\n" + 
		     			"		\""+sortby+"\":{\r\n" + 
		     			"			\"order\":\""+order+"\"\r\n" + 
		     			"			}\r\n" + 
		     			"		},\r\n" + 
		     			"}");
			 
		 }
		 	 
	     String url = base_url+"_search?size=100";
	     return this._getResult(url, jsonObj);
	}

	public String _getTotal() {
		return this.totalpost;
	}

	public ArrayList _searchByRange(String field,String greater, String less, JSONArray post_ids) throws Exception {
		
		String que="{\r\n" + 
				"  \"query\": {\r\n" + 
				"    \"bool\": {\r\n" + 
				"      \"must\": [\r\n" + 
				"        {\r\n" + 
				"		  \"constant_score\":{\r\n" + 
				"					\"filter\":{\r\n" + 
				"							\"terms\":{\r\n" + 
				"							\"blogpostid\":"+post_ids+"\r\n" + 
				"									}\r\n" + 
				"							}\r\n" + 
				"						}\r\n" + 
				"		},\r\n" + 
				"        {\r\n" + 
				"		  \"range\" : {\r\n" + 
				"            \""+field+"\" : {\r\n" + 
				"                \"gte\" : "+greater+",\r\n" + 
				"                \"lte\" : "+less+",\r\n" + 
				"				},\r\n" +
				"			}\r\n" + 
				"		}\r\n" + 
				"      ]\r\n" + 
				"    }\r\n" + 
				"  }\r\n" + 
				"}";
		JSONObject jsonObj = new JSONObject(que);
		String url = base_url+"_search";
		return this._getResult(url,jsonObj);
	}
	
	
	public String _searchRangeAggregate(String field,String greater, String less, JSONArray post_ids,String column) throws Exception {
		/*
		String pids = "";
		for(int y=0; y< post_ids.length(); y++) {
			if(y==post_ids.length()-1) {
				pids +=post_ids.get(y);
			}else {
				pids +=post_ids.get(y)+",";
			}
		}
		
		pids = "("+pids+")";
		ArrayList response =new ArrayList();
		DbConnection db = new DbConnection();
		String count = "0";
		try {
			response = db.queryJSON("SELECT sum("+column+") FROM liwc WHERE blogpostid IN "+pids+" AND "+field+">='"+greater+"' AND "+field+" <='"+less+"' ");
			if(response.size()>0){
			 	ArrayList hd = (ArrayList)response.get(0);
				count = hd.get(0).toString();
			}
		}catch(Exception e){
			return count;
		}
		
		
		return count;
		*/
		
		String que="{\r\n" + 
				"  \"query\": {\r\n" + 
				"    \"bool\": {\r\n" + 
				"      \"must\": [\r\n" + 
				"        {\r\n" + 
				"		  \"constant_score\":{\r\n" + 
				"					\"filter\":{\r\n" + 
				"							\"terms\":{\r\n" + 
				"							\"blogpostid\":"+post_ids+"\r\n" + 
				"									}\r\n" + 
				"							}\r\n" + 
				"						}\r\n" + 
				"		},\r\n" + 
				"        {\r\n" + 
				"		  \"range\" : {\r\n" + 
				"            \""+field+"\" : {\r\n" + 
				"                \"gte\" : "+greater+",\r\n" + 
				"                \"lte\" : "+less+",\r\n" + 
				"				},\r\n" +
				"			}\r\n" + 
				"		}\r\n" + 
				"      ]\r\n" + 
				"    }\r\n" + 
				"  },\r\n" + 
				"    \"aggs\" : {\r\n" + 
				"        \"total\" : { \"sum\" : { \"field\" : \""+column+"\" } }\r\n" + 
				"    }\r\n" + 
				"}";
	
	
		JSONObject jsonObj = new JSONObject(que);

		String url = base_url+"_search?size=1";
		return this._getAggregate(url,jsonObj);
		
	}

	
	public ArrayList _search(String term,String from) throws Exception {
		JSONObject jsonObj = new JSONObject("{\r\n" + 
				"  \"query\": {\r\n" + 
				"        \"query_string\" : {\r\n" + 
				"            \"fields\" : [\"blogsite_name\",\"blogsite_authors\"],\r\n" + 
				"            \"query\" : \""+term+"\"\r\n" + 
				"        }\r\n" + 
				"  },\r\n" + 
				"   \"sort\":{\r\n" + 
				"		\"blogsite_id\":{\r\n" + 
				"			\"order\":\"DESC\"\r\n" + 
				"			}\r\n" + 
				"		}\r\n" + 
				"}");


		String url = base_url+"_search?size=100";
		if(!from.equals("")) {
			jsonObj = new JSONObject("{\r\n" + 
					"  \"query\": {\r\n" + 
					"        \"query_string\" : {\r\n" + 
					"            \"fields\" : [\"blogsite_name\",\"blogsite_authors\"],\r\n" +
					"            \"query\" : \""+term+"\"\r\n" + 
					"        }\r\n" + 
					"  },\r\n" + 
					"   \"sort\":{\r\n" + 
					"		\"blogpost_id\":{\r\n" + 
					"			\"order\":\"DESC\"\r\n" + 
					"			}\r\n" + 
					"		},\r\n" + 
					" \"range\":{\r\n" + 
					"		\"blogpost_id\":{\r\n" + 
					"			\"lte\":\""+from+"\",\r\n" + 
					"			\"gte\":\""+0+"\"\r\n" + 
					"			}\r\n" + 
					"		}\r\n" + 
					"}");
		} 



		return this._getResult(url, jsonObj);
	}
	
	public ArrayList _getPosEmotion(String blogids) throws Exception {
		ArrayList result = new ArrayList();

		DbConnection db = new DbConnection();
		String count = "0";
		blogids = blogids.replaceAll(",$", "");
		blogids = blogids.replaceAll(", $", "");
		blogids = "("+blogids+")";
		System.out.println(blogids);
		
		try {
		// bad query too slow takes like 10 to 20 second on larger blogs
		 //result = db.query("SELECT SUM(posemo) FROM blogtrackers.liwc where blogpostid in (select blogpost_id from blogposts where blogsite_id in"+blogids+")");
		result = db.query("SELECT SUM(posemocount) FROM blogtrackers.blogsite_sentiments where blogsite_id in "+blogids);	
		
			
		}catch(Exception e){
		}
		return result;

	}
	
	public ArrayList _getNegEmotion(String blogids) throws Exception {
		ArrayList result = new ArrayList();

		DbConnection db = new DbConnection();
		String count = "0";
		blogids = blogids.replaceAll(",$", "");
		blogids = blogids.replaceAll(", $", "");
		blogids = "("+blogids+")";
		
		try {
		// bad query too slow takes like 10 to 20 second on larger blogs
		//result = db.query("SELECT SUM(negemo) FROM blogtrackers.liwc where blogpostid in (select blogpost_id from blogposts where blogsite_id in "+blogids+")");	
			result = db.query("SELECT SUM(negemocount) FROM blogtrackers.blogsite_sentiments where blogsite_id in "+blogids);	
			
		}catch(Exception e){
		}
		return result;

	}
	
	
	public String _getNegEmotionByBlogger(String blogger) throws Exception {
		ArrayList result = new ArrayList();

		DbConnection db = new DbConnection();
		String count = "0";
		
		try {
		result = db.query("SELECT SUM(negemo) FROM blogtrackers.liwc where blogpostid in (select blogpost_id from blogposts where blogger ='"+blogger+"')");		
			if(result.size()>0){
			 	ArrayList hd = (ArrayList)result.get(0);
				count = hd.get(0).toString();
			}
		}catch(Exception e){
		}
		return count;

	}
	
	public String _getPosEmotionByBlogger(String blogger) throws Exception {
		ArrayList result = new ArrayList();

		DbConnection db = new DbConnection();
		String count = "0";
		
		try {
		result = db.query("SELECT SUM(posemo) FROM blogtrackers.liwc where blogpostid in (select blogpost_id from blogposts where blogger ='"+blogger+"')");		
			if(result.size()>0){
			 	ArrayList hd = (ArrayList)result.get(0);
				count = hd.get(0).toString();
			}
		}catch(Exception e){
		}
		return count;

	}
	
	
	public String _getHighestPosSentiment() throws Exception {
		ArrayList result = new ArrayList();

		DbConnection db = new DbConnection();
		String count = "0";
		
		try {
		result = db.query("SELECT max(posemo) FROM blogger");		
			if(result.size()>0){
			 	ArrayList hd = (ArrayList)result.get(0);
				count = hd.get(0).toString();
			}
		}catch(Exception e){
		}
		return count;

	}
	
	
	public String _getLowestPosSentiment() throws Exception {
		ArrayList result = new ArrayList();

		DbConnection db = new DbConnection();
		String count = "0";
		
		try {
		result = db.query("SELECT min(posemo) FROM blogger");		
			if(result.size()>0){
			 	ArrayList hd = (ArrayList)result.get(0);
				count = hd.get(0).toString();
			}
		}catch(Exception e){
		}
		return count;

	}
	
	public String _getLowestNegSentiment() throws Exception {
		ArrayList result = new ArrayList();

		DbConnection db = new DbConnection();
		String count = "0";
		
		try {
		result = db.query("SELECT min(negemo) FROM blogger");		
			if(result.size()>0){
			 	ArrayList hd = (ArrayList)result.get(0);
				count = hd.get(0).toString();
			}
		}catch(Exception e){
		}
		return count;

	}

	public String _getHighestNegSentiment() throws Exception {
		ArrayList result = new ArrayList();

		DbConnection db = new DbConnection();
		String count = "0";
		
		try {
		result = db.query("SELECT max(negemo) FROM blogger");		
			if(result.size()>0){
			 	ArrayList hd = (ArrayList)result.get(0);
				count = hd.get(0).toString();
			}
		}catch(Exception e){
		}
		return count;

	}
	
	public ArrayList _fetch(String ids) throws Exception {
		ArrayList result = new ArrayList();
		String[] args = ids.split(",");

		JSONArray pars = new JSONArray(); 
		ArrayList<String> ar = new ArrayList<String>();	
		for(int i=0; i<args.length; i++){
			pars.put(args[i].replaceAll(" ", ""));
		}

		String arg2 = pars.toString();

		String que = "{\"query\": {\"constant_score\":{\"filter\":{\"terms\":{\"blogsiteid\":"+arg2+"}}}}}";

		JSONObject jsonObj = new JSONObject(que);
		String url = base_url+"_search";
		return this._getResult(url, jsonObj);

	}
	
	public String _getTotal(String url, JSONObject jsonObj) throws Exception {
		String total = "0";
		try {
		URL obj = new URL(url);
		HttpURLConnection con = (HttpURLConnection) obj.openConnection();

		con.setDoOutput(true);
		con.setDoInput(true);

		con.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
		con.setRequestProperty("Accept", "application/json");
		con.setRequestMethod("POST");

		OutputStreamWriter wr = new OutputStreamWriter(con.getOutputStream());
		wr.write(jsonObj.toString());
		wr.flush();

		//add request header
		//con.setRequestProperty("User-Agent", "Mozilla/5.0");
		int responseCode = con.getResponseCode();

		BufferedReader in = new BufferedReader(
				new InputStreamReader(con.getInputStream()));
		String inputLine;
		StringBuffer response = new StringBuffer();

		while ((inputLine = in.readLine()) != null) {
			response.append(inputLine);
		
		}
		in.close();

		JSONObject myResponse = new JSONObject(response.toString());
		ArrayList<String> list = new ArrayList<String>(); 
		//System.out.println(myResponse.get("hits"));
		if(null!=myResponse.get("hits")) {
			String res = myResponse.get("hits").toString();
			JSONObject myRes1 = new JSONObject(res);          
			total = myRes1.get("total").toString();              
		}
		}catch(Exception ex) {}
		return  total;
	}
	
	
	public String _getAggregate(String url, JSONObject jsonObj) throws Exception {
		String total = "0";
		try {
		URL obj = new URL(url);
		HttpURLConnection con = (HttpURLConnection) obj.openConnection();

		con.setDoOutput(true);
		con.setDoInput(true);

		con.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
		con.setRequestProperty("Accept", "application/json");
		con.setRequestMethod("POST");

		OutputStreamWriter wr = new OutputStreamWriter(con.getOutputStream());
		wr.write(jsonObj.toString());
		wr.flush();

		//add request header
		//con.setRequestProperty("User-Agent", "Mozilla/5.0");
		int responseCode = con.getResponseCode();

		BufferedReader in = new BufferedReader(
				new InputStreamReader(con.getInputStream()));
		String inputLine;
		StringBuffer response = new StringBuffer();

		while ((inputLine = in.readLine()) != null) {
			response.append(inputLine);
		
		}
		in.close();

		JSONObject myResponse = new JSONObject(response.toString());
		ArrayList<String> list = new ArrayList<String>(); 
		//System.out.println(myResponse.get("hits"));
		if(null!=myResponse.get("aggregations")) {
			String res = myResponse.get("aggregations").toString();
			JSONObject myRes1 = new JSONObject(res); 
			
			
			String res2 = myRes1.get("total").toString();
			
			JSONObject myRes2 = new JSONObject(res2);   
			total = myRes2.get("value").toString(); 
		}
		}catch(Exception ex) {}
		return  total;
	}
	
	
	

	public ArrayList _getResult(String url, JSONObject jsonObj) throws Exception {
		ArrayList<String> list = new ArrayList<String>(); 
		URL obj = new URL(url);
		HttpURLConnection con = (HttpURLConnection) obj.openConnection();

		con.setDoOutput(true);
		con.setDoInput(true);

		con.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
		con.setRequestProperty("Accept", "application/json");
		con.setRequestMethod("POST");

		OutputStreamWriter wr = new OutputStreamWriter(con.getOutputStream());
		wr.write(jsonObj.toString());
		wr.flush();

		// int responseCode = con.getResponseCode();

		BufferedReader in = new BufferedReader(
				new InputStreamReader(con.getInputStream()));
		String inputLine;
		StringBuffer response = new StringBuffer();

		while ((inputLine = in.readLine()) != null) {
			response.append(inputLine);
		}
		in.close();

		JSONObject myResponse = new JSONObject(response.toString());

		if(null!=myResponse.get("hits")) {
			String res = myResponse.get("hits").toString();
			JSONObject myRes1 = new JSONObject(res);	    
			JSONArray jsonArray = new JSONArray(myRes1.get("hits").toString()); 	     
			if (jsonArray != null) { 
				int len = jsonArray.length();
				for (int i=0;i<len;i++){ 
					list.add(jsonArray.get(i).toString());
				} 
			}
		}
		return  list;
	}

}