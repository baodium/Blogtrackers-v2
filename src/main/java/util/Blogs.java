package util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.ResultSet;

import org.json.JSONObject;
import org.json.JSONArray;
import authentication.DbConnection;
import scala.Tuple2;

import java.io.OutputStreamWriter;

import java.time.format.DateTimeFormatter;  
import java.time.LocalDateTime; 

import java.util.ArrayList;
import java.util.*;

public class Blogs extends DbConnection{


	HashMap<String, String> hm = DbConnection.loadConstant();		

	String base_url = hm.get("elasticIndex")+"blogsites/";
	String totalpost;		    

	public ArrayList _list(String order, String from) throws Exception {	


		JSONObject jsonObj = new JSONObject("{\r\n" + 
				"    \"query\": {\r\n" + 
				"        \"match_all\": {}\r\n" + 
				"    },\r\n" + 
				"	\"sort\":{\r\n" + 
				"		\"totalposts\":{\r\n" + 
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
					"		\"blogsite_id\":{\r\n" + 
					"			\"order\":\"DESC\"\r\n" + 
					"			}\r\n" + 
					"		},\r\n" + 
					"	\"range\":{\r\n" + 
					"		\"blogsite_id\":{\r\n" + 
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
					"            \"fields\" : [\"blogsite_name\",\"blogsite_name\"],\r\n" +
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

	public String _getTotalBloggers(String greater, String less, String blogids) throws Exception {
			
			DbConnection db = new DbConnection();
			String count = "0";
			blogids = blogids.replaceAll(",$", "");
			blogids = blogids.replaceAll(", $", "");
			blogids = "("+blogids+")";
			
			try {
				ArrayList response = db.query("SELECT DISTINCT blogger FROM blogposts WHERE blogsite_id IN "+blogids+" AND date>='"+greater+"' AND date<='"+less+"' ");		
				if(response.size()>0){
					count = response.size()+"";
				}
			}catch(Exception e){
				return count;
			}
			return count;
			
	}
	
	
	public ArrayList _getBloggers(String greater, String less, String blogids) throws Exception {	
		
		blogids = blogids.replaceAll(",$", "");
		blogids = blogids.replaceAll(", $", "");
		blogids = "("+blogids+")";
		
		blogids = "("+blogids+")";
		DbConnection db = new DbConnection();
		ArrayList response = new ArrayList();
		try {
			response = db.query("SELECT DISTINCT blogger,blogsite_id,language,date,blogpost_id FROM blogposts WHERE blogsite_id IN "+blogids+" AND date>='"+greater+"' AND date<='"+less+"' ORDER BY influence_score DESC LIMIT 20 ");				
		}catch(Exception e){
			return response;
		}
		
		return response;
	}
	

	public ArrayList _getPost(String blog_ids) {
		DbConnection db = new DbConnection();
		ArrayList response = new ArrayList<>();
		String result ="";
		blog_ids = blog_ids.replaceAll(",$", "");
		blog_ids = blog_ids.replaceAll(", $", "");
		blog_ids = "("+blog_ids+")";
		try {
			 response = db.query("select blogsite_id, blogsite_name, totalposts, CASE\r\n" + 
			 		"    WHEN last_crawled is null THEN last_modified_time\r\n" + 
			 		"    ELSE last_crawled\r\n" + 
			 		"END last_crawled from blogsites where blogsite_id in "+blog_ids);
			if(response.size()>0) {
				return response;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	

	/* Fetch posts by blog ids*/
	public ArrayList _getBloggerByBlogId(String blog_ids,String from) throws Exception {
		String url = base_url+"_search?size=20";
		String[] args = blog_ids.split(","); 
		JSONArray pars = new JSONArray(); 
		ArrayList<String> ar = new ArrayList<String>();	
		for(int i=0; i<args.length; i++){
			pars.put(args[i].replaceAll(" ", ""));
		}

		String arg2 = pars.toString();
		String que = "{\"query\": {\"constant_score\":{\"filter\":{\"terms\":{\"blogsite_id\":"+arg2+"}}}}}";

		JSONObject jsonObj = new JSONObject(que);
		ArrayList result =  this._getResult(url, jsonObj);
		return this._getResult(url, jsonObj);
	}

	//Obtain the count of blogs based on the blogsite ids
	public String _blogsiteCount(String blogids) throws Exception {
//		
//		DbConnection db = new DbConnection();
//		String count = "0";
//		blogids = blogids.replaceAll(",$", "");
//		blogids = blogids.replaceAll(", $", "");
//		blogids = "("+blogids+")";
//		
//		try {
//			ArrayList response = db.query("SELECT DISTINCT blogger FROM blogposts WHERE blogsite_id IN "+blogids+" AND date>='"+greater+"' AND date<='"+less+"' ");		
//			if(response.size()>0){
//				count = response.size()+"";
//			}
//		}catch(Exception e){
//			return count;
//		}
//		System.out.println(count);
//		return count;
		String count ="";
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
		String que = "{\"query\": {\"constant_score\":{\"filter\":{\"terms\":{\"blogsite_id\":"+arg2+"}}}},\"sort\":{\"totalposts\":{\"order\":\"DESC\"}}}";

		JSONObject jsonObj = new JSONObject(que);

		String url = base_url+"_search?size=10000";

		return this._getResult(url, jsonObj);

	}
	
	public ArrayList _getLocationUsage(String blogids) throws Exception {
		ArrayList result = new ArrayList();

		DbConnection db = new DbConnection();
		String count = "0";
		blogids = blogids.replaceAll(",$", "");
		blogids = blogids.replaceAll(", $", "");
		blogids = "("+blogids+")";
		
		try {
			result = db.query("SELECT location, count(location), blogsite_name  FROM blogsites WHERE blogsite_id IN "+blogids+" and location is not null group by blogsite_id");		
			
		}catch(Exception e){
		}
		return result;

	}
	
	public ArrayList _getLocation(String blogids) throws Exception {
		ArrayList result = new ArrayList();

		DbConnection db = new DbConnection();
		String count = "0";
		blogids = blogids.replaceAll(",$", "");
		blogids = blogids.replaceAll(", $", "");
		blogids = "("+blogids+")";
		
		try {
			result = db.query("SELECT DISTINCT(location), count(location), blogsite_name  FROM blogsites WHERE blogsite_id IN "+blogids+" and location is not null group by location");		
			
		}catch(Exception e){
		}
		return result;

	}
	
	public ArrayList _getLanguage(String blogids) throws Exception {
		ArrayList result = new ArrayList();

		DbConnection db = new DbConnection();
		String count = "0";
		blogids = blogids.replaceAll(",$", "");
		blogids = blogids.replaceAll(", $", "");
		blogids = "("+blogids+")";
		
		try {
			result = db.query("select language, sum(language_count) from language where blogsite_id in "+blogids+" and language != '"+"null"+"' and language != '"+"unknown"+"' group by language");		
			
		}catch(Exception e){
		}
		return result;
	}
	
	public ArrayList _getInfluencialBlog(String blogids) throws Exception {
		ArrayList result = new ArrayList();

		DbConnection db = new DbConnection();
		String count = "0";
		blogids = blogids.replaceAll(",$", "");
		blogids = blogids.replaceAll(", $", "");
		blogids = "("+blogids+")";
		
		try {
		result = db.query("SELECT (select distinct blogsite_name from blogsites bs where bl.blogsite_id = bs.blogsite_id) AS blogsiteName,  MAX(bl.influence_score), bl.blogsite_id FROM blogger bl where blogsite_id in "+
				(blogids)+" group by blogsiteName order by influence_score desc");		
			
		}catch(Exception e){
		}
		return result;

	}
	
	/**
	 * Getting most influential blogs
	 * @param field_name field name to filter search on
	 * @param field_values field values
	 * @param from lowest date range
	 * @param to highest date range
	 * @param limit output limit
	 * @throws Exception - Exception
	 * @return String result
	 */
	public static ArrayList<Tuple2<String, Integer>> getMostInfluentialBlogs(String field_name, String field_values, String from, String to, String limit) throws Exception {
		String result = null;
		ArrayList<Tuple2<String, Integer> > output = new ArrayList<>();
		Tuple2<String, Integer> v = new Tuple2<String, Integer>(null,null);
		
		if (field_values.indexOf("\"") != 0) {
			field_values = "\"" + field_values + "\"";
		}
		String query = "select "+field_name+", SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(permalink, '/', 3), '://', -1), '/', 1), '?', 1) as domain, max(influence_score) m\r\n" + 
				"from blogposts\r\n" + 
				"where blogsite_id in ("+field_values+") \r\n" + 
				"and date > \""+from+"\" \r\n" + 
				"and date < \""+to+"\"\r\n" + 
				"group by "+field_name+" limit "+limit+";";
		
		ResultSet post_all =  DbConnection.queryResultSet(query);
		
		while(post_all.next()){
			String domain_name = post_all.getString("domain");
			String field_name_data = post_all.getString(field_name);
			int count = post_all.getInt("m");
			
			v = new Tuple2<String, Integer>(domain_name+"_______________"+field_name_data,count);
			output.add(v);
		}

		post_all.close();
		return output;
	}
	
	
	
	public ArrayList _getInfluencialBlogger(String blogids) throws Exception {
		ArrayList result = new ArrayList();

		DbConnection db = new DbConnection();
		String count = "0";
		blogids = blogids.replaceAll(",$", "");
		blogids = blogids.replaceAll(", $", "");
		blogids = "("+blogids+")";
		try {
		result = db.query("select blogger_name, max(influence_score), blogsite_id from blogger where blogsite_id in "+
				(blogids)+" group by blogger_name order by influence_score desc");		

		}catch(Exception e){
		}
		return result;

	}
	
	public String _getBloggerInfluenceScore(String blogger, String start, String end) throws Exception {
		ArrayList result = new ArrayList();

		DbConnection db = new DbConnection();
		String count = "0";
		
		try {
			result = db.query("SELECT (select  sum(influence_score)  from blogtrackers.blogposts bp where bp.blogger='"+blogger+"' AND bl.blogger_name='"+blogger+"' bp.last_crawled >='"+start+"' AND bp.last_crawled <='"+end+"') as influence_score, bl.blogger_name as blogger_name FROM blogtrackers.blogger bl WHERE bl.blogger_name = '"+blogger+"'  ORDER BY bl.influence_score DESC LIMIT 1 ");		
			if(result.size()>0){
			 	ArrayList hd = (ArrayList)result.get(0);
				count = hd.get(0).toString();
			}
		}catch(Exception e){
		}
		return count;

	}
	public ArrayList _getblogPostFrequency(String blogids) throws Exception {
		ArrayList result = new ArrayList();

		DbConnection db = new DbConnection();
		String count = "0";
		blogids = blogids.replaceAll(",$", "");
		blogids = blogids.replaceAll(", $", "");
		blogids = "("+blogids+")";
		
		try {
		result = db.query("select blogsite_name, totalposts, blogsite_id, blogsite_url from blogsites where blogsite_id in "+blogids+" order by totalposts DESC");		
			
		}catch(Exception e){
		}
		return result;
		

	}
	
	public ArrayList _getblogPostID(String blogids) throws Exception {
		ArrayList result = new ArrayList();

		DbConnection db = new DbConnection();
		String count = "0";
		blogids = blogids.replaceAll(",$", "");
		blogids = blogids.replaceAll(", $", "");
		blogids = "("+blogids+")";
		
		try {
		result = db.query("select blogsite_name, totalposts from blogsites where blogsite_id in "+blogids);		
			
		}catch(Exception e){
		}
		return result;

	}
	
	

	public ArrayList _getMostactive(String blog_ids) throws Exception { 
		ArrayList mostactive = new ArrayList();
		ArrayList blogs = this._fetch(blog_ids);

		if (blogs.size() > 0) {
			String bres = null;
			JSONObject bresp = null;

			String bresu = null;
			JSONObject bobj = null;
			bres = blogs.get(0).toString();
			bresp = new JSONObject(bres);
			bresu = bresp.get("_source").toString();
			bobj = new JSONObject(bresu);
			mostactive.add(0, bobj.get("blogsite_name").toString()); 
			mostactive.add(1, bobj.get("blogsite_url").toString());				 
			mostactive.add(2, bobj.get("totalposts").toString());
			mostactive.add(3, bobj.get("blogsite_id").toString());

			if (blogs.size() > 1) {

				bres = blogs.get(1).toString();
				bresp = new JSONObject(bres);
				bresu = bresp.get("_source").toString();
				bobj = new JSONObject(bresu);

				mostactive.add(4, bobj.get("blogsite_name").toString()); 
				mostactive.add(5, bobj.get("blogsite_url").toString());				 
				mostactive.add(6, bobj.get("totalposts").toString());
				mostactive.add(7, bobj.get("blogsite_id").toString());
				mostactive.add(8, bobj.get("location").toString());
			}
		}
		return mostactive;		
	}


	public String _getTopLocation(String blog_ids) throws Exception { 
		String toplocation="";
		ArrayList blogs = this._fetch(blog_ids);
		JSONArray locations = new JSONArray();	
		HashMap<String,Integer> hm = new HashMap<String,Integer>();
		if (blogs.size() > 0) {
			String bres = null;
			JSONObject bresp = null;

			String bresu = null;
			JSONObject bobj = null;
			for(int y=0; y< blogs.size(); y++) {
				bres = blogs.get(y).toString();
				bresp = new JSONObject(bres);
				bresu = bresp.get("_source").toString();
				bobj = new JSONObject(bresu);

				String loc = bobj.get("location").toString();
				
				locations.put(loc);
				if ( hm.containsKey(loc) ) {
					int value = Integer.parseInt(hm.get(loc)+"");
					hm.put(loc, value + 1);
				} else {
					hm.put(loc, 1);
				}
			}
		}

		int highest = 0;
		Iterator it = hm.entrySet().iterator();
		while (it.hasNext()) {
			Map.Entry pair = (Map.Entry)it.next();
			if(Integer.parseInt(pair.getValue()+"")>highest) {
				toplocation = pair.getKey()+""; 
			}
			it.remove(); // avoids a ConcurrentModificationException
		}

		return toplocation;		
	}


	/* Add a new blog */
	public String _add(String userid, JSONObject params) throws Exception {

		String urll = base_url+"_search?size=5";  
		JSONObject jsonObj2 = new JSONObject("{\r\n" + 
				"    \"query\" : {\r\n" + 
				"        \"match_all\" : {}\r\n" + 
				"    }\r\n" + 
				"}");


		String next = this._getTotal(urll, jsonObj2);		 
		int tidd = Integer.parseInt(next)+1;

		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");  
		LocalDateTime now = LocalDateTime.now(); 

		JSONObject param = new JSONObject();
		param.put("crawled_by",userid);
		param.put("blogsite_name", params.get("blogsite_name"));
		//param.put("description", params.get("description"));
		param.put("blogsite_url", params.get("blogsite_url"));	
		param.put("blogsite_id", tidd);
		//param.put("date_modified",dtf.format(now));
		param.put("date_created",dtf.format(now)+"T06:00:00.000Z");


		String output = "false";

		String url = base_url+"blogsites";	 
		JSONObject myResponse = this._runUpdate(url, param);

		if(null==myResponse.get("result")) {
			output = "false";
		}else {
			String resv = myResponse.get("result").toString();
			if(resv.equals("created")) {
				output = "true";
			}else {
				output = "false";
			}
		} 

		return output;

	}

	/* Add a new tracker*/
	public String _delete(String blogsite_id,String userid) throws Exception {

		ArrayList<?> detail = this._fetch(blogsite_id);
		if(detail.size()>0){	
			ArrayList resut = (ArrayList)detail.get(0);		
			String id = resut.get(0).toString();

			String res = detail.get(0).toString();		
			JSONObject resp = new JSONObject(res);

			//tid = "4qSen2QBCl8_4DKPZSTm";

			String sid = resp.get("_id").toString();
			String owner = resp.get("crawled_by").toString();
			String url = base_url+"blogsites/"+sid;
			if(owner.equals(userid)) {
				this._runDelete(url);
				return "true";
			}else {
				return "false";
			}

		}

		return "false";

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
		}catch(Exception e) {}

		return  list;
	}

	public static String normalizeLanguage(String language) {
		switch(language.toLowerCase()) {
		case "en":
		case "english":
			language ="English";
			break;
		case "ar":
			language = "Arabic";
			break;
		case "null":
			language = "Unknown";
			break;
		case "ti":
			language = "Tigrinya";
			break;
		case "it":
			language = "Italian";
			break;
		case "de":
			language = "German";
			break;
		case "fr":
			language = "French";
			break;
		case "es":
			language = "Spanish";
			break;
		case "ro":
			language = " Moldovan";
			break;
		case "na":
			language = "Nauru";
			break;	
		case "ni":
			language = "Dutch";
			break;	
		case "nl":
			language = "Dutch";
			break;	
		case "so":
			language = "Somali";
			break;	
		case "id":
			language = "Indonesian";
			break;
		case "ca":
			language = "Catalan";
			break;	
		case "no":
			language = "Norwegian";
			break;	
		case "et":
			language = "Estonian";
			break;	
		case "tl":
			language = "Tagalog";
			break;	
		case "pt":
			language = "Portugese";
			break;	
		case "ru":
			language = "Russian";
			break;	
		case "da":
			language = "Danish";
			break;	
		case "af":
			language = "Afrikaans";
			break;	
		case "pl":
			language = "Polish";
			break;	
		case "sv":
			language = "Swedish";
			break;	
		}
		
		
		return language;
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

		/**
		 * Getting top blogs with respect to post frequency
		 * @param field_name field name to filter search on
		 * @param field_values field values
		 * @param from lowest date range
		 * @param to highest date range
		 * @param limit output limit
		 * @throws Exception - Exception
		 * @return String result
		 */
		public static ArrayList<Tuple2<String, Tuple2<String, Integer>> > getTopBlogs(String field_name, String field_values, String from, String to, String limit) throws Exception {
			String result = null;
			ArrayList<Tuple2<String, Tuple2<String, Integer>>> output = new ArrayList<>();
			Tuple2<String, Tuple2<String, Integer>> v = new Tuple2<String, Tuple2<String, Integer>>(null,null);
			
			if (field_values.indexOf("\"") != 0) {
				field_values = "\"" + field_values + "\"";
			}
			String query = "select "+field_name+", location, SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(permalink, '/', 3), '://', -1), '/', 1), '?', 1) as domain, count("+field_name+") c\r\n" + 
					"from blogposts\r\n" + 
					"where "+field_name+" in ("+field_values+") \r\n" + 
					"and date > \""+from+"\" and location is not null \r\n" + 
					"and date < \""+to+"\"\r\n" + 
					"group by "+field_name+" order by c desc limit "+limit+";";
		
			ResultSet post_all =  DbConnection.queryResultSet(query);
			
			while(post_all.next()){
				String domain_name = post_all.getString("domain");
				String location = post_all.getString("location");
				int count = post_all.getInt("c");
				
				v = new Tuple2<String, Tuple2<String, Integer>>(domain_name, new Tuple2<String, Integer>(location, count));
				output.add(v);
			}

			post_all.close();
			return output;
		}
		
		/**
		 * Getting top location with respect to post frequency
		 * @param field_name field name to filter search on
		 * @param field_values field values
		 * @param from lowest date range
		 * @param to highest date range
		 * @param limit output limit
		 * @throws Exception - Exception
		 * @return String result
		 */
		public static ArrayList<Tuple2<String, Integer> > getTopLocation(String field_name, String field_values, String from, String to, String limit) throws Exception {
			String result = null;
			ArrayList<Tuple2<String, Integer> > output = new ArrayList<>();
			Tuple2<String, Integer> v = new Tuple2<String, Integer>(null,null);
			
			if (field_values.indexOf("\"") != 0) {
				field_values = "\"" + field_values + "\"";
			}
			String query = "select location, count(location) c\n" + 
					"from blogposts\n" + 
					"where "+field_name+" in ("+field_values+") \n" + 
					"and date > \""+from+"\" \n" + 
					"and date < \""+to+"\"\n" + 
					"and location is not null\n" + 
					"group by location\n" + 
					"order by c desc\n" + 
					"limit "+limit+";";
			
			ResultSet post_all =  DbConnection.queryResultSet(query);
			
			while(post_all.next()){
				String location = post_all.getString("location");
				int count = post_all.getInt("c");
				
				v = new Tuple2<String, Integer>(location,count);
				output.add(v);
			}

			post_all.close();
			return output;
		}
		
		
		public static void main(String[] args) {
			try {
				getMostInfluentialBlogs("blogsite_id", "\"2649\",\"1319\",\"3436\"", "2020-01-01", "2020-11-11", "10");
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}


	}