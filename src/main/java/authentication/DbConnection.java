/**
 * The class DbConnection is used to create/read/update/delete database connections etc.
 * 
 * <p>
 * The method loadConstant is used to load the connection parameter from a remote config file for security reasons
 * @author Oluwaseun Johnson
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
import java.util.Map;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import java.util.Map.Entry;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import org.json.JSONArray;
import org.json.JSONObject;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

public class DbConnection {
	/**
	 * loadConstant() - For loading the configuration file from a remote repository
	 * @return hashmap
	 */

	public static HashMap<String, String> loadConstant() {
		HashMap<String, String> hm = new HashMap<String, String>();
		BufferedReader br = null;
		try {
			br = new BufferedReader(new FileReader("C:/blogtrackers.config")); // Read the config file
			String temp = ""; // Temporary variable to loop through the content of the file
			String[] arr;
			while ((temp = br.readLine()) != null) {
				temp = temp.trim(); // Strip the whitespaces
				if (temp.isEmpty() || temp.startsWith("//")) {
					continue; // Skip the comments, for example the author, created on and document type
				} else {
					arr = temp.split("##"); // Split it by ##, for example, if you have name##wale, then arr[0] = name
											// and arr[1] = wale and arr.length = 2 since it contains 2 elements
					if (arr.length == 2) {
						hm.put(arr[0].trim(), arr[1].trim()); // Save the element as a key value pair. Using example
																// above, the Hashmap will be [user, wale], where user
																// is the key and wale is the value
					}
				}
			}
		} catch (IOException ex) {
			Logger.getLogger(DbConnection.class.getName()).log(Level.SEVERE,
					"Encounter error while loading config file", ex); // To log the error for this specific class
		}
		return hm;
	}

	/**
	 * For getting the connection parameter and connecting to the database driver
	 * @return connection
	 */
	// hello
	public static Connection getConnection() {
		try {
			HashMap<String, String> hm = new HashMap<String, String>();

			hm = DbConnection.loadConstant(); // load the connection parameter so we can fetch appropriate parameters
												// like username, password, etc
			String connectionURL = hm.get("dbConnection"); // "jdbc:mysql://localhost:3306/blogtrackers";
			String driver = hm.get("driver");
			String username = hm.get("dbUserName");// "root";//
			String password = hm.get("dbPassword");
			String elastic = hm.get("elasticIndex");

			if (connectionURL != null && username != null && password != null) { // check to see if the connection
																					// parameter was successfully loaded
				try {
					Class.forName(driver); // com.mysql.jdbc.Driver
					// load the connection driver
				} catch (ClassNotFoundException ex) { // since this class can throw ClassNotFoundException so we are
														// catching it
					ex.printStackTrace();
					System.out.println("Encounter error while connecting to the database");// if there is an exception,
																							// give us a stacktrace of
																							// it
				}
			}
			Connection conn = DriverManager.getConnection(connectionURL, username, password); // create an instance of
																								// the connection using
																								// the JDBC driver
			return conn;
		} catch (SQLException ex) {
			Logger.getLogger(DbConnection.class.getName()).log(Level.SEVERE,
					"Encounter error while connecting to the database", ex); // Log the error for this specific class
		}
		return null; // Returns nothing if the connection is not successful
	}

	/**
	 * * This method checks to see if the username is already in the database We use
	 * this method to verify if a user already has an account in our database
	 * @param iUserName username of user
	 * @return boolean; True if user exists and False if other wise
	 */
	public boolean isUserExists(String iUserName) // This method returns True/False depending on whether the user is in
													// our database
	{

		try {
			String queryStr = "SELECT UserName FROM UserCredentials where UserName = ?"; // Bind the variable to prevent
																							// SQL injection
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement(queryStr);
			pstmt.setString(1, iUserName);

			if (pstmt.execute())

			{
				pstmt.close();
				conn.close();
				return true;
			} else {
				pstmt.close();
				conn.close();
				return false;
			}

		} catch (SQLException e) {

			e.printStackTrace();
			return false;
		}
	}

	/**
	 * same as isUserExists
	 * @param iUserName username of user
	 * @return boolean; True if user exists and False if other wise
	 */
	public boolean removeUser(String iUserName) 
	{
		try {

			String queryStr = "Delete FROM UserCredentials where UserName = ?";
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement(queryStr);
			pstmt.setString(1, iUserName);

			if (pstmt.execute()) {
				pstmt.close();
				conn.close();
				return true;
			} else {
				pstmt.close();
				conn.close();
				return false;
			}

		} catch (SQLException e) {

			e.printStackTrace();
			return false;
		}
	}

	/**
	 * add user to usercredentials table
	 * @param iUserName username of user
	 * @param iPassword password of user
	 * @param iEmail email of user
	 */
	public void addUser(String iUserName, String iPassword, String iEmail) {
		if (isUserExists(iUserName)) {
			System.out.println("User already exists");
		} else {
			String queryStr = "INSERT INTO UserCredentials VALUES(?,?,?)";
			String queryStr1 = "INSERT INTO User_Watches VALUES(?,?,?,?)";
			try {
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
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

	/**
	 * Update table query
	 * @param query MySQL query string
	 * @return boolean; True if table updated and False if otherwise
	 */
	public boolean updateTable(String query) {

		boolean donee = false;
		try {

			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement(query);

			int done = pstmt.executeUpdate(query);
			// rs = stmt.executeQuery(query);
			donee = true;
			pstmt.close();
			conn.close();

		} catch (SQLException ex) {
			// donee=false;
		}
		return donee;
	}

	/**
	 * Insert record query
	 * @param query query string
	 * @return boolean; True if table inserted and False if otherwise
	 */
	public boolean insertRecord(String query) {
		boolean donee = false;
		try {
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement(query);

			int done = pstmt.executeUpdate(query);

			donee = true;
			pstmt.close();
			conn.close();
		} catch (SQLException ex) {
			// donee = false
		}
		return donee;
	}

	/**
	 * Query Database
	 * @param query query string
	 * @return arraylist result
	 */
	public static ArrayList query(String query) {
		ArrayList result = new ArrayList();
		try {
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement(query);
			ResultSet rs = pstmt.executeQuery();
			Statement stmt = null;
			if (rs.next()) {
				stmt = conn.prepareStatement(query);
				rs = stmt.executeQuery(query);
				ResultSetMetaData rsmd = rs.getMetaData();
				int column_size = rsmd.getColumnCount();
				int i = 0;
				while (rs.next()) {
					ArrayList output = new ArrayList();
					int total = column_size;
					for (int j = 1; j <= (total); j++) {
						output.add((j - 1), rs.getString(j));
					}
					result.add(i, output);
					i++;
				}

				rs.close();
				pstmt.close();
				conn.close();
			} else {
				rs.close();
				pstmt.close();
				conn.close();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * Query Database  
	 * @param query query string
	 * @return json result
	 */
	public static ArrayList queryJSON(String query) {

		ArrayList<String> list = new ArrayList<String>();
		ArrayList result = new ArrayList();

		try {
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement(query);
			ResultSet rs = pstmt.executeQuery();
			Statement stmt = null;
			if (rs.next()) {
				stmt = conn.prepareStatement(query);
				rs = stmt.executeQuery(query);
				ResultSetMetaData rsmd = rs.getMetaData();
				int column_size = rsmd.getColumnCount();

				int i = 0;
				while (rs.next()) {
					// ArrayList output=new ArrayList();
					int total = column_size;
					JSONObject jobj = new JSONObject();
					for (int j = 1; j <= (total); j++) {
						String name = rsmd.getColumnName(j);
						// output.add((j-1), rs.getString(j));
						jobj.put(name, rs.getString(j));
					}

					JSONObject source = new JSONObject();
					source.put("_source", jobj);
					list.add(source.toString());

					i++;
				}

				rs.close();
				pstmt.close();
				conn.close();
			} else {
				rs.close();
				pstmt.close();
				conn.close();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return list;
	}

	/**
	 * calculates the MD5 hash of a string.
	 * @param userNamePass user password
	 * @return hashed string
	 */
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

	/**
	 * Custom query for Keyword Trend 
	 * @param query query string for Keyword Trend
	 * @return hashmap result
	 */
	public static HashMap queryKWT(String query) {
		HashMap result = new HashMap();
		HashMap<String, Integer> keyword_trend = new HashMap<String, Integer>();
		HashMap<String, Integer> post_count = new HashMap<String, Integer>();
		try {
			Connection conn = getConnection();
			Statement stmt = conn.createStatement();
			ResultSet rs = stmt.executeQuery(query);
			System.out.println(query);
			while (rs.next()) {
				String date = rs.getString("date");
				if (date != null) {
					String year = date.split("-")[0];
					if (keyword_trend.get(year) == null) {
						int count = rs.getInt("count");
						keyword_trend.put(year, count);
					} else {
						int count = rs.getInt("count");
						int old_count = keyword_trend.get(year);
						int new_count = count + old_count;
						keyword_trend.put(year, new_count);
					}
				}
			}
			conn.close();
			result.put("KWT", keyword_trend);
			return result;
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return result;
	}

	public static void main(String[] args) {

		System.out.println("started");
		// String q = "SELECT date,\r\n" +
		// "sum(ROUND ((LENGTH(lower(post)) - LENGTH(REPLACE (lower(post), \"people\",
		// \"\"))) / LENGTH(\"people\"))) AS count\r\n" +
		// "from (select *\r\n" +
		// "from blogposts\r\n" +
		// "where match (post)\r\n" +
		// "against (\"people\" IN BOOLEAN MODE)) a\r\n" +
		// "where blogsite_id\r\n" +
		// "in (63,127)\r\n" +
		// "group by year(date)";
		// (63,127,223,224,611,615,617,641,673,720,817,872,874,949,954,957,961,1030,1033,1034,1035,1036,1038,1040,1041,1042,1049,1051,1052,1054,1055,1056,1058,1063,1064,1065,1066,1067,1068,1069,1083,1084,1088,1089,1092,1095,1100,1101,1105,1121,1122,1124,1126,1127,1128,1134,1137,1139,1141,1148,1163,1164,1166,1169,1172,1173,1184,1185,1188,1195,1196,1204,1207,1210,1211,1213,1218,1220,1221,1222,1233,1235,1238,1239,1240,1242,1244,1250,1251,1256,1258,1262,1279,1280,1282,1288,1290,1293,1295,1297,1303,1306,1307,1315,1319,1324,1330,1333,1339,1341,1346,1350,1352,1360,1376,1379,1380,1381,1385,1387,1392,1394,1397,1399,1409,1417,1421,1424,1426,1429,1438,1439,1440,1446,1447,1448,1451,1455,1456,1457,1458,1459,1460,1461,1472,1474,1475,1478,1486,1487,1489,1490,1492,1493,1497,1501,1503,1504,1506,1507,1509,1516,1523,1525,1526,1531,1533,1543,1561,1563,1567,1568,1569,1574,1575,1582,1583,1595,1601,1602,1604,1608,1611,1614,1615,1623,1627,1628,1630,1637,1638,1639,1642,1651,1655,1659,1660,1661,1662,1663,1668,1669,1676,1681,1682,1684,1685,1686,1688,1689,1690,1691,1692,1693,1694,1697,1698,1699,1700,1701,1703,1704,1705,1706,1707,1708,1709,1710,1711,1712,1713,1714,1715,1716,1717,1718,1719,1720,1721,1722,1723,1724,1725,1726,1727,1728,1729,1730,1731,1732,1733,1734,1735,1736,1737,1738,1739,1740,1742,1743,1744,1745,1746,1747,1749,1750,1751,1752,1753,1754,1755,1756,1757,1759,1761,1762,1763,1764,1765,1766,1767,1768,1769,1770,1771,1772,1773,1774,1775,1776,1777,1778,1779,1780,1781,1782,1783,1784,1786,1787,1788,1790,1791,1792,1793,1794,1795,1796,1797,1798,1799,1800,1801,1802,1803,1804,1806,1807,1808,1809,1810,1811,1812,1813,1814,1815,1816,1817,1818,1822,1823,1824,1825,1826,1827,1829,1830,1831,1833,1834,1835,1836,1837,1838,1839,1840,1841,1842,1843,1844,1845,1846,1848,1849,1850,1851,1852,1853,1854,1856,1857,1858,1859,1860,1861,1862,1863,1864,1865,1866,1867,1868,1869,1870,1871,1872,1873,1874,1875,1876,1878,1886,1907,1927,1929,1934,1940,1943,1944,1952,1957,1961,1963,1964,1965,1966,1968,1971,1973,1974,1977,1978,2050)
		// String q = "SELECT post, title, blogpost_id, date, \r\n" +
		// "ROUND ((LENGTH(lower(post)) - LENGTH(REPLACE (lower(post), \"uche\", \"\")))
		// / LENGTH(\"uche\")) AS count\r\n" +
		// "from (select *\r\n" +
		// "from blogposts\r\n" +
		// "where match (title,post)\r\n" +
		// "against (\"uche\" IN BOOLEAN MODE)) a\r\n" +
		// "where blogsite_id\r\n" +
		// "in (617,961,1030)\r\n" +
		// "\r\n";

		// String q = "SELECT terms from blogpost_terms_api where blogsiteid in (62,88,117,128,238,248,254,255,616,641,777,787,858,859,860,862,863,874,923,966,1030)";

		// List<HashMap<String, Integer>> result = queryTerms(q);
		// System.out.println("DOne with query");
		Instant start = Instant.now();
		// HashMap<String, Integer> map_count = result.stream().flatMap(map -> map.entrySet().parallelStream())
		// 		.collect(Collectors.toMap(Entry::getKey, Entry::getValue, Integer::sum, HashMap::new));

		// System.out.println("done with counting");
		// System.out.println(map_count);
		// ArrayList test = query(q);

		// System.out.println(result);
		Instant end = Instant.now();
		Duration timeElapsed = Duration.between(start, end);
		System.out.println("Time taken: " + timeElapsed.getSeconds() + " seconds");
	}

}
