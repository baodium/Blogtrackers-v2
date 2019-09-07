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

public class Comment {
	HashMap<String, String> hm = DbConnection.loadConstant();
	
	public String _getCommentById(String blog_ids) {
		String count = "";
		blog_ids = blog_ids.replaceAll(",$", "");
		blog_ids = blog_ids.replaceAll(", $", "");
		blog_ids = "("+blog_ids+")";
		
		try {
			ArrayList response = DbConnection.query("SELECT sum(comment_count) from comments where blogsite_id in "+blog_ids+" ");		
			if(response.size()>0){
			 	ArrayList hd = (ArrayList)response.get(0);
				count = hd.get(0).toString();
			}
		}catch(Exception e){
			System.out.print("Error in getBlogPostById");
		}
		return count;
	}
	
	public String _getCommentByBlogger(String blogger) {
		String count = "";
		
		try {
			
			//"SELECT (select distinct blogsite_name from blogsites bs where bl.blogsite_id = bs.blogsite_id) AS blogsiteName,  MAX(bl.influence_score), bl.blogsite_id FROM blogger bl where blogsite_id in "+
				//	(blogids)+" group by blogsiteName order by influence_score desc"
					
			//ArrayList response = DbConnection.query("SELECT sum(comment_count) from comments where blogsite_id in "+blog_ids+" ");		
			
			ArrayList response = DbConnection.query("SELECT (select sum(comment_count)  from blogtrackers.comments cm where cm.blogsite_id = bp.blogsite_id) AS total_comment FROM blogtrackers.blogposts bp where blogger='"+blogger+"'");		
			if(response.size()>0){
			 	ArrayList hd = (ArrayList)response.get(0);
				count = hd.get(0).toString();
			}
		}catch(Exception e){
			System.out.print("Error in getBlogPostByblogger");
		}
		return count;
	}

}
