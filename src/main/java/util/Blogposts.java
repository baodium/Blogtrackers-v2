package util;

import java.io.BufferedReader;
import java.io.DataOutputStream;
//import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import org.json.JSONObject;

/*import com.mysql.jdbc.Connection;*/

import java.util.*;

import authentication.DbConnection;

import org.apache.http.HttpHost;
import org.apache.http.util.EntityUtils;
//import org.apache.http.HttpEntity;
//import org.apache.http.HttpHost;
//import org.apache.http.entity.ContentType;
//import org.apache.http.nio.entity.NStringEntity;
import org.elasticsearch.client.*;
//import org.elasticsearch.client.RestHighLevelClient;
//import org.elasticsearch.transport.InboundMessage.Response;
import org.json.JSONArray;

import java.io.OutputStreamWriter;

public class Blogposts {

	HashMap<String, String> hm = DbConnection.loadConstant();

	String base_url = hm.get("elasticIndex") + "blogposts/"; // - For testing server

	String base_url_test = "http://144.167.115.90:9200/blogposts/";

	Stopwords stop = new Stopwords();

	String totalpost;

	String date;

//	RestHighLevelClient client = new RestHighLevelClient(
//	        RestClient.builder(
//	                new HttpHost("localhost", 9200, "http"),
//	                new HttpHost("localhost", 9201, "http")));
//
//	RestClient restClient = RestClient.builder(
//			new HttpHost("localhost",9200,"http"),
//			new HttpHost("localhost",9201,"http")).build();
//	
//	restClient.close();

	public ArrayList _list(String order, String from, String sortby) throws Exception {
		int size = 20;
		int fr = 0;

		JSONObject jsonObj = new JSONObject("{\r\n" + "    \"query\": {\r\n" + "        \"match_all\": {}\r\n"
				+ "    },\r\n" + "	\"sort\":{\r\n" + "		\"" + sortby + "\":{\r\n" + "			\"order\":\""
				+ order + "\"\r\n" + "			}\r\n" + "		}\r\n" + "}");

		if (!from.equals("")) {
			fr = Integer.parseInt(from) * size;
			jsonObj = new JSONObject("{\r\n" + "    \"query\": {\r\n" + "        \"match_all\": {}\r\n" + "    },\r\n"
					+ "  	\"from\":" + fr + "," + "	\"size\":" + size + "," + "   \"sort\":{\r\n" + "		\""
					+ sortby + "\":{\r\n" + "			\"order\":\"" + order + "\"\r\n" + "			}\r\n"
					+ "		},\r\n" + "}");

		}

		String url = base_url + "_search?size=" + size + "&from=" + fr;
		System.out.println("ress--" + jsonObj);
		return this._getResult(url, jsonObj);

	}

	public String _getTotal() {
		return this.totalpost;
	}

	public ArrayList _getBloggerByBlogId(String field, String greater, String less, String blog_ids) throws Exception {

		String url = base_url + "_search";
		String[] args = blog_ids.split(",");
		JSONArray pars = new JSONArray();
		ArrayList<String> ar = new ArrayList<String>();
		for (int i = 0; i < args.length; i++) {
			pars.put(args[i].replaceAll(" ", ""));
		}

		String arg2 = pars.toString();
		// String que = "{\"query\":
		// {\"constant_score\":{\"filter\":{\"terms\":{\"blogsite_id\":"+arg2+"}}}},\"sort\":{\"date\":{\"order\":\"ASC\"}}}";
		String que = "{\r\n" + "	\"size\":50,\r\n" + "		\"sort\":{ \r\n" + "			\"date\":{\r\n"
				+ "				\"order\":\"asc\"\r\n" + "				}\r\n" + "	},\r\n" + "	\"query\": { \r\n"
				+ "			 \"bool\": {\r\n" + "				      \"must\": [\r\n" + "				      	{\r\n"
				+ "						  \"constant_score\":{ \r\n"
				+ "									\"filter\":{ \r\n"
				+ "											\"terms\":{ \r\n"
				+ "												\r\n"
				+ "											\"blogsite_id\":" + arg2 + "\r\n"
				+ "													}\r\n"
				+ "											}\r\n" + "										} \r\n"
				+ "						}, \r\n" + "						\r\n" + "	 		        { \r\n"
				+ "	 				  \"range\" : { \r\n" + "	 		            \"date\" : { \r\n"
				+ "	 		                \"gte\" : " + greater + ",\r\n" + "	 		                \"lte\" : "
				+ less + ",\r\n" + "	 						}\r\n" + "	 					} \r\n"
				+ "	 				} \r\n" + "	 		      ] \r\n" + "	 		    } \r\n" + "	 		  \r\n"
				+ "            }\r\n" + "	 	\r\n" + "}";

//		String que="{\r\n" + 
//				"  \"query\": {\r\n" + 
//				"    \"bool\": {\r\n" + 
//				"      \"must\": [\r\n" + 
//				"        {\r\n" + 
//				"		  \"constant_score\":{\r\n" + 
//				"					\"filter\":{\r\n" + 
//				"							\"terms\":{\r\n" + 
//				"							\"blogsite_id\":"+arg2+"\r\n" + 
//				"									}\r\n" + 
//				"							}\r\n" + 
//				"						}\r\n" + 
//				"		},\r\n" + 
//				"        {\r\n" + 
//				"		  \"range\" : {\r\n" + 
//				"            \""+field+"\" : {\r\n" + 
//				"                \"gte\" : "+greater+",\r\n" + 
//				"                \"lte\" : "+less+",\r\n" + 
//				"				},\r\n" +
//				"			}\r\n" + 
//				"		}\r\n" + 
//				"      ]\r\n" + 
//				"    }\r\n" + 
//				"  }\r\n" + 
//				"}";

		JSONObject jsonObj = new JSONObject(que);
		ArrayList result = this._getResult(url, jsonObj);

		return this._getResult(url, jsonObj);
	}

	public ArrayList _getPostByBlogpostId(String field, String greater, String less, JSONArray post_ids)
			throws Exception {

		String url = base_url + "_search";

		/*
		 * String[] args = post_ids.split(","); JSONArray pars = new JSONArray();
		 * ArrayList<String> ar = new ArrayList<String>(); for(int i=0; i<args.length;
		 * i++){ pars.put(args[i].replaceAll(" ", "")); }
		 */

		String arg2 = post_ids.toString();
		String que = "{\r\n" + "	\"size\":50,\r\n" + "		\"sort\":{ \r\n" + "			\"date\":{\r\n"
				+ "				\"order\":\"asc\"\r\n" + "				}\r\n" + "	},\r\n" + "	\"query\": { \r\n"
				+ "			 \"bool\": {\r\n" + "				      \"must\": [\r\n" + "				      	{\r\n"
				+ "						  \"constant_score\":{ \r\n"
				+ "									\"filter\":{ \r\n"
				+ "											\"terms\":{ \r\n"
				+ "												\r\n"
				+ "											\"blogpost_id\":" + arg2 + "\r\n"
				+ "													}\r\n"
				+ "											}\r\n" + "										} \r\n"
				+ "						}, \r\n" + "						\r\n" + "	 		        { \r\n"
				+ "	 				  \"range\" : { \r\n" + "	 		            \"date\" : { \r\n"
				+ "	 		                \"gte\" : " + greater + ",\r\n" + "	 		                \"lte\" : "
				+ less + ",\r\n" + "	 						}\r\n" + "	 					} \r\n"
				+ "	 				} \r\n" + "	 		      ] \r\n" + "	 		    } \r\n" + "	 		  \r\n"
				+ "            }\r\n" + "	 	\r\n" + "}";

		JSONObject jsonObj = new JSONObject(que);
		ArrayList result = this._getResult(url, jsonObj);

		return this._getResult(url, jsonObj);
	}

	public ArrayList _getBloggerByBloggerName(String field, String greater, String less, String bloggers)
			throws Exception {

		int size = 50;
		DbConnection db = new DbConnection();
		String count = "0";
		System.out.println("SELECT *  FROM blogposts WHERE blogger = '" + bloggers + "' AND " + field + ">='" + greater
				+ "' AND " + field + "<='" + less + "' ORDER BY date ASC LIMIT " + size + "");

		ArrayList result = new ArrayList();
		try {
			result = db.queryJSON("SELECT *  FROM blogposts WHERE blogger = '" + bloggers + "' AND " + field + ">="
					+ greater + " AND " + field + "<=" + less + " ORDER BY date ASC LIMIT " + size + "");

		} catch (Exception e) {
			return result;
		}

		return result;
		/*
		 * 
		 * String url = base_url+"_search?size=20"; String[] args = bloggers.split(",");
		 * JSONArray pars = new JSONArray(); ArrayList<String> ar = new
		 * ArrayList<String>(); for(int i=0; i<args.length; i++){ pars.put(args[i]); }
		 * 
		 * String arg2 = pars.toString(); //String que =
		 * "{\"query\": {\"constant_score\":{\"filter\":{\"terms\":{\"blogsite_id\":"
		 * +arg2+"}}}},\"sort\":{\"date\":{\"order\":\"ASC\"}}}"; /* String que="{\r\n"
		 * + "  \"query\": {\r\n" + "    \"bool\": {\r\n" + "      \"must\": [\r\n" +
		 * "        {\r\n" + "		  \"constant_score\":{\r\n" +
		 * "					\"filter\":{\r\n" +
		 * "							\"terms\":{\r\n" +
		 * "							\"blogger\":"+bloggers+"\r\n" +
		 * "									}\r\n" +
		 * "							}\r\n" + "						}\r\n" +
		 * "		},\r\n" + "        {\r\n" + "		  \"range\" : {\r\n" +
		 * "            \""+field+"\" : {\r\n" +
		 * "                \"gte\" : "+greater+",\r\n" +
		 * "                \"lte\" : "+less+",\r\n" + "				},\r\n" +
		 * "			}\r\n" + "		}\r\n" + "      ]\r\n" + "    }\r\n" + "  }\r\n"
		 * + "}";
		 * 
		 */
		/*
		 * JSONObject jsonObj = new JSONObject("{\r\n" + "       \"query\": {\r\n" +
		 * "          \"bool\": { \r\n" + "               \"must\": {\r\n" +
		 * "                    \"query_string\" : {\r\n" +
		 * "            			\"fields\" : [\"blogger\"],\r\n" +
		 * "            			\"query\" : \""+bloggers+"\"\r\n" +
		 * "                    }\r\n" + "                },\r\n" +
		 * "                \"filter\": {\r\n" + "                    \"range\" : {\r\n"
		 * + "                        \"date\" : {\r\n" +
		 * "                            \"gte\": \""+greater+"\",\r\n" +
		 * "                            \"lte\": \""+less+"\"\r\n" +
		 * "                        }\r\n" + "                    }\r\n" +
		 * "                }\r\n" + "            }\r\n" + "        }\r\n" + "    }");
		 * 
		 * //JSONObject jsonObj = new JSONObject(que); ArrayList result =
		 * this._getResult(url, jsonObj); return this._getResult(url, jsonObj);
		 */
	}

	public String _getPostIdsByBloggerName(String field, String greater, String less, String bloggers, String sort,
			String order) throws Exception {
		int size = 50;
		DbConnection db = new DbConnection();
		String ids = "";
		ArrayList result = new ArrayList();
		ArrayList resut = new ArrayList();
		try {
			result = db.query("SELECT blogpost_id FROM blogposts WHERE blogger = '" + bloggers + "' AND " + field
					+ ">='" + greater + "' AND " + field + "<='" + less + "' ORDER BY " + sort + " " + order + " LIMIT "
					+ size + "");
			// result = db.queryJSON("SELECT * FROM blogposts WHERE blogger = '"+bloggers+"'
			// AND "+field+">="+greater+" AND "+field+"<="+less+" ORDER BY date ASC LIMIT
			// "+size+"");

		} catch (Exception e) {

		}

		for (int i = 0; i < result.size(); i++) {
			resut = (ArrayList) result.get(i);

			String id = resut.get(0).toString();
			ids += id + ",";

		}

		ids = ids.replaceAll(",$", "");
		ids = ids.replaceAll(", $", "");
		return ids;
	}

