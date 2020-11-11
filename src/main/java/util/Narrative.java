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
//	private static final long serialVersionUID = 1L;
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
				+ "                    \"wildcard\": {\r\n" + "                        \"post\": {\r\n"
				+ "                            \"wildcard\": \"*"+search_value+"*\",\r\n"
				+ "                            \"boost\": 1.0\r\n" + "                        }\r\n"
				+ "                    }\r\n" + "                },\r\n" + "                {\r\n"
				+ "                    \"terms\": {\r\n" + "                        \"blogsite_id\": ["+blog_ids+"],\r\n"
				+ "                        \"boost\": 1\r\n" + "                    }\r\n" + "                }\r\n"
				+ "            ]\r\n" + "        }\r\n" + "    },\r\n" + "    \"sort\": [\r\n" + "        {\r\n"
				+ "            \"date\": {\r\n" + "                \"order\": \"desc\",\r\n"
				+ "                \"missing\": \"_first\",\r\n" + "                \"unmapped_type\": \"date\"\r\n"
				+ "            }\r\n" + "        }\r\n" + "    ]\r\n" + "}");
		try {
			// blogposts_result = db.queryJSON(query);
			result = Blogposts._makeElasticRequest(query, "GET", "blogposts_keyword/_search");
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

	public class Source {
		String entity;
		List<Data> data;

		public String toString() {
			return entity + "-------" + data;
		}
	}

	public class Data implements Comparable<Data> {
		String narrative;
		List<Integer> blogpost_ids = new ArrayList<>();

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

	public static void main(String[] args) {
//		String [] test =  get_entities("7", 5, 10);
//		ArrayList narra = get_narratives("Trump", "7", "10", "20");
		JSONObject res = search_narratives_post("6,10,23,1030", "test", "10");
		// List<Entity> res = search("trump");
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
