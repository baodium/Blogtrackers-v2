package util;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.FileWriter;
//import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import org.json.JSONObject;

/*import com.mysql.jdbc.Connection;*/

import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import authentication.DbConnection;

import org.apache.commons.text.StringEscapeUtils;
import org.apache.http.HttpHost;
import org.apache.http.util.EntityUtils;
//import org.apache.http.HttpEntity;
//import org.apache.http.HttpHost;
//import org.apache.http.entity.ContentType;
//import org.apache.http.nio.entity.NStringEntity;
import org.elasticsearch.client.*;
import org.elasticsearch.client.core.TermVectorsRequest;
import org.elasticsearch.client.core.TermVectorsResponse;
import org.elasticsearch.common.xcontent.XContentBuilder;
//import org.elasticsearch.client.RestHighLevelClient;
//import org.elasticsearch.transport.InboundMessage.Response;
import org.json.JSONArray;
import org.json.JSONException;

import java.io.OutputStreamWriter;
import static java.util.stream.Collectors.toMap;

public class Blogposts {

	HashMap<String, String> hm = DbConnection.loadConstant();

	String base_url = hm.get("elasticIndex") + "blogposts/"; // - For testing server

	String elasticUrl = hm.get("elasticUrl");

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

	public String _getTotal(String term) {

		JSONObject query = new JSONObject();
		if (!term.equals("")) {
			query = new JSONObject("{\r\n" + "  \r\n" + "    \"query\": {\r\n" + "        \"query_string\": {\r\n"
					+ "            \"query\": \"" + term + "\",\r\n" + "            \"fields\": [\r\n"
					+ "                \"title\",\r\n" + "                \"blogger\",\r\n"
					+ "                \"post\"\r\n" + "            ]\r\n" + "        }\r\n" + "    }\r\n" + "}");

		} else {
			query = new JSONObject(
					"{\r\n" + "    \"query\": {\r\n" + "        \"match_all\": {}\r\n" + "    }\r\n" + "}");
		}

		System.out.println("this is the query for _getTotal" + query);
		String total = null;
		JSONObject myResponse;
		try {
			myResponse = this._makeElasticRequest(query, "POST", "/blogposts/_count?");
			if (null != myResponse.get("count")) {
				Object hits = myResponse.get("count");
				total = hits.toString();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return total;
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
			result = db.query("SELECT blogpost_id FROM blogposts WHERE blogger in( " + bloggers + ") AND " + field
					+ ">='" + greater + "' AND " + field + "<='" + less + "' ORDER BY " + sort + " " + order + " LIMIT "
					+ size + "");
			// result = db.queryJSON("SELECT * FROM blogposts WHERE blogger = '"+bloggers+"'
			// AND "+field+">="+greater+" AND "+field+"<="+less+" ORDER BY date ASC LIMIT
			// "+size+"");
			System.out.println("SELECT1 blogpost_id FROM blogposts WHERE blogger in( " + bloggers + ") AND " + field
					+ ">='" + greater + "' AND " + field + "<='" + less + "' ORDER BY " + sort + " " + order + " LIMIT "
					+ size + "");
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

	public JSONObject _newGetBloggerByBloggerName(String field, String greater, String less, String bloggers,
			String order) throws Exception {

		JSONObject query = new JSONObject("{\r\n" + "    \"size\": 50,\r\n" + "    \"query\": {\r\n"
				+ "        \"bool\": {\r\n" + "            \"must\": [\r\n" + "                {\r\n"
				+ "                    \"terms\": {\r\n" + "                        \"blogger.keyword\": [" + bloggers
				+ "],\r\n" + "                        \"boost\": 1.0\r\n" + "                    }\r\n"
				+ "                },\r\n" + "                {\r\n" + "                    \"range\": {\r\n"
				+ "                        \"date\": {\r\n" + "                            \"from\": \"" + greater
				+ "\",\r\n" + "                            \"to\": \"" + less + "\",\r\n"
				+ "                            \"include_lower\": true,\r\n"
				+ "                            \"include_upper\": true,\r\n"
				+ "                            \"boost\": 1.0\r\n" + "                        }\r\n"
				+ "                    }\r\n" + "                }\r\n" + "            ],\r\n"
				+ "            \"adjust_pure_negative\": true,\r\n" + "            \"boost\": 1.0\r\n" + "        }\r\n"
				+ "    },\r\n" + "    \"_source\": {\r\n" + "        \"includes\": [\r\n"
				+ "            \"@version\",\r\n" + "            \"blogger\",\r\n" + "            \"blogpost_id\",\r\n"
				+ "            \"blogsite_id\",\r\n" + "            \"categories\",\r\n"
				+ "            \"influence_score\",\r\n" + "            \"language\",\r\n"
				+ "            \"location\",\r\n" + "            \"num_comments\",\r\n"
				+ "            \"num_inlinks\",\r\n" + "            \"num_outlinks\",\r\n"
				+ "            \"permalink\",\r\n" + "            \"post\",\r\n" + "            \"post_length\",\r\n"
				+ "            \"sentiment\",\r\n" + "            \"tags\",\r\n" + "            \"title\"\r\n"
				+ "        ],\r\n" + "        \"excludes\": []\r\n" + "    },\r\n" + "    \"docvalue_fields\": [\r\n"
				+ "        {\r\n" + "            \"field\": \"@timestamp\",\r\n"
				+ "            \"format\": \"epoch_millis\"\r\n" + "        },\r\n" + "        {\r\n"
				+ "            \"field\": \"date\",\r\n" + "            \"format\": \"yyyy-MM-dd\"\r\n"
				+ "        }\r\n" + "    ],\r\n" + "    \"sort\": [\r\n" + "        {\r\n" + "            \"" + field
				+ "\": {\r\n" + "                \"order\": \"" + order + "\",\r\n"
				+ "                \"missing\": \"_first\",\r\n" + "                \"unmapped_type\": \"date\"\r\n"
				+ "            }\r\n" + "        }\r\n" + "    ]\r\n" + "}");

		ArrayList<String> list = new ArrayList<String>();

		String source = null;

		System.out.println("this is the query _newGetBloggerByBloggerName-" + query);
		JSONArray jsonArray = null;

		JSONObject all_data = new JSONObject();

		try {
			JSONObject myResponse = this._makeElasticRequest(query, "POST", "/blogposts/_search/?scroll=1m");

			System.out.println(hm.get("elasticIndex") + "==" + query);

			if (null != myResponse.get("hits")) {

				Object hits = myResponse.getJSONObject("hits").getJSONArray("hits");
				Object total = myResponse.getJSONObject("hits").getJSONObject("total").get("value");
				source = hits.toString();
				jsonArray = new JSONArray(source);
				System.out.println("DONE GETTING POSTS FOR BLOGGER");

				all_data.put("total", total.toString());
				all_data.put("hit_array", jsonArray);

			}
		} catch (Exception e) {
		}
		return all_data;
	}

	public JSONObject _getPostByBlogID(String ids, String greater, String less) throws Exception {

		JSONObject query = new JSONObject("{\r\n" + "    \"size\": 1000,\r\n" + "    \"query\": {\r\n"
				+ "        \"bool\": {\r\n" + "            \"must\": [\r\n" + "                {\r\n"
				+ "                    \"terms\": {\r\n" + "                        \"blogsite_id\": [" + ids + "],\r\n"
				+ "                        \"boost\": 1.0\r\n" + "                    }\r\n" + "                },\r\n"
				+ "                {\r\n" + "                    \"range\": {\r\n"
				+ "                        \"date\": {\r\n" + "                            \"from\": \"" + greater
				+ "\",\r\n" + "                            \"to\": \"" + less + "\",\r\n"
				+ "                            \"include_lower\": true,\r\n"
				+ "                            \"include_upper\": true,\r\n"
				+ "                            \"boost\": 1.0\r\n" + "                        }\r\n"
				+ "                    }\r\n" + "                }\r\n" + "            ],\r\n"
				+ "            \"adjust_pure_negative\": true,\r\n" + "            \"boost\": 1.0\r\n" + "        }\r\n"
				+ "    },\r\n" + "    \"_source\": {\r\n" + "        \"includes\": [\r\n"
				+ "            \"@version\",\r\n" + "            \"blogger\",\r\n" + "            \"blogpost_id\",\r\n"
				+ "            \"blogsite_id\",\r\n" + "            \"categories\",\r\n"
				+ "            \"influence_score\",\r\n" + "            \"language\",\r\n"
				+ "            \"location\",\r\n" + "            \"num_comments\",\r\n"
				+ "            \"num_inlinks\",\r\n" + "            \"num_outlinks\",\r\n"
				+ "            \"permalink\",\r\n" + "            \"post\",\r\n" + "            \"post_length\",\r\n"
				+ "            \"sentiment\",\r\n" + "            \"tags\",\r\n" + "            \"title\"\r\n"
				+ "        ],\r\n" + "        \"excludes\": []\r\n" + "    },\r\n" + "    \"docvalue_fields\": [\r\n"
				+ "        {\r\n" + "            \"field\": \"@timestamp\",\r\n"
				+ "            \"format\": \"epoch_millis\"\r\n" + "        },\r\n" + "        {\r\n"
				+ "            \"field\": \"date\",\r\n" + "            \"format\": \"yyyy-MM-dd\"\r\n"
				+ "        }\r\n" + "    ],\r\n" + "    \"sort\": [\r\n" + "        {\r\n"
				+ "            \"influence_score\": {\r\n" + "                \"order\": \"desc\",\r\n"
				+ "                \"missing\": \"_last\",\r\n" + "                \"unmapped_type\": \"float\"\r\n"
				+ "            }\r\n" + "        }\r\n" + "    ]\r\n" + "}");

		ArrayList<String> list = new ArrayList<String>();

		String source = null;

		System.out.println("this is the query _getPostByBlogID-" + query);
		JSONArray jsonArray = null;

		JSONObject all_data = new JSONObject();

		try {
			JSONObject myResponse = this._makeElasticRequest(query, "POST", "/blogposts/_search/?scroll=1m");
			System.out.println(hm.get("elasticIndex") + "==" + query);

			if (null != myResponse.get("hits")) {

				Object hits = myResponse.getJSONObject("hits").getJSONArray("hits");
				Object total = myResponse.getJSONObject("hits").getJSONObject("total").get("value");
				source = hits.toString();
				jsonArray = new JSONArray(source);
				System.out.println("DONE GETTING POSTS FOR BLOGGER");

				all_data.put("total", total.toString());
				all_data.put("hit_array", jsonArray);

			}
		} catch (Exception e) {
		}
		return all_data;
	}

	public ArrayList _getBloggerByBloggerName(String field, String greater, String less, String bloggers, String sort,
			String order) throws Exception {
		int size = 50;
		DbConnection db = new DbConnection();
		String count = "0";
		ArrayList result = new ArrayList();
		try {
//			result = db.queryJSON("SELECT *  FROM blogposts WHERE blogger = '" + bloggers + "' AND " + field + ">='"
//					+ greater + "' AND " + field + "<='" + less + "' ORDER BY " + sort + " " + order + " LIMIT " + size
//					+ "");

//			return all_data;
			// result = db.queryJSON("SELECT * FROM blogposts WHERE blogger = '"+bloggers+"'
			// AND "+field+">="+greater+" AND "+field+"<="+less+" ORDER BY date ASC LIMIT
			// "+size+"");
//			System.out.println("blogpost _getBloggerByBloggerName--"+"SELECT *  FROM blogposts WHERE blogger = '" + bloggers + "' AND " + field + ">='"
//					+ greater + "' AND " + field + "<='" + less + "' ORDER BY " + sort + " " + order + " LIMIT " + size
//					+ "");
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
					.query("SELECT max(influence_score) as total, blogger_name,date FROM blogger WHERE blogger_name = '"
							+ bloggers + "'  ORDER BY influence_score DESC LIMIT 1");
			System.out.println("query for _searchRangeMaxTotalByBloggers"
					+ "SELECT max(influence_score) as total, blogger_name,date FROM blogger WHERE blogger_name = '"
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

	public String _searchMinAndMaxRangeMaxByBloggers(String field, String greater, String less, String bloggers)
			throws Exception {

		String count = "0";
		try {
			ArrayList response = DbConnection
					.query("SELECT MAX(influence_score) as total FROM blogposts WHERE blogger='" + bloggers + "' AND "
							+ field + ">='" + greater + "' AND " + field + " <='" + less + "' ");
			System.out.println("response--" + response);
			if (response.size() > 0) {
				ArrayList hd = (ArrayList) response.get(0);
				count = hd.get(0).toString();
			}
		} catch (Exception e) {

			return count;

		}

		return count;
	}

//	public String _searchMaxInfluence() throws Exception {
//
//		String count = "0";
//
//		try {
//			ArrayList response = DbConnection.query("SELECT max(influence_score) as total, blogger,date FROM blogger ");
//			if (response.size() > 0) {
//				ArrayList hd = (ArrayList) response.get(0);
//				count = hd.get(0).toString();
//			}
//		} catch (Exception e) {
//			return count;
//		}
//
//		return count;
//	}
	public String _searchInfluence2(String agg, String field, String date_from, String date_to, String ids_)
			throws Exception {
		ArrayList<String> list = new ArrayList<String>();
		HashMap<String, Integer> hm2 = new HashMap<String, Integer>();

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
				+ "    \"aggregations\": {\r\n" + "        \"groupby\": {\r\n" + "            \"filters\": {\r\n"
				+ "                \"filters\": [\r\n" + "                    {\r\n"
				+ "                        \"match_all\": {\r\n" + "                            \"boost\": 1.0\r\n"
				+ "                        }\r\n" + "                    }\r\n" + "                ],\r\n"
				+ "                \"other_bucket\": false,\r\n"
				+ "                \"other_bucket_key\": \"_other_\"\r\n" + "            },\r\n"
				+ "            \"aggregations\": {\r\n" + "                \"dat\": {\r\n" + "                    \""
				+ agg + "\": {\r\n" + "                        \"field\": \"" + field + "\"\r\n"
				+ "                    }\r\n" + "                }\r\n" + "            }\r\n" + "        }\r\n"
				+ "    }\r\n" + "}");

		JSONObject myResponse = this._makeElasticRequest(query, "POST", "/blogposts/_search/?");
		String val = null;
		String freq = null;
		String idx = null;
		String language = null;
		JSONArray jsonArray = new JSONArray();

		if (null != myResponse.get("aggregations")) {

			Object buckets = myResponse.getJSONObject("aggregations").getJSONObject("groupby").getJSONArray("buckets")
					.get(0);
			val = buckets.toString();
			JSONObject bucket_ = new JSONObject(val);
			freq = bucket_.getJSONObject("dat").get("value").toString();
			System.out.println("DONE GETTING POSTS--" + freq);

		}
		return freq;
	}

	public String _searchMaxInfluence() throws Exception {

		String count = "0";

		try {
			ArrayList response = DbConnection.query("SELECT max(influence_score) as total, blogger,date FROM blogger ");
			if (response.size() > 0) {
				ArrayList hd = (ArrayList) response.get(0);
				count = hd.get(0).toString();
			}
		} catch (Exception e) {
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

		if (result.size() > 0) {
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
		System.out.println("query for _getBloggerByBlogId" + jsonObj);
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
		term = null;
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
		System.out.println("query for elastic _searchByTitleAndBody --> " + jsonObj);
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
		System.out.println("post query" + jsonObj);
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
		System.out.println(que);
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
			System.out.println(
					"query for _searchRangeTotal" + "SELECT count(*) as total FROM blogposts WHERE blogsite_id IN "
							+ blog_ids + " AND date>='" + greater + "' AND date<='" + less + "' ");
			if (response.size() > 0) {
				ArrayList hd = (ArrayList) response.get(0);
				count = hd.get(0).toString();
			}
		} catch (Exception e) {
			return count;
		}
//		System.out.println("id--" + blog_ids);
//		System.out.println("greater--" + greater);
//		System.out.println("less--" + less);
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
			System.out.println("query for _searchRangeTotalByBlogger --"
					+ "SELECT count(*) as total FROM blogposts WHERE blogger = '" + bloggers + "' AND " + field + ">='"
					+ greater + "' AND " + field + "<='" + less + "' ");
			if (response.size() > 0) {
				ArrayList hd = (ArrayList) response.get(0);
				count = hd.get(0).toString();
			}
		} catch (Exception e) {
			return count;
		}

//		System.out.println("field--" + field);
//		System.out.println("greater--" + greater);
//		System.out.println("less--" + less);
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

			// OutputStreamWriter wr1 = new OutputStreamWriter(con.getOutputStream());
			wr.write(jsonObj.toString().getBytes());
			wr.flush();

			int responseCode = con.getResponseCode();
			BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
			String inputLine;
			StringBuffer response = new StringBuffer();

			while ((inputLine = in.readLine()) != null) {
				response.append(inputLine);
				// System.out.println(inputLine);

			}
			in.close();

			JSONObject myResponse = new JSONObject(response.toString());

			if (null != myResponse.get("hits")) {
				String res = myResponse.get("hits").toString();
				JSONObject myRes1 = new JSONObject(res);
				String total = myRes1.get("total").toString();
				JSONObject total_ = new JSONObject(total);
				this.totalpost = total_.get("value").toString();

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
		// System.out.println("This is the list for -----" + url + "---" + list);
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
//		blog_ids = "(" + blog_ids + ")";

		JSONObject query = new JSONObject(
				"{\r\n" + "    \"query\": {\r\n" + "        \"terms\": {\r\n" + "            \"blogsite_id\": ["
						+ blog_ids + "],\r\n" + "            \"boost\": 1\r\n" + "        }\r\n" + "    }\r\n" + "}");

		try {
//			ArrayList response = DbConnection
//					.query("select sum(blogpost_count) from blogger where blogsite_id in  " + blog_ids + " ");
//			if (response.size() > 0) {
//				ArrayList hd = (ArrayList<?>) response.get(0);
//				count = hd.get(0).toString();
//			}
			count = this._count(query);
		} catch (Exception e) {
			System.out.print("Error in getBlogPostById");
		}
		System.out.println("query for elastic _getBlogPostById --> " + query);
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
	public JSONObject _makeElasticRequest(JSONObject query, String requestType, String endPoint) throws Exception {

		JSONObject myResponse = new JSONObject();
		try {

			RestClient esClient = RestClient.builder(new HttpHost(elasticUrl, 9200, "http")).build();

			Request request = new Request(requestType, endPoint);
			request.setJsonEntity(query.toString());

			Response response = esClient.performRequest(request);
			// System.out.println("=!");
			// System.out.println("GETTING TERM VECTORS");
			String jsonResponse = EntityUtils.toString(response.getEntity());
			myResponse = new JSONObject(jsonResponse);

			esClient.close();

		} catch (Exception e) {
			// System.out.println("Error for elastic request -- > "+e);
		}
		return myResponse;

	}

	public JSONObject _scrollRequest(String scrollID) throws Exception {
		JSONObject result = new JSONObject();
		JSONObject query = new JSONObject(
				"{\r\n" + "    \"scroll\" : \"1m\", \r\n" + "    \"scroll_id\" : \"" + scrollID + "\" \r\n" + "}");

		result = this._makeElasticRequest(query, "POST", "_search/scroll");

		return result;
	}

	public JSONArray merge(JSONArray jsonArray, JSONArray jsonArray1) {

		try {
			for (int i = 0; i < jsonArray1.length(); i++) {
				JSONObject jsonObject = jsonArray1.getJSONObject(i);
				jsonArray.put(jsonObject);
			}

		} catch (JSONException e) {
			e.printStackTrace();
		}
		return jsonArray;
	}

	public JSONObject _elastic(JSONObject query) throws Exception {
		ArrayList<String> list = new ArrayList<String>();

		String source = null;

		System.out.println("this is the query-" + query);
		JSONArray jsonArray = new JSONArray();

		JSONObject all_data = new JSONObject();

		JSONObject myResponse = this._makeElasticRequest(query, "POST", "/blogposts/_search/?scroll=1m");

		System.out.println(hm.get("elasticIndex") + "==" + "==" + query);

		JSONArray allhits = new JSONArray();
		JSONObject scrollResult = new JSONObject();

		String scroll_id = null;

		if (null != myResponse.get("hits")) {

			Object hits = myResponse.getJSONObject("hits").getJSONArray("hits");
			Object total = myResponse.getJSONObject("hits").getJSONObject("total").get("value");
			source = hits.toString();
//			JSONArray J = new JSONArray(source);
			jsonArray = merge(jsonArray, new JSONArray(source));
			// jsonArray.put(new JSONArray(source));
			System.out.println("DONE GETTING POSTS FOR BLOGGER");

			scroll_id = (String) myResponse.get("_scroll_id");

			scrollResult = this._scrollRequest(scroll_id);
			allhits = scrollResult.getJSONObject("hits").getJSONArray("hits");
			source = allhits.toString();
			jsonArray = merge(jsonArray, new JSONArray(source));
			// jsonArray.put(new JSONArray(source));

			for (int i = 0; i < 10; i++) {
				if (allhits.length() <= 0) {
					break;
				}
//			while (allhits.length() > 0) {
				System.out.println("WHILE ---" + allhits.length());
				scroll_id = (String) scrollResult.get("_scroll_id");
				scrollResult = this._scrollRequest(scroll_id);
				allhits = scrollResult.getJSONObject("hits").getJSONArray("hits");
				source = allhits.toString();

				jsonArray = merge(jsonArray, new JSONArray(source));
				// jsonArray.put(new JSONArray(source));
			}

			all_data.put("total", total.toString());
			all_data.put("hit_array", jsonArray);

//			try (FileWriter file = new FileWriter("C:\\Users\\oljohnson\\Desktop\\SQL\\file2.json")) {
//
//				
//
//					
//					file.write(jsonArray.toString());
//					System.out.println("Successfully Copied JSON Object to File...");
//
//				
//
//			}

		}
		System.out.println("DONE");
		return all_data;
	}

	public ArrayList _getPosts(String blog_ids, String from, String to) throws Exception {
		JSONObject que = new JSONObject("{\r\n" + "    \"size\": 1000,\r\n" + "    \"query\": {\r\n"
				+ "        \"bool\": {\r\n" + "            \"must\": [\r\n" + "                {\r\n"
				+ "                    \"terms\": {\r\n" + "                        \"blogsite_id\": [" + blog_ids
				+ "],\r\n" + "                        \"boost\": 1.0\r\n" + "                    }\r\n"
				+ "                },\r\n" + "                {\r\n" + "                    \"range\": {\r\n"
				+ "                        \"date\": {\r\n" + "                            \"from\": \"" + from
				+ "\",\r\n" + "                            \"to\": \"" + to + "\",\r\n"
				+ "                            \"include_lower\": true,\r\n"
				+ "                            \"include_upper\": true,\r\n"
				+ "                            \"boost\": 1.0\r\n" + "                        }\r\n"
				+ "                    }\r\n" + "                }\r\n" + "            ],\r\n"
				+ "            \"adjust_pure_negative\": true,\r\n" + "            \"boost\": 1.0\r\n" + "        }\r\n"
				+ "    },\r\n" + "    \"_source\": {\r\n" + "        \"includes\": [\r\n"
				+ "            \"@version\",\r\n" + "            \"blogger\",\r\n" + "            \"blogpost_id\",\r\n"
				+ "            \"blogsite_id\",\r\n" + "            \"categories\",\r\n"
				+ "            \"influence_score\",\r\n" + "            \"language\",\r\n"
				+ "            \"location\",\r\n" + "            \"num_comments\",\r\n"
				+ "            \"num_inlinks\",\r\n" + "            \"num_outlinks\",\r\n"
				+ "            \"permalink\",\r\n" + "            \"post\",\r\n" + "            \"post_length\",\r\n"
				+ "            \"sentiment\",\r\n" + "            \"tags\",\r\n" + "            \"title\"\r\n"
				+ "        ],\r\n" + "        \"excludes\": []\r\n" + "    },\r\n" + "    \"docvalue_fields\": [\r\n"
				+ "        {\r\n" + "            \"field\": \"@timestamp\",\r\n"
				+ "            \"format\": \"epoch_millis\"\r\n" + "        },\r\n" + "        {\r\n"
				+ "            \"field\": \"date\",\r\n" + "            \"format\": \"yyyy-MM-dd\"\r\n"
				+ "        }\r\n" + "    ],\r\n" + "    \"sort\": [\r\n" + "        {\r\n"
				+ "            \"_doc\": {\r\n" + "                \"order\": \"asc\"\r\n" + "            }\r\n"
				+ "        }\r\n" + "    ]\r\n" + "}");

//		this._elastic(que);
		String url = base_url + "_search";
		System.out.println(que);
//		JSONObject jsonObj = new JSONObject(que);
		ArrayList result = this._getResult(url, que);
		return this._getResult(url, que);

//		String url = base_url + "_search?size=1";
//		return this._getResult(url, jsonObj);
//	}
//
//	public ArrayList _getResult(String url, JSONObject jsonObj) throws Exception {
	}

	public String _count(JSONObject query) {
		String total = null;
		JSONObject myResponse;
		try {
			myResponse = this._makeElasticRequest(query, "POST", "/blogposts/_count?");
			if (null != myResponse.get("count")) {
				Object hits = myResponse.get("count");
				total = hits.toString();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return total;
	}

	public String _countPostMentioned(String term, String date_from, String date_to, String ids_) {
//		term = null;
//		JSONObject query = new JSONObject("{\r\n" + "\r\n" + "    \"query\": {\r\n" + "        \"bool\": {\r\n"
//				+ "            \"adjust_pure_negative\": true,\r\n" + "            \"must\": [\r\n"
//				+ "                {\r\n" + "                    \"term\": {\r\n"
//				+ "                        \"post\": \"" + term + "\"\r\n" + "                    }\r\n"
//				+ "                },\r\n" + "                {\r\n" + "                    \"terms\": {\r\n"
//				+ "                        \"blogsite_id\": [" + ids_ + "],\r\n"
//				+ "                        \"boost\": 1\r\n" + "                    }\r\n" + "                },\r\n"
//				+ "                {\r\n" + "                    \"range\": {\r\n"
//				+ "                        \"date\": {\r\n" + "                            \"include_lower\": true,\r\n"
//				+ "                            \"include_upper\": true,\r\n"
//				+ "                            \"from\": \"" + date_from + "\",\r\n"
//				+ "                            \"boost\": 1,\r\n" + "                            \"to\": \"" + date_to
//				+ "\"\r\n" + "                        }\r\n" + "                    }\r\n" + "                }\r\n"
//				+ "            ],\r\n" + "            \"boost\": 1\r\n" + "        }\r\n" + "    }\r\n" + "\r\n" + "}");

		JSONObject query = new JSONObject("{\r\n" + "    \"query\": {\r\n" + "        \"bool\": {\r\n"
				+ "            \"adjust_pure_negative\": true,\r\n" + "            \"must\": [\r\n"
				+ "                {\r\n" + "                    \"terms\": {\r\n"
				+ "                        \"post\": [" + term + "]\r\n" + "                    }\r\n"
				+ "                },\r\n" + "                {\r\n" + "                    \"terms\": {\r\n"
				+ "                        \"blogsite_id\": [" + ids_ + "],\r\n"
				+ "                        \"boost\": 1\r\n" + "                    }\r\n" + "                },\r\n"
				+ "                {\r\n" + "                    \"range\": {\r\n"
				+ "                        \"date\": {\r\n" + "                            \"include_lower\": true,\r\n"
				+ "                            \"include_upper\": true,\r\n"
				+ "                            \"from\": \"" + date_from + "\",\r\n"
				+ "                            \"boost\": 1,\r\n" + "                            \"to\": \"" + date_to
				+ "\"\r\n" + "                        }\r\n" + "                    }\r\n" + "                }\r\n"
				+ "            ],\r\n" + "            \"boost\": 1\r\n" + "        }\r\n" + "    }\r\n" + "}");

		System.out.println("query for elastic _countPostMentioned --> " + query);
		return this._count(query);
	}

	public String _getMostLocation(String term, String date_from, String date_to, String ids_) throws Exception {
		ArrayList<String> list = new ArrayList<String>();
		HashMap<String, Integer> hm2 = new HashMap<String, Integer>();

		JSONArray all = new JSONArray();
		String res = null;

		JSONObject query = new JSONObject("{\r\n" + "    \"size\": 0,\r\n" + "    \"stored_fields\": \"_none_\",\r\n"
				+ "    \"query\": {\r\n" + "        \"bool\": {\r\n" + "            \"adjust_pure_negative\": true,\r\n"
				+ "            \"must\": [\r\n" + "                {\r\n" + "                    \"terms\": {\r\n"
				+ "                        \"post\": [" + term + "]\r\n" + "                    }\r\n"
				+ "                },\r\n" + "                {\r\n" + "                    \"bool\": {\r\n"
				+ "                        \"adjust_pure_negative\": true,\r\n"
				+ "                        \"must\": [\r\n" + "                            {\r\n"
				+ "                                \"terms\": {\r\n"
				+ "                                    \"blogsite_id\": [" + ids_ + "],\r\n"
				+ "                                    \"boost\": 1\r\n" + "                                }\r\n"
				+ "                            },\r\n" + "                            {\r\n"
				+ "                                \"exists\": {\r\n"
				+ "                                    \"field\": \"location\",\r\n"
				+ "                                    \"boost\": 1\r\n" + "                                }\r\n"
				+ "                            }\r\n" + "                        ],\r\n"
				+ "                        \"boost\": 1\r\n" + "                    }\r\n" + "                },\r\n"
				+ "                {\r\n" + "                    \"range\": {\r\n"
				+ "                        \"date\": {\r\n" + "                            \"include_lower\": true,\r\n"
				+ "                            \"include_upper\": true,\r\n"
				+ "                            \"from\": \"" + date_from + "\",\r\n"
				+ "                            \"boost\": 1,\r\n" + "                            \"to\": \"" + date_to
				+ "\"\r\n" + "                        }\r\n" + "                    }\r\n" + "                }\r\n"
				+ "            ],\r\n" + "            \"boost\": 1\r\n" + "        }\r\n" + "    },\r\n"
				+ "    \"_source\": false,\r\n" + "    \"aggregations\": {\r\n" + "        \"groupby\": {\r\n"
				+ "            \"composite\": {\r\n" + "                \"size\": 1000,\r\n"
				+ "                \"sources\": [\r\n" + "                    {\r\n"
				+ "                        \"dat\": {\r\n" + "                            \"terms\": {\r\n"
				+ "                                \"missing_bucket\": true,\r\n"
				+ "                                \"field\": \"location.keyword\",\r\n"
				+ "                                \"order\": \"asc\"\r\n" + "                            }\r\n"
				+ "                        }\r\n" + "                    }\r\n" + "                ]\r\n"
				+ "            },\r\n" + "            \"aggregations\": {\r\n" + "                \"dat\": {\r\n"
				+ "                    \"filter\": {\r\n" + "                        \"exists\": {\r\n"
				+ "                            \"field\": \"location\",\r\n"
				+ "                            \"boost\": 1\r\n" + "                        }\r\n"
				+ "                    }\r\n" + "                }\r\n" + "            }\r\n" + "        }\r\n"
				+ "    }\r\n" + "}");

		JSONObject myResponse = this._makeElasticRequest(query, "POST", "/blogposts/_search/?");
		String val = null;
		Integer freq = null;
		String idx = null;
		String language = null;
		JSONArray jsonArray = new JSONArray();
		System.out.println("query for elastic _getMostLocation --> " + query);
		if (null != myResponse.get("aggregations")) {
			Object buckets = myResponse.getJSONObject("aggregations").getJSONObject("groupby").getJSONArray("buckets");
			val = buckets.toString();
			jsonArray = new JSONArray(val);

			System.out.println("DONE GETTING POSTS FOR BLOGGER");

		}

		if (jsonArray != null) {

			for (int i = 0; i < jsonArray.length(); i++) {
				JSONObject da = new JSONObject();
				idx = jsonArray.get(i).toString();

				JSONObject j = new JSONObject(idx);
				freq = (Integer) j.get("doc_count");

				Object k = j.getJSONObject("key").get("dat");
				language = k.toString();

				da.put("letter", language);
				da.put("frequency", freq);

				all.put(da);
				hm2.put(language, freq);
			}

		}

		Map<String, Integer> hm1 = this.sortHashMapByValues(hm2);

		Map.Entry<String, Integer> entry = hm1.entrySet().iterator().next();
		Integer value = entry.getValue();
		res = entry.getKey();
		return res;
	}

	public JSONArray _getGetDateAggregate(String bloggers, String fieldGroupby, String format, String fieldCount,
			String interval, String groupbyType, String date_from, String date_to, String ids_) throws Exception {
		ArrayList<String> list = new ArrayList<String>();
		HashMap<String, Integer> hm2 = new HashMap<String, Integer>();

		JSONArray all = new JSONArray();
		JSONObject query = new JSONObject();

		if (bloggers == "NOBLOGGER") {
			query = new JSONObject("{\r\n" + "    \"size\": 0,\r\n" + "    \"query\": {\r\n" + "        \"bool\": {\r\n"
					+ "            \"must\": [\r\n" + "                {\r\n" + "                    \"terms\": {\r\n"
					+ "                        \"blogsite_id\": [" + ids_ + "],\r\n"
					+ "                        \"boost\": 1\r\n" + "                    }\r\n"
					+ "                },\r\n" + "                {\r\n" + "                    \"range\": {\r\n"
					+ "                        \"date\": {\r\n" + "                            \"from\": \"" + date_from
					+ "\",\r\n" + "                            \"to\": \"" + date_to + "\",\r\n"
					+ "                            \"include_lower\": true,\r\n"
					+ "                            \"include_upper\": true,\r\n"
					+ "                            \"boost\": 1\r\n" + "                        }\r\n"
					+ "                    }\r\n" + "                }\r\n" + "            ],\r\n"
					+ "            \"adjust_pure_negative\": true,\r\n" + "            \"boost\": 1\r\n"
					+ "        }\r\n" + "    },\r\n" + "    \"_source\": {\r\n" + "        \"excludes\": [],\r\n"
					+ "        \"includes\": [\r\n" + "            \"@version\",\r\n" + "            \"date\"\r\n"
					+ "        ]\r\n" + "    },\r\n" + "    \"aggregations\": {\r\n" + "        \"groupby\": {\r\n"
					+ "            \"composite\": {\r\n" + "                \"size\": 10000,\r\n"
					+ "                \"sources\": [\r\n" + "                    {\r\n" + "                        \""
					+ fieldGroupby + "\": {\r\n" + "                            \"" + groupbyType + "\": {\r\n"
					+ "                                \"field\": \"" + fieldGroupby + "\",\r\n"
					+ "                                \"format\": \"" + format + "\",\r\n"
					+ "                                \"calendar_interval\": \"" + interval + "\"\r\n"
					+ "                            }\r\n" + "                        }\r\n"
					+ "                    }\r\n" + "                ]\r\n" + "            },\r\n"
					+ "            \"aggregations\": {\r\n" + "                \"" + fieldCount + "\": {\r\n"
					+ "                    \"filter\": {\r\n" + "                        \"exists\": {\r\n"
					+ "                            \"field\": \"" + fieldCount + "\",\r\n"
					+ "                            \"boost\": 1\r\n" + "                        }\r\n"
					+ "                    }\r\n" + "                }\r\n" + "            }\r\n" + "        }\r\n"
					+ "    }\r\n" + "}");
		} else {
			query = new JSONObject("{\r\n" + "    \"size\": 0,\r\n" + "    \"query\": {\r\n" + "        \"bool\": {\r\n"
					+ "            \"adjust_pure_negative\": true,\r\n" + "            \"must\": [\r\n"
					+ "                {\r\n" + "                    \"terms\": {\r\n"
					+ "                        \"blogger.keyword\":[\"" + bloggers + "\"]\r\n"
					+ "                        \r\n" + "                    }\r\n" + "                },\r\n"
					+ "                {\r\n" + "                    \"terms\": {\r\n"
					+ "                        \"blogsite_id\": [" + ids_ + "],\r\n"
					+ "                        \"boost\": 1\r\n" + "                    }\r\n"
					+ "                },\r\n" + "                {\r\n" + "                    \"range\": {\r\n"
					+ "                        \"date\": {\r\n"
					+ "                            \"include_lower\": true,\r\n"
					+ "                            \"include_upper\": true,\r\n"
					+ "                            \"from\": \"" + date_from + "\",\r\n"
					+ "                            \"boost\": 1,\r\n" + "                            \"to\": \""
					+ date_to + "\"\r\n" + "                        }\r\n" + "                    }\r\n"
					+ "                }\r\n" + "            ],\r\n" + "            \"boost\": 1\r\n" + "        }\r\n"
					+ "    },\r\n" + "    \"_source\": {\r\n" + "        \"excludes\": [],\r\n"
					+ "        \"includes\": [\r\n" + "            \"@version\",\r\n" + "            \"date\"\r\n"
					+ "        ]\r\n" + "    },\r\n" + "    \"aggregations\": {\r\n" + "        \"groupby\": {\r\n"
					+ "            \"composite\": {\r\n" + "                \"size\": 10000,\r\n"
					+ "                \"sources\": [\r\n" + "                    {\r\n" + "                        \""
					+ fieldGroupby + "\": {\r\n" + "                            \"" + groupbyType + "\": {\r\n"
					+ "                                \"field\": \"" + fieldGroupby + "\",\r\n"
					+ "                                \"format\": \"" + format + "\",\r\n"
					+ "                                \"calendar_interval\": \"" + interval + "\"\r\n"
					+ "                            }\r\n" + "                        }\r\n"
					+ "                    }\r\n" + "                ]\r\n" + "            },\r\n"
					+ "            \"aggregations\": {\r\n" + "                \"" + fieldCount + "\": {\r\n"
					+ "                    \"filter\": {\r\n" + "                        \"exists\": {\r\n"
					+ "                            \"field\": \"" + fieldCount + "\",\r\n"
					+ "                            \"boost\": 1\r\n" + "                        }\r\n"
					+ "                    }\r\n" + "                }\r\n" + "            }\r\n" + "        }\r\n"
					+ "    }\r\n" + "}");
		}

		JSONObject myResponse = this._makeElasticRequest(query, "POST", "/blogposts/_search/?");
		String val = null;
		Integer freq = null;
		String idx = null;
		String language = null;
		JSONArray jsonArray = new JSONArray();

		System.out.println("query for elastic _getGetDateAggregate --> " + query);

		if (null != myResponse.get("aggregations")) {
			jsonArray = myResponse.getJSONObject("aggregations").getJSONObject("groupby").getJSONArray("buckets");
//			val = buckets.toString();
//			JSONObject bucket_ = new JSONObject(val);
//			freq = (Integer) bucket_.getJSONObject("dat").get("value");
//			System.out.println("DONE GETTING POSTS FOR BLOGGER--" + freq);

		}
		return jsonArray;
	}

	public Integer _getBlogOrPostMentioned(String field, String term, String date_from, String date_to, String ids_)
			throws Exception {
		ArrayList<String> list = new ArrayList<String>();
		HashMap<String, Integer> hm2 = new HashMap<String, Integer>();

		JSONArray all = new JSONArray();

		/*
		 * JSONObject query = new JSONObject("{\r\n" + "    \"size\": 0,\r\n" +
		 * "    \"query\": {\r\n" + "        \"bool\": {\r\n" +
		 * "            \"must\": [\r\n" + "                {\r\n" +
		 * "                    \"bool\": {\r\n" +
		 * "                        \"must\": [\r\n" +
		 * "                            {\r\n" +
		 * "                                \"term\": {\r\n" +
		 * "                                    \"post\": \"" + term + "\"\r\n" +
		 * "                                }\r\n" +
		 * "                            },\r\n" + "                            {\r\n" +
		 * "                                \"terms\": {\r\n" +
		 * "                                    \"blogsite_id\": [" + ids_ + "],\r\n" +
		 * "                                    \"boost\": 1\r\n" +
		 * "                                }\r\n" + "                            }\r\n"
		 * + "                        ],\r\n" +
		 * "                        \"adjust_pure_negative\": true,\r\n" +
		 * "                        \"boost\": 1\r\n" + "                    }\r\n" +
		 * "                },\r\n" + "                {\r\n" +
		 * "                    \"range\": {\r\n" +
		 * "                        \"date\": {\r\n" +
		 * "                            \"from\": \"" + date_from + "\",\r\n" +
		 * "                            \"to\": \"" + date_to + "\",\r\n" +
		 * "                            \"include_lower\": true,\r\n" +
		 * "                            \"include_upper\": true,\r\n" +
		 * "                            \"boost\": 1\r\n" +
		 * "                        }\r\n" + "                    }\r\n" +
		 * "                }\r\n" + "            ],\r\n" +
		 * "            \"adjust_pure_negative\": true,\r\n" +
		 * "            \"boost\": 1\r\n" + "        }\r\n" + "    },\r\n" +
		 * "    \"_source\": false,\r\n" + "    \"stored_fields\": \"_none_\",\r\n" +
		 * "    \"aggregations\": {\r\n" + "        \"groupby\": {\r\n" +
		 * "            \"filters\": {\r\n" + "                \"filters\": [\r\n" +
		 * "                    {\r\n" + "                        \"match_all\": {\r\n"
		 * + "                            \"boost\": 1\r\n" +
		 * "                        }\r\n" + "                    }\r\n" +
		 * "                ],\r\n" + "                \"other_bucket\": false,\r\n" +
		 * "                \"other_bucket_key\": \"_other_\"\r\n" +
		 * "            },\r\n" + "            \"aggregations\": {\r\n" +
		 * "                \"dat\": {\r\n" +
		 * "                    \"cardinality\": {\r\n" +
		 * "                        \"field\": \"" + field + "\"\r\n" +
		 * "                    }\r\n" + "                }\r\n" + "            }\r\n" +
		 * "        }\r\n" + "    }\r\n" + "}");
		 */
		JSONObject query = new JSONObject("{\r\n" + "    \"size\": 0,\r\n" + "    \"stored_fields\": \"_none_\",\r\n"
				+ "    \"query\": {\r\n" + "        \"bool\": {\r\n" + "            \"adjust_pure_negative\": true,\r\n"
				+ "            \"must\": [\r\n" + "                {\r\n" + "                    \"bool\": {\r\n"
				+ "                        \"adjust_pure_negative\": true,\r\n"
				+ "                        \"must\": [\r\n" + "                            {\r\n"
				+ "                                \"terms\": {\r\n" + "                                    \"post\": ["
				+ term + "]\r\n" + "                                }\r\n" + "                            },\r\n"
				+ "                            {\r\n" + "                                \"terms\": {\r\n"
				+ "                                    \"blogsite_id\": [" + ids_ + "],\r\n"
				+ "                                    \"boost\": 1\r\n" + "                                }\r\n"
				+ "                            }\r\n" + "                        ],\r\n"
				+ "                        \"boost\": 1\r\n" + "                    }\r\n" + "                },\r\n"
				+ "                {\r\n" + "                    \"range\": {\r\n"
				+ "                        \"date\": {\r\n" + "                            \"include_lower\": true,\r\n"
				+ "                            \"include_upper\": true,\r\n"
				+ "                            \"from\": \"" + date_from + "\",\r\n"
				+ "                            \"boost\": 1,\r\n" + "                            \"to\": \"" + date_to
				+ "\"\r\n" + "                        }\r\n" + "                    }\r\n" + "                }\r\n"
				+ "            ],\r\n" + "            \"boost\": 1\r\n" + "        }\r\n" + "    },\r\n"
				+ "    \"_source\": false,\r\n" + "    \"aggregations\": {\r\n" + "        \"groupby\": {\r\n"
				+ "            \"filters\": {\r\n" + "                \"other_bucket\": false,\r\n"
				+ "                \"other_bucket_key\": \"_other_\",\r\n" + "                \"filters\": [\r\n"
				+ "                    {\r\n" + "                        \"match_all\": {\r\n"
				+ "                            \"boost\": 1\r\n" + "                        }\r\n"
				+ "                    }\r\n" + "                ]\r\n" + "            },\r\n"
				+ "            \"aggregations\": {\r\n" + "                \"dat\": {\r\n"
				+ "                    \"cardinality\": {\r\n"
				+ "                        \"field\": \"blogsite_id\"\r\n" + "                    }\r\n"
				+ "                }\r\n" + "            }\r\n" + "        }\r\n" + "    }\r\n" + "}");

		JSONObject myResponse = this._makeElasticRequest(query, "POST", "/blogposts/_search/?");
		String val = null;
		Integer freq = null;
		String idx = null;
		String language = null;
		JSONArray jsonArray = new JSONArray();
		System.out.println("query for elastic _getBlogOrPostMentioned --> " + query);
		if (null != myResponse.get("aggregations")) {
			Object buckets = myResponse.getJSONObject("aggregations").getJSONObject("groupby").getJSONArray("buckets")
					.get(0);
			val = buckets.toString();
			JSONObject bucket_ = new JSONObject(val);
			freq = (Integer) bucket_.getJSONObject("dat").get("value");
			System.out.println("DONE GETTING POSTS FOR BLOGGER--" + freq);

		}
		return freq;
	}

	public JSONArray _getMostLanguage(String date_from, String date_to, String ids_, Integer limit) throws Exception {
		ArrayList<String> list = new ArrayList<String>();
		HashMap<String, Integer> hm2 = new HashMap<String, Integer>();

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

		JSONObject myResponse = this._makeElasticRequest(query, "POST", "/blogposts/_search/?");
		String val = null;
		Integer freq = null;
		String idx = null;
		String language = null;
		JSONArray jsonArray = new JSONArray();
		System.out.println("query for elastic _getMostLanguage --> " + query);
		if (null != myResponse.get("aggregations")) {
			Object buckets = myResponse.getJSONObject("aggregations").getJSONObject("groupby").getJSONArray("buckets");
			val = buckets.toString();
			jsonArray = new JSONArray(val);

			System.out.println("DONE GETTING POSTS FOR BLOGGER");

			if (jsonArray.length() < 10) {
				limit = jsonArray.length();
			}

			if (jsonArray != null) {
				for (int i = 0; i < limit; i++) {
					JSONObject da = new JSONObject();
					idx = jsonArray.get(i).toString();

					JSONObject j = new JSONObject(idx);
					freq = (Integer) j.get("doc_count");

					Object k = j.getJSONObject("key").get("dat");
					language = k.toString();

					da.put("letter", language);
					da.put("frequency", freq);

					all.put(da);
					hm2.put(language, freq);
				}

			}
		}
		return all;
	}

	public Map<String, Integer> _keywordTermvctors(String data) throws Exception {
		String result = null;
		String source = null;
		String source_ = null;
		JSONObject d = new JSONObject();
//		LinkedHashMap<String, Integer> sortedMap = new LinkedHashMap<>();
		// Map<String, Integer> hm1 = new HashMap<>();
		Map<String, Integer> hm1 = new HashMap<String, Integer>();
		System.out.println(data.length() + elasticUrl);
		if (data.length() > 0) {

			JSONObject query = new JSONObject("{\r\n" + "    \"doc\": {\r\n" + "      \"post\": \"" + data + "\"\r\n"
					+ "    },\r\n" + "    \"term_statistics\" : true,\r\n" + "    \"field_statistics\" : true,\r\n"
					+ "    \"positions\": false,\r\n" + "    \"offsets\": false,\r\n" + "    \"filter\" : {\r\n"
					+ "      \"max_num_terms\" : 1000,\r\n" + "      \"min_term_freq\" : 1,\r\n"
					+ "      \"min_doc_freq\" : 1,\r\n" + "      \"min_word_length\":3\r\n" + "	\r\n" + "    }\r\n"
					+ "}");
//System.out.println("keyword termvec query is"+query);
			JSONObject myResponse = this._makeElasticRequest(query, "POST", "/blogposts/_termvectors");

			Object hits = myResponse.getJSONObject("term_vectors").getJSONObject("post").getJSONObject("terms");

			source = hits.toString();
			System.out.println("GETTING TERM VECTORS");
			JSONObject jsonObject = new JSONObject(source);
			Iterator<String> keys = jsonObject.keys();

			source_ = keys.next();

			System.out.println("DONE GETTING TERM VECTORS");
			HashMap<String, Integer> hm2 = new HashMap<String, Integer>();
			JSONObject da_ = new JSONObject();

			while (keys.hasNext()) {
				String key = keys.next();
				Object freq = jsonObject.getJSONObject(key).get("term_freq");
				Integer f = (Integer) freq;
				hm2.put(key, f);
			}

			hm1 = this.sortHashMapByValues(hm2);
			System.out.println("DONE SORTING OBJECT");

			Map.Entry<String, Integer> entry = hm1.entrySet().iterator().next();
			source = entry.getKey().toUpperCase();

			Integer value = entry.getValue();
			String highest = entry.getKey();

			System.out.println("HIGHEST TERM IS -- " + source + " OCCURING " + value + " TIMES");

			String da = hm1.toString();

			d = new JSONObject(hm1);
			System.out.println(d);

		} else {
			source = "Null";
		}
		return hm1;

	}

	public String _getMostKeywordDashboard(String BloggerName, String date_from, String date_to, String ids_)
			throws Exception {
		//
//		BloggerName="Stephen Lendman,South Front";
		System.out.println("postingfreqbloggers" + BloggerName);
		ArrayList<String> list = new ArrayList<String>();
		JSONObject query = new JSONObject();
		String result = null;
		if (BloggerName == null || BloggerName == "") {
			query = new JSONObject("{\r\n" + "    \"size\": 1000,\r\n" + "    \"query\": {\r\n"
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
					+ "            \"adjust_pure_negative\": true,\r\n" + "            \"boost\": 1.0\r\n"
					+ "        }\r\n" + "    },\r\n" + "    \"_source\": {\r\n" + "        \"includes\": [\r\n"
					+ "            \"post\"\r\n" + "        ],\r\n" + "        \"excludes\": []\r\n" + "    },\r\n"
					+ "    \"sort\": [\r\n" + "        {\r\n" + "            \"influence_score\": {\r\n"
					+ "                \"order\": \"desc\",\r\n" + "                \"missing\": \"_first\",\r\n"
					+ "                \"unmapped_type\": \"float\"\r\n" + "            }\r\n" + "        }\r\n"
					+ "    ]\r\n" + "}");
		} else {
			query = new JSONObject("{\r\n" + "    \"size\": 1000,\r\n" + "    \"query\": {\r\n"
					+ "        \"bool\": {\r\n" + "            \"adjust_pure_negative\": true,\r\n"
					+ "            \"must\": [\r\n" + "                {\r\n" + "                    \"bool\": {\r\n"
					+ "                        \"adjust_pure_negative\": true,\r\n"
					+ "                        \"must\": [\r\n" + "                            {\r\n"
					+ "                                \"terms\": {\r\n"
					+ "                                    \"blogger.keyword\": [" + BloggerName + "],\r\n"
					+ "                                    \"boost\": 1\r\n" + "                                }\r\n"
					+ "                            },\r\n" + "                            {\r\n"
					+ "                                \"terms\": {\r\n"
					+ "                                    \"blogsite_id\": [" + ids_ + "],\r\n"
					+ "                                    \"boost\": 1\r\n" + "                                }\r\n"
					+ "                            }\r\n" + "                        ],\r\n"
					+ "                        \"boost\": 1\r\n" + "                    }\r\n"
					+ "                },\r\n" + "                {\r\n" + "                    \"range\": {\r\n"
					+ "                        \"date\": {\r\n"
					+ "                            \"include_lower\": true,\r\n"
					+ "                            \"include_upper\": true,\r\n"
					+ "                            \"from\": \"" + date_from + "\",\r\n"
					+ "                            \"boost\": 1,\r\n" + "                            \"to\": \""
					+ date_to + "\"\r\n" + "                        }\r\n" + "                    }\r\n"
					+ "                }\r\n" + "            ],\r\n" + "            \"boost\": 1\r\n" + "        }\r\n"
					+ "    },\r\n" + "    \"_source\": {\r\n" + "        \"excludes\": [],\r\n"
					+ "        \"includes\": [\r\n" + "            \"post\"\r\n" + "        ]\r\n" + "    },\r\n"
					+ "    \"sort\": [\r\n" + "        {\r\n" + "            \"influence_score\": {\r\n"
					+ "                \"unmapped_type\": \"float\",\r\n"
					+ "                \"missing\": \"_first\",\r\n" + "                \"order\": \"desc\"\r\n"
					+ "            }\r\n" + "        }\r\n" + "    ]\r\n" + "}");
			
		}
		System.out.println("query for elastic _getMostKeywordDashboard --> " + query);
		JSONArray jsonArray = (JSONArray) this._elastic(query).getJSONArray("hit_array");

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
		result = result.replace("o.style.setproperty", "");
		result = result.replace("o.style.setProperty", "");
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

	public static String escape2(String s) {
		return StringEscapeUtils.escapeJava(s);
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
//		data = escape2(data);
		if (data.length() > 0) {
//		JSONObject jsonObj = new JSONObject("{\r\n" + "  \"query\": {\r\n" + "    \"constant_score\":{\r\n"
//				+ "			\"filter\":{\r\n" + "					\"terms\":{\r\n"
//				+ "							\"blogpost_id\":[\"" + ids + "\"]\r\n" + "							}\r\n"
//				+ "					}\r\n" + "				}\r\n" + "    }\r\n" + "}");
			JSONObject query = new JSONObject("{\r\n" + "    \"doc\": {\r\n" + "      \"post\": \"" + data + "\"\r\n"
					+ "    },\r\n" + "    \"term_statistics\" : false,\r\n" + "    \"field_statistics\" : false,\r\n"
					+ "    \"positions\": false,\r\n" + "    \"offsets\": false,\r\n" + "    \"filter\" : {\r\n"
					+ "      \"max_num_terms\" : 1,\r\n" + "      \"min_term_freq\" : 1,\r\n"
					+ "      \"min_doc_freq\" : 1,\r\n" + "      \"min_word_length\":1\r\n" + "	\r\n" + "    }\r\n"
					+ "}");
			System.out.println("INPROCESS");
//			System.out.println(" _termVectors --- "+ query);

//			try (FileWriter file = new FileWriter("C:\\Users\\oljohnson\\Desktop\\SQL\\file2.json")) {
//
//				
//
//					
//					file.write(query.toString());
//					System.out.println("Successfully Copied JSON Object to File...");
//
//				
//			}
//			
//			

			JSONObject myResponse = this._makeElasticRequest(query, "POST", "/blogposts/_termvectors");
			System.out.println("PROCESSED");
			try {
				// Object r_ =
				// this._multipleTermVectors(id).getJSONArray("docs").getJSONObject(0).getJSONObject("term_vectors").getJSONObject("post").getJSONObject("terms").keys().next().toString();
				Object hits = myResponse.getJSONObject("term_vectors").getJSONObject("post").getJSONObject("terms");
				source = hits.toString();
			} catch (Exception e) {
				System.out.println(e);
			}

			JSONObject jsonObject = new JSONObject(source);
			Iterator<String> keys = jsonObject.keys();

			// source_ = keys.next();

			System.out.println("DONE GETTING TERM VECTORS");
			HashMap<String, Integer> hm2 = new HashMap<String, Integer>();
			while (keys.hasNext()) {
				String key = keys.next();
				// do something with jsonObject here
				Object freq = jsonObject.getJSONObject(key).get("term_freq");
				Integer f = (Integer) freq;

				// enter data into hashmap
				hm2.put(key, f);

			}

			System.out.println("2--" + data.length());
			Map<String, Integer> hm1 = this.sortHashMapByValues(hm2);
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

	public int countOccurences(String str, String word) {
		/*
		 * // split the string by spaces in a Pattern pt =
		 * Pattern.compile("[^a-zA-Z0-9]"); Matcher match = pt.matcher(str);
		 * 
		 * while (match.find()) { String s = match.group(); str =
		 * str.replaceAll("\\" + s, " "); }
		 */
		word = word.replaceAll("\"", "");
		System.out.println("This is the word-" + word);
		String a[] = str.split("\\W+");

		String wrd[] = word.split(",");
//		System.out.println("This is the word-" + wrd[1]);

		String str_ = null;

		// search for pattern in a
		int count = 0;
		for (int i = 0; i < a.length; i++) {
			// if match found increase count
			str_ = a[i].toLowerCase();
			for (int j = 0; j < wrd.length; j++) {
//				System.out.println("This is the splitted word-"+wrd[j]+"--"+str_);
				if (wrd[j].trim().equals(str_.trim())) {
					count++;
//					System.out.println("Count =="+count);
				}
			}
		}

		return count;
	}

	public JSONObject lineGraphAggregate(List<Map<String, Integer>> items) {

		Map<String, Integer> json = (HashMap<String, Integer>) items.stream().flatMap(m -> m.entrySet().stream())
				.collect(toMap(Map.Entry::getKey, Map.Entry::getValue, Integer::sum));

		/* System.out.println("map" + map); */
		JSONObject mapped = new JSONObject(json);
//		System.out.println("map2" + mapped);
		return mapped;

	}

	public JSONObject _multipleTermVectors(String id) throws Exception {
		JSONObject result = new JSONObject();
		JSONObject query = new JSONObject("{\r\n" + "    \"ids\": [" + id + "],\r\n" + "    \"parameters\": {\r\n"
				+ "        \"fields\": [\r\n" + "            \"post\"\r\n" + "        ],\r\n"
				+ "        \"term_statistics\": false,\r\n" + "        \"field_statistics\": false,\r\n"
				+ "        \"positions\": false,\r\n" + "        \"offsets\": false,\r\n" + "        \"filter\": {\r\n"
				+ "            \"max_num_terms\": 1,\r\n" + "            \"min_term_freq\": 1,\r\n"
				+ "            \"min_doc_freq\": 1\r\n" + "        }\r\n" + "    }\r\n" + "}");

		result = this._makeElasticRequest(query, "POST", "/blogposts/_mtermvectors");
		return result;
	}

//	public ArrayList<String> _getPostIds(JSONArray jsonArray) throws Exception{
//		ArrayList<String> result = new ArrayList<String>();
//		
//		for(int i = 0; i < jsonArray.length(); i++) {
//			String r = jsonArray.get(i).toString();
//			JSONObject res = new JSONObject(r);
//			String id = (String) res.get("_id");
//			Object r_ = this._multipleTermVectors(id).getJSONArray("docs").getJSONObject(0).getJSONObject("term_vectors").getJSONObject("post").getJSONObject("terms").keys().next().toString();
////			JSONObject terms = new JSONObject(r_);
////			terms
//			
//			result.add( (String) r_);
//		}
//		
//		return result;
//	}

//	public ArrayList<String> _getHighestTerm(String blogger, String ids, String date_from, String date_to) throws Exception{
//		ArrayList<String>  result = new ArrayList<String>();
//		JSONObject query = new JSONObject();
//		JSONObject r = new JSONObject();
//		if (blogger != "NOBLOGGER") {
//			query = new JSONObject("{\r\n" + "    \"size\": 100,\r\n" + "    \"query\": {\r\n"
//					+ "        \"bool\": {\r\n" + "            \"must\": [\r\n" + "                {\r\n"
//					+ "                    \"bool\": {\r\n" + "                        \"must\": [\r\n"
//					+ "                            {\r\n" + "                                \"term\": {\r\n"
//					+ "                                    \"blogger.keyword\": {\r\n"
//					+ "                                        \"value\": \"" + blogger + "\",\r\n"
//					+ "                                        \"boost\": 1.0\r\n"
//					+ "                                    }\r\n" + "                                }\r\n"
//					+ "                            },\r\n" + "                            {\r\n"
//					+ "                                \"terms\": {\r\n"
//					+ "                                    \"blogsite_id\": [" + ids + "],\r\n"
//					+ "                                    \"boost\": 1.0\r\n" + "                                }\r\n"
//					+ "                            }\r\n" + "                        ],\r\n"
//					+ "                        \"adjust_pure_negative\": true,\r\n"
//					+ "                        \"boost\": 1.0\r\n" + "                    }\r\n"
//					+ "                },\r\n" + "                {\r\n" + "                    \"range\": {\r\n"
//					+ "                        \"date\": {\r\n" + "                            \"from\": \"" + date_from
//					+ "\",\r\n" + "                            \"to\": \"" + date_to + "\",\r\n"
//					+ "                            \"include_lower\": true,\r\n"
//					+ "                            \"include_upper\": true,\r\n"
//					+ "                            \"boost\": 1.0\r\n" + "                        }\r\n"
//					+ "                    }\r\n" + "                }\r\n" + "            ],\r\n"
//					+ "            \"adjust_pure_negative\": true,\r\n" + "            \"boost\": 1.0\r\n"
//					+ "        }\r\n" + "    },\r\n" + "    \"_source\": {\r\n" + "        \"includes\": [\r\n"
//					+ "            \"post\"\r\n" + "        ],\r\n" + "        \"excludes\": []\r\n" + "    },\r\n"
//					+ "    \"sort\": [\r\n" + "        {\r\n" + "            \"influence_score\": {\r\n"
//					+ "                \"order\": \"desc\",\r\n" + "                \"missing\": \"_first\",\r\n"
//					+ "                \"unmapped_type\": \"float\"\r\n" + "            }\r\n" + "        }\r\n"
//					+ "    ]\r\n" + "}");
//
//		}else {
//
//			query = new JSONObject("{\r\n" + "    \"size\": 100,\r\n" + "    \"query\": {\r\n" + "        \"bool\": {\r\n"
//					+ "            \"must\": [\r\n" + "                {\r\n" + "                    \"terms\": {\r\n"
//					+ "                        \"blogsite_id\": [" + ids + "],\r\n"
//					+ "                        \"boost\": 1.0\r\n" + "                    }\r\n" + "                },\r\n"
//					+ "                {\r\n" + "                    \"range\": {\r\n"
//					+ "                        \"date\": {\r\n" + "                            \"from\": \"" + date_from
//					+ "\",\r\n" + "                            \"to\": \"" + date_to + "\",\r\n"
//					+ "                            \"include_lower\": true,\r\n"
//					+ "                            \"include_upper\": true,\r\n"
//					+ "                            \"boost\": 1.0\r\n" + "                        }\r\n"
//					+ "                    }\r\n" + "                }\r\n" + "            ],\r\n"
//					+ "            \"adjust_pure_negative\": true,\r\n" + "            \"boost\": 1.0\r\n" + "        }\r\n"
//					+ "    },\r\n" + "    \"_source\": {\r\n" + "        \"includes\": [\r\n"
//					+ "            \"@version\",\r\n" + "            \"blogger\",\r\n" + "            \"blogpost_id\",\r\n"
//					+ "            \"blogsite_id\",\r\n" + "            \"categories\",\r\n"
//					+ "            \"influence_score\",\r\n" + "            \"language\",\r\n"
//					+ "            \"location\",\r\n" + "            \"num_comments\",\r\n"
//					+ "            \"num_inlinks\",\r\n" + "            \"num_outlinks\",\r\n"
//					+ "            \"permalink\",\r\n" + "            \"post\",\r\n" + "            \"post_length\",\r\n"
//					+ "            \"sentiment\",\r\n" + "            \"tags\",\r\n" + "            \"title\"\r\n"
//					+ "        ],\r\n" + "        \"excludes\": []\r\n" + "    },\r\n" + "    \"docvalue_fields\": [\r\n"
//					+ "        {\r\n" + "            \"field\": \"@timestamp\",\r\n"
//					+ "            \"format\": \"epoch_millis\"\r\n" + "        },\r\n" + "        {\r\n"
//					+ "            \"field\": \"date\",\r\n" + "            \"format\": \"yyyy-MM-dd\"\r\n"
//					+ "        }\r\n" + "    ],\r\n" + "    \"sort\": [\r\n" + "        {\r\n"
//					+ "            \"_doc\": {\r\n" + "                \"order\": \"asc\"\r\n" + "            }\r\n"
//					+ "        }\r\n" + "    ]\r\n" + "}");
//		}
//		
//		JSONObject myResponse = this._makeElasticRequest(query, "POST", "/blogposts/_search/?scroll=1m");
//		JSONArray allhits = new JSONArray();
//		JSONObject scrollResult = new JSONObject();
//		String source = null;
//		JSONArray jsonArray = new JSONArray();
//		String scroll_id = null;
//		JSONObject all_data = new JSONObject();
//
//		System.out.println("_getHighestTerm query ---- "+query);
//		
//		if (null != myResponse.get("hits")) {
//
//			Object hits = myResponse.getJSONObject("hits").getJSONArray("hits");
//			Object total = myResponse.getJSONObject("hits").getJSONObject("total").get("value");
//			scroll_id = myResponse.getString("_scroll_id");			
//			source = hits.toString();
//
//			jsonArray = new JSONArray(source);
//			result = this._getPostIds(jsonArray);
////			Object a = this._multipleTermVectors(result).getJSONArray("docs").get(0);
//			
//			scrollResult = this._scrollRequest(scroll_id);
//			allhits = scrollResult.getJSONObject("hits").getJSONArray("hits");
//			result.addAll(this._getPostIds(allhits));
////			result.put
////			result =  merge(result, this._getPostIds(allhits));
////			result = this._getPostIds(allhits); 
//			
////			for (int i = 0; i < 10; i++) {
////				if (allhits.length() <= 0) {
////					break;
////				}
//			while (allhits.length() > 0) {
//				System.out.println("WHILE ---" + allhits.length());
//				scroll_id = (String) scrollResult.get("_scroll_id");
//				scrollResult = this._scrollRequest(scroll_id);
//				allhits = scrollResult.getJSONObject("hits").getJSONArray("hits");
//				source = allhits.toString();
//				
//				result.addAll(this._getPostIds(allhits));
//				//jsonArray.put(new JSONArray(source));
//			}
//						
//
////			
////			source = allhits.toString();
////			jsonArray =  merge(jsonArray, new JSONArray(source));
//		
//		}
//		return result;
	
//	}
	
	public String getHighestTerm(String data) throws Exception {
		String result = null;
		String source = null;
		String source_ = null;
		System.out.println(data.length());
		data = this.escape2(data);
		//data = this.escape(data);
		if (data.length() > 0) {
//data ="seun seun seun seun";
			JSONObject query = new JSONObject("{\r\n" + 
					"    \"doc\": {\r\n" + 
					"        \"post\": \""+data+"\"\r\n" + 
					"    },\r\n" + 
					"\r\n" + 
					"    \"term_statistics\": false,\r\n" + 
					"        \"field_statistics\": false,\r\n" + 
					"        \"positions\": false,\r\n" + 
					"        \"offsets\": false,\r\n" + 
					"        \"filter\": {\r\n" + 
					"            \"max_num_terms\": 1,\r\n" + 
					"            \"min_term_freq\": 1,\r\n" + 
					"            \"min_doc_freq\": 1\r\n" + 
					"        }\r\n" + 
					"}");
			System.out.println("INPROCESS--");


			JSONObject myResponse = this._makeElasticRequest(query, "POST", "/termv/_termvectors?");
			System.out.println("PROCESSED");
			try (FileWriter file = new FileWriter("C:\\Users\\oljohnson\\Desktop\\SQL\\file2.json")) {

				file.write(data.toString());
				System.out.println("Successfully Copied JSON Object to File...");

			}
			
			try {
				// Object r_ =
				// this._multipleTermVectors(id).getJSONArray("docs").getJSONObject(0).getJSONObject("term_vectors").getJSONObject("post").getJSONObject("terms").keys().next().toString();
				Object hits = myResponse.getJSONObject("term_vectors").getJSONObject("post").getJSONObject("terms");
				// hits = myResponse.getJSONObject("term_vectors").getJSONObject("post").getJSONObject("terms");
				source = hits.toString();
			} catch (Exception e) {
				System.out.println(e);
			}

			JSONObject jsonObject = new JSONObject(source);
			Iterator<String> keys = jsonObject.keys();
			int value = 0;

			System.out.println("DONE GETTING TERM VECTORS");
			HashMap<String, Integer> hm2 = new HashMap<String, Integer>();
			while (keys.hasNext()) {
				source = keys.next();
				// do something with jsonObject here
				Object freq = jsonObject.getJSONObject(source).get("term_freq");
				value = (Integer) freq;

			}

			System.out.println("HIGHEST TERM IS -- " + source + " OCCURING " + value + " TIMES");

		} else {
			source = "Null";
		}
		return source.toUpperCase();
	}

	public JSONObject _getBloggerPosts(String term, String bloggerName, String date_from, String date_to, String ids_)
			throws Exception {
//	
		ArrayList<String> list = new ArrayList<String>();
		ArrayList<String> _idlist = new ArrayList<String>();
		String result = null;

		JSONObject all_data = new JSONObject();
		JSONObject posts_occured_data = new JSONObject();

		JSONObject query = new JSONObject();

		if (bloggerName != "NOBLOGGER") {

			query = new JSONObject("{\r\n" + "    \"size\": 1000,\r\n" + "    \"query\": {\r\n"
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
					+ "                        \"boost\": 1.0\r\n" + "                    }\r\n"
					+ "                },\r\n" + "                {\r\n" + "                    \"range\": {\r\n"
					+ "                        \"date\": {\r\n" + "                            \"from\": \"" + date_from
					+ "\",\r\n" + "                            \"to\": \"" + date_to + "\",\r\n"
					+ "                            \"include_lower\": true,\r\n"
					+ "                            \"include_upper\": true,\r\n"
					+ "                            \"boost\": 1.0\r\n" + "                        }\r\n"
					+ "                    }\r\n" + "                }\r\n" + "            ],\r\n"
					+ "            \"adjust_pure_negative\": true,\r\n" + "            \"boost\": 1.0\r\n"
					+ "        }\r\n" + "    },\r\n" + "    \"_source\": {\r\n" + "        \"includes\": [\r\n"
					+ "            \"post\"\r\n" + "        ],\r\n" + "        \"excludes\": []\r\n" + "    },\r\n"
					+ "    \"sort\": [\r\n" + "        {\r\n" + "            \"influence_score\": {\r\n"
					+ "                \"order\": \"desc\",\r\n" + "                \"missing\": \"_first\",\r\n"
					+ "                \"unmapped_type\": \"float\"\r\n" + "            }\r\n" + "        }\r\n"
					+ "    ]\r\n" + "}");

		} else if (term == "___NO__TERM___" && bloggerName == "NOBLOGGER") {
			query = new JSONObject("{\r\n" + "    \"size\": 1000,\r\n" + "    \"query\": {\r\n"
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
					+ "            \"adjust_pure_negative\": true,\r\n" + "            \"boost\": 1.0\r\n"
					+ "        }\r\n" + "    },\r\n" + "    \"_source\": {\r\n" + "        \"includes\": [\r\n"
					+ "            \"@version\",\r\n" + "            \"blogger\",\r\n"
					+ "            \"blogpost_id\",\r\n" + "            \"blogsite_id\",\r\n"
					+ "            \"categories\",\r\n" + "            \"influence_score\",\r\n"
					+ "            \"language\",\r\n" + "            \"location\",\r\n"
					+ "            \"num_comments\",\r\n" + "            \"num_inlinks\",\r\n"
					+ "            \"num_outlinks\",\r\n" + "            \"permalink\",\r\n"
					+ "            \"post\",\r\n" + "            \"post_length\",\r\n"
					+ "            \"sentiment\",\r\n" + "            \"tags\",\r\n" + "            \"title\"\r\n"
					+ "        ],\r\n" + "        \"excludes\": []\r\n" + "    },\r\n"
					+ "    \"docvalue_fields\": [\r\n" + "        {\r\n" + "            \"field\": \"@timestamp\",\r\n"
					+ "            \"format\": \"epoch_millis\"\r\n" + "        },\r\n" + "        {\r\n"
					+ "            \"field\": \"date\",\r\n" + "            \"format\": \"yyyy-MM-dd\"\r\n"
					+ "        }\r\n" + "    ],\r\n" + "    \"sort\": [\r\n" + "        {\r\n"
					+ "            \"_doc\": {\r\n" + "                \"order\": \"asc\"\r\n" + "            }\r\n"
					+ "        }\r\n" + "    ]\r\n" + "}");
		} else {
			query = new JSONObject("{\r\n" + "    \"size\": 1000,\r\n" + "    \"query\": {\r\n"
					+ "        \"bool\": {\r\n" + "            \"adjust_pure_negative\": true,\r\n"
					+ "            \"must\": [\r\n" + "                {\r\n" + "                    \"terms\": {\r\n"
					+ "                        \"post\": [" + term + "]\r\n" + "                    }\r\n"
					+ "                },\r\n" + "                {\r\n" + "                    \"terms\": {\r\n"
					+ "                        \"blogsite_id\": [" + ids_ + "],\r\n"
					+ "                        \"boost\": 1\r\n" + "                    }\r\n"
					+ "                },\r\n" + "                {\r\n" + "                    \"range\": {\r\n"
					+ "                        \"date\": {\r\n"
					+ "                            \"include_lower\": true,\r\n"
					+ "                            \"include_upper\": true,\r\n"
					+ "                            \"from\": \"" + date_from + "\",\r\n"
					+ "                            \"boost\": 1,\r\n" + "                            \"to\": \""
					+ date_to + "\"\r\n" + "                        }\r\n" + "                    }\r\n"
					+ "                }\r\n" + "            ],\r\n" + "            \"boost\": 1\r\n" + "        }\r\n"
					+ "    },\r\n" + "    \"_source\": {\r\n" + "        \"excludes\": [],\r\n"
					+ "        \"includes\": [\r\n" + "            \"title\",\r\n" + "            \"post\",\r\n"
					+ "            \"blogpost_id\",\r\n" + "            \"permalink\",\r\n"
					+ "            \"num_comments\",\r\n" + "            \"date\",\r\n"
					+ "            \"num_comments\",\r\n" + "            \"blogger\"\r\n" + "        ]\r\n"
					+ "    },\r\n" + "    \"sort\": [\r\n" + "        {\r\n" + "            \"influence_score\": {\r\n"
					+ "                \"unmapped_type\": \"float\",\r\n"
					+ "                \"missing\": \"_last\",\r\n" + "                \"order\": \"desc\"\r\n"
					+ "            }\r\n" + "        }\r\n" + "    ]\r\n" + "}");
		}

		System.out.println("query for elastic _getBloggerPosts --> " + query);

		JSONObject elas = this._elastic(query);
		JSONArray jsonArray = (JSONArray) elas.getJSONArray("hit_array");
		System.out.println("JSON ARR LENGTH" + jsonArray.length());
		String total = elas.get("total").toString();
		System.out.println("TOTAL LENGTH" + total);
		String title = null;
		String blogpost_id = null;
		String permalink = null;
		String date = null;
		String num_comments = null;
		String blogger = null;
		int occurence = 0;

		JSONArray all = new JSONArray();

		System.out.println("DONE GETTING POSTS FOR BLOGGER");
		if (jsonArray != null) {

			for (int i = 0; i < jsonArray.length(); i++) {

				String indx = jsonArray.get(i).toString();
				JSONObject j = new JSONObject(indx);
				String ids = j.get("_source").toString();
				String _ids = j.get("_id").toString();

				j = new JSONObject(ids);

				String src = j.get("post").toString();
				//src = src.replaceAll("\\<.*?>", "");

				//src = src.replaceAll("\\<.*?>", "");
				//src = escape(src);
				// = src.replace("o.style.setproperty", "");
				//src = src.replace("o.style.setProperty", "");
				//src = src.replace("(adsbygoogle = window.adsbygoogle || []).push({}); ", "");

				if (bloggerName == "NOBLOGGER" && term != "___NO__TERM___") {
					if (j.get("title").toString() != null || j.get("title").toString() != "") {
						occurence = this.countOccurences(src, term);
						System.out.println(term + "----------------------" + occurence);
						title = j.get("title").toString();
						blogpost_id = j.get("blogpost_id").toString();
						permalink = j.get("permalink").toString();
						date = j.get("date").toString();
						num_comments = j.get("num_comments").toString();
						blogger = j.get("blogger").toString();
					}
				}

				posts_occured_data = new JSONObject();
				posts_occured_data.put("post", src);
				posts_occured_data.put("title", title);
				posts_occured_data.put("blogpost_id", blogpost_id);
				posts_occured_data.put("permalink", permalink);
				posts_occured_data.put("date", date);
				posts_occured_data.put("num_comments", num_comments);
				posts_occured_data.put("blogger", blogger);
				posts_occured_data.put("occurence", occurence);

				all.put(posts_occured_data);

				list.add(src);
				_idlist.add("\"" + _ids + "\"");
			}

			System.out.println("DONE and size of list is --" + list.size());

			result = String.join(" ", list);
		}

		System.out.println("Done Escaped the necessary");

		System.out.println("Done remmoving stop words");

		all_data.put("total", total);
//result = this.escape2(result);
//		result = result.replace("//", "");
//		result = result.replace("\\", "");
		//result = this.escape2(result);
//		result = this.escape2(result);
		all_data.put("posts", result);
		all_data.put("data", all);

		return all_data;
	}

	/*
	 * public ArrayList _testbloggertranslate(String blogger, String start) throws
	 * Exception {
	 * 
	 * JSONObject jsonObj = new JSONObject( "{\r\n" +
	 * "    \"query\": \"SELECT post FROM blogposts where blogger='" + blogger +
	 * "'\"\r\n" + "}");
	 * 
	 * System.out.println("ress--" + jsonObj); String url =
	 * "http://localhost:9200/_xpack/sql/translate";
	 * 
	 * return this._getsqlTranslated(url, jsonObj, start); }
	 */
	/*
	 * public ArrayList _getsqlTranslated(String url, JSONObject jsonObj, String
	 * start) throws Exception { ArrayList<String> list = new ArrayList<String>();
	 * ArrayList<String> list2 = new ArrayList<String>();
	 * 
	 * try {
	 * 
	 * URL obj = new URL(url); HttpURLConnection con = (HttpURLConnection)
	 * obj.openConnection();
	 * 
	 * con.setDoOutput(true); con.setDoInput(true);
	 * 
	 * con.setRequestProperty("Content-Type", "application/json; charset=utf-32");
	 * con.setRequestProperty("Content-Type", "application/json");
	 * con.setRequestProperty("Accept-Charset", "UTF-32");
	 * con.setRequestProperty("Accept", "application/json");
	 * con.setRequestMethod("POST");
	 * 
	 * DataOutputStream wr = new DataOutputStream(con.getOutputStream());
	 * 
	 * // OutputStreamWriter wr1 = new OutputStreamWriter(con.getOutputStream());
	 * wr.write(jsonObj.toString().getBytes()); wr.flush();
	 * 
	 * int responseCode = con.getResponseCode(); BufferedReader in = new
	 * BufferedReader(new InputStreamReader(con.getInputStream())); //
	 * System.out.println("--"+in); String inputLine; StringBuffer response = new
	 * StringBuffer();
	 * 
	 * while ((inputLine = in.readLine()) != null) { response.append(inputLine); //
	 * System.out.println(inputLine);
	 * 
	 * list.add(inputLine);
	 * 
	 * } in.close();
	 * 
	 * JSONObject myResponse = new JSONObject(response.toString()); //
	 * System.out.println(myResponse);
	 * 
	 * } catch (Exception ex) { }
	 * 
	 * // GETTING THE IDS String url2 = base_url_test + "_search?"; JSONObject
	 * jsonObj2 = new JSONObject(list.get(0)); ArrayList res = this._getResult(url2,
	 * jsonObj2);
	 * 
	 * try { if (res.size() > 0) {
	 * 
	 * for (int i = 0; i < res.size(); i++) { String indx = res.get(i).toString();
	 * JSONObject j = new JSONObject(indx); String ids = j.get(start).toString(); j
	 * = new JSONObject(ids); String src = j.get("post").toString();
	 * 
	 * list2.add(src); } } } catch (Exception e) { System.err.println(e); } return
	 * list2;
	 * 
	 * }
	 */

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

	/*
	 * public String _getbloggermostterms(String blogger) throws Exception {
	 * 
	 * // GETTING THE TERMS ArrayList list = this._testbloggertranslate(blogger,
	 * "_source"); JSONObject list_ = new JSONObject(list);
	 * 
	 * String url = base_url_test + "_termvectors"; JSONObject jsonObj = new
	 * JSONObject( "{\r\n" + "    \"doc\": {\r\n" + "      \"post\": \"" +
	 * list.get(0) + "\"\r\n" + "    },\r\n" + "    \"term_statistics\" : true,\r\n"
	 * + "    \"field_statistics\" : true,\r\n" + "    \"positions\": false,\r\n" +
	 * "    \"offsets\": false,\r\n" + "    \"filter\" : {\r\n" +
	 * "      \"max_num_terms\" : 25,\r\n" + "      \"min_term_freq\" : 1,\r\n" +
	 * "      \"min_doc_freq\" : 1,\r\n" + "      \"min_word_length\":1\r\n" +
	 * "    }\r\n" + "}");
	 * 
	 * // ArrayList res2 = this._getResult(url3, jsonObj3);
	 * System.out.println("This is the term query for -----" + url + "-----" +
	 * jsonObj); // System.out.println("term vector -----" + list);
	 * 
	 * return this._getrawquery(url, jsonObj); }
	 */
}