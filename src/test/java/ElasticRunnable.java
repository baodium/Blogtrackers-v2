import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

import scala.Tuple2;
import util.Terms;

public class ElasticRunnable implements Runnable {

	private JSONObject query;
	public JSONArray jsonArray;
	public String action;
	public List<Tuple2<String, Integer>> datatuple = new ArrayList<Tuple2<String, Integer>>();
	public int start;
	public int end;
	public Map<String, Integer> d = new HashMap<String, Integer>();

	Map<Integer, JSONArray> res = new HashMap<Integer, JSONArray>();

	public ElasticRunnable(JSONObject query, JSONArray jsonArray, int start, int end, List<Tuple2<String, Integer>> datatuple, Map<String, Integer> d,String action) {
		this.query = query;
		this.jsonArray = jsonArray;
		this.action = action;
		this.start = start;
		this.end = end;
		this.datatuple = datatuple;
		this.d = d;

	}

//	public ElasticRunnable(int start, int end, List<Tuple2<String, Integer>> datatuple, String action) {
//		
//	}

	static Terms term = new Terms();

//	public int _getArraySize() {
//		return this.jsonArray.length();
//	}
	
	public synchronized void  get(int start, int end, JSONArray jsonArray, Map<String, Integer> data) throws Exception{
		String blogsiteid = null;
		String blogpost_id = null;
		String terms = null;
		String result = null;
		String topterm = null;
		String date = null;

//		List<Tuple2<String, Integer>> data = new ArrayList<Tuple2<String, Integer>>();

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
				
				String first = tsplit[0].replace("\'", "").trim();
				Integer second = val2;
				
				Integer count = d.get(first);
				
				if(count == null) {
					data.put(first, second);
				}else {
					data.put(first, second + 1);
				}

//				Tuple2<String, Integer> pair = new Tuple2(tsplit[0].replace("\'", "").trim(), val2);
//				datatuple.add(pair);
			});

//			this.datatuple = data;
			topterm = j2.get("topterm").toString();

//			Object date_json = j1.getJSONObject("fields").getJSONArray("date").get(0);
//			date = date_json.toString();
		}
		
		
		
//		return null;
		 
	}

	@Override
	public void run() {

		// TODO Auto-generated method stub

		if (action.equals("elastic")) {
			try {
				System.out.println("Thread " + Thread.currentThread().getName() + " started");
				String source = null;
				JSONObject myResponse = term._makeElasticRequest(query, "POST", "/blogpost_terms/_search/?scroll=1m");
				if (null != myResponse.get("hits")) {

//				JSONArray jsonArray = new JSONArray();
					Object hits = myResponse.getJSONObject("hits").getJSONArray("hits");
					Object total = myResponse.getJSONObject("hits").getJSONObject("total").get("value");
					source = hits.toString();
//				System.out.println(total);

					JSONArray mergedArray = new JSONArray(source);
//				System.out.println("merged array length  -- >" + mergedArray.length());

					jsonArray = term.merge(jsonArray, mergedArray);

					System.out.println("DONE GETTING POSTS FOR BLOGGER");

				}

			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		} 
		if (action.equals("loop")) {
			try {
				System.out.println("Thread " + Thread.currentThread().getName() + " started");
				get(start,end, jsonArray, d); 

			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

}
