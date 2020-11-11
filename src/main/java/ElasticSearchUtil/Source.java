package ElasticSearchUtil;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class Source {

	@SerializedName("comments_url")
	@Expose
	private Object commentsUrl;
	@SerializedName("blogsite_id")
	@Expose
	private Integer blogsiteId;
	@SerializedName("sentiment")
	@Expose
	private Double sentiment;
	@SerializedName("influence_score")
	@Expose
	private Double influenceScore;
	@SerializedName("last_modified_time")
	@Expose
	private String lastModifiedTime;
	@SerializedName("num_comments")
	@Expose
	private Integer numComments;
	@SerializedName("blogger")
	@Expose
	private String blogger;
	@SerializedName("categories")
	@Expose
	private String categories;
	@SerializedName("post")
	@Expose
	private String post;
	@SerializedName("post_length")
	@Expose
	private Integer postLength;
	@SerializedName("permalink")
	@Expose
	private String permalink;
	@SerializedName("tags")
	@Expose
	private String tags;
	@SerializedName("@version")
	@Expose
	private String version;
	@SerializedName("language")
	@Expose
	private String language;
	@SerializedName("date")
	@Expose
	private String date;
	@SerializedName("title")
	@Expose
	private String title;
	@SerializedName("num_inlinks")
	@Expose
	private Integer numInlinks;
	@SerializedName("location")
	@Expose
	private String location;
	@SerializedName("blogpost_id")
	@Expose
	private Integer blogpostId;
	@SerializedName("num_outlinks")
	@Expose
	private Integer numOutlinks;
	@SerializedName("@timestamp")
	@Expose
	private String timestamp;

	public Object getCommentsUrl() {
		return commentsUrl;
	}

	public void setCommentsUrl(Object commentsUrl) {
		this.commentsUrl = commentsUrl;
	}

	public Integer getBlogsiteId() {
		return blogsiteId;
	}

	public void setBlogsiteId(Integer blogsiteId) {
		this.blogsiteId = blogsiteId;
	}

	public Double getSentiment() {
		return sentiment;
	}

	public void setSentiment(Double sentiment) {
		this.sentiment = sentiment;
	}

	public Double getInfluenceScore() {
		return influenceScore;
	}

	public void setInfluenceScore(Double influenceScore) {
		this.influenceScore = influenceScore;
	}

	public String getLastModifiedTime() {
		return lastModifiedTime;
	}

	public void setLastModifiedTime(String lastModifiedTime) {
		this.lastModifiedTime = lastModifiedTime;
	}

	public Integer getNumComments() {
		return numComments;
	}

	public void setNumComments(Integer numComments) {
		this.numComments = numComments;
	}

	public String getBlogger() {
		return blogger;
	}

	public void setBlogger(String blogger) {
		this.blogger = blogger;
	}

	public String getCategories() {
		return categories;
	}

	public void setCategories(String categories) {
		this.categories = categories;
	}

	public String getPost() {
		return post;
	}

	public void setPost(String post) {
		this.post = post;
	}

	public Integer getPostLength() {
		return postLength;
	}

	public void setPostLength(Integer postLength) {
		this.postLength = postLength;
	}

	public String getPermalink() {
		return permalink;
	}

	public void setPermalink(String permalink) {
		this.permalink = permalink;
	}

	public String getTags() {
		return tags;
	}

	public void setTags(String tags) {
		this.tags = tags;
	}

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

	public String getLanguage() {
		return language;
	}

	public void setLanguage(String language) {
		this.language = language;
	}

	public String getDate() {
		return date;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public Integer getNumInlinks() {
		return numInlinks;
	}

	public void setNumInlinks(Integer numInlinks) {
		this.numInlinks = numInlinks;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public Integer getBlogpostId() {
		return blogpostId;
	}

	public void setBlogpostId(Integer blogpostId) {
		this.blogpostId = blogpostId;
	}

	public Integer getNumOutlinks() {
		return numOutlinks;
	}

	public void setNumOutlinks(Integer numOutlinks) {
		this.numOutlinks = numOutlinks;
	}

	public String getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(String timestamp) {
		this.timestamp = timestamp;
	}

}
