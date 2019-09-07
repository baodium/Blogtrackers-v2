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
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;

public class Terms {

	HashMap<String, String> hm = DbConnection.loadConstant();		
	
	String base_url = hm.get("elasticIndex")+"terms/";
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
	 
	 
     String url = base_url+"_search?size=1000";
     return this._getResult(url, jsonObj);   
    }

public String _getTotal() {
	return this.totalpost;
}

public ArrayList _searchByRange(String field,String greater, String less, ArrayList blog_ids) throws Exception {

  /*
	blog_ids = blog_ids.replaceAll(",$", "");
	blog_ids = blog_ids.replaceAll(", $", "");
	blog_ids = "("+blog_ids+")";
	int size = 20;
	ArrayList response =new ArrayList();
	DbConnection db = new DbConnection();
	
	System.out.println("SELECT term,frequency,date,blogpostid,id,blogsiteid FROM terms WHERE blogsiteid IN "+blog_ids+" AND date>='"+greater+"' AND date <='"+less+"' GROUP BY(term) ORDER BY frequency DESC LIMIT "+size+"");
	
	try {
		//response = db.queryJSON("SELECT term,frequency,date,blogpostid,id,blogsiteid FROM terms WHERE blogsiteid IN "+blog_ids+" AND date>='"+greater+"' AND date <='"+less+"' GROUP BY(term) ORDER BY frequency DESC LIMIT "+size+"");
		response = db.queryJSON("SELECT term,frequency,date,blogpostid,id,blogsiteid FROM terms WHERE blogsiteid IN "+blog_ids+" GROUP BY(term) ORDER BY frequency DESC LIMIT "+size+"");
		 
		
	}catch(Exception e){
		return response;
	}
	
	
	return response;
	*/
	

	
	 //System.out.println("post wale id "+blog_ids);
		JSONObject jsonObj  = new JSONObject("{\r\n" + 
		 		"	\"size\":1000,\r\n" +
				"       \"query\": {\r\n" + 
				"          \"bool\": { \r\n" + 
				"               \"must\": {\r\n" + 
		 		"						  \"constant_score\":{ \r\n" + 
		 		"									\"filter\":{ \r\n" + 
		 		"											\"terms\":{ \r\n" + 
		 		"											\""+field+"\":"+blog_ids+"\r\n"+
		 		"													}\r\n" + 
		 		"											}\r\n" + 
		 		"										} \r\n" + 
				"                },\r\n" + 
				"                \"filter\": {\r\n" + 
				"                    \"range\" : {\r\n" + 
				"                        \"date\" : {\r\n" + 
				"                            \"gte\": \""+greater+"\",\r\n" + 
				"                            \"lte\": \""+less+"\"\r\n" + 
				"                        }\r\n" + 
				"                    }\r\n" + 
				"                }\r\n" + 
				"            }\r\n" + 
				"        },\r\n" +  
		 		"   	\"sort\":{\r\n" + 
		 		"		\"frequency\":{\r\n" + 
		 		"			\"order\":\"DESC\"\r\n" + 
		 		"			}\r\n" + 
		 		"		}\r\n" + /*
				"    	\"aggregations\": {\r\n" + 
		 		"        	\"term\": {\r\n" + 
		 		"            \"terms\": {\r\n" + 
		 		"                \"field\": \"term\"\r\n" +
		 		"            }\r\n" + 
		 		"        	}\r\n" + 
		 		"    	}\r\n"+ */
				"    }");
		
		
	//jsonObj = new JSONObject(que3);
    String url = base_url+"_search";
    return this._getResult(url,jsonObj);
  
}

