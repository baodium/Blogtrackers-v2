package util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.SortedMap;
import java.util.TreeMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import java.util.concurrent.*;

import org.json.JSONObject;

import authentication.AutomatedCrawlerConnect;
import authentication.DbConnection;
import scala.Tuple2;

import org.apache.http.HttpHost;
import org.apache.http.util.EntityUtils;
import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;
import org.elasticsearch.client.Request;
import org.elasticsearch.client.Response;
import org.elasticsearch.client.RestClient;
import org.json.JSONArray;
import org.json.JSONException;

import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.*;

import javax.servlet.http.HttpServlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/Terms")

public class Terms extends HttpServlet implements Runnable {
	private static final long serialVersionUID = 1L;
	HashMap<String, String> hm = DbConnection.loadConstant();

	String base_url = hm.get("elasticIndex") + "blogpost_terms/";
	String elasticUrl = hm.get("elasticUrl");
	String totalpost;

	public ArrayList _list(String order, String from) throws Exception {
		JSONObject jsonObj = new JSONObject("{\r\n" + "    \"query\": {\r\n" + "        \"match_all\": {}\r\n"
				+ "    },\r\n" + "	\"sort\":{\r\n" + "		\"id\":{\r\n" + "			\"order\":\"" + order + "\"\r\n"
				+ "			}\r\n" + "		}\r\n" + "}");

		if (!from.equals("")) {
			jsonObj = new JSONObject("{\r\n" + "    \"query\": {\r\n" + "        \"match_all\": {}\r\n" + "    },\r\n"
					+ "	\"sort\":{\r\n" + "		\"id\":{\r\n" + "			\"order\":\"DESC\"\r\n" + "			}\r\n"
					+ "		},\r\n" + "	\"range\":{\r\n" + "		\"id\":{\r\n" + "			\"lte\":\"" + from
					+ "\",\r\n" + "			\"gte\":\"" + 0 + "\"\r\n" + "			}\r\n" + "		}\r\n" + "}");

		}

		String url = base_url + "_search?size=1000";
		return this._getResult(url, jsonObj);
	}

	public String _getTotal() {
		return this.totalpost;
	}

	public ArrayList _searchByRange(String field, String greater, String less, ArrayList blog_ids) throws Exception {

		/*
		 * blog_ids = blog_ids.replaceAll(",$", ""); blog_ids =
		 * blog_ids.replaceAll(", $", ""); blog_ids = "("+blog_ids+")"; int size = 20;
		 * ArrayList response =new ArrayList(); DbConnection db = new DbConnection();
		 * 
		 * System.out.
		 * println("SELECT term,frequency,date,blogpostid,id,blogsiteid FROM terms WHERE blogsiteid IN "
		 * +blog_ids+" AND date>='"+greater+"' AND date <='"
		 * +less+"' GROUP BY(term) ORDER BY frequency DESC LIMIT "+size+"");
		 * 
		 * try { //response = db.
		 * queryJSON("SELECT term,frequency,date,blogpostid,id,blogsiteid FROM terms WHERE blogsiteid IN "
		 * +blog_ids+" AND date>='"+greater+"' AND date <='"
		 * +less+"' GROUP BY(term) ORDER BY frequency DESC LIMIT "+size+""); response =
		 * db.
		 * queryJSON("SELECT term,frequency,date,blogpostid,id,blogsiteid FROM terms WHERE blogsiteid IN "
		 * +blog_ids+" GROUP BY(term) ORDER BY frequency DESC LIMIT "+size+"");
		 * 
		 * 
		 * }catch(Exception e){ return response; }
		 * 
		 * 
		 * return response;
		 */

		// System.out.println("post wale id "+blog_ids);
		JSONObject jsonObj = new JSONObject(
				"{\r\n" + "	\"size\":1000,\r\n" + "       \"query\": {\r\n" + "          \"bool\": { \r\n"
						+ "               \"must\": {\r\n" + "						  \"constant_score\":{ \r\n"
						+ "									\"filter\":{ \r\n"
						+ "											\"terms\":{ \r\n"
						+ "											\"" + field + "\":" + blog_ids + "\r\n"
						+ "													}\r\n"
						+ "											}\r\n"
						+ "										} \r\n" + "                },\r\n"
						+ "                \"filter\": {\r\n" + "                    \"range\" : {\r\n"
						+ "                        \"date\" : {\r\n" + "                            \"gte\": \""
						+ greater + "\",\r\n" + "                            \"lte\": \"" + less + "\"\r\n"
						+ "                        }\r\n" + "                    }\r\n" + "                }\r\n"
						+ "            }\r\n" + "        },\r\n" + "   	\"sort\":{\r\n" + "		\"frequency\":{\r\n"
						+ "			\"order\":\"DESC\"\r\n" + "			}\r\n" + "		}\r\n"
						+ /*
							 * "    	\"aggregations\": {\r\n" + "        	\"term\": {\r\n" +
							 * "            \"terms\": {\r\n" + "                \"field\": \"term\"\r\n" +
							 * "            }\r\n" + "        	}\r\n" + "    	}\r\n"+
							 */
						"    }");

		// jsonObj = new JSONObject(que3);
		String url = base_url + "_search";
		return this._getResult(url, jsonObj);

	}

