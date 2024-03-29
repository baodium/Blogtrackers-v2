<<<<<<< HEAD
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
import scala.Tuple2;

import org.apache.commons.text.StringEscapeUtils;
import org.apache.http.HttpHost;
import org.apache.http.util.EntityUtils;
import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;
import org.apache.spark.sql.SparkSession;
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

	static HashMap<String, String> hm = DbConnection.loadConstant();

	String base_url = hm.get("elasticIndex") + "blogposts/"; // - For testing server

	static String elasticUrl = hm.get("elasticUrl");

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
		//System.out.println("ress--" + jsonObj);
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
				+ "											\"blogsite_id\":" + arg2 + "\r\n"
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
		//System.out.println("SELECT *  FROM blogposts WHERE blogger = '" + bloggers + "' AND " + field + ">='" + greater
				//+ "' AND " + field + "<='" + less + "' ORDER BY date ASC LIMIT " + size + "");

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

	public static ArrayList _getBlogPostDetails(String field, String greater, String less, String blogpost_ids, int size)
			throws Exception {
		DbConnection db = new DbConnection();
		String query = null;
		if(field != null & field == "" & greater != null & less == "" & size != 0) {
			query = "SELECT * FROM blogposts WHERE blogpost_id in( " + blogpost_ids + ") AND " + field
					+ ">='" + greater + "' AND " + field + "<='" + less + "'  LIMIT "  + size ;
		}else {
			query = "SELECT * FROM blogposts WHERE blogpost_id in( " + blogpost_ids + ")";
		}
		//System.out.println(query);

		ArrayList result = new ArrayList();
		try {
			result = db.queryJSON(query);

		} catch (Exception e) {
			return result;
		}
		return result;
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
//			System.out.println("SELECT1 blogpost_id FROM blogposts WHERE blogger in( " + bloggers + ") AND " + field
//					+ ">='" + greater + "' AND " + field + "<='" + less + "' ORDER BY " + sort + " " + order + " LIMIT "
//					+ size + "");
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
			result = db.queryJSON("SELECT *  FROM blogposts WHERE blogger = '" + bloggers + "' AND " + field + ">='"
					+ greater + "' AND " + field + "<='" + less + "' ORDER BY " + sort + " " + order + " LIMIT " + size
					+ "");

			// return all_data;
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
//			System.out.println("query for _searchRangeMaxTotalByBloggers"
//					+ "SELECT max(influence_score) as total, blogger_name,date FROM blogger WHERE blogger_name = '"
//					+ bloggers + "'  ORDER BY influence_score DESC LIMIT 1");
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
			//System.out.println("response--" + response);
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
			//System.out.println("DONE GETTING POSTS--" + freq);

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

	public static String getBlogIdsfromsearch(String term) {
		String result = "";
		JSONObject query = new JSONObject("{\r\n" + "	\r\n" + "    \"query\": {\r\n" + "        \"bool\": {\r\n"
				+ "            \"must\": [\r\n" + "                {\r\n" + "                    \"match\": {\r\n"
				+ "                        \"post\": \r\n" + "                            \"" + term + "\"\r\n"
				+ "                        \r\n" + "                    }\r\n" + "                }\r\n"
				+ "            ]\r\n" + "        }\r\n" + "    },\r\n" + "    \"size\": 0,\r\n"
				+ "    \"_source\": false,\r\n" + "    \"stored_fields\": \"_none_\",\r\n"
				+ "    \"aggregations\": {\r\n" + "        \"groupby\": {\r\n" + "            \"composite\": {\r\n"
				+ "                \"size\": 10000,\r\n" + "                \"sources\": [\r\n"
				+ "                    {\r\n" + "                        \"dat\": {\r\n"
				+ "                            \"terms\": {\r\n"
				+ "                                \"field\": \"blogsite_id\",\r\n"
				+ "                                \"missing_bucket\": true,\r\n"
				+ "                                \"order\": \"asc\"\r\n" + "                            }\r\n"
				+ "                        }\r\n" + "                    }\r\n" + "                ]\r\n"
				+ "            }\r\n" + "        }\r\n" + "    }\r\n" + "}");
		//System.out.println("this is the query for _getTotal " + query);
		try {
			JSONObject res = _makeElasticRequest(query, "POST", "/blogposts/_search");
			Object aggregation = res.getJSONObject("aggregations").getJSONObject("groupby").getJSONArray("buckets");
			JSONArray listofblogs = new JSONArray(aggregation.toString());

			for (Object x : listofblogs) {
				JSONObject idd = new JSONObject(x.toString());
				String blog_id = idd.getJSONObject("key").get("dat").toString();
				result += blog_id + ",";
//				System.out.println("x---"+x.toString());
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println(result);
		return result;
	}
	
	public static ArrayList getBlogIdsAndNamesfromsearch(String ids) {
		
		DbConnection db = new DbConnection();
		ArrayList response = new ArrayList();
		ids = ids.replaceAll(",$", "");
		ids = ids.replaceAll(", $", "");
		ids = "(" + ids + ")";
		try {
			response = db.queryJSON("SELECT blogsite_id, blogsite_name FROM blogsites WHERE blogsite_id  in " + ids);
		} catch (Exception e) {
			return response;
		}

		return response;
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
		// System.out.println("object-----" + jsonObj);
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
//		blog_ids = blog_ids.replaceAll(",$", "");
//		blog_ids = blog_ids.replaceAll(", $", "");
//		blog_ids = "(" + blog_ids + ")";

//		JSONObject query = new JSONObject(
//				"{\r\n" + "    \"query\": {\r\n" + "        \"terms\": {\r\n" + "            \"blogsite_id\": ["
//						+ blog_ids + "],\r\n" + "            \"boost\": 1\r\n" + "        }\r\n" + "    }\r\n" + "}");

		try {
//			ArrayList response = DbConnection.query("select count(*) as count from blogposts where blogsite_id in ("+blog_ids+")");
			ArrayList response = DbConnection.query("select sum(totalposts) as count from blogsites where blogsite_id in ("+blog_ids+")");
			if (response.size() > 0) {
				ArrayList hd = (ArrayList<?>) response.get(0);
				count = hd.get(0).toString();
			}
			
//			count = this._count(query);
		} catch (Exception e) {
			System.out.print("Error in getBlogPostById");
		}
		// System.out.println("query for elastic _getBlogPostById --> " + query);
		return count;
	}

//	_getBlogBloggerById

	public String _getBlogBloggerById(String blog_ids) {
		String count = "";
//		JSONObject result = new JSONObject();
//		JSONObject query = new JSONObject("{\r\n" + "    \"size\": 0,\r\n" + "    \"query\": {\r\n"
//				+ "        \"terms\": {\r\n" + "            \"blogsite_id\": [" + blog_ids + "],\r\n"
//				+ "            \"boost\": 1.0\r\n" + "        }\r\n" + "    },\r\n" + "    \"_source\": false,\r\n"
//				+ "    \"stored_fields\": \"_none_\",\r\n" + "    \"aggregations\": {\r\n"
//				+ "        \"groupby\": {\r\n" + "            \"filters\": {\r\n" + "                \"filters\": [\r\n"
//				+ "                    {\r\n" + "                        \"match_all\": {\r\n"
//				+ "                            \"boost\": 1.0\r\n" + "                        }\r\n"
//				+ "                    }\r\n" + "                ],\r\n"
//				+ "                \"other_bucket\": false,\r\n"
//				+ "                \"other_bucket_key\": \"_other_\"\r\n" + "            },\r\n"
//				+ "            \"aggregations\": {\r\n" + "                \"dat\": {\r\n"
//				+ "                    \"cardinality\": {\r\n"
//				+ "                        \"field\": \"blogger.keyword\"\r\n" + "                    }\r\n"
//				+ "                }\r\n" + "            }\r\n" + "        }\r\n" + "    }\r\n" + "}");
		
		
		try {
//			result = this._makeElasticRequest(query, "POST", "/blogposts/_search");
//			Object aggregation = result.getJSONObject("aggregations").getJSONObject("groupby").getJSONArray("buckets")
//					.getJSONObject(0).getJSONObject("dat").get("value");
//			count = aggregation.toString();
//			String q = "select count(distinct blogger) as count from blogposts where blogsite_id in ("+blog_ids+")";
			String q = "select count(blogger_name) as count from blogger where blogsite_id in ("+blog_ids+")";

			ArrayList response = DbConnection.query(q);
			if (response.size() > 0) {
				ArrayList hd = (ArrayList<?>) response.get(0);
				count = hd.get(0).toString();
			}

		} catch (Exception e) {
			System.out.print("Error in _getBlogBloggerById");
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
	public static JSONObject _makeElasticRequest(JSONObject query, String requestType, String endPoint)
			throws Exception {

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

//			MAKE SCROLL REQUEST
//			scroll_id = (String) myResponse.get("_scroll_id");
//
//			scrollResult = this._scrollRequest(scroll_id);
//			allhits = scrollResult.getJSONObject("hits").getJSONArray("hits");
//			source = allhits.toString();
//			jsonArray = merge(jsonArray, new JSONArray(source));

			// jsonArray.put(new JSONArray(source));

			// RECURRINNG SCROLL TILL HITS ARRAY IS EMPTY

//			for (int i = 0; i < 1; i++) {
//				if (allhits.length() <= 0) {
//					break;
//				}
////			while (allhits.length() > 0) {
////			while(jsonArray.length() < 1000) {
//				System.out.println("WHILE ---" + allhits.length());
//				scroll_id = (String) scrollResult.get("_scroll_id");
//				scrollResult = this._scrollRequest(scroll_id);
//				allhits = scrollResult.getJSONObject("hits").getJSONArray("hits");
//				source = allhits.toString();
//
//				jsonArray = merge(jsonArray, new JSONArray(source));
//				// jsonArray.put(new JSONArray(source));
//			}

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
		System.out.println("test-----" + que);
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
			System.out.println(myResponse);
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

	public static JSONArray _getGetDateAggregate(String bloggers, String fieldGroupby, String format, String fieldCount,
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

		JSONObject myResponse = _makeElasticRequest(query, "POST", "/blogposts/_search/?");
		String val = null;
		Integer freq = null;
		String idx = null;
		String language = null;
		JSONArray jsonArray = new JSONArray();

//		System.out.println("query for elastic _getGetDateAggregate --> " + query);

		if (null != myResponse.get("aggregations")) {
			jsonArray = myResponse.getJSONObject("aggregations").getJSONObject("groupby").getJSONArray("buckets");
//			val = buckets.toString();
//			JSONObject bucket_ = new JSONObject(val);
//			freq = (Integer) bucket_.getJSONObject("dat").get("value");
//			System.out.println("DONE GETTING POSoccutTS FOR BLOGGER--" + freq);

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

	public static ArrayList _getMostLanguage(String date_from, String date_to, String ids_, Integer limit) throws Exception {
		ArrayList<String> list = new ArrayList<String>();
		HashMap<String, Integer> hm2 = new HashMap<String, Integer>();
		
		String query = "select language, count(language) c from blogposts where blogsite_id in ("+ids_+") and date > \" "+date_from+"\" and date < \""+date_to+"\" and language is not null or language != 'null' group by language order by c desc limit "+limit+"";
//		System.out.println(query);
		ArrayList response = DbConnection.query(query);
		
		
		
		

//		JSONArray all = new JSONArray();
//
//		JSONObject query = new JSONObject("{\r\n" + "    \"size\": 0,\r\n" + "    \"query\": {\r\n"
//				+ "        \"bool\": {\r\n" + "            \"must\": [\r\n" + "                {\r\n"
//				+ "                    \"terms\": {\r\n" + "                        \"blogsite_id\": [" + ids_
//				+ "],\r\n" + "                        \"boost\": 1.0\r\n" + "                    }\r\n"
//				+ "                },\r\n" + "                {\r\n" + "                    \"range\": {\r\n"
//				+ "                        \"date\": {\r\n" + "                            \"from\": \"" + date_from
//				+ "\",\r\n" + "                            \"to\": \"" + date_to + "\",\r\n"
//				+ "                            \"include_lower\": true,\r\n"
//				+ "                            \"include_upper\": true,\r\n"
//				+ "                            \"boost\": 1.0\r\n" + "                        }\r\n"
//				+ "                    }\r\n" + "                }\r\n" + "            ],\r\n"
//				+ "            \"adjust_pure_negative\": true,\r\n" + "            \"boost\": 1.0\r\n" + "        }\r\n"
//				+ "    },\r\n" + "    \"_source\": false,\r\n" + "    \"stored_fields\": \"_none_\",\r\n"
//				+ "    \"aggregations\": {\r\n" + "        \"groupby\": {\r\n" + "            \"composite\": {\r\n"
//				+ "                \"size\": 1000,\r\n" + "                \"sources\": [\r\n"
//				+ "                    {\r\n" + "                        \"dat\": {\r\n"
//				+ "                            \"terms\": {\r\n"
//				+ "                                \"field\": \"language.keyword\",\r\n"
//				+ "                                \"missing_bucket\": true,\r\n"
//				+ "                                \"order\": \"asc\"\r\n" + "                            }\r\n"
//				+ "                        }\r\n" + "                    }\r\n" + "                ]\r\n"
//				+ "            },\r\n" + "            \"aggregations\": {\r\n" + "                \"dat\": {\r\n"
//				+ "                    \"filter\": {\r\n" + "                        \"exists\": {\r\n"
//				+ "                            \"field\": \"language\",\r\n"
//				+ "                            \"boost\": 1.0\r\n" + "                        }\r\n"
//				+ "                    }\r\n" + "                }\r\n" + "            }\r\n" + "        }\r\n"
//				+ "    }\r\n" + "}");
//
//		JSONObject myResponse = this._makeElasticRequest(query, "POST", "/blogposts/_search/?");
//		String val = null;
//		Integer freq = null;
//		String idx = null;
//		String language = null;
//		JSONArray jsonArray = new JSONArray();
//		// System.out.println("query for elastic _getMostLanguage --> " + query);
//		if (null != myResponse.get("aggregations")) {
//			Object buckets = myResponse.getJSONObject("aggregations").getJSONObject("groupby").getJSONArray("buckets");
//			val = buckets.toString();
//			jsonArray = new JSONArray(val);
//
//			System.out.println("DONE GETTING POSTS FOR BLOGGER");
//
//			if (jsonArray.length() < 10) {
//				limit = jsonArray.length();
//			}
//
//			if (jsonArray != null) {
//				for (int i = 0; i < limit; i++) {
//					JSONObject da = new JSONObject();
//					idx = jsonArray.get(i).toString();
//
//					JSONObject j = new JSONObject(idx);
//					freq = (Integer) j.get("doc_count");
//
//					Object k = j.getJSONObject("key").get("dat");
//					language = k.toString();
//
//					da.put("letter", language);
//					da.put("frequency", freq);
//
//					all.put(da);
//					hm2.put(language, freq);
//				}
//
//			}
//		}
		return response;
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

			// System.out.println("HIGHEST TERM IS -- " + source + " OCCURING " + value + "
			// TIMES");

			String da = hm1.toString();

			d = new JSONObject(hm1);
			// System.out.println(d);

		} else {
			source = "Null";
		}
		return hm1;

	}

	public String _getMostKeywordDashboard(String BloggerName, String date_from, String date_to, String ids_)
			throws Exception {
		//
//		BloggerName="Stephen Lendman,South Front";
		// System.out.println("postingfreqbloggers" + BloggerName);
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
		// System.out.println("query for elastic _getMostKeywordDashboard --> " +
		// query);
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

			// System.out.println("DONE and size of list is --" + list.size());
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
		// System.out.println(data.length());
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
			// System.out.println("INPROCESS");
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

			// System.out.println("2--" + data.length());
			Map<String, Integer> hm1 = this.sortHashMapByValues(hm2);
			System.out.println("DONE SORTING OBJECT");
			// System.out.println(" OCCURES-- " + hm1);

			Map.Entry<String, Integer> entry = hm1.entrySet().iterator().next();
			source = entry.getKey().toUpperCase();
			Integer value = entry.getValue();

			// System.out.println("HIGHEST TERM IS -- " + source + " OCCURING " + value + "
			// TIMES");

		} else {
			source = "Null";
		}
		return source;

	}

	public int countOccurences(String str, String word) {
		// System.out.println("str-"+str);
		int count = 0;
		word = word.toLowerCase();
		word = word.replace("\"", "");
		String[] word_split = word.split(",");

		for (String w : word_split) {
			// System.out.println("terms--" + w);
			String[] postsplit = str.split("\\W+");
			for (String pst : postsplit) {

				pst = pst.toLowerCase();
				if (w.trim().equals(pst.trim())) {
//					System.out.println(pst + "--" + w);
					count++;
					// title = title_;
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

	// SparkConf conf2 = new SparkConf();
	public ArrayList _selectTest(String id, int index) throws Exception {

		ArrayList result = null;

		try {
			System.out.println("select * from blogpost_terms where blogsite_id in " + id + " ");

			ArrayList response = DbConnection.query("select * from blogpost_terms where blogsiteid in (" + id + ") ");

			if (response.size() > 0) {

				ArrayList hd = response;
				// result = hd.get(index).toString();
				result = hd;
				// count = hd.get(0).toString();
			}
		} catch (Exception e) {
			return result;
		}

		return result;
	}

	public String mapReduce(List<Tuple2<String, Integer>> data) throws Exception {
		String result = null;
		try {
			SparkConf conf = new SparkConf().setMaster("local[*]").setAppName("Example");

			JavaSparkContext sc = new JavaSparkContext(conf);
			JavaRDD rdd = sc.parallelize(data);
			JavaPairRDD<String, Integer> pairRdd = JavaPairRDD.fromJavaRDD(rdd);
			ArrayList<Tuple2<String, Integer>> test = new ArrayList<Tuple2<String, Integer>>();
			/*
			 * for(Tuple2<String, Integer> x: pairRdd.reduceByKey((a,b) -> (a+
			 * b)).collect()) { //System.out.println(x); test.add(x); }
			 */
			// System.out.println(pairRdd.reduceByKey((a,b) -> (a+ b)).max(new
			// DummyComparator()));
			sc.stop();

		} catch (Exception e) {
			System.out.println(e);
		}
		return result;
	}

	public String countTerms(String path) throws Exception {
		String result = null;

		try {
			SparkConf conf = new SparkConf().setMaster("local[10]").setAppName("Example");

//			SparkSession spark = SparkSession
//				      .builder()
//				      .appName("Example")
//				      .config(conf)
//				      .getOrCreate();
//			SparkSession spark = SparkSession.builder()
//		    .appName("HDP Test Job")
//		    .master("yarn")
//		    .config("spark.submit.deployMode","cluster")
//		    //.config("spark.hadoop.fs.defaultFS", "hdfs://169.254.169.254:8020")
//		    //.config("spark.yarn.jars", "hdfs://169.254.169.254:8020/user/talentorigin/jars/*.jar")
//		    //.config("spark.hadoop.yarn.resourcemanager.address", "169.254.169.254:8032")
//		    //.config("spark.hadoop.yarn.application.classpath", "$HADOOP_CONF_DIR,$HADOOP_COMMON_HOME/*,$HADOOP_COMMON_HOME/lib/*,$HADOOP_HDFS_HOME/*,$HADOOP_HDFS_HOME/lib/*,$HADOOP_MAPRED_HOME/*,$HADOOP_MAPRED_HOME/lib/*,$HADOOP_YARN_HOME/*,$HADOOP_YARN_HOME/lib/*")
////		    .enableHiveSupport()
//		    .getOrCreate();
			JavaSparkContext sc = new JavaSparkContext(conf);
			//
			// JavaSparkContext sc = new JavaSparkContext(conf);
			JavaRDD<String> textFile = sc.textFile(path);
			Tuple2<String, Integer> counts = textFile.flatMap(s -> Arrays.asList(s.split(" ")).iterator())
					.mapToPair(word -> new Tuple2<>(word, 1)).reduceByKey((a, b) -> a + b).max(new DummyComparator());
//			new JavaSparkContext(new SparkConf().setMaster("local").setAppName("demo"))
//					.textFile("C:\\Users\\oljohnson\\Desktop\\SQL\\file2.json")
//					.flatMap(s -> Arrays.asList(s.split(" ")).iterator()).mapToPair(word -> new Tuple2<>(word, 1))
//
//					.reduceByKey((a, b) -> a + b)
//					.max( new DummyComparator());

			// .foreach(pair -> System.out.println(pair));

			// counts.saveAsTextFile("C:\\spark\\TEST\\new_output");
			result = counts._1().toString();
			sc.stop();
		} catch (Exception e) {
			System.out.println(e);
		}
		return result;
	}

	public String getHighestTerm(String data) throws Exception {
		String result = null;
		String source = null;
		String source_ = null;
		data = data.replaceAll("/[^A-Za-z0-9 ]/", "");
		System.out.println(data.length());
		// data = this.escape2(data);
		// data = this.escape(data);
		if (data.length() > 0) {
//data ="seun seun seun seun";

			System.out.println("INPROCESS--");

//			try (FileWriter file = new FileWriter("C:\\Users\\oljohnson\\Desktop\\SQL\\file2.json")) {
//
//				file.write(data.toString());
//				System.out.println("Successfully Copied JSON Object to File...");
//
//			}
			System.out.println("INPROCESS2--");
			try {
				result = this.countTerms("C:\\Users\\oljohnson\\Desktop\\SQL\\file2.json");

			} catch (Exception e) {
				System.out.println(e);
			}

		} else {
			source = "Null";
		}
		return result.toUpperCase();
	}

//	public String getHighestTerm(String data) throws Exception {
//		String result = null;
//		String source = null;
//		String source_ = null;
//		System.out.println(data.length());
//		data = this.escape2(data);
//		// data = this.escape(data);
//		if (data.length() > 0) {
////data ="seun seun seun seun";
//			JSONObject query = new JSONObject("{\r\n" + "    \"doc\": {\r\n" + "        \"post\": \"" + data + "\"\r\n"
//					+ "    },\r\n" + "\r\n" + "    \"term_statistics\": false,\r\n"
//					+ "        \"field_statistics\": false,\r\n" + "        \"positions\": false,\r\n"
//					+ "        \"offsets\": false,\r\n" + "        \"filter\": {\r\n"
//					+ "            \"max_num_terms\": 1,\r\n" + "            \"min_term_freq\": 1,\r\n"
//					+ "            \"min_doc_freq\": 1\r\n" + "        }\r\n" + "}");
//			System.out.println("INPROCESS--");
//
//			JSONObject myResponse = this._makeElasticRequest(query, "POST", "/termv/_termvectors?");
//			System.out.println("PROCESSED");
//			try (FileWriter file = new FileWriter("C:\\Users\\oljohnson\\Desktop\\SQL\\file2.json")) {
//
//				file.write(data.toString());
//				System.out.println("Successfully Copied JSON Object to File...");
//
//			}
//
//			try {
//				// Object r_ =
//				// this._multipleTermVectors(id).getJSONArray("docs").getJSONObject(0).getJSONObject("term_vectors").getJSONObject("post").getJSONObject("terms").keys().next().toString();
//				Object hits = myResponse.getJSONObject("term_vectors").getJSONObject("post").getJSONObject("terms");
//				// hits =
//				// myResponse.getJSONObject("term_vectors").getJSONObject("post").getJSONObject("terms");
//				source = hits.toString();
//			} catch (Exception e) {
//				System.out.println(e);
//			}
//
//			JSONObject jsonObject = new JSONObject(source);
//			Iterator<String> keys = jsonObject.keys();
//			int value = 0;
//
//			System.out.println("DONE GETTING TERM VECTORS");
//			HashMap<String, Integer> hm2 = new HashMap<String, Integer>();
//			while (keys.hasNext()) {
//				source = keys.next();
//				// do something with jsonObject here
//				Object freq = jsonObject.getJSONObject(source).get("term_freq");
//				value = (Integer) freq;
//
//			}
//
//			System.out.println("HIGHEST TERM IS -- " + source + " OCCURING " + value + " TIMES");
//
//		} else {
//			source = "Null";
//		}
//		return source.toUpperCase();
//	}

	public JSONObject _getBloggerPosts(String term, String bloggerName, String date_from, String date_to, String ids_,
			int limit) throws Exception {
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
			query = new JSONObject("{\r\n" + "    \"size\": 5000,\r\n" + "    \"query\": {\r\n"
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
			query = new JSONObject("{\r\n" + "    \"size\": " + limit + ",\r\n" + "    \"query\": {\r\n"
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
		System.out.println("TOTAL LENGTH--" + total);
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
				// src = src.replaceAll("\\<.*?>", "");

				// src = src.replaceAll("\\<.*?>", "");
				// src = escape(src);
				// = src.replace("o.style.setproperty", "");
				// src = src.replace("o.style.setProperty", "");
				// src = src.replace("(adsbygoogle = window.adsbygoogle || []).push({}); ", "");

				if (bloggerName == "NOBLOGGER" && term != "___NO__TERM___") {
					if (j.get("title").toString() != null || j.get("title").toString() != "") {
						occurence = this.countOccurences(src, term);
						// System.out.println(term + "----------------------" + occurence);
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

//				list.add(src);
//				_idlist.add("\"" + _ids + "\"");
			}

//			System.out.println("DONE and size of list is --" + list.size());

			// result = String.join(" ", list);
		}

		System.out.println("Done Escaped the necessary");

		System.out.println("Done remmoving stop words");

		all_data.put("total", total);
//result = this.escape2(result);
//		result = result.replace("//", "");
//		result = result.replace("\\", "");
		// result = this.escape2(result);
//		result = this.escape2(result);
//		all_data.put("posts", result);
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
	public static void main(String[] args) {
		try {
			
			ArrayList res = _getMostLanguage("2000-01-01", "2020-04-15", "63,127,223,224,611,615,617,641,673,720,817,872,874,949,954,957,961,1030,1033,1034,1035,1036,1038,1040,1041,1042,1049,1051,1052,1054,1055,1056,1058,1063,1064,1065,1066,1067,1068,1069,1083,1084,1088,1089,1092,1095,1100,1101,1105,1121,1122,1124,1126,1127,1128,1134,1137,1139,1141,1148,1163,1164,1166,1169,1172,1173,1184,1185,1188,1195,1196,1204,1207,1210,1211,1213,1218,1220,1221,1222,1233,1235,1238,1239,1240,1242,1244,1250,1251,1256,1258,1262,1279,1280,1282,1288,1290,1293,1295,1297,1303,1306,1307,1315,1319,1324,1330,1333,1339,1341,1346,1350,1352,1360,1376,1379,1380,1381,1385,1387,1392,1394,1397,1399,1409,1417,1421,1424,1426,1429,1438,1439,1440,1446,1447,1448,1451,1455,1456,1457,1458,1459,1460,1461,1472,1474,1475,1478,1486,1487,1489,1490,1492,1493,1497,1501,1503,1504,1506,1507,1509,1516,1523,1525,1526,1531,1533,1543,1561,1563,1567,1568,1569,1574,1575,1582,1583,1595,1601,1602,1604,1608,1611,1614,1615,1623,1627,1628,1630,1637,1638,1639,1642,1651,1655,1659,1660,1661,1662,1663,1668,1669,1676,1681,1682,1684,1685,1686,1688,1689,1690,1691,1692,1693,1694,1697,1698,1699,1700,1701,1703,1704,1705,1706,1707,1708,1709,1710,1711,1712,1713,1714,1715,1716,1717,1718,1719,1720,1721,1722,1723,1724,1725,1726,1727,1728,1729,1730,1731,1732,1733,1734,1735,1736,1737,1738,1739,1740,1742", 10);
			for(int i = 0; i < res.size(); i++) {
				ArrayList x = (ArrayList) res.get(i);
				System.out.println(x.get(0));
			}
			
//			System.out.println(_getGetDateAggregate("Conscioslifenews","date","yyyy","post","1y","date_histogram", "2000-01-01", "2020-04-15", "808,62,88,239,641,182,148,109,750,193,1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299, 300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348, 349, 350, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366, 367, 368, 369, 370, 371, 372, 373, 374, 375, 376, 377, 378, 379, 380, 381, 382, 383, 384, 385, 386, 387, 388, 389, 390, 391, 392, 393, 394, 395, 396, 397, 398, 399"));
//			System.out.println(_getBlogPostById("7"));
//			System.out.println();
			// getBlogIdsfromsearch("care");
//			_getBlogPostDetails("date", null, null, "1,2,3", 0);
//String ans = _getBlogPostById("63,127,223,224,611,615,617,641,673,720,817,872,874,949,954,957,961,1030,1033,1034,1035,1036,1038,1040,1041,1042,1049,1051,1052,1054,1055,1056,1058,1063,1064,1065,1066,1067,1068,1069,1083,1084,1088,1089,1092,1095,1100,1101,1105,1121,1122,1124,1126,1127,1128,1134,1137,1139,1141,1148,1163,1164,1166,1169,1172,1173,1184,1185,1188,1195,1196,1204,1207,1210,1211,1213,1218,1220,1221,1222,1233,1235,1238,1239,1240,1242,1244,1250,1251,1256,1258,1262,1279,1280,1282,1288,1290,1293,1295,1297,1303,1306,1307,1315,1319,1324,1330,1333,1339,1341,1346,1350,1352,1360,1376,1379,1380,1381,1385,1387,1392,1394,1397,1399,1409,1417,1421,1424,1426,1429,1438,1439,1440,1446,1447,1448,1451,1455,1456,1457,1458,1459,1460,1461,1472,1474,1475,1478,1486,1487,1489,1490,1492,1493,1497,1501,1503,1504,1506,1507,1509,1516,1523,1525,1526,1531,1533,1543,1561,1563,1567,1568,1569,1574,1575,1582,1583,1595,1601,1602,1604,1608,1611,1614,1615,1623,1627,1628,1630,1637,1638,1639,1642,1651,1655,1659,1660,1661,1662,1663,1668,1669,1676,1681,1682,1684,1685,1686,1688,1689,1690,1691,1692,1693,1694,1697,1698,1699,1700,1701,1703,1704,1705,1706,1707,1708,1709,1710,1711,1712,1713,1714,1715,1716,1717,1718,1719,1720,1721,1722,1723,1724,1725,1726,1727,1728,1729,1730,1731,1732,1733,1734,1735,1736,1737,1738,1739,1740,1742,1743,1744,1745,1746,1747,1749,1750,1751,1752,1753,1754,1755,1756,1757,1759,1761,1762,1763,1764,1765,1766,1767,1768,1769,1770,1771,1772,1773,1774,1775,1776,1777,1778,1779,1780,1781,1782,1783,1784,1786,1787,1788,1790,1791,1792,1793,1794,1795,1796,1797,1798,1799,1800,1801,1802,1803,1804,1806,1807,1808,1809,1810,1811,1812,1813,1814,1815,1816,1817,1818,1822,1823,1824,1825,1826,1827,1829,1830,1831,1833,1834,1835,1836,1837,1838,1839,1840,1841,1842,1843,1844,1845,1846,1848,1849,1850,1851,1852,1853,1854,1856,1857,1858,1859,1860,1861,1862,1863,1864,1865,1866,1867,1868,1869,1870,1871,1872,1873,1874,1875,1876,1878,1886,1907,1927,1929,1934,1940,1943,1944,1952,1957,1961,1963,1964,1965,1966,1968,1971,1973,1974,1977,1978,2050");
//		System.out.println(ans);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

=======
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
import scala.Tuple2;

import org.apache.commons.text.StringEscapeUtils;
import org.apache.http.HttpHost;
import org.apache.http.util.EntityUtils;
import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;
import org.apache.spark.sql.SparkSession;
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

	static HashMap<String, String> hm = DbConnection.loadConstant();

	String base_url = hm.get("elasticIndex") + "blogposts/"; // - For testing server

	static String elasticUrl = hm.get("elasticUrl");

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
		//System.out.println("ress--" + jsonObj);
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
				+ "											\"blogsite_id\":" + arg2 + "\r\n"
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
		//System.out.println("SELECT *  FROM blogposts WHERE blogger = '" + bloggers + "' AND " + field + ">='" + greater
				//+ "' AND " + field + "<='" + less + "' ORDER BY date ASC LIMIT " + size + "");

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

	public static ArrayList _getBlogPostDetails(String field, String greater, String less, String blogpost_ids, int size)
			throws Exception {
		DbConnection db = new DbConnection();
		String query = null;
		if(field != null & field == "" & greater != null & less == "" & size != 0) {
			query = "SELECT * FROM blogposts WHERE blogpost_id in( " + blogpost_ids + ") AND " + field
					+ ">='" + greater + "' AND " + field + "<='" + less + "'  LIMIT "  + size ;
		}else {
			query = "SELECT * FROM blogposts WHERE blogpost_id in( " + blogpost_ids + ")";
		}
		//System.out.println(query);

		ArrayList result = new ArrayList();
		try {
			result = db.queryJSON(query);

		} catch (Exception e) {
			return result;
		}
		return result;
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
//			System.out.println("SELECT1 blogpost_id FROM blogposts WHERE blogger in( " + bloggers + ") AND " + field
//					+ ">='" + greater + "' AND " + field + "<='" + less + "' ORDER BY " + sort + " " + order + " LIMIT "
//					+ size + "");
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
			result = db.queryJSON("SELECT *  FROM blogposts WHERE blogger = '" + bloggers + "' AND " + field + ">='"
					+ greater + "' AND " + field + "<='" + less + "' ORDER BY " + sort + " " + order + " LIMIT " + size
					+ "");

			// return all_data;
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
//			System.out.println("query for _searchRangeMaxTotalByBloggers"
//					+ "SELECT max(influence_score) as total, blogger_name,date FROM blogger WHERE blogger_name = '"
//					+ bloggers + "'  ORDER BY influence_score DESC LIMIT 1");
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
			//System.out.println("response--" + response);
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
			//System.out.println("DONE GETTING POSTS--" + freq);

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

	public static String getBlogIdsfromsearch(String term) {
		String result = "";
		JSONObject query = new JSONObject("{\r\n" + "	\r\n" + "    \"query\": {\r\n" + "        \"bool\": {\r\n"
				+ "            \"must\": [\r\n" + "                {\r\n" + "                    \"match\": {\r\n"
				+ "                        \"post\": \r\n" + "                            \"" + term + "\"\r\n"
				+ "                        \r\n" + "                    }\r\n" + "                }\r\n"
				+ "            ]\r\n" + "        }\r\n" + "    },\r\n" + "    \"size\": 0,\r\n"
				+ "    \"_source\": false,\r\n" + "    \"stored_fields\": \"_none_\",\r\n"
				+ "    \"aggregations\": {\r\n" + "        \"groupby\": {\r\n" + "            \"composite\": {\r\n"
				+ "                \"size\": 10000,\r\n" + "                \"sources\": [\r\n"
				+ "                    {\r\n" + "                        \"dat\": {\r\n"
				+ "                            \"terms\": {\r\n"
				+ "                                \"field\": \"blogsite_id\",\r\n"
				+ "                                \"missing_bucket\": true,\r\n"
				+ "                                \"order\": \"asc\"\r\n" + "                            }\r\n"
				+ "                        }\r\n" + "                    }\r\n" + "                ]\r\n"
				+ "            }\r\n" + "        }\r\n" + "    }\r\n" + "}");
		//System.out.println("this is the query for _getTotal " + query);
		try {
			JSONObject res = _makeElasticRequest(query, "POST", "/blogposts/_search");
			Object aggregation = res.getJSONObject("aggregations").getJSONObject("groupby").getJSONArray("buckets");
			JSONArray listofblogs = new JSONArray(aggregation.toString());

			for (Object x : listofblogs) {
				JSONObject idd = new JSONObject(x.toString());
				String blog_id = idd.getJSONObject("key").get("dat").toString();
				result += blog_id + ",";
//				System.out.println("x---"+x.toString());
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println(result);
		return result;
	}
	
	public static ArrayList getBlogIdsAndNamesfromsearch(String ids) {
		
		DbConnection db = new DbConnection();
		ArrayList response = new ArrayList();
		ids = ids.replaceAll(",$", "");
		ids = ids.replaceAll(", $", "");
		ids = "(" + ids + ")";
		try {
			response = db.queryJSON("SELECT blogsite_id, blogsite_name FROM blogsites WHERE blogsite_id  in " + ids);
		} catch (Exception e) {
			return response;
		}

		return response;
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
		// System.out.println("object-----" + jsonObj);
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
//		blog_ids = blog_ids.replaceAll(",$", "");
//		blog_ids = blog_ids.replaceAll(", $", "");
//		blog_ids = "(" + blog_ids + ")";

//		JSONObject query = new JSONObject(
//				"{\r\n" + "    \"query\": {\r\n" + "        \"terms\": {\r\n" + "            \"blogsite_id\": ["
//						+ blog_ids + "],\r\n" + "            \"boost\": 1\r\n" + "        }\r\n" + "    }\r\n" + "}");

		try {
//			ArrayList response = DbConnection.query("select count(*) as count from blogposts where blogsite_id in ("+blog_ids+")");
			ArrayList response = DbConnection.query("select sum(totalposts) as count from blogsites where blogsite_id in ("+blog_ids+")");
			if (response.size() > 0) {
				ArrayList hd = (ArrayList<?>) response.get(0);
				count = hd.get(0).toString();
			}
			
//			count = this._count(query);
		} catch (Exception e) {
			System.out.print("Error in getBlogPostById");
		}
		// System.out.println("query for elastic _getBlogPostById --> " + query);
		return count;
	}

//	_getBlogBloggerById

	public String _getBlogBloggerById(String blog_ids) {
		String count = "";
//		JSONObject result = new JSONObject();
//		JSONObject query = new JSONObject("{\r\n" + "    \"size\": 0,\r\n" + "    \"query\": {\r\n"
//				+ "        \"terms\": {\r\n" + "            \"blogsite_id\": [" + blog_ids + "],\r\n"
//				+ "            \"boost\": 1.0\r\n" + "        }\r\n" + "    },\r\n" + "    \"_source\": false,\r\n"
//				+ "    \"stored_fields\": \"_none_\",\r\n" + "    \"aggregations\": {\r\n"
//				+ "        \"groupby\": {\r\n" + "            \"filters\": {\r\n" + "                \"filters\": [\r\n"
//				+ "                    {\r\n" + "                        \"match_all\": {\r\n"
//				+ "                            \"boost\": 1.0\r\n" + "                        }\r\n"
//				+ "                    }\r\n" + "                ],\r\n"
//				+ "                \"other_bucket\": false,\r\n"
//				+ "                \"other_bucket_key\": \"_other_\"\r\n" + "            },\r\n"
//				+ "            \"aggregations\": {\r\n" + "                \"dat\": {\r\n"
//				+ "                    \"cardinality\": {\r\n"
//				+ "                        \"field\": \"blogger.keyword\"\r\n" + "                    }\r\n"
//				+ "                }\r\n" + "            }\r\n" + "        }\r\n" + "    }\r\n" + "}");
		
		
		try {
//			result = this._makeElasticRequest(query, "POST", "/blogposts/_search");
//			Object aggregation = result.getJSONObject("aggregations").getJSONObject("groupby").getJSONArray("buckets")
//					.getJSONObject(0).getJSONObject("dat").get("value");
//			count = aggregation.toString();
//			String q = "select count(distinct blogger) as count from blogposts where blogsite_id in ("+blog_ids+")";
			String q = "select count(blogger_name) as count from blogger where blogsite_id in ("+blog_ids+")";

			ArrayList response = DbConnection.query(q);
			if (response.size() > 0) {
				ArrayList hd = (ArrayList<?>) response.get(0);
				count = hd.get(0).toString();
			}

		} catch (Exception e) {
			System.out.print("Error in _getBlogBloggerById");
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
	public static JSONObject _makeElasticRequest(JSONObject query, String requestType, String endPoint)
			throws Exception {

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

//			MAKE SCROLL REQUEST
//			scroll_id = (String) myResponse.get("_scroll_id");
//
//			scrollResult = this._scrollRequest(scroll_id);
//			allhits = scrollResult.getJSONObject("hits").getJSONArray("hits");
//			source = allhits.toString();
//			jsonArray = merge(jsonArray, new JSONArray(source));

			// jsonArray.put(new JSONArray(source));

			// RECURRINNG SCROLL TILL HITS ARRAY IS EMPTY

//			for (int i = 0; i < 1; i++) {
//				if (allhits.length() <= 0) {
//					break;
//				}
////			while (allhits.length() > 0) {
////			while(jsonArray.length() < 1000) {
//				System.out.println("WHILE ---" + allhits.length());
//				scroll_id = (String) scrollResult.get("_scroll_id");
//				scrollResult = this._scrollRequest(scroll_id);
//				allhits = scrollResult.getJSONObject("hits").getJSONArray("hits");
//				source = allhits.toString();
//
//				jsonArray = merge(jsonArray, new JSONArray(source));
//				// jsonArray.put(new JSONArray(source));
//			}

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
		System.out.println("test-----" + que);
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
			System.out.println(myResponse);
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

	public static JSONArray _getGetDateAggregate(String bloggers, String fieldGroupby, String format, String fieldCount,
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

		JSONObject myResponse = _makeElasticRequest(query, "POST", "/blogposts/_search/?");
		String val = null;
		Integer freq = null;
		String idx = null;
		String language = null;
		JSONArray jsonArray = new JSONArray();

//		System.out.println("query for elastic _getGetDateAggregate --> " + query);

		if (null != myResponse.get("aggregations")) {
			jsonArray = myResponse.getJSONObject("aggregations").getJSONObject("groupby").getJSONArray("buckets");
//			val = buckets.toString();
//			JSONObject bucket_ = new JSONObject(val);
//			freq = (Integer) bucket_.getJSONObject("dat").get("value");
//			System.out.println("DONE GETTING POSoccutTS FOR BLOGGER--" + freq);

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

	public static ArrayList _getMostLanguage(String date_from, String date_to, String ids_, Integer limit) throws Exception {
		ArrayList<String> list = new ArrayList<String>();
		HashMap<String, Integer> hm2 = new HashMap<String, Integer>();
		
		String query = "select language, count(language) c from blogposts where blogsite_id in ("+ids_+") and date > \" "+date_from+"\" and date < \""+date_to+"\" and language is not null or language != 'null' group by language order by c desc limit "+limit+"";
//		System.out.println(query);
		ArrayList response = DbConnection.query(query);
		
		
		
		

//		JSONArray all = new JSONArray();
//
//		JSONObject query = new JSONObject("{\r\n" + "    \"size\": 0,\r\n" + "    \"query\": {\r\n"
//				+ "        \"bool\": {\r\n" + "            \"must\": [\r\n" + "                {\r\n"
//				+ "                    \"terms\": {\r\n" + "                        \"blogsite_id\": [" + ids_
//				+ "],\r\n" + "                        \"boost\": 1.0\r\n" + "                    }\r\n"
//				+ "                },\r\n" + "                {\r\n" + "                    \"range\": {\r\n"
//				+ "                        \"date\": {\r\n" + "                            \"from\": \"" + date_from
//				+ "\",\r\n" + "                            \"to\": \"" + date_to + "\",\r\n"
//				+ "                            \"include_lower\": true,\r\n"
//				+ "                            \"include_upper\": true,\r\n"
//				+ "                            \"boost\": 1.0\r\n" + "                        }\r\n"
//				+ "                    }\r\n" + "                }\r\n" + "            ],\r\n"
//				+ "            \"adjust_pure_negative\": true,\r\n" + "            \"boost\": 1.0\r\n" + "        }\r\n"
//				+ "    },\r\n" + "    \"_source\": false,\r\n" + "    \"stored_fields\": \"_none_\",\r\n"
//				+ "    \"aggregations\": {\r\n" + "        \"groupby\": {\r\n" + "            \"composite\": {\r\n"
//				+ "                \"size\": 1000,\r\n" + "                \"sources\": [\r\n"
//				+ "                    {\r\n" + "                        \"dat\": {\r\n"
//				+ "                            \"terms\": {\r\n"
//				+ "                                \"field\": \"language.keyword\",\r\n"
//				+ "                                \"missing_bucket\": true,\r\n"
//				+ "                                \"order\": \"asc\"\r\n" + "                            }\r\n"
//				+ "                        }\r\n" + "                    }\r\n" + "                ]\r\n"
//				+ "            },\r\n" + "            \"aggregations\": {\r\n" + "                \"dat\": {\r\n"
//				+ "                    \"filter\": {\r\n" + "                        \"exists\": {\r\n"
//				+ "                            \"field\": \"language\",\r\n"
//				+ "                            \"boost\": 1.0\r\n" + "                        }\r\n"
//				+ "                    }\r\n" + "                }\r\n" + "            }\r\n" + "        }\r\n"
//				+ "    }\r\n" + "}");
//
//		JSONObject myResponse = this._makeElasticRequest(query, "POST", "/blogposts/_search/?");
//		String val = null;
//		Integer freq = null;
//		String idx = null;
//		String language = null;
//		JSONArray jsonArray = new JSONArray();
//		// System.out.println("query for elastic _getMostLanguage --> " + query);
//		if (null != myResponse.get("aggregations")) {
//			Object buckets = myResponse.getJSONObject("aggregations").getJSONObject("groupby").getJSONArray("buckets");
//			val = buckets.toString();
//			jsonArray = new JSONArray(val);
//
//			System.out.println("DONE GETTING POSTS FOR BLOGGER");
//
//			if (jsonArray.length() < 10) {
//				limit = jsonArray.length();
//			}
//
//			if (jsonArray != null) {
//				for (int i = 0; i < limit; i++) {
//					JSONObject da = new JSONObject();
//					idx = jsonArray.get(i).toString();
//
//					JSONObject j = new JSONObject(idx);
//					freq = (Integer) j.get("doc_count");
//
//					Object k = j.getJSONObject("key").get("dat");
//					language = k.toString();
//
//					da.put("letter", language);
//					da.put("frequency", freq);
//
//					all.put(da);
//					hm2.put(language, freq);
//				}
//
//			}
//		}
		return response;
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

			// System.out.println("HIGHEST TERM IS -- " + source + " OCCURING " + value + "
			// TIMES");

			String da = hm1.toString();

			d = new JSONObject(hm1);
			// System.out.println(d);

		} else {
			source = "Null";
		}
		return hm1;

	}

	public String _getMostKeywordDashboard(String BloggerName, String date_from, String date_to, String ids_)
			throws Exception {
		//
//		BloggerName="Stephen Lendman,South Front";
		// System.out.println("postingfreqbloggers" + BloggerName);
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
		// System.out.println("query for elastic _getMostKeywordDashboard --> " +
		// query);
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

			// System.out.println("DONE and size of list is --" + list.size());
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
		// System.out.println(data.length());
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
			// System.out.println("INPROCESS");
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

			// System.out.println("2--" + data.length());
			Map<String, Integer> hm1 = this.sortHashMapByValues(hm2);
			System.out.println("DONE SORTING OBJECT");
			// System.out.println(" OCCURES-- " + hm1);

			Map.Entry<String, Integer> entry = hm1.entrySet().iterator().next();
			source = entry.getKey().toUpperCase();
			Integer value = entry.getValue();

			// System.out.println("HIGHEST TERM IS -- " + source + " OCCURING " + value + "
			// TIMES");

		} else {
			source = "Null";
		}
		return source;

	}

	public int countOccurences(String str, String word) {
		// System.out.println("str-"+str);
		int count = 0;
		word = word.toLowerCase();
		word = word.replace("\"", "");
		String[] word_split = word.split(",");

		for (String w : word_split) {
			// System.out.println("terms--" + w);
			String[] postsplit = str.split("\\W+");
			for (String pst : postsplit) {

				pst = pst.toLowerCase();
				if (w.trim().equals(pst.trim())) {
//					System.out.println(pst + "--" + w);
					count++;
					// title = title_;
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

	// SparkConf conf2 = new SparkConf();
	public ArrayList _selectTest(String id, int index) throws Exception {

		ArrayList result = null;

		try {
			System.out.println("select * from blogpost_terms where blogsite_id in " + id + " ");

			ArrayList response = DbConnection.query("select * from blogpost_terms where blogsiteid in (" + id + ") ");

			if (response.size() > 0) {

				ArrayList hd = response;
				// result = hd.get(index).toString();
				result = hd;
				// count = hd.get(0).toString();
			}
		} catch (Exception e) {
			return result;
		}

		return result;
	}

	public String mapReduce(List<Tuple2<String, Integer>> data) throws Exception {
		String result = null;
		try {
			SparkConf conf = new SparkConf().setMaster("local[*]").setAppName("Example");

			JavaSparkContext sc = new JavaSparkContext(conf);
			JavaRDD rdd = sc.parallelize(data);
			JavaPairRDD<String, Integer> pairRdd = JavaPairRDD.fromJavaRDD(rdd);
			ArrayList<Tuple2<String, Integer>> test = new ArrayList<Tuple2<String, Integer>>();
			/*
			 * for(Tuple2<String, Integer> x: pairRdd.reduceByKey((a,b) -> (a+
			 * b)).collect()) { //System.out.println(x); test.add(x); }
			 */
			// System.out.println(pairRdd.reduceByKey((a,b) -> (a+ b)).max(new
			// DummyComparator()));
			sc.stop();

		} catch (Exception e) {
			System.out.println(e);
		}
		return result;
	}

	public String countTerms(String path) throws Exception {
		String result = null;

		try {
			SparkConf conf = new SparkConf().setMaster("local[10]").setAppName("Example");

//			SparkSession spark = SparkSession
//				      .builder()
//				      .appName("Example")
//				      .config(conf)
//				      .getOrCreate();
//			SparkSession spark = SparkSession.builder()
//		    .appName("HDP Test Job")
//		    .master("yarn")
//		    .config("spark.submit.deployMode","cluster")
//		    //.config("spark.hadoop.fs.defaultFS", "hdfs://169.254.169.254:8020")
//		    //.config("spark.yarn.jars", "hdfs://169.254.169.254:8020/user/talentorigin/jars/*.jar")
//		    //.config("spark.hadoop.yarn.resourcemanager.address", "169.254.169.254:8032")
//		    //.config("spark.hadoop.yarn.application.classpath", "$HADOOP_CONF_DIR,$HADOOP_COMMON_HOME/*,$HADOOP_COMMON_HOME/lib/*,$HADOOP_HDFS_HOME/*,$HADOOP_HDFS_HOME/lib/*,$HADOOP_MAPRED_HOME/*,$HADOOP_MAPRED_HOME/lib/*,$HADOOP_YARN_HOME/*,$HADOOP_YARN_HOME/lib/*")
////		    .enableHiveSupport()
//		    .getOrCreate();
			JavaSparkContext sc = new JavaSparkContext(conf);
			//
			// JavaSparkContext sc = new JavaSparkContext(conf);
			JavaRDD<String> textFile = sc.textFile(path);
			Tuple2<String, Integer> counts = textFile.flatMap(s -> Arrays.asList(s.split(" ")).iterator())
					.mapToPair(word -> new Tuple2<>(word, 1)).reduceByKey((a, b) -> a + b).max(new DummyComparator());
//			new JavaSparkContext(new SparkConf().setMaster("local").setAppName("demo"))
//					.textFile("C:\\Users\\oljohnson\\Desktop\\SQL\\file2.json")
//					.flatMap(s -> Arrays.asList(s.split(" ")).iterator()).mapToPair(word -> new Tuple2<>(word, 1))
//
//					.reduceByKey((a, b) -> a + b)
//					.max( new DummyComparator());

			// .foreach(pair -> System.out.println(pair));

			// counts.saveAsTextFile("C:\\spark\\TEST\\new_output");
			result = counts._1().toString();
			sc.stop();
		} catch (Exception e) {
			System.out.println(e);
		}
		return result;
	}

	public String getHighestTerm(String data) throws Exception {
		String result = null;
		String source = null;
		String source_ = null;
		data = data.replaceAll("/[^A-Za-z0-9 ]/", "");
		System.out.println(data.length());
		// data = this.escape2(data);
		// data = this.escape(data);
		if (data.length() > 0) {
//data ="seun seun seun seun";

			System.out.println("INPROCESS--");

//			try (FileWriter file = new FileWriter("C:\\Users\\oljohnson\\Desktop\\SQL\\file2.json")) {
//
//				file.write(data.toString());
//				System.out.println("Successfully Copied JSON Object to File...");
//
//			}
			System.out.println("INPROCESS2--");
			try {
				result = this.countTerms("C:\\Users\\oljohnson\\Desktop\\SQL\\file2.json");

			} catch (Exception e) {
				System.out.println(e);
			}

		} else {
			source = "Null";
		}
		return result.toUpperCase();
	}

//	public String getHighestTerm(String data) throws Exception {
//		String result = null;
//		String source = null;
//		String source_ = null;
//		System.out.println(data.length());
//		data = this.escape2(data);
//		// data = this.escape(data);
//		if (data.length() > 0) {
////data ="seun seun seun seun";
//			JSONObject query = new JSONObject("{\r\n" + "    \"doc\": {\r\n" + "        \"post\": \"" + data + "\"\r\n"
//					+ "    },\r\n" + "\r\n" + "    \"term_statistics\": false,\r\n"
//					+ "        \"field_statistics\": false,\r\n" + "        \"positions\": false,\r\n"
//					+ "        \"offsets\": false,\r\n" + "        \"filter\": {\r\n"
//					+ "            \"max_num_terms\": 1,\r\n" + "            \"min_term_freq\": 1,\r\n"
//					+ "            \"min_doc_freq\": 1\r\n" + "        }\r\n" + "}");
//			System.out.println("INPROCESS--");
//
//			JSONObject myResponse = this._makeElasticRequest(query, "POST", "/termv/_termvectors?");
//			System.out.println("PROCESSED");
//			try (FileWriter file = new FileWriter("C:\\Users\\oljohnson\\Desktop\\SQL\\file2.json")) {
//
//				file.write(data.toString());
//				System.out.println("Successfully Copied JSON Object to File...");
//
//			}
//
//			try {
//				// Object r_ =
//				// this._multipleTermVectors(id).getJSONArray("docs").getJSONObject(0).getJSONObject("term_vectors").getJSONObject("post").getJSONObject("terms").keys().next().toString();
//				Object hits = myResponse.getJSONObject("term_vectors").getJSONObject("post").getJSONObject("terms");
//				// hits =
//				// myResponse.getJSONObject("term_vectors").getJSONObject("post").getJSONObject("terms");
//				source = hits.toString();
//			} catch (Exception e) {
//				System.out.println(e);
//			}
//
//			JSONObject jsonObject = new JSONObject(source);
//			Iterator<String> keys = jsonObject.keys();
//			int value = 0;
//
//			System.out.println("DONE GETTING TERM VECTORS");
//			HashMap<String, Integer> hm2 = new HashMap<String, Integer>();
//			while (keys.hasNext()) {
//				source = keys.next();
//				// do something with jsonObject here
//				Object freq = jsonObject.getJSONObject(source).get("term_freq");
//				value = (Integer) freq;
//
//			}
//
//			System.out.println("HIGHEST TERM IS -- " + source + " OCCURING " + value + " TIMES");
//
//		} else {
//			source = "Null";
//		}
//		return source.toUpperCase();
//	}

	public JSONObject _getBloggerPosts(String term, String bloggerName, String date_from, String date_to, String ids_,
			int limit) throws Exception {
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
			query = new JSONObject("{\r\n" + "    \"size\": 5000,\r\n" + "    \"query\": {\r\n"
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
			query = new JSONObject("{\r\n" + "    \"size\": " + limit + ",\r\n" + "    \"query\": {\r\n"
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
		System.out.println("TOTAL LENGTH--" + total);
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
				// src = src.replaceAll("\\<.*?>", "");

				// src = src.replaceAll("\\<.*?>", "");
				// src = escape(src);
				// = src.replace("o.style.setproperty", "");
				// src = src.replace("o.style.setProperty", "");
				// src = src.replace("(adsbygoogle = window.adsbygoogle || []).push({}); ", "");

				if (bloggerName == "NOBLOGGER" && term != "___NO__TERM___") {
					if (j.get("title").toString() != null || j.get("title").toString() != "") {
						occurence = this.countOccurences(src, term);
						// System.out.println(term + "----------------------" + occurence);
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

//				list.add(src);
//				_idlist.add("\"" + _ids + "\"");
			}

//			System.out.println("DONE and size of list is --" + list.size());

			// result = String.join(" ", list);
		}

		System.out.println("Done Escaped the necessary");

		System.out.println("Done remmoving stop words");

		all_data.put("total", total);
//result = this.escape2(result);
//		result = result.replace("//", "");
//		result = result.replace("\\", "");
		// result = this.escape2(result);
//		result = this.escape2(result);
//		all_data.put("posts", result);
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
	public static void main(String[] args) {
		try {
			
			ArrayList res = _getMostLanguage("2000-01-01", "2020-04-15", "63,127,223,224,611,615,617,641,673,720,817,872,874,949,954,957,961,1030,1033,1034,1035,1036,1038,1040,1041,1042,1049,1051,1052,1054,1055,1056,1058,1063,1064,1065,1066,1067,1068,1069,1083,1084,1088,1089,1092,1095,1100,1101,1105,1121,1122,1124,1126,1127,1128,1134,1137,1139,1141,1148,1163,1164,1166,1169,1172,1173,1184,1185,1188,1195,1196,1204,1207,1210,1211,1213,1218,1220,1221,1222,1233,1235,1238,1239,1240,1242,1244,1250,1251,1256,1258,1262,1279,1280,1282,1288,1290,1293,1295,1297,1303,1306,1307,1315,1319,1324,1330,1333,1339,1341,1346,1350,1352,1360,1376,1379,1380,1381,1385,1387,1392,1394,1397,1399,1409,1417,1421,1424,1426,1429,1438,1439,1440,1446,1447,1448,1451,1455,1456,1457,1458,1459,1460,1461,1472,1474,1475,1478,1486,1487,1489,1490,1492,1493,1497,1501,1503,1504,1506,1507,1509,1516,1523,1525,1526,1531,1533,1543,1561,1563,1567,1568,1569,1574,1575,1582,1583,1595,1601,1602,1604,1608,1611,1614,1615,1623,1627,1628,1630,1637,1638,1639,1642,1651,1655,1659,1660,1661,1662,1663,1668,1669,1676,1681,1682,1684,1685,1686,1688,1689,1690,1691,1692,1693,1694,1697,1698,1699,1700,1701,1703,1704,1705,1706,1707,1708,1709,1710,1711,1712,1713,1714,1715,1716,1717,1718,1719,1720,1721,1722,1723,1724,1725,1726,1727,1728,1729,1730,1731,1732,1733,1734,1735,1736,1737,1738,1739,1740,1742", 10);
			for(int i = 0; i < res.size(); i++) {
				ArrayList x = (ArrayList) res.get(i);
				System.out.println(x.get(0));
			}
			
//			System.out.println(_getGetDateAggregate("Conscioslifenews","date","yyyy","post","1y","date_histogram", "2000-01-01", "2020-04-15", "808,62,88,239,641,182,148,109,750,193,1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299, 300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348, 349, 350, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366, 367, 368, 369, 370, 371, 372, 373, 374, 375, 376, 377, 378, 379, 380, 381, 382, 383, 384, 385, 386, 387, 388, 389, 390, 391, 392, 393, 394, 395, 396, 397, 398, 399"));
//			System.out.println(_getBlogPostById("7"));
//			System.out.println();
			// getBlogIdsfromsearch("care");
//			_getBlogPostDetails("date", null, null, "1,2,3", 0);
//String ans = _getBlogPostById("63,127,223,224,611,615,617,641,673,720,817,872,874,949,954,957,961,1030,1033,1034,1035,1036,1038,1040,1041,1042,1049,1051,1052,1054,1055,1056,1058,1063,1064,1065,1066,1067,1068,1069,1083,1084,1088,1089,1092,1095,1100,1101,1105,1121,1122,1124,1126,1127,1128,1134,1137,1139,1141,1148,1163,1164,1166,1169,1172,1173,1184,1185,1188,1195,1196,1204,1207,1210,1211,1213,1218,1220,1221,1222,1233,1235,1238,1239,1240,1242,1244,1250,1251,1256,1258,1262,1279,1280,1282,1288,1290,1293,1295,1297,1303,1306,1307,1315,1319,1324,1330,1333,1339,1341,1346,1350,1352,1360,1376,1379,1380,1381,1385,1387,1392,1394,1397,1399,1409,1417,1421,1424,1426,1429,1438,1439,1440,1446,1447,1448,1451,1455,1456,1457,1458,1459,1460,1461,1472,1474,1475,1478,1486,1487,1489,1490,1492,1493,1497,1501,1503,1504,1506,1507,1509,1516,1523,1525,1526,1531,1533,1543,1561,1563,1567,1568,1569,1574,1575,1582,1583,1595,1601,1602,1604,1608,1611,1614,1615,1623,1627,1628,1630,1637,1638,1639,1642,1651,1655,1659,1660,1661,1662,1663,1668,1669,1676,1681,1682,1684,1685,1686,1688,1689,1690,1691,1692,1693,1694,1697,1698,1699,1700,1701,1703,1704,1705,1706,1707,1708,1709,1710,1711,1712,1713,1714,1715,1716,1717,1718,1719,1720,1721,1722,1723,1724,1725,1726,1727,1728,1729,1730,1731,1732,1733,1734,1735,1736,1737,1738,1739,1740,1742,1743,1744,1745,1746,1747,1749,1750,1751,1752,1753,1754,1755,1756,1757,1759,1761,1762,1763,1764,1765,1766,1767,1768,1769,1770,1771,1772,1773,1774,1775,1776,1777,1778,1779,1780,1781,1782,1783,1784,1786,1787,1788,1790,1791,1792,1793,1794,1795,1796,1797,1798,1799,1800,1801,1802,1803,1804,1806,1807,1808,1809,1810,1811,1812,1813,1814,1815,1816,1817,1818,1822,1823,1824,1825,1826,1827,1829,1830,1831,1833,1834,1835,1836,1837,1838,1839,1840,1841,1842,1843,1844,1845,1846,1848,1849,1850,1851,1852,1853,1854,1856,1857,1858,1859,1860,1861,1862,1863,1864,1865,1866,1867,1868,1869,1870,1871,1872,1873,1874,1875,1876,1878,1886,1907,1927,1929,1934,1940,1943,1944,1952,1957,1961,1963,1964,1965,1966,1968,1971,1973,1974,1977,1978,2050");
//		System.out.println(ans);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

>>>>>>> 1f92e31eaa52c61d7b7996ab5ec5a9cf214df293
}