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

public class PostingFrequency {

	HashMap<String, String> hm = DbConnection.loadConstant();		
	
	String base_url = hm.get("elasticIndex")+"blogpost_entitysentiment/";
	String totalpost;
	   
public ArrayList _list(String order, String from) throws Exception {	 
	 JSONObject jsonObj = new JSONObject("{\r\n" + 
		 		"    \"query\": {\r\n" + 
		 		"        \"match_all\": {}\r\n" + 
		 		"    },\r\n" + 
		 		"	\"sort\":{\r\n" + 
		 		"		\"id\":{\r\n" + 
		 		"			\"order\":\""+order+"\"\r\n" + 
		 		"			}\r\n" + 
		 		"		}\r\n" + 
		 		"}");
	 
	 if(!from.equals("")) {
		  jsonObj = new JSONObject("{\r\n" + 
		  		"    \"query\": {\r\n" + 
		  		"        \"match_all\": {}\r\n" + 
		  		"    },\r\n" + 
		  		"	\"sort\":{\r\n" + 
		  		"		\"id\":{\r\n" + 
		  		"			\"order\":\"DESC\"\r\n" + 
		  		"			}\r\n" + 
		  		"		},\r\n" + 
		  		"	\"range\":{\r\n" + 
		  		"		\"id\":{\r\n" + 
		  		"			\"lte\":\""+from+"\",\r\n" + 
		  		"			\"gte\":\""+0+"\"\r\n" + 
		  		"			}\r\n" + 
		  		"		}\r\n" + 
		  		"}");
		 
	 }
	 
	 
     String url = base_url+"_search?size=50";
 
     
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
	      String total = myRes1.get("total").toString();
	      this.totalpost = total;
	    
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

public String _getTotal() {
	return this.totalpost;
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
	
	 
    String url = base_url+"_search?size=50";
    if(!from.equals("")) {
    	jsonObj = new JSONObject("{\r\n" + 
    			"  \"query\": {\r\n" + 
    			"        \"query_string\" : {\r\n" + 
	 		    "            \"fields\" : [\"entity\",\"type\"],\r\n" +
    			"            \"query\" : \""+term+"\"\r\n" + 
    			"        }\r\n" + 
    			"  },\r\n" + 
    			"   \"sort\":{\r\n" + 
    			"		\"id\":{\r\n" + 
    			"			\"order\":\"DESC\"\r\n" + 
    			"			}\r\n" + 
    			"		},\r\n" + 
    			" \"range\":{\r\n" + 
    			"		\"id\":{\r\n" + 
    			"			\"lte\":\""+from+"\",\r\n" + 
		  		"			\"gte\":\""+0+"\"\r\n" + 
    			"			}\r\n" + 
    			"		}\r\n" + 
    			"}");
    }
    
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
	     
	
	     
	      //String total = myRes1.get("total").toString();
	      //this.totalpost = total;
	    
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

public ArrayList _fetch(String ids) throws Exception {
	 ArrayList result = new ArrayList();
	 String[] args = ids.split(",");
	 String arg = "";
	 
	 
	 ArrayList<String> ar = new ArrayList<String>();	
	 for(int i=0; i<args.length; i++){
		
		if(i<(args.length-1)){
			arg+= "\""+args[i]+"\",";
		}else{
			arg+= "\""+args[i]+"\"";
		}
		
	 }
	 
	 String arg2 = "200";

	 //String que = "{\"query\": {\"constant_score\":{\"filter\":{\"terms\":{\"blogsite_id\":[\""+arg+"\"]}}}}}";
	 String que = "{\"query\": {\"constant_score\":{\"filter\":{\"terms\":{\"blogsite_id\":[\"259\",\"37\"]}}}}}";
		
	 JSONObject jsonObj = new JSONObject(que);
/*
	 
	 JSONObject jsonObj = new JSONObject("{\r\n" + 
	 		"  \"query\": {\r\n" + 
	 		"    \"constant_score\":{\r\n" + 
	 		"			\"filter\":{\r\n" + 
	 		"					\"terms\":{\r\n" + 
	 		"							\"blogsite_id\":[\"200\",\"500\"]\r\n" + 
	 		"							}\r\n" + 
	 		"					}\r\n" + 
	 		"				}\r\n" + 
	 		"    }\r\n" + 
	 		"}");

	 */
	// JSONObject jsonObj = new JSONObject(que);
/*
	 
	 JSONObject jsonObj = new JSONObject("{\r\n" + 
	 		"  \"query\": {\r\n" + 
	 		"    \"constant_score\":{\r\n" + 
	 		"			\"filter\":{\r\n" + 
	 		"					\"terms\":{\r\n" + 
	 		"							\"blogsite_id\":[\"200\",\"500\"]\r\n" + 
	 		"							}\r\n" + 
	 		"					}\r\n" + 
	 		"				}\r\n" + 
	 		"    }\r\n" + 
	 		"}");

	 */
	//System.out.println(arg);
   String url = base_url+"_search/";
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
    ArrayList<String> list = new ArrayList<String>(); 
    if(null!=myResponse.get("hits")) {
	     String res = myResponse.get("hits").toString();
	     JSONObject myRes1 = new JSONObject(res);
	    //  String total = myRes1.get("total").toString();
	     // this.totalpost = total;	    
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