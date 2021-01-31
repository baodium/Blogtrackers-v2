package util;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.*;
import authentication.*;

import org.json.JSONArray;
import org.json.JSONObject;
import com.google.gson.Gson;

/**
 * Servlet implementation class Narrative
 */
@WebServlet("/NARRATIVE")
public class Narrative extends HttpServlet {
	/**
		 * 
		 */
	private static final long serialVersionUID = 1L;
	// private static final long serialVersionUID = 1L;
//       
//    /**
//     * @see HttpServlet#HttpServlet()
//     */
//    public Narrative() {
//        super();
//        // TODO Auto-generated constructor stub
//    }
	public static DbConnection db;
	public static Blogposts bp;

	/**
	 * Query to get narratives by entity and tracker_id
	 * 
	 * @param entity          query string for entity
	 * @param tid             query string for tracker id
	 * @param blogpost_limit  query string for number of posts
	 * @param narrative_limit query string for number of narratives
	 * @return ArrayList blogpost_narratives
	 */
	public static ArrayList get_narratives(String entity, String tid, String blogpost_limit, String narrative_limit) {
		ArrayList blogpost_narratives = new ArrayList();
		String blogpost_narratives_query = "select n.narrative, substring_index(group_concat(distinct n.blogpost_id separator ','),',',"
				+ blogpost_limit + ") blogpost_id_concatenated, count(n.blogpost_id) c " + "from tracker_narratives, "
				+ "json_table(blogpost_narratives," + "'$.*.\"" + entity + "\"[*]' columns("
				+ "narrative varchar(225) path '$.narrative'," + "blogpost_id int(11) path '$.blogpost_id'" + ")" + ") "
				+ "as n " + "where tid =" + tid + " and n.narrative is not null " + "group by n.narrative "
				+ "order by c desc " + "limit " + narrative_limit + ";";

		try {
			blogpost_narratives = db.queryJSON(blogpost_narratives_query);
		} catch (Exception e) {
			System.out.println(e);
		}

		return blogpost_narratives;
	}

