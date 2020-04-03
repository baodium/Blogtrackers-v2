package util;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.NumberFormat;
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

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;

import static java.util.stream.Collectors.toMap;
import java.io.OutputStreamWriter;

/**
 * Servlet implementation class KeywordTrend
 */
//@WebServlet("/KeywordTrend1")
public class KeywordTrend1 extends HttpServlet {

	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 * 
	 * 
	 * 
	 *      /**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	static Terms term = new Terms();

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
System.out.println(query);
		result = term._count(query, "/" + index + "/_count?");
		return result;
	}

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
				+ "                                \"missing_bucket\": true,\r\n"
				+ "                                \"order\": \""+sort+"\"\r\n" + "                            }\r\n"
				+ "                        }\r\n" + "                    }\r\n" + "                ]\r\n"
				+ "            }\r\n" + "        }\r\n" + "    }\r\n" + "}");
System.out.println(query);
System.out.println(index);
		JSONObject myResponse = term._makeElasticRequest(query, "POST", "/" + index + "/_search/?");
		if (null != myResponse.get("hits")) {

//		JSONArray jsonArray = new JSONArray();
			
			if(type.contentEquals("bucket_length")) {
				Object bucket_length = myResponse.getJSONObject("aggregations").getJSONObject("groupby")
						.getJSONArray("buckets").length();
				result = bucket_length.toString();
			}else if(type.contentEquals("bucket_highest")) {
				Object key = myResponse.getJSONObject("aggregations").getJSONObject("groupby").getJSONArray("buckets").getJSONObject(0).getJSONObject("key").get("dat");
				Object value = myResponse.getJSONObject("aggregations").getJSONObject("groupby").getJSONArray("buckets").getJSONObject(0).get("doc_count");
				
				result = key.toString() + "___" + value.toString();
			}
			

		}
		return result;
	}

	public static void main(String[] args) {
		Instant start = Instant.now();
		Clustering terms = new Clustering();
		String ids = "813,815,809,811,812,806,808,817,644,652,616,641,732,761,709,128";
		String from = "1970-01-01";
		String to = "2020-03-26";
		try {
			String t_ = "\"opens" + "\",\"seun\"";
			String t = "__TERMS__KEYWORD__" + t_;
			System.out.println("__TERMS__KEYWORD__" + t);

//			Clustering._buildSlicedScrollQuery(ids, from, to, t,"blogposts");
			Clustering.getPosts(ids, from, to, t, "blogposts");
//			System.out.println(aggregation(t_, ids, from, to, "blogposts","location","desc","bucket_highest"));
//			System.out.println(aggregation(t_, ids, from, to, "blogposts","blogsite_id","asc","bucket_length"));
//			System.out.println(getPostsMentioned(t_, ids, from, to, "blogposts"));
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Instant end = Instant.now();
		Duration timeElapsed = Duration.between(start, end);
		System.out.println("Time taken: " + timeElapsed.getSeconds() + " seconds");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		String tid = null;
		Object json_type_2 = null;

		Object email = (null == session.getAttribute("email")) ? "" : session.getAttribute("email");

		Object user = (null == session.getAttribute("username")) ? "" : session.getAttribute("username");
		Object userid = (null == session.getAttribute("user")) ? "" : session.getAttribute("user");
		Object termites = (null == session.getAttribute("top_terms")) ? "" : session.getAttribute("top_terms");
		// TODO Auto-generated method stub
		String date_start = (null == request.getParameter("date_start")) ? "" : request.getParameter("date_start");
		String date_end = (null == request.getParameter("date_end")) ? "" : request.getParameter("date_end");
		String mostactiveterm = (null == request.getParameter("term")) ? "" : request.getParameter("term").toString();

		String all_selected_terms = (null == request.getParameter("all_selected_names")) ? ""
				: request.getParameter("all_selected_names").toString();

		Object index = (null == request.getParameter("index")) ? "" : request.getParameter("index");

		String sort = (null == request.getParameter("sort")) ? "" : request.getParameter("sort");
		String action = (null == request.getParameter("action")) ? "" : request.getParameter("action");
		String id = (null == request.getParameter("id")) ? "" : request.getParameter("id");
		tid = (null == request.getParameter("tid")) ? "" : request.getParameter("tid");
		json_type_2 = (null == session.getAttribute(tid.toString())) ? "" : session.getAttribute(tid.toString());
		String all_blog_ids = (null == request.getParameter("all_blog_ids")) ? ""
				: request.getParameter("all_blog_ids");

		Blogposts post = new Blogposts();

		System.out.println(date_start.toString());
		System.out.println(tid.toString() + json_type_2.toString() + action.toString() + mostactiveterm.toString()
				+ date_start.toString() + date_end.toString() + all_blog_ids.toString());

		Integer blog_mentioned = null;
		String top_location = null;
		String posts = null;

		String result_blogmentioned = null;
		JSONObject result_location = new JSONObject();
		String result_posts = null;
		JSONObject sql = new JSONObject();

		String sql__ = null;
		List<HashMap<String, Integer>> items = new ArrayList<>();

		if (action.toString().equals("getblogmentioned")) {
			try {
				System.out.println("i am here----");
				PrintWriter out = response.getWriter();
				System.out.println("mostactiveterm----"+mostactiveterm);
				String t_ = "\"" + mostactiveterm.toString() + "\"";
				String t = "__TERMS__KEYWORD__" + t_;
				result_blogmentioned = aggregation(t_, all_blog_ids, date_start, date_end, "blogposts","blogsite_id","asc","bucket_length");

				out.write(result_blogmentioned.toString());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
//		doGet(request, response);
		} else if (action.toString().equals("getmostlocation")) {
			PrintWriter out = response.getWriter();
			try {
				String t_ = "\"" + mostactiveterm.toString() + "\"";
				String t = "__TERMS__KEYWORD__" + t_;
				top_location = aggregation(t_, all_blog_ids, date_start, date_end, "blogposts","location","desc","bucket_highest");
			} catch (Exception e) {

				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			out.write(top_location.toString());

		} else if (action.toString().equals("getmostpost")) {
			try {
				PrintWriter out = response.getWriter();
				String t_ = "\"" + mostactiveterm.toString() + "\"";
				String t = "__TERMS__KEYWORD__" + t_;
				result_posts = getPostsMentioned(t_, all_blog_ids, date_start, date_end, "blogposts");
				out.write(result_posts.toString());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} else if (action.toString().equals("gettermtable")) {
			try {
				PrintWriter out = response.getWriter();
				json_type_2 = (null == session.getAttribute(tid.toString())) ? ""
						: session.getAttribute(tid.toString());
				if (null != json_type_2 || "" != json_type_2) {

					Map<String, Integer> json = (HashMap<String, Integer>) json_type_2;

					Map.Entry<String, Integer> entry1 = json.entrySet().iterator().next();

					Iterator<Map.Entry<String, Integer>> itr = json.entrySet().iterator();

					System.out.println("I entered--" + tid.toString());

					JSONObject posts_occured_data = new JSONObject();

					JSONArray all = new JSONArray();
					JSONObject all_ = new JSONObject();

					Integer keyword_count = entry1.getValue();

					String t_ = null;
					Integer blog_mentioned_ = null;

					for (int i = 0; i < 500; i++) {
						/* while(keys_.hasNext()) { */
						Map.Entry<String, Integer> key_ = itr.next();
						String key = key_.getKey();
						// System.out.println("values2--"+key+"NOBLOGGER"+","+json.get(key)+","+dt+","+
						// dte+","+ids);
						try {
							// JSONObject t = post._getBloggerPosts(key, "NOBLOGGER",
							// date_start.toString(),date_end.toString(), all_blog_ids.toString());
							t_ = post._countPostMentioned(key, date_start.toString(), date_end.toString(),
									all_blog_ids.toString());
							// t_ = t.get("total").toString();
							blog_mentioned_ = post._getBlogOrPostMentioned("blogsite_id", key, date_start.toString(),
									date_end.toString(), all_blog_ids.toString());

//							top_location = post._getMostLocation(key, date_start.toString(), date_end.toString(),
//									all_blog_ids.toString());
							posts_occured_data = new JSONObject();
							posts_occured_data.put("term", key);
							posts_occured_data.put("frequency", key_.getValue());
							posts_occured_data.put("post_count", t_);
							posts_occured_data.put("blog_count", blog_mentioned_);

							all.put(posts_occured_data);
							all_ = new JSONObject(all);
							all_.put("data", all);
							System.out.println("all_data--" + all_);

						} catch (Exception e) {

						}

					}
					session.setAttribute(tid.toString() + "_termtable", all_.toString());
					out.write(all_.toString());
				}
			} catch (Exception e) {

			}
		} else if (action.toString().equals("line_graph")) {

			try {
				PrintWriter out = response.getWriter();

				JSONObject result = new JSONObject();

//				System.out.println("terms_ma--"+all_selected_terms);
				sql = post._getBloggerPosts(mostactiveterm, "NOBLOGGER", date_start.toString(), date_end.toString(),
						all_blog_ids.toString());

				JSONObject firstpost = new JSONObject();
				Object map = null;
				/* if(allposts.size()>0){ */

				if (sql.getJSONArray("data").length() > 0) {
					String perma_link = null;
					String j = null;
					String title = null;
					String blogpost_id = null;
					String date = null;
					String num_comments = null;
					String blogger = null;

					Integer occurence = null;
					String mostActiveTerms[] = null;

					HashMap<String, Integer> hm2 = new HashMap<String, Integer>();

					String sql_ = sql.get("data").toString();
					for (int i = 0; i < sql.getJSONArray("data").length(); i++) {
//						System.out.println(sql.getJSONArray("data").length());
						Object jsonArray = sql.getJSONArray("data").get(i);

						j = jsonArray.toString();
						JSONObject j_ = new JSONObject(j);
						perma_link = j_.get("permalink").toString();
						title = j_.get("title").toString();
						blogpost_id = j_.get("blogpost_id").toString();
						date = j_.get("date").toString();
						num_comments = j_.get("num_comments").toString();
						blogger = j_.get("blogger").toString();
						posts = j_.get("post").toString();
						occurence = (Integer) j_.get("occurence");

						DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
								Locale.ENGLISH);
						DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("dd-MM-yyy", Locale.ENGLISH);
						LocalDate date_ = LocalDate.parse(date, inputFormatter);
						Integer d = date_.getYear();
						/* String formattedDate = outputFormatter.format(date); */
//						System.out.println(d.toString());

						hm2 = new HashMap<String, Integer>();
						hm2.put(d.toString(), (Integer) occurence);
//						System.out.println(d.toString() + "-+" + occurence + "date-" + date);
						items.add(i, hm2);

						mostActiveTerms = all_selected_terms.split(",");

//						for (int k = 0; k < mostActiveTerms.length; i++) {
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
//							String replace = "<span style=background:red;color:#fff>" + mostActiveTerms[k]+ "</span>";
//							String active2 = mostActiveTerms[k].substring(0, 1).toUpperCase()
//									+ mostActiveTerms[k].substring(1, mostActiveTerms[k].length());
//							String active3 = mostActiveTerms[k].toUpperCase();
//
//							posts = posts.replaceAll(mostActiveTerms[k], replace);
//							posts = posts.replaceAll(active2, replace);
//							posts = posts.replaceAll(active3, replace);
//
//							title = title.replaceAll(mostActiveTerms[k], replace);
//							title = title.replaceAll(active2, replace);
//							title = title.replaceAll(active3, replace);
//						}

					}

				}

				System.out.println("items--" + items);

				Map<String, Integer> json = (HashMap<String, Integer>) items.stream()
						.flatMap(m -> m.entrySet().stream())
						.collect(toMap(Map.Entry::getKey, Map.Entry::getValue, Integer::sum));

				System.out.println("map" + map);
				JSONObject mapped = new JSONObject(json);
				System.out.println("map2" + mapped);

				result.put("values", mapped);
				result.put("name", mostactiveterm);
				result.put("index", index);

				out.write(result.toString());
			} catch (Exception e) {

			}
		}
	}

}
