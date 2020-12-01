package util;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.Duration;
import java.time.Instant;
import java.util.Arrays;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import authentication.DbConnection;

public class Dashboard {
	String kwt_status_percentage;
	String cluster_status_percentage;
	String kwt_status;
	String cluster_status;
	JSONObject final_centroids = new JSONObject();
	JSONObject final_result = new JSONObject();
	String tid;
	String start_date;
	String end_date;
	String blog_ids;

	Clustering c = new Clustering();

	ResultSet clusters_and_terms = null;
	ResultSet outlinks = null;

	public Dashboard(String tid) throws SQLException {
		this.tid = tid;
		String q = "select c.*, tk.status tk_status, tk.status_percentage tk_status_percentage \n" + "from clusters c\n"
				+ "join tracker_keyword tk\n" + "on c.tid = tk.tid\n" + "where c.tid = " + this.tid + " or tk.tid = "
				+ this.tid + ";";

		this.clusters_and_terms = DbConnection.queryResultSet(q);
//		while (this.clusters_and_terms.next()) {
//			this.kwt_status = clusters_and_terms.getString("tk_status");
//			this.kwt_status_percentage = clusters_and_terms.getString("tk_status_percentage");
//
//			this.final_result.put("status_percentage", this.kwt_status_percentage);
//			this.final_result.put("status", this.kwt_status);
//
//			this.cluster_status = clusters_and_terms.getString("status");
//			this.cluster_status_percentage = clusters_and_terms.getString("status_percentage");
//		}
	}

	public Dashboard(String blog_ids, String start_date, String end_date) {
		this.blog_ids = blog_ids;
		this.start_date = start_date;
		this.end_date = end_date;
	}

	public String get_kwt_status_percentage() {
		return this.kwt_status_percentage;
	}

	public String get_cluster_status_percentage() {
		return this.cluster_status_percentage;
	}

	public String get_cluster_status() {
		return this.cluster_status;
	}

	public JSONObject get_final_centroids() {
		return this.final_centroids;
	}

	public JSONObject get_final_result() {
		return this.final_result;
	}

	public String get_kwt_status() {
		return this.kwt_status;
	}

	public ResultSet get_cluster_result() {
		return this.clusters_and_terms;
	}

	public ResultSet get_outlinks_result() {
		return this.outlinks;
	}

	/**
	 * Loading status and data for clusters and terms
	 * 
	 * @throws SQLException throws SQL Exception
	 */
	public void load_cluster_and_terms_dashboard() throws SQLException {
		while (this.clusters_and_terms.next()) {
			this.kwt_status = clusters_and_terms.getString("tk_status");
			this.kwt_status_percentage = clusters_and_terms.getString("tk_status_percentage");

			this.final_result.put("status_percentage", this.kwt_status_percentage);
			this.final_result.put("status", this.kwt_status);

			this.cluster_status = clusters_and_terms.getString("status");
			this.cluster_status_percentage = clusters_and_terms.getString("status_percentage");

			JSONObject cluster_final_result = new JSONObject();
			cluster_final_result.put("status_percentage", this.cluster_status_percentage);
			cluster_final_result.put("status", this.cluster_status);

			if (this.cluster_status.equals("1")) {
				// start clustering data gathering
				// get postids from each cluster in tracker and save in JSONObject
				JSONArray nodes_centroids = new JSONArray();
				JSONArray links_centroids = new JSONArray();

				int[][] termsMatrix = new int[10][10];

				for (int i = 1; i < 11; i++) {

					String cluster_ = "cluster_" + String.valueOf(i);
					String centroids = "C" + String.valueOf(i) + "xy";

					JSONObject cluster_data = new JSONObject(clusters_and_terms.getString(cluster_));

					String post_ids = cluster_data.get("post_ids").toString();

					String centroid = clusters_and_terms.getString(centroids).replace("[", "").replace("]", "");
					String centroid_x = centroid.split(",")[0].trim();
					String centroid_y = centroid.split(",")[1].trim();

					JSONObject data_centroids_ = new JSONObject();

					data_centroids_.put("id", "Cluster_" + i);
					data_centroids_.put("group", i);
					data_centroids_.put("label", "CLUSTER_" + i);
					data_centroids_.put("level", post_ids.split(",").length);

					nodes_centroids.put(data_centroids_);
					for (int k = 1; k < 11; k++) {
						if (k != i) {
							String centroids_ = "C" + String.valueOf(k) + "xy";
							String centroid_ = clusters_and_terms.getString(centroids_).replace("[", "").replace("]",
									"");
							String centroid_x_ = centroid_.split(",")[0].trim();
							String centroid_y_ = centroid_.split(",")[1].trim();

							JSONObject data_centroids = new JSONObject();
							data_centroids.put("target", "Cluster_" + i);
							data_centroids.put("source", "Cluster_" + k);

							double left_ = Math.pow(
									(double) Double.parseDouble(centroid_x_) - (double) Double.parseDouble(centroid_x),
									2);
							double right_ = Math.pow(
									(double) Double.parseDouble(centroid_y_) - (double) Double.parseDouble(centroid_y),
									2);
							String distance_ = String.valueOf(Math.pow((left_ + right_), 0.5));

							data_centroids.put("strength", 50 - Double.parseDouble(distance_));
							links_centroids.put(data_centroids);
						}
					}

					String terms = cluster_data.get("topterms").toString();
					String str1 = null;
					str1 = terms.replace("),", "-").replace("(", "").replace(")", "").replaceAll("[0-9]", "")
							.replace("-", "");
					List<String> t1 = Arrays.asList(str1.replace("[", "").replace("]", "").split(","));
					termsMatrix[i - 1][i - 1] = t1.size();

					// CREATING CHORD MATRIX
					String str2 = null;
					for (int k = (i + 1); k < 11; k++) {
						String cluster_matrix = "cluster_" + String.valueOf(k);
						JSONObject cluster_data_matrix = new JSONObject(clusters_and_terms.getString(cluster_matrix));
						String terms_matrix = cluster_data_matrix.get("topterms").toString();

						str2 = terms_matrix.replace("),", "-").replace("(", "").replace(")", "").replaceAll("[0-9]", "")
								.replace("-", "");

						List<String> t2 = Arrays.asList(str2.replace("[", "").replace("]", "").split(","));

						int count = 0;
						for (int i_ = 0; i_ < t1.size(); i_++) {
							for (int j_ = 0; j_ < t2.size(); j_++) {
								if (t1.get(i_).contentEquals(t2.get(j_))) {
									count++;
								}
							}
						}
						termsMatrix[i - 1][k - 1] = count;
						termsMatrix[k - 1][i - 1] = count;
					}
				}
				this.final_centroids.put("nodes", nodes_centroids);
				this.final_centroids.put("links", links_centroids);
			} else if (this.cluster_status.equals("0")) {

			}
		}
	}

