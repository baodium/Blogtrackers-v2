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
	public JSONObject _getResult(String url, JSONObject jsonObj) throws Exception {
		ArrayList<String> list = new ArrayList<String>();
		JSONObject myResponse = new JSONObject();
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
			// System.out.println("RESPONSE ==> " + myResponse);

		} catch (Exception ex) {
		}
		// System.out.println("This is the list for -----" + url + "---" + list);
		return myResponse;

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

	public static int getShardSize(JSONObject query,String index) {
		JSONObject myResponse = new JSONObject();
		int result = 0;
		try {
			myResponse = term._makeElasticRequest(query, "GET", "/"+index+"/_search_shards");
			// System.out.println(myResponse);

			if (!(myResponse.getJSONArray("shards").getJSONArray(0) == null)) {
				result = myResponse.getJSONArray("shards").getJSONArray(0).length();
			}
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

	public synchronized static ArrayList<JSONObject> _buildSlicedScrollQuery(String ids, String from, String to,
			String type, String index) throws Exception {
		JSONObject query = new JSONObject();
		
		if (type.contentEquals("__ONLY__SITE__ID__")) {
			query = new JSONObject("{\r\n" + "    \"query\": {\r\n" + "        \"bool\": {\r\n"
					+ "            \"must\": [\r\n" + "                {\r\n" + "                    \"terms\": {\r\n"
					+ "                        \"blogsite_id\": [" + ids + "],\r\n"
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
		}

		ArrayList<JSONObject> result = new ArrayList<JSONObject>();
		String total = term._count(query, "/" + index + "/_count?");
		// System.out.println(query);
		int shardCount = getShardSize(query,index);
//		System.out.println(shardCount);
//		System.out.println("total -->"+total);
		int size = 0;
		if(Integer.parseInt(total) > 10000) {
			size = Math.round(Integer.parseInt(total) / shardCount) + 5;
		}else {
			size = 1000;
		}
//		int 
		size = (size == 0) ? 0 : size;

		System.out.println("size -->" + size);
		 int id = Math.round(Integer.parseInt(total) / size);
		 int max = (id + 2 > shardCount) ? shardCount : (id + 2);
		//int max = shardCount;
//		System.out.println(String.valueOf(0));	

		System.out.println("max -->" + String.valueOf(max));
		for (int i = 0; i < max; i++) {
			String appendee = query.toString();
			String newquery = "{\r\n" + "	\"size\":" + String.valueOf(size) + ","
					+ appendee.substring(1, appendee.length() - 1) + "," + "\"slice\": {\r\n" + "    	      \"id\": "
					+ String.valueOf(i) + ",\r\n" + "        \"max\": " + String.valueOf(max) + "\r\n" + "    }}";

			// System.out.println(newquery);
			result.add(new JSONObject(newquery));
		}
		return result;
	}

	public static synchronized JSONArray getPosts(String ids, String from, String to, String type) throws Exception {
		JSONArray jsonArray = new JSONArray();
		
		HashMap<String, String> result = new HashMap<String, String>();
//		Instant start = Instant.now();
		List<Tuple2<String, Integer>> datatuple = new ArrayList<Tuple2<String, Integer>>();
		Map<String, Integer> d = new HashMap<String, Integer>();

		int shardCount = getShardSize(new JSONObject(),"blogposts");
		System.out.println("shard c 2==>" + shardCount);

		ExecutorService executorServiceBlogSiteIds = Executors.newFixedThreadPool(shardCount + 1);
//		String ids = "182,142,128,193,173,74,135,133,100,143,77,233,221,163,132,147,150,43,242,\r\n" + 
//				"			111,101,86,199,251,118,106,121,129,49,48,66,91,176,124,167,215,141,166,17,220,\r\n" + 
//				"			119,236,230,225,252,20,130,22,76,235,85,245,\r\n" + 
//				"			79,26,109,80,131,253,105,226,137,115,52";

//		String ids = "162";
		if (type.contentEquals("__ONLY__POST__ID__")) {
			jsonArray = new JSONArray();
			for (JSONObject q : _buildSlicedScrollQuery(ids, from, to, type, "blogposts")) {
				// System.out.println(q);
				int start1 = 0;
				int end = 0;
				RunnableUtil esR2 = new RunnableUtil(q, jsonArray, start1, end, datatuple, d, "elastic", "blogposts",
						"post");
				executorServiceBlogSiteIds.execute(esR2);
			}
		} else if (type.contentEquals("__ONLY__TERMS__")) {
			jsonArray = new JSONArray();
			for (JSONObject q : _buildSlicedScrollQuery(ids, from, to, type, "blogpost_terms")) {
//				 System.out.println(q);
				int start1 = 0;
				int end = 0;
				RunnableUtil esR2 = new RunnableUtil(q, jsonArray, start1, end, datatuple, d, "elastic",
						"blogpost_terms", "terms");
				executorServiceBlogSiteIds.execute(esR2);
			}
		}

		executorServiceBlogSiteIds.shutdown();
		while (!executorServiceBlogSiteIds.isTerminated()) {
		}

		System.out.println("length from thread" + jsonArray.length());
		return jsonArray;
	}

	public JSONArray getPostIdsFromApiCluster(String clusterNum, JSONObject result) throws Exception {
		JSONArray result_ = new JSONArray();
		String index = String.valueOf(Integer.parseInt(clusterNum) - 1);

		JSONArray posts_ids = result.getJSONArray(index).getJSONObject(0).getJSONObject("cluster_" + (clusterNum))
				.getJSONArray("post_ids");

		result_ = posts_ids;
		return result_;
	}

	public String getBloggersMentioned(String postIds) throws Exception {
		String result = null;
		JSONObject query = new JSONObject("{\r\n" + "    \"size\": 0,\r\n" + "    \"query\": {\r\n"
				+ "        \"terms\": {\r\n" + "            \"blogpost_id\": [" + postIds + "],\r\n"
				+ "            \"boost\": 1.0\r\n" + "        }\r\n" + "    },\r\n" + "    \"_source\": false,\r\n"
				+ "    \"stored_fields\": \"_none_\",\r\n" + "    \"aggregations\": {\r\n"
				+ "        \"groupby\": {\r\n" + "            \"composite\": {\r\n"
				+ "                \"size\": 1000,\r\n" + "                \"sources\": [\r\n"
				+ "                    {\r\n" + "                        \"442\": {\r\n"
				+ "                            \"terms\": {\r\n"
				+ "                                \"field\": \"blogger.keyword\",\r\n"
				+ "                                \"missing_bucket\": true,\r\n"
				+ "                                \"order\": \"asc\"\r\n" + "                            }\r\n"
				+ "                        }\r\n" + "                    }\r\n" + "                ]\r\n"
				+ "            }\r\n" + "        }\r\n" + "    }\r\n" + "}");

		JSONObject myResponse = term._makeElasticRequest(query, "POST", "/blogposts/_search");
		if (null != myResponse.get("hits")) {
			Object aggregations = myResponse.getJSONObject("aggregations").getJSONObject("groupby")
					.getJSONArray("buckets").length();
			result = aggregations.toString();
		}
		return result;
	}

	public String getTopPostingLocation(String postIds) throws Exception {
		String result = null;
		JSONObject query = new JSONObject("{\r\n" + "    \"size\": 0,\r\n" + "    \"query\": {\r\n"
				+ "        \"terms\": {\r\n" + "            \"blogpost_id\": [" + postIds + "],\r\n"
				+ "            \"boost\": 1.0\r\n" + "        }\r\n" + "    },\r\n" + "    \"_source\": false,\r\n"
				+ "    \"stored_fields\": \"_none_\",\r\n" + "    \"aggregations\": {\r\n"
				+ "        \"groupby\": {\r\n" + "            \"composite\": {\r\n"
				+ "                \"size\": 1000,\r\n" + "                \"sources\": [\r\n"
				+ "                    {\r\n" + "                        \"dat\": {\r\n"
				+ "                            \"terms\": {\r\n"
				+ "                                \"field\": \"location.keyword\",\r\n"
				+ "                                \"missing_bucket\": true,\r\n"
				+ "                                \"order\": \"desc\"\r\n" + "                            }\r\n"
				+ "                        }\r\n" + "                    }\r\n" + "                ]\r\n"
				+ "            },\r\n" + "            \"aggregations\": {\r\n" + "                \"dat\": {\r\n"
				+ "                    \"filter\": {\r\n" + "                        \"exists\": {\r\n"
				+ "                            \"field\": \"location\",\r\n"
				+ "                            \"boost\": 1.0\r\n" + "                        }\r\n"
				+ "                    }\r\n" + "                }\r\n" + "            }\r\n" + "        }\r\n"
				+ "    }\r\n" + "}");

		JSONObject myResponse = term._makeElasticRequest(query, "POST", "/blogposts/_search");
		if (null != myResponse.get("hits")) {
			Object aggregations = myResponse.getJSONObject("aggregations").getJSONObject("groupby")
					.getJSONArray("buckets").getJSONObject(0).getJSONObject("key").get("dat");
			result = aggregations.toString();
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
		JSONArray jsonArray = new JSONArray();
//			HashMap<String, String> result = new HashMap<String, String>();
		ArrayList<String> result = new ArrayList<String>();
//			Instant start = Instant.now();
		List<Tuple2<String, Integer>> datatuple = new ArrayList<Tuple2<String, Integer>>();
		Map<String, Integer> d = new HashMap<String, Integer>();

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
		for (int i = 0; i < jsonArray.length(); i++) {
//				Object post_id = jsonArray.getJSONObject(i).getJSONObject("_source").get("blogpost_id");
			Object post = jsonArray.getJSONObject(i).getJSONObject("_source").get("post");
			result.add(post.toString());

//				test.put(post_id.toString(), post.toString());
//				result.put(post_id.toString(), post.toString());
		}

		System.out.println("this is result" + result.size());
		return result;
	}

	public static ArrayList _getClusters(String tid) throws Exception {

		int size = 50;
		DbConnection db = new DbConnection();
		String count = "0";
		//System.out.println("SELECT *  FROM clusters WHERE tid = '" + tid + "");

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
		//System.out.println("SELECT *  FROM cluster_svd WHERE post_id in ( " + postids + ")");

		ArrayList result = new ArrayList();
		try {
			result = db.queryJSON("SELECT *  FROM cluster_svd WHERE post_id in ( " + postids + ")");

		} catch (Exception e) {
			return result;
		}

		return result;

	}
	
	public static String getTopTerms(String PostIds) throws Exception{
		String result = null;
		
		JSONArray postDataAll = getPosts(PostIds, "", "", "__ONLY__TERMS__");

		System.out.println("postall" + postDataAll.length());

		int a = postDataAll.length();
		int b = 1000;
		int poolsize = ((a / b)) > 0 ? (a / b) + 1 : 1;
		System.out.println(poolsize);
////	System.out.println(jsonArray.length());
		ExecutorService executorServiceSplitLoop = Executors.newFixedThreadPool(poolsize);
		System.out.println("1" + executorServiceSplitLoop.isShutdown());
//ArrayList<int[]> result = new ArrayList<int[]>();
//		List<Tuple2<String, Integer>> returnedData = new ArrayList<Tuple2<String, Integer>>();
		List<Tuple2<String, Integer>> returnedData = Collections
				.synchronizedList(new ArrayList<Tuple2<String, Integer>>());

		Map<String, Integer> d = new HashMap<String, Integer>();

		for (int i = 0; i < 10; i = i + b) {

			int start1 = 0;
			int end_ = 0;

//	int[] test = new int[2];
//test[0] = i;
			start1 = i;

			if ((i + b) > a) {
//test[1] = i +(a%b);
				end_ = i + (a % b);
			} else {
//test[1] = i + b;
				end_ = i + b;
			}
			System.out.println(start1 + "--" + end_);
			JSONObject q = new JSONObject();
			RunnableUtil es = new RunnableUtil(q, postDataAll, start1, end_, returnedData, d, "loop",
					"blogpost_terms", "terms");
			executorServiceSplitLoop.execute(es);
//			returnedData = es.datatuple;
			// System.out.println("returned"+returnedData.size());

		}

		executorServiceSplitLoop.shutdown();
		while (!executorServiceSplitLoop.isTerminated()) {
		}

		System.out.println("2" + executorServiceSplitLoop.isShutdown());
		System.out.println("json array size" + postDataAll.length());
//		RunnableUtil es = new RunnableUtil();
//		(în,114787)
		System.out.println("returned--" + returnedData.size());
//		System.out.println(returnedData.get(0));

		result = term.mapReduce(returnedData, "100");
		
		return result;
	}

	public static void main(String[] args) {

		try {
String ssssss = "[(news,1076), (read,1056), (editor,852), (wnu,849), (navy,742), (air,672), (military,572), (reuters,550), (attack,451), (peace,442), (army,416), (aircraft,405), (president,384), (china,382), (police,378), (killed,363), (times,343), (people,343), (afp,338), (time,325), (sea,320), (soldiers,306), (south,301), (years,300), (2016,296), (forces,295), (update,290), (photo,276), (north,267), (carrier,262), (bbc,261), (city,260), (daily,251), (year,251), (government,250), (defense,247), (ship,246), (chinese,243), (day,219), (10,218), (uss,215), (security,213), (base,211), (fighter,211), (anti,209), (cnn,206), (leader,205), (missile,204), (35,203), (long,201), (washington,196), (000,195), (agency,191), (battle,188), (dead,186), (group,185), (video,183), (taliban,182), (officials,182), (short,179), (2017,178), (russian,177), (mail,175), (told,174), (today,174), (korea,172), (twitter,172), (national,172), (islamic,171), (life,171), (weapons,168), (post,167), (country,166), (guardian,166), (death,164), (report,161), (coast,160), (bomb,159), (live,156), (afghan,154), (stories,154), (ships,153), (class,153), (isis,152), (election,150), (intelligence,148), (combat,147), (training,146), (plane,145), (service,144), (wikileaks,144), (attacks,142), (cia,142), (space,141), (sputnik,139), (poems,139), (france,139), (essays,139), (excerpts,138), (nuclear,138)]";
			Instant start = Instant.now();
			ssssss = ssssss.replace("[","").replace("]", "").replace("),", "-").replace("(", "");
			System.out.println(ssssss);
			System.out.println(Arrays.asList(ssssss.split("-")).get(0));
			
			SparkConf conf = new SparkConf().setMaster("spark://144.167.35.50:4042").setAppName("Example").set("spark.ui.port","4042");;
//			conf.set("spark.driver.memory", "64g");
			JavaSparkContext sc = new JavaSparkContext(conf);
			sc.stop();
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
		Object tid = (null == request.getParameter("tid")) ? "" : request.getParameter("tid");

		Object result = (null == session.getAttribute(tid.toString() + "cluster_result")) ? ""
				: session.getAttribute(tid.toString() + "cluster_result");
		Object result_key_val = (null == session.getAttribute(tid.toString() + "cluster_result_key_val")) ? ""
				: session.getAttribute(tid.toString() + "cluster_result_key_val");
		
		Object distances = (null == session.getAttribute(tid.toString() + "cluster_distances")) ? ""
				: session.getAttribute(tid.toString() + "cluster_distances");

		HashMap<String, String> key_val_posts = (HashMap<String, String>) result_key_val;
		HashMap<Pair<String, String>, JSONArray> clusterResult = (HashMap<Pair<String, String>, JSONArray>) result;

		Pair<String, String> key_val = new Pair<String, String>(null, null);
		String cluster_ = cluster.toString();
		String post_ids = key_val_posts.get(cluster_);

		key_val = new Pair<String, String>(cluster_, post_ids);
		clusterResult.get(key_val);

		Object total = (null == session.getAttribute(tid.toString() + "clusters_total")) ? ""
				: session.getAttribute(tid.toString() + "clusters_total");
		String blogdistribution = null;
		String bloggersMentioned = null;
		String topPostingLocation = null;
		JSONArray postData = new JSONArray();

		try {
			blogdistribution = this.getBlogDistribution(post_ids, (double) Integer.parseInt(total.toString()));
			bloggersMentioned = this.getBloggersMentioned(post_ids);
			topPostingLocation = this.getTopPostingLocation(post_ids);
			postData = clusterResult.get(key_val);
		} catch (NumberFormatException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
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
			post_distances_all.put("post_data", postData);
			out.write(post_distances_all.toString());
		}

//		if(Action)
	}

}
