$(document).ready(function(){
	var selected_blogs = Cookies.get('selectedblogs').split(",");

    //console.log(selected_blogs);
	//console.log(selected_blogs.length);
	/*for( blog_id in  selected_blogs)
		{
		console.log(blog_id);
		$(".curve_"+blog_id).addClass("border-selected");
		$(".curve_"+blog_id).find(".posttitle a").addClass("text-selected");
		$(".curve_"+blog_id).find(".trackingtracks").addClass("makeinvisible");
		$(".blog_id_"+blog_id).attr("data-original-title","Remove Blog from Tracker");
		// add a class that make similar blog selected
		$(".blog_id_"+blog_id).addClass("text-selected");

		$(this).parent().parent().addClass("border-selected");
		$(this).parent().parent().find(".posttitle a").addClass("text-selected");
		$(this).parent().parent().find(".trackingtracks").addClass("makeinvisible");
		$(this).attr("data-original-title","Remove Blog from Tracker");	
		}*/
	
	for (i=0; i<selected_blogs.length;i++)
		{
		$(".curve_"+selected_blogs[i]+" td").addClass("border-selected");
		$(".curve_"+selected_blogs[i]+" td .myposttitle a").addClass("text-selected");
		
		$(".curve_"+selected_blogs[i]).addClass("border-selected");
		$(".curve_"+selected_blogs[i]).find(".posttitle a").addClass("text-selected");
		$(".curve_"+selected_blogs[i]).find(".trackingtracks").addClass("makeinvisible");
		$(".blog_id_"+selected_blogs[i]).attr("data-original-title","Remove Blog from Tracker");
		// add a class that make similar blog selected
		$(".blog_id_"+selected_blogs[i]).addClass("text-selected");
		}
	
	loggedin = Cookies.get('loggedinstatus');
	//console.log(loggedin);
	if(loggedin === "false")
	{
	cookieblogs = Cookies.get('allfavoritesblogs');
	if(cookieblogs !== "")
	{
	blogpostids	= cookieblogs.split(",");
	for(eachblog in blogpostids)
	{
	element = $("#blogpostt_"+blogpostids[eachblog]);
	element.removeClass("far");
	element.addClass("fas");
	//console.log(blogpostids[eachblog]);	
	}
	}
	}
});