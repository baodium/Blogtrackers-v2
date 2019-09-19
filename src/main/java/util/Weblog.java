package util;

import java.util.ArrayList;
import java.net.URI;
import java.net.URISyntaxException;

import authentication.*;

public class Weblog {
	public String _addBlog(String username, String blog, String status) {

		String dup1 = "";
		String dup2 = "";
		String dup3 = "";
		String dup4 = "";

		DbConnection Db = new DbConnection();
		ArrayList<?> bloggers = new ArrayList();

		String maindomain = "";
		try {
			URI uri = new URI(blog);
			String domain = uri.getHost();
			if (domain.startsWith("www.")) {
				maindomain = domain.substring(4);
			} else {
				maindomain = domain;
			}
		} catch (Exception ex) {
		}

		if (maindomain.length() > 0) {
			dup1 = "http://" + maindomain;
			dup2 = "https://" + maindomain;
			dup3 = "http://www." + maindomain;
			dup4 = "https://www." + maindomain;
		}

		System.out.println("main" + maindomain);
		System.out.println("dup1" + dup1.length());
		System.out.println("dup2" + dup2);
		System.out.println("dup3" + dup3);

		if (dup1.length() == 0 || dup2.length() == 0 || dup3.length() == 0 || dup4.length() == 0) {
			bloggers = Db.query("SELECT * FROM user_blog WHERE userid='" + username + "' AND (url like'" + dup1
					+ "' OR url like'" + dup2 + "' OR url like'" + dup3 + "' OR url like'" + dup4 + "' )");
		}else {
			bloggers = Db.query("SELECT * FROM user_blog WHERE userid='" + username + "' AND (url like'" + dup1
					+ "%' OR url like'" + dup2 + "%' OR url like'" + dup3 + "%' OR url like'" + dup4 + "%' )");
		}

		System.out.println("blogger--" + bloggers);
		System.out.println("blog--" + blog);
		if (bloggers.size() > 0) {
			return blog + "already exists";
		} else {
			if (!(blog == null || blog == "") && maindomain.length() != 0) {


				System.out.println(
						"username is " + username + "blog of the owner is " + blog + "Crawling status is " + status);
				String que = "INSERT INTO user_blog(userid, url,status) VALUES('" + username + "', '" + blog + "', '"
						+ status + "')";
//
				boolean done = new DbConnection().updateTable(que);
				System.out.println(done);
				if (done) {
					return "success";
				}
			}
			
		}
		// return "Error while adding blog";
		return "error";
	}

	public ArrayList _fetchBlog(String username) {
		// System.out.println(username);
		ArrayList bloggers = new DbConnection().query("SELECT * FROM user_blog WHERE userid='" + username + "'");
		System.out.println(bloggers.size());

		return bloggers;
	}

	public ArrayList _fetchPipeline(String blogsite_name) {
		// System.out.println(username);
		ArrayList bloggers_pipeline = new AutomatedCrawlerConnect()
				.query("SELECT * FROM crawler_pipeline WHERE blogsite_name='" + blogsite_name + "'");
		System.out.println(bloggers_pipeline.size());
		return bloggers_pipeline;
	}
	
	public ArrayList _fetchCrawlerBlogs(String blogsite_name) {
		// System.out.println(username);
		ArrayList bloggers_blogs = new AutomatedCrawlerConnect()
				.query("SELECT * FROM blogsites WHERE blogsite_url='" + blogsite_name + "'");
		System.out.println(bloggers_blogs.size());
		return bloggers_blogs;
	}

	public boolean _deleteBlog(String username, String id) {
		boolean deleted = new DbConnection()
				.updateTable("delete FROM user_blog WHERE userid='" + username + "' AND id = '" + id + "'");
		System.out.println("deleting"+username+" and "+id);
		if (deleted) {
			System.out.println("deletedd"+username+" and "+id);
			return true;
		}

		return false;
	}
}
