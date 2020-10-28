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
	public static ArrayList get_narratives(String entity, String tid, String blogpost_limit, String narrative_limit) {
		ArrayList blogpost_narratives = new ArrayList();
//		DbConnection db = new DbConnection();
		
		String blogpost_narratives_query = "select n.narrative, substring_index(group_concat(distinct n.blogpost_id separator ','),','," + blogpost_limit + ") blogpost_id_concatenated, count(n.blogpost_id) c " + 
        		"from tracker_narratives, " +
        		"json_table(blogpost_narratives," +
        		  "'$.*.\""+ entity +"\"[*]' columns(" +
        		     "narrative varchar(225) path '$.narrative'," +
        		    "blogpost_id int(11) path '$.blogpost_id'" +
        		    ")" +
        		  ") " +
        		  "as n " +
        		  "where tid ="+ tid +" and n.narrative is not null " +
        		  "group by n.narrative " +
        		  "order by c desc " +
        		  "limit " + narrative_limit +";";
		
		try{
        	blogpost_narratives = db.queryJSON(blogpost_narratives_query);
        }catch(Exception e){
        	System.out.println(e);
        }
        
		
		return blogpost_narratives;
	}
	
	public static String [] get_entities(String tid, int start_index, int end_index) {
		ArrayList narratives_top_entities = new ArrayList();
		int limit = end_index - start_index;
		
		
		String top_entities_query = "SELECT top_entities from tracker_narratives where tid = " + tid;
		
		narratives_top_entities = db.queryJSON(top_entities_query);
		
		JSONObject source = new JSONObject();
		Object top_entities = null;
		String [] slice = new String[limit];
		
		if(narratives_top_entities.size() > 0){
			source = new JSONObject(narratives_top_entities.get(0).toString());
			top_entities = source.getJSONObject("_source").get("top_entities"); 
			//Getting top 10 entities
			
			String [] slicer = Arrays.copyOfRange(top_entities.toString().replace("{","").replace("}","").replace("\"","").split(","),start_index, end_index);
			int a = 0;
			for(String x: slicer){
				if(a == limit){
					break;
				}
				if(x.indexOf("div.") == -1){
					slice[a] = x;
					a++;
				}
			}
			//slice = Arrays.copyOfRange(, 0, 10); 
			
			System.out.println(Arrays.toString(slice)); 
			System.out.println("processed");
		}
		
		return slice;
	}
	
	public static Object load_more(String entity) {
		Object result = null;
		
		return result;
	}

	public static ArrayList search_narratives_post(String blog_ids, String search_value, String limit) {
		ArrayList blogposts_result = new ArrayList();
		String query = "select blogpost_id, title, date, permalink, post\r\n" + 
				"from blogtrackers.blogposts \r\n" + 
				"where blogsite_id in ("+blog_ids.toString()+")\r\n" + 
				"and match (post) against('"+search_value.toString()+"' IN BOOLEAN MODE) and post like '% "+search_value.toString()+" %' limit "+limit+";";
		        
		try{
			blogposts_result = db.queryJSON(query);
	    }catch(Exception e){
	    	System.out.println(e);
	    }
		
		return blogposts_result;
	}
	
	public static List<Entity> search(String search_string) {
		JSONObject result = new JSONObject();
		JSONObject query = new JSONObject("{\r\n" + 
				"  \"query\": {\r\n" + 
				"    \"fuzzy\": {\r\n" + 
				"      \"data.narrative\": {\r\n" + 
				"        \"value\": \""+search_string+"\",\r\n" + 
				"        \"fuzziness\": \"1\"\r\n" + 
				"      }\r\n" + 
				"    }\r\n" + 
				"  }\r\n" + 
				"}");
		try {
			result = Blogposts._makeElasticRequest(query, "GET", "entity_narratives/_search");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Object hits = result.getJSONObject("hits").getJSONArray("hits");
		JSONArray hit = new JSONArray(hits.toString());
		List<Entity> res = new ArrayList<>();

		for(int i = 0; i < hit.length(); i++) {
			JSONObject x = new JSONObject(hit.get(i).toString());
			Object entity = x.getJSONObject("_source").get("entity");
			Object data = x.getJSONObject("_source").getJSONArray("data");

			res.add(new Entity(entity.toString(), new JSONArray(data.toString())));
		}
		Collections.sort(res, (a,b)->{
			Integer x = a.data.length();
			Integer y = b.data.length();
			return  y.compareTo(x);
		});
		return res;
	}
	
	public static class Entity{
		String entity;
		JSONArray data;
		
		public Entity(String entity, JSONArray data) {
			this.entity = entity;
			this.data = data;
		}
		
		public String toString(){
		   return entity+"-------"+data;
		 }
	}
	
	public static void main(String [] args) {
//		String [] test =  get_entities("7", 5, 10);
//		ArrayList narra = get_narratives("Trump", "7", "10", "20");
//		ArrayList res = search_narratives_post("6,10,23,1030", "test", "10");
		List<Entity> res = search("trump");
		System.out.println("done");
	}
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
	}

}

