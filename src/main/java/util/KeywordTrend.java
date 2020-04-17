package util;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.NumberFormat;
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
//@WebServlet("/KeywordTrend")
public class KeywordTrend extends HttpServlet{
	Clustering terms = new Clustering();
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

		JSONObject result_blogmentioned = new JSONObject();
		JSONObject result_location = new JSONObject();
		JSONObject result_posts = new JSONObject();
		JSONObject sql = new JSONObject();

		String sql__ = null;
		List<Map<String, Integer>> items = new ArrayList<>();

		if (action.toString().equals("getblogmentioned")) {
			try {
				System.out.println("i am here----");
				PrintWriter out = response.getWriter();
				blog_mentioned = post._getBlogOrPostMentioned("blogsite_id", mostactiveterm.toString(),
						date_start.toString(), date_end.toString(), all_blog_ids.toString());

				System.out.println("bloger men-----" + blog_mentioned + mostactiveterm.toString()
						+ date_start.toString() + date_end.toString() + all_blog_ids.toString());

				result_blogmentioned.put("blogmentioned",
						NumberFormat.getNumberInstance(Locale.US).format(new Integer(blog_mentioned.toString())));
				String new_result = result_blogmentioned.toString();
				result_blogmentioned = new JSONObject(new_result);

				out.write(result_blogmentioned.toString());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
//		doGet(request, response);
		} else if (action.toString().equals("getmostlocation")) {
			PrintWriter out = response.getWriter();
			try {

				top_location = post._getMostLocation(mostactiveterm.toString(), date_start.toString(),
						date_end.toString(), all_blog_ids.toString());
			} catch (Exception e) {

				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			System.out.println("loacation---" + top_location.toString() + mostactiveterm.toString()
					+ date_start.toString() + date_end.toString() + all_blog_ids.toString());

			System.out.println("location_str" + top_location.toString());
			result_location.put("toplocation", top_location.toString());
			String new_result = result_location.toString();
			result_location = new JSONObject(new_result);

			System.out.println("locationfinal_str" + result_location.toString());
			out.write(result_location.toString());

		} else if (action.toString().equals("getmostpost")) {
			try {
				PrintWriter out = response.getWriter();
//				sql = post._getBloggerPosts(mostactiveterm.toString(), "NOBLOGGER", date_start.toString(),
//						date_end.toString(), all_blog_ids.toString());
				sql__ = post._countPostMentioned(mostactiveterm.toString(), date_start.toString(), date_end.toString(),
						all_blog_ids.toString());
//				posts = sql.get("total").toString();
				// posts = post._getBlogOrPostMentioned("post",
				// mostactiveterm.toString(),date_start.toString(), date_end.toString(),
				// date_end.toString());

				System.out.println("post---" + sql__ + mostactiveterm.toString() + date_start.toString()
						+ date_end.toString() + all_blog_ids.toString());

				System.out.println("post_str" + sql__.toString());
				result_posts.put("post", NumberFormat.getNumberInstance(Locale.US).format(new Integer(sql__)));
				String new_result = result_posts.toString();
				result_posts = new JSONObject(new_result);

				System.out.println("post" + result_posts.toString());
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
				sql = post._getBloggerPosts(mostactiveterm.toString(), "NOBLOGGER", date_start.toString(),
						date_end.toString(), all_blog_ids.toString(),1000);

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

					HashMap<String, Integer> hm2 = new HashMap<String, Integer>();

					String sql_ = sql.get("data").toString();
					for (int i = 0; i < sql.getJSONArray("data").length(); i++) {
						System.out.println(sql.getJSONArray("data").length());
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
						System.out.println(d.toString());

						hm2 = new HashMap<String, Integer>();
						hm2.put(d.toString(), (Integer) occurence);
						System.out.println(d.toString() + "-+" + occurence + "date-" + date);
						items.add(i, hm2);

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
				System.out.println("items--" + items);
				Map<String, Integer> json = (HashMap<String, Integer>) items.stream()
						.flatMap(m -> m.entrySet().stream())
						.collect(toMap(Map.Entry::getKey, Map.Entry::getValue, Integer::sum));
				System.out.println("map" + map);
				JSONObject mapped = new JSONObject(json);
				System.out.println("map2" + mapped);
				out.write(mapped.toString());
			} catch (Exception e) {

			}
		}
	}

	public static void main(String [] args) {
		
	}
}