	public ArrayList _getBloggerByBloggerName(String field, String greater, String less, String bloggers, String sort,
			String order) throws Exception {
		int size = 50;
		DbConnection db = new DbConnection();
		String count = "0";
		ArrayList result = new ArrayList();
		try {
			result = db.queryJSON("SELECT *  FROM blogposts WHERE blogger = '" + bloggers + "' AND " + field + ">='"
					+ greater + "' AND " + field + "<='" + less + "' ORDER BY " + sort + " " + order + " LIMIT " + size
					+ "");
			// result = db.queryJSON("SELECT * FROM blogposts WHERE blogger = '"+bloggers+"'
			// AND "+field+">="+greater+" AND "+field+"<="+less+" ORDER BY date ASC LIMIT
			// "+size+"");

		} catch (Exception e) {
			return result;
		}

		return result;
		/*
		 * String url = base_url+"_search?size=20";
		 * 
		 * String[] args = bloggers.split(","); JSONArray pars = new JSONArray();
		 * ArrayList<String> ar = new ArrayList<String>(); for(int i=0; i<args.length;
		 * i++){ pars.put(args[i].toLowerCase()); }
		 * 
		 * String arg2 =pars.toString();
		 * 
		 * JSONObject jsonObj = new JSONObject("{\r\n" + "       \"query\": {\r\n" +
		 * "          \"bool\": { \r\n" + "               \"must\": {\r\n" +
		 * "                    \"query_string\" : {\r\n" +
		 * "            			\"fields\" : [\"blogger\"],\r\n" +
		 * "            			\"query\" : \""+bloggers+"\"\r\n" +
		 * "                    }\r\n" + "                },\r\n" +
		 * "                \"filter\": {\r\n" + "                    \"range\" : {\r\n"
		 * + "                        \"date\" : {\r\n" +
		 * "                            \"gte\": \""+greater+"\",\r\n" +
		 * "                            \"lte\": \""+less+"\"\r\n" +
		 * "                        }\r\n" + "                    }\r\n" +
		 * "                }\r\n" + "            }\r\n" + "        },\r\n" +
		 * "		\"sort\":{\r\n" + "		\""+sort+"\":{\r\n" +
		 * "			\"order\":\""+order+"\"\r\n" + "			}\r\n" +
		 * "		}\r\n" + "    }");
		 * 
		 * 
		 * //JSONObject jsonObj = new JSONObject(que); ArrayList result =
		 * this._getResult(url, jsonObj); return this._getResult(url, jsonObj);
		 */
	}

	public String _getTotalByBloggerName(String field, String greater, String less, String bloggers, String sort,
			String order) throws Exception {

		String count = "0";

		try {
			ArrayList response = DbConnection.query("SELECT count(*) as total FROM blogposts WHERE blogger = '"
					+ bloggers + "' AND " + field + ">='" + greater + "' AND " + field + "<='" + less + "' ");
			if (response.size() > 0) {
				ArrayList hd = (ArrayList) response.get(0);
				count = hd.get(0).toString();
			}
		} catch (Exception e) {
			return count;
		}

		return count;
		/*
		 * 
		 * String url = base_url+"_search?size=1";
		 * 
		 * String[] args = bloggers.split(","); JSONArray pars = new JSONArray();
		 * ArrayList<String> ar = new ArrayList<String>(); for(int i=0; i<args.length;
		 * i++){ pars.put(args[i].toLowerCase()); }
		 * 
		 * String arg2 =pars.toString();
		 * 
		 * JSONObject jsonObj = new JSONObject("{\r\n" + "       \"query\": {\r\n" +
		 * "          \"bool\": { \r\n" + "               \"must\": {\r\n" +
		 * "                    \"query_string\" : {\r\n" +
		 * "            			\"fields\" : [\"blogger\"],\r\n" +
		 * "            			\"query\" : \""+bloggers+"\"\r\n" +
		 * "                    }\r\n" + "                },\r\n" +
		 * "                \"filter\": {\r\n" + "                    \"range\" : {\r\n"
		 * + "                        \"date\" : {\r\n" +
		 * "                            \"gte\": \""+greater+"\",\r\n" +
		 * "                            \"lte\": \""+less+"\"\r\n" +
		 * "                        }\r\n" + "                    }\r\n" +
		 * "                }\r\n" + "            }\r\n" + "        },\r\n" +
		 * "		\"sort\":{\r\n" + "		\""+sort+"\":{\r\n" +
		 * "			\"order\":\""+order+"\"\r\n" + "			}\r\n" +
		 * "		}\r\n" + "    }");
		 * 
		 * ArrayList result = this._getResult(url, jsonObj); return this._getTotal(url,
		 * jsonObj);
		 */
	}

	public String _searchRangeAggregate(String field, String greater, String less, String blog_ids) throws Exception {
		/*
		 * DbConnection db = new DbConnection(); String count = "0"; blog_ids =
		 * blog_ids.replaceAll(",$", ""); blog_ids = blog_ids.replaceAll(", $", "");
		 * 
		 * blog_ids = "("+blog_ids+")"; try { ArrayList response = db.
		 * query("SELECT sum(influence_score) as total FROM blogposts WHERE blogsite_id IN "
		 * +blog_ids+" AND date>='"+greater+"' AND date<='"+less+"' ");
		 * if(response.size()>0){ ArrayList hd = (ArrayList)response.get(0); count =
		 * hd.get(0).toString(); } }catch(Exception e){ return count; }
		 * 
		 * return count;
		 */

		String[] args = blog_ids.split(",");
		JSONArray pars = new JSONArray();
		ArrayList<String> ar = new ArrayList<String>();
		for (int i = 0; i < args.length; i++) {
			pars.put(args[i].replaceAll(" ", ""));
		}

		String arg2 = pars.toString();
		// String range = "\"range\" : {\"sentiment\" : {\"gte\" : "+greater+",\"lte\" :
		// "+less+"}}";

		String que = "{\r\n" + "  \"query\": {\r\n" + "    \"bool\": {\r\n" + "      \"must\": [\r\n" + "        {\r\n"
				+ "		  \"constant_score\":{\r\n" + "					\"filter\":{\r\n"
				+ "							\"terms\":{\r\n" + "							\"blogsite_id\":" + arg2
				+ "\r\n" + "									}\r\n" + "							}\r\n"
				+ "						}\r\n" + "		},\r\n" + "        {\r\n" + "		  \"range\" : {\r\n"
				+ "            \"" + field + "\" : {\r\n" + "                \"gte\" : " + greater + ",\r\n"
				+ "                \"lte\" : " + less + ",\r\n" + "				},\r\n" + "			}\r\n"
				+ "		}\r\n" + "      ]\r\n" + "    }\r\n" + "  },\r\n" + "    \"aggs\" : {\r\n"
				+ "        \"total\" : { \"sum\" : { \"field\" : \"influence_score\" } }\r\n" + "    }\r\n" + "}";

		JSONObject jsonObj = new JSONObject(que);

		String url = base_url + "_search?size=1";
		return this._getAggregate(url, jsonObj);

	}

	public String _searchRangeAggregate(String field, String greater, String less, String blog_ids, String filter)
			throws Exception {
		/*
		 * DbConnection db = new DbConnection(); String count = "0"; blog_ids =
		 * blog_ids.replaceAll(",$", ""); blog_ids = blog_ids.replaceAll(", $", "");
		 * 
		 * blog_ids = "("+blog_ids+")"; try { ArrayList response =
		 * db.query("SELECT sum("
		 * +filter+") as total FROM blogposts WHERE blogsite_id IN "
		 * +blog_ids+" AND date>='"+greater+"' AND date<='"+less+"' ");
		 * if(response.size()>0){ ArrayList hd = (ArrayList)response.get(0); count =
		 * hd.get(0).toString(); } }catch(Exception e){ return count; }
		 * 
		 * return count;
		 */

		String[] args = blog_ids.split(",");
		JSONArray pars = new JSONArray();
		ArrayList<String> ar = new ArrayList<String>();
		for (int i = 0; i < args.length; i++) {
			pars.put(args[i].replaceAll(" ", ""));
		}

		String arg2 = pars.toString();
		// String range = "\"range\" : {\"sentiment\" : {\"gte\" : "+greater+",\"lte\" :
		// "+less+"}}";

		String que = "{\r\n" + "  \"query\": {\r\n" + "    \"bool\": {\r\n" + "      \"must\": [\r\n" + "        {\r\n"
				+ "		  \"constant_score\":{\r\n" + "					\"filter\":{\r\n"
				+ "							\"terms\":{\r\n" + "							\"blogsite_id\":" + arg2
				+ "\r\n" + "									}\r\n" + "							}\r\n"
				+ "						}\r\n" + "		},\r\n" + "        {\r\n" + "		  \"range\" : {\r\n"
				+ "            \"" + field + "\" : {\r\n" + "                \"gte\" : " + greater + ",\r\n"
				+ "                \"lte\" : " + less + ",\r\n" + "				},\r\n" + "			}\r\n"
				+ "		}\r\n" + "      ]\r\n" + "    }\r\n" + "  },\r\n" + "    \"aggs\" : {\r\n"
				+ "        \"total\" : { \"sum\" : { \"field\" : \"" + filter + "\" } }\r\n" + "    }\r\n" + "}";

		JSONObject jsonObj = new JSONObject(que);

		String url = base_url + "_search?size=1";
		return this._getAggregate(url, jsonObj);

	}

	public String _searchRangeAggregateByBloggers(String field, String greater, String less, String bloggers)
			throws Exception {

		String count = "0";
		// blog_ids = "("+blog_ids+")";
		try {
			ArrayList response = DbConnection
					.query("SELECT sum(influence_score) as total, blogger,date FROM blogposts WHERE blogger = '"
							+ bloggers + "' AND " + field + ">='" + greater + "' AND " + field + "<='" + less
							+ "' ORDER BY influence_score DESC LIMIT 1");
			//
			// ArrayList response = DbConnection.query("SELECT max(influence_score) as
			// total, blogger,date FROM blogposts WHERE blogger = '"+bloggers+"' ORDER BY
			// influence_score DESC LIMIT 1");

			if (response.size() > 0) {
				ArrayList hd = (ArrayList) response.get(0);
				// System.out.println("resp:"+response);
				count = hd.get(0).toString();
			}
		} catch (Exception e) {
			return count;
		}

		return count;

		/*
		 * String[] args = bloggers.split(","); JSONArray pars = new JSONArray();
		 * ArrayList<String> ar = new ArrayList<String>(); for(int i=0; i<args.length;
		 * i++){ pars.put(args[i].toLowerCase()); }
		 * 
		 * String arg2 = pars.toString(); // String range =
		 * "\"range\" : {\"sentiment\" : {\"gte\" : "+greater+",\"lte\" : "+less+"}}";
		 * 
		 * String que="{\r\n" + "  \"query\": {\r\n" + "    \"bool\": {\r\n" +
		 * "      \"must\": [\r\n" + "        {\r\n" +
		 * "		  \"constant_score\":{\r\n" + "					\"filter\":{\r\n" +
		 * "							\"terms\":{\r\n" +
		 * "							\"blogger\":"+bloggers+"\r\n" +
		 * "									}\r\n" +
		 * "							}\r\n" + "						}\r\n" +
		 * "		},\r\n" + "        {\r\n" + "		  \"range\" : {\r\n" +
		 * "            \""+field+"\" : {\r\n" +
		 * "                \"gte\" : "+greater+",\r\n" +
		 * "                \"lte\" : "+less+",\r\n" + "				},\r\n" +
		 * "			}\r\n" + "		}\r\n" + "      ]\r\n" + "    }\r\n" +
		 * "  },\r\n" + "    \"aggs\" : {\r\n" +
		 * "        \"total\" : { \"sum\" : { \"field\" : \"influence_score\" } }\r\n" +
		 * "    }\r\n" + "}";
		 * 
		 * String q="";
		 * 
		 * JSONObject jsonObj = new JSONObject(que); String url =
		 * base_url+"_search?size=1"; return this._getAggregate(url,jsonObj);
		 */
	}

	public String _searchRangeMaxTotalByBloggers(String bloggers) throws Exception {

		String count = "0";

		try {
			ArrayList response = DbConnection
					.query("SELECT max(influence_score) as total, blogger,date FROM blogger WHERE blogger = '"
							+ bloggers + "'  ORDER BY influence_score DESC LIMIT 1");
			if (response.size() > 0) {
				ArrayList hd = (ArrayList) response.get(0);
				count = hd.get(0).toString();
			}
		} catch (Exception e) {
			return count;
		}

		return count;
	}
	


public String _searchMinAndMaxRangeMaxByBloggers(String field,String greater, String less, String bloggers) throws Exception {
	
	String count = "0";
	try {
		ArrayList response = DbConnection.query("SELECT MAX(influence_score) as total FROM blogposts WHERE blogger='"+bloggers+"' AND "+field+">='"+greater+"' AND "+field+" <='"+less+"' ");
		System.out.println("response--"+response);	 
		if(response.size()>0){
		 	ArrayList hd = (ArrayList)response.get(0);
			count = hd.get(0).toString();
		}
	}catch(Exception e){
	
		return count;
		
	}

	return count;
}
	

	public String _searchMinInfluence() throws Exception {

		String count = "0";

		try {
			ArrayList response = DbConnection.query("SELECT min(influence_score) as total, blogger,date FROM blogger ");
			if (response.size() > 0) {
				ArrayList hd = (ArrayList) response.get(0);
				count = hd.get(0).toString();
			}
		} catch (Exception e) {
			return count;
		}

		return count;
	}

