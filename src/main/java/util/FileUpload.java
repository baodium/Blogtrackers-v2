package util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ServletFileUpload upload = new ServletFileUpload(new DiskFileItemFactory());
		PrintWriter out = response.getWriter();
		JSONObject json = new JSONObject();
		JSONArray array = new JSONArray();
		try {
			List<FileItem> files_ = upload.parseRequest(request);
			for (FileItem item : files_) {
				String name = item.getName();
//				System.out.println(name);
//				out.println(name);
				
				String root = getServletContext().getRealPath("/");
                File path = new File(root + "/fileuploads");
                if (!path.exists()) {
                    boolean status = path.mkdirs();
                }
                
                String timeStamp = new SimpleDateFormat("yyyy.MM.dd.HH.mm.ss").format(new Date()).replace(".", "_");
                
                String ext = FilenameUtils.getExtension(name);
                String name_new = name.replace("." + ext, "");
                String name_new_ = name_new + "_" + timeStamp + "." + ext;
                System.out.println("PREVIOUS"+name_new);
                System.out.println("NEW"+name_new_);
                System.out.println(path);
//
                File uploadedFile = new File(path + "/" + name_new_);
                item.write(uploadedFile);
                BufferedReader br = new BufferedReader(new FileReader(uploadedFile)); 
                
                String st; 
                while ((st = br.readLine()) != null) {
//                  System.out.println(st); 
                  array.put(st);
                  
                }
                br.close();
//				for (int k = 0; k < array.length(); k++) {
//					System.out.println("THIS"+array.get(k));
//				} 
								
				
				
			}
//			request.setAttribute("seun", array);
//			request.getRequestDispatcher("addblog.jsp").forward(request, response);
//			System.out.println("THIS"+array.get(k));
			out.println(array);
//			System.out.println(array);
			System.out.println(array);
			System.out.println("end of file");
			
			
		} catch (Exception e) {
			// TODO: handle exception
		}
	}

}
