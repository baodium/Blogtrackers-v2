package util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL; 
import org.json.JSONObject;
import org.json.JSONArray;

import java.io.OutputStreamWriter;


import java.util.ArrayList;

public class Blogposts {

String base_url = "http://144.167.115.218:9200/test-migrate/";
String totalpost;		    
	   
public ArrayList _list(String order, String from) throws Exception {
	 ArrayList result = new ArrayList();
	 
	 JSONObject query = new JSONObject();
	 JSONObject param = new JSONObject();
	 
	
	 
	 JSONObject ord = new JSONObject();
	 JSONObject sortby =new JSONObject();
	
	 
	 param.put("match_all",new JSONObject());
	 
	 
	 ord.put("order", order);
	 
	 query.put("query", param);
	 sortby.put("date", ord);
	 
	 
	 query.put("sort", sortby);
	 //auth.put("passwordCredentials", cred);
	 //parent.put("auth", auth);
	 
	 //System.out.println(query.toString());
	 
	 
     String url = base_url+"_search?size=10";
     
     if(!from.equals("")) {
    	 int fr = (Integer.parseInt(from)-10);
    	 url = base_url+"_search?size=10&from="+from;
     }
     URL obj = new URL(url);
     HttpURLConnection con = (HttpURLConnection) obj.openConnection();
     
     con.setDoOutput(true);
     con.setDoInput(true);
     // optional default is GET
     //con.setRequestMethod("GET");
     
     con.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
     con.setRequestProperty("Accept", "application/json");
     con.setRequestMethod("POST");
     
     OutputStreamWriter wr = new OutputStreamWriter(con.getOutputStream());
     wr.write(query.toString());
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
	 ArrayList result = new ArrayList();
	 
	 JSONObject query = new JSONObject(); 
	 JSONObject jsonObj = new JSONObject("{\r\n" + 
	 		"  \"query\": {\r\n" + 
	 		"        \"query_string\" : {\r\n" + 
	 		"            \"fields\" : [\"title\",\"blogger\",\"post\"],\r\n" + 
	 		"            \"query\" : "+term+"\r\n" + 
	 		"        }\r\n" + 
	 		"  }\r\n" + 
	 		"}");
	 
	 
	
	 
    String url = base_url+"_search/";
    if(!from.equals("")) {
   	 url = base_url+"_search?size=10&from="+from;
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

public ArrayList _fetch(String ids) throws Exception {
	 ArrayList result = new ArrayList();
	 
	 JSONObject query = new JSONObject(); 
	 JSONObject jsonObj = new JSONObject("{\r\n" + 
	 		"  \"query\": {\r\n" + 
	 		"    \"constant_score\":{\r\n" + 
	 		"			\"filter\":{\r\n" + 
	 		"					\"terms\":{\r\n" + 
	 		"							\"blogpost_id\":[\""+ids+"\"]\r\n" + 
	 		"							}\r\n" + 
	 		"					}\r\n" + 
	 		"				}\r\n" + 
	 		"    }\r\n" + 
	 		"}");
	 
	 
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

}