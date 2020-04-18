package util;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.*;
import java.time.format.DateTimeFormatter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;

import javafx.util.Pair;

import java.util.*;

/**
 * Servlet implementation class TopicDistribution
 */
@WebServlet("/TD")
public class TopicDistribution extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		HttpSession session = request.getSession();
		Object email = (null == session.getAttribute("email")) ? "" : session.getAttribute("email");
		Object tid = (null == request.getParameter("tid")) ? "" : request.getParameter("tid");
		Object user = (null == session.getAttribute("username")) ? "" : session.getAttribute("username");
		Object date_start = (null == request.getParameter("date_start")) ? "" : request.getParameter("date_start");
		Object date_end = (null == request.getParameter("date_end")) ? "" : request.getParameter("date_end");
		Object single = (null == request.getParameter("single_date")) ? "" : request.getParameter("single_date");
		String sort = (null == request.getParameter("sortby")) ? "blog"
				: request.getParameter("sortby").toString().replaceAll("[^a-zA-Z]", " ");
		
		Object blogIds = (null == request.getParameter("blogIds")) ? "" : request.getParameter("blogIds");
		Object action = (null == request.getParameter("action")) ? "" : request.getParameter("action");
		PrintWriter out = response.getWriter();
		
		
		//System.out.println("action --" + action.toString());
		Blogposts blogpostsContainer = new Blogposts();
		//System.out.println("action1 --" + action.toString());
		
		if (action.toString().equals("loadChord")) {
			//System.out.println("idss --"+blogIds.toString());
			String stdate = null;
			
			try {
				stdate = blogpostsContainer._getDate(blogIds.toString(), "first");
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			LocalDate localDate = LocalDate.now();
			String today = DateTimeFormatter.ofPattern("yyy-MM-dd").format(localDate);

			ArrayList<String> JSONposts = null;
			try {
				JSONposts = blogpostsContainer._getPosts(blogIds.toString(), stdate, today);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			// System.out.println("SIZE --" + JSONposts.size());

			// ArrayList<String> JSONposts = blogpostsContainer._getPostByBlogId(blogIds,
			// DUMMYSTR);
			ArrayList<TopicModelling.BlogPost> blogpostsArray = new ArrayList<TopicModelling.BlogPost>();

			JSONObject rawJSONpost = null;
			JSONObject post = null;

			JSONObject post_date = null;
			// = null;

			for (int i = 0; i < JSONposts.size(); ++i) {
				rawJSONpost = new JSONObject(JSONposts.get(i).toString());
				post = new JSONObject(rawJSONpost.get("_source").toString());

				Object post_date_ = rawJSONpost.getJSONObject("fields").getJSONArray("date").get(0).toString();
				// System.out.println(post_date_.toString());

				// JSONObject post_date = null;

				blogpostsArray.add(new TopicModelling.BlogPost(post.get("blogpost_id").toString(),
						// blogpostsContainer.escape(post.get("title").toString()),
						blogpostsContainer.escape2(post.get("title").toString()), post.get("post").toString(),
						post_date_.toString(),
						// post.get("date").toString().split("T")[0],
						post.get("blogger").toString(), post.get("location").toString(),
						post.get("num_comments").toString()));
			}

			final double TOPIC_THRESHOLD = 0.1;
			final int TOPIC_NUMBER = 10;
			final int TOPICMODEL_MAXWORDS = 30;
			final int WORDCLOUD_MAXWORDS = 20;
			final int DATATABLE_MAXWORDS = 10;

			TopicModelling model = new TopicModelling(blogpostsArray, TOPIC_NUMBER);
			Map<Integer, ArrayList<Pair<String, Double>>> topics = model.getTopics(TOPICMODEL_MAXWORDS);
			// Blogposts used in the local JS
			ArrayList<TopicModelling.Documents.Document> blogposts = model.getDocuments();
			final String DEFAULT_AUTHOR = "Not Provided";
			int bloggerMention[] = new int[topics.size()];
			int postMention[] = new int[topics.size()];
			String topBloggers[] = new String[topics.size()];

			double[][] blogDistributionMatrix = new double[topics.size()][topics.size()];

			for (int i = 0; i < topics.size(); i++) {
				HashMap<String, Integer> bloggers = new HashMap<String, Integer>();
				HashMap<String, Integer> locationFrequency = new HashMap<String, Integer>();
				String bloggerHighestTopicProb = DEFAULT_AUTHOR;
				double highestTopicProb = 0;
				int blogPostsInThreshold = 0;

				for (TopicModelling.Documents.Document doc : blogposts) {
					if (doc.theta[i] > TOPIC_THRESHOLD) {
						blogPostsInThreshold++;
						// Track author whose post has highest topic probability
						if (doc.theta[i] > highestTopicProb) {
							highestTopicProb = doc.theta[i];
							bloggerHighestTopicProb = doc.blog_author;
						}
						// Track Number of Occurence for each Blogger
						if (bloggers.containsKey(doc.blog_author)) {
							bloggers.replace(doc.blog_author, bloggers.get(doc.blog_author) + 1);
						} else {
							bloggers.put(doc.blog_author, 1);
						}
						// Track Location Frequency
						if (locationFrequency.containsKey(doc.blog_location)) {
							locationFrequency.put(doc.blog_location, locationFrequency.get(doc.blog_location) + 1);
						} else {
							locationFrequency.put(doc.blog_location, 1);
						}
						// Track Topic Overlap
						for (int j = 0; j < topics.size(); j++) {
							if (doc.theta[j] > TOPIC_THRESHOLD) {
								blogDistributionMatrix[i][j]++;
							}
						}
					}
				}
				bloggerMention[i] = bloggers.size();
				postMention[i] = blogPostsInThreshold;
				topBloggers[i] = bloggerHighestTopicProb;

			}

			ArrayList<ArrayList<Double>> _chordDiagramMatrix = new ArrayList<ArrayList<Double>>();
			
			// double [][] _chordDiagramMatrix = new double[10][10];

			for (int i : topics.keySet()) {
				ArrayList<Double> a = new ArrayList<Double>(1);
				_chordDiagramMatrix.add(a);
				for (int j : topics.keySet()) {
					//ArrayList<Double> arr = new ArrayList<Double>(10);
					a = _chordDiagramMatrix.get(_chordDiagramMatrix.size() - 1);
					a.add(blogDistributionMatrix[i][j]);
				}
				
			}
			//System.out.println("chord--"+_chordDiagramMatrix);
			session.setAttribute(tid.toString() + "_chorddatadashboard", _chordDiagramMatrix.toString());
			Object chordData = (null == session.getAttribute(tid.toString()+ "_chorddatadashboard"))
					? ""
					: session.getAttribute(tid.toString()+ "_chorddatadashboard");
//System.out.println("testing chord" + chordData);
			out.write(_chordDiagramMatrix.toString());
		}else {
			System.out.println("action2");
		}
		
	}
}