public ArrayList _getBloggerTermById(String field,String greater, String less, String blog_ids) throws Exception {
	blog_ids = blog_ids.replaceAll(",$", "");
	blog_ids = blog_ids.replaceAll(", $", "");
 
	
	String[] args = blog_ids.split(","); 

	
	 JSONArray pars = new JSONArray(); 
	 ArrayList<String> ar = new ArrayList<String>();	
	 for(int i=0; i<args.length; i++){
		 pars.put(args[i].replaceAll(" ", ""));
	 }
	 String arg2 = pars.toString();
		JSONObject jsonObj  = new JSONObject("{\r\n" + 
		 		"	\"size\":20,\r\n" +
				"       \"query\": {\r\n" + 
				"          \"bool\": { \r\n" + 
				"               \"must\": {\r\n" + 
		 		"						  \"constant_score\":{ \r\n" + 
		 		"									\"filter\":{ \r\n" + 
		 		"											\"terms\":{ \r\n" + 
		 		"											\""+field+"\":"+arg2+"\r\n"+
		 		"													}\r\n" + 
		 		"											}\r\n" + 
		 		"										} \r\n" + 
				"                },\r\n" + 
				"                \"filter\": {\r\n" + 
				"                    \"range\" : {\r\n" + 
				"                        \"date\" : {\r\n" + 
				"                            \"gte\": \""+greater+"\",\r\n" + 
				"                            \"lte\": \""+less+"\"\r\n" + 
				"                        }\r\n" + 
				"                    }\r\n" + 
				"                }\r\n" + 
				"            }\r\n" + 
				"        },\r\n" +  
		 		"   	\"sort\":{\r\n" + 
		 		"		\"frequency\":{\r\n" + 
		 		"			\"order\":\"DESC\"\r\n" + 
		 		"			}\r\n" + 
		 		"		}\r\n" + /*
				"    	\"aggregations\": {\r\n" + 
		 		"        	\"term\": {\r\n" + 
		 		"            \"terms\": {\r\n" + 
		 		"                \"field\": \"term\"\r\n" +
		 		"            }\r\n" + 
		 		"        	}\r\n" + 
		 		"    	}\r\n"+ */
				"    }");
		
		
	//jsonObj = new JSONObject(que3);
    String url = base_url+"_search";
    return this._getResult(url,jsonObj);
  
}

public ArrayList _searchByRange(String field,String greater, String less, String blog_ids) throws Exception {
	blog_ids = blog_ids.replaceAll(",$", "");
	blog_ids = blog_ids.replaceAll(", $", "");
 
	/*
	blog_ids = "("+blog_ids+")";
	int size = 20;
	ArrayList response =new ArrayList();
	
	DbConnection db = new DbConnection();
	
	System.out.println("SELECT term,frequency,date,blogpostid,id,blogsiteid FROM terms WHERE blogsiteid IN "+blog_ids+" AND date>='"+greater+"' AND date <='"+less+"' GROUP BY(term) ORDER BY frequency DESC LIMIT "+size+"");
	
	try {
		//response = db.queryJSON("SELECT term,frequency,date,blogpostid,id,blogsiteid FROM terms WHERE blogsiteid IN "+blog_ids+" AND date>='"+greater+"' AND date <='"+less+"' GROUP BY(term) ORDER BY frequency DESC LIMIT "+size+"");
		//response = db.queryJSON("SELECT term,frequency,date,blogpostid,id,blogsiteid FROM terms WHERE blogsiteid IN "+blog_ids+" GROUP BY(term) ORDER BY frequency DESC LIMIT "+size+"");
		response = db.queryJSON("SELECT term,frequency,date,blogpostid,id,blogsiteid FROM terms WHERE blogsiteid IN "+blog_ids+" AND date>='"+greater+"' AND date <='"+less+"' ORDER BY frequency DESC LIMIT "+size+"");
		 
		
	}catch(Exception e){
		return response;
	}
	
	
	return response;
	
	*/
	
	String[] args = blog_ids.split(","); 
	//System.out.println(args);
	
	 JSONArray pars = new JSONArray(); 
	 ArrayList<String> ar = new ArrayList<String>();	
	 for(int i=0; i<args.length; i++){
		 pars.put(args[i].replaceAll(" ", ""));
	 }
	 String arg2 = pars.toString();
		JSONObject jsonObj  = new JSONObject("{\r\n" + 
		 		"	\"size\":300,\r\n" +
				"       \"query\": {\r\n" + 
				"          \"bool\": { \r\n" + 
				"               \"must\": {\r\n" + 
		 		"						  \"constant_score\":{ \r\n" + 
		 		"									\"filter\":{ \r\n" + 
		 		"											\"terms\":{ \r\n" + 
		 		"											\""+field+"\":"+arg2+"\r\n"+
		 		"													}\r\n" + 
		 		"											}\r\n" + 
		 		"										} \r\n" + 
				"                },\r\n" + 
				"                \"filter\": {\r\n" + 
				"                    \"range\" : {\r\n" + 
				"                        \"date\" : {\r\n" + 
				"                            \"gte\": \""+greater+"\",\r\n" + 
				"                            \"lte\": \""+less+"\"\r\n" + 
				"                        }\r\n" + 
				"                    }\r\n" + 
				"                }\r\n" + 
				"            }\r\n" + 
				"        },\r\n" +  
		 		"   	\"sort\":{\r\n" + 
		 		"		\"frequency\":{\r\n" + 
		 		"			\"order\":\"DESC\"\r\n" + 
		 		"			}\r\n" + 
		 		"		}\r\n" + /*
				"    	\"aggregations\": {\r\n" + 
		 		"        	\"term\": {\r\n" + 
		 		"            \"terms\": {\r\n" + 
		 		"                \"field\": \"term\"\r\n" +
		 		"            }\r\n" + 
		 		"        	}\r\n" + 
		 		"    	}\r\n"+ */
				"    }");
		
		
	//jsonObj = new JSONObject(que3);
    String url = base_url+"_search";
    return this._getResult(url,jsonObj);
  
}







