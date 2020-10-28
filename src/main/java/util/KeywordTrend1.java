package util;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.Duration;
import java.time.Instant;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import authentication.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;

import static java.util.stream.Collectors.toMap;

/**
 * Servlet implementation class KeywordTrend
 */
//@WebServlet("/KeywordTrend1")
public class KeywordTrend1 extends HttpServlet {

	private static final long serialVersionUID = 1L;
	static Terms term = new Terms();

	/**
	 * Custom query to compute all posts and other details where most active term occurs
	 * 
	 * @param mostactiveterm query string for most active term
	 * @param date_start query string for start date range
	 * @param date_end query string for end of date range
	 * @param all_blog_ids query string for all selected blog_ids
	 * @param limit query string for limit to display
	 * @return JSONObject result
	 */
	public static JSONObject getBloggerTerms(String mostactiveterm, String date_start, String date_end, String all_blog_ids, int limit) {
		Blogposts post = new Blogposts();
		JSONObject result = new JSONObject();
		try {
			JSONObject sql = post._getBloggerPosts(mostactiveterm, "NOBLOGGER", date_start,date_end.toString(), all_blog_ids,limit);
			result = sql;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * Custom query to count of number of posts where terms occur
	 * 
	 * @param terms query string for most active term
	 * @param ids query string for all selected blog_ids
	 * @param from query string for start date range
	 * @param to  query string for end of date range
	 * @param index query string for selected index or table
	 * @return String result
	 */
	public static String getPostsMentioned(String terms, String ids, String from, String to, String index)
			throws Exception {
		String result = null;
		JSONObject query = new JSONObject();
		query = new JSONObject("{\r\n" + "   \r\n" + "    \"query\": {\r\n" + "        \"bool\": {\r\n"
				+ "            \"must\": [\r\n" + "                {\r\n" + "                    \"terms\": {\r\n"
				+ "                        \"post\": [\r\n" + "							"+terms+"\r\n"
				+ "                        ]\r\n" + "                    }\r\n" + "                },\r\n"
				+ "                {\r\n" + "                    \"terms\": {\r\n"
				+ "                        \"blogsite_id\": ["+ids+"],\r\n"
				+ "                        \"boost\": 1\r\n" + "                    }\r\n" + "                },\r\n"
				+ "                {\r\n" + "                    \"range\": {\r\n"
				+ "                        \"date\": {\r\n"
				+ "                            \"from\": \""+from+"\",\r\n"
				+ "                            \"to\": \""+to+"\",\r\n"
				+ "                            \"include_lower\": true,\r\n"
				+ "                            \"include_upper\": true,\r\n"
				+ "                            \"boost\": 1\r\n" + "                        }\r\n"
				+ "                    }\r\n" + "                }\r\n" + "            ]\r\n" + "        }\r\n"
				+ "    }\r\n" + "}");
		result = term._count(query, "/" + index + "/_count?");
		return result;
	}

	/**
	 * Custom Elasticsearch query to perform aggregation
	 * 
	 * @param terms query string for most active term
	 * @param ids query string for all selected blog_ids
	 * @param from query string for start date range
	 * @param to  query string for end of date range
	 * @param index query string for selected index or table
	 * @param field query string for field
	 * @param sort query string for field to sort on
	 * @param type query string for type of aggregation (e.g bucket_highest, bucket_length)
	 * @return String result
	 */
	public static String aggregation(String terms, String ids, String from, String to, String index, String field, String sort, String type)
			throws Exception {
		String result = null;
		JSONObject query = new JSONObject();
		query = new JSONObject("{\r\n" + "    \"size\": 0,\r\n" + "    \r\n" + "    \"query\": {\r\n"
				+ "        \"bool\": {\r\n" + "            \"must\": [\r\n" + "                {\r\n"
				+ "                    \"terms\": {\r\n" + "                        \"post\": [\r\n"
				+ "                            " + terms + "\r\n" + "                        ]\r\n"
				+ "                    }\r\n" + "                },\r\n" + "                {\r\n"
				+ "                    \"terms\": {\r\n" + "                        \"blogsite_id\": [" + ids + "],\r\n"
				+ "                        \"boost\": 1\r\n" + "                    }\r\n" + "                },\r\n"
				+ "                {\r\n" + "                    \"range\": {\r\n"
				+ "                        \"date\": {\r\n" + "                            \"from\": \"" + from
				+ "\",\r\n" + "                            \"to\": \"" + to + "\",\r\n"
				+ "                            \"include_lower\": true,\r\n"
				+ "                            \"include_upper\": true,\r\n"
				+ "                            \"boost\": 1\r\n" + "                        }\r\n"
				+ "                    }\r\n" + "                }\r\n" + "            ]\r\n" + "        }\r\n"
				+ "    },\r\n" + "    \"aggregations\": {\r\n" + "        \"groupby\": {\r\n"
				+ "            \"composite\": {\r\n" + "                \"size\": 1000,\r\n"
				+ "                \"sources\": [\r\n" + "                    {\r\n"
				+ "                        \"dat\": {\r\n" + "                            \"terms\": {\r\n"
				+ "                                \"field\": \""+field+"\",\r\n"
				+ "                                \"missing_bucket\": false,\r\n"
				+ "                                \"order\": \""+sort+"\"\r\n" + "                            }\r\n"
				+ "                        }\r\n" + "                    }\r\n" + "                ]\r\n"
				+ "            }\r\n" + "        }\r\n" + "    }\r\n" + "}");

		JSONObject myResponse = term._makeElasticRequest(query, "POST", "/" + index + "/_search/?");
		if (null != myResponse.get("hits")) {

			Object key = null;
			Object value = null;
			
			String key_result = null;
			String value_result = null;
			
			if(type.contentEquals("bucket_length")) {
				Object bucket_length = myResponse.getJSONObject("aggregations").getJSONObject("groupby")
						.getJSONArray("buckets").length();
				result = bucket_length.toString();
			}else if(type.contentEquals("bucket_highest")) {
				Object k = myResponse.getJSONObject("aggregations").getJSONObject("groupby").getJSONArray("buckets");
				int lenght_of_array = new JSONArray(k.toString()).length();
				if(lenght_of_array > 0) {
					int current_max = 0;
					for(int i = 0; i < lenght_of_array; i++) {
						key = ((JSONArray) k).getJSONObject(i).getJSONObject("key").get("dat");
						value = myResponse.getJSONObject("aggregations").getJSONObject("groupby").getJSONArray("buckets").getJSONObject(i).get("doc_count");
						
						if(!key.equals("null") && !key.equals(null)) {
							if(Integer.parseInt(value.toString()) >= current_max){
								current_max = Integer.parseInt(value.toString());
								key_result = key.toString();
								value_result = value.toString();
							}
						}
						
					}
					
					result = key_result + "___" + value_result;
				}else {
					result = "NO DATA AVAILABLE" + "___" + "0";
				}
				
				
			}
			

		}
		return result;
	}

	/**
	 * @see HttpServlet#HttpServlet()
	 * 
	 * 
	 * 
	 *      /**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		String tid = null;
		Object json_type_2 = null;

		if (null == session.getAttribute("email")) {
		} else {
			session.getAttribute("email");
		}

		if (null == session.getAttribute("username")) {
		} else {
			session.getAttribute("username");
		}
		if (null == session.getAttribute("user")) {
		} else {
			session.getAttribute("user");
		}
		if (null == session.getAttribute("top_terms")) {
		} else {
			session.getAttribute("top_terms");
		}
		// TODO Auto-generated method stub
		// Get all parameters from post request
		String date_start = (null == request.getParameter("date_start")) ? "" : request.getParameter("date_start");
		String date_end = (null == request.getParameter("date_end")) ? "" : request.getParameter("date_end");
		String mostactiveterm = (null == request.getParameter("term")) ? "" : request.getParameter("term").toString();

		String all_selected_terms = (null == request.getParameter("all_selected_names")) ? ""
				: request.getParameter("all_selected_names").toString();

		Object index = (null == request.getParameter("index")) ? "" : request.getParameter("index");

		if (null == request.getParameter("sort")) {
		} else {
			request.getParameter("sort");
		}
		String action = (null == request.getParameter("action")) ? "" : request.getParameter("action");
		if (null == request.getParameter("id")) {
		} else {
			request.getParameter("id");
		}
		tid = (null == request.getParameter("tid")) ? "" : request.getParameter("tid");
		json_type_2 = (null == session.getAttribute(tid.toString())) ? "" : session.getAttribute(tid.toString());
		String all_blog_ids = (null == request.getParameter("all_blog_ids")) ? ""
				: request.getParameter("all_blog_ids");

		Blogposts post = new Blogposts();

		String top_location = null;
		String posts = null;

		String result_blogmentioned = null;
		new JSONObject();
		String result_posts = null;
		JSONObject sql = new JSONObject();

		List<HashMap<String, Integer>> items = new ArrayList<>();

		// Get number of blogs mentioned
		if (action.toString().equals("getblogmentioned")) {
			try {
				PrintWriter out = response.getWriter();
				String t_ = mostactiveterm.toString();
				result_blogmentioned = aggregation(t_, all_blog_ids, date_start, date_end, "blogposts","blogsite_id","asc","bucket_length");

				out.write(result_blogmentioned.toString());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} 
		// Get most location
		else if (action.toString().equals("getmostlocation")) {
			PrintWriter out = response.getWriter();
			try {
				String t_ = mostactiveterm.toString();
				top_location = aggregation(t_, all_blog_ids, date_start, date_end, "blogposts","location","desc","bucket_highest");
				
			} catch (Exception e) {

				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			if(top_location != null) {
				out.write(top_location.toString());
			}else {
				out.write("NO DATA AVAILABLE");
			}
			

		} 
		
		// Get number of posts mentioned
		else if (action.toString().equals("getmostpost")) {
			try {
				PrintWriter out = response.getWriter();
				String t_ = mostactiveterm.toString();
				result_posts = getPostsMentioned(t_, all_blog_ids, date_start, date_end, "blogposts");
				out.write(result_posts.toString());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} 

		// Populate terms table
		else if (action.toString().equals("gettermtable")) {
			try {
				PrintWriter out = response.getWriter();
				json_type_2 = (null == session.getAttribute(tid.toString())) ? ""
						: session.getAttribute(tid.toString());
				if (null != json_type_2 || "" != json_type_2) {

					Map<String, Integer> json = (HashMap<String, Integer>) json_type_2;

					Map.Entry<String, Integer> entry1 = json.entrySet().iterator().next();

					Iterator<Map.Entry<String, Integer>> itr = json.entrySet().iterator();

					JSONObject posts_occured_data = new JSONObject();

					JSONArray all = new JSONArray();
					JSONObject all_ = new JSONObject();

					entry1.getValue();

					String t_ = null;
					Integer blog_mentioned_ = null;

					for (int i = 0; i < 500; i++) {
						Map.Entry<String, Integer> key_ = itr.next();
						String key = key_.getKey();
						try {
							t_ = post._countPostMentioned(key, date_start.toString(), date_end.toString(),
									all_blog_ids.toString());
							blog_mentioned_ = post._getBlogOrPostMentioned("blogsite_id", key, date_start.toString(),
									date_end.toString(), all_blog_ids.toString());
							posts_occured_data = new JSONObject();
							posts_occured_data.put("term", key);
							posts_occured_data.put("frequency", key_.getValue());
							posts_occured_data.put("post_count", t_);
							posts_occured_data.put("blog_count", blog_mentioned_);

							all.put(posts_occured_data);
							all_ = new JSONObject(all);
							all_.put("data", all);

						} catch (Exception e) {

						}

					}
					session.setAttribute(tid.toString() + "_termtable", all_.toString());
					out.write(all_.toString());
				}
			} catch (Exception e) {

			}
		} 
		// Get trend data for line graph
		else if (action.toString().equals("line_graph")) {

			try {
				PrintWriter out = response.getWriter();

				JSONObject result = new JSONObject();
				sql = post._getBloggerPosts(mostactiveterm, "NOBLOGGER", date_start.toString(), date_end.toString(),
						all_blog_ids.toString(),500);

				new JSONObject();
				if (sql.getJSONArray("data").length() > 0) {
					String j = null;
					String title = null;
					String date = null;
					Integer occurence = null;
					HashMap<String, Integer> hm2 = new HashMap<String, Integer>();

					sql.get("data").toString();
					for (int i = 0; i < sql.getJSONArray("data").length(); i++) {
						Object jsonArray = sql.getJSONArray("data").get(i);

						j = jsonArray.toString();
						JSONObject j_ = new JSONObject(j);
						j_.get("permalink").toString();
						title = j_.get("title").toString();
						j_.get("blogpost_id").toString();
						date = j_.get("date").toString();
						j_.get("num_comments").toString();
						j_.get("blogger").toString();
						posts = j_.get("post").toString();
						occurence = (Integer) j_.get("occurence");

						DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
								Locale.ENGLISH);
						DateTimeFormatter.ofPattern("dd-MM-yyy", Locale.ENGLISH);
						LocalDate date_ = LocalDate.parse(date, inputFormatter);
						Integer d = date_.getYear();

						hm2 = new HashMap<String, Integer>();
						hm2.put(d.toString(), (Integer) occurence);

						items.add(i, hm2);

						all_selected_terms.split(",");

						String replace = "<span style=background:red;color:#fff>" + mostactiveterm + "</span>";
						String active2 = mostactiveterm.substring(0, 1).toUpperCase()
								+ mostactiveterm.substring(1, mostactiveterm.length());
						String active3 = mostactiveterm.toUpperCase();

						posts = posts.replaceAll(mostactiveterm, replace);
						posts = posts.replaceAll(active2, replace);
						posts = posts.replaceAll(active3, replace);

						title = title.replaceAll(mostactiveterm, replace);
						title = title.replaceAll(active2, replace);
						title = title.replaceAll(active3, replace);

					}

				}

				Map<String, Integer> json = (HashMap<String, Integer>) items.stream()
						.flatMap(m -> m.entrySet().stream())
						.collect(toMap(Map.Entry::getKey, Map.Entry::getValue, Integer::sum));

				JSONObject mapped = new JSONObject(json);

				result.put("values", mapped);
				result.put("name", mostactiveterm);
				result.put("index", index);

				out.write(result.toString());
			} 
			catch (Exception e) {

			}
		}
		// Get data for keyword trend
		else if (action.toString().equals("getgraphdata")) {
			DbConnection db = new DbConnection();
			PrintWriter out = response.getWriter();
			mostactiveterm = mostactiveterm.toLowerCase();
			String q = "SELECT post, title, blogpost_id, date, \r\n" + 
					"ROUND ((LENGTH(lower(post)) - LENGTH(REPLACE (lower(post), \""+mostactiveterm+"\", \"\"))) / LENGTH(\""+mostactiveterm+"\")) AS count\r\n" + 
					"from (select *\r\n" + 
					"from blogposts\r\n" + 
					"where match (title,post)\r\n" + 
					"against (\""+mostactiveterm+"\" IN BOOLEAN MODE)) a\r\n" + 
					"where blogsite_id\r\n" + 
					"in ("+all_blog_ids.toString()+")\r\n" + 
					"\r\n";
			HashMap result = db.queryKWT(q);
			JSONObject result_final = new JSONObject();
			if(result.get("KWT") != null) {
				result_final.put("details", result.get("KWT"));
			}else {
				result_final.put("details", "NO DATA AVAILABLE FOR THIS KEYWORD IN THIS TRACKER");
			}
			out.write(result_final.toString());
			
			
		}
	}

	public static void main(String[] args) {
		Instant start = Instant.now();
		new Clustering();
		try {
			String mostactiveterm = "people";
			String all_blog_ids = "1,2,5,88,9,200";
			
			DbConnection db = new DbConnection();
			String q = "SELECT post, title, blogpost_id, date, \r\n" + 
					"ROUND ((LENGTH(lower(post)) - LENGTH(REPLACE (lower(post), \""+mostactiveterm+"\", \"\"))) / LENGTH(\""+mostactiveterm+"\")) AS count\r\n" + 
					"from (select *\r\n" + 
					"from blogposts\r\n" + 
					"where match (title,post)\r\n" + 
					"against (\""+mostactiveterm+"\" IN BOOLEAN MODE)) a\r\n" + 
					"where blogsite_id\r\n" + 
					"in ("+all_blog_ids.toString()+")\r\n" + 
					"\r\n";
			HashMap result = db.queryKWT(q);
			HashMap result_final = new HashMap();
			result_final.put(mostactiveterm, result.get("KWT"));
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Instant end = Instant.now();
		Duration timeElapsed = Duration.between(start, end);
		System.out.println("Time taken: " + timeElapsed.getSeconds() + " seconds");
	}

}
