package util;

import java.io.*;
import java.sql.ResultSet;
import java.util.*;

import authentication.DbConnection;
import scala.Tuple2;
public class LanguageMapper {
	HashMap<String, String> lang = new HashMap<String, String>();		
	
	public static void main(String[] args) {
		try {
			getTopLanguages("blogsite_id", "\"2649\",\"1319\",\"3436\"", "2020-01-01", "2020-11-11", "10");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	public LanguageMapper(){
		HashMap<String, String> hm = new HashMap<String, String>();
		BufferedReader br = null;
		try {
			br = new BufferedReader(new FileReader("0.csv"));
			String temp = "";
			String[] arr;
			while((temp= br.readLine()) != null) {
				temp = temp.trim();  											 	// Strip the whitespaces 
				if(temp.isEmpty()) { 						
					continue;														// Skip the comments, for example the author, created on and document type
				}
				else {
					arr = temp.split(",");											// Split it by ##, for example, if you have name##wale, then arr[0] = name and arr[1] = wale and arr.length = 2 since it contains 2 elements
					if(arr.length == 2) {
						hm.put(arr[0].trim(), arr[1].trim());	
						this.lang = hm;// Save the element as a key value pair. Using example above, the Hashmap will be [user, wale], where user is the key and wale is the value
					}
				}	
			}
		}catch(Exception e) {
			
		}
		
	}
	public HashMap<String, String> loadLang(){
				
		return lang;
	}
	
	/**
	 * Getting top languages with respect to post frequency
	 * @param field_name field name to filter search on
	 * @param field_values field values
	 * @param from lowest date range
	 * @param to highest date range
	 * @param limit output limit
	 * @throws Exception - Exception
	 * @return String result
	 */
	public static ArrayList<Tuple2<String, Integer> > getTopLanguages(String field_name, String field_values, String from, String to, String limit) throws Exception {
		String result = null;
		ArrayList<Tuple2<String, Integer> > output = new ArrayList<>();
		Tuple2<String, Integer> v = new Tuple2<String, Integer>(null,null);
		
		if (field_values.indexOf("\"") != 0) {
			field_values = "\"" + field_values + "\"";
		}
		String query = "select language, count(language) c\r\n" + 
				"from blogposts\r\n" + 
				"where "+field_name+" in ("+field_values+") \r\n" + 
				"and date > \""+from+"\" \r\n" + 
				"and date < \""+to+"\"\r\n" + 
				"group by language\r\n" + 
				"order by c desc\r\n" + 
				"limit "+limit+";";
		
		ResultSet post_all =  DbConnection.queryResultSet(query);
		
		while(post_all.next()){
			String language = post_all.getString("language");
			int count = post_all.getInt("c");
			
			v = new Tuple2<String, Integer>(language,count);
			output.add(v);
		}

		post_all.close();
		return output;
	}
	
	
	
}
