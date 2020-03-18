package util;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

import scala.Tuple2;
import util.Terms;

public class RunnableUtil implements Runnable {

	private JSONObject query;
	public JSONArray jsonArray;
	public String action;
	public String index;
//	public List<Tuple2<String, Integer>> datatuple = new ArrayList<Tuple2<String, Integer>>();
	public List<Tuple2<String, Integer>> datatuple = Collections.synchronizedList(new ArrayList<Tuple2<String, Integer>>());
	public int start;
	public int end;
	public Map<String, Integer> d = new HashMap<String, Integer>();
	public String field;

	Map<Integer, JSONArray> res = new HashMap<Integer, JSONArray>();

	public RunnableUtil(List<Tuple2<String, Integer>> datatuple) {
		this.datatuple = datatuple;
	}
	
	public RunnableUtil(JSONObject query, JSONArray jsonArray, int start, int end, List<Tuple2<String, Integer>> datatuple, Map<String, Integer> d,String action, String index, String field) {
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

	static Terms term = new Terms();
	
	public synchronized void  get(int start, int end, JSONArray jsonArray, Map<String, Integer> data) throws Exception{
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
				
				String first = tsplit[0].replace("\'", "").trim();
				Integer second = val2;
				
				Integer count = d.get(first);
				
				if(count == null) {
					data.put(first, second);
				}else {
					data.put(first, second + 1);
				}
			});

//			this.datatuple = data;
			topterm = j2.get("topterm").toString();

//			Object date_json = j1.getJSONObject("fields").getJSONArray("date").get(0);
//			date = date_json.toString();
		}
		
		
		
//		return null;
		 
	}
	
	public void wrangleDatadata(JSONArray postarray, String field, int start, int end) {
//		List<Tuple2<String, Integer>> returnedData = new ArrayList<Tuple2<String, Integer>>();
		String result = null;
//		int count_ = 0;
		for (int i = start; i < end; i++) {
			String indx = postarray.get(i).toString();
			JSONObject j1 = new JSONObject(indx);
			String ids = j1.get("_source").toString();
			JSONObject j2 = new JSONObject(ids);
			String terms = j2.get(field).toString();

			String val = terms;
			result = val.replace("[", "").replace("]", "");
			String[] spl = result.split("\\),");
//			System.out.println(spl.length);
//			count_ = count_ + spl.length;

			for (String v : spl) {
				String newstr = v.replace("(", "").replace(")", "");
				String[] tsplit = newstr.split(",");
				int val2 = Integer.parseInt(tsplit[1].trim());

				String first = tsplit[0].replace("\'", "").trim();
				Integer second = val2;

				Tuple2<String, Integer> pair = new Tuple2(first, second);
//				returnedData.add(pair);
				this.datatuple.add(pair);
			}
		}
		
//		this.datatuple = returnedData;
//		System.out.println(count_);
//		System.out.println(datatuple.size());
//		return returnedData;
	}
	
	public List<Tuple2<String, Integer>> gettuple(){
		return this.datatuple;
	}

	@Override
	public void run() {

		// TODO Auto-generated method stub

		if (action.equals("elastic")) {
			try {
				
				
//				System.out.println("Thread " + Thread.currentThread().getName() + " started");
				String source = null;
				JSONObject myResponse = term._makeElasticRequest(query, "POST", "/" + index + "/_search/?scroll=1m");
				if (null != myResponse.get("hits")) {

//				JSONArray jsonArray = new JSONArray();
					Object hits = myResponse.getJSONObject("hits").getJSONArray("hits");
					Object total = myResponse.getJSONObject("hits").getJSONObject("total").get("value");
					source = hits.toString();
//				System.out.println(total);

					JSONArray mergedArray = new JSONArray(source);
//				System.out.println("merged array length  -- >" + mergedArray.length());

					jsonArray = term.merge(jsonArray, mergedArray);

//					System.out.println("DONE");

				}

			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		} 
		if (action.equals("loop")) {
			try {
//				System.out.println("Thread " + Thread.currentThread().getName() + " started");
//				get(start,end, jsonArray, d); 
				Clustering cluster = new Clustering();
				wrangleDatadata(jsonArray, field, start, end);

			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

}