	public String _searchRangeMaxByBloggers(String field, String greater, String less, String bloggers)
			throws Exception {

		String count = "0";
		try {
			ArrayList response = DbConnection
					.query("SELECT MAX(influence_score) as total FROM blogposts WHERE blogger='" + bloggers + "' AND "
							+ field + ">='" + greater + "' AND " + field + " <='" + less + "' ");

			if (response.size() > 0) {
				ArrayList hd = (ArrayList) response.get(0);
				count = hd.get(0).toString();
			}
		} catch (Exception e) {
			return count;
		}
		System.out.println("blogger--" + bloggers);
		return count;
		/*
		 * 
		 * String[] args = bloggers.split(","); JSONArray pars = new JSONArray();
		 * ArrayList<String> ar = new ArrayList<String>(); for(int i=0; i<args.length;
		 * i++){ pars.put(args[i].toLowerCase()); }
		 * 
		 * String arg2 = pars.toString(); // String range =
		 * "\"range\" : {\"sentiment\" : {\"gte\" : "+greater+",\"lte\" : "+less+"}}";
		 * 
		 * 
		 * JSONObject jsonObj = new JSONObject("{\r\n" + "       \"query\": {\r\n" +
		 * "          \"bool\": { \r\n" + "               \"must\": {\r\n" +
		 * "                    \"query_string\" : {\r\n" +
		 * "            			\"fields\" : [\"blogger\"],\r\n" +
		 * "            			\"query\" : \""+bloggers+"\"\r\n" +
		 * "                    }\r\n" + "                },\r\n" +
		 * "                \"filter\": {\r\n" + "                    \"range\" : {\r\n"
		 * + "                        \"date\" : {\r\n" +
		 * "                            \"gte\": \""+greater+"\",\r\n" +
		 * "                            \"lte\": \""+less+"\"\r\n" +
		 * "                        }\r\n" + "                    }\r\n" +
		 * "                }\r\n" + "            }\r\n" + "        },\r\n" +
		 * "		\"sort\":{\r\n" + "		\"influence_score\":{\r\n" +
		 * "			\"order\":\"DESC\"\r\n" + "			}\r\n" + "		}\r\n" +
		 * "    }");
		 * 
		 * String url = base_url+"_search?size=1"; ArrayList result =
		 * this._getResult(url, jsonObj); String res = "0"; if(result.size()>0) { String
		 * tres = null; JSONObject tresp = null; String tresu = null; JSONObject tobj =
		 * null; for(int i=0; i< result.size(); i++){ tres = result.get(i).toString();
		 * tresp = new JSONObject(tres); tresu = tresp.get("_source").toString(); tobj =
		 * new JSONObject(tresu);
		 * 
		 * res = tobj.get("influence_score").toString();
		 * 
		 * } } return res;
		 */
	}

	public String _searchRangeMaxByBlogId(String field, String greater, String less, String blogid) throws Exception {
		/*
		 * DbConnection db = new DbConnection(); String count = "0"; try { ArrayList
		 * response =
		 * db.query("SELECT influence_score as total FROM blogposts WHERE blogsite_id='"
		 * +blogid+"' AND "+field+">='"+greater+"' AND "+field+" <='"
		 * +less+"' ORDER BY influence_score DESC LIMIT 1");
		 * 
		 * if(response.size()>0){ ArrayList hd = (ArrayList)response.get(0); count =
		 * hd.get(0).toString(); } }catch(Exception e){ return count; }
		 * 
		 * 
		 * return count;
		 * 
		 */
		String[] args = blogid.split(",");
		JSONArray pars = new JSONArray();
		ArrayList<String> ar = new ArrayList<String>();
		for (int i = 0; i < args.length; i++) {
			pars.put(args[i].toLowerCase());
		}

		String arg2 = pars.toString();
		// String range = "\"range\" : {\"sentiment\" : {\"gte\" : "+greater+",\"lte\" :
		// "+less+"}}";

		/*
		 * JSONObject jsonObj = new JSONObject("{\r\n" + "       \"query\": {\r\n" +
		 * "          \"bool\": { \r\n" + "               \"must\": {\r\n" +
		 * "                    \"query_string\" : {\r\n" +
		 * "            			\"fields\" : [\"blogger\"],\r\n" +
		 * "            			\"query\" : \""+blogid+"\"\r\n" +
		 * "                    }\r\n" + "                },\r\n" +
		 * "                \"filter\": {\r\n" + "                    \"range\" : {\r\n"
		 * + "                        \"date\" : {\r\n" +
		 * "                            \"gte\": \""+greater+"\",\r\n" +
		 * "                            \"lte\": \""+less+"\"\r\n" +
		 * "                        }\r\n" + "                    }\r\n" +
		 * "                }\r\n" + "            }\r\n" + "        },\r\n" +
		 * "		\"sort\":{\r\n" + "		\"influence_score\":{\r\n" +
		 * "			\"order\":\"DESC\"\r\n" + "			}\r\n" + "		}\r\n" +
		 * "    }");
		 */

		String que = "{\r\n" + "  \"query\": {\r\n" + "    \"bool\": {\r\n" + "      \"must\": [\r\n" + "        {\r\n"
				+ "		  \"constant_score\":{\r\n" + "					\"filter\":{\r\n"
				+ "							\"terms\":{\r\n" + "							\"blogsite_id\":" + arg2
				+ "\r\n" + "									}\r\n" + "							}\r\n"
				+ "						}\r\n" + "		},\r\n" + "        {\r\n" + "		  \"range\" : {\r\n"
				+ "            \"" + field + "\" : {\r\n" + "                \"gte\" : " + greater + ",\r\n"
				+ "                \"lte\" : " + less + ",\r\n" + "				},\r\n" + "			}\r\n"
				+ "		}\r\n" + "      ]\r\n" + "    }\r\n" + "  },\r\n" + "	\"sort\":{\r\n"
				+ "		\"influence_score\":{\r\n" + "			\"order\":\"DESC\"\r\n" + "			}\r\n" + "	}\r\n"
				+ "}";

		JSONObject jsonObj = new JSONObject(que);
		String url = base_url + "_search?size=1";
		ArrayList result = this._getResult(url, jsonObj);
		String res = "0";
		

		
		if(result.size()>0) {
			String tres = null;
			JSONObject tresp = null;
			String tresu = null;
			JSONObject tobj = null;
			for (int i = 0; i < result.size(); i++) {
				tres = result.get(i).toString();
				tresp = new JSONObject(tres);
				tresu = tresp.get("_source").toString();
				tobj = new JSONObject(tresu);
				res = tobj.get("influence_score").toString();
			}
		}
		return res;

	}

	public String _searchRangeAggregateByBloggers(String field, String greater, String less, String bloggers,
			String sort) throws Exception {

		String count = "0";
		try {
			ArrayList response = DbConnection.query("SELECT max(" + field + ") as total FROM blogposts WHERE blogger='"
					+ bloggers + "' AND " + field + ">='" + greater + "' AND " + field + " <='" + less + "' ");

			if (response.size() > 0) {
				ArrayList hd = (ArrayList) response.get(0);
				count = hd.get(0).toString();
			}
		} catch (Exception e) {
			return count;
		}

		return count;

		/*
		 * String[] args = bloggers.split(","); JSONArray pars = new JSONArray();
		 * ArrayList<String> ar = new ArrayList<String>(); for(int i=0; i<args.length;
		 * i++){ pars.put(args[i].toLowerCase()); }
		 * 
		 * String arg2 = pars.toString(); // String range =
		 * "\"range\" : {\"sentiment\" : {\"gte\" : "+greater+",\"lte\" : "+less+"}}";
		 * 
		 * String que="{\r\n" + "  \"query\": {\r\n" + "    \"bool\": {\r\n" +
		 * "      \"must\": [\r\n" + "        {\r\n" +
		 * "		  \"constant_score\":{\r\n" + "					\"filter\":{\r\n" +
		 * "							\"terms\":{\r\n" +
		 * "							\"blogger\":"+arg2+"\r\n" +
		 * "									}\r\n" +
		 * "							}\r\n" + "						}\r\n" +
		 * "		},\r\n" + "        {\r\n" + "		  \"range\" : {\r\n" +
		 * "            \""+field+"\" : {\r\n" +
		 * "                \"gte\" : "+greater+",\r\n" +
		 * "                \"lte\" : "+less+",\r\n" + "				},\r\n" +
		 * "			}\r\n" + "		}\r\n" + "      ]\r\n" + "    }\r\n" +
		 * "  },\r\n" + "    \"aggs\" : {\r\n" +
		 * "        \"total\" : { \"sum\" : { \"field\" : \""+sort+"\" } }\r\n" +
		 * "    }\r\n" + "}";
		 * 
		 * 
		 * JSONObject jsonObj = new JSONObject(que); String url =
		 * base_url+"_search?size=1"; return this._getAggregate(url,jsonObj);
		 */
		/*
		 * String url = base_url+"_search?size=1";
		 * 
		 * String[] args = bloggers.split(","); JSONArray pars = new JSONArray();
		 * ArrayList<String> ar = new ArrayList<String>(); for(int i=0; i<args.length;
		 * i++){ pars.put(args[i].toLowerCase()); }
		 * 
		 * String arg2 =pars.toString();
		 * 
		 * JSONObject jsonObj = new JSONObject("{\r\n" + "       \"query\": {\r\n" +
		 * "          \"bool\": { \r\n" + "               \"must\": {\r\n" +
		 * "                    \"query_string\" : {\r\n" +
		 * "            			\"fields\" : [\"blogger\"],\r\n" +
		 * "            			\"query\" : \""+bloggers+"\"\r\n" +
		 * "                    }\r\n" + "                },\r\n" +
		 * "                \"filter\": {\r\n" + "                    \"range\" : {\r\n"
		 * + "                        \"date\" : {\r\n" +
		 * "                            \"gte\": \""+greater+"\",\r\n" +
		 * "                            \"lte\": \""+less+"\"\r\n" +
		 * "                        }\r\n" + "                    }\r\n" +
		 * "                }\r\n" + "            }\r\n" + "        },\r\n" +
		 * "    \"aggs\" : {\r\n" +
		 * "        \"total\" : { \"sum\" : { \"field\" : \""+sort+"\" } }\r\n" +
		 * "    }\r\n" + "    }");
		 * 
		 * ArrayList result = this._getResult(url, jsonObj); return
		 * this._getAggregate(url, jsonObj);
		 */
	}

	public ArrayList _getBloggerByBlogId(String field, String greater, String less, String blog_ids, String sort,
			String order) throws Exception {
		int size = 50;
		/*
		 * blog_ids = blog_ids.replaceAll(",$", ""); blog_ids =
		 * blog_ids.replaceAll(", $", "");
		 * 
		 * blog_ids = "("+blog_ids+")"; DbConnection db = new DbConnection(); ArrayList
		 * response = new ArrayList();
		 * 
		 * //System.out.
		 * println("SELECT DISTINCT blogger,blogsite_id,language,date,blogpost_id,influence_score,location FROM blogposts WHERE blogsite_id IN "
		 * +blog_ids+" LIMIT "+size+" ");
		 * 
		 * try { //response =
		 * db.queryJSON("SELECT * FROM blogposts WHERE blogsite_id IN "
		 * +blog_ids+" AND date>='"+greater+"' AND date<='"
		 * +less+"' GROUP BY(blogger) ORDER BY "+sort+" "+order+" LIMIT "+size+" ");
		 * response = db.queryJSON("SELECT * FROM blogposts WHERE blogsite_id IN "
		 * +blog_ids+" GROUP BY(blogger) LIMIT "+size+" ");
		 * System.out.println("Resp:"+response); }catch(Exception e){
		 * System.out.println("Error:"); return response; }
		 * 
		 * return response;
		 */

		String url = base_url + "_search?size=50";
		String[] args = blog_ids.split(",");
		JSONArray pars = new JSONArray();
		ArrayList<String> ar = new ArrayList<String>();
		for (int i = 0; i < args.length; i++) {
			pars.put(args[i].replaceAll(" ", ""));
		}

		String arg2 = pars.toString();
		// String que = "{\"query\":
		// {\"constant_score\":{\"filter\":{\"terms\":{\"blogsite_id\":"+arg2+"}}}},\"sort\":{\"date\":{\"order\":\"ASC\"}}}";
		String que = "{\r\n" + "  \"query\": {\r\n" + "    \"bool\": {\r\n" + "      \"must\": [\r\n" + "        {\r\n"
				+ "		  \"constant_score\":{\r\n" + "					\"filter\":{\r\n"
				+ "							\"terms\":{\r\n" + "							\"blogsite_id\":" + arg2
				+ "\r\n" + "									}\r\n" + "							}\r\n"
				+ "						}\r\n" + "		},\r\n" + "        {\r\n" + "		  \"range\" : {\r\n"
				+ "            \"" + field + "\" : {\r\n" + "                \"gte\" : " + greater + ",\r\n"
				+ "                \"lte\" : " + less + ",\r\n" + "				},\r\n" + "			}\r\n"
				+ "		}\r\n" + "      ]\r\n" + "    }\r\n" + "  },\r\n" + "	\"sort\":{\r\n" + "		\"" + sort
				+ "\":{\r\n" + "			\"order\":\"" + order + "\"\r\n" + "			}\r\n" + "	}\r\n" + "}";

		JSONObject jsonObj = new JSONObject(que);
		ArrayList result = this._getResult(url, jsonObj);
		return this._getResult(url, jsonObj);
	}

