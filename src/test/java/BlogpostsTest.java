import java.io.FileWriter;
import java.time.Duration;
import java.time.Instant;
import java.util.*;
import util.*;

import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorCompletionService;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;
import org.json.JSONArray;
import org.json.JSONObject;

import scala.Tuple2;
//import util.DummyComparator;

public class BlogpostsTest {

	public String countTerms(List<Tuple2> data) throws Exception {
		String result = null;

		try {
			SparkConf conf = new SparkConf().setMaster("local[10]").setAppName("Example");

			JavaSparkContext sc = new JavaSparkContext(conf);
			JavaRDD rdd = sc.parallelize(data);
			JavaPairRDD pairRdd = JavaPairRDD.fromJavaRDD(rdd);
//			JavaPairRDD counts = pairRdd.reduceByKey((a, b) -> a + b);
//			JavaPairRDD counts  = pairRdd.mapt
			System.out.println(pairRdd);

		} catch (Exception e) {
			System.out.println(e);
		}
		return result;
	}

	public static int getShardSize(JSONObject query) {
		JSONObject myResponse = new JSONObject();
		try {
			myResponse = term._makeElasticRequest(query, "GET", "/blogpost_terms/_search_shards");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		int result = myResponse.getJSONArray("shards").getJSONArray(0).length();
		return result;
	}

//	182,142,128,193,173,74,135,133,100,143,77,233,221,163,132,147,150,43,242,
//	111,101,86,199,251,118,106,121,129,49,48,66,91,176,124,167,215,141,166,17,220,
//	119,236,230,225,252,20,130,22,76,235,85,245,
//	79,26,109,80,131,253,105,226,137,115,52
	static Terms term = new Terms();

	public static ArrayList<JSONObject> _buildSlicedScrollQuery(String ids) throws Exception {
		JSONObject query = new JSONObject("{\r\n" + "    \"query\": {\r\n" + "        \"bool\": {\r\n"
				+ "            \"must\": [\r\n" + "                {\r\n" + "                    \"terms\": {\r\n"
				+ "                        \"blogsiteid\": [" + ids + "],\r\n"
				+ "                        \"boost\": 1\r\n" + "                    }\r\n" + "                },\r\n"
				+ "                {\r\n" + "                    \"range\": {\r\n"
				+ "                        \"date\": {\r\n"
				+ "                            \"from\": \"2007-08-23\",\r\n"
				+ "                            \"to\": \"2018-12-07\",\r\n"
				+ "                            \"include_lower\": true,\r\n"
				+ "                            \"include_upper\": true,\r\n"
				+ "                            \"boost\": 1\r\n" + "                        }\r\n"
				+ "                    }\r\n" + "                }\r\n" + "            ],\r\n"
				+ "            \"adjust_pure_negative\": true,\r\n" + "            \"boost\": 1\r\n" + "        }\r\n"
				+ "    }\r\n" + "}");

		ArrayList<JSONObject> result = new ArrayList<JSONObject>();
		String total = term._count(query, "/blogpost_terms/_count?");
		JSONObject myResponse = term._makeElasticRequest(query, "GET", "/blogpost_terms/_search_shards");
//		System.out.println(query);g
		int shardCount = getShardSize(query);
//		System.out.println(shardCount);
//		System.out.println("total -->"+total);
		int size = Math.round(Integer.parseInt(total) / shardCount) + 500;
//		System.out.println("size -->" + size);
		//int id = Math.round(Integer.parseInt(total) / size);
//		int max = (id + 2 > shardCount) ? shardCount : (id + 2);
		int max = shardCount;
//		System.out.println(String.valueOf(0));		
//		System.out.println("max -->"+String.valueOf(max));
		for (int i = 0; i < max; i++) {
			String appendee = query.toString();
			String newquery = "{\r\n" + "	\"size\":" + String.valueOf(size) + ","
					+ appendee.substring(1, appendee.length() - 1) + "," + "\"slice\": {\r\n" + "    	      \"id\": "
					+ String.valueOf(i) + ",\r\n" + "        \"max\": " + String.valueOf(max) + "\r\n" + "    }}";

//			System.out.println(newquery);
			result.add(new JSONObject(newquery));
		}
		return result;
	}

	public static int getpoolsize(JSONArray jsonArray) throws Exception {
		// <JSONArray> result = new ArrayList<JSONArray>();

		int split = Math.round(jsonArray.length() / 1000);
//		for 

		return split;
	}

//	public static ArrayList<JSONArray> _buildSlicedLoop(JSONArray jsonArray) throws Exception {
//		ArrayList<JSONArray> result = new ArrayList<JSONArray>();
//
//		int split = Math.round(jsonArray.length() / size);
////		for 
//
//		return result;
//	}

	public static void main(String[] args) {
		JSONArray jsonArray = new JSONArray();
		Instant start = Instant.now();
		List<Tuple2<String, Integer>> datatuple = new ArrayList<Tuple2<String, Integer>>();
		Map<String, Integer> d = new HashMap<String, Integer>();

		int shardCount = getShardSize(new JSONObject());
		System.out.println("shard c 2==>" + shardCount);
		

		
		ExecutorService executorServiceElastic = Executors.newFixedThreadPool(shardCount + 1);
//		ExecutorCompletionService ecs = new ExecutorCompletionService(executorServiceElastic);

		Collection<Callable<ElasticRunnable>> tasks = new ArrayList<Callable<ElasticRunnable>>(16);
		
		try {
			
			String ids = "182,142,128,193,173,74,135,133,100,143,77,233,221,163,132,147,150,43,242,\r\n" + 
					"			111,101,86,199,251,118,106,121,129,49,48,66,91,176,124,167,215,141,166,17,220,\r\n" + 
					"			119,236,230,225,252,20,130,22,76,235,85,245,\r\n" + 
					"			79,26,109,80,131,253,105,226,137,115,52";
//			String ids = "162";
			for (JSONObject q : _buildSlicedScrollQuery(ids)) {
				int start1 = 0;
				int end = 0;
				ElasticRunnable esR2 = new ElasticRunnable(q, jsonArray, start1, end, datatuple,d, "elastic");
				executorServiceElastic.execute(esR2);
			}

			executorServiceElastic.shutdown();
			while(!executorServiceElastic.isTerminated()) {}
			

//			if (executorServiceElastic.isShutdown()) {
				  System.out.println("json array size" + jsonArray.length());
//				int a = jsonArray.length();
////				System.out.println(a);
//				int b = 1000;
//				int poolsize = ((a / b)) > 0 ? (a/b): 1;
//				System.out.println(poolsize);
////					System.out.println(jsonArray.length());
//				ExecutorService executorServiceSplitLoop = Executors.newFixedThreadPool(poolsize);
//				System.out.println("1"+executorServiceSplitLoop.isShutdown());
////		ArrayList<int[]> result = new ArrayList<int[]>();
//
//				for (int i = 0; i < a; i = i + b) {
//
//					int start1 = 0;
//					int end = 0;
//
////					int[] test = new int[2];
////			test[0] = i;
//					start1 = i;
//
//					if ((i + b) > a) {
////				test[1] = i +(a%b);
//						end = i + (a % b);
//					} else {
////			test[1] = i + b;
//						end = i + b;
//					}
//					System.out.println(start1 + "--" + end);
//					JSONObject q = new JSONObject();
//					ElasticRunnable es = new ElasticRunnable(q, jsonArray, start1, end, datatuple,d, "loop");
//					executorServiceSplitLoop.execute(es);
//					
//
//				}
//				executorServiceSplitLoop.shutdown();
//				while(!executorServiceSplitLoop.isTerminated()) {}
//				System.out.println("2"+executorServiceSplitLoop.isShutdown());
//				System.out.println("json array size" + jsonArray.length());
////				System.out.println(datatuple);
////				System.out.println();
//				String highest = Collections.max(d.entrySet(), Comparator.comparingInt(Map.Entry::getValue)).getKey();
//				System.out.println(d.get(highest));
				
//				term.mapReduce(datatuple, "topterm");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
//		System.out.println(result);
		Instant end = Instant.now();
		Duration timeElapsed = Duration.between(start, end);
		System.out.println("Time taken: " + timeElapsed.getSeconds() + " seconds");
	}

}
