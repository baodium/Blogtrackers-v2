/**
 * The class DbConnection is used to create/read/update/delete database connections etc.
 * 
 * <p>
 * The method loadConstant is used to load the connection parameter from a remote config file for security reasons
 * @author Adewale Obadimu
 */

package authentication;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.json.JSONArray;
import org.json.JSONObject;

public class AutomatedCrawlerConnect {
	/**
	 * loadConstant() - For loading the configuration file from a remote repository	
	 */
	
	public static HashMap<String, String> loadConstant() {
		HashMap<String, String> hm = new HashMap<String, String>();
		BufferedReader br = null;	
		try {
			br = new BufferedReader(new FileReader("C:/blogtrackers.config"));  	// Read the config file
			String temp = "";														// Temporary variable to loop through the content of the file
			String[] arr;
			while((temp = br.readLine()) != null) {
				temp = temp.trim();  											 	// Strip the whitespaces 
				if(temp.isEmpty() || temp.startsWith("//")) { 						
					continue;														// Skip the comments, for example the author, created on and document type
				}
				else {
					arr = temp.split("##");											// Split it by ##, for example, if you have name##wale, then arr[0] = name and arr[1] = wale and arr.length = 2 since it contains 2 elements
					if(arr.length == 2) {
						hm.put(arr[0].trim(), arr[1].trim());						// Save the element as a key value pair. Using example above, the Hashmap will be [user, wale], where user is the key and wale is the value
					}
				}	
			}
		} catch(IOException ex) {
			Logger.getLogger(AutomatedCrawlerConnect.class.getName()).log(Level.SEVERE, "Encounter error while loading config file", ex);	//To log the error for this specific class
		}
		return hm;
	}

	/**
	 * getConnection() - For getting the connection parameter and connecting to the database driver
	 */
// hello
	public  static Connection getConnection() {
		try{
			HashMap<String, String> hm = new HashMap<String, String>();
			
			hm = AutomatedCrawlerConnect.loadConstant();				//load the connection parameter so we can fetch appropriate parameters like username, password, etc
			String connectionURL =  hm.get("dbConnection");	//"jdbc:mysql://localhost:3306/blogtrackers";						
			String driver =    hm.get("driver"); 
			String username =  hm.get("dbUserName");//"root";//
			String password = hm.get("dbPassword");
			String elastic = hm.get("elasticIndex");
			String crawler = hm.get("automatedCrawler");
			
			

			if(connectionURL != null && username != null && password != null) {		//check to see if the connection parameter was successfully loaded
				try {
					Class.forName(driver);	//com.mysql.jdbc.Driver	
					//load the connection driver
				}catch(ClassNotFoundException ex) {									//since this class can throw ClassNotFoundException so we are catching it
					ex.printStackTrace();
					System.out.println("Encounter error while connecting to the database");//if there is an exception, give us a stacktrace of it
				}
			}
			Connection conn = DriverManager.getConnection(crawler, username, password);  //create an instance of the connection using the JDBC driver
			return conn;
		} catch(SQLException ex) {
			Logger.getLogger(AutomatedCrawlerConnect.class.getName()).log(Level.SEVERE, "Encounter error while connecting to the database", ex);	//Log the error for this specific class
		}
		return null;																//Returns nothing if the connection is not successful
	}

	
	/*
	 * This method checks to see if the username is already in the database
	 * We use this method to verify if a user already has an account in our database
	 * 
	 * @param: iUsername: The username of the user
	 * 
	 */
	
	public boolean updateTable(String query){
		      
		boolean donee =false;
		try {
			
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement(query);
			
		    int done = pstmt.executeUpdate(query);
			//rs = stmt.executeQuery(query);
			donee=true;
			pstmt.close();
			conn.close();

		} catch (SQLException ex) {
			//donee=false;    
		} 
		return donee;
	}
	
	public boolean insertRecord(String query)
	{
		boolean donee = false;
		try
		{
		Connection conn = getConnection();
		PreparedStatement pstmt = conn.prepareStatement(query);
		
		int done = pstmt.executeUpdate(query);
		
		donee=true;
		pstmt.close();
		conn.close();
		}
		catch(SQLException ex)
		{
		// donee = false	
		}
		return donee;
	}
	
	
	/* Query Database*/
	
	public static ArrayList query(String query){
		ArrayList result=new ArrayList(); 
		try{
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement(query);
			ResultSet rs = pstmt.executeQuery();
			Statement stmt = null;
			if(rs.next())
			{
				stmt = conn.prepareStatement(query);
				rs = stmt.executeQuery(query); 
				ResultSetMetaData rsmd = rs.getMetaData();
				int column_size = rsmd.getColumnCount();
				int i=0;
				while(rs.next()){
					ArrayList output=new ArrayList();
					int total=column_size;
					for(int j=1;j<=(total); j++ ){
						output.add((j-1), rs.getString(j));
					}
					result.add(i, output);
					i++;
				}
				
				
				rs.close();
				pstmt.close();
				conn.close();
			}
			else
			{
				rs.close();
				pstmt.close();
				conn.close();
			}
		}catch(SQLException e){
			e.printStackTrace();
		}
		
		return result;
	}
	
	
	/* Query Database and return json result*/
	public ArrayList queryJSON(String query){
		
		ArrayList<String> list = new ArrayList<String>();
		ArrayList result=new ArrayList(); 
		
		
		try{
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement(query);
			ResultSet rs = pstmt.executeQuery();
			Statement stmt = null;
			if(rs.next())
			{
				stmt = conn.prepareStatement(query);
				rs = stmt.executeQuery(query); 
				ResultSetMetaData rsmd = rs.getMetaData();
				int column_size = rsmd.getColumnCount();
				
				
				int i=0;
				while(rs.next()){
					//ArrayList output=new ArrayList();
					int total=column_size;
					JSONObject jobj = new JSONObject();
					for(int j=1;j<=(total); j++ ){
						String name = rsmd.getColumnName(j);					 
						//output.add((j-1), rs.getString(j));
						jobj.put(name,rs.getString(j));					
					}
					
					JSONObject source = new JSONObject();
					source.put("_source",jobj);
					list.add(source.toString());
					
				     
					i++;
				}
				
				
				rs.close();
				pstmt.close();
				conn.close();
			}
			else
			{
				rs.close();
				pstmt.close();
				conn.close();
			}
		}catch(SQLException e){
			e.printStackTrace();
		}
			 
		return list;
	}
	
	public ArrayList<String> query2(String query){
		ArrayList<String> result=new ArrayList<String>(); 
		try{
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement(query);
			ResultSet rs = pstmt.executeQuery();
			Statement stmt = null;
			if(rs.next())
			{
				stmt = conn.prepareStatement(query);
				rs = stmt.executeQuery(query); 
				ResultSetMetaData rsmd = rs.getMetaData();
				int column_size = rsmd.getColumnCount();
				int i=0;
				while(rs.next()){
					ArrayList output=new ArrayList();
					int total=column_size;
					for(int j=1;j<=(total); j++ ){
						output.add((j-1), rs.getString(j));
					}
					result.addAll(i, output);
					i++;
				}
				
				
				rs.close();
				pstmt.close();
				conn.close();
			}
			else
			{
				rs.close();
				pstmt.close();
				conn.close();
			}
		}catch(SQLException e)
		{
			e.printStackTrace();
		}
		
		return result;
	}
}
	