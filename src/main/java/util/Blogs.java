package util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL; 
import org.json.JSONObject;
import org.json.JSONArray;
import authentication.DbConnection;

import java.io.OutputStreamWriter;


import java.util.ArrayList;
import java.util.HashMap;

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


		String url = base_url+"_search?size=100";
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



	/* Fetch posts by blog ids*/
	public ArrayList _getBloggerByBlogId(String blog_ids,String from) throws Exception {
		String url = base_url+"_search?size=1000";
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


	public ArrayList _fetch(String ids) throws Exception {
		ArrayList result = new ArrayList();
		String[] args = ids.split(",");

		JSONArray pars = new JSONArray(); 
		ArrayList<String> ar = new ArrayList<String>();	
		for(int i=0; i<args.length; i++){
			pars.put(args[i].replaceAll(" ", ""));
		}

		String arg2 = pars.toString();
		System.out.println(ids);
		//String que = "{\"query\": {\"constant_score\":{\"filter\":{\"terms\":{\"blogsite_id\":"+arg2+"}}}}}";
		String que = "{\"query\": {\"constant_score\":{\"filter\":{\"terms\":{\"blogsite_id\":"+arg2+"}}}},\"sort\":{\"totalposts\":{\"order\":\"DESC\"}}}";

		
		JSONObject jsonObj = new JSONObject(que);
		String url = base_url+"_search";
		return this._getResult(url, jsonObj);

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
				}
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
		}catch(Exception e) {}
		
		return  list;
	}

}