	public static List<Entity_> get_narratives(String blog_ids, String date_from, String date_end, String size,
			String field, String sort_field) throws Exception {
		// query to get top entities
		JSONObject query = new JSONObject("{\r\n" + "    \"size\": 0,\r\n" + "    \"query\": {\r\n"
				+ "        \"bool\": {\r\n" + "            \"must\": [\r\n" + "                {\r\n"
				+ "                    \"terms\": {\r\n" + "                        \"blogsite_id\": [" + blog_ids
				+ "],\r\n" + "                        \"boost\": 1.0\r\n" + "                    }\r\n"
				+ "                },\r\n" + "                {\r\n" + "                    \"range\": {\r\n"
				+ "                        \"date\": {\r\n" + "                            \"from\": \"" + date_from
				+ "\",\r\n" + "                            \"to\": \"" + date_end + "\",\r\n"
				+ "                            \"include_lower\": false,\r\n"
				+ "                            \"include_upper\": false,\r\n"
				+ "                            \"boost\": 1.0\r\n" + "                        }\r\n"
				+ "                    }\r\n" + "                }\r\n" + "            ],\r\n"
				+ "            \"adjust_pure_negative\": true,\r\n" + "            \"boost\": 1.0\r\n" + "        }\r\n"
				+ "    },\r\n" + "    \"aggs\": {\r\n" + "        \"" + field + "\": {\r\n"
				+ "            \"terms\": {\r\n" + "                \"size\": " + size + ",\r\n"
				+ "                \"field\": \"" + field + "\"\r\n" + "            }\r\n" + "        }\r\n"
				+ "    }\r\n" + "}");

		JSONObject top_entity_result = Blogposts._makeElasticRequest(query, "GET", "entity_narratives/_search");
		Object aggregations = top_entity_result.getJSONObject("aggregations").getJSONObject(field)
				.getJSONArray("buckets");
		JSONArray buckets = new JSONArray(aggregations.toString());

		// build string with comma separated top entities
		StringBuilder top_entities = new StringBuilder();
		for (int i = 0; i < buckets.length(); i++) {
			Object entity = buckets.getJSONObject(i).get("key");
			top_entities.append(entity.toString() + ",");
		}
		String top_entities_str = new String(top_entities.deleteCharAt(top_entities.length() - 1));

		JSONObject get_all_query = new JSONObject("{\r\n" + "    \"size\": 50000,\r\n" + "    \"query\": {\r\n"
				+ "        \"bool\": {\r\n" + "            \"must\": [\r\n" + "                {\r\n"
				+ "                    \"bool\": {\r\n" + "                        \"must\": [\r\n"
				+ "                            {\r\n" + "                                \"terms\": {\r\n"
				+ "                                    \"entity\": [" + top_entities_str + "],\r\n"
				+ "                                    \"boost\": 1.0\r\n" + "                                }\r\n"
				+ "                            },\r\n" + "                            {\r\n"
				+ "                                \"terms\": {\r\n"
				+ "                                    \"blogsite_id\": [" + blog_ids + "],\r\n"
				+ "                                    \"boost\": 1.0\r\n" + "                                }\r\n"
				+ "                            }\r\n" + "                        ],\r\n"
				+ "                        \"adjust_pure_negative\": true,\r\n"
				+ "                        \"boost\": 1.0\r\n" + "                    }\r\n" + "                },\r\n"
				+ "                {\r\n" + "                    \"range\": {\r\n"
				+ "                        \"date\": {\r\n" + "                            \"from\": \"" + date_from
				+ "\",\r\n" + "                            \"to\": \"" + date_end + "\",\r\n"
				+ "                            \"include_lower\": false,\r\n"
				+ "                            \"include_upper\": false,\r\n"
				+ "                            \"boost\": 1.0\r\n" + "                        }\r\n"
				+ "                    }\r\n" + "                }\r\n" + "            ],\r\n"
				+ "            \"adjust_pure_negative\": true,\r\n" + "            \"boost\": 1.0\r\n" + "        }\r\n"
				+ "    },\r\n" + "    \"_source\": {\r\n" + "        \"includes\": [\r\n"
				+ "            \"blogpost_id\",\r\n" + "            \"entity\",\r\n" + "            \"narrative\"\r\n"
				+ "        ],\r\n" + "        \"excludes\": []\r\n" + "    },\r\n" + "    \"sort\": [\r\n"
				+ "        {\r\n" + "            \"" + sort_field + "\": {\r\n"
				+ "                \"order\": \"asc\",\r\n" + "                \"missing\": \"_last\",\r\n"
				+ "                \"unmapped_type\": \"" + sort_field + "\"\r\n" + "            }\r\n"
				+ "        }\r\n" + "    ]\r\n" + "}");
		JSONObject top_all_result = Blogposts._makeElasticRequest(get_all_query, "GET", "entity_narratives/_search");
		Object hits = top_all_result.getJSONObject("hits").getJSONArray("hits");
		JSONArray hit = new JSONArray(hits.toString());
		List<Entity_> res = wrangleJson(hit);

		return res;

	}

	/**
	 * Query to get top entities by tracker_id
	 * 
	 * @param tid         query string for tracker id
	 * @param start_index starting index for entity array result
	 * @param end_index   ending index for entity array result
	 * @return String [] slice
	 */
	public static String[] get_entities(String tid, int start_index, int end_index) {
		ArrayList narratives_top_entities = new ArrayList();
		int limit = end_index - start_index;

		String top_entities_query = "SELECT top_entities from tracker_narratives where tid = " + tid;

		narratives_top_entities = db.queryJSON(top_entities_query);

		JSONObject source = new JSONObject();
		Object top_entities = null;
		String[] slice = new String[limit];

		if (narratives_top_entities.size() > 0) {
			source = new JSONObject(narratives_top_entities.get(0).toString());
			top_entities = source.getJSONObject("_source").get("top_entities");

			// Getting top 10 entities
			String[] slicer = Arrays.copyOfRange(
					top_entities.toString().replace("{", "").replace("}", "").replace("\"", "").split(","), start_index,
					end_index);
			int a = 0;
			for (String x : slicer) {
				if (a == limit) {
					break;
				}
				if (x.indexOf("div.") == -1) {
					slice[a] = x;
					a++;
				}
			}
		}

		return slice;
	}

	public static Object load_more(String entity) {
		Object result = null;
		return result;
	}

