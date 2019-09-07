package util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL; 
import org.json.JSONObject;

import authentication.DbConnection;

import org.json.JSONArray;

import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.util.*;
import java.time.format.DateTimeFormatter;  
import java.time.LocalDateTime; 
import java.text.SimpleDateFormat;
import java.util.Date;
public class Trackers {

	HashMap<String, String> hm = DbConnection.loadConstant();		
	
	String base_url = hm.get("elasticIndex")+"trackers/";
	String totalpost;	    
	   
public ArrayList _list(String order, String from, String userid, String size) throws Exception {
	/*
	 	 JSONObject jsonObj = new JSONObject("{\r\n" + 
	 		"  \"query\": {\r\n" + 
	 		"        \"query_string\" : {\r\n" + 
	 		"            \"fields\" : [\"userid\"],\r\n" + 
	 		"            \"query\" : \""+userid+"\"\r\n" + 
	 		"        }\r\n" + 
	 		"  },\r\n" + 
	 		"   \"sort\":{\r\n" + 
	 		"		\"tid\":{\r\n" + 
	 		"			\"order\":\"DESC\"\r\n" + 
	 		"			}\r\n" + 
	 		"		}\r\n" + 
	 		"}");
	

    if(!from.equals("")) {
    	jsonObj = new JSONObject("{\r\n" + 
    			"  \"query\": {\r\n" + 
    			"        \"query_string\" : {\r\n" + 
    			"            \"fields\" : [\"userid\"],\r\n" + 
    			"            \"query\" : \""+userid+"\"\r\n" + 
    			"        }\r\n" + 
    			"  },\r\n" + 
    			"   \"sort\":{\r\n" + 
    			"		\"tid\":{\r\n" + 
    			"			\"order\":\"DESC\"\r\n" + 
    			"			}\r\n" + 
    			"		},\r\n" + 
    			" \"range\":{\r\n" + 
    			"		\"tid\":{\r\n" + 
    			"			\"lte\":\""+from+"\",\r\n" + 
		  		"			\"gte\":\""+0+"\"\r\n" + 
    			"			}\r\n" + 
    			"		}\r\n" + 
    			"}");
    }
	 
     String url = base_url+"_search?size="+size;     
     return this._getResult(url, jsonObj);
   */
	ArrayList trackerlist = new ArrayList();
	try {
		//System.out.println("userid:"+userid);
		trackerlist = DbConnection.query("select * from trackers where userid = '"+userid+"' ORDER BY tid DESC ");				
	} catch (Exception ex) {}
	
	return trackerlist;
	
   }

public String _getTotal() {
	return this.totalpost;
}

public JSONObject getMyTrackedBlogs(String userid) throws Exception{
	String res = null;
	JSONObject resp = null;
	String resu = null;
	JSONObject obj = null;	
	ArrayList resut = new ArrayList();
	ArrayList result = this._list("DESC","", userid,"100");
	
	JSONObject content = new JSONObject();
	if(result.size()>0) {
		for(int i=0; i< result.size(); i++){
			resut = (ArrayList<?>)result.get(i);
			//resp = new JSONObject(res);
		   // resu = resp.get("_source").toString();
		    //obj = new JSONObject(resu);
		   // if(obj.has("tid")) {
		    String id = resut.get(0).toString();
		    String query = resut.get(5).toString();//obj.get("query").toString();
			query = query.replaceAll("blogsite_id in ", "");
			query = query.replaceAll("\\(", "");			 
			query = query.replaceAll("\\)", "");
			
			 if(!query.equals("")){
				 String[] allque = query.replaceAll(", $", "").split(",");//query.split(",");
				 if( allque.length>0){
					 for(int k=0; k< allque.length; k++){
						 String blog_id = allque[k].trim();
						 content.put(blog_id, blog_id);
					 }
				 }
			 }
		   // }
		}
	}
	
	//System.out.println(content);
	return content;
}


public ArrayList _search(String term,String username) throws Exception {
	/*
	 JSONObject jsonObj = new JSONObject("{\r\n" + 
	 		"  \"query\": {\r\n" + 
	 		"        \"query_string\" : {\r\n" + 
	 		"            \"fields\" : [\"tracker_name\"],\r\n" + 
	 		"            \"query\" : \""+term+"\"\r\n" + 
	 		"        }\r\n" + 
	 		"  },\r\n" + 
	 		"   \"sort\":{\r\n" + 
	 		"		\"tid\":{\r\n" + 
	 		"			\"order\":\"DESC\"\r\n" + 
	 		"			}\r\n" + 
	 		"		}\r\n" + 
	 		"}");
	
	 
    String url = base_url+"_search?size=100";
    if(!from.equals("")) {
    	jsonObj = new JSONObject("{\r\n" + 
    			"  \"query\": {\r\n" + 
    			"        \"query_string\" : {\r\n" + 
    			"            \"fields\" : [\"tracker_name\"],\r\n" + 
    			"            \"query\" : \""+term+"\"\r\n" + 
    			"        }\r\n" + 
    			"  },\r\n" + 
    			"   \"sort\":{\r\n" + 
    			"		\"tid\":{\r\n" + 
    			"			\"order\":\"DESC\"\r\n" + 
    			"			}\r\n" + 
    			"		},\r\n" + 
    			" \"range\":{\r\n" + 
    			"		\"tid\":{\r\n" + 
    			"			\"lte\":\""+from+"\",\r\n" + 
		  		"			\"gte\":\""+0+"\"\r\n" + 
    			"			}\r\n" + 
    			"		}\r\n" + 
    			"}");
    }
    
    return this._getResult(url, jsonObj);
    */
	ArrayList bloglist = new ArrayList();
	 String s="";
	try {
		if(!term.trim().isEmpty()){
			
			   bloglist = DbConnection.query("select * from trackers where userid='"+username+"' AND tracker_name like '%"+term+"%' ");				
		}
	} catch (Exception ex) {}
	
	return bloglist;
}



public String getTotalTrack(String blogsite_id) throws Exception {
	/*
	 JSONObject jsonObj = new JSONObject("{\r\n" + 
	 		"  \"query\": {\r\n" + 
	 		"        \"query_string\" : {\r\n" + 
	 		"            \"fields\" : [\"query\"],\r\n" + 
	 		"            \"query\" : \""+blogsite_id+",\"\r\n" + 
	 		"        }\r\n" + 
	 		"  },\r\n" + 
	 		"   \"sort\":{\r\n" + 
	 		"		\"tid\":{\r\n" + 
	 		"			\"order\":\"DESC\"\r\n" + 
	 		"			}\r\n" + 
	 		"		}\r\n" + 
	 		"}");
	
	 
    String url = base_url+"_search?size=100";
    
    */
	ArrayList result = new ArrayList();
	 result =  DbConnection.query("select * from trackers where query LIKE '%,"+blogsite_id+",%' OR query LIKE '%\\("+blogsite_id+",%' OR query LIKE '%,"+blogsite_id+"\\)%' OR query LIKE '%\\("+blogsite_id+"\\)%' GROUP BY userid ");			

    return result.size()+"";
}


public ArrayList _fetch(String ids) throws Exception {
	 ArrayList result = new ArrayList();
	 String s = "("+ids+")";
	
	 result =  DbConnection.query("select * from trackers where tid ="+s+"");			

	 /*
	 JSONObject query = new JSONObject(); 
	 JSONObject jsonObj = new JSONObject("{\r\n" + 
	 		"  \"query\": {\r\n" + 
	 		"    \"constant_score\":{\r\n" + 
	 		"			\"filter\":{\r\n" + 
	 		"					\"terms\":{\r\n" + 
	 		"							\"tid\":[\""+ids+"\"]\r\n" + 
	 		"							}\r\n" + 
	 		"					}\r\n" + 
	 		"				}\r\n" + 
	 		"    }\r\n" + 
	 		"}");
	 
	 
   String url = base_url+"_search/";
   return this._getResult(url, jsonObj)
   */
	 return result;
}

/* Add a new tracker*/
public String _add(String userid, JSONObject params) throws Exception {
	 String blgs =  params.get("blogs").toString();
	 String[] blogs = blgs.split(",");
	 int blognum = 0;
	 if(!blgs.equals("")) {
		 blognum = blogs.length;
	 }
	 
	 
	 /*
	 String urll = base_url+"_search?size=5";  
	 JSONObject jsonObj2 = new JSONObject("{\r\n" + 
	 		"    \"query\" : {\r\n" + 
	 		"        \"match_all\" : {}\r\n" + 
	 		"    }\r\n" + 
	 		"}");
	 
	 
	 String next = this._getTotal(urll, jsonObj2);
	 
	 //int tidd = Integer.parseInt(next)+1;
	 
	 
	 //DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");  
	 //LocalDateTime now = LocalDateTime.now();  
	 //System.out.println(dtf.format(now));  
	 
	 JSONObject param = new JSONObject();
	 param.put("userid",userid);
	 param.put("query", "blogsite_id in ("+params.get("blogs")+")");
	 param.put("tracker_name", params.get("trackername"));
	 param.put("description", params.get("description"));
	 param.put("blogsites_num", blognum);	
	// param.put("tid", tidd);
	 //param.put("date_modified",dtf.format(now));
	 //param.put("date_created",dtf.format(now)+"T06:00:00.000Z");

	 
	 //System.out.println(param);
	//JSONObject jsonObj = new JSONObject("{\"userid\":\"wizzletest\",\"query\":\"blogsite_id in (46,62,47,49,66,52,53,65,63,54)\",\"tracker_name\":\"Wizzle\",\"description\":\"Best blogs ever\",\"blogsites_num\":10}");	 
	 String output = "false";
	 
	 //String url = base_url+"trackers";	 
	// JSONObject myResponse = this._runUpdate(url, param);
	 
	  if(null==myResponse.get("result")) {
		   	  output = "false";
	   }else {
		   String resv = myResponse.get("result").toString();
		  // System.out.println(resv);
		   if(resv.equals("created")) {
			   output = "true";
		   }else {
			   output = "false";
		   }
	   } 
	   */
	 
	 String output = "false";
	 String blogsites = "blogsite_id in ("+params.get("blogs")+")";
	 String trackerName = params.get("trackername").toString();
	 String description = params.get("description").toString();
	 String createdDate= getDateTime();
	// String totalblogs = blognum+"";
	 
	 ArrayList prev = DbConnection.query("SELECT * FROM trackers WHERE tracker_name='"+trackerName+"'");
		
		if(prev!=null && prev.size()>0) {
			output = "false";
		}else {	
			String query="INSERT INTO trackers(userid,tracker_name,date_created,date_modified,query,description,blogsites_num) VALUES('"+userid+"', '"+trackerName+"', '"+createdDate+"', "+ null+", '"+blogsites+"', '"+description+"', '"+blognum+"')";
			boolean done = new DbConnection().updateTable(query);
			if(done) {
			  	output = "true";
			}else {
				output = "false";
			}
		}
		
	
	  return output;
	    
}


/* Add a new tracker*/
public String _delete(String trackerid) throws Exception {
	
	 ArrayList<?> detail = this._fetch(trackerid);
	 if(detail.size()>0){	
		 	ArrayList resut = (ArrayList)detail.get(0);		
		    String id = resut.get(0).toString();
		   /*
			String res = detail.get(0).toString();		
			JSONObject resp = new JSONObject(res);
			
			//tid = "4qSen2QBCl8_4DKPZSTm";
			/*
			 String tid = resp.get("_id").toString();
			String url = base_url+"trackers/"+tid;
			this._runDelete(url);
			
			String tid = resp.get("tracker_id").toString();	
			*/
			String query="DELETE FROM trackers WHERE  tid='"+id+"'";
			boolean done = new DbConnection().updateTable(query);
			if(done) {
				return "true";
			}else {
				return "false";
			}
			
	 }
 
	 return "false";
		
}

/* Remove blogs from tracker*/
public String _removeBlogs(String trackerid,String blog_ids,String userid) throws Exception {
	String[] blogs = blog_ids.split(",");
	JSONObject jblog = new JSONObject();
	String output = "false";
	
	for(int k=0; k<blogs.length; k++) {
		jblog.put(blogs[k], blogs[k]);
	}
	 
	ArrayList<?> detail = this._fetch(trackerid);
	
	 if(detail.size()>0){		 
		 	ArrayList resut = (ArrayList)detail.get(0);		
		    String id = resut.get(0).toString();
		    String quer = resut.get(5).toString();//obj.get("query").toString();
			
			quer = quer.replaceAll("blogsite_id in ", "");
			quer = quer.replaceAll("\\(", "");
			quer = quer.replaceAll("\\)", "");
			String dtt =resut.get(3).toString();
			
			String mergedblogs = "";
			String[] blogs2 = quer.replaceAll(", $", "").split(",");//quer.split(",");
			 int blogcounter=0;
			 for(int j=0; j<blogs2.length; j++) {
				 if(!jblog.has(blogs2[j])) {
					 if(j<(blogs2.length-1))
						 mergedblogs+=blogs2[j]+",";
					 else
						 mergedblogs+=blogs2[j];
					 blogcounter++;
				 }
			 }
			 			
			String que =  "blogsite_id in ("+mergedblogs+")";				
		 
		 /*
			String res = detail.get(0).toString();		
			JSONObject resp = new JSONObject(res);
			String tid = resp.get("_id").toString();
			
			 String resu = resp.get("_source").toString();
			 JSONObject obj = new JSONObject(resu);	
			 
			 String mergedblogs = "";			 
			 String quer = obj.get("query").toString();
			 	 if(!obj.get("userid").toString().equals(userid)) {
			 		 return "false";
			 	 }
				 quer = quer.replaceAll("blogsite_id in ", "");
				 quer = quer.replaceAll("\\(", "");			 
				 quer = quer.replaceAll("\\)", "");
				 String[] blogs2 = quer.split(",");
				 int blogcounter=0;
				 for(int j=0; j<blogs2.length; j++) {
					 if(!jblog.has(blogs2[j])) {
						 if(j<(blogs2.length-1))
							 mergedblogs+=blogs2[j]+",";
						 else
							 mergedblogs+=blogs2[j];
						 blogcounter++;
					 }
				 }
				 			
				String que =  "blogsite_id in ("+mergedblogs+")";	
				/*
				String url = base_url+"trackers/"+tid+"/_update";			 
				JSONObject jsonObj = new JSONObject("{\r\n" + 
			    		"    \"script\" : \"ctx._source.query = '"+que+"'; ctx._source.blogsites_num= '"+blogcounter+"';\",\r\n" + 
			    		"}");
			 
				JSONObject myResponse = this._runUpdate(url, jsonObj);	
				 if(null!=myResponse.get("result")) {
					   String resv = myResponse.get("result").toString();
					   if(resv.equals("updated")) {
						   output = "true";
					   }
				   }
			*/
				String query = "UPDATE trackers SET query='"+que+"', blogsites_num = '"+blogcounter+"' WHERE  tid='"+trackerid+"'";
				boolean done = new DbConnection().updateTable(query);
				if(done) {
					output = "true";
				}else {
					output = "false";
				}			   						
	 }
	 
	 return output;
}

/* Add a new tracker*/
public String _update(String trackerid, JSONObject params) throws Exception {
	 String blgs =  params.get("blogs").toString();
	 String[] blogs = blgs.split(",");
	 int blognum = 0;
	 //System.out.println("To Merged:"+blgs);
	 
	 
	 String output = "false";
	 ArrayList<?> detail = this._fetch(trackerid);
	 //System.out.println(detail);
	 if(detail.size()>0){	
		 /*
			String res = detail.get(0).toString();		
			JSONObject resp = new JSONObject(res);
			String tid = resp.get("_id").toString(); 
		    String resu = resp.get("_source").toString();
		    JSONObject obj = new JSONObject(resu);		     	     
		    String quer = obj.get("query").toString();
		   		  
		    	
			 quer = quer.replaceAll("blogsite_id in ", "");
			 quer = quer.replaceAll("\\(", "");			 
			 quer = quer.replaceAll("\\)", "");
			 String[] blogs2 = quer.split(",");
			 
			 //System.out.println(quer);
			 //System.out.println("Bid"+);
			 
			 if(blogs.length>0) {
			    	String bid = blogs[0].trim();
			    	for(int b=0; b<blogs2.length; b++) {
			    		String b2id = blogs2[b].trim();
			    		if(b2id.equals(bid)) {		    			
			    			return "false";
			    		}
			    	}
			  }
			 
			 String mergedblogs = this.mergeArrays(blogs, blogs2);
			 String[] allblogs = mergedblogs.split(",");
			 blognum = allblogs.length;
			 
			 
			 JSONObject param = new JSONObject();
			 //param.put("userid",userid);
			 param.put("query", "blogsite_id in ("+mergedblogs+")");
			 if(params.has("trackername")) {
				 param.put("tracker_name", params.get("trackername"));
			 }
			 if(params.has("description")) {
				 param.put("description", params.get("description"));
			 }
			 
			 if(params.has("userid")) {
				 param.put("userid", params.get("userid"));
			 }
			 
			 param.put("blogsites_num", blognum);
			 
			 //System.out.println(param);
			//JSONObject jsonObj = new JSONObject("{\"userid\":\"wizzletest\",\"query\":\"blogsite_id in (46,62,47,49,66,52,53,65,63,54)\",\"tracker_name\":\"Wizzle\",\"description\":\"Best blogs ever\",\"blogsites_num\":10}");
			 	 
			 String url = base_url+"trackers/"+tid+"/_update";
			 
			 JSONObject jsonObj = new JSONObject("{\r\n" + 
			    		"    \"script\" : \"ctx._source.query = '"+param.get("query")+"'; ctx._source.blogsites_num= '"+param.get("blogsites_num")+"';\",\r\n" + 
			    		"}");
			 JSONObject myResponse = this._runUpdate(url, jsonObj);	
			 //this._delete(trackerid);
			  *if(null==myResponse.get("result")) {
				   	  output = "false";
			   }else {
				   String resv = myResponse.get("result").toString();
				   if(resv.equals("updated")) {
					   output = "true";
				   }else {
					   output = "false";
				   }
			   }
			 */

				ArrayList resut = (ArrayList)detail.get(0);
				
			    String id = resut.get(0).toString();
			    String quer = resut.get(5).toString();//obj.get("query").toString();
				
				quer = quer.replaceAll("blogsite_id in ", "");
				quer = quer.replaceAll("\\(", "");
				quer = quer.replaceAll("\\)", "");
				
				String[] blogs2 = quer.replaceAll(", $", "").split(",");//quer.split(",");
				 
				 //System.out.println(quer);
				 //System.out.println("Bid"+);
				 
				 if(blogs.length>0) {
				    	String bid = blogs[0].trim();
				    	for(int b=0; b<blogs2.length; b++) {
				    		String b2id = blogs2[b].trim();
				    		if(b2id.equals(bid)) {		    			
				    			return "false";
				    		}
				    	}
				  }
				 
				 String mergedblogs = this.mergeArrays(blogs, blogs2);
				 String[] allblogs = mergedblogs.split(",");
				 blognum = allblogs.length;
				 
				String qu = "blogsite_id in ("+mergedblogs+")";
				String trackerName = "";
				 if(params.has("trackername")) {
					 trackerName = params.get("trackername").toString();
				 }
				 
				 String description = params.get("description").toString();
				 String userid = params.get("userid").toString();
			
				 String query = "UPDATE trackers SET tracker_name='"+trackerName+"', description='"+description+"', query='"+qu+"', blogsites_num = '"+blognum+"' WHERE  tid='"+trackerid+"' AND userid = '"+userid+"'";
				 new DbConnection().updateTable(query);	
				 boolean done = new DbConnection().updateTable(query);
					if(done) {
							output = "true";
					}else {
							output = "false";
					}			   							 
	 }
	 
	
	 return  output;
	 
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
	}catch(Exception ex) {}
     return list;
}


/* Update tracker*/
public JSONObject _runUpdate(String url, JSONObject jsonObj) throws Exception {
	URL obj = new URL(url);
	 JSONObject myResponse = new  JSONObject();
	try {
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
	   myResponse = new JSONObject(response.toString()); 
	}catch(Exception e) {}
	   return  myResponse;
}


/* Delete tracker*/
public void _runDelete(String url) throws Exception {
	URL obj = new URL(url);
    HttpURLConnection con = (HttpURLConnection) obj.openConnection(); 
    con.setDoOutput(true);
    con.setDoInput(true);
    con.setRequestMethod("DELETE");    
    OutputStreamWriter wr = new OutputStreamWriter(con.getOutputStream());
    int responseCode = con.getResponseCode();  
}




public String _getTotal(String url, JSONObject jsonObj) throws Exception {
	String total  = "0";
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
	      total = myRes1.get("total").toString();  
     }
	}catch(Exception e) {}
     return total;
}

	public String mergeArrays(String[] arr1, String[] arr2){
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
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date = new Date();
		return dateFormat.format(date);
	}
}