package util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL; 
import org.json.JSONObject;
import org.json.JSONArray;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import authentication.DbConnection;


public class Favourites {
	   
	public ArrayList _list(String userid) throws Exception {
		DbConnection dbinstance = new DbConnection();
		ArrayList list = dbinstance.query("SELECT * FROM favourites where userid = '"+userid+"' ");			
		return  list;   
	}
		
	public ArrayList _get(String fid) throws Exception {	
		DbConnection dbinstance = new DbConnection();
		ArrayList list = dbinstance.query("SELECT * FROM favourites where favourite_id = '"+fid+"' ");			
		return  list;   
	}

}