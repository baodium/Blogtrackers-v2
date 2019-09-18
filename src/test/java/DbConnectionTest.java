import java.util.HashMap;

import authentication.*;
<<<<<<< HEAD

=======
import org.json.*;
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7

public class DbConnectionTest {
	public static void main(String[] args) {
		DbConnection testConnection = new DbConnection();
<<<<<<< HEAD
		//HashMap<String, String> hm = new HashMap<String, String>();
=======
		System.out.println(testConnection.getConnection());
		JSONObject js = new JSONObject();
		js.put("wale", "Obadimu");
		System.out.println(js.get("wale"));
//HashMap<String, String> hm = new HashMap<String, String>();
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
		
		//hm = DbConnection.loadConstant();		
		//System.out.println(testConnection.isUserExists("baodium"));
		//System.out.println(hm.get("elasticIndex")+"blogposts/");						// Test JDBC Connection
		//System.out.println(testConnection.md5Funct("wale"));
		//testConnection.addUser("abcabc", "pass", "baodium@gmail.com");
		//testConnection.removeUser("ax");
		//System.out.println(new DbConnection().query("SELECT * FROM usercredentials where Email = '"+baodium@gmail.com+"'"));
<<<<<<< HEAD
		System.out.println(new DbConnection().insertRecord("insert into favorites (userid,blogpost_ids,created_date) "
				+ "VALUES ('nihal1','12,23,56','DATETIME')"));
=======
//		System.out.println(new DbConnection().insertRecord("insert into favorites (userid,blogpost_ids,created_date) "
//				+ "VALUES ('nihal1','12,23,56','DATETIME')"));
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
	}
}