	/**
	 * Query to edit narrative text
	 * 
	 * @param blog_ids     query string for all blogsite ids
	 * @param search_value query string for new_string
	 * @param limit        query string for new narrative
	 * @return ArrayList [] blogposts_result
	 */
	public static JSONObject search_narratives_post(String blog_ids, String search_value, String limit) {
		// ArrayList<?> blogposts_result = new ArrayList<>();
		JSONObject result = new JSONObject();
//		String query = "select blogpost_id, title, date, permalink, post\r\n" + 
//				"from blogtrackers.blogposts \r\n" + 
//				"where blogsite_id in ("+blog_ids.toString()+")\r\n" + 
//				"and match (post) against('"+search_value.toString()+"' IN BOOLEAN MODE) and post like '% "+search_value.toString()+" %' limit "+limit+";";
//		        
		JSONObject query = new JSONObject("{\r\n" + "    \"size\": \"" + limit + "\",\r\n" + "    \"query\": {\r\n"
				+ "        \"bool\": {\r\n" + "            \"must\": [\r\n" + "                {\r\n"
				+ "                    \"wildcard\": {\r\n" + "                        \"narrative\": {\r\n"
				+ "                            \"wildcard\": \"*" + search_value + "*\",\r\n"
				+ "                            \"boost\": 1.0\r\n" + "                        }\r\n"
				+ "                    }\r\n" + "                },\r\n" + "                {\r\n"
				+ "                    \"terms\": {\r\n" + "                        \"blogsite_id\": [" + blog_ids
				+ "],\r\n" + "                        \"boost\": 1\r\n" + "                    }\r\n"
				+ "                }\r\n" + "            ]\r\n" + "        }\r\n" + "    },\r\n" + "    \"sort\": [\r\n"
				+ "        {\r\n" + "            \"date\": {\r\n" + "                \"order\": \"desc\",\r\n"
				+ "                \"missing\": \"_first\",\r\n" + "                \"unmapped_type\": \"date\"\r\n"
				+ "            }\r\n" + "        }\r\n" + "    ]\r\n" + "}");
		try {
			// blogposts_result = db.queryJSON(query);
//			result = Blogposts._makeElasticRequest(query, "GET", "blogposts_keyword/_search");
			result = Blogposts._makeElasticRequest(query, "GET", "entity_narratives/_search");
		} catch (Exception e) {
			System.out.println(e);
		}

		return result;
	}

