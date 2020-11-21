package util;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.json.JSONObject;
import java.util.*;

import authentication.DbConnection;
import scala.Tuple2;

import org.json.JSONArray;

import java.io.OutputStreamWriter;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;

public class Blogger {
	HashMap<String, String> hm = DbConnection.loadConstant();

	/**
	 * Count number of bloggers for a specific tracker using blog ids
	 * @param blog_ids - blogsite ids
	 * @return String count
	 */
	public String _getBloggerById(String blog_ids) {
		String count = "";
		blog_ids = blog_ids.replaceAll(",$", "");
		blog_ids = blog_ids.replaceAll(", $", "");
		blog_ids = "(" + blog_ids + ")";
		try {
			ArrayList response = DbConnection
					.query("select count(distinct(blogger_name)) from blogger where blogsite_id in  " + blog_ids + " ");

			if (response.size() > 0) {
				ArrayList hd = (ArrayList) response.get(0);
				count = hd.get(0).toString();
			}
		} catch (Exception e) {
			System.out.print("Error in getBlogPostById");
		}
		return count;
	}

	/**
	 * Getting list of bloggers based on number of posts
	 * @param blogids - blogsite ids
	 * @throws Exception - Exception
	 * @return ArrayList result
	 */
	public ArrayList _getBloggerPostFrequency(String blogids) throws Exception {
		ArrayList result = new ArrayList();

		DbConnection db = new DbConnection();
		String count = "0";
		blogids = blogids.replaceAll(",$", "");
		blogids = blogids.replaceAll(", $", "");
		blogids = "(" + blogids + ")";
		try {
			result = db.query(
					"select distinct blg.blogger_name, sum(blg.blogpost_count) as totalpost, blg.blogsite_id, bls.blogsite_url from blogsites as bls, blogger as blg where blg.blogsite_id = bls.blogsite_id and blg.blogger_name!=\"\" and blg.blogsite_id in "
							+ blogids + " group by blg.blogger_name order by totalpost desc limit 50");
		} catch (Exception e) {
		}
		return result;

	}
	/**
	 * Getting count of post for single blogger
	 * @param bloggerName - blogger's name
	 * @throws Exception - Exception
	 * @return String count
	 */
	public String _getpostByBlogger(String bloggerName) throws Exception {
		ArrayList result = new ArrayList();
		String count = "";
		DbConnection db = new DbConnection();
		try {
			result = db.query("SELECT sum(blogpost_count) FROM blogger where blogger_name = '" + bloggerName + "'");
			if (result.size() > 0) {
				ArrayList hd = (ArrayList) result.get(0);
				count = hd.get(0).toString();
			}
		} catch (Exception e) {
		}
		return count;
	}

	/**
	 * Getting sum of influence score for single blogger
	 * @param bloggerName -blogger's name
	 * @throws Exception - Exception
	 * @return String count
	 */
	public String _getInfluenceByBlogger(String bloggerName) throws Exception {
		ArrayList result = new ArrayList();
		String count = "";
		DbConnection db = new DbConnection();
		try {
			result = db.query(
					"SELECT sum(influence_score) FROM blogtrackers.blogger where blogger_name = '" + bloggerName + "'");
			if (result.size() > 0) {
				ArrayList hd = (ArrayList) result.get(0);
				count = hd.get(0).toString();
			}
		} catch (Exception e) {
		}
		return count;

	}
	
	/**
	 * Getting top bloggers with respect to post frequency
	 * @param field_name field name to filter search on
	 * @param field_values field values
	 * @param from lowest date range
	 * @param to highest date range
	 * @param limit output limit
	 * @throws Exception - Exception
	 * @return String result
	 */
	public static ArrayList<Tuple2<String, Integer> > getTopBloggers(String field_name, String field_values, String from, String to, String limit) throws Exception {
		String result = null;
		ArrayList<Tuple2<String, Integer> > output = new ArrayList<>();
		Tuple2<String, Integer> v = new Tuple2<String, Integer>(null,null);
		
		if (field_values.indexOf("\"") != 0) {
			field_values = "\"" + field_values + "\"";
		}
		String query = "select blogger, count(blogger) c\r\n" + 
				"from blogposts\r\n" + 
				"where "+field_name+" in ("+field_values+") \r\n" + 
				"and date > \""+from+"\" \r\n" + 
				"and date < \""+to+"\"\r\n" + 
				"group by blogger limit "+limit+";";
		
		ResultSet post_all =  DbConnection.queryResultSet(query);
		
		while(post_all.next()){
			String blogger = post_all.getString("blogger").replaceAll("\\s+", " ").replace("By","").replace("by","").trim();
			int count = post_all.getInt("c");
			
			v = new Tuple2<String, Integer>(blogger,count);
			output.add(v);
		}

		post_all.close();
		return output;
	}
	
	/**
	 * Getting most influential bloggers
	 * @param field_name field name to filter search on
	 * @param field_values field values
	 * @param from lowest date range
	 * @param to highest date range
	 * @param limit output limit
	 * @throws Exception - Exception
	 * @return String result
	 */
	public static ArrayList<Tuple2<String, Integer> > getMostInfluentialBloggers(String field_name, String field_values, String from, String to, String limit) throws Exception {
		String result = null;
		ArrayList<Tuple2<String, Integer> > output = new ArrayList<>();
		Tuple2<String, Integer> v = new Tuple2<String, Integer>(null,null);
		
		if (field_values.indexOf("\"") != 0) {
			field_values = "\"" + field_values + "\"";
		}
		String query = "select blogger, max(influence_score) m\r\n" + 
				"from blogposts\r\n" + 
				"where "+field_name+" in ("+field_values+") \r\n" + 
				"and date > \""+from+"\" \r\n" + 
				"and date < \""+to+"\"\r\n" + 
				"group by blogger order by m desc limit "+limit+";";
		
		ResultSet post_all =  DbConnection.queryResultSet(query);
		
		while(post_all.next()){
			String blogger = post_all.getString("blogger").replaceAll("\\s+", " ").replace("By","").replace("by","").trim();
			int count = post_all.getInt("m");
			
			v = new Tuple2<String, Integer>(blogger,count);
			output.add(v);
		}

		post_all.close();
		return output;
	}
	
	public static void main(String[] args) {
		try {
			getMostInfluentialBloggers("blogsite_id", "\"2649\",\"1319\",\"3436\"", "2020-01-01", "2020-11-11", "10");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
