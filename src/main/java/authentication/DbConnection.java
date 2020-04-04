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
	
	public static void main(String [] args) {
		Instant start = Instant.now();
		ArrayList test = queryJSON("select * from blogtrackers.blogposts where blogpost_id in (70,17633,17642,17646,17658,17668,17680,17683,17686,17691,17710,17722,17728,17756,17770,17778,17780,17785,17787,17791,17795,17798,17800,17808,17820,17823,17835,17842,17858,17868,17873,17874,17875,17879,17884,17886,17888,17897,17899,17900,17915,17918,17919,17921,17924,17930,17931,17932,17937,17938,17944,17947,17948,17950,17951,17969,17983,17989,17990,17992,17994,17999,18001,18010,18014,18025,18029,18031,18033,18048,18049,18057,18060,18069,18082,18095,18102,18137,18142,18151,18162,18171,18188,18204,18214,18233,18240,18241,18250,18263,18278,18279,18284,18291,18292,18302,18312,18319,18322,18325,18326,18329,18334,18335,18346,18360,18370,18374,18387,18394,18409,18421,18440,18448,18452,18460,18463,18465,18474,18475,18502,18508,18518,18519,18522,18524,18532,18546,18548,18560,18564,18576,18588,18598,18624,18636,18637,18646,18669,18674,18677,18694,18704,18706,18709,18710,18722,18726,18762,18768,18787,18789,18799,18801,18803,18807,18809,18823,18841,18856,18857,18860,18863,18869,18881,18886,18896,18901,18904,18907,18912,18923,18950,18967,18968,18980,18982,18987,18992,19010,19020,19021,19031,19035,19038,19062,19076,19080,19082,19110,19114,19115,19126,19129,19134,19150,19151,19158,19170,19174,19185,19189,19192,19210,19221,19226,19227,19235,19240,19261,19264,19272,19275,19276,19284,19297,19312,19326,19333,19340,19341,19343,19375,19381,19384,19390,19393,19401,19404,19406,19407,19410,19414,19417,19419,19426,19428,19435,19438,19442,19447,19449,19452,19455,19478,19483,19488,19495,19500,19530,19531,19534,19535,19545,19555,19568,19571,19580,19582,19584,19615,19618,19631,19633,19642,19644,19646,19652,19653,19657,19661,19663,19664,19665,19666,19669,19674,19678,19696,19700,19705,19741,19744,19751,19759,19760,19770,19771,19789,19801,19808,19809,19820,19821,19840,19843,19847,19887,19888,19891,19898,19904,19905,19912,19922,19933,19935,19952,19953,19959,19964,19972,19979,19980,19983,19995,20004,20015,20040,20045,20051,20052,20073,20076,20082,20093,20101,20105,20124,20127,20129,20130,20143,20145,20165,20176,20179,20187,20193,20215,20225,20226,20235,20242,20255,20256,20260,20263,20272,20277,20290,20299,20317,20319,20323,20324,20327,20336,20341,20348,20352,20354,20364,20366,20369,20372,20383,20390,20393,20396,20397,20398,20400,20410,20411,20422,20430,20435,20436,20440,20445,20446,20486,20489,20526,20532,20538,20557,20558,20559,20561,20563,20596,20599,20604,20608,20625,20626,20644,20647,20648,20652,20662,20672,20680,20701,20703,20704,20706,20719,20720,20735,20736,20743,20748,20749,20756,20759,20769,20785,20787,20794,20805,20807,20809,20810,20812,20817,20818,20821,20825,20828,20837,20843,20855,20860,20861,20869,20870,20874,20875,20876,20885,20893,20913,20915,20927,20931,20936,20956,20964,20965,20975,20977,20981,20985,20986,20988,20989,20995,21009,21010,21013,21018,21034,21035,21045,21055,21062,21073,21074,21077,21082,21088,21107,21113,21118,21119,21127,21145,21164,21168,21175,21180,21181,21187,21188,21199,21200,21203,21209,21224,21225,21227,21228,21231,21232,21234,21243,21246,21253,21258,21266,21273,21275,21278,21279,21280,21286,21296,21309,21310,21314,21317,21321,21322,21330,21331,21336,21349,21351,21355,21356,21357,21361,21362,21370,21384,21386,21387,21388,21390,21412,21415,21421,21423,21433,21436,21449,21450,21460,21461,21463,21475,21481,21527,21528,21532,21542,21545,21548,21572,21577,21584,21593,21605,21607,21611,21613,21614,21619,21634,21641,21646,21647,21658,21664,21695,21697,21703,21707,35429,35472,35483,35503,35505,35523,35525,35584,35589,35640,35681,35729,35743,35826,35831,35880,35919,35967,35981,74954,75005,85323,85340,85345,85361,85363,87805,87807,91552,91553,91560,91572,91578,91585,91592,91594,91606,91623,91633,91641,91649,91655,91656,91663,91665,91676,91681,91685,239037,239041,239042,239049,239051,239055,239057,239063,239074,239087,239092,239094,239098,239107,239110,239111,239114,239119,239245,239294,239296,241279,241311,241469,241605,241615,241656,241658,241697,241721)");
		for(int i = 0; i < 1; i++) {
			System.out.println(test.get(i));
		}
		System.out.println(test.size());
		Instant end = Instant.now();
		Duration timeElapsed = Duration.between(start, end);
		System.out.println("Time taken: " + timeElapsed.getSeconds() + " seconds");
	}
	
}
