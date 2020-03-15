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
String str1 = "[('nato', 2485), ('russia', 2257), ('security', 1878), ('military', 1700), ('united', 1675), ('iran', 1588), ('president', 1522), ('ukraine', 1444), ('russian', 1369), ('europe', 1261), ('government', 1179), ('european', 1125), ('policy', 1119), ('obama', 1113), ('nuclear', 1112), ('afghanistan', 1085), ('political', 1071), ('international', 1063), ('defense', 1015), ('foreign', 941), ('atlantic', 863), ('council', 843), ('time', 831), ('american', 811), ('economic', 807), ('years', 737), ('national', 737), ('forces', 736), ('countries', 721), ('power', 716), ('putin', 689), ('country', 670), ('china', 656), ('people', 655), ('strategic', 655), ('alliance', 642), ('support', 627), ('global', 624), ('allies', 607), ('iraq', 575), ('strategy', 569), ('administration', 558), ('year', 552), ('long', 545), ('center', 541), ('east', 541), ('washington', 538), ('leaders', 534), ('crisis', 497), ('syria', 496), ('weapons', 488), ('america', 485), ('future', 474), ('west', 473), ('union', 470), ('minister', 460), ('sanctions', 439), ('moscow', 434), ('region', 425), ('middle', 410), ('relations', 409), ('members', 404), ('turkey', 393), ('iranian', 393), ('germany', 390), ('including', 389), ('percent', 385), ('troops', 382), ('senior', 381), ('nations', 380), ('public', 379), ('western', 375), ('interests', 375), ('economy', 373), ('major', 371), ('deal', 367), ('libya', 364), ('james', 348), ('today', 347), ('energy', 344), ('cooperation', 341), ('conflict', 337), ('regime', 337), ('leadership', 337), ('change', 336), ('eastern', 334), ('term', 332), ('secretary', 329), ('ukrainian', 325), ('israel', 324), ('pakistan', 320), ('soviet', 319), ('financial', 319), ('clear', 316), ('000', 316), ('role', 315), ('north', 314), ('prime', 308), ('threat', 308), ('general', 306)]";
String str2 = "[('albania', 485), ('albanian', 382), ('greek', 373), ('minister', 351), ('kosovo', 340), ('greece', 260), ('serbia', 219), ('government', 202), ('prime', 151), ('serbian', 151), ('police', 149), ('nato', 146), ('president', 138), ('2015', 135), ('tirana', 133), ('year', 123), ('country', 123), ('international', 119), ('belgrade', 116), ('community', 113), ('people', 112), ('himara', 107), ('years', 105), ('security', 104), ('pristina', 104), ('rama', 104), ('party', 102), ('foreign', 101), ('time', 99), ('told', 99), ('albanians', 97), ('europe', 96), ('council', 96), ('region', 96), ('agreement', 96), ('northern', 94), ('2016', 93), ('european', 89), ('athens', 89), ('church', 88), ('national', 85), ('vucic', 85), ('day', 82), ('political', 80), ('july', 80), ('source', 80), ('2009', 79), ('000', 76), ('decision', 76), ('epirus', 76), ('friday', 75), ('visit', 74), ('center', 73), ('rights', 72), ('countries', 72), ('group', 71), ('atlantic', 70), ('june', 69), ('statement', 68), ('photo', 67), ('turkish', 66), ('tanjug', 66), ('edi', 66), ('2014', 65), ('15', 65), ('court', 65), ('leader', 64), ('relations', 64), ('beta', 64), ('orthodox', 63), ('12', 62), ('serb', 62), ('ministry', 61), ('authorities', 61), ('called', 61), ('media', 60), ('energy', 60), ('today', 58), ('report', 58), ('meeting', 58), ('parliament', 58), ('serbs', 58), ('january', 57), ('30', 57), ('2013', 56), ('18', 56), ('ethnic', 56), ('11', 55), ('asked', 55), ('members', 54), ('general', 54), ('official', 54), ('deputy', 54), ('union', 54), ('area', 54), ('officials', 53), ('based', 53), ('defense', 53), ('corfu', 53), ('law', 52)]";
String str3 = "[('government', 1513), ('security', 1443), ('european', 1425), ('nato', 1374), ('europe', 1327), ('united', 1257), ('president', 1253), ('political', 1139), ('atlantic', 1079), ('council', 1032), ('international', 1023), ('military', 982), ('people', 935), ('russia', 930), ('afghanistan', 923), ('country', 909), ('years', 906), ('countries', 887), ('time', 875), ('ukraine', 871), ('pakistan', 822), ('economic', 813), ('national', 760), ('energy', 740), ('foreign', 739), ('policy', 715), ('defense', 707), ('center', 707), ('gas', 679), ('russian', 671), ('minister', 664), ('crisis', 653), ('long', 641), ('year', 626), ('power', 598), ('turkey', 589), ('american', 586), ('china', 585), ('global', 581), ('union', 576), ('support', 558), ('forces', 544), ('obama', 533), ('germany', 525), ('percent', 516), ('party', 514), ('leaders', 494), ('public', 486), ('financial', 480), ('strategic', 473), ('region', 471), ('economy', 460), ('future', 447), ('india', 438), ('north', 431), ('washington', 429), ('change', 426), ('member', 426), ('james', 424), ('south', 423), ('cyber', 409), ('group', 406), ('trade', 406), ('greece', 406), ('prime', 396), ('general', 384), ('including', 379), ('german', 371), ('work', 366), ('french', 366), ('west', 362), ('good', 360), ('fact', 360), ('term', 359), ('deal', 355), ('strategy', 355), ('greek', 355), ('relations', 354), ('attacks', 352), ('joyner', 352), ('oil', 351), ('east', 348), ('senior', 348), ('western', 347), ('france', 347), ('major', 346), ('role', 345), ('taliban', 344), ('conflict', 343), ('day', 339), ('today', 335), ('officials', 335), ('current', 334), ('agreement', 334), ('process', 333), ('election', 332), ('peace', 330), ('2009', 330), ('nuclear', 329), ('case', 328)]";

			Instant start = Instant.now();
			JSONArray test_all = new JSONArray();
