package util;

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
import java.util.concurrent.atomic.AtomicInteger;

import org.apache.commons.math3.analysis.function.Atan;
import org.elasticsearch.cluster.metadata.AliasAction.NewAliasValidator;
import org.json.JSONArray;
import org.json.JSONObject;

import scala.Tuple2;
import util.Terms;

public class RunnableUtil implements Runnable {

	private JSONObject query;
//	public JSONArray jsonArray;
	public List<JSONObject> jsonArray;
	public String action;
	public String index;
//	public List<Tuple2<String, Integer>> datatuple = new ArrayList<Tuple2<String, Integer>>();
	public List<Tuple2<String, Integer>> datatuple = Collections
			.synchronizedList(new ArrayList<Tuple2<String, Integer>>());
	public List<JSONObject> jsonList = new ArrayList<JSONObject>();
	public ConcurrentHashMap<String, String> datatuple2 = new ConcurrentHashMap<String, String>();
	public ConcurrentHashMap<String, ConcurrentHashMap<String, String>> datatuple3 = new ConcurrentHashMap<String, ConcurrentHashMap<String, String>>();
	public int start;
	public int end;
//	public Map<String, Integer> d = new HashMap<String, Integer>();
	public ConcurrentHashMap<String, Integer> d = new ConcurrentHashMap<String, Integer>();
//	Map<String, Integer> d = Collections.synchronizedMap(new HashMap<String, Integer>());
	public String field;
	public StringBuffer buffer = new StringBuffer();
	public ConcurrentHashMap<String, Integer> m = new ConcurrentHashMap<String, Integer>();
	public JSONArray ja;
	
	public JSONArray forkArray;
	public int forkStart;
	public int forkEnd;
	

//	Map<Integer, JSONArray> res = new HashMap<Integer, JSONArray>();

//	public RunnableUtil(List<Tuple2<String, Integer>> datatuple) {
//		this.datatuple = datatuple;
//	}

//	public RunnableUtil(JSONArray jsonArray) {
//		this.jsonArray = jsonArray;
//	}
	public RunnableUtil(JSONArray forkArray, int forkStart, int forkEnd, String action, List<JSONObject> jsonList,ConcurrentHashMap<String, ConcurrentHashMap<String, String>> datatuple3) {
		this.forkArray = forkArray;
		this.forkStart = forkStart;
		this.forkEnd = forkEnd;
		this.action = action;
		this.jsonList = jsonList;
		this.datatuple3 = datatuple3;
	}

	public RunnableUtil(JSONObject query, List<JSONObject> jsonArray, int start, int end,
			List<Tuple2<String, Integer>> datatuple, ConcurrentHashMap<String, String> datatuple2,
			ConcurrentHashMap<String, Integer> d, String action, String index, String field, StringBuffer buffer,
			ConcurrentHashMap<String, ConcurrentHashMap<String, String>> datatuple3) {

		this.query = query;
		this.jsonArray = jsonArray;
		this.action = action;
		this.start = start;
		this.end = end;
		this.datatuple = datatuple;
		this.datatuple2 = datatuple2;
		this.datatuple3 = datatuple3;
		this.d = d;
		this.index = index;
		this.field = field;
		this.buffer = buffer;
	}

	public RunnableUtil(JSONObject query, List<JSONObject> jsonArray, int start, int end,
			List<Tuple2<String, Integer>> datatuple, ConcurrentHashMap<String, Integer> d, String action, String index,
			String field) {

		this.query = query;
		this.jsonArray = jsonArray;
		this.action = action;
		this.start = start;
		this.end = end;
		this.datatuple = datatuple;
		this.d = d;
		this.index = index;
		this.field = field;
	}

	public RunnableUtil(JSONObject query, List<JSONObject> jsonArray, int start, int end,
			List<Tuple2<String, Integer>> datatuple, ConcurrentHashMap<String, Integer> d, String action, String index,
			String field, List<JSONObject> jsonList, ConcurrentHashMap<String, ConcurrentHashMap<String, String>> datatuple3) {

		this.query = query;
		this.jsonArray = jsonArray;
		this.action = action;
		this.start = start;
		this.end = end;
		this.datatuple = datatuple;
		this.d = d;
		this.index = index;
		this.field = field;
		this.jsonList = jsonList;
		this.datatuple3 = datatuple3;
	}

