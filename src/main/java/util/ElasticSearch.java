package util;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;

import org.apache.http.HttpHost;
import org.apache.http.util.EntityUtils;
import org.elasticsearch.action.search.*;
import org.elasticsearch.client.*;
import org.json.*;

public class ElasticSearch {
	public static void _getBloggerPosts(String url, JSONObject query) throws Exception {
	    
		ArrayList<String> list = new ArrayList<String>();
		
		RestClient esClient = RestClient.builder(new HttpHost("144.167.115.90", 9200, "http")).build();
		RestHighLevelClient client = new RestHighLevelClient(
				RestClient.builder(new HttpHost("144.167.115.90", 9200, "http")));
		Request request = new Request("POST", "/blogposts/_search/?scroll=1d");
		request.setJsonEntity(query.toString());
		Response response = esClient.performRequest(request);
		String source = null;
		String result = null;
		JSONArray jsonArray = null;
		String jsonResponse = EntityUtils.toString(response.getEntity());
		
		
		JSONObject myResponse = new JSONObject(jsonResponse);
		
		if (null != myResponse.get("hits")) {
				Object hits = myResponse.getJSONObject("hits").getJSONArray("hits");
				System.out.print(hits.toString());
				Object total = myResponse.getJSONObject("hits").getJSONObject("total").get("value");
				System.out.println(total);
				JSONObject myRes1 = new JSONObject(hits);
				source = hits.toString();
				jsonArray = new JSONArray(source);
				
				if (jsonArray != null) {
					for (int i = 0; i < jsonArray.length(); i++) {
						String indx = jsonArray.get(i).toString();
						JSONObject j = new JSONObject(indx);
						String ids = j.get("_source").toString();
						j = new JSONObject(ids);
						String src = j.get("post").toString();
						list.add(src);
					}
					
					result = String.join(" ", list);
				}
			
		}
		esClient.close();
		client.close();
		result = escape(result);

}
	public static String escape(String s) {
		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < s.length(); i++) {
			char c = s.charAt(i);
			// These characters are part of the query syntax and must be escaped
			if (c == '\\' || c == '\"' || c == '/') {
				sb.append('\\');
			}
			sb.append(c);
		}
		return sb.toString();
	}

	private static String totalpost;
	
	public static ArrayList _getResult(String url, JSONObject jsonObj) throws Exception {
		ArrayList<String> list = new ArrayList<String>();
		try {
		URL obj = new URL(url);
	    HttpURLConnection con = (HttpURLConnection) obj.openConnection();
	    
	    con.setDoOutput(true);
	    con.setDoInput(true);
	   
	    con.setRequestProperty("Content-Type", "application/json; charset=utf-32");
	    con.setRequestProperty("Content-Type", "application/json");
	    con.setRequestProperty("Accept-Charset", "UTF-32");
	    con.setRequestProperty("Accept", "application/json");
	    con.setRequestMethod("POST");
	    
	    DataOutputStream wr = new DataOutputStream(con.getOutputStream());
	    
	    
	    
	    //OutputStreamWriter wr1 = new OutputStreamWriter(con.getOutputStream());
	    wr.write(jsonObj.toString().getBytes());
	    wr.flush();
	    
	    int responseCode = con.getResponseCode();  
	    BufferedReader in = new BufferedReader(
	         new InputStreamReader(con.getInputStream()));
	    String inputLine;
	    StringBuffer response = new StringBuffer();
	    
	    while ((inputLine = in.readLine()) != null) {
	     	response.append(inputLine);
	     	//System.out.println(inputLine);
	     	
	     }
	     in.close();
	     
	     JSONObject myResponse = new JSONObject(response.toString());
	    
	     if(null!=myResponse.get("hits")) {
		     String res = myResponse.get("hits").toString();
		     JSONObject myRes1 = new JSONObject(res);
		      String total = myRes1.get("total").toString();
		      JSONObject totalTmp = new JSONObject(total);
		      totalpost = totalTmp.get("value").toString();
		      
		 
		    
		     JSONArray jsonArray = new JSONArray(myRes1.get("hits").toString()); 
		     
		     if (jsonArray != null) { 
		        int len = jsonArray.length();
		        for (int i=0;i<len;i++){ 
		         list.add(jsonArray.get(i).toString());
		        } 
		     }
	     }
		}catch(Exception ex) {}
		
	     return list;
	     
	}
	public static String _getTotal(String url) {
		ArrayList<String> list = new ArrayList<String>();
		try {
		URL obj = new URL(url);
	    HttpURLConnection con = (HttpURLConnection) obj.openConnection();
	    
	    con.setDoOutput(true);
	    con.setDoInput(true);
	   
	    con.setRequestProperty("Content-Type", "application/json; charset=utf-32");
	    con.setRequestProperty("Content-Type", "application/json");
	    con.setRequestProperty("Accept-Charset", "UTF-32");
	    con.setRequestProperty("Accept", "application/json");
	    con.setRequestMethod("POST");
	    
	    DataOutputStream wr = new DataOutputStream(con.getOutputStream());
	   
	    
	    int responseCode = con.getResponseCode();  
	    BufferedReader in = new BufferedReader(
	         new InputStreamReader(con.getInputStream()));
	    String inputLine;
	    StringBuffer response = new StringBuffer();
	    
	    while ((inputLine = in.readLine()) != null) {
	     	response.append(inputLine);
	     	//System.out.println(inputLine);
	     	
	     }
	     in.close();
	     
	     JSONObject myResponse = new JSONObject(response.toString());
	    
	     if(null!=myResponse.get("hits")) {
		     String res = myResponse.get("hits").toString();
		     return res;
		    // System.out.println(res);
		     /*JSONObject myRes1 = new JSONObject(res);
		      String total = myRes1.get("total").toString();
		      JSONObject totalTmp = new JSONObject(total);
		      totalpost = totalTmp.get("value").toString();
		      
		 
		    
		     JSONArray jsonArray = new JSONArray(myRes1.get("hits").toString()); 
		     
		     if (jsonArray != null) { 
		        int len = jsonArray.length();
		        for (int i=0;i<len;i++){ 
		         list.add(jsonArray.get(i).toString());
		        } 
		     }*/
	     }
		}catch(Exception ex) {}
		return url;
	
	     
	
	}

	
	public static void main(String[] args) {
		System.out.println("Make call");
		try {
			JSONObject obj = new JSONObject("{\n" + 
					"	\"query\":{\n" + 
					"		\"match_all\":{}\n" + 
					"	}\n" + 
					"	\n" + 
					"}");
			ArrayList something = new ArrayList<>();
			something = _getResult("http://144.167.115.90:9200/blogposts/_search",obj);
			/*for(int i = 0; i < something.size(); i++) {
				JSONObject resu = new JSONObject(something.get(i));
				System.out.println(resu);
			}*/
			System.out.println(something);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
}