//			str1 = str1.replace("[","").replace("]", "").replace("),", "-").replace("(", "");
			str1 = str1.replace("),", "-").replace("(", "");
			str2 = str2.replace("),", "-").replace("(", "");
			str3 = str3.replace("),", "-").replace("(", "");
			
			System.out.println(str1);
			System.out.println(str2);
			System.out.println(str3);
			
			System.out.println(str1.replaceAll("[0-9]","").replace("-", ""));
			System.out.println(str2.replaceAll("[0-9]","").replace("-", ""));
			System.out.println(str3.replaceAll("[0-9]","").replace("-", ""));
			
			
			String tester1 = str1.replaceAll("[0-9]","").replace("-", "").replace(", )", "");
			String tester2 = str2.replaceAll("[0-9]","").replace("-", "").replace(", )", "");
			String tester3 = str3.replaceAll("[0-9]","").replace("-", "").replace(", )", "");
			
			JSONArray test1 = new JSONArray(tester1);
			JSONArray test2 = new JSONArray(tester2);
			JSONArray test3 = new JSONArray(tester3);
			
			test_all.put(test1);
			test_all.put(test2);
			test_all.put(test3);
			//System.out.println(Arrays.asList(ssssss.split("-")).get(0));
			
			//SparkConf conf = new SparkConf().setMaster("spark://144.167.35.50:4042").setAppName("Example").set("spark.ui.port","4042");;
//			conf.set("spark.driver.memory", "64g");
			//JavaSparkContext sc = new JavaSparkContext(conf);
			//sc.stop();
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
		
		Object topterms_object = (null == session.getAttribute(tid.toString() + "cluster_terms")) ? ""
				: session.getAttribute(tid.toString() + "cluster_terms");
		
//		topterms = (HashMap<String, String>()) topterms.get;
//		HashMap<String, String> topterm = new HashMap<String, String>();
		HashMap<String, String> topterms = (HashMap<String, String>) topterms_object;
		//System.out.println("topterms_object --"+topterms_object);
		
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
		}else if (action.toString().equals("loadkeywords")) {
			//System.out.println("action" + action + "terms--" + topterms.get(cluster_));
			out.write(topterms.get(cluster_).toString());
		}
		
		

//		if(Action)
	}

}
