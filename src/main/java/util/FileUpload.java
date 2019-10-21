package util;

import authentication.*;
import java.util.*;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FilenameUtils;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 * Servlet implementation class FileUpload
 */
@WebServlet("/FileUploads")

public class FileUpload extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		ServletFileUpload upload = new ServletFileUpload(new DiskFileItemFactory());
		PrintWriter out = response.getWriter();

		JSONObject json_type = new JSONObject();
System.out.println("seun");
		JSONObject json = new JSONObject();
		JSONObject json_exists = new JSONObject();
		JSONObject json_error = new JSONObject();

		JSONArray array_url = new JSONArray();
		JSONArray array_url_exists = new JSONArray();

		JSONArray array_status = new JSONArray();
		JSONArray array_status_exists = new JSONArray();

		JSONArray array_url_error = new JSONArray();
		JSONArray array_status_error = new JSONArray();

		HttpSession session = request.getSession();
		String fileStatus = "";
		String typ = "";

		AutomatedCrawlerConnect automatedCrawler = new AutomatedCrawlerConnect();
		DbConnection Db = new DbConnection();
		Weblog new_blog = new Weblog();
		ArrayList results_blogfinder = null;
		String userid = (null == session.getAttribute("username")) ? "" : session.getAttribute("username").toString();

		/* .query("SELECT * FROM usercredentials where Email = '" + email + "'"); */
		if (userid == null) {
			response.sendRedirect("login.jsp");
		} else {

			try {
				List<FileItem> files_ = upload.parseRequest(request);
				System.out.println("ttt1--" + files_);

				String fi = files_.get(0).getFieldName().replace(" ", "");
				System.out.println("fi--" + fi.toString());
				if (fi.toString().equals("blog_file")) {
					System.out.println("true it is");

					for (FileItem item : files_) {
						String name = item.getName();
//					System.out.println(name);
//					out.println(name);

						String root = getServletContext().getRealPath("/");
						File path = new File(root + "/fileuploads");
						if (!path.exists()) {
							boolean status = path.mkdirs();
						}

						String timeStamp = new SimpleDateFormat("yyyy.MM.dd.HH.mm.ss").format(new Date()).replace(".",
								"_");

						String ext = FilenameUtils.getExtension(name);
						String name_new = name.replace("." + ext, "");
						String name_new_ = name_new + "_" + timeStamp + "." + ext;
						System.out.println("PREVIOUS" + name_new);
						System.out.println("NEW" + name_new_);
						System.out.println(path);
						//
						File uploadedFile = new File(path + "/" + name_new_);
						item.write(uploadedFile);
						BufferedReader br = new BufferedReader(new FileReader(uploadedFile));

						String st;
						while ((st = br.readLine()) != null) {

//						array_url.put(st);
//						array_status.put("not_crawled");

//						st ="https://tacticalinvestor.com/blog/"; 
							results_blogfinder = new_blog._fetchPipeline(st);
							System.out.println("----" + results_blogfinder);

							System.out.println(results_blogfinder.size());
//						System.out.println(st);
							try {
								if (results_blogfinder.size() > 0) {
									results_blogfinder = (ArrayList<?>) results_blogfinder.get(0);
									System.out.println(st);
									String blog_url = (null == results_blogfinder.get(1)) ? ""
											: (results_blogfinder.get(1).toString());
									String status = (null == results_blogfinder.get(4)) ? ""
											: (results_blogfinder.get(4).toString());
									String priority = (null == results_blogfinder.get(3)) ? ""
											: (results_blogfinder.get(3).toString());
									String lastUpdate = (null == results_blogfinder.get(14)) ? ""
											: (results_blogfinder.get(14).toString());

									fileStatus = new_blog._addBlog(userid, st, status);

									if (fileStatus.indexOf("already exists") != -1) {
										array_url_exists.put(st);
										array_status_exists.put("already exists");
//								typ = "exists";
									} else if (fileStatus == "success") {
										array_url.put(st);
										array_status.put(status);
									} else if (fileStatus == "error") {
										array_url_error.put(st);
										array_status_error.put("error");
									}
//								else if (fileStatus.indexOf("success") != -1){
//								array_url.put(st);
//								array_status.put("not_crawled");
//								typ = "success";
//							}

								} else {
									System.out.println("2--" + st);

									String status = "not_crawled";

									fileStatus = new_blog._addBlog(userid, st, status);
									System.out.println("fileStatus---" + fileStatus);
									if (fileStatus == "success") {
										array_url.put(st);
										array_status.put(status);
									} else if (fileStatus == "error") {
										array_url_error.put(st);
										array_status_error.put("error");
									} else if (fileStatus.indexOf("already exists") != -1) {
										array_url_exists.put(st);
										array_status_exists.put("already exists");
									}

//							if (fileStatus.indexOf("already exists") != -1) {
//								array_url_exists.put(st);
//								array_status_exists.put("already exists");
//								typ = "exists";
//							} else if (fileStatus.indexOf("success") != -1){
//								array_url.put(st);
//								array_status.put(status);
//								typ = "success";
//							}

								}
							} catch (Exception e) {
								System.out.println(e);
							}

							System.out.println("---" + results_blogfinder.size());

						}
						br.close();
//					for (int k = 0; k < array.length(); k++) {
//						System.out.println("THIS"+array.get(k));
//					} 

					}

//				if (condition) {
//					
//				} else {
//
//				}
					System.out.println("urlfound----" + array_url.length());
					System.out.println("statusfound----" + array_status.length());
					System.out.println("urleefound----" + array_url_exists.length());
					System.out.println("statuseefound----" + array_status_exists.length());
					System.out.println("urlnnfound----" + array_url_error.length());
					System.out.println("statusnnfound----" + array_status_error.length());

					if (array_url.length() > 0) {
						json.put("url", array_url);
						json.put("status", array_status);
						json_type.put("success", json);
					}
					if (array_url_exists.length() > 0) {
						json_exists.put("url", array_url_exists);
						json_exists.put("status", array_status_exists);
						json_type.put("exists", json_exists);
					}
					if (array_url_error.length() > 0) {
						json_error.put("url", array_url_error);
						json_error.put("status", array_status_error);
						json_type.put("error", array_url_error);
					}

//				JSONObject json_type = new JSONObject();
//				
//				JSONObject json = new JSONObject();
//				JSONObject json_exists = new JSONObject();
//				JSONObject json_error = new JSONObject();
//				
//				JSONArray array_url = new JSONArray();
//				JSONArray array_url_exists = new JSONArray();
//				
//				JSONArray array_status = new JSONArray();
//				JSONArray array_status_exists = new JSONArray();
//				
//				JSONArray array_error = new JSONArray();
//				JSONArray array_status_error= new JSONArray();

//				request.setAttribute("seun", array);
//				request.getRequestDispatcher("addblog.jsp").forward(request, response);
//				System.out.println("THIS"+array.get(k));
//				if (condition) {
//					
//				} else {
//
//				}
					out.println(json_type);

					System.out.println(json_type);
//				System.out.println("end of file");

					ArrayList<?> userinfo_ = new ArrayList();
					Object email = (null == session.getAttribute("email")) ? "" : session.getAttribute("email");
					userinfo_ = Db.query("SELECT * FROM usercredentials where Email = '" + email + "'");
//				out.println(userinfo_);
					System.out.println(userinfo_);

				} else if (fi.toString().equals("userfile")) {
					for (FileItem item : files_) {
						String name = item.getName();
						String root = getServletContext().getRealPath("/");
						File path = new File(root + "/images/profile_images");
						if (!path.exists()) {
							boolean status = path.mkdirs();
						}

						String email = session.getAttribute("email").toString();
						String file_name = email + ".jpg";
						File file__ = new File(path + "/" + email + ".jpg");
						item.write(file__);
//	                File uploadedFile = new File(path + "/" + name);
//	                item.write(uploadedFile);
						System.out.println(email);
					}
					System.out.println("true it is");
					out.println("true it is");
				}

			} catch (Exception e) {
				// TODO: handle exception
			}
		}
	}

}
