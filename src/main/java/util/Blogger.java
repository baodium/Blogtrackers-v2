package util;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.SQLException;

import org.json.JSONObject;
import java.util.*;

import authentication.DbConnection;

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

}
