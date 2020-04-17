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
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.json.JSONArray;
import org.json.JSONObject;

public class DbConnection {
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
			Logger.getLogger(DbConnection.class.getName()).log(Level.SEVERE, "Encounter error while loading config file", ex);	//To log the error for this specific class
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
			
			hm = DbConnection.loadConstant();				//load the connection parameter so we can fetch appropriate parameters like username, password, etc
			String connectionURL =  hm.get("dbConnection");	//"jdbc:mysql://localhost:3306/blogtrackers";						
			String driver =    hm.get("driver"); 
			String username =  hm.get("dbUserName");//"root";//
			String password = hm.get("dbPassword");
			String elastic = hm.get("elasticIndex");
			
			

			if(connectionURL != null && username != null && password != null) {		//check to see if the connection parameter was successfully loaded
				try {
					Class.forName(driver);	//com.mysql.jdbc.Driver	
					//load the connection driver
				}catch(ClassNotFoundException ex) {									//since this class can throw ClassNotFoundException so we are catching it
					ex.printStackTrace();
					System.out.println("Encounter error while connecting to the database");//if there is an exception, give us a stacktrace of it
				}
			}
			Connection conn = DriverManager.getConnection(connectionURL, username, password);  //create an instance of the connection using the JDBC driver
			return conn;
		} catch(SQLException ex) {
			Logger.getLogger(DbConnection.class.getName()).log(Level.SEVERE, "Encounter error while connecting to the database", ex);	//Log the error for this specific class
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
	public boolean isUserExists(String iUserName)										//This method returns True/False depending on whether the user is in our database					
	{

		
		try{
			String queryStr = "SELECT UserName FROM UserCredentials where UserName = ?";	//Bind the variable to prevent SQL injection
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement(queryStr);
			pstmt.setString(1, iUserName);

			if(pstmt.execute())															

			{
				pstmt.close();
				conn.close();
				return true;
			}
			else
			{
				pstmt.close();
				conn.close();
				return false;
			}

		}catch(SQLException e)
		{

			e.printStackTrace();
			return false;
		}
	}


	
	public boolean removeUser(String iUserName)											//same as isUserExists
	{
		try{

			String queryStr = "Delete FROM UserCredentials where UserName = ?";
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement(queryStr);
			pstmt.setString(1, iUserName);

			if(pstmt.execute())															
			{
				pstmt.close();
				conn.close();
				return true;
			}
			else
			{
				pstmt.close();
				conn.close();
				return false;
			}

		}catch(SQLException e)
		{

			e.printStackTrace();
			return false;
		}
	}

	public void addUser(String iUserName,String iPassword,String iEmail)
	{
		if(isUserExists(iUserName))
		{
			System.out.println("User already exists");
		}
		else
		{
			String queryStr = "INSERT INTO UserCredentials VALUES(?,?,?)";
			String queryStr1 = "INSERT INTO User_Watches VALUES(?,?,?,?)";
			try{
				Connection conn = getConnection();
				PreparedStatement stmt = conn.prepareStatement(queryStr);
				stmt.setString(1, iUserName);
				stmt.setString(2, iPassword);
				stmt.setString(3, iEmail);
				stmt.execute();
				stmt = conn.prepareStatement(queryStr1);
				stmt.setString(1, iUserName);
				stmt.setString(2, "");
				stmt.setString(3, iEmail);
				stmt.setInt(4, 0);
				stmt.execute();
				stmt.close();
				conn.close();
			}catch(SQLException e)
			{
				e.printStackTrace();
			}
		}
	}
	
	
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
	public static ArrayList queryJSON(String query){
		
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
	
	
	
	
	public String md5Funct(String userNamePass) {
		try {
			MessageDigest md = MessageDigest.getInstance("MD5");
			md.update(userNamePass.getBytes());
			byte byteData[] = md.digest();
			StringBuilder hexString = new StringBuilder();
			for (int i = 0; i < byteData.length; i++) {
				String hex = Integer.toHexString(0xff & byteData[i]);
				if (hex.length() == 1)
					hexString.append('0');
				hexString.append(hex);
			}
			return hexString.toString();
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	// static void split(String query)
	
	public static void main(String [] args) {
		Instant start = Instant.now();
		System.out.println("started");
		ArrayList test = queryJSON("SELECT * FROM blogtrackers.blogpost_terms where blogsiteid in (142,153,229,148,127,46,3,170,154,72,38,224,157,128,61,112,140,116,125,193,173,74,249,250,243,263,98,69,62,78,117,73,135,133,100,143,77,233,221,163,132,147,150,43,242,111,101,86,199,251,118,106,121,129,49,48,66,91,176,124,167,215,141,166,17,220,119,236,230,225,252,20,130,22,76,235,85,245,79,26,109,80,131,253,105,226,137,115,52,53,65,213,96,238,210,136,239,27,206,107,63,57,204,205,216,208,36,102,134,108,113,59,54,88) order by blogsiteid limit 0,10000");
//		DbConnection.queryJSON("select * from blogpost_terms where blogger = \"" + bloggers + "\" and date > \"" + from + "\" and date < \"" +  to +"\"");
		for(int i = 0; i < 1; i++) {
			System.out.println(test.get(i));
		}
		System.out.println(test.size());
		Instant end = Instant.now();
		Duration timeElapsed = Duration.between(start, end);
		System.out.println("Time taken: " + timeElapsed.getSeconds() + " seconds");
	}
	
}