public ArrayList _searchByRangeByPostId(String blog_ids) throws Exception {
	
	blog_ids = blog_ids.replaceAll(",$", "");
	blog_ids = blog_ids.replaceAll(", $", "");
	blog_ids = "("+blog_ids+")";
	
	ArrayList response =new ArrayList();
	DbConnection db = new DbConnection();
	
	//System.out.println("SELECT * FROM terms WHERE blogpostid IN "+blog_ids+" ");
	try {
		response = db.queryJSON("SELECT * FROM terms WHERE blogpostid IN "+blog_ids+" ");		
	}catch(Exception e){
		return response;
	}
	
	
	return response;
}


public ArrayList getTermsByBlogger(String blogger,String date_start, String date_end) throws Exception {
	

	ArrayList response =new ArrayList();
	DbConnection db = new DbConnection();
	
	try {
		//response = db.queryJSON("SELECT * FROM terms WHERE blogpostid IN "+blog_ids+" ");
		response = db.queryJSON("SELECT (select blogpost_id from blogposts bp where bp.blogpost_id = tm.blogpostid AND bp.blogger='"+blogger+"' ) as blogpostid, tm.blogsiteid as blogsiteid, tm.blogpostid as blogpostid, tm.term as term, tm.frequency as frequency FROM terms tm ORDER BY tm.frequency DESC LIMIT 50 ");
	}catch(Exception e){
		return response;
	}
	
	
	return response;
}


public String _getMostActiveByBlog(String date_start, String date_end, String blogsiteid) throws Exception {
	ArrayList response =new ArrayList();
	DbConnection db = new DbConnection();
	
	try {
		response = db.queryJSON("SELECT term FROM terms WHERE blogsiteid='"+blogsiteid+"' ORDER BY frequency DESC LIMIT 1 ");
	}catch(Exception e){
		ArrayList hd = (ArrayList)response.get(0);
		return hd.get(0).toString();
	}
	
	return "";
}