	public RunnableUtil(JSONObject query, List<JSONObject> jsonArray, int start, int end,
			List<Tuple2<String, Integer>> datatuple, ConcurrentHashMap<String, Integer> d, String action, String index,
			String field, StringBuffer buffer) {

		this.query = query;
		this.jsonArray = jsonArray;
		this.action = action;
		this.start = start;
		this.end = end;
		this.datatuple = datatuple;
		this.d = d;
		this.index = index;
		this.field = field;
		this.buffer = buffer;
	}

	public RunnableUtil(ConcurrentHashMap<String, Integer> m, JSONArray ja, int start, int end, String action) {
		this.m = m;
		this.ja = ja;
		this.start = start;
		this.end = end;
		this.action = action;
	}

//	public RunnableUtil

	static Terms term = new Terms();

//	public synchronized void get(int start, int end, JSONArray jsonArray, Map<String, Integer> data) throws Exception {
//		String blogsiteid = null;
//		String blogpost_id = null;
//		String terms = null;
//		String result = null;
//		String topterm = null;
//		String date = null;
//
//		for (int i = start; i < end; i++) {
//			String indx = jsonArray.get(i).toString();
//			JSONObject j1 = new JSONObject(indx);
//			String ids = j1.get("_source").toString();
//			JSONObject j2 = new JSONObject(ids);
//
//			blogsiteid = j2.get("blogsiteid").toString();
//			blogpost_id = j2.get("blogpost_id").toString();
//			terms = j2.get("terms").toString();
//			date = j2.get("date").toString();
//
//			// process terms
//			String val = terms;
//			result = val.replace("[", "").replace("]", "");
//			String[] spl = result.split("\\),");
//
//			// perform stream
//			Arrays.asList(spl).parallelStream().forEach(v -> {
//				String newstr = v.replace("(", "").replace(")", "");
//				String[] tsplit = newstr.split(",");
//				int val2 = Integer.parseInt(tsplit[1].trim());
//
//				String first = tsplit[0].replace("\'", "").trim();
//				Integer second = val2;
//
//				Integer count = d.get(first);
//
//				if (count == null) {
//					data.put(first, second);
//				} else {
//					data.put(first, second + 1);
//				}
//			});
//
////			this.datatuple = data;
//			topterm = j2.get("topterm").toString();
//
////			Object date_json = j1.getJSONObject("fields").getJSONArray("date").get(0);
////			date = date_json.toString();
//		}
//
////		return null;
//
//	}

	public void wrangleDatadata(List<JSONObject> postarray, String field, int start, int end) {
//		List<Tuple2<String, Integer>> returnedData = new ArrayList<Tuple2<String, Integer>>();
		String result = null;
//		int count_ = 0;
		for (int i = start; i < end; i++) {
			String indx = postarray.get(i).toString();
			JSONObject j1 = new JSONObject(indx);
			String ids = j1.get("_source").toString();
			JSONObject j2 = new JSONObject(ids);
			String post_ids = j2.get("blogpost_id").toString();
			String title = j2.get("title").toString();
			String post = j2.get("post").toString();
			String terms = j2.get(field).toString();
			String blogger = j2.get("blogger").toString();
//			String num_comments = j2.get("num_comments").toString();
			String date = j2.get("date").toString();
//			String permalink = j2.get("permalink").toString();

//			HashMap<String, String> map = new HashMap<String, String>();
//			map.put(post_ids, terms);
			this.datatuple2.put(post_ids.trim(), terms.replaceAll("\"", "").trim());
			ConcurrentHashMap<String, String> temp = new ConcurrentHashMap<String, String>();
			
			temp.put("post", post);
			temp.put("title", title);
			temp.put("blogger", blogger);
//			temp.put("num_comments", num_comments);
			temp.put("date", date);

			this.datatuple3.put(post_ids.trim(), temp);

//			

			String val = terms;
			// String new_str1 = val.replace("),", "-").replace(",", "_").replace("(",
			// "").replace("-", ",").replace(" ", "").replace(")", "").replace("\'",
			// "").replace("[", "").replace("]", "");

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

					Tuple2<String, Integer> pair = new Tuple2<String, Integer>(first, second);
//				returnedData.add(pair);
					this.datatuple.add(pair);
				}
//				else {
//					Tuple2<String, Integer> pair = new Tuple2("__BLANK__", 1);
//					this.datatuple.add(pair);
//				}
			}
		}

