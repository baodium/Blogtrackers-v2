<<<<<<< HEAD
package util;

import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.time.Instant;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;

import com.sun.corba.se.spi.orbutil.fsm.Action;

import authentication.DbConnection;
import javafx.util.Pair;
import scala.Tuple2;

import org.apache.lucene.search.MultiTermQuery.TopTermsBlendedFreqScoringRewrite;
import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;

import org.json.JSONArray;
import org.json.JSONObject;
//import org.apache.spark.mllib.clustering.KMeans;
//import org.apache.spark.mllib.clustering.KMeansModel;
//import org.apache.spark.mllib.linalg.Vector;
//import org.apache.spark.mllib.linalg.Vectors;

//import java.io.IOException;
//import java.net.URI;
//import java.net.http.HttpClient;
//import java.net.http.HttpRequest;
//import java.net.http.HttpResponse;

/**
 * Servlet implementation class Clustering
 */
@WebServlet("/CLUSTERING")
public class Clustering extends HttpServlet {

	static Terms term = new Terms();

//	public static void _clusteringTest(String pathin, String pathout) throws Exception {
//
//		SparkConf conf = new SparkConf().setMaster("local[4]").setAppName("Example");
//		JavaSparkContext jsc = new JavaSparkContext(conf);
//
//		// String path = "data/mllib/kmeans_data.txt";
//		JavaRDD<String> data = jsc.textFile(pathin);
//		JavaRDD<Vector> parsedData = data.map(s -> {
//			String[] sarray = s.split(" ");
//			double[] values = new double[sarray.length];
//			for (int i = 0; i < sarray.length; i++) {
//				values[i] = Double.parseDouble(sarray[i]);
//			}
//			return Vectors.dense(values);
//		});
//		parsedData.cache();
//
//		// Cluster the data into two classes using KMeans
//		int numClusters = 2;
//		int numIterations = 20;
//		KMeansModel clusters = KMeans.train(parsedData.rdd(), numClusters, numIterations);
//
//		System.out.println("Cluster centers:");
//		for (Vector center : clusters.clusterCenters()) {
//			System.out.println(" " + center);
//		}
//		double cost = clusters.computeCost(parsedData.rdd());
//		System.out.println("Cost: " + cost);
//
//		// Evaluate clustering by computing Within Set Sum of Squared Errors
//		double WSSSE = clusters.computeCost(parsedData.rdd());
//		System.out.println("Within Set Sum of Squared Errors = " + WSSSE);
//
//		// Save and load model
//		// "target/org/apache/spark/JavaKMeansExample/KMeansModel"
//		clusters.save(jsc.sc(), pathout);
//		KMeansModel sameModel = KMeansModel.load(jsc.sc(), pathout);
//		jsc.stop();
//
//	}
	public static String _getResult(String url, JSONObject jsonObj) throws Exception {
		ArrayList<String> list = new ArrayList<String>();
		JSONObject myResponse = new JSONObject();
		String out = null;
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

			myResponse = new JSONObject(response.toString());
			out = myResponse.toString();
			// System.out.println("RESPONSE ==> " + myResponse);

		} catch (Exception ex) {
		}
		// System.out.println("This is the list for -----" + url + "---" + list);
		return out;

	}

	public JSONObject getResult2(String uu, String jsonObj) throws Exception {
		HttpURLConnection conn = null;
//		 os = null;
		JSONObject myResponse = new JSONObject();
		try {
//			URL url = new URL("http://127.0.0.1:5000/add/"); // important to add the trailing slash after add
			URL url = new URL(uu); // important to add the trailing slash after add
			String[] inputData = { jsonObj };
//			HttpURLConnection con = (HttpURLConnection) url.openConnection();

			for (String input : inputData) {
				byte[] postData = input.getBytes(StandardCharsets.UTF_8);
				conn = (HttpURLConnection) url.openConnection();
				conn.setDoOutput(true);
				conn.setRequestMethod("POST");
				conn.setRequestProperty("Content-Type", "application/json");
				conn.setRequestProperty("charset", "utf-8");
				conn.setRequestProperty("Content-Length", Integer.toString(input.length()));
				DataOutputStream os = new DataOutputStream(conn.getOutputStream());
				os.write(postData);
				os.flush();

				if (conn.getResponseCode() != 200) {
					throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());
				}

				BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));

				String output;
				System.out.println("Output from Server .... \n");
				StringBuffer response = new StringBuffer();
				while ((output = br.readLine()) != null) {
//					System.out.println(output);
					response.append(output);
				}
				myResponse = new JSONObject(response.toString());
				conn.disconnect();

			}
		} catch (MalformedURLException e) {
			e.printStackTrace();
			System.out.println(e);
		} catch (IOException e) {
			e.printStackTrace();
			System.out.println(3);
		} finally {
			if (conn != null) {
				conn.disconnect();
			}
		}
		return myResponse;
	}

	public JSONObject _getResult3(String url, JSONObject jsonObj) throws Exception {
		JSONObject result = new JSONObject();
		String POST_PARAMS = jsonObj.toString();
//	    final String POST_PARAMS = "{\n" + "\"userId\": 101,\r\n" +
//
//        "    \"id\": 101,\r\n" +
//
//        "    \"title\": \"Test Title\",\r\n" +
//
//        "    \"body\": \"Test Body\"" + "\n}";

//    System.out.println(POST_PARAMS);

		URL obj = new URL("https://jsonplaceholder.typicode.com/posts");

		HttpURLConnection postConnection = (HttpURLConnection) obj.openConnection();

		postConnection.setRequestMethod("POST");

		postConnection.setRequestProperty("userId", "a1bcdefgh");

		postConnection.setRequestProperty("Content-Type", "application/json");

		postConnection.setDoOutput(true);

		OutputStream os = postConnection.getOutputStream();

		os.write(POST_PARAMS.getBytes());

		os.flush();

		os.close();

		int responseCode = postConnection.getResponseCode();

		System.out.println("POST Response Code :  " + responseCode);

		System.out.println("POST Response Message : " + postConnection.getResponseMessage());

		if (responseCode == HttpURLConnection.HTTP_CREATED) { // success

			BufferedReader in = new BufferedReader(new InputStreamReader(

					postConnection.getInputStream()));

			String inputLine;

			StringBuffer response = new StringBuffer();

			while ((inputLine = in.readLine()) != null) {

				response.append(inputLine);

			}
			in.close();

			// print result
			result = new JSONObject(response.toString());
			// System.out.println("THISI I SRESULT --" + result);
			postConnection.disconnect();

//        System.out.println(response.toString());

		} else {

			System.out.println("POST NOT WORKED");

		}
		return result;
	}

	public static int getShardSize(JSONObject query, String index) {
		JSONObject myResponse = new JSONObject();
		int result = 0;
		try {
			myResponse = term._makeElasticRequest(query, "GET", "/" + index + "/_search_shards/");
//			System.out.println("/" + index + "/_search_shards");
//			System.out.println(myResponse);
//			if (myResponse.length() > 0) {
			if (!(myResponse.getJSONObject("nodes") == null)) {
//				result = myResponse.getJSONArray("shards").getJSONArray(0).length();
				result = myResponse.getJSONObject("nodes").length();
			}
//			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}

	public String getTotal(String ids, String from, String to) {
		JSONObject query = new JSONObject();
		String result = null;
		String total = null;
		query = new JSONObject("{\r\n" + "    \"query\": {\r\n" + "        \"bool\": {\r\n"
				+ "            \"must\": [\r\n" + "                {\r\n" + "                    \"terms\": {\r\n"
				+ "                        \"blogsite_id\": [" + ids + "],\r\n"
				+ "                        \"boost\": 1\r\n" + "                    }\r\n" + "                },\r\n"
				+ "                {\r\n" + "                    \"range\": {\r\n"
				+ "                        \"date\": {\r\n" + "                            \"from\": \"" + from
				+ "\",\r\n" + "                            \"to\": \"" + to + "\",\r\n"
				+ "                            \"include_lower\": true,\r\n"
				+ "                            \"include_upper\": true,\r\n"
				+ "                            \"boost\": 1\r\n" + "                        }\r\n"
				+ "                    }\r\n" + "                }\r\n" + "            ],\r\n"
				+ "            \"adjust_pure_negative\": true,\r\n" + "            \"boost\": 1\r\n" + "        }\r\n"
				+ "    }\r\n" + "}");
		try {
			total = term._count(query, "/blogposts/_count?");
			result = total;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}

	public static ArrayList<JSONObject> _buildSlicedScrollQuery(String ids, String from, String to, String type,
			String index) throws Exception {
		JSONObject query = new JSONObject();

		if (type.contentEquals("__ONLY__TERMS__BLOGSITE_IDS__")) {
			query = new JSONObject("{\r\n" + "    \"query\": {\r\n" + "        \"bool\": {\r\n"
					+ "            \"must\": [\r\n" + "                {\r\n" + "                    \"terms\": {\r\n"
					+ "                        \"blogsiteid\": [" + ids + "],\r\n"
					+ "                        \"boost\": 1\r\n" + "                    }\r\n"
					+ "                },\r\n" + "                {\r\n" + "                    \"range\": {\r\n"
					+ "                        \"date\": {\r\n" + "                            \"from\": \"" + from
					+ "\",\r\n" + "                            \"to\": \"" + to + "\",\r\n"
					+ "                            \"include_lower\": true,\r\n"
					+ "                            \"include_upper\": true,\r\n"
					+ "                            \"boost\": 1\r\n" + "                        }\r\n"
					+ "                    }\r\n" + "                }\r\n" + "            ],\r\n"
					+ "            \"adjust_pure_negative\": true,\r\n" + "            \"boost\": 1\r\n"
					+ "        }\r\n" + "    }\r\n" + "}");
		} else if (type.contentEquals("__ONLY__POST__ID__")) {
			query = new JSONObject("{\r\n" + "   \r\n" + "    \"query\": {\r\n" + "        \"terms\": {\r\n"
					+ "            \"blogpost_id\": [" + ids + "],\r\n" + "            \"boost\": 1.0\r\n"
					+ "        }\r\n" + "    }\r\n" + "    \r\n" + "}");
		} else if (type.contentEquals("__ONLY__TERMS__")) {
			query = new JSONObject("{\r\n" + "   \r\n" + "    \"query\": {\r\n" + "        \"terms\": {\r\n"
					+ "            \"blogpost_id\": [" + ids + "],\r\n" + "            \"boost\": 1.0\r\n"
					+ "        }\r\n" + "    }\r\n" + "    \r\n" + "}");
		} else if (type.contentEquals("__ONLY__TERMS__BLOGGERS")) {
			query = new JSONObject("{\r\n" + "    \"query\": {\r\n" + "        \"bool\": {\r\n"
					+ "            \"must\": [\r\n" + "                {\r\n" + "                    \"terms\": {\r\n"
					+ "                        \"blogger.keyword\": [" + ids + "],\r\n"
					+ "                        \"boost\": 1\r\n" + "                    }\r\n"
					+ "                },\r\n" + "                {\r\n" + "                    \"range\": {\r\n"
					+ "                        \"date\": {\r\n" + "                            \"from\": \"" + from
					+ "\",\r\n" + "                            \"to\": \"" + to + "\",\r\n"
					+ "                            \"include_lower\": true,\r\n"
					+ "                            \"include_upper\": true,\r\n"
					+ "                            \"boost\": 1\r\n" + "                        }\r\n"
					+ "                    }\r\n" + "                }\r\n" + "            ],\r\n"
					+ "            \"adjust_pure_negative\": true,\r\n" + "            \"boost\": 1\r\n"
					+ "        }\r\n" + "    }\r\n" + "}");
		} else if (type.contains("__TERMS__KEYWORD__")) {
			String term = type.substring(type.lastIndexOf("__") + 2);
			System.out.println("term--" + term);
			query = new JSONObject("{\r\n" + "   \r\n" + "    \"query\": {\r\n" + "        \"bool\": {\r\n"
					+ "            \"must\": [\r\n" + "                {\r\n" + "                    \"terms\": {\r\n"
					+ "                        \"post\": [\r\n" + "                            " + term + "\r\n"
					+ "                        ]\r\n" + "                    }\r\n" + "                },\r\n"
					+ "                {\r\n" + "                    \"terms\": {\r\n"
					+ "                        \"blogsite_id\": [" + ids + "],\r\n"
					+ "                        \"boost\": 1\r\n" + "                    }\r\n"
					+ "                },\r\n" + "                {\r\n" + "                    \"range\": {\r\n"
					+ "                        \"date\": {\r\n" + "                            \"from\": \"" + from
					+ "\",\r\n" + "                            \"to\": \"" + to + "\",\r\n"
					+ "                            \"include_lower\": true,\r\n"
					+ "                            \"include_upper\": true,\r\n"
					+ "                            \"boost\": 1\r\n" + "                        }\r\n"
					+ "                    }\r\n" + "                }\r\n" + "            ]\r\n" + "        }\r\n"
					+ "    }\r\n" + "}");
		}

		System.out.println("buildquery--" + query);
		ArrayList<JSONObject> result = new ArrayList<JSONObject>();
		String total = term._count(query, "/" + index + "/_count?");
		// System.out.println(query);
		int shardCount = getShardSize(query, index);
//		System.out.println(shardCount);
//		System.out.println("total -->"+total);
		int temp = Integer.parseInt(total) / shardCount + 500;
//		int id = Math.round(Integer.parseInt(total) / size);
		// int size = 0;

//		  if (temp > 1000) { size = temp + 1000; } else { size = 1500; }

//		int 
		// size = Math.round(Integer.parseInt(total) / shardCount);
//		size = 1000;
//		size = (size > 10000) ? 10000 : size;
		// size = (size == 0) ? 0 : size;
		// size = 10000;
		// System.out.println("size -->" + size);

//		int max = (id + 2 > shardCount) ? shardCount : (id + 2);

		int max = 132;
//		System.out.println(String.valueOf(0));	

		System.out.println("max -->" + String.valueOf(max));
		for (int i = 0; i < max; i++) {
			String appendee = query.toString();
			String newquery = "{\r\n" + "\"size\":" + 1000 + "," + appendee.substring(1, appendee.length() - 1) + ","
					+ "\"slice\": {\r\n" + "    	      \"id\": " + String.valueOf(i) + ",\r\n" + "        \"max\": "
					+ String.valueOf(max) + "\r\n" + "    }}";

//			 System.out.println(newquery);
			result.add(new JSONObject(newquery));
		}
		return result;
	}

	public static List<JSONObject> getPosts(String ids, String from, String to, String type, String index)
			throws Exception {
		List<JSONObject> jsonArray;
		HashMap<String, String> result = new HashMap<String, String>();

		List<Tuple2<String, Integer>> datatuple = Collections
				.synchronizedList(new ArrayList<Tuple2<String, Integer>>());

		ConcurrentHashMap<String, Integer> d = new ConcurrentHashMap<String, Integer>();

		int shardCount = getShardSize(new JSONObject(), index);
		System.out.println("shard c 2==>" + shardCount);
		List<JSONObject> jsonList = Collections.synchronizedList(new ArrayList<JSONObject>());
		ConcurrentHashMap<String, ConcurrentHashMap<String, String>> datatuple3 = new ConcurrentHashMap<String, ConcurrentHashMap<String, String>>();
		ExecutorService executorServiceBlogSiteIds = Executors.newFixedThreadPool(shardCount);
		int start_test = 0;
		if (type.contentEquals("__ONLY__POST__ID__")) {
			jsonArray = new ArrayList<JSONObject>();
			for (JSONObject q : _buildSlicedScrollQuery(ids, from, to, type, index)) {
				// System.out.println(q);
				int start1 = 0;
				int end = 0;
				RunnableUtil esR2 = new RunnableUtil(q, jsonArray, start1, end, datatuple, d, "elastic", index, "post",
						jsonList, datatuple3);
				executorServiceBlogSiteIds.execute(esR2);
			}
		} else if (type.contentEquals("__ONLY__TERMS__")) {
//			jsonArray = new JSONArray();
			jsonArray = new ArrayList<JSONObject>();
			for (JSONObject q : _buildSlicedScrollQuery(ids, from, to, type, index)) {
//				 System.out.println(q);
				int start1 = 0;
				int end = 0;
				RunnableUtil esR2 = new RunnableUtil(q, jsonArray, start1, end, datatuple, d, "elastic", index, "terms",
						jsonList, datatuple3);
				executorServiceBlogSiteIds.execute(esR2);
			}
		} else if (type.contentEquals("__ONLY__TERMS__BLOGSITE_IDS__")) {
//			jsonArray = new JSONArray();
			jsonArray = new ArrayList<JSONObject>();
			for (JSONObject q : _buildSlicedScrollQuery(ids, from, to, type, index)) {
//				 System.out.println(q);
				int start1 = 0;
				int end = 0;
				RunnableUtil esR2 = new RunnableUtil(q, jsonArray, start_test, end, datatuple, d, "elastic", index,
						"terms", jsonList, datatuple3);
				executorServiceBlogSiteIds.execute(esR2);
			}
		} else if (type.contentEquals("__ONLY__TERMS__BLOGGERS")) {
//			jsonArray = new JSONArray();
			jsonArray = new ArrayList<JSONObject>();
			for (JSONObject q : _buildSlicedScrollQuery(ids, from, to, type, index)) {
//				 System.out.println(q);
				int start1 = 0;
				int end = 0;
//				RunnableUtil esR2 = new RunnableUtil(q, jsonArray, start1, end, datatuple, d, "elastic", index,
//						"terms");
				RunnableUtil esR2 = new RunnableUtil(q, jsonArray, start1, end, datatuple, d, "elastic", index, "terms",
						jsonList, datatuple3);
//				executorServiceBlogSiteIds.execute(esR2);
				executorServiceBlogSiteIds.execute(esR2);
			}
		} else if (type.contains("__TERMS__KEYWORD__")) {
//			jsonArray = new JSONArray();
			jsonArray = new ArrayList<JSONObject>();
			for (JSONObject q : _buildSlicedScrollQuery(ids, from, to, type, index)) {
//				 System.out.println(q);
				int start1 = 0;
				int end = 0;

				// RunnableUtil esR2 = new RunnableUtil(q, jsonArray, start_test, end,
				// datatuple, d, "elastic", index, "terms",jsonList);
				RunnableUtil esR2 = new RunnableUtil(q, jsonArray, start1, end, datatuple, d, "elastic", index, "terms",
						jsonList, datatuple3);
//				executorServiceBlogSiteIds.execute(esR2);
				executorServiceBlogSiteIds.execute(esR2);
			}
		}

		executorServiceBlogSiteIds.shutdown();
		while (!executorServiceBlogSiteIds.isTerminated()) {
		}
		System.out.println("list length from thread--" + jsonList.size());
		System.out.println("tuple3 --" + datatuple3.size());
		// System.out.println("length from thread--" + jsonArray.length());
//		try (FileWriter file = new FileWriter("C:\\Users\\bt_admin\\file2.json")) {
//			
//							file.write(jsonArray.toString());
//							System.out.println("Successfully Copied JSON Object to File...");
//			
//						}
		return jsonList;
	}

	public JSONArray getPostIdsFromApiCluster(String clusterNum, JSONObject result) throws Exception {
		JSONArray result_ = new JSONArray();
		String index = String.valueOf(Integer.parseInt(clusterNum) - 1);

		JSONArray posts_ids = result.getJSONArray(index).getJSONObject(0).getJSONObject("cluster_" + (clusterNum))
				.getJSONArray("post_ids");

		result_ = posts_ids;
		return result_;
	}

	public static String getBloggersMentioned(String postIds) throws Exception {
		String result = null;
		JSONObject query = new JSONObject("{\r\n" + "    \"size\": 0,\r\n" + "    \"query\": {\r\n"
				+ "        \"terms\": {\r\n" + "            \"blogpost_id\": [" + postIds + "],\r\n"
				+ "            \"boost\": 1.0\r\n" + "        }\r\n" + "    },\r\n" + "    \"_source\": false,\r\n"
				+ "    \"stored_fields\": \"_none_\",\r\n" + "    \"aggregations\": {\r\n"
				+ "        \"groupby\": {\r\n" + "            \"composite\": {\r\n"
				+ "                \"size\": 10000,\r\n" + "                \"sources\": [\r\n"
				+ "                    {\r\n" + "                        \"442\": {\r\n"
				+ "                            \"terms\": {\r\n"
				+ "                                \"field\": \"blogger.keyword\",\r\n"
				+ "                                \"missing_bucket\": true,\r\n"
				+ "                                \"order\": \"asc\"\r\n" + "                            }\r\n"
				+ "                        }\r\n" + "                    }\r\n" + "                ]\r\n"
				+ "            }\r\n" + "        }\r\n" + "    }\r\n" + "}");
//System.out.println("getBloggersMentioned --" + query);
		JSONObject myResponse = term._makeElasticRequest(query, "POST", "/blogposts/_search");
		if (null != myResponse.get("hits")) {
			Object aggregations = myResponse.getJSONObject("aggregations").getJSONObject("groupby")
					.getJSONArray("buckets").length();
			result = aggregations.toString();
		}
		return result;
	}

	public String getTopPostingLocation(String postIds) throws Exception {
//		String result = null;
//		JSONObject query = new JSONObject("{\r\n" + "    \"size\": 0,\r\n" + "    \"query\": {\r\n"
//				+ "        \"terms\": {\r\n" + "            \"blogpost_id\": [" + postIds + "],\r\n"
//				+ "            \"boost\": 1.0\r\n" + "        }\r\n" + "    },\r\n" + "    \"_source\": false,\r\n"
//				+ "    \"stored_fields\": \"_none_\",\r\n" + "    \"aggregations\": {\r\n"
//				+ "        \"groupby\": {\r\n" + "            \"composite\": {\r\n"
//				+ "                \"size\": 10000,\r\n" + "                \"sources\": [\r\n"
//				+ "                    {\r\n" + "                        \"dat\": {\r\n"
//				+ "                            \"terms\": {\r\n"
//				+ "                                \"field\": \"location.keyword\",\r\n"
//				+ "                                \"missing_bucket\": true,\r\n"
//				+ "                                \"order\": \"desc\"\r\n" + "                            }\r\n"
//				+ "                        }\r\n" + "                    }\r\n" + "                ]\r\n"
//				+ "            },\r\n" + "            \"aggregations\": {\r\n" + "                \"dat\": {\r\n"
//				+ "                    \"filter\": {\r\n" + "                        \"exists\": {\r\n"
//				+ "                            \"field\": \"location\",\r\n"
//				+ "                            \"boost\": 1.0\r\n" + "                        }\r\n"
//				+ "                    }\r\n" + "                }\r\n" + "            }\r\n" + "        }\r\n"
//				+ "    }\r\n" + "}");
//		// System.out.println("getTopPostingLocation --" + query);
//		JSONObject myResponse = term._makeElasticRequest(query, "POST", "/blogposts/_search");
//		if (null != myResponse.get("hits")) {
//			Object aggregations = myResponse.getJSONObject("aggregations").getJSONObject("groupby")
//					.getJSONArray("buckets").getJSONObject(0).getJSONObject("key").get("dat");
//			result = aggregations.toString();
//		}
//		return result;

		String result = null;
		JSONObject query = new JSONObject();
		query = new JSONObject("{\r\n" + "    \"size\": 0,\r\n" + "    \"query\": {\r\n" + "        \"bool\": {\r\n"
				+ "            \"must\": [\r\n" + "                {\r\n" + "                    \"terms\": {\r\n"
				+ "                        \"blogpost_id\": [" + postIds + "],\r\n"
				+ "                        \"boost\": 1\r\n" + "                    }\r\n" + "                }\r\n"
				+ "            ]\r\n" + "        }\r\n" + "    },\r\n" + "    \"aggregations\": {\r\n"
				+ "        \"groupby\": {\r\n" + "            \"composite\": {\r\n"
				+ "                \"size\": 1000,\r\n" + "                \"sources\": [\r\n"
				+ "                    {\r\n" + "                        \"dat\": {\r\n"
				+ "                            \"terms\": {\r\n"
				+ "                                \"missing_bucket\": false,\r\n"
				+ "                                \"field\": \"location\",\r\n"
				+ "                                \"order\": \"asc\"\r\n" + "                            }\r\n"
				+ "                        }\r\n" + "                    }\r\n" + "                ]\r\n"
				+ "            }\r\n" + "        }\r\n" + "    }\r\n" + "}");

		JSONObject myResponse = term._makeElasticRequest(query, "POST", "/blogposts/_search/?");
		if (null != myResponse.get("hits")) {
			Object key = null;
			Object value = null;

			String key_result = null;
			String value_result = null;

			Object k = myResponse.getJSONObject("aggregations").getJSONObject("groupby").getJSONArray("buckets");
			int lenght_of_array = new JSONArray(k.toString()).length();
			if (lenght_of_array > 0) {
				int current_max = 0;
				for (int i = 0; i < lenght_of_array; i++) {
					key = ((JSONArray) k).getJSONObject(i).getJSONObject("key").get("dat");
					value = myResponse.getJSONObject("aggregations").getJSONObject("groupby").getJSONArray("buckets")
							.getJSONObject(i).get("doc_count");

					if (Integer.parseInt(value.toString()) >= current_max) {
						current_max = Integer.parseInt(value.toString());
						key_result = key.toString();
						value_result = value.toString();
					}
				}
				result = key_result.toUpperCase();
			} else {
				result = "NO DATA AVAILABLE";
			}

		}
		return result;
	}

	public String totalposts = null;

	public String getBlogDistribution(String postIds, double total) throws Exception {
		String result = null;
		String[] postIdCount = postIds.split(",");
		double count = postIdCount.length;
		this.totalposts = String.valueOf(count);
		System.out.println("This is from count query" + count);

		double res = ((double) count / total) * 100;
		result = String.valueOf(Math.round(res)) + "%";

		return result;
	}

	public ArrayList<String> getPostsByPostIds(String postIds) throws Exception {
//		JSONArray jsonArray = new JSONArray();
		List<JSONObject> jsonArray = new ArrayList<JSONObject>();
//			HashMap<String, String> result = new HashMap<String, String>();
		ArrayList<String> result = new ArrayList<String>();
//			Instant start = Instant.now();
		List<Tuple2<String, Integer>> datatuple = new ArrayList<Tuple2<String, Integer>>();
//		Map<String, Integer> d = new HashMap<String, Integer>();
		ConcurrentHashMap<String, Integer> d = new ConcurrentHashMap<String, Integer>();
//		Map<String, Integer> d = Collections.synchronizedMap(new HashMap<String, Integer>());

		int shardCount = this.getShardSize(new JSONObject(), "blogposts");
		System.out.println("shard c 2==>" + shardCount);

		ExecutorService executorServiceBlogPostIds = Executors.newFixedThreadPool(shardCount + 1);
		for (JSONObject q : this._buildSlicedScrollQuery(postIds, "", "", "__ONLY__POST__ID__", "blogposts")) {
			// System.out.println(q);
			int start1 = 0;
			int end = 0;
			RunnableUtil esR2 = new RunnableUtil(q, jsonArray, start1, end, datatuple, d, "elastic", "blogposts",
					"post");
			executorServiceBlogPostIds.execute(esR2);
		}

		executorServiceBlogPostIds.shutdown();
		while (!executorServiceBlogPostIds.isTerminated()) {
		}

		JSONObject test = new JSONObject();
		for (int i = 0; i < jsonArray.size(); i++) {
//				Object post_id = jsonArray.getJSONObject(i).getJSONObject("_source").get("blogpost_id");
//			jsonArray.get(index)
			JSONObject t = new JSONObject(jsonArray.get(i));
//			Object post = jsonArray.getJSONObject(i).getJSONObject("_source").get("post");
			Object post = t.getJSONObject("_source").get("post");
			result.add(post.toString());
		}

		System.out.println("this is result" + result.size());
		return result;
	}

	public static ArrayList _getClusters(String tid) throws Exception {

		int size = 50;
		DbConnection db = new DbConnection();
		String count = "0";
		ArrayList result = new ArrayList();
		try {
			result = db.queryJSON("SELECT *  FROM clusters WHERE tid = '" + tid + "'");

		} catch (Exception e) {
			return result;
		}

		return result;

	}

	public static ArrayList _getSvd(String postids) throws Exception {

		int size = 50;
		DbConnection db = new DbConnection();
		String count = "0";
		ArrayList result = new ArrayList();
		try {
			result = db.queryJSON("SELECT *  FROM cluster_svd WHERE post_id in ( " + postids + ")");

		} catch (Exception e) {
			return result;
		}

		return result;

	}

	public static JSONObject topTerms(List postDataAll, String limit) {
		JSONObject res = new JSONObject();
		JSONArray output = new JSONArray();

		int a = postDataAll.size();
		int b = 1000;
		int poolsize = ((a / b)) > 0 ? (a / b) + 1 : 1;
		System.out.println(poolsize);

		ExecutorService executorServiceSplitLoop = Executors.newFixedThreadPool(poolsize);
		System.out.println("1" + executorServiceSplitLoop.isShutdown());
		List<Tuple2<String, Integer>> returnedData = Collections
				.synchronizedList(new ArrayList<Tuple2<String, Integer>>());
		ConcurrentHashMap<String, String> datatuple2 = new ConcurrentHashMap<String, String>();
		ConcurrentHashMap<String, ConcurrentHashMap<String, String>> datatuple3 = new ConcurrentHashMap<String, ConcurrentHashMap<String, String>>();
		ConcurrentHashMap<String, Integer> d = new ConcurrentHashMap<String, Integer>();
		StringBuffer buffer = new StringBuffer();

		for (int i = 0; i < a; i = i + b) {

			int start1 = 0;
			int end_ = 0;
			start1 = i;

			if ((i + b) > a) {
				end_ = i + (a % b);
			} else {
				end_ = i + b;
			}
			System.out.println(start1 + "--" + end_);
			JSONObject q = new JSONObject();
			RunnableUtil es = new RunnableUtil(q, postDataAll, start1, end_, returnedData, datatuple2, d, "loop",
					"blogpost_terms", "terms", buffer, datatuple3);
			executorServiceSplitLoop.execute(es);
		}

		executorServiceSplitLoop.shutdown();
		while (!executorServiceSplitLoop.isTerminated()) {
		}

		System.out.println("datatule2--" + datatuple2.size());
		System.out.println("datatule3--" + datatuple3.size());
		System.out.println("json array size" + postDataAll.size());
		System.out.println("returned--" + returnedData.size());
		HashMap<String, Integer> m = new HashMap<String, Integer>();
		for (Tuple2<String, Integer> p : returnedData) {
			String first = p._1;
			Integer second = p._2;
			if (!m.containsKey(first)) {
				m.put(first, second);
			} else {
				int m_val = m.get(first);
				int new_mval = m_val + second;
				m.put(first, new_mval);
			}
		}

		List<Entry<String, Integer>> entry = new Terms().entriesSortedByValues(m);
		if (entry.size() > 0) {
			for (int i = 0; i < Integer.parseInt(limit); i++) {
				if (i < entry.size()) {
					String left = entry.get(i).getKey();
					Integer right = entry.get(i).getValue();
					Tuple2<String, Integer> v = new Tuple2<String, Integer>(left, right);
					output.put(v);
				} else {
					break;
				}
			}
			System.out.println("answer--" + entry.get(0));
			System.out.println("output--" + output);
		}
		res.put("output", output);
		res.put("post_id_term_pair", datatuple2);
		res.put("post_id_post", datatuple3);
		return res;
	}

	public static void topTerms2(List<JSONObject> postDataAll, String limit) {

//		for (int i = 0; i < a; i = i + b) {
//
//			int start1 = 0;
//			int end_ = 0;
//
////	int[] test = new int[2];
////test[0] = i;
//			start1 = i;
//
//			if ((i + b) > a) {
////test[1] = i +(a%b);
//				end_ = i + (a % b);
//			} else {
////test[1] = i + b;
//				end_ = i + b;
//			}
//			System.out.println(start1 + "--" + end_);
//			JSONObject q = new JSONObject();
//			RunnableUtil es = new RunnableUtil(q, postDataAll, start1, end_, returnedData, datatuple2, d, "loop",
//					"blogpost_terms", "terms", buffer,datatuple3);
//			executorServiceSplitLoop.execute(es);
////			returnedData = es.datatuple;
//			// System.out.println("returned"+returnedData.size());
//
//		}
//
//		System.out.println("datatule2--" + datatuple2.size());
//		System.out.println("datatule3--" + datatuple3.size());
//		System.out.println("json array size" + postDataAll.size());
////		RunnableUtil es = new RunnableUtil();
////		(în,114787)
//		System.out.println("returned--" + returnedData.size());
//		HashMap<String, Integer> m = new HashMap<String, Integer>();
//		for (Tuple2<String, Integer> p : returnedData) {
//			String first = p._1;
//			Integer second = p._2;
//			if (!m.containsKey(first)) {
//				m.put(first, second);
//			} else {
//				int m_val = m.get(first);
//				int new_mval = m_val + second;
//				m.put(first, new_mval);
//			}
//		}
////		System.out.println(returnedData.get(0));
//
////		result = term.mapReduce(returnedData, limit);
//		List<Entry<String, Integer>> entry = new Terms().entriesSortedByValues(m);
////		
//		if (entry.size() > 0) {
//			for (int i = 0; i < Integer.parseInt(limit); i++) {
//				String left = entry.get(i).getKey();
//				Integer right = entry.get(i).getValue();
////			String v =  "(" + left + "," + String.valueOf(right) + ")";
//				Tuple2<String, Integer> v = new Tuple2<String, Integer>(left, right);
//				output.put(v);
//			}
//			System.out.println("answer--" + entry.get(0));
//			System.out.println("output--" + output);
//
////			return output;
//		}
//		res.put("output", output);
//		res.put("post_id_term_pair", datatuple2);
//		res.put("post_id_post", datatuple3);
//		return res;
	}

	public static String getTopTermsFromBlogIds(String ids, String from, String to, String limit) throws Exception {
		String result = null;
		JSONArray output = new JSONArray();
//		System.out.println("select * from blogpost_terms where blogsiteid in  (" + ids + ") and date > \"" + from
//				+ "\" and date < \"" + to + "\"");
//		List postDataAll = DbConnection.queryJSON("select * from blogpost_terms where blogsiteid in  (" + ids
//				+ ") and date > \"" + from + "\" and date < \"" + to + "\"");
//		JSONObject o = topTerms(postDataAll, limit);
//
//		return o;

		String query = "select n.term, sum(n.occurr) occurrence " + "from blogpost_terms_api, "
				+ "json_table(terms_test, " + "'$[*]' columns( " + "term varchar(128) path '$.term', "
				+ "occurr int(11) path '$.occurrence' " + ") " + ") " + "as n " + "where blogsiteid in  (" + ids
				+ ") and date > \"" + from + "\" and date < \"" + to + "\" " + "group by n.term "
				+ "order by occurrence desc " + "limit " + limit + "";
		System.out.println(query);
		List postDataAll = DbConnection.queryJSON(query);
		if (postDataAll.size() > 0) {
			for (int i = 0; i < postDataAll.size(); i++) {
				JSONObject data = new JSONObject(postDataAll.get(i).toString());
				Object term = data.getJSONObject("_source").get("term");
				Object occurrence = data.getJSONObject("_source").get("occurrence");
				Tuple2<String, Integer> v = new Tuple2<String, Integer>(term.toString(),
						Integer.parseInt(occurrence.toString()));
				output.put(v);

			}
		}
		return output.toString();
	}

	public static String getTopTermsFromBlogger(String blogger, String from, String to, String limit) throws Exception {
		String result = null;
		JSONArray output = new JSONArray();
//		System.out.println("select * from blogpost_terms where blogger in  (" + blogger + ") and date > \"" + from
//				+ "\" and date < \"" + to + "\"");
//		List postDataAll = DbConnection.queryJSON("select * from blogpost_terms where blogger in  (" + blogger
//				+ ") and date > \"" + from + "\" and date < \"" + to + "\"");
//		JSONObject o = topTerms(postDataAll, limit);
//
//		return o.get("output").toString();
		if (blogger.indexOf("\"") != 0) {
			blogger = "\"" + blogger + "\"";
		}
		String query = "select n.term, sum(n.occurr) occurrence " + "from blogpost_terms_api, "
				+ "json_table(terms_test, " + "'$[*]' columns( " + "term varchar(128) path '$.term', "
				+ "occurr int(11) path '$.occurrence' " + ") " + ") " + "as n " + "where blogger in  (" + blogger
				+ ") and date > \"" + from + "\" and date < \"" + to + "\" " + "group by n.term "
				+ "order by occurrence desc " + "limit " + limit + "";
		System.out.println(query);
		List postDataAll = DbConnection.queryJSON(query);
		if (postDataAll.size() > 0) {
			for (int i = 0; i < postDataAll.size(); i++) {
				JSONObject data = new JSONObject(postDataAll.get(i).toString());
				Object term = data.getJSONObject("_source").get("term");
				Object occurrence = data.getJSONObject("_source").get("occurrence");
				Tuple2<String, Integer> v = new Tuple2<String, Integer>(term.toString(),
						Integer.parseInt(occurrence.toString()));
				output.put(v);

			}
		}
		return output.toString();
	}

	public static String getTopTermsFromDashboard(String ids, String from, String to, String limit) throws Exception {
		String result = null;
		System.out.println("select * from blogpost_terms where blogsiteid in  (" + ids + ") and date > \"" + from
				+ "\" and date < \"" + to + "\"");
		List postDataAll = DbConnection.queryJSON("select * from blogpost_terms where blogsiteid in  (" + ids
				+ ") and date > \"" + from + "\" and date < \"" + to + "\"");
		JSONObject o = topTerms(postDataAll, limit);

		return o.get("output").toString();
	}

	public static String getTopTermsBlogger(String bloggers, String from, String to, String limit) throws Exception {
		String result = null;
		System.out.println("select * from blogpost_terms where blogger = \"" + bloggers + "\" and date > \"" + from
				+ "\" and date < \"" + to + "\"");
		List postDataAll = DbConnection.queryJSON("select * from blogpost_terms where blogger = \"" + bloggers
				+ "\" and date > \"" + from + "\" and date < \"" + to + "\"");
		if (postDataAll.size() > 0) {
			JSONObject o = topTerms(postDataAll, limit);
			JSONArray output = (JSONArray) o.get("output");

			result = output.toString().replaceAll("\"", "");
		} else {
			JSONArray output = new JSONArray("[-]");

			result = output.toString().replaceAll("\"", "");
		}
		return result;
	}

	public static String getTopTermsFromBlogIds2(String ids, String from, String to, String limit) throws Exception {
		String result = null;

		List<JSONObject> postDataAll = getPosts(ids, from, to, "__ONLY__TERMS__BLOGSITE_IDS__", "blogpost_terms");

		System.out.println(postDataAll.size());
		return result;
	}

	public static void main(String[] args) {

		try {

			Instant start = Instant.now();
			String ids = "813,815,809,811,812,806,808,817,644,652,616,641,732,761,709,128";
//			 String ids ="142,153,229,148,127,46,3,170,154,72,38,224,157,128,61,112,140,116,125,193,173,74,249,250,243,263,98,69,62,78,117,73,135,133,100,143,77,233,221,163,132,147,150,43,242,111,101,86,199,251,118,106,121,129,49,48,66,91,176,124,167,215,141,166,17,220,119,236,230,225,252,20,130,22,76,235,85,245,79,26,109,80,131,253,105,226,137,115,52,53,65,213,96,238,210,136,239,27,206,107,63,57,204,205,216,208,36,102,134,108,113,59,54,88";
//			String ids = "616";
//			String from = "2008-08-09";
//			String to = "2015-06-01";
//			String from = "1970-01-01";
//			String to = "2020-03-15";
//			String from = "1012-10-17";
//			String to = "2020-03-15";
//					"from": "2008-08-09",
//			        "to": "2015-06-01",

//			String ids = "";
			StringBuffer buffer = new StringBuffer();
			String from = "2000-01-01";
			String to = "2020-03-27";
			// System.out.println(getTopTermsFromBlogIds(ids, from, to, "100"));
			String s1 = "[('ukraine', 10), ('russia', 9), ('neutralism', 7), ('yugoslavia', 6), ('west', 5), ('economy', 4), ('policy', 3), ('tito', 3), ('stalin', 3), ('blocs', 3), ('poroshenko', 3), ('imf', 3), ('crisis', 2), ('relations', 2), ('power', 2), ('increasingly', 2), ('obama', 2), ('grey', 2), ('cold', 2), ('split', 2), ('members', 2), ('rapprochement', 2), ('exchange', 2), ('sending', 2), ('people', 2), ('send', 2), ('soviet', 2), ('nato', 2), ('threat', 2), ('regime', 2), ('looked', 2), ('petro', 2), ('russian', 2), ('putin', 2), ('offers', 2), ('union', 2), ('economic', 2), ('stability', 2), ('government', 2), ('crimean', 1), ('heralds', 1), ('international', 1), ('pivotal', 1), ('moment', 1), ('relationship', 1), ('balances', 1), ('shifting', 1), ('united', 1), ('remains', 1), ('unrivalled', 1), ('sheer', 1), ('close', 1), ('borders', 1), ('rising', 1), ('china', 1), ('assertive', 1), ('allegedly', 1), ('emboldened', 1), ('vacillations', 1), ('syria', 1), ('areas', 1), ('emerging', 1), ('vulnerable', 1), ('revisionist', 1), ('powers', 1), ('alarmed', 1), ('hands', 1), ('approach', 1), ('appears', 1), ('worthy', 1), ('revival', 1), ('defined', 1), ('foreign', 1), ('pioneered', 1), ('finland', 1), ('josip', 1), ('geographically', 1), ('sandwiched', 1), ('antagonistic', 1), ('prescribed', 1), ('balanced', 1), ('relationships', 1), ('neutral', 1), ('reaped', 1), ('rewards', 1), ('reserved', 1), ('paid', 1), ('bloc', 1), ('enjoyed', 1), ('modicum', 1), ('security', 1), ('knowing', 1), ('considered', 1), ('mutual', 1), ('neighbour', 1), ('preferable', 1), ('defection', 1), ('archetypal', 1), ('volcanic', 1), ('foresaw', 1), ('featured', 1), ('imploring', 1), ('kill', 1), ('teasing', 1), ('paranoia', 1), ('killers', 1), ('wrote', 1), ('moscow', 1), ('ensuing', 1), ('isolation', 1), ('decimated', 1), ('embargo', 1), ('thorn', 1), ('flesh', 1), ('communist', 1), ('unity', 1), ('trade', 1), ('deficits', 1), ('soaked', 1), ('afloat', 1), ('generous', 1), ('western', 1), ('loans', 1), ('balkan', 1), ('pact', 1), ('entwined', 1), ('greece', 1), ('turkey', 1), ('affording', 1), ('relief', 1), ('real', 1), ('intervention', 1), ('necessitating', 1), ('formal', 1), ('membership', 1), ('khrushchёv', 1), ('ostensibly', 1), ('socialist', 1), ('prospered', 1), ('area', 1), ('messianic', 1), ('empires', 1), ('lynchpin', 1), ('needed', 1), ('subject', 1), ('continued', 1), ('independence', 1), ('crushing', 1), ('hungary', 1), ('revolution', 1), ('testament', 1), ('paucity', 1), ('circumstance', 1), ('vie', 1), ('influence', 1), ('surprising', 1), ('president', 1), ('elect', 1), ('willingness', 1), ('rekindle', 1), ('limit', 1), ('military', 1), ('activities', 1), ('donetsk', 1), ('republic', 1), ('closer', 1), ('ties', 1), ('vladimir', 1), ('commentary', 1), ('abounded', 1), ('shortly', 1), ('began', 1), ('declared', 1), ('implacable', 1), ('allegiance', 1), ('opposing', 1), ('sides', 1), ('believed', 1), ('rise', 1), ('intermediary', 1), ('unique', 1), ('bounties', 1), ('doubt', 1), ('seek', 1), ('european', 1), ('integration', 1), ('definitive', 1), ('blow', 1), ('eurasian', 1), ('january', 1), ('surely', 1), ('primary', 1), ('simply', 1), ('achieve', 1), ('leaning', 1), ('electorate', 1), ('countenance', 1), ('rebalance', 1), ('exclusive', 1), ('alliance', 1), ('threaten', 1), ('recovery', 1), ('agenda', 1), ('underpinning', 1), ('presidency', 1), ('warned', 1), ('major', 1), ('reforms', 1), ('ukrainian', 1), ('potential', 1), ('unemployment', 1), ('nightmare', 1), ('ukrainians', 1), ('traditional', 1), ('energy', 1), ('subsidies', 1), ('period', 1), ('austerity', 1), ('leave', 1), ('relying', 1), ('irony', 1), ('bloodshed', 1), ('east', 1), ('sworn', 1), ('eliminate', 1), ('insurgency', 1), ('months', 1), ('hours', 1), ('long', 1), ('foreseen', 1), ('concession', 1), ('autonomy', 1), ('defuse', 1), ('situation', 1), ('victory', 1), ('russians', 1), ('alike', 1), ('recognises', 1), ('evident', 1), ('stated', 1), ('readiness', 1), ('dialogue', 1), ('denounced', 1), ('illegitimate', 1), ('junta', 1), ('decry', 1), ('surrender', 1), ('evidently', 1), ('nasty', 1), ('problems', 1), ('aware', 1), ('wage', 1), ('strategically', 1), ('lukewarm', 1), ('eager', 1), ('responsibility', 1), ('moribund', 1), ('weight', 1), ('restructuring', 1), ('hanging', 1), ('heavily', 1), ('coupled', 1), ('gas', 1), ('cut', 1), ('nascent', 1), ('appealing', 1)]";
			String s2 = "[('ukraine', 5), ('russian', 4), ('international', 4), ('putin', 4), ('nato', 3), ('moderate', 2), ('stephen', 2), ('walt', 2), ('favour', 2), ('ukrainian', 2), ('situation', 2), ('crimea', 2), ('russia', 2), ('response', 2), ('politics', 2), ('predictions', 1), ('future', 1), ('invasion', 1), ('abound', 1), ('expect', 1), ('bloodshed', 1), ('predict', 1), ('forthcoming', 1), ('apocalypse', 1), ('exclamations', 1), ('voices', 1), ('medhi', 1), ('hassan', 1), ('represent', 1), ('inconspicuous', 1), ('minority', 1), ('forgive', 1), ('generalisation', 1), ('events', 1), ('ilk', 1), ('horrendously', 1), ('overblown', 1), ('conclusions', 1), ('remembered', 1), ('wonks', 1), ('victims', 1), ('surely', 1), ('shots', 1), ('fired', 1), ('expectations', 1), ('great', 1), ('majority', 1), ('prognoses', 1), ('simplify', 1), ('notice', 1), ('aims', 1), ('fundamentally', 1), ('avoidance', 1), ('conflict', 1), ('note', 1), ('military', 1), ('installations', 1), ('occupied', 1), ('shelled', 1), ('traditional', 1), ('practice', 1), ('optimal', 1), ('successful', 1), ('referendum', 1), ('demanded', 1), ('february', 1), ('auspices', 1), ('occupation', 1), ('transferral', 1), ('sovereign', 1), ('status', 1), ('akin', 1), ('abkhazia', 1), ('south', 1), ('ossetia', 1), ('breakaway', 1), ('regions', 1), ('georgia', 1), ('recognised', 1), ('gradual', 1), ('membership', 1), ('federation', 1), ('stands', 1), ('potential', 1), ('nascent', 1), ('administration', 1), ('likelihood', 1), ('attacking', 1), ('forces', 1), ('slim', 1), ('steadfast', 1), ('assurance', 1), ('western', 1), ('poland', 1), ('lithuania', 1), ('soviet', 1), ('called', 1), ('emergency', 1), ('meeting', 1), ('claiming', 1), ('basis', 1), ('security', 1), ('interests', 1), ('threatened', 1), ('strong', 1), ('considerable', 1), ('divergence', 1), ('indefatigable', 1), ('mainstay', 1), ('limp', 1), ('responses', 1), ('tough', 1), ('talks', 1), ('avoided', 1), ('cliché', 1), ('testament', 1), ('aptitude', 1), ('machiavellian', 1), ('commentator', 1), ('wrote', 1), ('reminding', 1), ('work', 1), ('structure', 1), ('norms', 1), ('territorial', 1), ('land', 1), ('grabs', 1), ('political', 1), ('faux', 1), ('delivered', 1), ('crisis', 1), ('reap', 1), ('benefits', 1), ('painting', 1), ('impotent', 1), ('dressed', 1), ('kosovo', 1), ('reverse', 1), ('unilateral', 1), ('partition', 1), ('requested', 1), ('populace', 1), ('writes', 1), ('classic', 1), ('tradeoff', 1), ('stronger', 1), ('cares', 1), ('power', 1), ('trumps', 1), ('image', 1), ('courtesy', 1), ('taras', 1), ('gren', 1), ('wikimedia', 1)]";

			String new_str1 = s1.replace("),", "-").replace(",", "_").replace("(", "").replace("-", ",")
					.replace(" ", "").replace(")", "").replace("\'", "").replace("[", "").replace("]", "");
			String new_str2 = s2.replace("),", "-").replace(",", "_").replace("(", "").replace("-", ",")
					.replace(" ", "").replace(")", "").replace("\'", "").replace("[", "").replace("]", "");

			ArrayList<String> list = new ArrayList<String>();
			list.add(new_str1);
			list.add(new_str2);

			for (int i = 0; i < list.size(); i++) {
				buffer.append(list.get(i) + ",");
			}
//			buffer.append(new_str1);
//			buffer.append(",");
//			buffer.append(new_str2);
//			buffer.append(",");
			String finalbuffer = "[" + buffer + "]";

			System.out.println(finalbuffer);
			JSONArray ja = new JSONArray(finalbuffer);
			System.out.println(ja);

//			getTopTermsFromBlogIds(ids, from, to, "100");
//			System.out.println(getTopTermsFromBlogger("\"George McGinn\",\"Southfront analytic team\"", "2000-01-01", "2020-01-01" , "100"));
//			getPosts(ids, from, to, "__ONLY__TERMS__BLOGSITE_IDS__", "blogpost_terms");
			String url = " http://144.167.35.138:5000/";
			JSONObject js = new JSONObject("{\r\n" + "	\"tracker_id\":7,\r\n" + "	\"type\":\"create\"\r\n" + "}");

			System.out.println(_getResult(url, js));
//			getBloggersMentioned("20,16");
			// String bloggers = "George McGinn";
//			String from = "2000-01-01";
//			String to = "2020-01-01";
			// System.out.println(getTopTermsBlogger("George McGinn", "2000-01-01",
			// "2020-01-01" , "1"));
//			List<JSONObject> postDataAll1 = getPosts(bloggers, from, to, "__ONLY__TERMS__BLOGGERS", "blogpost_terms");
//			//System.out.println("select * from blogpost_terms where blogger = \"" + bloggers + "\" and date > \"" + from + "\" and date < \"" +  to +"\"");
//			List postDataAll = DbConnection.queryJSON("select * from blogpost_terms where blogger = \"" + bloggers + "\" and date > \"" + from + "\" and date < \"" +  to +"\"");
//			
//			System.out.println("first---"+postDataAll1.get(0));
//			String indx = postDataAll1.get(0).toString();
//			JSONObject j1 = new JSONObject(indx);
//			String ids1 = j1.get("_source").toString();
//			JSONObject j2 = new JSONObject(ids1);
//			String post_ids = j2.get("blogpost_id").toString();
//			String title = j2.get("title").toString();
//			String post = j2.get("post").toString();
//			System.out.println("first id-- "+post_ids);
//			
//			
//			//String terms = j2.get(field).toString();
//			
//			
//			
//			System.out.println("second---"+postDataAll.get(0));
////			 indx = postDataAll.get(0).toString();
//			 JSONObject source = new JSONObject(postDataAll.get(0).toString());
//			 System.out.println("source id-- "+source.get("_source"));
			// System.out.println(Arrays.asList(ssssss.split("-")).get(0));

			// SparkConf conf = new
			// SparkConf().setMaster("spark://144.167.35.50:4042").setAppName("Example").set("spark.ui.port","4042");;
//			conf.set("spark.driver.memory", "64g");
			// JavaSparkContext sc = new JavaSparkContext(conf);
			// sc.stop();
//			String test = "";
//			String tracker_id = "238";
//			// get postids from each cluster in tracker and save in JSONObject
//			ArrayList result = _getClusters(tracker_id);
//
//			JSONObject res = new JSONObject(result.get(0).toString());
//			JSONObject source = new JSONObject(res.get("_source").toString());
//
//			// ArrayList R2 = (ArrayList)result.get(0);
//			// for()
//			// System.out.println(source.get("cluster_3"));
////			HashMap<Pair<String, String>, JSONArray> clusterResult = new HashMap<Pair<String, String>, JSONArray>();
//			// JSONObject key_val = new JSONObject();
////			Pair<String, String> key_val = new Pair<String, String>(null, null);
//
////			HashMap<String, String> key_val_posts = new HashMap<String, String>();
//
//			String post_ids = null;
////			List<String> list = Arrays.asList("a","b","c");
//
////	        System.out.println(result);
//			int count_ = 0;
//			for (int i = 1; i < 11; i++) {
//				String cluster_ = "cluster_" + String.valueOf(i);
//				post_ids = source.get(cluster_).toString();
//				count_ = (count_ + (post_ids.split(",").length));
//
//				test = test.concat(post_ids + ",");
//
//			}
//
////			System.out.println(test.substring(test.length() - 1));
//			System.out.println("count ---" + count_);
//			System.out.println("test length---" + test.split(",").length);

			Instant end = Instant.now();
			Duration timeElapsed = Duration.between(start, end);
			System.out.println("Time taken: " + timeElapsed.getSeconds() + " seconds");

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Clustering() {
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
		HttpSession session = request.getSession();
		Object action = (null == request.getParameter("action")) ? "" : request.getParameter("action");
		Object cluster = (null == request.getParameter("cluster")) ? "" : request.getParameter("cluster");
		Object cluster_number = (null == request.getParameter("cluster")) ? "" : request.getParameter("cluster_number");
		Object tid = (null == request.getParameter("tid")) ? "" : request.getParameter("tid");

		Object result = (null == session.getAttribute(tid.toString() + "cluster_result")) ? ""
				: session.getAttribute(tid.toString() + "cluster_result");
		Object result_key_val = (null == session.getAttribute(tid.toString() + "cluster_result_key_val")) ? ""
				: session.getAttribute(tid.toString() + "cluster_result_key_val");

		Object distances = (null == session.getAttribute(tid.toString() + "cluster_distances")) ? ""
				: session.getAttribute(tid.toString() + "cluster_distances");

		HashMap<String, String> key_val_posts = (HashMap<String, String>) result_key_val;
		HashMap<Pair<String, String>, ArrayList<JSONObject>> clusterResult = (HashMap<Pair<String, String>, ArrayList<JSONObject>>) result;
//		try (FileWriter file = new FileWriter("C:\\Users\\bt_admin\\file2.json")) {
//			
//			file.write(key_val_posts.toString());
//			System.out.println("Successfully Copied JSON Object to File...");
//
//		}
		Pair<String, String> key_val = new Pair<String, String>(null, null);
		String cluster_ = cluster.toString();
		String post_ids = key_val_posts.get(cluster_);

		key_val = new Pair<String, String>(cluster_, post_ids);
		// System.out.println("seun o s here" + cluster_ +post_ids );

		Object total = (null == session.getAttribute(tid.toString() + "clusters_total")) ? ""
				: session.getAttribute(tid.toString() + "clusters_total");

		Object topterms_object = (null == session.getAttribute(tid.toString() + "cluster_terms")) ? ""
				: session.getAttribute(tid.toString() + "cluster_terms");

//		topterms = (HashMap<String, String>()) topterms.get;
//		HashMap<String, String> topterm = new HashMap<String, String>();
		HashMap<String, String> topterms = (HashMap<String, String>) topterms_object;
		// System.out.println("topterms_object --"+topterms_object);

		String blogdistribution = null;
		String bloggersMentioned = null;
		String topPostingLocation = null;
		ArrayList<JSONObject> postData = new ArrayList<JSONObject>();

		try {
			blogdistribution = this.getBlogDistribution(post_ids, (double) Integer.parseInt(total.toString()));
			bloggersMentioned = this.getBloggersMentioned(post_ids);
			topPostingLocation = this.getTopPostingLocation(post_ids);
			postData = clusterResult.get(key_val);
			// System.out.println("postData--"+postData);
		} catch (NumberFormatException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
//			 TODO Auto-generated catch block
			e.printStackTrace();
		}

		PrintWriter out = response.getWriter();
		// System.out.println(action.toString() +"----"+blogdistribution);

		if (action.toString().equals("loadblogdistribution")) {
			out.write(blogdistribution);
		} else if (action.toString().equals("loadpostmentioned")) {
			out.write(this.totalposts.replace(".0", ""));
		} else if (action.toString().equals("loadbloggersmentioned")) {
			out.write(bloggersMentioned);
		} else if (action.toString().equals("loadpostinglocation")) {
			out.write(topPostingLocation);
		} else if (action.toString().equals("loadtitletable")) {
			// Object title =
			// postData.getJSONObject(j).getJSONObject("_source").get("title");
			JSONObject post_distances_all = new JSONObject();
			post_distances_all.put("distances", new JSONObject(distances.toString()));
			post_distances_all.put("post_data", new JSONArray(postData.toString()));
			out.write(post_distances_all.toString());
		} else if (action.toString().equals("loadkeywords")) {
			// System.out.println("action" + action + "terms--" + topterms.get(cluster_));
			out.write(topterms.get(cluster_).toString());
		} else if (action.toString().equals("fetch_graph")) {

			Blogposts posts = new Blogposts();
			ArrayList value = new ArrayList();
			try {
				value = posts._getBlogPostDetails(null, null, null, post_ids, 0);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			HashMap<String, String> post_title = new HashMap<String, String>();
			for (int i = 0; i < value.size(); i++) {
				JSONObject data = new JSONObject(value.get(i).toString());
				Object title = data.getJSONObject("_source").get("title");
				Object blogpost_id = data.getJSONObject("_source").get("blogpost_id");
				post_title.put(blogpost_id.toString(), title.toString());
			}

			JSONArray nodes = new JSONArray();
			JSONArray links = new JSONArray();

			JSONObject center = new JSONObject();
			center.put("id", "center");
			center.put("group", 0);
			center.put("label", "center".toUpperCase());
			center.put("level", 1);
			nodes.put(center);

			String[] post_split = post_ids.split(",");
			// for(int i = 0; i < post_split.length; i++){
			for (int i = 0; i < 1000; i++) {

				if (i < post_split.length) {
					String p = post_split[i];
					JSONObject data = new JSONObject();

					data.put("id", p);
					data.put("group", cluster);
					data.put("label", cluster.toString().toUpperCase());
					data.put("level", 1);
					data.put("title", post_title.get(p));

					nodes.put(data);
				}
			}

			JSONObject d = new JSONObject(distances.toString());
			// for(int i = 0; i < post_split.length; i++){
			for (int i = 0; i < 1000; i++) {
				if (i < post_split.length) {
					String p = post_split[i];
					JSONObject data = new JSONObject();

					data.put("target", "center");
					data.put("source", p);
					data.put("strength", 50 - Double.parseDouble(d.get(p).toString()));

					links.put(data);
				}
			}

			JSONObject final_data = new JSONObject();
			final_data.put("nodes", nodes);
			final_data.put("links", links);
			JSONObject final_result = new JSONObject();
			final_result.put("final_data", final_data);
			final_result.put("cluster_id", cluster);
			final_result.put("cluster_number", cluster_number.toString());

			out.write(final_result.toString());
		}
//		if(Action)
	}

}
=======
package util;

import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.time.Instant;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;

import com.sun.corba.se.spi.orbutil.fsm.Action;

import authentication.DbConnection;
import javafx.util.Pair;
import scala.Tuple2;

import org.apache.lucene.search.MultiTermQuery.TopTermsBlendedFreqScoringRewrite;
import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;

import org.json.JSONArray;
import org.json.JSONObject;
//import org.apache.spark.mllib.clustering.KMeans;
//import org.apache.spark.mllib.clustering.KMeansModel;
//import org.apache.spark.mllib.linalg.Vector;
//import org.apache.spark.mllib.linalg.Vectors;

//import java.io.IOException;
//import java.net.URI;
//import java.net.http.HttpClient;
//import java.net.http.HttpRequest;
//import java.net.http.HttpResponse;

/**
 * Servlet implementation class Clustering
 */
@WebServlet("/CLUSTERING")
public class Clustering extends HttpServlet {

	static Terms term = new Terms();

//	public static void _clusteringTest(String pathin, String pathout) throws Exception {
//
//		SparkConf conf = new SparkConf().setMaster("local[4]").setAppName("Example");
//		JavaSparkContext jsc = new JavaSparkContext(conf);
//
//		// String path = "data/mllib/kmeans_data.txt";
//		JavaRDD<String> data = jsc.textFile(pathin);
//		JavaRDD<Vector> parsedData = data.map(s -> {
//			String[] sarray = s.split(" ");
//			double[] values = new double[sarray.length];
//			for (int i = 0; i < sarray.length; i++) {
//				values[i] = Double.parseDouble(sarray[i]);
//			}
//			return Vectors.dense(values);
//		});
//		parsedData.cache();
//
//		// Cluster the data into two classes using KMeans
//		int numClusters = 2;
//		int numIterations = 20;
//		KMeansModel clusters = KMeans.train(parsedData.rdd(), numClusters, numIterations);
//
//		System.out.println("Cluster centers:");
//		for (Vector center : clusters.clusterCenters()) {
//			System.out.println(" " + center);
//		}
//		double cost = clusters.computeCost(parsedData.rdd());
//		System.out.println("Cost: " + cost);
//
//		// Evaluate clustering by computing Within Set Sum of Squared Errors
//		double WSSSE = clusters.computeCost(parsedData.rdd());
//		System.out.println("Within Set Sum of Squared Errors = " + WSSSE);
//
//		// Save and load model
//		// "target/org/apache/spark/JavaKMeansExample/KMeansModel"
//		clusters.save(jsc.sc(), pathout);
//		KMeansModel sameModel = KMeansModel.load(jsc.sc(), pathout);
//		jsc.stop();
//
//	}
	public static String _getResult(String url, JSONObject jsonObj) throws Exception {
		ArrayList<String> list = new ArrayList<String>();
		JSONObject myResponse = new JSONObject();
		String out = null;
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

			myResponse = new JSONObject(response.toString());
			out = myResponse.toString();
			// System.out.println("RESPONSE ==> " + myResponse);

		} catch (Exception ex) {
		}
		// System.out.println("This is the list for -----" + url + "---" + list);
		return out;

	}

	public JSONObject getResult2(String uu, String jsonObj) throws Exception {
		HttpURLConnection conn = null;
//		 os = null;
		JSONObject myResponse = new JSONObject();
		try {
//			URL url = new URL("http://127.0.0.1:5000/add/"); // important to add the trailing slash after add
			URL url = new URL(uu); // important to add the trailing slash after add
			String[] inputData = { jsonObj };
//			HttpURLConnection con = (HttpURLConnection) url.openConnection();

			for (String input : inputData) {
				byte[] postData = input.getBytes(StandardCharsets.UTF_8);
				conn = (HttpURLConnection) url.openConnection();
				conn.setDoOutput(true);
				conn.setRequestMethod("POST");
				conn.setRequestProperty("Content-Type", "application/json");
				conn.setRequestProperty("charset", "utf-8");
				conn.setRequestProperty("Content-Length", Integer.toString(input.length()));
				DataOutputStream os = new DataOutputStream(conn.getOutputStream());
				os.write(postData);
				os.flush();

				if (conn.getResponseCode() != 200) {
					throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());
				}

				BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));

				String output;
				System.out.println("Output from Server .... \n");
				StringBuffer response = new StringBuffer();
				while ((output = br.readLine()) != null) {
//					System.out.println(output);
					response.append(output);
				}
				myResponse = new JSONObject(response.toString());
				conn.disconnect();

			}
		} catch (MalformedURLException e) {
			e.printStackTrace();
			System.out.println(e);
		} catch (IOException e) {
			e.printStackTrace();
			System.out.println(3);
		} finally {
			if (conn != null) {
				conn.disconnect();
			}
		}
		return myResponse;
	}

	public JSONObject _getResult3(String url, JSONObject jsonObj) throws Exception {
		JSONObject result = new JSONObject();
		String POST_PARAMS = jsonObj.toString();
//	    final String POST_PARAMS = "{\n" + "\"userId\": 101,\r\n" +
//
//        "    \"id\": 101,\r\n" +
//
//        "    \"title\": \"Test Title\",\r\n" +
//
//        "    \"body\": \"Test Body\"" + "\n}";

//    System.out.println(POST_PARAMS);

		URL obj = new URL("https://jsonplaceholder.typicode.com/posts");

		HttpURLConnection postConnection = (HttpURLConnection) obj.openConnection();

		postConnection.setRequestMethod("POST");

		postConnection.setRequestProperty("userId", "a1bcdefgh");

		postConnection.setRequestProperty("Content-Type", "application/json");

		postConnection.setDoOutput(true);

		OutputStream os = postConnection.getOutputStream();

		os.write(POST_PARAMS.getBytes());

		os.flush();

		os.close();

		int responseCode = postConnection.getResponseCode();

		System.out.println("POST Response Code :  " + responseCode);

		System.out.println("POST Response Message : " + postConnection.getResponseMessage());

		if (responseCode == HttpURLConnection.HTTP_CREATED) { // success

			BufferedReader in = new BufferedReader(new InputStreamReader(

					postConnection.getInputStream()));

			String inputLine;

			StringBuffer response = new StringBuffer();

			while ((inputLine = in.readLine()) != null) {

				response.append(inputLine);

			}
			in.close();

			// print result
			result = new JSONObject(response.toString());
			// System.out.println("THISI I SRESULT --" + result);
			postConnection.disconnect();

//        System.out.println(response.toString());

		} else {

			System.out.println("POST NOT WORKED");

		}
		return result;
	}

	public static int getShardSize(JSONObject query, String index) {
		JSONObject myResponse = new JSONObject();
		int result = 0;
		try {
			myResponse = term._makeElasticRequest(query, "GET", "/" + index + "/_search_shards/");
//			System.out.println("/" + index + "/_search_shards");
//			System.out.println(myResponse);
//			if (myResponse.length() > 0) {
			if (!(myResponse.getJSONObject("nodes") == null)) {
//				result = myResponse.getJSONArray("shards").getJSONArray(0).length();
				result = myResponse.getJSONObject("nodes").length();
			}
//			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}

	public String getTotal(String ids, String from, String to) {
		JSONObject query = new JSONObject();
		String result = null;
		String total = null;
		query = new JSONObject("{\r\n" + "    \"query\": {\r\n" + "        \"bool\": {\r\n"
				+ "            \"must\": [\r\n" + "                {\r\n" + "                    \"terms\": {\r\n"
				+ "                        \"blogsite_id\": [" + ids + "],\r\n"
				+ "                        \"boost\": 1\r\n" + "                    }\r\n" + "                },\r\n"
				+ "                {\r\n" + "                    \"range\": {\r\n"
				+ "                        \"date\": {\r\n" + "                            \"from\": \"" + from
				+ "\",\r\n" + "                            \"to\": \"" + to + "\",\r\n"
				+ "                            \"include_lower\": true,\r\n"
				+ "                            \"include_upper\": true,\r\n"
				+ "                            \"boost\": 1\r\n" + "                        }\r\n"
				+ "                    }\r\n" + "                }\r\n" + "            ],\r\n"
				+ "            \"adjust_pure_negative\": true,\r\n" + "            \"boost\": 1\r\n" + "        }\r\n"
				+ "    }\r\n" + "}");
		try {
			total = term._count(query, "/blogposts/_count?");
			result = total;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}

	public static ArrayList<JSONObject> _buildSlicedScrollQuery(String ids, String from, String to, String type,
			String index) throws Exception {
		JSONObject query = new JSONObject();

		if (type.contentEquals("__ONLY__TERMS__BLOGSITE_IDS__")) {
			query = new JSONObject("{\r\n" + "    \"query\": {\r\n" + "        \"bool\": {\r\n"
					+ "            \"must\": [\r\n" + "                {\r\n" + "                    \"terms\": {\r\n"
					+ "                        \"blogsiteid\": [" + ids + "],\r\n"
					+ "                        \"boost\": 1\r\n" + "                    }\r\n"
					+ "                },\r\n" + "                {\r\n" + "                    \"range\": {\r\n"
					+ "                        \"date\": {\r\n" + "                            \"from\": \"" + from
					+ "\",\r\n" + "                            \"to\": \"" + to + "\",\r\n"
					+ "                            \"include_lower\": true,\r\n"
					+ "                            \"include_upper\": true,\r\n"
					+ "                            \"boost\": 1\r\n" + "                        }\r\n"
					+ "                    }\r\n" + "                }\r\n" + "            ],\r\n"
					+ "            \"adjust_pure_negative\": true,\r\n" + "            \"boost\": 1\r\n"
					+ "        }\r\n" + "    }\r\n" + "}");
		} else if (type.contentEquals("__ONLY__POST__ID__")) {
			query = new JSONObject("{\r\n" + "   \r\n" + "    \"query\": {\r\n" + "        \"terms\": {\r\n"
					+ "            \"blogpost_id\": [" + ids + "],\r\n" + "            \"boost\": 1.0\r\n"
					+ "        }\r\n" + "    }\r\n" + "    \r\n" + "}");
		} else if (type.contentEquals("__ONLY__TERMS__")) {
			query = new JSONObject("{\r\n" + "   \r\n" + "    \"query\": {\r\n" + "        \"terms\": {\r\n"
					+ "            \"blogpost_id\": [" + ids + "],\r\n" + "            \"boost\": 1.0\r\n"
					+ "        }\r\n" + "    }\r\n" + "    \r\n" + "}");
		} else if (type.contentEquals("__ONLY__TERMS__BLOGGERS")) {
			query = new JSONObject("{\r\n" + "    \"query\": {\r\n" + "        \"bool\": {\r\n"
					+ "            \"must\": [\r\n" + "                {\r\n" + "                    \"terms\": {\r\n"
					+ "                        \"blogger.keyword\": [" + ids + "],\r\n"
					+ "                        \"boost\": 1\r\n" + "                    }\r\n"
					+ "                },\r\n" + "                {\r\n" + "                    \"range\": {\r\n"
					+ "                        \"date\": {\r\n" + "                            \"from\": \"" + from
					+ "\",\r\n" + "                            \"to\": \"" + to + "\",\r\n"
					+ "                            \"include_lower\": true,\r\n"
					+ "                            \"include_upper\": true,\r\n"
					+ "                            \"boost\": 1\r\n" + "                        }\r\n"
					+ "                    }\r\n" + "                }\r\n" + "            ],\r\n"
					+ "            \"adjust_pure_negative\": true,\r\n" + "            \"boost\": 1\r\n"
					+ "        }\r\n" + "    }\r\n" + "}");
		} else if (type.contains("__TERMS__KEYWORD__")) {
			String term = type.substring(type.lastIndexOf("__") + 2);
			System.out.println("term--" + term);
			query = new JSONObject("{\r\n" + "   \r\n" + "    \"query\": {\r\n" + "        \"bool\": {\r\n"
					+ "            \"must\": [\r\n" + "                {\r\n" + "                    \"terms\": {\r\n"
					+ "                        \"post\": [\r\n" + "                            " + term + "\r\n"
					+ "                        ]\r\n" + "                    }\r\n" + "                },\r\n"
					+ "                {\r\n" + "                    \"terms\": {\r\n"
					+ "                        \"blogsite_id\": [" + ids + "],\r\n"
					+ "                        \"boost\": 1\r\n" + "                    }\r\n"
					+ "                },\r\n" + "                {\r\n" + "                    \"range\": {\r\n"
					+ "                        \"date\": {\r\n" + "                            \"from\": \"" + from
					+ "\",\r\n" + "                            \"to\": \"" + to + "\",\r\n"
					+ "                            \"include_lower\": true,\r\n"
					+ "                            \"include_upper\": true,\r\n"
					+ "                            \"boost\": 1\r\n" + "                        }\r\n"
					+ "                    }\r\n" + "                }\r\n" + "            ]\r\n" + "        }\r\n"
					+ "    }\r\n" + "}");
		}

		System.out.println("buildquery--" + query);
		ArrayList<JSONObject> result = new ArrayList<JSONObject>();
		String total = term._count(query, "/" + index + "/_count?");
		// System.out.println(query);
		int shardCount = getShardSize(query, index);
//		System.out.println(shardCount);
//		System.out.println("total -->"+total);
		int temp = Integer.parseInt(total) / shardCount + 500;
//		int id = Math.round(Integer.parseInt(total) / size);
		// int size = 0;

//		  if (temp > 1000) { size = temp + 1000; } else { size = 1500; }

//		int 
		// size = Math.round(Integer.parseInt(total) / shardCount);
//		size = 1000;
//		size = (size > 10000) ? 10000 : size;
		// size = (size == 0) ? 0 : size;
		// size = 10000;
		// System.out.println("size -->" + size);

//		int max = (id + 2 > shardCount) ? shardCount : (id + 2);

		int max = 132;
//		System.out.println(String.valueOf(0));	

		System.out.println("max -->" + String.valueOf(max));
		for (int i = 0; i < max; i++) {
			String appendee = query.toString();
			String newquery = "{\r\n" + "\"size\":" + 1000 + "," + appendee.substring(1, appendee.length() - 1) + ","
					+ "\"slice\": {\r\n" + "    	      \"id\": " + String.valueOf(i) + ",\r\n" + "        \"max\": "
					+ String.valueOf(max) + "\r\n" + "    }}";

//			 System.out.println(newquery);
			result.add(new JSONObject(newquery));
		}
		return result;
	}

	public static List<JSONObject> getPosts(String ids, String from, String to, String type, String index)
			throws Exception {
		List<JSONObject> jsonArray;
		HashMap<String, String> result = new HashMap<String, String>();

		List<Tuple2<String, Integer>> datatuple = Collections
				.synchronizedList(new ArrayList<Tuple2<String, Integer>>());

		ConcurrentHashMap<String, Integer> d = new ConcurrentHashMap<String, Integer>();

		int shardCount = getShardSize(new JSONObject(), index);
		System.out.println("shard c 2==>" + shardCount);
		List<JSONObject> jsonList = Collections.synchronizedList(new ArrayList<JSONObject>());
		ConcurrentHashMap<String, ConcurrentHashMap<String, String>> datatuple3 = new ConcurrentHashMap<String, ConcurrentHashMap<String, String>>();
		ExecutorService executorServiceBlogSiteIds = Executors.newFixedThreadPool(shardCount);
		int start_test = 0;
		if (type.contentEquals("__ONLY__POST__ID__")) {
			jsonArray = new ArrayList<JSONObject>();
			for (JSONObject q : _buildSlicedScrollQuery(ids, from, to, type, index)) {
				// System.out.println(q);
				int start1 = 0;
				int end = 0;
				RunnableUtil esR2 = new RunnableUtil(q, jsonArray, start1, end, datatuple, d, "elastic", index, "post",
						jsonList, datatuple3);
				executorServiceBlogSiteIds.execute(esR2);
			}
		} else if (type.contentEquals("__ONLY__TERMS__")) {
//			jsonArray = new JSONArray();
			jsonArray = new ArrayList<JSONObject>();
			for (JSONObject q : _buildSlicedScrollQuery(ids, from, to, type, index)) {
//				 System.out.println(q);
				int start1 = 0;
				int end = 0;
				RunnableUtil esR2 = new RunnableUtil(q, jsonArray, start1, end, datatuple, d, "elastic", index, "terms",
						jsonList, datatuple3);
				executorServiceBlogSiteIds.execute(esR2);
			}
		} else if (type.contentEquals("__ONLY__TERMS__BLOGSITE_IDS__")) {
//			jsonArray = new JSONArray();
			jsonArray = new ArrayList<JSONObject>();
			for (JSONObject q : _buildSlicedScrollQuery(ids, from, to, type, index)) {
//				 System.out.println(q);
				int start1 = 0;
				int end = 0;
				RunnableUtil esR2 = new RunnableUtil(q, jsonArray, start_test, end, datatuple, d, "elastic", index,
						"terms", jsonList, datatuple3);
				executorServiceBlogSiteIds.execute(esR2);
			}
		} else if (type.contentEquals("__ONLY__TERMS__BLOGGERS")) {
//			jsonArray = new JSONArray();
			jsonArray = new ArrayList<JSONObject>();
			for (JSONObject q : _buildSlicedScrollQuery(ids, from, to, type, index)) {
//				 System.out.println(q);
				int start1 = 0;
				int end = 0;
//				RunnableUtil esR2 = new RunnableUtil(q, jsonArray, start1, end, datatuple, d, "elastic", index,
//						"terms");
				RunnableUtil esR2 = new RunnableUtil(q, jsonArray, start1, end, datatuple, d, "elastic", index, "terms",
						jsonList, datatuple3);
//				executorServiceBlogSiteIds.execute(esR2);
				executorServiceBlogSiteIds.execute(esR2);
			}
		} else if (type.contains("__TERMS__KEYWORD__")) {
//			jsonArray = new JSONArray();
			jsonArray = new ArrayList<JSONObject>();
			for (JSONObject q : _buildSlicedScrollQuery(ids, from, to, type, index)) {
//				 System.out.println(q);
				int start1 = 0;
				int end = 0;

				// RunnableUtil esR2 = new RunnableUtil(q, jsonArray, start_test, end,
				// datatuple, d, "elastic", index, "terms",jsonList);
				RunnableUtil esR2 = new RunnableUtil(q, jsonArray, start1, end, datatuple, d, "elastic", index, "terms",
						jsonList, datatuple3);
//				executorServiceBlogSiteIds.execute(esR2);
				executorServiceBlogSiteIds.execute(esR2);
			}
		}

		executorServiceBlogSiteIds.shutdown();
		while (!executorServiceBlogSiteIds.isTerminated()) {
		}
		System.out.println("list length from thread--" + jsonList.size());
		System.out.println("tuple3 --" + datatuple3.size());
		// System.out.println("length from thread--" + jsonArray.length());
//		try (FileWriter file = new FileWriter("C:\\Users\\bt_admin\\file2.json")) {
//			
//							file.write(jsonArray.toString());
//							System.out.println("Successfully Copied JSON Object to File...");
//			
//						}
		return jsonList;
	}

	public JSONArray getPostIdsFromApiCluster(String clusterNum, JSONObject result) throws Exception {
		JSONArray result_ = new JSONArray();
		String index = String.valueOf(Integer.parseInt(clusterNum) - 1);

		JSONArray posts_ids = result.getJSONArray(index).getJSONObject(0).getJSONObject("cluster_" + (clusterNum))
				.getJSONArray("post_ids");

		result_ = posts_ids;
		return result_;
	}

	public static String getBloggersMentioned(String postIds) throws Exception {
		String result = null;
		JSONObject query = new JSONObject("{\r\n" + "    \"size\": 0,\r\n" + "    \"query\": {\r\n"
				+ "        \"terms\": {\r\n" + "            \"blogpost_id\": [" + postIds + "],\r\n"
				+ "            \"boost\": 1.0\r\n" + "        }\r\n" + "    },\r\n" + "    \"_source\": false,\r\n"
				+ "    \"stored_fields\": \"_none_\",\r\n" + "    \"aggregations\": {\r\n"
				+ "        \"groupby\": {\r\n" + "            \"composite\": {\r\n"
				+ "                \"size\": 10000,\r\n" + "                \"sources\": [\r\n"
				+ "                    {\r\n" + "                        \"442\": {\r\n"
				+ "                            \"terms\": {\r\n"
				+ "                                \"field\": \"blogger.keyword\",\r\n"
				+ "                                \"missing_bucket\": true,\r\n"
				+ "                                \"order\": \"asc\"\r\n" + "                            }\r\n"
				+ "                        }\r\n" + "                    }\r\n" + "                ]\r\n"
				+ "            }\r\n" + "        }\r\n" + "    }\r\n" + "}");
//System.out.println("getBloggersMentioned --" + query);
		JSONObject myResponse = term._makeElasticRequest(query, "POST", "/blogposts/_search");
		if (null != myResponse.get("hits")) {
			Object aggregations = myResponse.getJSONObject("aggregations").getJSONObject("groupby")
					.getJSONArray("buckets").length();
			result = aggregations.toString();
		}
		return result;
	}

	public String getTopPostingLocation(String postIds) throws Exception {
//		String result = null;
//		JSONObject query = new JSONObject("{\r\n" + "    \"size\": 0,\r\n" + "    \"query\": {\r\n"
//				+ "        \"terms\": {\r\n" + "            \"blogpost_id\": [" + postIds + "],\r\n"
//				+ "            \"boost\": 1.0\r\n" + "        }\r\n" + "    },\r\n" + "    \"_source\": false,\r\n"
//				+ "    \"stored_fields\": \"_none_\",\r\n" + "    \"aggregations\": {\r\n"
//				+ "        \"groupby\": {\r\n" + "            \"composite\": {\r\n"
//				+ "                \"size\": 10000,\r\n" + "                \"sources\": [\r\n"
//				+ "                    {\r\n" + "                        \"dat\": {\r\n"
//				+ "                            \"terms\": {\r\n"
//				+ "                                \"field\": \"location.keyword\",\r\n"
//				+ "                                \"missing_bucket\": true,\r\n"
//				+ "                                \"order\": \"desc\"\r\n" + "                            }\r\n"
//				+ "                        }\r\n" + "                    }\r\n" + "                ]\r\n"
//				+ "            },\r\n" + "            \"aggregations\": {\r\n" + "                \"dat\": {\r\n"
//				+ "                    \"filter\": {\r\n" + "                        \"exists\": {\r\n"
//				+ "                            \"field\": \"location\",\r\n"
//				+ "                            \"boost\": 1.0\r\n" + "                        }\r\n"
//				+ "                    }\r\n" + "                }\r\n" + "            }\r\n" + "        }\r\n"
//				+ "    }\r\n" + "}");
//		// System.out.println("getTopPostingLocation --" + query);
//		JSONObject myResponse = term._makeElasticRequest(query, "POST", "/blogposts/_search");
//		if (null != myResponse.get("hits")) {
//			Object aggregations = myResponse.getJSONObject("aggregations").getJSONObject("groupby")
//					.getJSONArray("buckets").getJSONObject(0).getJSONObject("key").get("dat");
//			result = aggregations.toString();
//		}
//		return result;

		String result = null;
		JSONObject query = new JSONObject();
		query = new JSONObject("{\r\n" + "    \"size\": 0,\r\n" + "    \"query\": {\r\n" + "        \"bool\": {\r\n"
				+ "            \"must\": [\r\n" + "                {\r\n" + "                    \"terms\": {\r\n"
				+ "                        \"blogpost_id\": [" + postIds + "],\r\n"
				+ "                        \"boost\": 1\r\n" + "                    }\r\n" + "                }\r\n"
				+ "            ]\r\n" + "        }\r\n" + "    },\r\n" + "    \"aggregations\": {\r\n"
				+ "        \"groupby\": {\r\n" + "            \"composite\": {\r\n"
				+ "                \"size\": 1000,\r\n" + "                \"sources\": [\r\n"
				+ "                    {\r\n" + "                        \"dat\": {\r\n"
				+ "                            \"terms\": {\r\n"
				+ "                                \"missing_bucket\": false,\r\n"
				+ "                                \"field\": \"location\",\r\n"
				+ "                                \"order\": \"asc\"\r\n" + "                            }\r\n"
				+ "                        }\r\n" + "                    }\r\n" + "                ]\r\n"
				+ "            }\r\n" + "        }\r\n" + "    }\r\n" + "}");

		JSONObject myResponse = term._makeElasticRequest(query, "POST", "/blogposts/_search/?");
		if (null != myResponse.get("hits")) {
			Object key = null;
			Object value = null;

			String key_result = null;
			String value_result = null;

			Object k = myResponse.getJSONObject("aggregations").getJSONObject("groupby").getJSONArray("buckets");
			int lenght_of_array = new JSONArray(k.toString()).length();
			if (lenght_of_array > 0) {
				int current_max = 0;
				for (int i = 0; i < lenght_of_array; i++) {
					key = ((JSONArray) k).getJSONObject(i).getJSONObject("key").get("dat");
					value = myResponse.getJSONObject("aggregations").getJSONObject("groupby").getJSONArray("buckets")
							.getJSONObject(i).get("doc_count");

					if (Integer.parseInt(value.toString()) >= current_max) {
						current_max = Integer.parseInt(value.toString());
						key_result = key.toString();
						value_result = value.toString();
					}
				}
				result = key_result.toUpperCase();
			} else {
				result = "NO DATA AVAILABLE";
			}

		}
		return result;
	}

	public String totalposts = null;

	public String getBlogDistribution(String postIds, double total) throws Exception {
		String result = null;
		String[] postIdCount = postIds.split(",");
		double count = postIdCount.length;
		this.totalposts = String.valueOf(count);
		System.out.println("This is from count query" + count);

		double res = ((double) count / total) * 100;
		result = String.valueOf(Math.round(res)) + "%";

		return result;
	}

	public ArrayList<String> getPostsByPostIds(String postIds) throws Exception {
//		JSONArray jsonArray = new JSONArray();
		List<JSONObject> jsonArray = new ArrayList<JSONObject>();
//			HashMap<String, String> result = new HashMap<String, String>();
		ArrayList<String> result = new ArrayList<String>();
//			Instant start = Instant.now();
		List<Tuple2<String, Integer>> datatuple = new ArrayList<Tuple2<String, Integer>>();
//		Map<String, Integer> d = new HashMap<String, Integer>();
		ConcurrentHashMap<String, Integer> d = new ConcurrentHashMap<String, Integer>();
//		Map<String, Integer> d = Collections.synchronizedMap(new HashMap<String, Integer>());

		int shardCount = this.getShardSize(new JSONObject(), "blogposts");
		System.out.println("shard c 2==>" + shardCount);

		ExecutorService executorServiceBlogPostIds = Executors.newFixedThreadPool(shardCount + 1);
		for (JSONObject q : this._buildSlicedScrollQuery(postIds, "", "", "__ONLY__POST__ID__", "blogposts")) {
			// System.out.println(q);
			int start1 = 0;
			int end = 0;
			RunnableUtil esR2 = new RunnableUtil(q, jsonArray, start1, end, datatuple, d, "elastic", "blogposts",
					"post");
			executorServiceBlogPostIds.execute(esR2);
		}

		executorServiceBlogPostIds.shutdown();
		while (!executorServiceBlogPostIds.isTerminated()) {
		}

		JSONObject test = new JSONObject();
		for (int i = 0; i < jsonArray.size(); i++) {
//				Object post_id = jsonArray.getJSONObject(i).getJSONObject("_source").get("blogpost_id");
//			jsonArray.get(index)
			JSONObject t = new JSONObject(jsonArray.get(i));
//			Object post = jsonArray.getJSONObject(i).getJSONObject("_source").get("post");
			Object post = t.getJSONObject("_source").get("post");
			result.add(post.toString());
		}

		System.out.println("this is result" + result.size());
		return result;
	}

	public static ArrayList _getClusters(String tid) throws Exception {

		int size = 50;
		DbConnection db = new DbConnection();
		String count = "0";
		ArrayList result = new ArrayList();
		try {
			result = db.queryJSON("SELECT *  FROM clusters WHERE tid = '" + tid + "'");

		} catch (Exception e) {
			return result;
		}

		return result;

	}

	public static ArrayList _getSvd(String postids) throws Exception {

		int size = 50;
		DbConnection db = new DbConnection();
		String count = "0";
		ArrayList result = new ArrayList();
		try {
			result = db.queryJSON("SELECT *  FROM cluster_svd WHERE post_id in ( " + postids + ")");

		} catch (Exception e) {
			return result;
		}

		return result;

	}

	public static JSONObject topTerms(List postDataAll, String limit) {
		JSONObject res = new JSONObject();
		JSONArray output = new JSONArray();

		int a = postDataAll.size();
		int b = 1000;
		int poolsize = ((a / b)) > 0 ? (a / b) + 1 : 1;
		System.out.println(poolsize);

		ExecutorService executorServiceSplitLoop = Executors.newFixedThreadPool(poolsize);
		System.out.println("1" + executorServiceSplitLoop.isShutdown());
		List<Tuple2<String, Integer>> returnedData = Collections
				.synchronizedList(new ArrayList<Tuple2<String, Integer>>());
		ConcurrentHashMap<String, String> datatuple2 = new ConcurrentHashMap<String, String>();
		ConcurrentHashMap<String, ConcurrentHashMap<String, String>> datatuple3 = new ConcurrentHashMap<String, ConcurrentHashMap<String, String>>();
		ConcurrentHashMap<String, Integer> d = new ConcurrentHashMap<String, Integer>();
		StringBuffer buffer = new StringBuffer();

		for (int i = 0; i < a; i = i + b) {

			int start1 = 0;
			int end_ = 0;
			start1 = i;

			if ((i + b) > a) {
				end_ = i + (a % b);
			} else {
				end_ = i + b;
			}
			System.out.println(start1 + "--" + end_);
			JSONObject q = new JSONObject();
			RunnableUtil es = new RunnableUtil(q, postDataAll, start1, end_, returnedData, datatuple2, d, "loop",
					"blogpost_terms", "terms", buffer, datatuple3);
			executorServiceSplitLoop.execute(es);
		}

		executorServiceSplitLoop.shutdown();
		while (!executorServiceSplitLoop.isTerminated()) {
		}

		System.out.println("datatule2--" + datatuple2.size());
		System.out.println("datatule3--" + datatuple3.size());
		System.out.println("json array size" + postDataAll.size());
		System.out.println("returned--" + returnedData.size());
		HashMap<String, Integer> m = new HashMap<String, Integer>();
		for (Tuple2<String, Integer> p : returnedData) {
			String first = p._1;
			Integer second = p._2;
			if (!m.containsKey(first)) {
				m.put(first, second);
			} else {
				int m_val = m.get(first);
				int new_mval = m_val + second;
				m.put(first, new_mval);
			}
		}

		List<Entry<String, Integer>> entry = new Terms().entriesSortedByValues(m);
		if (entry.size() > 0) {
			for (int i = 0; i < Integer.parseInt(limit); i++) {
				if (i < entry.size()) {
					String left = entry.get(i).getKey();
					Integer right = entry.get(i).getValue();
					Tuple2<String, Integer> v = new Tuple2<String, Integer>(left, right);
					output.put(v);
				} else {
					break;
				}
			}
			System.out.println("answer--" + entry.get(0));
			System.out.println("output--" + output);
		}
		res.put("output", output);
		res.put("post_id_term_pair", datatuple2);
		res.put("post_id_post", datatuple3);
		return res;
	}

	public static void topTerms2(List<JSONObject> postDataAll, String limit) {

//		for (int i = 0; i < a; i = i + b) {
//
//			int start1 = 0;
//			int end_ = 0;
//
////	int[] test = new int[2];
////test[0] = i;
//			start1 = i;
//
//			if ((i + b) > a) {
////test[1] = i +(a%b);
//				end_ = i + (a % b);
//			} else {
////test[1] = i + b;
//				end_ = i + b;
//			}
//			System.out.println(start1 + "--" + end_);
//			JSONObject q = new JSONObject();
//			RunnableUtil es = new RunnableUtil(q, postDataAll, start1, end_, returnedData, datatuple2, d, "loop",
//					"blogpost_terms", "terms", buffer,datatuple3);
//			executorServiceSplitLoop.execute(es);
////			returnedData = es.datatuple;
//			// System.out.println("returned"+returnedData.size());
//
//		}
//
//		System.out.println("datatule2--" + datatuple2.size());
//		System.out.println("datatule3--" + datatuple3.size());
//		System.out.println("json array size" + postDataAll.size());
////		RunnableUtil es = new RunnableUtil();
////		(în,114787)
//		System.out.println("returned--" + returnedData.size());
//		HashMap<String, Integer> m = new HashMap<String, Integer>();
//		for (Tuple2<String, Integer> p : returnedData) {
//			String first = p._1;
//			Integer second = p._2;
//			if (!m.containsKey(first)) {
//				m.put(first, second);
//			} else {
//				int m_val = m.get(first);
//				int new_mval = m_val + second;
//				m.put(first, new_mval);
//			}
//		}
////		System.out.println(returnedData.get(0));
//
////		result = term.mapReduce(returnedData, limit);
//		List<Entry<String, Integer>> entry = new Terms().entriesSortedByValues(m);
////		
//		if (entry.size() > 0) {
//			for (int i = 0; i < Integer.parseInt(limit); i++) {
//				String left = entry.get(i).getKey();
//				Integer right = entry.get(i).getValue();
////			String v =  "(" + left + "," + String.valueOf(right) + ")";
//				Tuple2<String, Integer> v = new Tuple2<String, Integer>(left, right);
//				output.put(v);
//			}
//			System.out.println("answer--" + entry.get(0));
//			System.out.println("output--" + output);
//
////			return output;
//		}
//		res.put("output", output);
//		res.put("post_id_term_pair", datatuple2);
//		res.put("post_id_post", datatuple3);
//		return res;
	}

	public static String getTopTermsFromBlogIds(String ids, String from, String to, String limit) throws Exception {
		String result = null;
		JSONArray output = new JSONArray();
//		System.out.println("select * from blogpost_terms where blogsiteid in  (" + ids + ") and date > \"" + from
//				+ "\" and date < \"" + to + "\"");
//		List postDataAll = DbConnection.queryJSON("select * from blogpost_terms where blogsiteid in  (" + ids
//				+ ") and date > \"" + from + "\" and date < \"" + to + "\"");
//		JSONObject o = topTerms(postDataAll, limit);
//
//		return o;

		String query = "select n.term, sum(n.occurr) occurrence " + "from blogpost_terms_api, "
				+ "json_table(terms_test, " + "'$[*]' columns( " + "term varchar(128) path '$.term', "
				+ "occurr int(11) path '$.occurrence' " + ") " + ") " + "as n " + "where blogsiteid in  (" + ids
				+ ") and date > \"" + from + "\" and date < \"" + to + "\" " + "group by n.term "
				+ "order by occurrence desc " + "limit " + limit + "";
		System.out.println(query);
		List postDataAll = DbConnection.queryJSON(query);
		if (postDataAll.size() > 0) {
			for (int i = 0; i < postDataAll.size(); i++) {
				JSONObject data = new JSONObject(postDataAll.get(i).toString());
				Object term = data.getJSONObject("_source").get("term");
				Object occurrence = data.getJSONObject("_source").get("occurrence");
				Tuple2<String, Integer> v = new Tuple2<String, Integer>(term.toString(),
						Integer.parseInt(occurrence.toString()));
				output.put(v);

			}
		}
		return output.toString();
	}

	public static String getTopTermsFromBlogger(String blogger, String from, String to, String limit) throws Exception {
		String result = null;
		JSONArray output = new JSONArray();
//		System.out.println("select * from blogpost_terms where blogger in  (" + blogger + ") and date > \"" + from
//				+ "\" and date < \"" + to + "\"");
//		List postDataAll = DbConnection.queryJSON("select * from blogpost_terms where blogger in  (" + blogger
//				+ ") and date > \"" + from + "\" and date < \"" + to + "\"");
//		JSONObject o = topTerms(postDataAll, limit);
//
//		return o.get("output").toString();
		if (blogger.indexOf("\"") != 0) {
			blogger = "\"" + blogger + "\"";
		}
		String query = "select n.term, sum(n.occurr) occurrence " + "from blogpost_terms_api, "
				+ "json_table(terms_test, " + "'$[*]' columns( " + "term varchar(128) path '$.term', "
				+ "occurr int(11) path '$.occurrence' " + ") " + ") " + "as n " + "where blogger in  (" + blogger
				+ ") and date > \"" + from + "\" and date < \"" + to + "\" " + "group by n.term "
				+ "order by occurrence desc " + "limit " + limit + "";
		System.out.println(query);
		List postDataAll = DbConnection.queryJSON(query);
		if (postDataAll.size() > 0) {
			for (int i = 0; i < postDataAll.size(); i++) {
				JSONObject data = new JSONObject(postDataAll.get(i).toString());
				Object term = data.getJSONObject("_source").get("term");
				Object occurrence = data.getJSONObject("_source").get("occurrence");
				Tuple2<String, Integer> v = new Tuple2<String, Integer>(term.toString(),
						Integer.parseInt(occurrence.toString()));
				output.put(v);

			}
		}
		return output.toString();
	}

	public static String getTopTermsFromDashboard(String ids, String from, String to, String limit) throws Exception {
		String result = null;
		System.out.println("select * from blogpost_terms where blogsiteid in  (" + ids + ") and date > \"" + from
				+ "\" and date < \"" + to + "\"");
		List postDataAll = DbConnection.queryJSON("select * from blogpost_terms where blogsiteid in  (" + ids
				+ ") and date > \"" + from + "\" and date < \"" + to + "\"");
		JSONObject o = topTerms(postDataAll, limit);

		return o.get("output").toString();
	}

	public static String getTopTermsBlogger(String bloggers, String from, String to, String limit) throws Exception {
		String result = null;
		System.out.println("select * from blogpost_terms where blogger = \"" + bloggers + "\" and date > \"" + from
				+ "\" and date < \"" + to + "\"");
		List postDataAll = DbConnection.queryJSON("select * from blogpost_terms where blogger = \"" + bloggers
				+ "\" and date > \"" + from + "\" and date < \"" + to + "\"");
		if (postDataAll.size() > 0) {
			JSONObject o = topTerms(postDataAll, limit);
			JSONArray output = (JSONArray) o.get("output");

			result = output.toString().replaceAll("\"", "");
		} else {
			JSONArray output = new JSONArray("[-]");

			result = output.toString().replaceAll("\"", "");
		}
		return result;
	}

	public static String getTopTermsFromBlogIds2(String ids, String from, String to, String limit) throws Exception {
		String result = null;

		List<JSONObject> postDataAll = getPosts(ids, from, to, "__ONLY__TERMS__BLOGSITE_IDS__", "blogpost_terms");

		System.out.println(postDataAll.size());
		return result;
	}

	public static void main(String[] args) {

		try {

			Instant start = Instant.now();
			String ids = "813,815,809,811,812,806,808,817,644,652,616,641,732,761,709,128";
//			 String ids ="142,153,229,148,127,46,3,170,154,72,38,224,157,128,61,112,140,116,125,193,173,74,249,250,243,263,98,69,62,78,117,73,135,133,100,143,77,233,221,163,132,147,150,43,242,111,101,86,199,251,118,106,121,129,49,48,66,91,176,124,167,215,141,166,17,220,119,236,230,225,252,20,130,22,76,235,85,245,79,26,109,80,131,253,105,226,137,115,52,53,65,213,96,238,210,136,239,27,206,107,63,57,204,205,216,208,36,102,134,108,113,59,54,88";
//			String ids = "616";
//			String from = "2008-08-09";
//			String to = "2015-06-01";
//			String from = "1970-01-01";
//			String to = "2020-03-15";
//			String from = "1012-10-17";
//			String to = "2020-03-15";
//					"from": "2008-08-09",
//			        "to": "2015-06-01",

//			String ids = "";
			StringBuffer buffer = new StringBuffer();
			String from = "2000-01-01";
			String to = "2020-03-27";
			// System.out.println(getTopTermsFromBlogIds(ids, from, to, "100"));
			String s1 = "[('ukraine', 10), ('russia', 9), ('neutralism', 7), ('yugoslavia', 6), ('west', 5), ('economy', 4), ('policy', 3), ('tito', 3), ('stalin', 3), ('blocs', 3), ('poroshenko', 3), ('imf', 3), ('crisis', 2), ('relations', 2), ('power', 2), ('increasingly', 2), ('obama', 2), ('grey', 2), ('cold', 2), ('split', 2), ('members', 2), ('rapprochement', 2), ('exchange', 2), ('sending', 2), ('people', 2), ('send', 2), ('soviet', 2), ('nato', 2), ('threat', 2), ('regime', 2), ('looked', 2), ('petro', 2), ('russian', 2), ('putin', 2), ('offers', 2), ('union', 2), ('economic', 2), ('stability', 2), ('government', 2), ('crimean', 1), ('heralds', 1), ('international', 1), ('pivotal', 1), ('moment', 1), ('relationship', 1), ('balances', 1), ('shifting', 1), ('united', 1), ('remains', 1), ('unrivalled', 1), ('sheer', 1), ('close', 1), ('borders', 1), ('rising', 1), ('china', 1), ('assertive', 1), ('allegedly', 1), ('emboldened', 1), ('vacillations', 1), ('syria', 1), ('areas', 1), ('emerging', 1), ('vulnerable', 1), ('revisionist', 1), ('powers', 1), ('alarmed', 1), ('hands', 1), ('approach', 1), ('appears', 1), ('worthy', 1), ('revival', 1), ('defined', 1), ('foreign', 1), ('pioneered', 1), ('finland', 1), ('josip', 1), ('geographically', 1), ('sandwiched', 1), ('antagonistic', 1), ('prescribed', 1), ('balanced', 1), ('relationships', 1), ('neutral', 1), ('reaped', 1), ('rewards', 1), ('reserved', 1), ('paid', 1), ('bloc', 1), ('enjoyed', 1), ('modicum', 1), ('security', 1), ('knowing', 1), ('considered', 1), ('mutual', 1), ('neighbour', 1), ('preferable', 1), ('defection', 1), ('archetypal', 1), ('volcanic', 1), ('foresaw', 1), ('featured', 1), ('imploring', 1), ('kill', 1), ('teasing', 1), ('paranoia', 1), ('killers', 1), ('wrote', 1), ('moscow', 1), ('ensuing', 1), ('isolation', 1), ('decimated', 1), ('embargo', 1), ('thorn', 1), ('flesh', 1), ('communist', 1), ('unity', 1), ('trade', 1), ('deficits', 1), ('soaked', 1), ('afloat', 1), ('generous', 1), ('western', 1), ('loans', 1), ('balkan', 1), ('pact', 1), ('entwined', 1), ('greece', 1), ('turkey', 1), ('affording', 1), ('relief', 1), ('real', 1), ('intervention', 1), ('necessitating', 1), ('formal', 1), ('membership', 1), ('khrushchёv', 1), ('ostensibly', 1), ('socialist', 1), ('prospered', 1), ('area', 1), ('messianic', 1), ('empires', 1), ('lynchpin', 1), ('needed', 1), ('subject', 1), ('continued', 1), ('independence', 1), ('crushing', 1), ('hungary', 1), ('revolution', 1), ('testament', 1), ('paucity', 1), ('circumstance', 1), ('vie', 1), ('influence', 1), ('surprising', 1), ('president', 1), ('elect', 1), ('willingness', 1), ('rekindle', 1), ('limit', 1), ('military', 1), ('activities', 1), ('donetsk', 1), ('republic', 1), ('closer', 1), ('ties', 1), ('vladimir', 1), ('commentary', 1), ('abounded', 1), ('shortly', 1), ('began', 1), ('declared', 1), ('implacable', 1), ('allegiance', 1), ('opposing', 1), ('sides', 1), ('believed', 1), ('rise', 1), ('intermediary', 1), ('unique', 1), ('bounties', 1), ('doubt', 1), ('seek', 1), ('european', 1), ('integration', 1), ('definitive', 1), ('blow', 1), ('eurasian', 1), ('january', 1), ('surely', 1), ('primary', 1), ('simply', 1), ('achieve', 1), ('leaning', 1), ('electorate', 1), ('countenance', 1), ('rebalance', 1), ('exclusive', 1), ('alliance', 1), ('threaten', 1), ('recovery', 1), ('agenda', 1), ('underpinning', 1), ('presidency', 1), ('warned', 1), ('major', 1), ('reforms', 1), ('ukrainian', 1), ('potential', 1), ('unemployment', 1), ('nightmare', 1), ('ukrainians', 1), ('traditional', 1), ('energy', 1), ('subsidies', 1), ('period', 1), ('austerity', 1), ('leave', 1), ('relying', 1), ('irony', 1), ('bloodshed', 1), ('east', 1), ('sworn', 1), ('eliminate', 1), ('insurgency', 1), ('months', 1), ('hours', 1), ('long', 1), ('foreseen', 1), ('concession', 1), ('autonomy', 1), ('defuse', 1), ('situation', 1), ('victory', 1), ('russians', 1), ('alike', 1), ('recognises', 1), ('evident', 1), ('stated', 1), ('readiness', 1), ('dialogue', 1), ('denounced', 1), ('illegitimate', 1), ('junta', 1), ('decry', 1), ('surrender', 1), ('evidently', 1), ('nasty', 1), ('problems', 1), ('aware', 1), ('wage', 1), ('strategically', 1), ('lukewarm', 1), ('eager', 1), ('responsibility', 1), ('moribund', 1), ('weight', 1), ('restructuring', 1), ('hanging', 1), ('heavily', 1), ('coupled', 1), ('gas', 1), ('cut', 1), ('nascent', 1), ('appealing', 1)]";
			String s2 = "[('ukraine', 5), ('russian', 4), ('international', 4), ('putin', 4), ('nato', 3), ('moderate', 2), ('stephen', 2), ('walt', 2), ('favour', 2), ('ukrainian', 2), ('situation', 2), ('crimea', 2), ('russia', 2), ('response', 2), ('politics', 2), ('predictions', 1), ('future', 1), ('invasion', 1), ('abound', 1), ('expect', 1), ('bloodshed', 1), ('predict', 1), ('forthcoming', 1), ('apocalypse', 1), ('exclamations', 1), ('voices', 1), ('medhi', 1), ('hassan', 1), ('represent', 1), ('inconspicuous', 1), ('minority', 1), ('forgive', 1), ('generalisation', 1), ('events', 1), ('ilk', 1), ('horrendously', 1), ('overblown', 1), ('conclusions', 1), ('remembered', 1), ('wonks', 1), ('victims', 1), ('surely', 1), ('shots', 1), ('fired', 1), ('expectations', 1), ('great', 1), ('majority', 1), ('prognoses', 1), ('simplify', 1), ('notice', 1), ('aims', 1), ('fundamentally', 1), ('avoidance', 1), ('conflict', 1), ('note', 1), ('military', 1), ('installations', 1), ('occupied', 1), ('shelled', 1), ('traditional', 1), ('practice', 1), ('optimal', 1), ('successful', 1), ('referendum', 1), ('demanded', 1), ('february', 1), ('auspices', 1), ('occupation', 1), ('transferral', 1), ('sovereign', 1), ('status', 1), ('akin', 1), ('abkhazia', 1), ('south', 1), ('ossetia', 1), ('breakaway', 1), ('regions', 1), ('georgia', 1), ('recognised', 1), ('gradual', 1), ('membership', 1), ('federation', 1), ('stands', 1), ('potential', 1), ('nascent', 1), ('administration', 1), ('likelihood', 1), ('attacking', 1), ('forces', 1), ('slim', 1), ('steadfast', 1), ('assurance', 1), ('western', 1), ('poland', 1), ('lithuania', 1), ('soviet', 1), ('called', 1), ('emergency', 1), ('meeting', 1), ('claiming', 1), ('basis', 1), ('security', 1), ('interests', 1), ('threatened', 1), ('strong', 1), ('considerable', 1), ('divergence', 1), ('indefatigable', 1), ('mainstay', 1), ('limp', 1), ('responses', 1), ('tough', 1), ('talks', 1), ('avoided', 1), ('cliché', 1), ('testament', 1), ('aptitude', 1), ('machiavellian', 1), ('commentator', 1), ('wrote', 1), ('reminding', 1), ('work', 1), ('structure', 1), ('norms', 1), ('territorial', 1), ('land', 1), ('grabs', 1), ('political', 1), ('faux', 1), ('delivered', 1), ('crisis', 1), ('reap', 1), ('benefits', 1), ('painting', 1), ('impotent', 1), ('dressed', 1), ('kosovo', 1), ('reverse', 1), ('unilateral', 1), ('partition', 1), ('requested', 1), ('populace', 1), ('writes', 1), ('classic', 1), ('tradeoff', 1), ('stronger', 1), ('cares', 1), ('power', 1), ('trumps', 1), ('image', 1), ('courtesy', 1), ('taras', 1), ('gren', 1), ('wikimedia', 1)]";

			String new_str1 = s1.replace("),", "-").replace(",", "_").replace("(", "").replace("-", ",")
					.replace(" ", "").replace(")", "").replace("\'", "").replace("[", "").replace("]", "");
			String new_str2 = s2.replace("),", "-").replace(",", "_").replace("(", "").replace("-", ",")
					.replace(" ", "").replace(")", "").replace("\'", "").replace("[", "").replace("]", "");

			ArrayList<String> list = new ArrayList<String>();
			list.add(new_str1);
			list.add(new_str2);

			for (int i = 0; i < list.size(); i++) {
				buffer.append(list.get(i) + ",");
			}
//			buffer.append(new_str1);
//			buffer.append(",");
//			buffer.append(new_str2);
//			buffer.append(",");
			String finalbuffer = "[" + buffer + "]";

			System.out.println(finalbuffer);
			JSONArray ja = new JSONArray(finalbuffer);
			System.out.println(ja);

//			getTopTermsFromBlogIds(ids, from, to, "100");
//			System.out.println(getTopTermsFromBlogger("\"George McGinn\",\"Southfront analytic team\"", "2000-01-01", "2020-01-01" , "100"));
//			getPosts(ids, from, to, "__ONLY__TERMS__BLOGSITE_IDS__", "blogpost_terms");
			String url = " http://144.167.35.138:5000/";
			JSONObject js = new JSONObject("{\r\n" + "	\"tracker_id\":7,\r\n" + "	\"type\":\"create\"\r\n" + "}");

			System.out.println(_getResult(url, js));
//			getBloggersMentioned("20,16");
			// String bloggers = "George McGinn";
//			String from = "2000-01-01";
//			String to = "2020-01-01";
			// System.out.println(getTopTermsBlogger("George McGinn", "2000-01-01",
			// "2020-01-01" , "1"));
//			List<JSONObject> postDataAll1 = getPosts(bloggers, from, to, "__ONLY__TERMS__BLOGGERS", "blogpost_terms");
//			//System.out.println("select * from blogpost_terms where blogger = \"" + bloggers + "\" and date > \"" + from + "\" and date < \"" +  to +"\"");
//			List postDataAll = DbConnection.queryJSON("select * from blogpost_terms where blogger = \"" + bloggers + "\" and date > \"" + from + "\" and date < \"" +  to +"\"");
//			
//			System.out.println("first---"+postDataAll1.get(0));
//			String indx = postDataAll1.get(0).toString();
//			JSONObject j1 = new JSONObject(indx);
//			String ids1 = j1.get("_source").toString();
//			JSONObject j2 = new JSONObject(ids1);
//			String post_ids = j2.get("blogpost_id").toString();
//			String title = j2.get("title").toString();
//			String post = j2.get("post").toString();
//			System.out.println("first id-- "+post_ids);
//			
//			
//			//String terms = j2.get(field).toString();
//			
//			
//			
//			System.out.println("second---"+postDataAll.get(0));
////			 indx = postDataAll.get(0).toString();
//			 JSONObject source = new JSONObject(postDataAll.get(0).toString());
//			 System.out.println("source id-- "+source.get("_source"));
			// System.out.println(Arrays.asList(ssssss.split("-")).get(0));

			// SparkConf conf = new
			// SparkConf().setMaster("spark://144.167.35.50:4042").setAppName("Example").set("spark.ui.port","4042");;
//			conf.set("spark.driver.memory", "64g");
			// JavaSparkContext sc = new JavaSparkContext(conf);
			// sc.stop();
//			String test = "";
//			String tracker_id = "238";
//			// get postids from each cluster in tracker and save in JSONObject
//			ArrayList result = _getClusters(tracker_id);
//
//			JSONObject res = new JSONObject(result.get(0).toString());
//			JSONObject source = new JSONObject(res.get("_source").toString());
//
//			// ArrayList R2 = (ArrayList)result.get(0);
//			// for()
//			// System.out.println(source.get("cluster_3"));
////			HashMap<Pair<String, String>, JSONArray> clusterResult = new HashMap<Pair<String, String>, JSONArray>();
//			// JSONObject key_val = new JSONObject();
////			Pair<String, String> key_val = new Pair<String, String>(null, null);
//
////			HashMap<String, String> key_val_posts = new HashMap<String, String>();
//
//			String post_ids = null;
////			List<String> list = Arrays.asList("a","b","c");
//
////	        System.out.println(result);
//			int count_ = 0;
//			for (int i = 1; i < 11; i++) {
//				String cluster_ = "cluster_" + String.valueOf(i);
//				post_ids = source.get(cluster_).toString();
//				count_ = (count_ + (post_ids.split(",").length));
//
//				test = test.concat(post_ids + ",");
//
//			}
//
////			System.out.println(test.substring(test.length() - 1));
//			System.out.println("count ---" + count_);
//			System.out.println("test length---" + test.split(",").length);

			Instant end = Instant.now();
			Duration timeElapsed = Duration.between(start, end);
			System.out.println("Time taken: " + timeElapsed.getSeconds() + " seconds");

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Clustering() {
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
		HttpSession session = request.getSession();
		Object action = (null == request.getParameter("action")) ? "" : request.getParameter("action");
		Object cluster = (null == request.getParameter("cluster")) ? "" : request.getParameter("cluster");
		Object cluster_number = (null == request.getParameter("cluster")) ? "" : request.getParameter("cluster_number");
		Object tid = (null == request.getParameter("tid")) ? "" : request.getParameter("tid");

		Object result = (null == session.getAttribute(tid.toString() + "cluster_result")) ? ""
				: session.getAttribute(tid.toString() + "cluster_result");
		Object result_key_val = (null == session.getAttribute(tid.toString() + "cluster_result_key_val")) ? ""
				: session.getAttribute(tid.toString() + "cluster_result_key_val");

		Object distances = (null == session.getAttribute(tid.toString() + "cluster_distances")) ? ""
				: session.getAttribute(tid.toString() + "cluster_distances");

		HashMap<String, String> key_val_posts = (HashMap<String, String>) result_key_val;
		HashMap<Pair<String, String>, ArrayList<JSONObject>> clusterResult = (HashMap<Pair<String, String>, ArrayList<JSONObject>>) result;
//		try (FileWriter file = new FileWriter("C:\\Users\\bt_admin\\file2.json")) {
//			
//			file.write(key_val_posts.toString());
//			System.out.println("Successfully Copied JSON Object to File...");
//
//		}
		Pair<String, String> key_val = new Pair<String, String>(null, null);
		String cluster_ = cluster.toString();
		String post_ids = key_val_posts.get(cluster_);

		key_val = new Pair<String, String>(cluster_, post_ids);
		// System.out.println("seun o s here" + cluster_ +post_ids );

		Object total = (null == session.getAttribute(tid.toString() + "clusters_total")) ? ""
				: session.getAttribute(tid.toString() + "clusters_total");

		Object topterms_object = (null == session.getAttribute(tid.toString() + "cluster_terms")) ? ""
				: session.getAttribute(tid.toString() + "cluster_terms");

//		topterms = (HashMap<String, String>()) topterms.get;
//		HashMap<String, String> topterm = new HashMap<String, String>();
		HashMap<String, String> topterms = (HashMap<String, String>) topterms_object;
		// System.out.println("topterms_object --"+topterms_object);

		String blogdistribution = null;
		String bloggersMentioned = null;
		String topPostingLocation = null;
		ArrayList<JSONObject> postData = new ArrayList<JSONObject>();

		try {
			blogdistribution = this.getBlogDistribution(post_ids, (double) Integer.parseInt(total.toString()));
			bloggersMentioned = this.getBloggersMentioned(post_ids);
			topPostingLocation = this.getTopPostingLocation(post_ids);
			postData = clusterResult.get(key_val);
			// System.out.println("postData--"+postData);
		} catch (NumberFormatException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
//			 TODO Auto-generated catch block
			e.printStackTrace();
		}

		PrintWriter out = response.getWriter();
		// System.out.println(action.toString() +"----"+blogdistribution);

		if (action.toString().equals("loadblogdistribution")) {
			out.write(blogdistribution);
		} else if (action.toString().equals("loadpostmentioned")) {
			out.write(this.totalposts.replace(".0", ""));
		} else if (action.toString().equals("loadbloggersmentioned")) {
			out.write(bloggersMentioned);
		} else if (action.toString().equals("loadpostinglocation")) {
			out.write(topPostingLocation);
		} else if (action.toString().equals("loadtitletable")) {
			// Object title =
			// postData.getJSONObject(j).getJSONObject("_source").get("title");
			JSONObject post_distances_all = new JSONObject();
			post_distances_all.put("distances", new JSONObject(distances.toString()));
			post_distances_all.put("post_data", new JSONArray(postData.toString()));
			out.write(post_distances_all.toString());
		} else if (action.toString().equals("loadkeywords")) {
			// System.out.println("action" + action + "terms--" + topterms.get(cluster_));
			out.write(topterms.get(cluster_).toString());
		} else if (action.toString().equals("fetch_graph")) {

			Blogposts posts = new Blogposts();
			ArrayList value = new ArrayList();
			try {
				value = posts._getBlogPostDetails(null, null, null, post_ids, 0);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			HashMap<String, String> post_title = new HashMap<String, String>();
			for (int i = 0; i < value.size(); i++) {
				JSONObject data = new JSONObject(value.get(i).toString());
				Object title = data.getJSONObject("_source").get("title");
				Object blogpost_id = data.getJSONObject("_source").get("blogpost_id");
				post_title.put(blogpost_id.toString(), title.toString());
			}

			JSONArray nodes = new JSONArray();
			JSONArray links = new JSONArray();

			JSONObject center = new JSONObject();
			center.put("id", "center");
			center.put("group", 0);
			center.put("label", "center".toUpperCase());
			center.put("level", 1);
			nodes.put(center);

			String[] post_split = post_ids.split(",");
			// for(int i = 0; i < post_split.length; i++){
			for (int i = 0; i < 1000; i++) {

				if (i < post_split.length) {
					String p = post_split[i];
					JSONObject data = new JSONObject();

					data.put("id", p);
					data.put("group", cluster);
					data.put("label", cluster.toString().toUpperCase());
					data.put("level", 1);
					data.put("title", post_title.get(p));

					nodes.put(data);
				}
			}

			JSONObject d = new JSONObject(distances.toString());
			// for(int i = 0; i < post_split.length; i++){
			for (int i = 0; i < 1000; i++) {
				if (i < post_split.length) {
					String p = post_split[i];
					JSONObject data = new JSONObject();

					data.put("target", "center");
					data.put("source", p);
					data.put("strength", 50 - Double.parseDouble(d.get(p).toString()));

					links.put(data);
				}
			}

			JSONObject final_data = new JSONObject();
			final_data.put("nodes", nodes);
			final_data.put("links", links);
			JSONObject final_result = new JSONObject();
			final_result.put("final_data", final_data);
			final_result.put("cluster_id", cluster);
			final_result.put("cluster_number", cluster_number.toString());

			out.write(final_result.toString());
		}
//		if(Action)
	}

}
>>>>>>> 1f92e31eaa52c61d7b7996ab5ec5a9cf214df293