	public void load_outlinks() {
		this.outlinks = this.load_filter(this.blog_ids, this.start_date, this.end_date, "top_language", "100");
	}

	public ResultSet load_filter(String blog_ids, String date_start, String date_end, String card_name, String limit) {
		String query = "";
		switch (card_name) {

		case "outlinks":
			query = "select domain, count(domain) c\r\n" + "from outlinks\r\n" + "where blogsite_id in (" + blog_ids
					+ ") and domain is not null and domain != '' \r\n" + "and date > \"" + date_start + "\" \r\n"
					+ "and date < \"" + date_end + "\"\r\n" + "group by domain\r\n" + "order by c desc limit " + limit
					+ ";";
			break;

		case "most_active_location":
			query = "select blogsite_id, location, SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(permalink, '/', 3), '://', -1), '/', 1), '?', 1) as domain, count(blogsite_id) c\r\n"
					+ "from blogposts\r\n" + "where blogsite_id in (" + blog_ids + ") \r\n" + "and date > \""
					+ date_start + "\" and location is not null \r\n" + "and date < \"" + date_end + "\"\r\n"
					+ "group by blogsite_id order by c desc limit " + limit + ";";
			break;

		case "top_language":
			query = "select language, count(language) c\r\n" + "from blogposts\r\n" + "where blogsite_id in ("
					+ blog_ids + ") \r\n" + "and date > \"" + date_start + "\" \r\n" + "and date < \"" + date_end
					+ "\"\r\n" + "group by language\r\n" + "order by c desc\r\n" + "limit " + limit + ";";
			break;

		case "sentiment":
			query = "select sum(posemo) p, sum(negemo) n \r\n" + "from liwc \r\n"
					+ "where blogpostid in (select blogpost_id from blogposts where blogsite_id in (" + blog_ids
					+ ")) and\r\n" + "date > \"" + date_start + "\" and \r\n" + "date < \"" + date_end + "\";";
			break;

		case "most_influencial_bloggers":
			query = "select blogger, max(influence_score) m\r\n" + "from blogposts\r\n" + "where blogsite_id in ("
					+ blog_ids + ") \r\n" + "and date > \"" + date_start + "\" \r\n" + "and date < \"" + date_end
					+ "\"\r\n" + "group by blogger order by m desc limit " + limit + ";";
			break;

		case "most_influencial_blogs":
			query = "select blogsite_id, SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(permalink, '/', 3), '://', -1), '/', 1), '?', 1) as domain, max(influence_score) m\r\n"
					+ "from blogposts\r\n" + "where blogsite_id in (" + blog_ids + ") \r\n" + "and date > \""
					+ date_start + "\" \r\n" + "and date < \"" + date_end + "\"\r\n" + "group by blogsite_id limit "
					+ limit + ";";
			break;
		default:
			query = "";
		}
		return DbConnection.queryResultSet(query);
	}

	public static void main(String[] args) {
		try {

			Instant start = Instant.now();
			new StringBuffer();

//			Dashboard d = new Dashboard("428");
			Dashboard d_outlinks = new Dashboard("\"2649\",\"1319\",\"3436\"", "2020-01-01", "2020-11-11");
//			d.load_cluster_and_terms_dashboard();
			d_outlinks.load_outlinks();

			Instant end = Instant.now();
			Duration timeElapsed = Duration.between(start, end);
			System.out.println(timeElapsed.getSeconds() + " second(s)");
			System.out.println(timeElapsed);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