	// SELECT * FROM blogposts WHERE blogsite_id IN (149,148,153,302,127,62) order
	// by date desc LIMIT 1
	public String _getDate(String blog_ids, String type) throws Exception {
		String url = base_url + "_search?size=1";
		String dt = "";
		String[] args = blog_ids.split(",");
		JSONArray pars = new JSONArray();
		ArrayList<String> ar = new ArrayList<String>();
		for (int i = 0; i < args.length; i++) {
			pars.put(args[i].replaceAll(" ", ""));
		}

		String arg2 = pars.toString();
		String que = "{\"query\": {\"constant_score\":{\"filter\":{\"terms\":{\"blogsite_id\":" + arg2
				+ "}}}},\"sort\":{\"date\":{\"order\":\"DESC\"}}}";

		if (type.equals("first")) {
			que = "{\"query\": {\"constant_score\":{\"filter\":{\"terms\":{\"blogsite_id\":" + arg2
					+ "}}}},\"sort\":{\"date\":{\"order\":\"ASC\"}}}";
		}

		JSONObject jsonObj = new JSONObject(que);
		ArrayList result = this._getResult(url, jsonObj);
		// System.out.println("results:"+result);
		if (result.size() > 0) {
			String bres = result.get(0).toString();
			JSONObject bresp = new JSONObject(bres);
			String bresu = bresp.get("_source").toString();
			JSONObject bobj = new JSONObject(bresu);
			String[] date = bobj.get("date").toString().split(" ");
			dt = date[0];
		}
		return dt;
	}

	public ArrayList _search(String term, String from, String sortby) throws Exception {

		int size = 100;
		int fr = 0;
		JSONObject jsonObj = new JSONObject("{\r\n" + "  \"query\": {\r\n" + "        \"query_string\" : {\r\n"
				+ "            \"fields\" : [\"title\",\"blogger\",\"post\"],\r\n" + "            \"query\" : \"" + term
				+ "\"\r\n" + "        }\r\n" + "  },\r\n" + "   \"sort\":{\r\n" + "		\"" + sortby + "\":{\r\n"
				+ "			\"order\":\"DESC\"\r\n" + "			}\r\n" + "		}\r\n" + "}");

		if (!from.equals("")) {
			fr = Integer.parseInt(from) * size;
			jsonObj = new JSONObject("{\r\n" + "  \"query\": {\r\n" + "        \"query_string\" : {\r\n"
					+ "            \"fields\" : [\"title\",\"blogger\",\"post\"],\r\n" + "            \"query\" : \""
					+ term + "\"\r\n" + "        }\r\n" + "  },\r\n" + "  	\"from\":" + from + "," + "	\"size\":"
					+ size + "," + "   \"sort\":{\r\n" + "		\"" + sortby + "\":{\r\n"
					+ "			\"order\":\"DESC\"\r\n" + "			}\r\n" + "		},\r\n" + "}");
		}

		if (from.equals("date")) {
			jsonObj = new JSONObject("{\r\n" + "  \"query\": {\r\n" + "        \"query_string\" : {\r\n"
					+ "            \"fields\" : [\"title\",\"blogger\",\"post\"],\r\n" + "            \"query\" : \""
					+ term + "\"\r\n" + "        }\r\n" + "  },\r\n" + "   \"sort\":{\r\n"
					+ "		\"blogpost_id\":{\r\n" + "			\"order\":\"DESC\"\r\n" + "			}\r\n"
					+ "		},\r\n" + " \"range\":{\r\n" + "		\"date\":{\r\n" + "			\"lte\":\"" + from
					+ "\",\r\n" + "			\"gte\":\"" + 0 + "\"\r\n" + "			}\r\n" + "		}\r\n" + "}");
		}
		String url = base_url + "_search?size=" + size + "&from=" + fr;
		System.out.println("object-----" + jsonObj);
		return this._getResult(url, jsonObj);
	}

	public ArrayList _searchByTitleAndBody(String term, String sortby, String start, String end) throws Exception {

		int size = 20;
		/*
		 * ArrayList response =new ArrayList(); DbConnection db = new DbConnection();
		 * String count = "0"; try { response =
		 * db.queryJSON("SELECT * FROM blogposts WHERE (title LIKE '%"
		 * +term+"%' OR post LIKE '%"+term+"%') AND date>='"+start+"' AND date <='"
		 * +end+"' ORDER BY date DESC LIMIT "+size+"");
		 * 
		 * 
		 * }catch(Exception e){ return response; }
		 * 
		 * 
		 * return response;
		 */
		/*
		 * JSONObject jsonObj = new JSONObject("{\r\n" + "  \"query\": {\r\n" +
		 * "        \"query_string\" : {\r\n" +
		 * "            \"fields\" : [\"title\",\"post\"],\r\n" +
		 * "            \"query\" : \""+term+"\"\r\n" + "        }\r\n" + "  },\r\n" +
		 * "   \"sort\":{\r\n" + "		\""+sortby+"\":{\r\n" +
		 * "			\"order\":\"DESC\"\r\n" + "			}\r\n" + "	}\r\n" + "}");
		 */

		JSONObject jsonObj = new JSONObject("{\r\n" + "       \"query\": {\r\n" + "          \"bool\": { \r\n"
				+ "               \"must\": {\r\n" + "                    \"query_string\" : {\r\n"
				+ "            			\"fields\" : [\"title\",\"post\"],\r\n" + "            			\"query\" : \""
				+ term + "\"\r\n" + "                    }\r\n" + "                },\r\n"
				+ "                \"filter\": {\r\n" + "                    \"range\" : {\r\n"
				+ "                        \"date\" : {\r\n" + "                            \"gte\": \"" + start
				+ "\",\r\n" + "                            \"lte\": \"" + end + "\"\r\n"
				+ "                        }\r\n" + "                    }\r\n" + "                }\r\n"
				+ "            }\r\n" + "        }\r\n" + "    }");

		String url = base_url + "_search?size=" + size;
		// System.out.println(url);
		return this._getResult(url, jsonObj);

	}

	public ArrayList _searchByBody(String term, String start, String end) throws Exception {

		ArrayList response = new ArrayList();
		String count = "0";
		try {
			response = DbConnection.query("SELECT count(*) FROM blogposts WHERE post LIKE '%" + term + "%' AND date>='"
					+ start + "' AND date <='" + end + "' ");

			if (response.size() > 0) {
				ArrayList hd = (ArrayList) response.get(0);
				count = hd.get(0).toString();
			}
		} catch (Exception e) {
			return response;
		}

		return response;
	}

	public String _searchTotalByBody(String term, String start, String end) throws Exception {

		ArrayList response = new ArrayList();
		String count = "0";
		try {
			response = DbConnection.query("SELECT count(*) FROM blogposts WHERE post LIKE '%" + term + "%' AND date>='"
					+ start + "' AND date <='" + end + "' ");

			if (response.size() > 0) {
				ArrayList hd = (ArrayList) response.get(0);
				count = hd.get(0).toString();
			}
		} catch (Exception e) {
			return count;
		}

		return count;

		/*
		 * return response; JSONObject jsonObj = new JSONObject("{\r\n" +
		 * "       \"query\": {\r\n" + "          \"bool\": { \r\n" +
		 * "               \"must\": {\r\n" +
		 * "                    \"query_string\" : {\r\n" +
		 * "            			\"fields\" : [\"post\"],\r\n" +
		 * "            			\"query\" : \""+term+"\"\r\n" +
		 * "                    }\r\n" + "                },\r\n" +
		 * "                \"filter\": {\r\n" + "                    \"range\" : {\r\n"
		 * + "                        \"date\" : {\r\n" +
		 * "                            \"gte\": \""+start+"\",\r\n" +
		 * "                            \"lte\": \""+end+"\"\r\n" +
		 * "                        }\r\n" + "                    }\r\n" +
		 * "                }\r\n" + "            }\r\n" + "        }\r\n" + "    }");
		 * 
		 * String url = base_url+"_search?size=1"; //String url =
		 * base_url+"_termvectors?fields="+term; //String vl = this._getTotalTest(url,
		 * jsonObj); //System.out.println("Val Here:"+vl); return this._getTotal(url,
		 * jsonObj);
		 */
	}

	public String _searchTotalByTitleAndBody(String term, String sortby, String start, String end) throws Exception {

		/*
		 * 
		 * ArrayList response =new ArrayList(); DbConnection db = new DbConnection();
		 * String count = "0"; try { response =
		 * db.query("SELECT count(*) FROM blogposts WHERE (title LIKE '%"
		 * +term+"%' OR post LIKE '%"+term+"%') AND date>='"+start+"' AND date <='"
		 * +end+"' ");
		 * 
		 * if(response.size()>0){ ArrayList hd = (ArrayList)response.get(0); count =
		 * hd.get(0).toString(); } }catch(Exception e){ return count; }
		 * 
		 * 
		 * return count;
		 * 
		 *//*
			 * JSONObject jsonObj = new JSONObject("{\r\n" + "       \"query\": {\r\n" +
			 * "          \"bool\": { \r\n" + "               \"must\": {\r\n" +
			 * "                    \"query_string\" : {\r\n" +
			 * "            			\"fields\" : [\"title\",\"post\"],\r\n" +
			 * "            			\"query\" : \""+term+"\"\r\n" +
			 * "                    }\r\n" + "                },\r\n" +
			 * "                \"filter\": {\r\n" + "                    \"range\" : {\r\n"
			 * + "                        \"date\" : {\r\n" +
			 * "                            \"gte\": \""+start+"\",\r\n" +
			 * "                            \"lte\": \""+end+"\"\r\n" +
			 * "                        }\r\n" + "                    }\r\n" +
			 * "                }\r\n" + "            }\r\n" + "        },\r\n" + "  }  }");
			 */
		JSONObject jsonObj = new JSONObject("{\r\n" + "       \"query\": {\r\n" + "          \"bool\": { \r\n"
				+ "               \"must\": {\r\n" + "                    \"query_string\" : {\r\n"
				+ "            			\"fields\" : [\"title\",\"post\"],\r\n" + "            			\"query\" : \""
				+ term + "\"\r\n" + "                    }\r\n" + "                },\r\n"
				+ "                \"filter\": {\r\n" + "                    \"range\" : {\r\n"
				+ "                        \"date\" : {\r\n" + "                            \"gte\": \"" + start
				+ "\",\r\n" + "                            \"lte\": \"" + end + "\"\r\n"
				+ "                        }\r\n" + "                    }\r\n" + "                }\r\n"
				+ "            }\r\n" + "        }\r\n" + "    }");

		String url = base_url + "_search?size=1";
		if (term.equals("war")) {
			System.out.println(jsonObj);
		}
		return this._getTotal(url, jsonObj);

	}

