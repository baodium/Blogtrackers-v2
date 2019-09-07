package util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.SQLException;

import org.json.JSONObject;

import authentication.DbConnection;

import org.apache.commons.lang3.ArrayUtils;
import org.json.JSONArray;

import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.util.*;
import java.time.format.DateTimeFormatter;  
import java.time.LocalDateTime; 

public class Favorites{
// add new favorite post in Favorite table
public String insertPostInFavorite(String username, String blogpostid)
{
ArrayList checkFavoritesRecord  = new ArrayList();	
LocalDateTime currentdatetime  = LocalDateTime.now();
String message = "";
// check if the record exists
//System.out.println("I am in insert record");
checkFavoritesRecord = new DbConnection().query("select * from favorites where userid ='"+username+"'");
//System.out.println(checkFavoritesRecord.size());
if(checkFavoritesRecord.size() == 0)
{
// insert a record if it does not exist	
boolean inserted = new DbConnection().insertRecord("insert into favorites (userid,blogpost_ids,created_date,updated_date) VALUES ('"+username+"','"+blogpostid+"','"+currentdatetime+"','"+currentdatetime+"')");
//System.out.println(inserted);	
}
else
{
// select the initial blog 	
checkFavoritesRecord = new DbConnection().query("select blogpost_ids from favorites where userid ='"+username+"'");
boolean blogpostexist = false;
String allblogposttoupdate = "";
// check if exist get the value of post
String initialblogpost = "";
initialblogpost = checkFavoritesRecord.get(0).toString().replaceAll("\\[","").replaceAll("\\]","");
String[] allblogarray =  initialblogpost.split(",");
for(int i=0; i < allblogarray.length; i++)
{
	if(allblogarray[i].equals(blogpostid))
	{
	blogpostexist = true;
	break;
	}
	//System.out.println("The checkFavorite is " +checkFavoritesRecord.get(i).toString().contains(blogpostid));	
}
//System.out.println(blogpostexist);
if(!blogpostexist)
{
if(initialblogpost.equalsIgnoreCase(""))
{
// no existence of id initially	
allblogposttoupdate	= blogpostid;
}
if(!initialblogpost.equalsIgnoreCase(""))
{
// store the id in database and new array in a new string	
allblogposttoupdate = checkFavoritesRecord.get(0).toString().replaceAll("\\[","").replaceAll("\\]","").concat(","+blogpostid);	
}

// update the database
boolean updateTable  = new DbConnection().updateTable("UPDATE favorites SET blogpost_ids='"+allblogposttoupdate+"', updated_date='"+currentdatetime+"' where userid ='"+username+"'");
if(updateTable)
{
// messsage notification of added to favorites	
message = "addedtofavorites";	
}
}

//System.out.println(allblogposttoupdate);
}

return message;
}

// check if post exist
public String checkIfFavoritePost(String username)
{
ArrayList checkFavoritesPost  = new ArrayList ();
String allblogstring = "";
try 
{
	
checkFavoritesPost = new DbConnection().query("select blogpost_ids from favorites where userid ='"+username+"'");
allblogstring = checkFavoritesPost.get(0).toString().replaceAll("\\[","").replaceAll("\\]","");
	//System.out.println(allblogstring);	
}
// error message if record does not exist
catch(Exception ex)
{
	ex.getMessage();
	allblogstring = "";	
}

//String[] allblogarray =  allblogstring.split(",");
return allblogstring;	
}

public String removePostFromFavorites(String username, String blogpostid)
{
String message = "";	
LocalDateTime currentdatetime  = LocalDateTime.now();
ArrayList checkFavoritesRecord  = new ArrayList();	
checkFavoritesRecord = new DbConnection().query("select blogpost_ids from favorites where userid ='"+username+"'");
String allblogstring = checkFavoritesRecord.get(0).toString().replaceAll("\\[","").replaceAll("\\]","");
String[] allblogarray =  allblogstring.split(",");
// remove the element from the array
for(int i = 0; i < allblogarray.length; i++){
    if(allblogarray[i].equalsIgnoreCase(blogpostid)){
      // Using ArrayUtils
    allblogarray = ArrayUtils.remove(allblogarray, i);
      break;
    }
}
// join the new array with comma separated value
String allnewblogstring = String.join(",",allblogarray);
// add updated value to database
boolean updateTable  = new DbConnection().updateTable("UPDATE favorites SET blogpost_ids='"+allnewblogstring+"', updated_date='"+currentdatetime+"' where userid ='"+username+"'");
if(updateTable)
{
// messsage notification of added to favorites	
message = "removed";	
}
//System.out.println(allnewblogstring);
//System.out.println(allblogarray.length);
return message;	
}


public String selectAllFavoritePost(String username)
{
ArrayList checkFavoritesRecord  = new ArrayList();	
LocalDateTime currentdatetime  = LocalDateTime.now();
String allblogstring = "";
checkFavoritesRecord = new DbConnection().query("select * from favorites where userid ='"+username+"'");
//System.out.println(checkFavoritesRecord.get(0));
if(checkFavoritesRecord.size() == 0)
{
// insert a record if it does not exist	
boolean inserted = new DbConnection().insertRecord("insert into favorites (userid,blogpost_ids,created_date,updated_date) VALUES ('"+username+"','','"+currentdatetime+"','"+currentdatetime+"')");
//System.out.println(inserted);	
}
else
{
ArrayList checkFavoritesRecord2 = new DbConnection().query("select blogpost_ids from favorites where userid ='"+username+"'");
//System.out.println(checkFavoritesRecord2.get(0));
allblogstring = checkFavoritesRecord2.get(0).toString().replaceAll("\\[","").replaceAll("\\]","");
}
return allblogstring;
}


public String selectBlogTitle(String blogpostid)
{
String blogtitle = "";	
ArrayList checkFavoritesRecord2 = new DbConnection().query("select blogsite_name from blogsites where blogsite_id ='"+blogpostid+"'");
blogtitle  = checkFavoritesRecord2.get(0).toString().replaceAll("\\[","").replaceAll("\\]","");
return blogtitle;
}

}