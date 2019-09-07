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

public class Outlinks {

	HashMap<String, String> hm = DbConnection.loadConstant();		
	
	String base_url = hm.get("elasticIndex")+"outlinks/";
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
	 
	 
     String url = base_url+"_search?size=20";
     return this._getResult(url, jsonObj);   
    }

public String _getTotal() {
	return this.totalpost;
}

public ArrayList _searchByRange(String field,String greater, String less, String blog_ids) throws Exception {
	 blog_ids = blog_ids.replaceAll(",$", "");
	 blog_ids = blog_ids.replaceAll(", $", "");
  
	 
	 String[] args = blog_ids.split(","); 
	 JSONArray pars = new JSONArray(); 
	 ArrayList<String> ar = new ArrayList<String>();	
	 for(int i=0; i<args.length; i++){
		 pars.put(args[i].replaceAll(" ", ""));
	 }
	 
	 String arg2 = pars.toString();
	 String que ="{\r\n" + 
		 		"	\"size\":1000,\r\n" + 
		 		"	\r\n" + 
		 		"	\"query\": { \r\n" + 
		 		"			 \"bool\": {\r\n" + 
		 		"				      \"must\": [\r\n" + 
		 		"				      	{\r\n" + 
		 		"						  \"constant_score\":{ \r\n" + 
		 		"									\"filter\":{ \r\n" + 
		 		"											\"terms\":{ \r\n" + 
		 		"												\r\n" + 
		 		"											\"blogsite_id\":"+arg2+"\r\n"+
		 		"													}\r\n" + 
		 		"											}\r\n" + 
		 		"										} \r\n" + 
		 		"						}, \r\n" + 
		 		"	 		        { \r\n" + 
		 		"	 				  \"range\" : { \r\n" + 
		 		"	 		            \"date\" : { \r\n" + 
		 		"	 		                \"gte\" : "+greater+",\r\n"+
		 		"	 		                \"lte\" : "+less+"\r\n" + 
		 		"	 						}\r\n" + 
		 		"	 					} \r\n" + 
		 		"	 				} \r\n" + 
		 		"	 		      ] \r\n" + 
		 		"	 		    } \r\n" + 
		 		"	 		  }, \r\n" + 
		 		 
		 		"   		\"sort\":{\r\n" + 
		 		"						\"date\":{\r\n" + 
		 		"						\"order\":\"DESC\"\r\n" + 
		 		"					}\r\n" + 
		 		"				}\r\n" + 
		 		"	 		}";

//	 String que="{\r\n" + 
//	 		"  \"query\": {\r\n" + 
//	 		"    \"bool\": {\r\n" + 
//	 		"      \"must\": [\r\n" + 
//	 		"        {\r\n" + 
//	 		"		  \"constant_score\":{\r\n" + 
//	 		"					\"filter\":{\r\n" + 
//	 		"							\"terms\":{\r\n" + 
//		 	"							\"blogsite_id\":"+arg2+"\r\n" + 
//	 		"									}\r\n" + 
//	 		"							}\r\n" + 
//	 		"						}\r\n" + 
//	 		"		},\r\n" + 
//	 		"        {\r\n" + 
//	 		"		  \"range\" : {\r\n" + 
//	 		"            \""+field+"\" : {\r\n" + 
//	 		"                \"gte\" : "+greater+",\r\n" + 
//	 		"                \"lte\" : "+less+",\r\n" + 
//	 		"				},\r\n" +
//	 		"			}\r\n" + 
//	 		"		}\r\n" + 
//	 		"      ]\r\n" + 
//	 		"    }\r\n" + 
//	 		"  }\r\n" + 
//	 		"}";
//	 
	 
	JSONObject jsonObj = new JSONObject(que);
	 
    String url = base_url+"_search";
    return this._getResult(url,jsonObj);
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
	
	 
    String url = base_url+"_search?size=20";
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

public ArrayList _fetch(String ids) throws Exception {
	 ArrayList result = new ArrayList();
	 String[] args = ids.split(",");
	 
	 JSONArray pars = new JSONArray(); 
	 ArrayList<String> ar = new ArrayList<String>();	
	 for(int i=0; i<args.length; i++){
		 pars.put(args[i].replaceAll(" ", ""));
	 }
	 
	 String arg2 = pars.toString();

	// String que = "{\"query\": {\"constant_score\":{\"filter\":{\"terms\":{\"blogsiteid\":"+arg2+"}}}}}";
	 String que = "{\"query\": {\"constant_score\":{\"filter\":{\"terms\":{\"blogsite_id\":"+arg2+"}}}},\"sort\":{\"frequency\":{\"order\":\"DESC\"}}}";

		
	JSONObject jsonObj = new JSONObject(que);
	String url = base_url+"_search";
	return this._getResult(url, jsonObj);
	   
}



public ArrayList _getResult(String url, JSONObject jsonObj) throws Exception {
	
	   ArrayList<String> list = new ArrayList<String>(); 
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
	}catch(Exception ex) {}
	   return  list;
}

}