public String _getMostActiveByBlogger(String blogger,String date_start, String date_end) throws Exception {
	

	ArrayList response =new ArrayList();
	DbConnection db = new DbConnection();
	
	try {
		//response = db.queryJSON("SELECT * FROM terms WHERE blogpostid IN "+blog_ids+" ");
		response = db.queryJSON("SELECT (select blogpost_id from blogposts bp where bp.blogpost_id = tm.blogpostid AND bp.blogger='"+blogger+"' ) as blogpostid, tm.blogsiteid as blogsiteid, tm.blogpostid as blogpostid, tm.term as term, tm.frequency as frequency   FROM terms tm ORDER BY tm.frequency DESC LIMIT 1 ");
		ArrayList hd = (ArrayList)response.get(0);
		return hd.get(5).toString();
	}catch(Exception e){
		return "";
	}
	
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

public String _searchRangeAggregate(String field,String greater, String less, String terms) throws Exception {
	String[] args = terms.split(","); 
	JSONArray pars = new JSONArray(); 
	ArrayList<String> ar = new ArrayList<String>();	
	for(int i=0; i<args.length; i++){
		pars.put(args[i].toLowerCase());
	}

	String arg2 = pars.toString();
	// String range = "\"range\" : {\"sentiment\" : {\"gte\" : "+greater+",\"lte\" : "+less+"}}";

	
	String que="{\r\n" + 
			"  \"query\": {\r\n" + 
			"    \"bool\": {\r\n" + 
			"      \"must\": [\r\n" + 
			"        {\r\n" + 
			"		  \"constant_score\":{\r\n" + 
			"					\"filter\":{\r\n" + 
			"							\"terms\":{\r\n" + 
			"							\"term\":"+arg2+"\r\n" + 
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
			"        \"total\" : { \"sum\" : { \"field\" : \"frequency\" } }\r\n" + 
			"    }\r\n" + 
			"}";


	JSONObject jsonObj = new JSONObject(que);

	String url = base_url+"_search?size=1";
	return this._getAggregate(url,jsonObj);
}

public String _searchRangeTotal(String field,String greater, String less, String terms) throws Exception {
	String[] args = terms.split(","); 
	JSONArray pars = new JSONArray(); 
	ArrayList<String> ar = new ArrayList<String>();	
	for(int i=0; i<args.length; i++){
		pars.put(args[i].toLowerCase());
	}

	String arg2 = pars.toString();
	// String range = "\"range\" : {\"sentiment\" : {\"gte\" : "+greater+",\"lte\" : "+less+"}}";
	String que="{\r\n" + 
			"  \"query\": {\r\n" + 
			"    \"bool\": {\r\n" + 
			"      \"must\": [\r\n" + 
			"        {\r\n" + 
			"		  \"constant_score\":{\r\n" + 
			"					\"filter\":{\r\n" + 
			"							\"terms\":{\r\n" + 
			"							\"term\":"+arg2+"\r\n" + 
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
	return this._getTotal(url,jsonObj);
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
	 String que = "{\"query\": {\"constant_score\":{\"filter\":{\"terms\":{\"id\":"+arg2+"}}}},\"sort\":{\"date\":{\"order\":\"DESC\"}}}";

		
	JSONObject jsonObj = new JSONObject(que);
	String url = base_url+"_search";
	return this._getResult(url, jsonObj);
	   
}




public ArrayList _getMostUsed(String blog_ids) throws Exception { 
	ArrayList mostactive = new ArrayList();
	ArrayList terms = this._fetch(blog_ids);

	if (terms.size() > 0) {
		String bres = null;
		JSONObject bresp = null;
		
		String bresu = null;
		JSONObject bobj = null;
		bres = terms.get(0).toString();
			bresp = new JSONObject(bres);
			bresu = bresp.get("_source").toString();
			bobj = new JSONObject(bresu);
			mostactive.add(0, bobj.get("term").toString()); 
			mostactive.add(1, bobj.get("frequency").toString());	
	}
	return mostactive;		
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


public Integer getTermOcuurence(String term,String start_date,String end_date) {
	String tres = null;
	JSONObject tresp = null;
	String tresu = null;
	JSONObject tobj = null;								
	int alloccurence = 0;
	int k=0;
	Blogposts post = new Blogposts();
	try {
	ArrayList allposts =  post._searchByTitleAndBody(term,"date", start_date,end_date);//term._searchByRange("date",dt,dte, tm,"term","10");
	
	for(int i=0; i< allposts.size(); i++){
		tres = allposts.get(i).toString();	
		tresp = new JSONObject(tres);									
		tresu = tresp.get("_source").toString();
		tobj = new JSONObject(tresu);
		
				int bodyoccurencece = 0;//ut.countMatches(tobj3.get("post").toString(), mostactiveterm);			
		        String str = tobj.get("post").toString()+" "+ tobj.get("post").toString();
		        str = str.toLowerCase();
		        term = term.toLowerCase();
		        String findStr = term;
				int lastIndex = 0;
				//int count = 0;

				while(lastIndex != -1){

				    lastIndex = str.indexOf(findStr,lastIndex);

				    if(lastIndex != -1){
				        bodyoccurencece++;
				        alloccurence+=bodyoccurencece;
				        lastIndex += findStr.length();
				    }			    
				}
		}
	}catch(Exception ex) {}
	return alloccurence;
}


	public JSONArray _sortJson2(JSONArray termsarray) {
		JSONArray sortedtermsarray = new JSONArray();
		List<String> jsonList = new ArrayList<String>();
		for (int i = 0; i < termsarray.length(); i++) {
		    jsonList.add(termsarray.get(i).toString());
		}
		
		Collections.sort(jsonList, new Comparator<String>() {
		    public int compare(String o1, String o2) {
		    	String[] a1 = o1.split("___");
	        	String[] b1 = o2.split("___");
		        return extractInt(b1[0]) - extractInt(a1[0]);
		    }
	
		    int extractInt(String s) {
		        String num = s.replaceAll("\\D", "");
		        // return 0 if no digits found
		        return num.isEmpty() ? 0 : Integer.parseInt(num);
		    }
		});
		
		
		for (int i = 0; i < termsarray.length(); i++) {
		    sortedtermsarray.put(jsonList.get(i));
		}
		return sortedtermsarray;
	}

}