	public ArrayList _getBloggerTermById(String field, String greater, String less, String blog_ids) throws Exception {
		blog_ids = blog_ids.replaceAll(",$", "");
		blog_ids = blog_ids.replaceAll(", $", "");

		String[] args = blog_ids.split(",");

		JSONArray pars = new JSONArray();
		ArrayList<String> ar = new ArrayList<String>();
		for (int i = 0; i < args.length; i++) {
			pars.put(args[i].replaceAll(" ", ""));
		}
		String arg2 = pars.toString();
		JSONObject jsonObj = new JSONObject(
				"{\r\n" + "	\"size\":20,\r\n" + "       \"query\": {\r\n" + "          \"bool\": { \r\n"
						+ "               \"must\": {\r\n" + "						  \"constant_score\":{ \r\n"
						+ "									\"filter\":{ \r\n"
						+ "											\"terms\":{ \r\n"
						+ "											\"" + field + "\":" + arg2 + "\r\n"
						+ "													}\r\n"
						+ "											}\r\n"
						+ "										} \r\n" + "                },\r\n"
						+ "                \"filter\": {\r\n" + "                    \"range\" : {\r\n"
						+ "                        \"date\" : {\r\n" + "                            \"gte\": \""
						+ greater + "\",\r\n" + "                            \"lte\": \"" + less + "\"\r\n"
						+ "                        }\r\n" + "                    }\r\n" + "                }\r\n"
						+ "            }\r\n" + "        },\r\n" + "   	\"sort\":{\r\n" + "		\"frequency\":{\r\n"
						+ "			\"order\":\"DESC\"\r\n" + "			}\r\n" + "		}\r\n"
						+ /*
							 * "    	\"aggregations\": {\r\n" + "        	\"term\": {\r\n" +
							 * "            \"terms\": {\r\n" + "                \"field\": \"term\"\r\n" +
							 * "            }\r\n" + "        	}\r\n" + "    	}\r\n"+
							 */
						"    }");

		// jsonObj = new JSONObject(que3);
		String url = base_url + "_search";
		return this._getResult(url, jsonObj);

	}

	public ArrayList _searchByRange(String field, String greater, String less, String blog_ids) throws Exception {
		blog_ids = blog_ids.replaceAll(",$", "");
		blog_ids = blog_ids.replaceAll(", $", "");

		/*
		 * blog_ids = "("+blog_ids+")"; int size = 20; ArrayList response =new
		 * ArrayList();
		 * 
		 * DbConnection db = new DbConnection();
		 * 
		 * System.out.
		 * println("SELECT term,frequency,date,blogpostid,id,blogsiteid FROM terms WHERE blogsiteid IN "
		 * +blog_ids+" AND date>='"+greater+"' AND date <='"
		 * +less+"' GROUP BY(term) ORDER BY frequency DESC LIMIT "+size+"");
		 * 
		 * try { //response = db.
		 * queryJSON("SELECT term,frequency,date,blogpostid,id,blogsiteid FROM terms WHERE blogsiteid IN "
		 * +blog_ids+" AND date>='"+greater+"' AND date <='"
		 * +less+"' GROUP BY(term) ORDER BY frequency DESC LIMIT "+size+""); //response
		 * = db.
		 * queryJSON("SELECT term,frequency,date,blogpostid,id,blogsiteid FROM terms WHERE blogsiteid IN "
		 * +blog_ids+" GROUP BY(term) ORDER BY frequency DESC LIMIT "+size+""); response
		 * = db.
		 * queryJSON("SELECT term,frequency,date,blogpostid,id,blogsiteid FROM terms WHERE blogsiteid IN "
		 * +blog_ids+" AND date>='"+greater+"' AND date <='"
		 * +less+"' ORDER BY frequency DESC LIMIT "+size+"");
		 * 
		 * 
		 * }catch(Exception e){ return response; }
		 * 
		 * 
		 * return response;
		 * 
		 */

		String[] args = blog_ids.split(",");
		// System.out.println(args);

		JSONArray pars = new JSONArray();
		ArrayList<String> ar = new ArrayList<String>();
		for (int i = 0; i < args.length; i++) {
			pars.put(args[i].replaceAll(" ", ""));
		}
		String arg2 = pars.toString();
		JSONObject jsonObj = new JSONObject(
				"{\r\n" + "	\"size\":300,\r\n" + "       \"query\": {\r\n" + "          \"bool\": { \r\n"
						+ "               \"must\": {\r\n" + "						  \"constant_score\":{ \r\n"
						+ "									\"filter\":{ \r\n"
						+ "											\"terms\":{ \r\n"
						+ "											\"" + field + "\":" + arg2 + "\r\n"
						+ "													}\r\n"
						+ "											}\r\n"
						+ "										} \r\n" + "                },\r\n"
						+ "                \"filter\": {\r\n" + "                    \"range\" : {\r\n"
						+ "                        \"date\" : {\r\n" + "                            \"gte\": \""
						+ greater + "\",\r\n" + "                            \"lte\": \"" + less + "\"\r\n"
						+ "                        }\r\n" + "                    }\r\n" + "                }\r\n"
						+ "            }\r\n" + "        },\r\n" + "   	\"sort\":{\r\n" + "		\"frequency\":{\r\n"
						+ "			\"order\":\"DESC\"\r\n" + "			}\r\n" + "		}\r\n"
						+ /*
							 * "    	\"aggregations\": {\r\n" + "        	\"term\": {\r\n" +
							 * "            \"terms\": {\r\n" + "                \"field\": \"term\"\r\n" +
							 * "            }\r\n" + "        	}\r\n" + "    	}\r\n"+
							 */
						"    }");

		// jsonObj = new JSONObject(que3);
		String url = base_url + "_search";
		System.out.println("term_url" + url);
		System.out.println("term_jsonobj" + jsonObj);
		return this._getResult(url, jsonObj);

	}