	/**
	 * Query for fuzzy search
	 * 
	 * @param search_string search string
	 * @return List<Entity> res
	 */
	public static List<Entity> search(String search_string) {
		JSONObject result = new JSONObject();

		JSONObject query = new JSONObject(
				"{\r\n" + "    \"size\": 10,\r\n" + "     \"query\": {\r\n" + "        \"match\" : {\r\n"
						+ "            \"data.narrative\" : {\r\n" + "                \"query\" : \"" + search_string
						+ "\",\r\n" + "                \"fuzziness\": \"auto\"\r\n" + "            }\r\n"
						+ "        }\r\n" + "    }\r\n" + "}");

		try {
//			result = Blogposts._makeElasticRequest(query, "GET", "entity_narratives/_search");
			result = Blogposts._makeElasticRequest(query, "GET", "entity_narratives_testing/_search");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		Object hits = result.getJSONObject("hits").getJSONArray("hits");
		JSONArray hit = new JSONArray(hits.toString());
		List<Entity> res = new ArrayList<>();

		for (int i = 0; i < hit.length(); i++) {
			JSONObject x = new JSONObject(hit.get(i).toString());
			Object entity = x.getJSONObject("_source").get("entity");
			Object data = x.getJSONObject("_source").getJSONArray("data");
			Gson gson = new Gson();

			Source s = gson.fromJson(x.getJSONObject("_source").toString(), Source.class);
			List<Data> d = s.data;

			Collections.sort(d);

			res.add(new Entity(entity.toString(), d));
		}
		Collections.sort(res, (a, b) -> {
			Integer x = a.data.size();
			Integer y = b.data.size();
			return y.compareTo(x);
		});
		return res;
	}

	public static List<Entity_> search_(String search_string, String date_start, String date_end) {
		JSONObject result = new JSONObject();
		JSONObject query = new JSONObject();
		if(date_start == null & date_end == null || date_start == "" & date_end == "") {
			query = new JSONObject("{\r\n" + 
					"    \"size\": 10000,\r\n" + 
					"    \"query\": {\r\n" + 
					"        \"match\": {\r\n" + 
					"            \"narrative_keyword\": {\r\n" + 
					"                \"fuzziness\": \"auto\",\r\n" + 
					"                \"query\": \""+search_string+"\"\r\n" + 
					"            }\r\n" + 
					"        }\r\n" + 
					"    }\r\n" + 
					"}");
		}else {
			query = new JSONObject("{\r\n" + "    \"size\": 10000,\r\n" + "    \"query\": {\r\n"
					+ "        \"bool\": {\r\n" + "            \"adjust_pure_negative\": true,\r\n"
					+ "            \"must\": [\r\n" + "                {\r\n" + "                    \"match\": {\r\n"
					+ "                        \"narrative_keyword\": {\r\n"
					+ "                            \"fuzziness\": \"auto\",\r\n"
					+ "                            \"query\": \"" + search_string + "\"\r\n"
					+ "                        }\r\n" + "                    }\r\n" + "                },\r\n"
					+ "                {\r\n" + "                    \"range\": {\r\n"
					+ "                        \"date\": {\r\n"
					+ "                            \"include_lower\": false,\r\n"
					+ "                            \"include_upper\": false,\r\n"
					+ "                            \"from\": \"" + date_start + "\",\r\n"
					+ "                            \"boost\": 1,\r\n" + "                            \"to\": \"" + date_end
					+ "\"\r\n" + "                        }\r\n" + "                    }\r\n" + "                }\r\n"
					+ "            ]\r\n" + "        }\r\n" + "    }\r\n" + "}");
		}
		

		try {
			result = Blogposts._makeElasticRequest(query, "GET", "entity_narratives/_search");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		Object hits = result.getJSONObject("hits").getJSONArray("hits");
		JSONArray hit = new JSONArray(hits.toString());
		List<Entity_> res = wrangleJson(hit);

		return res;
	}

	public static List<Entity_> wrangleJson(JSONArray hit) {
		List<Entity_> final_array = new ArrayList<>();
		Map<String, List<Data_>> entity_map = new HashMap<>();

		for (int i = 0; i < hit.length(); i++) {
			JSONObject x = new JSONObject(hit.get(i).toString());
			String entity = x.getJSONObject("_source").get("entity").toString();
			String narrative = x.getJSONObject("_source").get("narrative").toString();
			String blogpost_id = x.getJSONObject("_source").get("blogpost_id").toString();

			Data_ temp_array = new Data_(null, new HashSet<String>());
			Set<String> bp_temp = new HashSet<>();
			List<Data_> t = new ArrayList<>();

			if (!entity_map.containsKey(entity)) {
				bp_temp = new HashSet<>();
				bp_temp.add(blogpost_id);

				t = new ArrayList<>();

				temp_array = new Data_(narrative, bp_temp);
				t.add(temp_array);

				entity_map.put(entity, t);
			} else {
				List<Data_> data = entity_map.get(entity);
				Set<String> blogpost_ids = new HashSet<>();
				int found = -1;
				for (int j = 0; j < data.size(); j++) {

					Data_ d = data.get(j);
					if (d.getNarrative().equals(narrative)) {
						found = j;
						blogpost_ids = d.getBlogpostIds();
						break;
					}
				}
				if (found == -1) {
					bp_temp = new HashSet<>();
					bp_temp.add(blogpost_id);

					temp_array = new Data_(narrative, bp_temp);

					data.add(temp_array);

					entity_map.put(entity, data);
				} else if (!blogpost_ids.contains(blogpost_id)) {
					blogpost_ids.add(blogpost_id);
					entity_map.put(entity, data);
				}
			}
		}

		for (String key : entity_map.keySet()) {
			List<Data_> temp_ = entity_map.get(key);
			Collections.sort(temp_);
			final_array.add(new Entity_(key, temp_));
		}

		Collections.sort(final_array, (a, b) -> {
			Integer x = a.data.size();
			Integer y = b.data.size();
			return y.compareTo(x);
		});

		return final_array;
	}

	public static List<Data> merge(String merge_string) {
		JSONObject result = new JSONObject();

		JSONObject query = new JSONObject("{\r\n" + "    \"size\": 10,\r\n" + "    \"query\": {\r\n"
				+ "        \"bool\": {\r\n" + "            \"must\": [\r\n" + "                {\r\n"
				+ "                    \"terms\": {\r\n" + "                        \"entity.keyword\": ["
				+ merge_string + "],\r\n" + "                        \"boost\": 1.0\r\n" + "                    }\r\n"
				+ "                },\r\n" + "                {\r\n" + "                    \"match\": {\r\n"
				+ "                        \"data.narrative\": \"" + merge_string.replace("\"", "").replace(",", " ")
				+ "\"\r\n" + "                    }\r\n" + "                }\r\n" + "            ]\r\n"
				+ "        }\r\n" + "    }\r\n" + "}");

		try {
			result = Blogposts._makeElasticRequest(query, "GET", "entity_narratives_testing/_search");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		Object hits = result.getJSONObject("hits").getJSONArray("hits");
		JSONArray hit = new JSONArray(hits.toString());
		List<Entity> res = new ArrayList<>();

		List<Data> merged_data = new ArrayList<>();
		JSONObject x = new JSONObject();
		Object entity = null;
		Object data = null;
		Gson gson = new Gson();
		Source s = null;

		if (hit.length() > 0) {
			x = new JSONObject(hit.get(0).toString());
			entity = x.getJSONObject("_source").get("entity");
			data = x.getJSONObject("_source").getJSONArray("data");
			gson = new Gson();
			s = gson.fromJson(x.getJSONObject("_source").toString(), Source.class);
			merged_data = s.data;
			Collections.sort(merged_data);
		}

		if (hit.length() > 1) {
			for (int i = 1; i < hit.length(); i++) {
				x = new JSONObject(hit.get(i).toString());
				entity = x.getJSONObject("_source").get("entity");
				data = x.getJSONObject("_source").getJSONArray("data");
				gson = new Gson();
				s = gson.fromJson(x.getJSONObject("_source").toString(), Source.class);
				List<Data> d = s.data;
				Collections.sort(d);
				merged_data.addAll(d);

			}
		}

		return merged_data;
	}

	public static List<Data_> merge_(String merge_string, String blogsite_ids) {
		JSONObject result = new JSONObject();

		JSONObject query = new JSONObject("{\r\n" + "    \"size\": 1000,\r\n" + "    \"query\": {\r\n"
				+ "        \"bool\": {\r\n" + "            \"must\": [\r\n" + "                {\r\n"
				+ "                    \"terms\": {\r\n" + "                        \"entity\": [" + merge_string
				+ "],\r\n" + "                        \"boost\": 1\r\n" + "                    }\r\n"
				+ "                },\r\n" + "                {\r\n" + "                    \"match\": {\r\n"
				+ "                        \"narrative_keyword\": \"" + merge_string.replace("\"", "").replace(",", " ")
				+ "\"\r\n" + "                    }\r\n" + "                },\r\n" + "                {\r\n"
				+ "                    \"terms\": {\r\n" + "                        \"blogsite_id\": [" + blogsite_ids
				+ "],\r\n" + "                        \"boost\": 1.0\r\n" + "                    }\r\n"
				+ "                }\r\n" + "            ]\r\n" + "        }\r\n" + "    }\r\n" + "}");

		try {
			result = Blogposts._makeElasticRequest(query, "GET", "entity_narratives/_search");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		Object hits = result.getJSONObject("hits").getJSONArray("hits");
		JSONArray hit = new JSONArray(hits.toString());
		List<Entity_> res = wrangleJson(hit);

		List<Data_> merged_data = new ArrayList<>();
		JSONObject x = new JSONObject();
		Object entity = null;
		Object data = null;
		Gson gson = new Gson();
		Source s = null;

		if (res.size() > 0) {
			for (int i = 0; i < res.size(); i++) {
				List<Data_> d = res.get(i).getData();
				merged_data.addAll(d);
			}
		}

		Collections.sort(merged_data);
		return merged_data;
	}

	public static List<Data> unmerge(String entity_string) {
		JSONObject result = new JSONObject();

		JSONObject query = new JSONObject("{\r\n" + "    \"size\": 1000,\r\n" + "    \"query\": {\r\n"
				+ "        \"term\": {\r\n" + "            \"entity.keyword\": {\r\n" + "                \"value\": \""
				+ entity_string + "\",\r\n" + "                \"boost\": 1.0\r\n" + "            }\r\n"
				+ "        }\r\n" + "    },\r\n" + "    \"_source\": {\r\n" + "        \"includes\": [\r\n"
				+ "            \"@version\",\r\n" + "            \"data.blogpost_ids\",\r\n"
				+ "            \"data.narrative\",\r\n" + "            \"entity\"\r\n" + "        ],\r\n"
				+ "        \"excludes\": []\r\n" + "    },\r\n" + "    \"docvalue_fields\": [\r\n" + "        {\r\n"
				+ "            \"field\": \"@timestamp\",\r\n" + "            \"format\": \"epoch_millis\"\r\n"
				+ "        },\r\n" + "        {\r\n" + "            \"field\": \"last_modified_time\",\r\n"
				+ "            \"format\": \"epoch_millis\"\r\n" + "        }\r\n" + "    ],\r\n"
				+ "    \"sort\": [\r\n" + "        {\r\n" + "            \"_doc\": {\r\n"
				+ "                \"order\": \"asc\"\r\n" + "            }\r\n" + "        }\r\n" + "    ]\r\n" + "}");

		try {
			result = Blogposts._makeElasticRequest(query, "GET", "entity_narratives_testing/_search");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		Object hits = result.getJSONObject("hits").getJSONArray("hits");
		JSONArray hit = new JSONArray(hits.toString());
		List<Entity> res = new ArrayList<>();

		List<Data> merged_data = new ArrayList<>();
		JSONObject x = new JSONObject();
		Object entity = null;
		Object data = null;
		Gson gson = new Gson();
		Source s = null;

		if (hit.length() > 0) {
			x = new JSONObject(hit.get(0).toString());
			entity = x.getJSONObject("_source").get("entity");
			data = x.getJSONObject("_source").getJSONArray("data");
			gson = new Gson();
			s = gson.fromJson(x.getJSONObject("_source").toString(), Source.class);
			merged_data = s.data;
			Collections.sort(merged_data);
		}
		return merged_data;
	}

	public class Source {
		String entity;
		List<Data> data;

		public Source(String entity, List<Data> data) {
			this.entity = entity;
			this.data = data;
		}

		public String toString() {
			return entity + "-------" + data;
		}
	}

	public class Data implements Comparable<Data> {
		String narrative;
		List<Integer> blogpost_ids = new ArrayList<>();

		public Data(String narrative, List<Integer> blogpost_ids) {
			this.narrative = narrative;
			this.blogpost_ids = blogpost_ids;
		}

//		public void setData()

		public String toString() {
			return narrative + "-------" + blogpost_ids;
		}

		public String getNarrative() {
			return narrative;
		}

		public List<Integer> getBlogpostIds() {
			return blogpost_ids;
		}

		public int compareTo(Data d) {
			return d.blogpost_ids.size() - this.blogpost_ids.size();
		}
	}

	public static class Data_ implements Comparable<Data_> {
		String narrative;
		Set<String> blogpost_ids = new HashSet<>();

		public Data_(String narrative, Set<String> blogpost_ids) {
			this.narrative = narrative;
			this.blogpost_ids = blogpost_ids;
		}

//		public void setData()

		public String toString() {
			return narrative + "-------" + blogpost_ids;
		}

		public String getNarrative() {
			return narrative;
		}

		public Set<String> getBlogpostIds() {
			return blogpost_ids;
		}

		public int compareTo(Data_ d) {
			return d.blogpost_ids.size() - this.blogpost_ids.size();
		}
	}

	public static class Entity {
		String entity;
		List<Data> data;

		public Entity(String entity, List<Data> data) {
			this.entity = entity;
			this.data = data;
		}

		public List<Data> getData() {
			return data;
		}

		public String getEntity() {
			return entity;
		}

		public String toString() {
			return entity + "-------" + data;
		}
	}

	public static class Entity_ {
		String entity;
		List<Data_> data;

		public Entity_(String entity, List<Data_> data) {
			this.entity = entity;
			this.data = data;
		}

		public List<Data_> getData() {
			return data;
		}

		public String getEntity() {
			return entity;
		}

		public String toString() {
			return entity + "-------" + data;
		}
	}

	public static void main(String[] args) throws Exception {
//		String [] test =  get_entities("7", 5, 10);
//		ArrayList narra = get_narratives("Trump", "7", "10", "20");
//		JSONObject res = search_narratives_post("1", "west", "10");
		List<Entity_> res = search_("trump","2000-01-01", "2020-11-11");
//		List<Entity_> res = get_narratives("1,2,3", "2000-01-01", "2020-11-11", "10", "entity", "date");
//		List<Data_> res = merge_("\"Obama\",\"Trump\"", "88,267,127,1806");
//		List<Data> res = unmerge("trump");
		System.out.println("done");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub

	}

}
