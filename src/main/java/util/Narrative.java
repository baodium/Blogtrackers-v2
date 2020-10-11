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
	
	public static ArrayList get_narratives(String entity, String tid, String blogpost_limit, String narrative_limit) {
		ArrayList blogpost_narratives = new ArrayList();
		DbConnection db = new DbConnection();
		
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
		
		DbConnection db = new DbConnection();
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

	public static void main(String [] args) {
		String [] test =  get_entities("7", 5, 10);
		ArrayList narra = get_narratives("Trump", "7", "10", "20");
		System.out.println("done");
	}
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
	}

}