	public ArrayList _getPostId(String blog_ids) {
		DbConnection db = new DbConnection();
		ArrayList response = new ArrayList<>();
		String result = "";
		blog_ids = blog_ids.replaceAll(",$", "");
		blog_ids = blog_ids.replaceAll(", $", "");
		blog_ids = "(" + blog_ids + ")";
		try {
			response = db.query("select blogpost_id from blogposts where blogsite_id in " + blog_ids);
			if (response.size() > 0) {
				return response;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public String _searchTotalAndUnique(String term, String sortby, String start, String end, String filter)
			throws Exception {

		/*
		 * DbConnection db = new DbConnection(); String count = "0";
		 * 
		 * try { ArrayList response = db.query("SELECT count(DISTINCT "
		 * +filter+") as total FROM blogposts WHERE (title LIKE '%"
		 * +term+"%' OR post LIKE '%"+term+"%' ) AND date>='"+start+"' AND date<='"
		 * +end+"' "); if(response.size()>0){ ArrayList hd = (ArrayList)response.get(0);
		 * count = hd.get(0).toString(); } }catch(Exception e){ return count; }
		 * 
		 * return count;
		 */
		/*
		 * JSONObject jsonObj = new JSONObject("{\r\n" + "  \"query\": {\r\n" +
		 * "        \"query_string\" : {\r\n" +
		 * "            \"fields\" : [\"title\",\"post\"],\r\n" +
		 * "            \"query\" : \""+term+"\"\r\n" + "        },\r\n" + "  },\r\n" +
		 * "	\"size\" : 0,\r\n" + "    \"aggs\" : {\r\n" +
		 * "        \"total\" : {\r\n" + "            \"cardinality\" : {\r\n" +
		 * "              \"field\" : \""+filter+"\"\r\n" + "            }\r\n" +
		 * "        }\r\n" + "    }"+ " }");
		 * 
		 */
		JSONObject jsonObj = new JSONObject("{\r\n" + "       \"query\": {\r\n" + "          \"bool\": { \r\n"
				+ "               \"must\": {\r\n" + "                    \"query_string\" : {\r\n"
				+ "            			\"fields\" : [\"title\",\"post\"],\r\n" + "            			\"query\" : \""
				+ term + "\"\r\n" + "                    }\r\n" + "                },\r\n"
				+ "                \"filter\": {\r\n" + "                    \"range\" : {\r\n"
				+ "                        \"date\" : {\r\n" + "                            \"gte\": \"" + start
				+ "\",\r\n" + "                            \"lte\": \"" + end + "\"\r\n"
				+ "                        }\r\n" + "                    }\r\n" + "                }\r\n"
				+ "            }\r\n" + "        },\r\n" + "		\"size\" : 0,\r\n" + "    	\"aggs\" : {\r\n"
				+ "        \"total\" : {\r\n" + "            \"cardinality\" : {\r\n" + "              \"field\" : \""
				+ filter + "\"\r\n" + "            }\r\n" + "        }\r\n" + "    }" + "    }");

		String url = base_url + "_search?size=1";

		return this._getAggregate(url, jsonObj);

	}

	public String _searchTotalAndUniqueBlogger(String term, String sortby, String start, String end, String filter)
			throws Exception {

		String count = "0";
		// Modify to distinct blogger
		/*
		 * try { ArrayList response = DbConnection.query("SELECT count(DISTINCT "
		 * +filter+") as total FROM blogposts WHERE (title LIKE '%"
		 * +term+"%' OR post LIKE '%"+term+"%' OR blogger LIKE '%"
		 * +term+"%' ) AND date>='"+start+"' AND date<='"+end+"' ");
		 * if(response.size()>0){ ArrayList hd = (ArrayList)response.get(0); count =
		 * hd.get(0).toString(); } }catch(Exception e){ return count; }
		 * 
		 * return count;
		 */

		JSONObject jsonObj = new JSONObject("{\r\n" + "  \"query\": {\r\n" + "        \"query_string\" : {\r\n"
				+ "            \"fields\" : [\"title\",\"post\",\"blogger\"],\r\n" + "            \"query\" : \"" + term
				+ "\"\r\n" + "        }\r\n" + "  },\r\n" + "\"aggs\": {\r\n" + "    \"top-uids\": {\r\n"
				+ "      \"terms\": {\r\n" + "        \"field\": \"" + filter + "\"\r\n" + "      },\r\n"
				+ "      \"aggs\": {\r\n" + "        \"top_uids_hits\": {\r\n" + "          \"top_hits\": {\r\n"
				+ "            \"sort\": [\r\n" + "              {\r\n" + "                \"_score\": {\r\n"
				+ "                  \"order\": \"desc\"\r\n" + "                }\r\n" + "              }\r\n"
				+ "            ],\r\n" + "            \"size\": 1\r\n" + "          }\r\n" + "        }\r\n"
				+ "      }\r\n" + "    }\r\n" + "  }" + "}");

		String url = base_url + "_search?size=1";
		return this._getTotal(url, jsonObj);

	}

	public ArrayList _getPostByBlogger(String blogger) throws Exception {
		int size = 50;
		DbConnection db = new DbConnection();
		ArrayList response = new ArrayList();
		try {
			response = db.queryJSON(
					"SELECT * FROM blogposts WHERE blogger = '" + blogger + "' ORDER BY date DESC LIMIT " + size + "");
		} catch (Exception e) {
			return response;
		}

		return response;

		/*
		 * JSONObject jsonObj = new JSONObject("{\r\n" + "  \"query\": {\r\n" +
		 * "        \"query_string\" : {\r\n" +
		 * "            \"fields\" : [\"blogger\"],\r\n" +
		 * "            \"query\" : \""+blogger+"\"\r\n" + "        }\r\n" + "  },\r\n"
		 * + "   \"sort\":{\r\n" + "		\"date\":{\r\n" +
		 * "			\"order\":\"DESC\"\r\n" + "			}\r\n" + "		}\r\n" +
		 * "}"); String url = base_url+"_search?size=20"; return this._getResult(url,
		 * jsonObj);
		 */
	}

	/* Fetch posts by blog ids */
	public String _getTotalByBlogId(String blog_ids, String from) throws Exception {

		/*
		 * DbConnection db = new DbConnection(); String count = "0"; blog_ids =
		 * blog_ids.replaceAll(",$", ""); blog_ids = blog_ids.replaceAll(", $", "");
		 * blog_ids = "("+blog_ids+")";
		 * 
		 * 
		 * try { ArrayList response =
		 * db.query("SELECT count(*) as total FROM blogposts WHERE blogsite_id IN "
		 * +blog_ids+" "); if(response.size()>0){ ArrayList hd =
		 * (ArrayList)response.get(0); count = hd.get(0).toString(); } }catch(Exception
		 * e){ return count; }
		 * 
		 * return count;
		 */

		String url = base_url + "_search?size=1";
		String[] args = blog_ids.split(",");
		JSONArray pars = new JSONArray();
		for (int i = 0; i < args.length; i++) {
			pars.put(args[i].replaceAll(" ", ""));
		}

		String arg2 = pars.toString();
		String que = "{\"query\": {\"constant_score\":{\"filter\":{\"terms\":{\"blogsite_id\":" + arg2 + "}}}}}";

		JSONObject jsonObj = new JSONObject(que);
		ArrayList result = this._getResult(url, jsonObj);
		return this.totalpost;

	}

	/* Fetch posts by blog ids */
	public String _getTotalByBlogger(String blogger, String field, String greater, String less) throws Exception {

		String count = "0";
		// System.out.println("SELECT count(*) as total FROM blogposts WHERE blogger =
		// '"+blogger+"' AND "+field+">='"+greater+"' AND "+field+"<='"+less+"' ");

		try {
			ArrayList response = DbConnection.query("SELECT count(*) as total FROM blogposts WHERE blogger = '"
					+ blogger + "' AND " + field + ">='" + greater + "' AND " + field + "<='" + less + "' ");
			if (response.size() > 0) {
				ArrayList hd = (ArrayList) response.get(0);
				count = hd.get(0).toString();
			}
		} catch (Exception e) {
			return count;
		}

		return count;

		/*
		 * String url = base_url+"_search?size=1"; //String que =
		 * "{\"query\": {\"constant_score\":{\"filter\":{\"terms\":{\"blogger\":"
		 * +blogger+"}}}}}";
		 * 
		 * //JSONObject jsonObj = new JSONObject(que);
		 * 
		 * JSONObject jsonObj = new JSONObject("{\r\n" + "  \"query\": {\r\n" +
		 * "        \"query_string\" : {\r\n" +
		 * "            \"fields\" : [\"blogger\"],\r\n" +
		 * "            \"query\" : \""+blogger+"\"\r\n" + "        }\r\n" + "  },\r\n"
		 * + "   \"sort\":{\r\n" + "		\""+field+"\":{\r\n" +
		 * "			\"order\":\"DESC\"\r\n" + "			}\r\n" + "		}\r\n" +
		 * "}");
		 * 
		 * return this._getTotal(url, jsonObj);
		 */
	}

	/* Fetch posts by blog ids */
	public ArrayList _getPostByBlogId(String blog_ids, String from) throws Exception {
		String url = base_url + "_search?size=50";
		String[] args = blog_ids.split(",");
		JSONArray pars = new JSONArray();
		ArrayList<String> ar = new ArrayList<String>();
		for (int i = 0; i < args.length; i++) {
			pars.put(args[i].replaceAll(" ", ""));
		}

		String arg2 = pars.toString();
		String que = "{\"query\": {\"constant_score\":{\"filter\":{\"terms\":{\"blogsite_id\":" + arg2 + "}}}}}";

		JSONObject jsonObj = new JSONObject(que);
		ArrayList result = this._getResult(url, jsonObj);
		return this._getResult(url, jsonObj);
	}

	public ArrayList _searchPostTotal(String field, int greater, int less, String blog_ids) throws Exception {

		ArrayList hd = new ArrayList();
		blog_ids = blog_ids.replaceAll(",$", "");
		blog_ids = blog_ids.replaceAll(", $", "");

		blog_ids = "(" + blog_ids + ")";

		try {
			hd = DbConnection
					.query("select year, sum(totalpost) from blogpostyearcount_byblogsite where blogsite_id in "
							+ blog_ids + " and year between '" + greater + "' AND '" + less + "' group by year ");

		} catch (Exception e) {
			return hd;
		}

		return hd;
	}

	public String _searchRangeTotal(String field, String greater, String less, String blog_ids) throws Exception {

		String count = "0";
		blog_ids = blog_ids.replaceAll(",$", "");
		blog_ids = blog_ids.replaceAll(", $", "");

		blog_ids = "(" + blog_ids + ")";

		try {
			ArrayList response = DbConnection.query("SELECT count(*) as total FROM blogposts WHERE blogsite_id IN "
					+ blog_ids + " AND date>='" + greater + "' AND date<='" + less + "' ");
			if (response.size() > 0) {
				ArrayList hd = (ArrayList) response.get(0);
				count = hd.get(0).toString();
			}
		} catch (Exception e) {
			return count;
		}
		System.out.println("id--" + blog_ids);
		System.out.println("greater--" + greater);
		System.out.println("less--" + less);
		return count;

//		String[] args = blog_ids.split(","); 
//		JSONArray pars = new JSONArray(); 
//		ArrayList<String> ar = new ArrayList<String>();	
//		for(int i=0; i<args.length; i++){
//			pars.put(args[i].replaceAll(" ", ""));
//		}
//
//		String arg2 = pars.toString();
//		// String range = "\"range\" : {\"sentiment\" : {\"gte\" : "+greater+",\"lte\" : "+less+"}}";
//		String que ="{\r\n" + 
//		 		"	\"size\":20,\r\n" + 
//		 		"	\r\n" + 
//		 		"	\"query\": { \r\n" + 
//		 		"			 \"bool\": {\r\n" + 
//		 		"				      \"must\": [\r\n" + 
//		 		"				      	{\r\n" + 
//		 		"						  \"constant_score\":{ \r\n" + 
//		 		"									\"filter\":{ \r\n" + 
//		 		"											\"terms\":{ \r\n" + 
//		 		"												\r\n" + 
//		 		"											\"blogsite_id\":"+arg2+"\r\n"+
//		 		"													}\r\n" + 
//		 		"											}\r\n" + 
//		 		"										} \r\n" + 
//		 		"						}, \r\n" + 
//		 		"	 		        { \r\n" + 
//		 		"	 				  \"range\" : { \r\n" + 
//		 		"	 		            \"date\" : { \r\n" + 
//		 		"	 		                \"gte\" : "+greater+",\r\n"+
//		 		"	 		                \"lte\" : "+less+"\r\n" + 
//		 		"	 						}\r\n" + 
//		 		"	 					} \r\n" + 
//		 		"	 				} \r\n" + 
//		 		"	 		      ] \r\n" + 
//		 		"	 		    } \r\n" + 
//		 		"	 		  } \r\n" + 
//		 		"	 		}";
//
//		String que="{\r\n" + 
//				"  \"query\": {\r\n" + 
//				"    \"bool\": {\r\n" + 
//				"      \"must\": [\r\n" + 
//				"        {\r\n" + 
//				"		  \"constant_score\":{\r\n" + 
//				"					\"filter\":{\r\n" + 
//				"							\"terms\":{\r\n" + 
//				"							\"blogsite_id\":"+arg2+"\r\n" + 
//				"									}\r\n" + 
//				"							}\r\n" + 
//				"						}\r\n" + 
//				"		},\r\n" + 
//				"        {\r\n" + 
//				"		  \"range\" : {\r\n" + 
//				"            \""+field+"\" : {\r\n" + 
//				"                \"gte\" : "+greater+",\r\n" + 
//				"                \"lte\" : "+less+",\r\n" + 
//				"				},\r\n" +
//				"			}\r\n" + 
//				"		}\r\n" + 
//				"      ]\r\n" + 
//				"    }\r\n" + 
//				"  }\r\n" + 
//				"}";
//		JSONObject jsonObj = new JSONObject(que);
//
//		String url = base_url+"_search";
//		return this._getTotal(url,jsonObj);

	}

	public String _searchRangeTotalByBlogger(String field, String greater, String less, String bloggers)
			throws Exception {

		String count = "0";

		try {
			ArrayList response = DbConnection.query("SELECT count(*) as total FROM blogposts WHERE blogger = '"
					+ bloggers + "' AND " + field + ">='" + greater + "' AND " + field + "<='" + less + "' ");
			if (response.size() > 0) {
				ArrayList hd = (ArrayList) response.get(0);
				count = hd.get(0).toString();
			}
		} catch (Exception e) {
			return count;
		}

		System.out.println("field--" + field);
		System.out.println("greater--" + greater);
		System.out.println("less--" + less);
		return count;

		/*
		 * String[] args = bloggers.split(","); JSONArray pars = new JSONArray();
		 * for(int i=0; i<args.length; i++){ pars.put(args[i].toLowerCase()); }
		 * 
		 * String arg2 = pars.toString();
		 * 
		 * // String range =
		 * "\"range\" : {\"sentiment\" : {\"gte\" : "+greater+",\"lte\" : "+less+"}}";
		 * String que = "{\r\n" + "	\"size\":10,\r\n" + "		\"sort\":{ \r\n" +
		 * "			\"date\":{\r\n" + "				\"order\":\"desc\"\r\n" +
		 * "				}\r\n" + "	},\r\n" + "	\"query\": { \r\n" +
		 * "			 \"bool\": {\r\n" + "				      \"must\": [\r\n" +
		 * "				      \r\n" + "				      	{\r\n" +
		 * "						  \"match_phrase\":{ \r\n" +
		 * "													\"blogger\":"+bloggers+
		 * "\r\n"+ "											\r\n" +
		 * "										} \r\n" +
		 * "						}, \r\n" + "						\r\n" +
		 * "	 		        { \r\n" + "	 				  \"range\" : { \r\n" +
		 * "	 		            \"date\" : { \r\n" +
		 * "	 		                \"gte\" : "+greater+",\r\n" +
		 * "	 		                \"lte\" : "+less+"\r\n" +
		 * "	 						}\r\n" + "	 					} \r\n" +
		 * "	 				} \r\n" + "	 		      ],\r\n" +
		 * "			 	\"minimum_should_match\": \"100%\"\r\n" + "			 } \r\n"
		 * + "	 		  \r\n" + "                 }\r\n" + "	 	\r\n" + "}"; //
		 * String que ="{\r\n" + // "	\"size\":400,\r\n" + // "	\r\n" + //
		 * "	\"query\": { \r\n" + // "			 \"bool\": {\r\n" + //
		 * "				      \"must\": [\r\n" + // "				      	{\r\n" +
		 * // "						  \"constant_score\":{ \r\n" + //
		 * "									\"filter\":{ \r\n" + //
		 * "											\"terms\":{ \r\n" + //
		 * "												\r\n" + //
		 * "											\"blogger\":"+arg2+"\r\n"+ //
		 * "													}\r\n" + //
		 * "											}\r\n" + //
		 * "										} \r\n" + //
		 * "						}, \r\n" + // "	 		        { \r\n" + //
		 * "	 				  \"range\" : { \r\n" + //
		 * "	 		            \"date\" : { \r\n" + //
		 * "	 		                \"gte\" : "+greater+",\r\n"+ //
		 * "	 		                \"lte\" : "+less+"\r\n" + //
		 * "	 						}\r\n" + // "	 					} \r\n" + //
		 * "	 				} \r\n" + // "	 		      ] \r\n" + //
		 * "				\"minimum_should_match\": 100%"+ // "	 		    } \r\n"
		 * + // "	 		  } \r\n" + // "	 		}"; // // String que="{\r\n" +
		 * // "  \"query\": {\r\n" + // "    \"bool\": {\r\n" + //
		 * "      \"must\": [\r\n" + // "        {\r\n" + //
		 * "		  \"constant_score\":{\r\n" + //
		 * "					\"filter\":{\r\n" + //
		 * "							\"terms\":{\r\n" + //
		 * "							\"blogger\":"+arg2+"\r\n" + //
		 * "									}\r\n" + //
		 * "							}\r\n" + // "						}\r\n" + //
		 * "		},\r\n" + // "        {\r\n" + // "		  \"range\" : {\r\n" + //
		 * "            \""+field+"\" : {\r\n" + //
		 * "                \"gte\" : "+greater+",\r\n" + //
		 * "                \"lte\" : "+less+",\r\n" + // "				},\r\n" + //
		 * "			}\r\n" + // "		}\r\n" + // "      ]\r\n" + // "    }\r\n" +
		 * // "  }\r\n" + // "}"; JSONObject jsonObj = new JSONObject(que); String url =
		 * base_url+"_search"; return this._getTotal(url,jsonObj);
		 */
	}

	public String _searchRangeTotal(String field, String greater, String less, String date_from, String date_to,
			String blog_ids) throws Exception {

		// Modify to distinct blogger
		DbConnection db = new DbConnection();
		String count = "0";
		blog_ids = blog_ids.replaceAll(",$", "");
		blog_ids = blog_ids.replaceAll(", $", "");

		blog_ids = "(" + blog_ids + ")";
		return "0";
		/*
		 * try { ArrayList response = db.
		 * query("SELECT count(DISTINCT blogger) as total FROM blogposts WHERE blogsite_id IN "
		 * +blog_ids+" AND "+field+">='"+date_from+"' AND "+field+"<='"+date_to+"' ");
		 * if(response.size()>0){ ArrayList hd = (ArrayList)response.get(0); count =
		 * hd.get(0).toString(); } }catch(Exception e){ return count; }
		 * 
		 * return count;
		 */
		/*
		 * String[] args = blog_ids.split(","); JSONArray pars = new JSONArray();
		 * ArrayList<String> ar = new ArrayList<String>(); for(int i=0; i<args.length;
		 * i++){ pars.put(args[i].replaceAll(" ", "")); }
		 * 
		 * String arg2 = pars.toString(); // String range =
		 * "\"range\" : {\"sentiment\" : {\"gte\" : "+greater+",\"lte\" : "+less+"}}";
		 * 
		 * 
		 * String que="{\r\n" + "  \"query\": {\r\n" + "    \"bool\": {\r\n" +
		 * "      \"must\": [\r\n" + "        {\r\n" +
		 * "		  \"constant_score\":{\r\n" + "					\"filter\":{\r\n" +
		 * "							\"terms\":{\r\n" +
		 * "							\"blogsite_id\":"+arg2+"\r\n" +
		 * "									}\r\n" +
		 * "							}\r\n" + "						}\r\n" +
		 * "		},\r\n" + "        {\r\n" + "		  \"range\" : {\r\n" +
		 * "            \""+field+"\" : {\r\n" +
		 * "                \"gte\" : "+greater+",\r\n" +
		 * "                \"lte\" : "+less+",\r\n" + "				},\r\n" +
		 * "			}\r\n" + "		}\r\n" + "      ]\r\n" + "    }\r\n" + "  }\r\n"
		 * + "}"; JSONObject jsonObj = new JSONObject(que);
		 * 
		 * String url = base_url+"_search"; return this._getTotal(url,jsonObj);
		 */
	}

	public ArrayList _fetch(String ids) throws Exception {
		JSONObject jsonObj = new JSONObject("{\r\n" + "  \"query\": {\r\n" + "    \"constant_score\":{\r\n"
				+ "			\"filter\":{\r\n" + "					\"terms\":{\r\n"
				+ "							\"blogpost_id\":[\"" + ids + "\"]\r\n" + "							}\r\n"
				+ "					}\r\n" + "				}\r\n" + "    }\r\n" + "}");

		String url = base_url + "_search?size=50";
		return this._getResult(url, jsonObj);

	}

	public ArrayList _getPost(String key, String value) throws Exception {
		JSONObject jsonObj = new JSONObject("{\r\n" + "  \"query\": {\r\n" + "    \"constant_score\":{\r\n"
				+ "			\"filter\":{\r\n" + "					\"terms\":{\r\n" + "							\""
				+ key + "\":[\"" + value + "\"]\r\n" + "							}\r\n" + "					}\r\n"
				+ "				}\r\n" + "    }\r\n" + "}");

		String url = base_url + "_search?size=1";
		return this._getResult(url, jsonObj);
	}

	public ArrayList _getResult(String url, JSONObject jsonObj) throws Exception {
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
		      JSONObject total_ = new JSONObject(total);
		      this.totalpost = total_.get("value").toString();
		    
		     JSONArray jsonArray = new JSONArray(myRes1.get("hits").toString()); 
		     
		     if (jsonArray != null) { 
		        int len = jsonArray.length();
		        for (int i=0;i<len;i++){ 
		         list.add(jsonArray.get(i).toString());
		        } 
		     }
	     }
		}catch(Exception ex) {}
		System.out.println("This is the list for -----"+url+"---"+list);
	     return list;
	     
	}

	public String NormalizedOutput(String value) {
		System.out.println("Output:" + value);
		switch (value) {
		case ("-2"):
			return "Very Low";
		case ("-1"):
			return "Low";
		case ("0"):
			return "Medium";
		case ("1"):
			return "High";
		case ("2"):
			return "Very High";
		default:
			return "Very High";
		}
	}

	public String NormalizedOutputSentiment(String value) {
		System.out.println("Output:" + value);
		switch (value) {
		case ("-2"):
			return "Very Negative";
		case ("-1"):
			return "Negative";
		case ("0"):
			return "Neutral";
		case ("1"):
			return "Positive";
		case ("2"):
			return "Very Positive";
		default:
			return "Unknown";
		}
	}

	public String _getTotalTest(String url, JSONObject jsonObj) throws Exception {
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
			System.out.println("A response :" + myResponse);
			if (null != myResponse.get("hits")) {
				String res = myResponse.get("hits").toString();
				JSONObject myRes1 = new JSONObject(res);
				total = myRes1.get("total").toString();
			}
		} catch (Exception ex) {
		}
		return total;
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

	public JSONArray _sortJson(JSONArray yearsarray) {
		JSONArray sortedyearsarray = new JSONArray();
		List<String> jsonList = new ArrayList<String>();
		for (int i = 0; i < yearsarray.length(); i++) {
			jsonList.add(yearsarray.get(i).toString());
		}

		Collections.sort(jsonList, new Comparator<String>() {
			public int compare(String a, String b) {
				String valA = new String();
				String valB = new String();

				try {
					valA = (String) a;
					valB = (String) b;
				} catch (Exception e) {
					// do something
				}
				return valA.compareTo(valB);
			}
		});

		for (int i = 0; i < yearsarray.length(); i++) {
			sortedyearsarray.put(jsonList.get(i));
		}
		return sortedyearsarray;
	}

	public JSONArray _sortJson2(JSONArray yearsarray) {
		JSONArray sortedyearsarray = new JSONArray();
		List<String> jsonList = new ArrayList<String>();
		for (int i = 0; i < yearsarray.length(); i++) {
			jsonList.add(yearsarray.get(i).toString());
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

		for (int i = 0; i < yearsarray.length(); i++) {
			sortedyearsarray.put(jsonList.get(i));
		}
		return sortedyearsarray;
	}

	public int monthsBetweenDates(Date startDate, Date endDate) {

		Calendar start = Calendar.getInstance();
		start.setTime(startDate);

		Calendar end = Calendar.getInstance();
		end.setTime(endDate);

		int monthsBetween = 0;
		int dateDiff = end.get(Calendar.DAY_OF_MONTH) - start.get(Calendar.DAY_OF_MONTH);

		if (dateDiff < 0) {
			int borrrow = end.getActualMaximum(Calendar.DAY_OF_MONTH);
			dateDiff = (end.get(Calendar.DAY_OF_MONTH) + borrrow) - start.get(Calendar.DAY_OF_MONTH);
			monthsBetween--;

			if (dateDiff > 0) {
				monthsBetween++;
			}
		} else {
			monthsBetween++;
		}
		monthsBetween += end.get(Calendar.MONTH) - start.get(Calendar.MONTH);
		monthsBetween += (end.get(Calendar.YEAR) - start.get(Calendar.YEAR)) * 12;
		return monthsBetween;
	}

	public String _getBlogPostById(String blog_ids) {
		String count = "";
		blog_ids = blog_ids.replaceAll(",$", "");
		blog_ids = blog_ids.replaceAll(", $", "");
		blog_ids = "(" + blog_ids + ")";

		try {
			ArrayList response = DbConnection
					.query("select sum(blogpost_count) from blogger where blogsite_id in  " + blog_ids + " ");
			if (response.size() > 0) {
				ArrayList hd = (ArrayList<?>) response.get(0);
				count = hd.get(0).toString();
			}
		} catch (Exception e) {
			System.out.print("Error in getBlogPostById");
		}
		return count;
	}

	public ArrayList _getBloggerPostId(String bloggerName) {
		ArrayList hd = null;
		String res = "";
		ArrayList result = new ArrayList<>();
		try {
			ArrayList response = DbConnection
					.query("SELECT blogpost_id from blogposts where blogger= '" + bloggerName + "'");
			if (response.size() > 0) {
				for (int i = 0; i < response.size(); i++) {
					hd = (ArrayList) response.get(i);
					res = hd.get(0).toString();
					result.add(res);
				}

			}
		} catch (Exception e) {
			System.out.print("Error in getBlogPostById");
		}

		return result;
	}

	/*
	 * public Date addDay(Date date, int i) { Calendar cal = Calendar.getInstance();
	 * cal.setTime(date); cal.add(Calendar.DAY_OF_YEAR, i); return cal.getTime(); }
	 * 
	 * public Date addMonth(Date date, int i) { Calendar cal =
	 * Calendar.getInstance(); cal.setTime(date); cal.add(Calendar.MONTH, i); return
	 * cal.getTime(); }
	 * 
	 * public Date addYear(Date date, int i) { Calendar cal =
	 * Calendar.getInstance(); cal.setTime(date); cal.add(Calendar.YEAR, i); return
	 * cal.getTime(); }
	 */
	public JSONObject _makeElasticRequest(JSONObject query,String IP,Integer port, String requestType, String endPoint) throws Exception {
		
		JSONObject myResponse = new JSONObject();
		try {
			RestClient esClient = RestClient.builder(new HttpHost(IP, port, "http")).build();

			Request request = new Request(requestType, endPoint);
			request.setJsonEntity(query.toString());

			Response response = esClient.performRequest(request);
			System.out.println("GETTING TERM VECTORS");
			String jsonResponse = EntityUtils.toString(response.getEntity());
			myResponse = new JSONObject(jsonResponse);
		} catch (Exception e) {

		}
		return myResponse;
		
	}

	public JSONArray _elastic(JSONObject query) throws Exception {
		ArrayList<String> list = new ArrayList<String>();

//		RestClient esClient = RestClient.builder(new HttpHost("144.167.115.90", 9200, "http")).build();
//		Request request = new Request("POST", "/blogposts/_search/?scroll=1d");
//		request.setJsonEntity(query.toString());

//		Response response = esClient.performRequest(request);

		String source = null;

		System.out.println("this is the query-" + query);
		JSONArray jsonArray = null;
//		String jsonResponse = EntityUtils.toString(response.getEntity());

//		Object j_ = new JSONObject(response.getEntity());
//		JSONObject myResponse = new JSONObject(jsonResponse);
		
		JSONObject myResponse = this._makeElasticRequest(query, "144.167.115.90", 9200, "POST", "/blogposts/_search/?scroll=1d");
//		System.out.println("response-" + j_);

		if (null != myResponse.get("hits")) {
			Object hits = myResponse.getJSONObject("hits").getJSONArray("hits");
			Object total = myResponse.getJSONObject("hits").getJSONObject("total").get("value");

//			JSONObject myRes1 = new JSONObject(hits);
			source = hits.toString();

			jsonArray = new JSONArray(source);

			System.out.println("DONE GETTING POSTS FOR BLOGGER");

		}

		return jsonArray;
	}

	public JSONArray _getMostLanguage(String date_from, String date_to, String ids_,Integer limit) throws Exception {
		ArrayList<String> list = new ArrayList<String>();
		HashMap<String, Integer> hm = new HashMap<String, Integer>();
		
		JSONArray all = new JSONArray();
		
		
		JSONObject query = new JSONObject("{\r\n" + "    \"size\": 0,\r\n" + "    \"query\": {\r\n"
				+ "        \"bool\": {\r\n" + "            \"must\": [\r\n" + "                {\r\n"
				+ "                    \"terms\": {\r\n" + "                        \"blogsite_id\": [" + ids_
				+ "],\r\n" + "                        \"boost\": 1.0\r\n" + "                    }\r\n"
				+ "                },\r\n" + "                {\r\n" + "                    \"range\": {\r\n"
				+ "                        \"date\": {\r\n" + "                            \"from\": \"" + date_from
				+ "\",\r\n" + "                            \"to\": \"" + date_to + "\",\r\n"
				+ "                            \"include_lower\": true,\r\n"
				+ "                            \"include_upper\": true,\r\n"
				+ "                            \"boost\": 1.0\r\n" + "                        }\r\n"
				+ "                    }\r\n" + "                }\r\n" + "            ],\r\n"
				+ "            \"adjust_pure_negative\": true,\r\n" + "            \"boost\": 1.0\r\n" + "        }\r\n"
				+ "    },\r\n" + "    \"_source\": false,\r\n" + "    \"stored_fields\": \"_none_\",\r\n"
				+ "    \"aggregations\": {\r\n" + "        \"groupby\": {\r\n" + "            \"composite\": {\r\n"
				+ "                \"size\": 1000,\r\n" + "                \"sources\": [\r\n"
				+ "                    {\r\n" + "                        \"dat\": {\r\n"
				+ "                            \"terms\": {\r\n"
				+ "                                \"field\": \"language.keyword\",\r\n"
				+ "                                \"missing_bucket\": true,\r\n"
				+ "                                \"order\": \"asc\"\r\n" + "                            }\r\n"
				+ "                        }\r\n" + "                    }\r\n" + "                ]\r\n"
				+ "            },\r\n" + "            \"aggregations\": {\r\n" + "                \"dat\": {\r\n"
				+ "                    \"filter\": {\r\n" + "                        \"exists\": {\r\n"
				+ "                            \"field\": \"language\",\r\n"
				+ "                            \"boost\": 1.0\r\n" + "                        }\r\n"
				+ "                    }\r\n" + "                }\r\n" + "            }\r\n" + "        }\r\n"
				+ "    }\r\n" + "}");

		JSONObject myResponse = this._makeElasticRequest(query, "144.167.115.90", 9200, "POST", "/blogposts/_search/?");
		String val=null;
		Integer freq = null;
		String idx = null;
		String language = null;
		JSONArray jsonArray = new JSONArray();
		
		if (null != myResponse.get("aggregations")) {
			Object buckets = myResponse.getJSONObject("aggregations").getJSONObject("groupby").getJSONArray("buckets");
//			Object total = myResponse.getJSONObject("hits").getJSONObject("total").get("value");

//			JSONObject myRes1 = new JSONObject(buckets);
			val = buckets.toString();
			jsonArray = new JSONArray(val);

			System.out.println("DONE GETTING POSTS FOR BLOGGER");

		}
//		JSONArray jsonArray = this._elastic(query);
//		String source = null;
//		String source_ = null;
//		String result = null;
//
//		System.out.println("DONE GETTING POSTS FOR BLOGGER");
		if (jsonArray != null) {
			
			for (int i = 0; i < limit; i++) {
				JSONObject da = new JSONObject();
				idx = jsonArray.get(i).toString();
				
				JSONObject j = new JSONObject(idx);
				freq = (Integer)j.get("doc_count");
				
				Object k = j.getJSONObject("key").get("dat");
				language = k.toString();
//				String ids = j.get("_source").toString();
//				j = new JSONObject(ids);
//				String src = j.get("post").toString();
//
//				list.add(src);
				da.put("letter", language);
				da.put("frequency", freq);
				
				all.put(da);
				hm.put(language, freq);
			}
			
//
//			System.out.println("DONE and size of list is --" + list.size());
//			result = String.join(" ", list);
		}

		return all;
	}

	public JSONObject _keywordTermvctors(String data) throws Exception {
		String result = null;
		String source = null;
		String source_ = null;
		JSONObject d = new JSONObject();
//		LinkedHashMap<String, Integer> sortedMap = new LinkedHashMap<>();
		Map<String, Integer> hm1 = new HashMap<>();

		System.out.println(data.length());
		if (data.length() > 0) {

			JSONObject query = new JSONObject("{\r\n" + "    \"doc\": {\r\n" + "      \"post\": \"" + data + "\"\r\n"
					+ "    },\r\n" + "    \"term_statistics\" : true,\r\n" + "    \"field_statistics\" : true,\r\n"
					+ "    \"positions\": false,\r\n" + "    \"offsets\": false,\r\n" + "    \"filter\" : {\r\n"
					+ "      \"max_num_terms\" : 1000,\r\n" + "      \"min_term_freq\" : 1,\r\n"
					+ "      \"min_doc_freq\" : 1,\r\n" + "      \"min_word_length\":3\r\n" + "	\r\n" + "    }\r\n"
					+ "}");
			
				JSONObject myResponse = this._makeElasticRequest(query, "144.167.115.90", 9200, "POST", "/blogposts/_termvectors");
				
				Object hits = myResponse.getJSONObject("term_vectors").getJSONObject("post").getJSONObject("terms");

				source = hits.toString();
				System.out.println("GETTING TERM VECTORS");
				JSONObject jsonObject = new JSONObject(source);
				Iterator<String> keys = jsonObject.keys();

				source_ = keys.next();

				System.out.println("DONE GETTING TERM VECTORS");
				HashMap<String, Integer> hm = new HashMap<String, Integer>();
				while (keys.hasNext()) {
					String key = keys.next();
					Object freq = jsonObject.getJSONObject(key).get("term_freq");
					Integer f = (Integer) freq;
					hm.put(key, f);
				
				}

				hm1 = this.sortHashMapByValues(hm);
				System.out.println("DONE SORTING OBJECT");
				System.out.println(" OCCURES-- " + hm1);

				Map.Entry<String, Integer> entry = hm1.entrySet().iterator().next();
				source = entry.getKey().toUpperCase();
				Integer value = entry.getValue();

				System.out.println("HIGHEST TERM IS -- " + source + " OCCURING " + value + " TIMES");

				String da = hm1.toString();
				d = new JSONObject(hm1);
				System.out.println(d);

		} else {
			source = "Null";
		}
		return d;

	}

	public String _getMostKeywordDashboard(String date_from, String date_to, String ids_) throws Exception {
		//
		ArrayList<String> list = new ArrayList<String>();
		String result = null;
		JSONObject query = new JSONObject("{\r\n" + "    \"size\": 10000,\r\n" + "    \"query\": {\r\n"
				+ "        \"bool\": {\r\n" + "            \"must\": [\r\n" + "                {\r\n"
				+ "                    \"terms\": {\r\n" + "                        \"blogsite_id\": [" + ids_
				+ "],\r\n" + "                        \"boost\": 1.0\r\n" + "                    }\r\n"
				+ "                },\r\n" + "                {\r\n" + "                    \"range\": {\r\n"
				+ "                        \"date\": {\r\n" + "                            \"from\": \"" + date_from
				+ "\",\r\n" + "                            \"to\": \"" + date_to + "\",\r\n"
				+ "                            \"include_lower\": true,\r\n"
				+ "                            \"include_upper\": true,\r\n"
				+ "                            \"boost\": 1.0\r\n" + "                        }\r\n"
				+ "                    }\r\n" + "                }\r\n" + "            ],\r\n"
				+ "            \"adjust_pure_negative\": true,\r\n" + "            \"boost\": 1.0\r\n" + "        }\r\n"
				+ "    },\r\n" + "    \"_source\": {\r\n" + "        \"includes\": [\r\n" + "            \"post\"\r\n"
				+ "        ],\r\n" + "        \"excludes\": []\r\n" + "    },\r\n" + "    \"sort\": [\r\n"
				+ "        {\r\n" + "            \"influence_score\": {\r\n"
				+ "                \"order\": \"desc\",\r\n" + "                \"missing\": \"_first\",\r\n"
				+ "                \"unmapped_type\": \"float\"\r\n" + "            }\r\n" + "        }\r\n"
				+ "    ]\r\n" + "}");

		JSONArray jsonArray = this._elastic(query);

		System.out.println("DONE GETTING POSTS FOR BLOGGER");
		if (jsonArray != null) {
			for (int i = 0; i < jsonArray.length(); i++) {
				String indx = jsonArray.get(i).toString();
				JSONObject j = new JSONObject(indx);
				String ids = j.get("_source").toString();
				j = new JSONObject(ids);
				String src = j.get("post").toString();

				list.add(src);
			}

			System.out.println("DONE and size of list is --" + list.size());
			result = String.join(" ", list);
		}

//		}

//		esClient.close();

		result = this.escape(result);
		System.out.println("Done Escaped the necessary");

		System.out.println("Done remmoving stop words");
		return result.replace("(adsbygoogle = window.adsbygoogle || []).push({}); ", "");
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

	public LinkedHashMap<String, Integer> sortHashMapByValues(HashMap<String, Integer> passedMap) {
		List<String> mapKeys = new ArrayList<>(passedMap.keySet());
		List<Integer> mapValues = new ArrayList<>(passedMap.values());
		Collections.sort(mapValues, Collections.reverseOrder());
		Collections.sort(mapKeys, Collections.reverseOrder());

		LinkedHashMap<String, Integer> sortedMap = new LinkedHashMap<>();

		Iterator<Integer> valueIt = mapValues.iterator();
		while (valueIt.hasNext()) {
			Integer val = valueIt.next();
			Iterator<String> keyIt = mapKeys.iterator();

			while (keyIt.hasNext()) {
				String key = keyIt.next();
				Integer comp1 = passedMap.get(key);
				Integer comp2 = val;

				if (comp1.equals(comp2)) {
					keyIt.remove();
					sortedMap.put(key, val);
					break;
				}
			}
		}
		return sortedMap;
	}

	public String _termVectors(String data) throws Exception {
		String result = null;
		String source = null;
		String source_ = null;
		System.out.println(data.length());
		if (data.length() > 0) {
//		JSONObject jsonObj = new JSONObject("{\r\n" + "  \"query\": {\r\n" + "    \"constant_score\":{\r\n"
//				+ "			\"filter\":{\r\n" + "					\"terms\":{\r\n"
//				+ "							\"blogpost_id\":[\"" + ids + "\"]\r\n" + "							}\r\n"
//				+ "					}\r\n" + "				}\r\n" + "    }\r\n" + "}");
			JSONObject query = new JSONObject("{\r\n" + "    \"doc\": {\r\n" + "      \"post\": \"" + data + "\"\r\n"
					+ "    },\r\n" + "    \"term_statistics\" : true,\r\n" + "    \"field_statistics\" : true,\r\n"
					+ "    \"positions\": false,\r\n" + "    \"offsets\": false,\r\n" + "    \"filter\" : {\r\n"
					+ "      \"max_num_terms\" : 100,\r\n" + "      \"min_term_freq\" : 1,\r\n"
					+ "      \"min_doc_freq\" : 1,\r\n" + "      \"min_word_length\":3\r\n" + "	\r\n" + "    }\r\n"
					+ "}");
				
				JSONObject myResponse = this._makeElasticRequest(query, "144.167.115.90", 9200, "POST", "/blogposts/_termvectors");
				
				Object hits = myResponse.getJSONObject("term_vectors").getJSONObject("post").getJSONObject("terms");
				source = hits.toString();

				JSONObject jsonObject = new JSONObject(source);
				Iterator<String> keys = jsonObject.keys();

				source_ = keys.next();

				System.out.println("DONE GETTING TERM VECTORS");
				HashMap<String, Integer> hm = new HashMap<String, Integer>();
				while (keys.hasNext()) {
					String key = keys.next();
					// do something with jsonObject here
					Object freq = jsonObject.getJSONObject(key).get("term_freq");
					Integer f = (Integer) freq;

					// enter data into hashmap
					hm.put(key, f);


				}
				System.out.println("2--" + data.length());
				Map<String, Integer> hm1 = this.sortHashMapByValues(hm);
				System.out.println("DONE SORTING OBJECT");
				System.out.println(" OCCURES-- " + hm1);

				Map.Entry<String, Integer> entry = hm1.entrySet().iterator().next();
				source = entry.getKey().toUpperCase();
				Integer value = entry.getValue();

				System.out.println("HIGHEST TERM IS -- " + source + " OCCURING " + value + " TIMES");

		} else {
			source = "Null";
		}
		return source;

	}

	public String _getBloggerPosts(String bloggerName, String date_from, String date_to, String ids_) throws Exception {
//	
		ArrayList<String> list = new ArrayList<String>();
		ArrayList<String> _idlist = new ArrayList<String>();
		JSONObject query = new JSONObject("{\r\n" + "    \"size\": 10000,\r\n" + "    \"query\": {\r\n"
				+ "        \"bool\": {\r\n" + "            \"must\": [\r\n" + "                {\r\n"
				+ "                    \"bool\": {\r\n" + "                        \"must\": [\r\n"
				+ "                            {\r\n" + "                                \"term\": {\r\n"
				+ "                                    \"blogger.keyword\": {\r\n"
				+ "                                        \"value\": \"" + bloggerName + "\",\r\n"
				+ "                                        \"boost\": 1.0\r\n"
				+ "                                    }\r\n" + "                                }\r\n"
				+ "                            },\r\n" + "                            {\r\n"
				+ "                                \"terms\": {\r\n"
				+ "                                    \"blogsite_id\": [" + ids_ + "],\r\n"
				+ "                                    \"boost\": 1.0\r\n" + "                                }\r\n"
				+ "                            }\r\n" + "                        ],\r\n"
				+ "                        \"adjust_pure_negative\": true,\r\n"
				+ "                        \"boost\": 1.0\r\n" + "                    }\r\n" + "                },\r\n"
				+ "                {\r\n" + "                    \"range\": {\r\n"
				+ "                        \"date\": {\r\n" + "                            \"from\": \"" + date_from
				+ "\",\r\n" + "                            \"to\": \"" + date_to + "\",\r\n"
				+ "                            \"include_lower\": true,\r\n"
				+ "                            \"include_upper\": true,\r\n"
				+ "                            \"boost\": 1.0\r\n" + "                        }\r\n"
				+ "                    }\r\n" + "                }\r\n" + "            ],\r\n"
				+ "            \"adjust_pure_negative\": true,\r\n" + "            \"boost\": 1.0\r\n" + "        }\r\n"
				+ "    },\r\n" + "    \"_source\": {\r\n" + "        \"includes\": [\r\n" + "            \"post\"\r\n"
				+ "        ],\r\n" + "        \"excludes\": []\r\n" + "    },\r\n" + "    \"sort\": [\r\n"
				+ "        {\r\n" + "            \"influence_score\": {\r\n"
				+ "                \"order\": \"desc\",\r\n" + "                \"missing\": \"_first\",\r\n"
				+ "                \"unmapped_type\": \"float\"\r\n" + "            }\r\n" + "        }\r\n"
				+ "    ]\r\n" + "}");

		RestClient esClient = RestClient.builder(new HttpHost("144.167.115.90", 9200, "http")).build();
//		RestHighLevelClient client = new RestHighLevelClient(
//				RestClient.builder(new HttpHost("localhost", 9200, "http")));

		Request request = new Request("POST", "/blogposts/_search/?");
		request.setJsonEntity(query.toString());

		Response response = esClient.performRequest(request);
		String source = null;
		String source_ = null;
		String result = null;
		JSONArray jsonArray = null;
		String jsonResponse = EntityUtils.toString(response.getEntity());

		Object j_ = new JSONObject(response.getEntity());

		JSONObject myResponse = new JSONObject(jsonResponse);
		System.out.println("response-" + j_);
		if (bloggerName != "" || bloggerName != null) {
			System.out.println("nameblogger" + bloggerName);
			if (null != myResponse.get("hits")) {
				Object hits = myResponse.getJSONObject("hits").getJSONArray("hits");
				Object total = myResponse.getJSONObject("hits").getJSONObject("total").get("value");
//			JSONArray hits_ = myResponse.getJSONArray("hits");

				JSONObject myRes1 = new JSONObject(hits);
				source = hits.toString();

//			this.totalpost = total;
//
				jsonArray = new JSONArray(source);

//			System.out.print("--"+src);
//			System.out.print("----"+jsonArray.length());
				System.out.println("DONE GETTING POSTS FOR BLOGGER");
				if (jsonArray != null) {
////////				int len = jsonArray.length();
					for (int i = 0; i < jsonArray.length(); i++) {
//////					System.out.println();
						String indx = jsonArray.get(i).toString();
						JSONObject j = new JSONObject(indx);
						String ids = j.get("_source").toString();
						String _ids = j.get("_id").toString();

						j = new JSONObject(ids);
//						JSONObject _j = new JSONObject(_ids);

						String src = j.get("post").toString();

						list.add(src);
						_idlist.add("\"" + _ids + "\"");
					}

					System.out.println("DONE and size of list is --" + list.size());
//					System.out.println("IDS_ are --" + _idlist);
					result = String.join(" ", list);
				}

//			XContentBuilder docBuilder = XContentFactory.jsonBuilder();
//			docBuilder.startObject().field("post", "guest-user").endObject();
//			TermVectorsRequest request1 = new TermVectorsRequest("blogposts",docBuilder); 
//			
//			request1.setFieldStatistics(false); 
//			request1.setTermStatistics(true); 
//			request1.setPositions(false); 
//			request1.setOffsets(false); 
//			request1.setPayloads(false); 
//
//			Map<String, Integer> filterSettings = new HashMap<>();
//			filterSettings.put("max_num_terms", 3);
//			filterSettings.put("min_term_freq", 1);
//			filterSettings.put("max_term_freq", 10);
//			filterSettings.put("min_doc_freq", 1);
//			filterSettings.put("max_doc_freq", 100);
//			filterSettings.put("min_word_length", 1);
//			filterSettings.put("max_word_length", 10);
//			
//			request1.setFilterSettings(filterSettings);
//			
//			org.elasticsearch.client.core.TermVectorsResponse response1 = client.termvectors(request1, RequestOptions.DEFAULT);
//			
//			String index = response1.getIndex(); 
//			
//			String id = response1.getId(); 
//			boolean found = response1.getFound(); 
//			
//			System.out.print("index-"+index);

			}
		}
//		RestHighLevelClient client = new RestHighLevelClient(
//        RestClient.builder(
//                new HttpHost("localhost", 9200, "http"),
//                new HttpHost("localhost", 9201, "http")));
//
////		RestClient restClient = RestClient
////				.builder(new HttpHost("localhost", 9200, "http"), new HttpHost("localhost", 9201, "http")).build();
//
//		Request request = null;
////		String url = base_url_test + "_search";
//		
//
////
////		RestClient restClient = RestClient.builder(new HttpHost("localhost", 9200, "http")).build();
////		
//		
//		SearchResponse response = client.prepareSearch("blogposts")
//                .setQuery(query)
//                .execute()
//                .actionGet();

//		SearchResponse response2 = client.prepareSearch("index1", "index2")
//		        .setSearchType(SearchType.DFS_QUERY_THEN_FETCH)
//		        .setQuery(QueryBuilders.termQuery("multi", "test"))                 // Query
//		        .setPostFilter(QueryBuilders.rangeQuery("age").from(12).to(18))     // Filter
//		        .setFrom(0).setSize(60).setExplain(true)
//		        .get();

//		Request request = new Request("POST", "/blogposts/_search");
//		request.addParameter("pretty", "true");
//		request.setEntity(new NStringEntity(query, ContentType.APPLICATION_JSON));
//		Response response = null;
//		try {
//		response = restClient.performRequest(request);
//		} catch (IOException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//		
//		
//		HttpEntity entity = new NStringEntity(query,ContentType.APPLICATION_JSON);
//		Response response = restClient.performRequest("GET", "/hist_latest_5.5.0/_search",Collections.<String, String>emptyMap(),entity);
//		Response response = client.performRequest("POST","/_search",emptyMap(),entity);
////		Response response = restClient.performRequest("POST","/_search",emptyMap(),entity);
////		SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
////		SearchModule searchModule = new SearchModule(Settings.EMPTY, false, Collections.emptyList());
////		try (XContentParser parser = XContentFactory.xContent(XContentType.JSON).createParser(new NamedXContentRegistry(searchModule
////		            .getNamedXContents()), query)) {
////		    searchSourceBuilder.parseXContent(parser);
////		}
////		
//		IndexResponse response = client.prepareIndex("blogposts", "_doc")
//		        .setSource(json, XContentType.JSON)
//		        .get();
////		
////		JSONObject jsonObj = new JSONObject(que);
////		ArrayList result = this._getResult(url, jsonObj);
//
////		return this._getResult(url, jsonObj);
//		System.out.println("response--" + jsonResponse);
		esClient.close();
//		client.close();

//		result = result.replace("/","//");
//		String q = query.toString();
//		q = q.replaceAll("[^a-zA-Z0-9\\s+:]", "");
		result = this.escape(result);
		System.out.println("Done Escaped the necessary");
//		result = stop.removeStopWords(result);
		System.out.println("Done remmoving stop words");
		return result.replace("(adsbygoogle = window.adsbygoogle || []).push({}); ", "");
	}

	public ArrayList _testbloggertranslate(String blogger, String start) throws Exception {
//		JSONObject jsonObj = new JSONObject(
//				"{\r\n" + "    \"query\": \"SELECT post FROM blogposts where blogger=\"" + blogger + "\"\r\n" + "}");

		JSONObject jsonObj = new JSONObject(
				"{\r\n" + "    \"query\": \"SELECT post FROM blogposts where blogger='" + blogger + "'\"\r\n" + "}");

		System.out.println("ress--" + jsonObj);
		String url = "http://localhost:9200/_xpack/sql/translate";

		return this._getsqlTranslated(url, jsonObj, start);
	}

	public ArrayList _getsqlTranslated(String url, JSONObject jsonObj, String start) throws Exception {
		ArrayList<String> list = new ArrayList<String>();
		ArrayList<String> list2 = new ArrayList<String>();

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

			// OutputStreamWriter wr1 = new OutputStreamWriter(con.getOutputStream());
			wr.write(jsonObj.toString().getBytes());
			wr.flush();

			int responseCode = con.getResponseCode();
			BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
//			System.out.println("--"+in);
			String inputLine;
			StringBuffer response = new StringBuffer();

			while ((inputLine = in.readLine()) != null) {
				response.append(inputLine);
//				 System.out.println(inputLine);

				list.add(inputLine);

			}
			in.close();

			JSONObject myResponse = new JSONObject(response.toString());
//			System.out.println(myResponse);

		} catch (Exception ex) {
		}

		// GETTING THE IDS
		String url2 = base_url_test + "_search?";
		JSONObject jsonObj2 = new JSONObject(list.get(0));
		ArrayList res = this._getResult(url2, jsonObj2);

		try {
			if (res.size() > 0) {

				for (int i = 0; i < res.size(); i++) {
					String indx = res.get(i).toString();
					JSONObject j = new JSONObject(indx);
					String ids = j.get(start).toString();
					j = new JSONObject(ids);
					String src = j.get("post").toString();

					list2.add(src);
				}
			}
		} catch (Exception e) {
			System.err.println(e);
		}
		return list2;

	}

	public String _getrawquery(String url, JSONObject jsonObj) throws Exception {
		ArrayList<String> list = new ArrayList<String>();
		ArrayList<String> list2 = new ArrayList<String>();

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

			// OutputStreamWriter wr1 = new OutputStreamWriter(con.getOutputStream());
			wr.write(jsonObj.toString().getBytes());
			wr.flush();

			int responseCode = con.getResponseCode();
			BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
//			System.out.println("--"+in);
			String inputLine;
			StringBuffer response = new StringBuffer();

			while ((inputLine = in.readLine()) != null) {
				response.append(inputLine);
//				 System.out.println(inputLine);

				list.add(inputLine);

			}
			in.close();

			JSONObject myResponse = new JSONObject(response.toString());
//			System.out.println(myResponse);

		} catch (Exception ex) {
		}

		String indx = list.get(0).toString();
		JSONObject j = new JSONObject(indx);
		String trmvec = j.get("term_vectors").toString();
		j = new JSONObject(trmvec);

		String src = j.get("post").toString();
		j = new JSONObject(src);

		String trms = j.get("terms").toString();
		j = new JSONObject(trms);

		Iterator<String> keys = j.keys();
		String strName = keys.next();
//		System.out.println("terms---"+trms);
		System.out.println("terms---" + strName);
		return strName;
	}

	public String _getbloggermostterms(String blogger) throws Exception {

		// GETTING THE TERMS
		ArrayList list = this._testbloggertranslate(blogger, "_source");
		JSONObject list_ = new JSONObject(list);

		String url = base_url_test + "_termvectors";
		JSONObject jsonObj = new JSONObject(
				"{\r\n" + "    \"doc\": {\r\n" + "      \"post\": \"" + list.get(0) + "\"\r\n" + "    },\r\n"
						+ "    \"term_statistics\" : true,\r\n" + "    \"field_statistics\" : true,\r\n"
						+ "    \"positions\": false,\r\n" + "    \"offsets\": false,\r\n" + "    \"filter\" : {\r\n"
						+ "      \"max_num_terms\" : 25,\r\n" + "      \"min_term_freq\" : 1,\r\n"
						+ "      \"min_doc_freq\" : 1,\r\n" + "      \"min_word_length\":1\r\n" + "    }\r\n" + "}");

//				ArrayList res2 = this._getResult(url3, jsonObj3);
		System.out.println("This is the term query for -----" + url + "-----" + jsonObj);
//				System.out.println("term vector -----" + list);

		return this._getrawquery(url, jsonObj);
	}

}