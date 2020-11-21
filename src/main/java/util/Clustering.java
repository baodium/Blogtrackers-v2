package util;

import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map.Entry;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.io.*;
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

import authentication.DbConnection;
import javafx.util.Pair;
import scala.Tuple2;

/**
 * Servlet implementation class Clustering
 */
@WebServlet("/CLUSTERING")
public class Clustering extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	/**
	 * 
	 */
	
	 Terms term = new Terms();

	public  String _getResult(String url, JSONObject jsonObj) throws Exception {
		new ArrayList<String>();
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

			con.getResponseCode();
			BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
			String inputLine;
			StringBuffer response = new StringBuffer();

			while ((inputLine = in.readLine()) != null) {
				response.append(inputLine);
			}
			in.close();

			myResponse = new JSONObject(response.toString());
			out = myResponse.toString();

		} catch (Exception ex) {
		}
		return out;

	}

	public  int getShardSize(JSONObject query, String index) {
		JSONObject myResponse = new JSONObject();
		int result = 0;
		try {
			myResponse = term._makeElasticRequest(query, "GET", "/" + index + "/_search_shards/");
			if (!(myResponse.getJSONObject("nodes") == null)) {
				result = myResponse.getJSONObject("nodes").length();
			}
		} catch (Exception e) {
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
			e.printStackTrace();
		}
		return result;
	}

	public  ArrayList<JSONObject> _buildSlicedScrollQuery(String ids, String from, String to, String type,
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

		ArrayList<JSONObject> result = new ArrayList<JSONObject>();
		String total = term._count(query, "/" + index + "/_count?");
		Integer.parseInt(total);

		int max = 132;
		for (int i = 0; i < max; i++) {
			String appendee = query.toString();
			String newquery = "{\r\n" + "\"size\":" + 1000 + "," + appendee.substring(1, appendee.length() - 1) + ","
					+ "\"slice\": {\r\n" + "    	      \"id\": " + String.valueOf(i) + ",\r\n" + "        \"max\": "
					+ String.valueOf(max) + "\r\n" + "    }}";
			result.add(new JSONObject(newquery));
		}
		return result;
	}

	public  List<JSONObject> getPosts(String ids, String from, String to, String type, String index)
			throws Exception {
		List<JSONObject> jsonArray;
		new HashMap<String, String>();

		List<Tuple2<String, Integer>> datatuple = Collections
				.synchronizedList(new ArrayList<Tuple2<String, Integer>>());

		ConcurrentHashMap<String, Integer> d = new ConcurrentHashMap<String, Integer>();

		int shardCount = getShardSize(new JSONObject(), index);

		List<JSONObject> jsonList = Collections.synchronizedList(new ArrayList<JSONObject>());
		ConcurrentHashMap<String, ConcurrentHashMap<String, String>> datatuple3 = new ConcurrentHashMap<String, ConcurrentHashMap<String, String>>();
		ExecutorService executorServiceBlogSiteIds = Executors.newFixedThreadPool(shardCount);
		int start_test = 0;
		if (type.contentEquals("__ONLY__POST__ID__")) {
			jsonArray = new ArrayList<JSONObject>();
			for (JSONObject q : _buildSlicedScrollQuery(ids, from, to, type, index)) {
				int start1 = 0;
				int end = 0;
				RunnableUtil esR2 = new RunnableUtil(q, jsonArray, start1, end, datatuple, d, "elastic", index, "post",
						jsonList, datatuple3);
				executorServiceBlogSiteIds.execute(esR2);
			}
		} else if (type.contentEquals("__ONLY__TERMS__")) {
			jsonArray = new ArrayList<JSONObject>();
			for (JSONObject q : _buildSlicedScrollQuery(ids, from, to, type, index)) {
				int start1 = 0;
				int end = 0;
				RunnableUtil esR2 = new RunnableUtil(q, jsonArray, start1, end, datatuple, d, "elastic", index, "terms",
						jsonList, datatuple3);
				executorServiceBlogSiteIds.execute(esR2);
			}
		} else if (type.contentEquals("__ONLY__TERMS__BLOGSITE_IDS__")) {
			jsonArray = new ArrayList<JSONObject>();
			for (JSONObject q : _buildSlicedScrollQuery(ids, from, to, type, index)) {
				int end = 0;
				RunnableUtil esR2 = new RunnableUtil(q, jsonArray, start_test, end, datatuple, d, "elastic", index,
						"terms", jsonList, datatuple3);
				executorServiceBlogSiteIds.execute(esR2);
			}
		} else if (type.contentEquals("__ONLY__TERMS__BLOGGERS")) {
			jsonArray = new ArrayList<JSONObject>();
			for (JSONObject q : _buildSlicedScrollQuery(ids, from, to, type, index)) {
				int start1 = 0;
				int end = 0;
				RunnableUtil esR2 = new RunnableUtil(q, jsonArray, start1, end, datatuple, d, "elastic", index, "terms",
						jsonList, datatuple3);
				executorServiceBlogSiteIds.execute(esR2);
			}
		} else if (type.contains("__TERMS__KEYWORD__")) {
			jsonArray = new ArrayList<JSONObject>();
			for (JSONObject q : _buildSlicedScrollQuery(ids, from, to, type, index)) {
				int start1 = 0;
				int end = 0;

				RunnableUtil esR2 = new RunnableUtil(q, jsonArray, start1, end, datatuple, d, "elastic", index, "terms",
						jsonList, datatuple3);
				executorServiceBlogSiteIds.execute(esR2);
			}
		}

		executorServiceBlogSiteIds.shutdown();
		while (!executorServiceBlogSiteIds.isTerminated()) {
		}

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

	public  String getBloggersMentioned(String postIds) throws Exception {
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
						value.toString();
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

		double res = ((double) count / total) * 100;
		result = String.valueOf(Math.round(res)) + "%";

		return result;
	}

	public ArrayList<String> getPostsByPostIds(String postIds) throws Exception {
		List<JSONObject> jsonArray = new ArrayList<JSONObject>();
		ArrayList<String> result = new ArrayList<String>();
		List<Tuple2<String, Integer>> datatuple = new ArrayList<Tuple2<String, Integer>>();
		ConcurrentHashMap<String, Integer> d = new ConcurrentHashMap<String, Integer>();

		int shardCount = this.getShardSize(new JSONObject(), "blogposts");

		ExecutorService executorServiceBlogPostIds = Executors.newFixedThreadPool(shardCount + 1);
		for (JSONObject q : this._buildSlicedScrollQuery(postIds, "", "", "__ONLY__POST__ID__", "blogposts")) {
			int start1 = 0;
			int end = 0;
			RunnableUtil esR2 = new RunnableUtil(q, jsonArray, start1, end, datatuple, d, "elastic", "blogposts",
					"post");
			executorServiceBlogPostIds.execute(esR2);
		}

		executorServiceBlogPostIds.shutdown();
		while (!executorServiceBlogPostIds.isTerminated()) {
		}

		new JSONObject();
		for (int i = 0; i < jsonArray.size(); i++) {
			JSONObject t = new JSONObject(jsonArray.get(i));
			Object post = t.getJSONObject("_source").get("post");
			result.add(post.toString());
		}

		return result;
	}

	public  ArrayList _getClusters(String tid) throws Exception {

		DbConnection db = new DbConnection();
		ArrayList result = new ArrayList();
		try {
			result = db.queryJSON("SELECT *  FROM clusters WHERE tid = '" + tid + "'");

		} catch (Exception e) {
			return result;
		}
		return result;

	}

	public  ArrayList _getSvd(String postids) throws Exception {

		DbConnection db = new DbConnection();
		ArrayList result = new ArrayList();
		try {
			result = db.queryJSON("SELECT *  FROM cluster_svd WHERE post_id in ( " + postids + ")");

		} catch (Exception e) {
			return result;
		}

		return result;

	}

	public  JSONObject topTerms(List postDataAll, String limit) {
		JSONObject res = new JSONObject();
		JSONArray output = new JSONArray();

		int a = postDataAll.size();
		int b = 1000;
		int poolsize = ((a / b)) > 0 ? (a / b) + 1 : 1;

		ExecutorService executorServiceSplitLoop = Executors.newFixedThreadPool(poolsize);
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

			JSONObject q = new JSONObject();
			RunnableUtil es = new RunnableUtil(q, postDataAll, start1, end_, returnedData, datatuple2, d, "loop",
					"blogpost_terms", "terms", buffer, datatuple3);
			executorServiceSplitLoop.execute(es);
		}

		executorServiceSplitLoop.shutdown();
		while (!executorServiceSplitLoop.isTerminated()) {
		}

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

		}
		res.put("output", output);
		res.put("post_id_term_pair", datatuple2);
		res.put("post_id_post", datatuple3);
		return res;
	}

	public  String getTopTermsFromBlogIds(String ids, String from, String to, String limit) throws Exception {
		JSONArray output = new JSONArray();
		String query = "select n.term, sum(n.occurr) occurrence " + "from blogpost_terms_api, "
				+ "json_table(terms_test, " + "'$[*]' columns( " + "term varchar(128) path '$.term', "
				+ "occurr int(11) path '$.occurrence' " + ") " + ") " + "as n " + "where blogsiteid in  (" + ids
				+ ") and date > \"" + from + "\" and date < \"" + to + "\" " + "group by n.term "
				+ "order by occurrence desc " + "limit " + limit + "";

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

	public  String getTopTermsFromDashboard(String ids, String from, String to, String limit) throws Exception {
		List postDataAll = DbConnection.queryJSON("select * from blogpost_terms where blogsiteid in  (" + ids
				+ ") and date > \"" + from + "\" and date < \"" + to + "\"");
		JSONObject o = topTerms(postDataAll, limit);

		return o.get("output").toString();
	}

	public  String getTopTermsBlogger(String bloggers, String from, String to, String limit) throws Exception {
		String result = null;

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

	public  String getTopTermsFromBlogIds2(String ids, String from, String to, String limit) throws Exception {
		String result = null;

		List<JSONObject> postDataAll = getPosts(ids, from, to, "__ONLY__TERMS__BLOGSITE_IDS__", "blogpost_terms");

		return result;
	}

	
	/**
	 * @see HttpServlet#HttpServlet()
	 */

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

		Pair<String, String> key_val = new Pair<String, String>(null, null);
		String cluster_ = cluster.toString();
		String post_ids = key_val_posts.get(cluster_);

		key_val = new Pair<String, String>(cluster_, post_ids);

		Object total = (null == session.getAttribute(tid.toString() + "clusters_total")) ? ""
				: session.getAttribute(tid.toString() + "clusters_total");

		Object topterms_object = (null == session.getAttribute(tid.toString() + "cluster_terms")) ? ""
				: session.getAttribute(tid.toString() + "cluster_terms");

		HashMap<String, String> topterms = (HashMap<String, String>) topterms_object;

		String blogdistribution = null;
		String bloggersMentioned = null;
		String topPostingLocation = null;
		ArrayList<JSONObject> postData = new ArrayList<JSONObject>();

		try {
			blogdistribution = this.getBlogDistribution(post_ids, (double) Integer.parseInt(total.toString()));
			bloggersMentioned = this.getBloggersMentioned(post_ids);
			topPostingLocation = this.getTopPostingLocation(post_ids);
			postData = clusterResult.get(key_val);
		} catch (NumberFormatException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
//			 TODO Auto-generated catch block
			e.printStackTrace();
		}

		PrintWriter out = response.getWriter();

		if (action.toString().equals("loadblogdistribution")) {
			out.write(blogdistribution);
		} else if (action.toString().equals("loadpostmentioned")) {
			out.write(this.totalposts.replace(".0", ""));
		} else if (action.toString().equals("loadbloggersmentioned")) {
			out.write(bloggersMentioned);
		} else if (action.toString().equals("loadpostinglocation")) {
			out.write(topPostingLocation);
		} else if (action.toString().equals("loadtitletable")) {
			JSONObject post_distances_all = new JSONObject();
			post_distances_all.put("distances", new JSONObject(distances.toString()));
			post_distances_all.put("post_data", new JSONArray(postData.toString()));
			out.write(post_distances_all.toString());
		} else if (action.toString().equals("loadkeywords")) {
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
	}

}
