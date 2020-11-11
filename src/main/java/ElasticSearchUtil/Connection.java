package ElasticSearchUtil;

import java.util.HashMap;

import org.apache.http.HttpHost;
import org.apache.http.util.EntityUtils;
import org.elasticsearch.client.Request;
import org.elasticsearch.client.Response;
import org.elasticsearch.client.RestClient;
import org.json.JSONObject;

import com.google.gson.Gson;

import authentication.DbConnection;
import util.Narrative.Source;

public class Connection {
	public static HashMap<String, String> hm = DbConnection.loadConstant();
	String base_url = hm.get("elasticIndex") + "blogposts/";
	public static String elasticUrl = hm.get("elasticUrl");

	public static Hits _getHits(JSONObject query, String requestType, String endPoint) throws Exception {

		Hits s = new Hits();
		try {

			RestClient esClient = RestClient.builder(new HttpHost(elasticUrl, 9200, "http")).build();

			Request request = new Request(requestType, endPoint);
			request.setJsonEntity(query.toString());

			Response response = esClient.performRequest(request);
			String jsonResponse = EntityUtils.toString(response.getEntity());
			
			Object hits = new JSONObject(jsonResponse).getJSONObject("hits");
			
			Gson gson = new Gson();
			s = gson.fromJson(hits.toString(), Hits.class);
			esClient.close();

		} catch (Exception e) {
			// System.out.println("Error for elastic request -- > "+e);
		}
		return s;

	}
	
	public static void main(String [] args) {
		try {
			_getHits(new JSONObject(), "POST", "/blogposts/_search?");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
