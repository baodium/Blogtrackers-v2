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
import java.util.logging.Level;
import java.util.logging.Logger;

public class DbConnection {
	/**
	 * loadConstant() - For loading the configuration file from a remote repository	
	 */
	private static HashMap<String, String> hm = new HashMap<String, String>();				// Hashmap that will contain the key-value pair from the config file
	private static void loadContant() {
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
	}

	/**
	 * getConnection() - For getting the connection parameter and connecting to the database driver
	 */

	public static Connection getConnection() {
		try{
			loadContant();															//load the connection parameter so we can fetch appropriate parameters like username, password, etc
			String connectionURL = hm.get("dbConnection");								
			String driver = hm.get("driver"); 
			String username = hm.get("dbUserName");
			String password = hm.get("dbPassword");

			if(connectionURL != null && username != null && password != null) {		//check to see if the connection parameter was successfully loaded
				try {
					Class.forName(driver);											//load the connection driver
				}catch(ClassNotFoundException ex) {									//since this class can throw ClassNotFoundException so we are catching it
					ex.printStackTrace();											//if there is an exception, give us a stacktrace of it
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
			String queryStr = "SELECT UserName FROM UserCredentials where Username = ?";	//Bind the variable to prevent SQL injection
			Connection conn = getConnection();												//Get a connection to the database
			PreparedStatement pstmt = conn.prepareStatement(queryStr);						//Prepared statement to perform parametized query
			pstmt.setString(1, iUserName);													
			ResultSet rs = pstmt.executeQuery();											//executeQuery because we are retrieving data; could have used execute but not executeUpdate since we are not altering the database
			if(rs.next())																	//This statement will evaluate to false since there won't any row after the update, hence close the database connection to avoid memory leaking 
			{
				rs.close();																	
				pstmt.close();
				conn.close();
				return true;
			}
			else
			{
				rs.close();
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
	
	
	public boolean removeUser(String iUserName)											//same as user
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
	
	
	public ArrayList query(String query){
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
}