	public ArrayList _searchByRangeByPostId(String blog_ids) throws Exception {

		blog_ids = blog_ids.replaceAll(",$", "");
		blog_ids = blog_ids.replaceAll(", $", "");
		blog_ids = "(" + blog_ids + ")";

		ArrayList response = new ArrayList();
		DbConnection db = new DbConnection();

		// System.out.println("SELECT * FROM terms WHERE blogpostid IN "+blog_ids+" ");
		try {
			response = db.queryJSON("SELECT * FROM terms WHERE blogpostid IN " + blog_ids + " ");
		} catch (Exception e) {
			return response;
		}

		return response;
	}

	public ArrayList getTermsByBlogger(String blogger, String date_start, String date_end) throws Exception {

		ArrayList response = new ArrayList();
		DbConnection db = new DbConnection();

		try {

			// response = db.queryJSON("SELECT * FROM terms WHERE blogpostid IN "+blog_ids+"
			// ");
			response = db.queryJSON(
					"SELECT (select blogpost_id from blogposts bp where bp.blogpost_id = tm.blogpostid AND bp.blogger='"
							+ blogger
							+ "' ) as blogpostid, tm.blogsiteid as blogsiteid, tm.blogpostid as blogpostid, tm.term as term, tm.frequency as frequency FROM terms tm ORDER BY tm.frequency DESC LIMIT 50 ");
		} catch (Exception e) {
			return response;
		}

		return response;
	}

	public String _getMostActiveByBlog(String date_start, String date_end, String blogsiteid) throws Exception {
		ArrayList response = new ArrayList();
		DbConnection db = new DbConnection();

		try {
			response = db.queryJSON(
					"SELECT term FROM terms WHERE blogsiteid='" + blogsiteid + "' ORDER BY frequency DESC LIMIT 1 ");
		} catch (Exception e) {
			ArrayList hd = (ArrayList) response.get(0);
			return hd.get(0).toString();
		}

		return "";
	}

//public String _getMostActiveByBlogger(String blogger,String date_start, String date_end) throws Exception {
	public String _getMostActiveByBlogger(String blogger) throws Exception {

		ArrayList response = new ArrayList();
		DbConnection db = new DbConnection();

		try {
//		ArrayList bloggers = new DbConnection().query("SELECT * FROM user_blog WHERE userid='" + username + "'");
//		System.out.println(bloggers.size());
			// response = db.queryJSON("SELECT * FROM terms WHERE blogpostid IN "+blog_ids+"
			// ");
			response = db.query(
					"SELECT (select blogpost_id from blogposts bp where bp.blogpost_id = tm.blogpostid AND bp.blogger='"
							+ blogger
							+ "' ) as blogpostid, tm.blogsiteid as blogsiteid, tm.blogpostid as blogpostid, tm.term as term, tm.frequency as frequency   FROM terms tm ORDER BY tm.frequency DESC LIMIT 1 ");
//		response = db.queryJSON("SELECT (select blogpost_id from blogposts bp where bp.blogpost_id = tm.blogpostid AND bp.blogger='"+blogger+"' ) as blogpostid, tm.blogsiteid as blogsiteid, tm.blogpostid as blogpostid, tm.term as term, tm.frequency as frequency   FROM terms tm ORDER BY tm.frequency DESC LIMIT 1 ");
			System.out.println(blogger);
			ArrayList hd = (ArrayList) response.get(0);
			System.out.println("-----------" + hd);
			return hd.get(3).toString();

		} catch (Exception e) {
			System.out.println(e);
			return "";
		}

	}

	public ArrayList _search(String term, String from) throws Exception {
		JSONObject jsonObj = new JSONObject("{\r\n" + "  \"query\": {\r\n" + "        \"query_string\" : {\r\n"
				+ "            \"fields\" : [\"blogsite_name\",\"blogsite_authors\"],\r\n"
				+ "            \"query\" : \"" + term + "\"\r\n" + "        }\r\n" + "  },\r\n" + "   \"sort\":{\r\n"
				+ "		\"blogsite_id\":{\r\n" + "			\"order\":\"DESC\"\r\n" + "			}\r\n" + "		}\r\n"
				+ "}");

		String url = base_url + "_search?size=20";
		if (!from.equals("")) {
			jsonObj = new JSONObject("{\r\n" + "  \"query\": {\r\n" + "        \"query_string\" : {\r\n"
					+ "            \"fields\" : [\"blogsite_name\",\"blogsite_authors\"],\r\n"
					+ "            \"query\" : \"" + term + "\"\r\n" + "        }\r\n" + "  },\r\n"
					+ "   \"sort\":{\r\n" + "		\"blogpost_id\":{\r\n" + "			\"order\":\"DESC\"\r\n"
					+ "			}\r\n" + "		},\r\n" + " \"range\":{\r\n" + "		\"blogpost_id\":{\r\n"
					+ "			\"lte\":\"" + from + "\",\r\n" + "			\"gte\":\"" + 0 + "\"\r\n"
					+ "			}\r\n" + "		}\r\n" + "}");
		}

		return this._getResult(url, jsonObj);
	}

