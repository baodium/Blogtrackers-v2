import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;
import org.json.JSONArray;
import org.json.JSONObject;

import scala.Tuple2;
import util.DummyComparator;
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

	public ElasticRunnable(JSONObject query, JSONArray jsonArray, int start, int end,
			List<Tuple2<String, Integer>> datatuple, Map<String, Integer> d, String action) {
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

	public synchronized void get(int start, int end, JSONArray jsonArray, Map<String, Integer> data) throws Exception {
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

				if (count == null) {
					data.put(first, second);
				} else {
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

	}

	@Override
	public void run() {

		// TODO Auto-generated method stub

		if (action.equals("elastic")) {
			try {
				System.out.println("Thread " + Thread.currentThread().getName() + " started");

//		return null;
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

//					jsonArray = term.merge(jsonArray, mergedArray);

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
				get(start, end, jsonArray, d);

			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	public static List<Tuple2<String, Integer>> wrangleDatadata(ArrayList<String> array) {
		List<Tuple2<String, Integer>> returnedData = new ArrayList<Tuple2<String, Integer>>();
		String result = null;
		for (String s : array) {
			String val = s;
			result = val.replace("[", "").replace("]", "");
			String[] spl = result.split("\\),");
			System.out.println(spl.length);
			

			for (String v : spl) {
				String newstr = v.replace("(", "").replace(")", "");
				String[] tsplit = newstr.split(",");
				int val2 = Integer.parseInt(tsplit[1].trim());

				String first = tsplit[0].replace("\'", "").trim();
				Integer second = val2;

				Tuple2<String, Integer> pair = new Tuple2(first, second);
				returnedData.add(pair);
			}
		}
		return returnedData;
	}

	public static void main(String[] args) {
		List<Tuple2<String, Integer>> data = new ArrayList<Tuple2<String, Integer>>();
		String result = null;
		String s = "[('european', 20), ('europe', 18), ('united', 11), ('commission', 9), ('barroso', 9), ('ttip', 9), ('katainen', 9), ('global', 8), ('union', 8), ('atlantic', 7), ('growth', 6), ('president', 6), ('trade', 5), ('integration', 5), ('countries', 5), ('montanino', 5), ('kingdom', 5), ('deal', 4), ('standards', 4), ('private', 4), ('council', 4), ('investment', 4), ('rules', 3), ('economy', 3), ('transatlantic', 3), ('strengthen', 3), ('agreement', 3), ('business', 3), ('economics', 3), ('power', 3), ('challenges', 3), ('sector', 3), ('ashish', 3), ('kumar', 3), ('sides', 3), ('jobs', 3), ('fair', 3), ('economic', 3), ('program', 3), ('eizenstat', 3), ('moving', 3), ('migrant', 3), ('official', 2), ('vice', 2), ('jyrki', 2), ('negotiated', 2), ('stimulate', 2), ('provide', 2), ('work', 2), ('high', 2), ('companies', 2), ('minister', 2), ('plan', 2), ('juncker', 2), ('reform', 2), ('challenge', 2), ('group', 2), ('march', 2), ('write', 2), ('century', 2), ('level', 2), ('washington', 2), ('initiative', 2), ('andrea', 2), ('obama', 2), ('including', 2), ('migration', 2), ('prime', 2), ('strong', 2), ('called', 2), ('market', 2), ('today', 2), ('asked', 2), ('faces', 2), ('crisis', 2), ('british', 2), ('member', 2), ('greater', 2), ('precedent', 2), ('endpoint', 2), ('migrants', 2), ('2016', 1), ('bat', 1), ('senior', 1), ('negotiators', 1), ('year', 1), ('50', 1), ('linked', 1), ('chance', 1), ('deals', 1), ('meet', 1), ('representative', 1), ('michael', 1), ('negotiator', 1), ('negotiations', 1), ('economies', 1), ('compromising', 1), ('citizens', 1), ('showing', 1), ('spoke', 1)]";
		String s2 = "[('ukraine', 13), ('nemtsov', 9), ('putin', 8), ('russian', 8), ('russia', 8), ('democracy', 6), ('gershman', 6), ('kadyrov', 6), ('kremlin', 5), ('atlantic', 5), ('council', 5), ('activists', 4), ('exposing', 3), ('mark', 3), ('assassination', 3), ('human', 3), ('center', 3), ('security', 3), ('march', 3), ('role', 3), ('dobriansky', 3), ('opposition', 3), ('rights', 3), ('activist', 3), ('vladimir', 3), ('violence', 3), ('boris', 2), ('mikaila', 2), ('legacy', 2), ('project', 2), ('event', 2), ('2015', 2), ('presence', 2), ('discussion', 2), ('eurasia', 2), ('kirk', 2), ('remarks', 2), ('increasingly', 2), ('leader', 2), ('chechnya', 2), ('fear', 2), ('threat', 2), ('poliudova', 2), ('success', 2), ('remembering', 2), ('altenbern', 2), ('washington', 2), ('anniversary', 2), ('director', 2), ('people', 2), ('lies', 2), ('senate', 2), ('president', 2), ('national', 2), ('dinu', 2), ('patriciu', 2), ('panelists', 2), ('attack', 2), ('kara', 2), ('murza', 2), ('international', 2), ('report', 2), ('yashin', 2), ('party', 2), ('freedom', 2), ('death', 2), ('time', 2), ('conflict', 2), ('2016', 1), ('paula', 1), ('senior', 1), ('university', 1), ('board', 1), ('february', 1), ('moscow', 1), ('participated', 1), ('politician', 1), ('played', 1), ('documenting', 1), ('spoke', 1), ('caucus', 1), ('joined', 1), ('panel', 1), ('berschinski', 1), ('deputy', 1), ('assistant', 1), ('bureau', 1), ('carl', 1), ('endowment', 1), ('john', 1), ('ill', 1), ('chairman', 1), ('critic', 1), ('fight', 1), ('linked', 1), ('combination', 1), ('factors', 1), ('ramzan', 1), ('rogue', 1), ('coverage', 1)]";
		String s3 = "[('european', 24), ('europe', 18), ('union', 15), ('barroso', 13), ('countries', 9), ('britain', 7), ('crisis', 7), ('united', 6), ('kingdom', 6), ('migrant', 6), ('commission', 5), ('challenges', 5), ('eastern', 5), ('minister', 5), ('security', 5), ('time', 5), ('brexit', 5), ('prime', 5), ('enlargement', 5), ('greece', 5), ('crises', 4), ('challenge', 4), ('nato', 4), ('ashish', 4), ('kumar', 4), ('british', 4), ('national', 4), ('multiple', 3), ('leave', 3), ('cameron', 3), ('country', 3), ('year', 3), ('cope', 3), ('power', 3), ('danger', 3), ('leadership', 3), ('matter', 3), ('flank', 3), ('divisions', 3), ('president', 3), ('southern', 3), ('membership', 3), ('bloc', 3), ('interview', 3), ('euro', 3), ('appetite', 3), ('concerned', 3), ('difficult', 3), ('integration', 2), ('referendum', 2), ('deal', 2), ('jump', 2), ('dark', 2), ('existential', 2), ('atlanticist', 2), ('don', 2), ('refugee', 2), ('political', 2), ('systems', 2), ('accepted', 2), ('project', 2), ('point', 2), ('interests', 2), ('response', 2), ('responsibility', 2), ('putting', 2), ('pressure', 2), ('work', 2), ('greek', 2), ('march', 2), ('josé', 2), ('manuel', 2), ('flanks', 2), ('grapples', 2), ('facing', 2), ('case', 2), ('david', 2), ('brussels', 2), ('remain', 2), ('wise', 2), ('issue', 2), ('atlantic', 2), ('council', 2), ('diminish', 2), ('attraction', 2), ('respond', 2), ('impact', 2), ('mentioned', 2), ('uk', 2), ('hope', 2), ('thoughts', 2), ('experience', 2), ('future', 2), ('russia', 2), ('geopolitical', 2), ('2016', 1), ('walk', 1), ('vote', 1), ('june', 1), ('revamps', 1)]";

		ArrayList<String> arr = new ArrayList<String>();
		arr.add(s);
		arr.add(s2);
		arr.add(s3);
		
		data = wrangleDatadata(arr);
		try {
			System.out.println(term.mapReduce(data, "topterm"));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

}