//		this.datatuple = returnedData;
//		System.out.println(count_);
//		System.out.println(datatuple.size());
//		return returnedData;
	}

	public synchronized void wrangleDatadata2(List<JSONObject> postarray, String field, int start, int end) {
		String result = null;
//		int count_ = 0;
		for (int i = start; i < end; i++) {
			String indx = postarray.get(i).toString();
			JSONObject j1 = new JSONObject(indx);
			String ids = j1.get("_source").toString();
			JSONObject j2 = new JSONObject(ids);
			String post_ids = j2.get("blogpost_id").toString();
			String terms = j2.get(field).toString();
			String post = j2.get("post").toString();

//			HashMap<String, String> map = new HashMap<String, String>();
//			map.put(post_ids, terms);
			this.datatuple2.put(post_ids.trim(), terms.replaceAll("\"", "").trim());
			this.datatuple2.put(post_ids.trim(), post);
			// this.datatuple2.put(post_ids.trim(), terms.replaceAll("\"", "").trim());

			String val = terms;
			if (!terms.equals("BLANK")) {
				String new_str1 = val.replace("),", "-").replace(",", "__________term").replace("(", "")
						.replace("-", ",").replace(" ", "").replace(")", "").replace("\'", "").replace("[", "")
						.replace("]", "");
				buffer.append(new_str1 + ",");
			}

		}

	}

	public void forkJoin(JSONArray jsonarray, int start, int end) {
		for (int i = start; i < end; i++) {
//			if(i == 0) {
////				System.out.println("first"+jsonarray.getJSONObject(i));
//				System.out.println("first"+jsonarray.getJSONObject(i).getJSONObject("_source").get("blogpost_id"));
//			}
			ConcurrentHashMap<String, String> temp = new ConcurrentHashMap<String, String>();
			Object p = jsonarray.getJSONObject(i).getJSONObject("_source").get("post");
			String post = p.toString();
			Object t = jsonarray.getJSONObject(i).getJSONObject("_source").get("title");
			String title = t.toString();
			Object b = jsonarray.getJSONObject(i).getJSONObject("_source").get("blogger");
			String blogger = b.toString();
			Object p_id = jsonarray.getJSONObject(i).getJSONObject("_source").get("blogpost_id");
			String post_ids = p_id.toString();
			temp.put("post", post);
			temp.put("title", title);
			temp.put("blogger", blogger);
//			temp.put("num_comments", num_comments);
//			temp.put("date", date);

			this.datatuple3.put(post_ids.trim(), temp);
			JSONObject jsonObject = jsonarray.getJSONObject(i);
			
			jsonList.add(jsonObject);
		}
	}

	public void termsData(JSONArray ja) {
		for (int i = 0; i < ja.length(); i++) {
//			System.out.println(ja.get(i).toString());
			String first = ja.get(i).toString().split("__________term")[0];
			Integer second = Integer.parseInt(ja.get(i).toString().split("__________term")[1]);
			if (!this.m.containsKey(first)) {
				this.m.put(first, second);
			} else {
				int m_val = m.get(first);
				int new_mval = m_val + second;
				this.m.put(first, new_mval);
			}
		}
	}

	public List<Tuple2<String, Integer>> gettuple() {
		return this.datatuple;
	}

	public synchronized void test(JSONArray mergedArray) {
		for (int i = 0; i < mergedArray.length(); i++) {
			JSONObject jsonObject = mergedArray.getJSONObject(i);
			jsonList.add(jsonObject);
		}
	}

	public void pool(JSONArray mergedArray, List<JSONObject> jsonList,ConcurrentHashMap<String, ConcurrentHashMap<String, String>> datatuple3) {
		int a = mergedArray.length();
//		System.out.println("array_length--" + a);
		int b = 500;
		int poolsize = ((a / b)) > 0 ? (a / b) + 1 : 1;
		ExecutorService executorServiceFork = Executors.newFixedThreadPool(poolsize);

		for (int i = 0; i < a; i = i + b) {
			int start1 = 0;
			int end_ = 0;
			start1 = i;
			if ((i + b) > a) {
				end_ = i + (a % b);
//				System.out.println("final -- "+ start1 + "--" + end_);
			} else {
				end_ = i + b;
			}
			System.out.println("(-"+start1 + "--" + end_ + "-)");
			RunnableUtil es = new RunnableUtil(mergedArray, start1, end_, "fork", jsonList,datatuple3);
			executorServiceFork.execute(es);
		}
		
		executorServiceFork.shutdown();
	}
	
	public void scrollResult(String scroll_id) {
		JSONObject scrollResult = new JSONObject();
		try {
			scrollResult = term._scrollRequest(scroll_id);
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		Object allhits = scrollResult.getJSONObject("hits").getJSONArray("hits");
		String source = allhits.toString();
		JSONArray mergedArray = new JSONArray(source);

//		for (int i = 0; i < mergedArray.length(); i++) {
//			JSONObject jsonObject = mergedArray.getJSONObject(i);
//			jsonList.add(jsonObject);
//		}
		pool(mergedArray, jsonList,datatuple3); 
		
		JSONObject scrollResultContinue = new JSONObject();
		try {
			scrollResultContinue = term._scrollRequest(scroll_id);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Object allhits_continue = scrollResultContinue.getJSONObject("hits").getJSONArray("hits");
		JSONArray all = (JSONArray) allhits_continue;

		while (all.length() > 0) {
			mergedArray = new JSONArray(allhits_continue.toString());
			pool(mergedArray, jsonList, datatuple3); 
//			for (int i = 0; i < mergedArray.length(); i++) {
//				JSONObject jsonObject = mergedArray.getJSONObject(i);
//				jsonList.add(jsonObject);
//			}
			try {
				scrollResultContinue = term._scrollRequest(scroll_id);
				allhits_continue = scrollResultContinue.getJSONObject("hits").getJSONArray("hits");
				all = (JSONArray) allhits_continue;
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

//	private 
//	public 
	@Override
	public void run() {

		// TODO Auto-generated method stub
		// int count = 0;
		int val = 0;
		if (action.equals("elastic")) {
			try {
				String source = null;
				JSONObject myResponse = term._makeElasticRequest(query, "POST", "/" + index + "/_search/?scroll=1m");

				if (null != myResponse.get("hits")) {

					Object hits = myResponse.getJSONObject("hits").getJSONArray("hits");
					Object total = myResponse.getJSONObject("hits").getJSONObject("total").get("value");
					System.out.print(total + ",");
					Object scroll_id = myResponse.get("_scroll_id");

					source = hits.toString();
					JSONArray mergedArray = new JSONArray(source);
					pool(mergedArray, jsonList, datatuple3); 
					
//					while (!executorServiceFork.isTerminated()) {
//					}
					
//					for (int i = 0; i < mergedArray.length(); i++) {
//						JSONObject jsonObject = mergedArray.getJSONObject(i);
//						jsonList.add(jsonObject);
//					}
					scrollResult(scroll_id.toString());
				}

			} catch (Exception e) {
				// TODO Auto-generated catch block
				System.out.println("error--" + e);
				e.printStackTrace();
			}

		}
		// System.out.println("thread --" +count);
		if (action.equals("loop")) {
			try {
//				System.out.println("Thread " + Thread.currentThread().getName() + " started");
//				get(start,end, jsonArray, d); 
//				Clustering cluster = new Clustering();
//				wrangleDatadata2(jsonArray, field, start, end);
				wrangleDatadata(jsonArray, field, start, end);

			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		if (action.equals("test")) {
			try {
//				System.out.println("Thread " + Thread.currentThread().getName() + " started");
//				get(start,end, jsonArray, d); 
//				Clustering cluster = new Clustering();
				termsData(ja);
//				wrangleDatadata(jsonArray, field, start, end);

			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		if (action.equals("fork")) {
			try {
				forkJoin(forkArray, forkStart, forkEnd);

			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

}