	public String _searchRangeAggregate(String field, String greater, String less, String terms) throws Exception {
		String[] args = terms.split(",");
		JSONArray pars = new JSONArray();
		ArrayList<String> ar = new ArrayList<String>();
		for (int i = 0; i < args.length; i++) {
			pars.put(args[i].toLowerCase());
		}

		String arg2 = pars.toString();
		// String range = "\"range\" : {\"sentiment\" : {\"gte\" : "+greater+",\"lte\" :
		// "+less+"}}";

		String que = "{\r\n" + "  \"query\": {\r\n" + "    \"bool\": {\r\n" + "      \"must\": [\r\n" + "        {\r\n"
				+ "		  \"constant_score\":{\r\n" + "					\"filter\":{\r\n"
				+ "							\"terms\":{\r\n" + "							\"term\":" + arg2 + "\r\n"
				+ "									}\r\n" + "							}\r\n"
				+ "						}\r\n" + "		},\r\n" + "        {\r\n" + "		  \"range\" : {\r\n"
				+ "            \"" + field + "\" : {\r\n" + "                \"gte\" : " + greater + ",\r\n"
				+ "                \"lte\" : " + less + ",\r\n" + "				},\r\n" + "			}\r\n"
				+ "		}\r\n" + "      ]\r\n" + "    }\r\n" + "  },\r\n" + "    \"aggs\" : {\r\n"
				+ "        \"total\" : { \"sum\" : { \"field\" : \"frequency\" } }\r\n" + "    }\r\n" + "}";

		JSONObject jsonObj = new JSONObject(que);

		String url = base_url + "_search?size=1";
		return this._getAggregate(url, jsonObj);
	}

	public String _searchRangeTotal(String field, String greater, String less, String terms) throws Exception {
		String[] args = terms.split(",");
		JSONArray pars = new JSONArray();
		ArrayList<String> ar = new ArrayList<String>();
		for (int i = 0; i < args.length; i++) {
			pars.put(args[i].toLowerCase());
		}

		String arg2 = pars.toString();
		// String range = "\"range\" : {\"sentiment\" : {\"gte\" : "+greater+",\"lte\" :
		// "+less+"}}";
		String que = "{\r\n" + "  \"query\": {\r\n" + "    \"bool\": {\r\n" + "      \"must\": [\r\n" + "        {\r\n"
				+ "		  \"constant_score\":{\r\n" + "					\"filter\":{\r\n"
				+ "							\"terms\":{\r\n" + "							\"term\":" + arg2 + "\r\n"
				+ "									}\r\n" + "							}\r\n"
				+ "						}\r\n" + "		},\r\n" + "        {\r\n" + "		  \"range\" : {\r\n"
				+ "            \"" + field + "\" : {\r\n" + "                \"gte\" : " + greater + ",\r\n"
				+ "                \"lte\" : " + less + ",\r\n" + "				},\r\n" + "			}\r\n"
				+ "		}\r\n" + "      ]\r\n" + "    }\r\n" + "  }\r\n" + "}";
		JSONObject jsonObj = new JSONObject(que);

		String url = base_url + "_search";
		return this._getTotal(url, jsonObj);
	}

	public ArrayList _fetch(String ids) throws Exception {
		ArrayList result = new ArrayList();
		String[] args = ids.split(",");

		JSONArray pars = new JSONArray();
		ArrayList<String> ar = new ArrayList<String>();
		for (int i = 0; i < args.length; i++) {
			pars.put(args[i].replaceAll(" ", ""));
		}

		String arg2 = pars.toString();

		// String que = "{\"query\":
		// {\"constant_score\":{\"filter\":{\"terms\":{\"blogsiteid\":"+arg2+"}}}}}";
		String que = "{\"query\": {\"constant_score\":{\"filter\":{\"terms\":{\"id\":" + arg2
				+ "}}}},\"sort\":{\"date\":{\"order\":\"DESC\"}}}";

		JSONObject jsonObj = new JSONObject(que);
		String url = base_url + "_search";
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

			BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
			String inputLine;
			StringBuffer response = new StringBuffer();

			while ((inputLine = in.readLine()) != null) {
				response.append(inputLine);
			}
			in.close();

			JSONObject myResponse = new JSONObject(response.toString());

			if (null != myResponse.get("hits")) {
				String res = myResponse.get("hits").toString();
				JSONObject myRes1 = new JSONObject(res);
				JSONArray jsonArray = new JSONArray(myRes1.get("hits").toString());
				if (jsonArray != null) {
					int len = jsonArray.length();
					for (int i = 0; i < len; i++) {
						list.add(jsonArray.get(i).toString());
					}
				}
			}
		} catch (Exception ex) {
		}
		/* System.out.println(list); */
		return list;
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

			// add request header
			// con.setRequestProperty("User-Agent", "Mozilla/5.0");
			int responseCode = con.getResponseCode();

			BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
			String inputLine;
			StringBuffer response = new StringBuffer();

			while ((inputLine = in.readLine()) != null) {
				response.append(inputLine);

			}
			in.close();

			JSONObject myResponse = new JSONObject(response.toString());
			ArrayList<String> list = new ArrayList<String>();
			// System.out.println(myResponse.get("hits"));
			if (null != myResponse.get("hits")) {
				String res = myResponse.get("hits").toString();
				JSONObject myRes1 = new JSONObject(res);
				total = myRes1.get("total").toString();
			}
		} catch (Exception ex) {
		}
		return total;
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

			// add request header
			// con.setRequestProperty("User-Agent", "Mozilla/5.0");
			int responseCode = con.getResponseCode();

			BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
			String inputLine;
			StringBuffer response = new StringBuffer();

			while ((inputLine = in.readLine()) != null) {
				response.append(inputLine);

			}
			in.close();

			JSONObject myResponse = new JSONObject(response.toString());
			ArrayList<String> list = new ArrayList<String>();
			// System.out.println(myResponse.get("hits"));
			if (null != myResponse.get("aggregations")) {
				String res = myResponse.get("aggregations").toString();
				JSONObject myRes1 = new JSONObject(res);

				String res2 = myRes1.get("total").toString();

				JSONObject myRes2 = new JSONObject(res2);
				total = myRes2.get("value").toString();
			}
		} catch (Exception ex) {
		}
		return total;
	}

	public Integer getTermOcuurence(String term, String start_date, String end_date) {
		String tres = null;
		JSONObject tresp = null;
		String tresu = null;
		JSONObject tobj = null;
		int alloccurence = 0;
		int k = 0;
		Blogposts post = new Blogposts();
		try {
			ArrayList allposts = post._searchByTitleAndBody(term, "date", start_date, end_date);// term._searchByRange("date",dt,dte,
																								// tm,"term","10");

			for (int i = 0; i < allposts.size(); i++) {
				tres = allposts.get(i).toString();
				tresp = new JSONObject(tres);
				tresu = tresp.get("_source").toString();
				tobj = new JSONObject(tresu);

				int bodyoccurencece = 0;// ut.countMatches(tobj3.get("post").toString(), mostactiveterm);
				String str = tobj.get("post").toString() + " " + tobj.get("post").toString();
				str = str.toLowerCase();
				term = term.toLowerCase();
				String findStr = term;
				int lastIndex = 0;
				// int count = 0;

				while (lastIndex != -1) {

					lastIndex = str.indexOf(findStr, lastIndex);

					if (lastIndex != -1) {
						bodyoccurencece++;
						alloccurence += bodyoccurencece;
						lastIndex += findStr.length();
					}
				}
			}
		} catch (Exception ex) {
		}
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

	public JSONObject _makeElasticRequest(JSONObject query, String requestType, String endPoint) throws Exception {

		JSONObject myResponse = new JSONObject();
		RestClient esClient = RestClient.builder(new HttpHost(elasticUrl, 9200, "http"), new HttpHost(elasticUrl, 9201, "http")).build();
		try {

			
			Request request = new Request(requestType, endPoint);
			request.setJsonEntity(query.toString());
//System.out.println(request);
			Response response = esClient.performRequest(request);
			
			String jsonResponse = EntityUtils.toString(response.getEntity());
			myResponse = new JSONObject(jsonResponse);
//			System.out.println("---"+myResponse);
			esClient.close();
//			return myResponse;

		} catch (Exception e) {
			esClient.close();
			System.out.println("Error for elastic request -- > "+e);
		}
		esClient.close();
		return myResponse;

	}

	public JSONObject _scrollRequest(String scrollID) throws Exception {
		JSONObject result = new JSONObject();
		JSONObject query = new JSONObject(
				"{\r\n" + "    \"scroll\" : \"1m\", \r\n" + "    \"scroll_id\" : \"" + scrollID + "\" \r\n" + "}");

		result = this._makeElasticRequest(query, "POST", "_search/scroll");

		return result;
	}

	public synchronized JSONArray merge(JSONArray jsonArray, JSONArray jsonArray1, String type) {
//		List<Tuple2<String, Integer>> returnedData = Collections
//				.synchronizedList(new ArrayList<Tuple2<String, Integer>>());
		try {

			// check to perform stream or check normal array or check best way to store ES
			// hits
			if (type.contentEquals("all")) {
				for (int i = 0; i < jsonArray1.length(); i++) {
					JSONObject jsonObject = jsonArray1.getJSONObject(i);
					jsonArray.put(jsonObject);
				}
				//return jsonArray;
			} 

			

		} catch (JSONException e) {
			e.printStackTrace();
		}
		
		return jsonArray;
	}

	public <K, V extends Comparable<? super V>> List<Entry<K, V>> entriesSortedByValues(Map<K, V> map) {

		List<Entry<K, V>> sortedEntries = new ArrayList<Entry<K, V>>(map.entrySet());

		Collections.sort(sortedEntries, new Comparator<Entry<K, V>>() {
			@Override
			public int compare(Entry<K, V> e1, Entry<K, V> e2) {
				return e2.getValue().compareTo(e1.getValue());
			}
		});

		return sortedEntries;
	}

	public Map<String, Integer> wrangleDatadata2(JSONArray postarray, String field, int start, int end) {
//		List<Tuple2<String, Integer>> returnedData = new ArrayList<Tuple2<String, Integer>>();
//		ConcurrentSkipListMap<String, Integer> m = new ConcurrentSkipListMap<String, Integer>();
//		HashMap<String, Integer> m = new HashMap<String, Integer>();
		Map<String, Integer> m = Collections.synchronizedMap(new HashMap<String, Integer>());
//		ConcurrentHashMap<String, Integer> m = new ConcurrentHashMap<String, Integer>();
		String result = null;
//		int count_ = 0;
		for (int i = start; i < end; i++) {
			String indx = postarray.get(i).toString();
			JSONObject j1 = new JSONObject(indx);
			String ids = j1.get("_source").toString();
			JSONObject j2 = new JSONObject(ids);
			String terms = j2.get(field).toString();

			String val = terms;
//			System.out.println(val);

//			try {
//			JSONArray t = new JSONArray(val);
////			System.out.println(t.length());
//			}catch(Exception e) {
//				System.out.println("error--" + e);
//				System.out.println("error--" + val);
//			}

			result = val.replace("[", "").replace("]", "");
			String[] spl = result.split("\\),");
//			System.out.println(spl.length);
//			count_ = count_ + spl.length;

			for (String v : spl) {
				if (!terms.equals("BLANK")) {
					String newstr = v.replace("(", "").replace(")", "");
					String[] tsplit = newstr.split(",");
					int val2 = Integer.parseInt(tsplit[1].trim());

					String first = tsplit[0].replace("\'", "").trim();
					Integer second = val2;

					// Tuple2<String, Integer> pair = new Tuple2(first, second);
//				returnedData.add(pair);
//					this.datatuple.add(pair);
					if (!m.containsKey(first)) {
						m.put(first, second);
					} else {
						int m_val = m.get(first);
						int new_mval = m_val + second;
						m.put(first, new_mval);
					}

				}
//				else {
//					Tuple2<String, Integer> pair = new Tuple2("__BLANK__", 1);
//					this.datatuple.add(pair);
//				}
			}
		}
		System.out.println("done");

		
//		.entrySet().iterator().next();
		List<Entry<String, Integer>> entry = entriesSortedByValues(m);
//		String key = entry.getKey();
//		Integer value = entry.getValue();
		System.out.println(entry.get(0));
		return m;
//		this.datatuple = returnedData;
//		System.out.println(count_);
//		System.out.println(datatuple.size());
//		return returnedData;
	}

	public synchronized List<Tuple2<String, Integer>> dtuple(JSONArray jsonArray, int start, int end) {
		List<Tuple2<String, Integer>> datatuple_ = new ArrayList<Tuple2<String, Integer>>();

		String blogsiteid = null;
		String blogpost_id = null;
		String terms = null;
		String result = null;
		String topterm = null;
		String date = null;
		for (int i = start; i < end; i++) {
			String indx = jsonArray.get(i).toString();
			JSONObject j1 = new JSONObject(indx);
			String ids = j1.get("_source").toString();
//System.out.println();
			JSONObject j2 = new JSONObject(ids);

			blogsiteid = j2.get("blogsiteid").toString();
			blogpost_id = j2.get("blogpost_id").toString();
			terms = j2.get("terms").toString();
			date = j2.get("date").toString();

			// process terms
			String val = terms;
			result = val.replace("[", "").replace("]", "");
			String[] spl = result.split("\\),");

			// perform stream
			Arrays.asList(spl).parallelStream().forEach(v -> {
				String newstr = v.replace("(", "").replace(")", "");
				String[] tsplit = newstr.split(",");
				int val2 = Integer.parseInt(tsplit[1].trim());

				Tuple2<String, Integer> pair = new Tuple2(tsplit[0].replace("\'", "").trim(), val2);
				datatuple_.add(pair);
			});

//		this.datatuple = data;
			topterm = j2.get("topterm").toString();

//		Object date_json = j1.getJSONObject("fields").getJSONArray("date").get(0);
//		date = date_json.toString();
		}
		return datatuple_;
	}

	public ArrayList<JSONObject> _buildSlicedScrollQuery(JSONObject query) throws Exception {
		ArrayList<JSONObject> result = new ArrayList<JSONObject>();

		for (int i = 0; i < 10; i++) {

		}
		return result;
	}

	@Override
	public void run() {
		// TODO Auto-generated method stub

	}

	public String _count(JSONObject query, String url) {
		String total = null;
		JSONObject myResponse;
		try {
			myResponse = this._makeElasticRequest(query, "POST", url);
			System.out.println(myResponse);
			if (null != myResponse.get("count")) {
				Object hits = myResponse.get("count");
				total = hits.toString();
			}
			
			System.out.println("count query" + query);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return total;
	}

	public JSONObject _elastic(JSONObject query) throws Exception {

		ArrayList<String> list = new ArrayList<String>();

		String source = null;

		System.out.println("this is the query-" + query);
		JSONArray jsonArray = new JSONArray();

		JSONObject all_data = new JSONObject();

		JSONObject myResponse = this._makeElasticRequest(query, "POST", "/blogpost_terms/_search/?scroll=1m");

		// System.out.println(hm.get("elasticIndex") + "==" + "==" + query);

		JSONArray allhits = new JSONArray();
		JSONObject scrollResult = new JSONObject();

		String scroll_id = null;

		if (null != myResponse.get("hits")) {

			Object hits = myResponse.getJSONObject("hits").getJSONArray("hits");
			Object total = myResponse.getJSONObject("hits").getJSONObject("total").get("value");
			source = hits.toString();

			jsonArray = merge(jsonArray, new JSONArray(source), "all");

			System.out.println("DONE GETTING POSTS FOR BLOGGER");

			scroll_id = (String) myResponse.get("_scroll_id");

			scrollResult = this._scrollRequest(scroll_id);
			allhits = scrollResult.getJSONObject("hits").getJSONArray("hits");
			source = allhits.toString();
			jsonArray = merge(jsonArray, new JSONArray(source), "all");
			// jsonArray.put(new JSONArray(source));

			for (int i = 0; i < jsonArray.length(); i++) {

				if (allhits.length() <= 0) {
					break;
				}
//			while (allhits.length() > 0) {
				System.out.println("WHILE ---" + allhits.length());
				scroll_id = (String) scrollResult.get("_scroll_id");
				scrollResult = this._scrollRequest(scroll_id);
				allhits = scrollResult.getJSONObject("hits").getJSONArray("hits");
				source = allhits.toString();

				jsonArray = merge(jsonArray, new JSONArray(source), "all");
				// jsonArray.put(new JSONArray(source));
			}

			all_data.put("total", total.toString());
			all_data.put("hit_array", jsonArray);

		}
		System.out.println("DONE");
		return all_data;
	}

//	int arg1 = 10;
//	String arg2 = "foo";
//	Function<String, String> partialFunction = (str) -> callbackFunction.apply(arg1, arg2, str);
//	stringList.parallelStream().map(partialFunction);

	public static String applyFunction(String name, Function<String, String> function) {
		return function.apply(name);
	}

	List<Tuple2<String, Integer>> datatuple = new ArrayList<Tuple2<String, Integer>>();

	public JSONObject _getTerms(String term, String bloggerName, String date_from, String date_to, String ids_)
			throws Exception {
//	
		ArrayList<String> list = new ArrayList<String>();
		ArrayList<String> _idlist = new ArrayList<String>();
		String result = null;

		JSONObject all_data = new JSONObject();
		JSONObject posts_occured_data = new JSONObject();

//		this._getTerms(term, bloggerName, date_from, date_to, ids_)
		JSONObject query = new JSONObject();
		List<Tuple2<String, Integer>> data = new ArrayList<Tuple2<String, Integer>>();
		if (bloggerName != "__NOBLOGGER__") {

			query = new JSONObject("");

		} else if (term == "___NO__TERM___" && bloggerName == "__NOBLOGGER__") {
			query = new JSONObject("{\r\n" + "    \"size\": 10000,\r\n" + "    \"query\": {\r\n"
					+ "        \"bool\": {\r\n" + "            \"must\": [\r\n" + "                {\r\n"
					+ "                    \"terms\": {\r\n" + "                        \"blogsiteid\": [" + ids_
					+ "],\r\n" + "                        \"boost\": 1.0\r\n" + "                    }\r\n"
					+ "                },\r\n" + "                {\r\n" + "                    \"range\": {\r\n"
					+ "                        \"date\": {\r\n" + "                            \"from\": \"" + date_from
					+ "\",\r\n" + "                            \"to\": \"" + date_to + "\",\r\n"
					+ "                            \"include_lower\": true,\r\n"
					+ "                            \"include_upper\": true,\r\n"
					+ "                            \"boost\": 1.0\r\n" + "                        }\r\n"
					+ "                    }\r\n" + "                }\r\n" + "            ],\r\n"
					+ "            \"adjust_pure_negative\": true,\r\n" + "            \"boost\": 1.0\r\n"
					+ "        }\r\n" + "    },\r\n" + "    \"_source\": {\r\n" + "        \"includes\": [\r\n"
					+ "            \"@version\",\r\n" + "            \"blogpost_id\",\r\n"
					+ "            \"blogsiteid\",\r\n" + "            \"terms\",\r\n" + "            \"topterm\"\r\n"
					+ "        ],\r\n" + "        \"excludes\": []\r\n" + "    },\r\n"
					+ "    \"docvalue_fields\": [\r\n" + "        {\r\n" + "            \"field\": \"@timestamp\",\r\n"
					+ "            \"format\": \"epoch_millis\"\r\n" + "        },\r\n" + "        {\r\n"
					+ "            \"field\": \"date\",\r\n" + "            \"format\": \"yyyy-mm-dd\"\r\n"
					+ "        }\r\n" + "    ],\r\n" + "    \"sort\": [\r\n" + "        {\r\n"
					+ "            \"_doc\": {\r\n" + "                \"order\": \"asc\"\r\n" + "            }\r\n"
					+ "        }\r\n" + "    ]\r\n" + "}");
		} else {
			query = new JSONObject("");
		}

//		System.out.println("query for elastic _getBloggerPosts --> " + query);

		JSONObject elas = this._elastic(query);
		JSONArray jsonArray = (JSONArray) elas.getJSONArray("hit_array");

		String total = elas.get("total").toString();
		String blogpost_id = null;
		String blogsiteid = null;
		String terms = null;
		String topterm = null;
		String date = null;

		JSONArray all = new JSONArray();

		System.out.println("DONE GETTING POSTS FOR BLOGGER");
		if (jsonArray != null) {

			// check to perform stream on jsonarry or convert to normal array(doubt)
			for (int i = 0; i < jsonArray.length(); i++) {
				String indx = jsonArray.get(i).toString();
				JSONObject j1 = new JSONObject(indx);
				String ids = j1.get("_source").toString();

				JSONObject j2 = new JSONObject(ids);

				blogsiteid = j2.get("blogsiteid").toString();
				blogpost_id = j2.get("blogpost_id").toString();
				terms = j2.get("terms").toString();

				// process terms
				String val = terms;
				result = val.replace("[", "").replace("]", "");
				String[] spl = result.split("\\),");

				// perform stream
				Arrays.asList(spl).parallelStream().forEach(v -> {
					String newstr = v.replace("(", "").replace(")", "");
					String[] tsplit = newstr.split(",");
					int val2 = Integer.parseInt(tsplit[1].trim());

					Tuple2<String, Integer> pair = new Tuple2(tsplit[0].replace("\'", "").trim(), val2);
					data.add(pair);
				});

				this.datatuple = data;
				topterm = j2.get("topterm").toString();

				Object date_json = j1.getJSONObject("fields").getJSONArray("date").get(0);
				date = date_json.toString();

			}
		}
		return all_data;
	}

	public List<Tuple2<String, Integer>> getTupleData() throws Exception {
		return this.datatuple;
	}

	public int compare(Tuple2<String, Integer> x, Tuple2<String, Integer> y) {
		return Integer.compare(x._2(), y._2());
	}

	public String mapReduce(List<Tuple2<String, Integer>> data, String type) throws Exception {
		JavaPairRDD<String, Integer> result = null;
		String result2 = null;
		SparkConf conf = new SparkConf().setMaster("local[6]").setAppName("Example");
//		SparkConf conf = new SparkConf().setMaster("spark://144.167.35.50:4042").setAppName("Example").set("spark.ui.port","4042");
//		conf.set("spark.driver.memory", "64g");
		JavaSparkContext sc = new JavaSparkContext(conf);
		try {

//			data.stream().collect(Collectors.groupingBy(Tuple2::getKey, Collectors.mapping(Tuple2::getValue, Collectors.toList())));
//			data.parallelStream().reduce((int a, int b) -> a+b);
//			data.parallelStream().filter(x -> x._2 > 10 ).forEach(System.out::println);
			JavaRDD rdd = sc.parallelize(data);
			JavaPairRDD<String, Integer> pairRdd = JavaPairRDD.fromJavaRDD(rdd);

			ArrayList<Tuple2<String, Integer>> test = new ArrayList<Tuple2<String, Integer>>();

			if (type.contentEquals("topterm")) {
				System.out.println("i am here");
				System.out.println(data.size());
				// System.out.println(data.parallelStream().max(new DummyComparator()));
//				System.out.println(pairRdd.groupByKey().toString());
//				result2 = pairRdd.reduceByKey((a, b) -> (a + b)).max(new DummyComparator())._1().toString();
				result2 = pairRdd.reduceByKey((a, b) -> (a + b)).max(new DummyComparator()).toString();
//				result = pairRdd.reduceByKey((a,b) -> (a + b));

//				for (JavaPairRDD<String, Integer> tuple2 : pairRdd) {
//					
//				}
				sc.stop();
//				System.out.println(result.max(new DummyComparator()));
//				return result;
			} else if (type.contentEquals("dashboard")) {
//				result2 = pairRdd.reduceByKey((a, b) -> (a + b)).takeOrdered(100, TupleTakeOrder.INSTANCE).toString();
				result2 = pairRdd.reduceByKey((a, b) -> (a + b)).toString();
//				return result;
//				System.out.println(result);
				sc.stop();
				return result2;

			} else {
				result2 = pairRdd.reduceByKey((a, b) -> (a + b))
						.takeOrdered(Integer.parseInt(type), TupleTakeOrder.INSTANCE).toString();
				sc.stop();
				return result2;
			}
			// System.out.println();

		} catch (Exception e) {
			System.out.println(e);
		}

		return result2;

	}

	public Terms() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		// doGet(request, response);
		PrintWriter out = response.getWriter();

		Clustering cluster = new Clustering();
		HttpSession session = request.getSession();

//		Map<String, Integer> result = new HashMap<String, Integer>();
		String output = null;
		Object action = (null == request.getParameter("action")) ? "" : request.getParameter("action");
		Object date_start = (null == request.getParameter("date_start")) ? "" : request.getParameter("date_start");
		Object date_end = (null == request.getParameter("date_end")) ? "" : request.getParameter("date_end");
		Object blogger = (null == request.getParameter("blogger")) ? "" : request.getParameter("blogger");

		Object all_bloggers = (null == request.getParameter("all_bloggers")) ? ""
				: request.getParameter("all_bloggers");

		Object post_ids = (null == request.getParameter("post_ids")) ? "" : request.getParameter("post_ids");
		Object ids = (null == request.getParameter("ids")) ? "" : request.getParameter("ids");
		JSONArray out_ = new JSONArray();
		JSONObject o = new JSONObject();

		if (action.toString().equals("getkeyworddashboard")) {
			System.out.println("action is getkeyworddashboard and ids are " + ids.toString());
			try {
				JSONObject output_ = new JSONObject();
				o = cluster.getTopTermsFromBlogIds(ids.toString(), date_start.toString(), date_end.toString(),"100");
//				out_ = (JSONArray) o.get("output");

//				String result = out_.toString().replaceAll("\"", "");
//				output_.put(key, value);
				//JSONObject ttt = (JSONObject) o.get("post_id_term_pair");
				//System.out.println("keyssssss--" + ttt.keySet());
				JSONObject pp = (JSONObject)o.get("post_id_post");
				System.out.println("pp --" + pp.length());
				if(pp.length() > 0) {
					
				session.setAttribute(ids.toString() + "--" + action.toString(), o);
				}
//				for (Tuple2<String, Integer> x : data) {
//					result.put(x._1, x._2);
//				}
			} catch (Exception e) {

			}
			System.out.println("dashboard output");
			out.write(o.toString());
		} else if (action.toString().equals("gethighestterms")) {
			try {
				o = cluster.getTopTermsFromBlogIds(ids.toString(), date_start.toString(), date_end.toString(),"1");
				out_ = (JSONArray) o.get("output");
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			out.write(out_.toString().replaceAll("\"", ""));
		}else if (action.toString().equals("getbloggerhighestterms")) {
			try {
				output = cluster.getTopTermsBlogger(blogger.toString(), date_start.toString(), date_end.toString(),
						"1");
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			out.write(output.toString());
		}
			
	}

}