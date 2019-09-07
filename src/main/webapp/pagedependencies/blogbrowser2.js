var selected_blogs = new Array();
var looper = 0;

$(document).ready(function() {

	// tracking blogcount
	
	// tracker selected count
	var blgs = $(".blogselection");
	var trackscount = blgs.length;
	var trackerselectedcount = 0;
	
	
	
	
//  show tooltip
  $(function () {
    $('[data-toggle="tooltip"]').tooltip()
  })

 //tracker list handler  
$('.blogindividual').on("mouseenter",function(){
$(this).find(".checkblog").removeClass("hidden");
});


$('.blogindividual').on("mouseleave",function(){
  selected = $(this).hasClass("blogindividualactive");
  if(selected)
  {
  // do not hide delete icon
  }
  else if(!selected)
  {
    // hide delete icon
  $(this).find(".checkblog").addClass("hidden").removeClass("blogindividualactive");
  }
});

$('.blogindividual').on("click",function(e){
  selected = $(this).hasClass("blogindividualactive");
  // check selected blog
  if(!selected)
  {
    $(this).find(".blogtracker").removeClass("hidden");
    $(this).addClass("blogindividualactive");
    // remember to pass session id of blog
  }
  // check if a blog is not selected
  else if(selected)
  {
    $(this).find(".blogtracker").addClass("hidden");
    $(this).removeClass("blogindividualactive");
    // remember to pass session id of blog
  }

});

// end of blog individual


//tracker list handler
$('.trackerindividual').on("mouseenter",function(){
$(this).find(".checktracker").removeClass("hidden");
});


$('.trackerindividual').on("mouseleave",function(){
  selected = $(this).hasClass("trackerindividualactive");
  if(selected)
  {
  // do not hide delete icon
  }
  else if(!selected)
  {
    // hide delete icon
  $(this).find(".checktracker").addClass("hidden").removeClass("trackerindividualactive");
  
  }
});

$('.trackerindividual').on("click",function(e){
  selected = $(this).hasClass("trackerindividualactive");
  // check selected blog
  console.log(selected+":seected");
  if(!selected)
  {
    $(this).find(".checktracker").removeClass("hidden");
    $(this).addClass("trackerindividualactive").removeClass("bold-text");
    $(this).addClass("trackerindividualactive");
    console.log("here");
    
    updateTracker(this,"update");
    // remember to pass session id of blog
    trackerselectedcount++;
    console.log("sel:"+trackerselectedcount);
    
    $('.selectedtrackercount').html(trackerselectedcount);
  }
  // check if a blog is not selected
  else if(selected)
  {
    $(this).find(".checktracker").addClass("hidden");
    $(this).removeClass("trackerindividualactive").addClass("bold-text");
    // remember to pass session id of blog
   // updateTracker(this,"remove");
    trackerselectedcount--;
    console.log("not"+trackerselectedcount);
    // increase count of selected tracker
    $('.selectedtrackercount').html(trackerselectedcount);
  }

});

// end of tracker list handler



//tracker list handler
$('.trackerindividual2').on("mouseenter",function(){
$(this).find(".checktracker2").removeClass("hidden");
});


$('.trackerindividual2').on("mouseleave focusout",function(){
  selected = $(this).hasClass("trackerindividual2active");
  if(selected)
  {
  // do not hide delete icon
  }
  else if(!selected)
  {
    // hide delete icon
  $(this).find(".checktracker2").addClass("hidden").removeClass("trackerindividual2active");
  }
});

// focusout effects
$('.trackerindividual2').on("focusout",function(){
  selected = $(this).hasClass("trackerindividual2active");
  if(selected)
  {
  // do not hide delete icon
  }
  else if(!selected)
  {
    // hide delete icon
// $(this).css("background-color","transparent");
// $(this).css("color","white");
  }

});
$('.trackerindividual2').on("click",function(e){
  selected = $(this).hasClass("trackerindividual2active");
  // check selected blog
  if(!selected)
  {
    $(this).find(".checktracker2").removeClass("hidden");
    $(this).addClass("trackerindividual2active");
    // remember to pass session id of blog
  }
  // check if a blog is not selected
  else if(selected)
  {
    $(this).find(".checktracker2").addClass("hidden");
    $(this).removeClass("trackerindividual2active");
    // remember to pass session id of blog
  }

});

// end of tracker list handler





// for the delete on hover for blog buttons
$('.blogselection').on("mouseenter",function(e){
$(this).find(".deleteblog").removeClass("hidden");
});



$('.blogselection').on("mouseleave",function(e){
// check the status of the button whether selecte or //
selected = $(this).hasClass("blogselectionactive");
if(selected)
{
// do not hide delete icon
}
else if(!selected)
{
  // hide delete icon
$(this).find(".deleteblog").addClass("hidden");
}


});

$('.blogselection').on("click",function(e){
  selected = $(this).hasClass("blogselectionactive");
  // check selected blog
  if(!selected)
  {
    $(this).find(".deleteblog").removeClass("hidden");
    $(this).addClass("blogselectionactive");
    // remember to pass session id of blog
  }
  // check if a blog is not selected
  else if(selected)
  {
    $(this).find(".deleteblog").addClass("hidden");
    $(this).removeClass("blogselectionactive");
    // remember to pass session id of blog
  }

});

$('.deleteblog').on("click",function()
{
	
	id = $(this).attr('id');
	
	var index = selected_blogs.indexOf(id);
	if (index > -1) {
		selected_blogs.splice(index, 1);
	}
	$(".total_selected").text(selected_blogs.length);
	$(this).parent().remove();
// perform an action that remove the blog from the list
})
// end

  
$('#closetracks').on("click",function(){
$(this).parent().toggle();	
});
  
// handler for each favorites
$(document).on("click",".favoritestoggle",function(e){
// check if it has been favorites
isFavorites = $(this).hasClass('far');
if(isFavorites) // if it is favorites
{
$(this).removeClass("far fa-heart").addClass("fas fa-heart");
$(this).attr("data-original-title","Remove to Favorite");
console.log("You Added to favorites")
// add an jax to favorites the post

}
else if(!isFavorites) // if it does not have favorites
{
$(this).removeClass("fas fa-heart").addClass("far fa-heart");
$(this).attr("data-original-title","Add to Favorite");
console.log("You removed from favorites")
// add an ajax to unfavorite the post

}

});
// end of handler for favorites


//select a blog to track
$(document).on("click",".trackblog",function(e){
// check the status if the blog is tracked
blog_id = "";
classes = $(this).attr('class').split(/\s+/);
$.each(classes, function(index, item) {
	    if (item.indexOf("blog_id")>-1) {
	        blog_id = item.split("_");
	        blog_id = blog_id[blog_id.length-1];
	    }
	});
var trackingblog = null;
var allsel = $("#selected_blogs_").val();
var selected_blogs = allsel.split(",");
console.log(" before anything:"+selected_blogs);
isblogselected = $(".blog_id_"+blog_id).hasClass("text-selected");
//console.log("blog is selected " + isblogselected);
if(!isblogselected)
{
	if(jQuery.inArray(blog_id,selected_blogs) == -1 && blog_id!=""){
	trackingblog=false;
	}
	
}
else if(isblogselected)
{
	trackingblog=true;
}
//if(jQuery.inArray(blog_id,selected_blogs) == -1 && blog_id!=""){
//	trackingblog=false;
//}else{
//	trackingblog=true;
//}

//console.log("value of tracking blog immediately after click "+trackingblog);
//console.log("value of all selected blogs after click"+selected_blogs);

//trackingblog = $(this).hasClass("text-success");
if(!trackingblog)
{
// if the blog is being tracked
//$(this).addClass("text-success");

$(".curve_"+blog_id).addClass("border-selected");
$(".curve_"+blog_id).find(".posttitle a").addClass("text-selected");
$(".curve_"+blog_id).find(".trackingtracks").addClass("makeinvisible");
$(".blog_id_"+blog_id).attr("data-original-title","Remove Blog from Tracker");
$(".blog_id_"+blog_id).addClass("text-selected");

$(this).parent().parent().addClass("border-selected");
$(this).parent().parent().find(".posttitle a").addClass("text-selected");
$(this).parent().parent().find(".trackingtracks").addClass("makeinvisible");
$(this).attr("data-original-title","Remove Blog from Tracker");
// adding blog to tracks



//console.log("Added blog to be tracked");
		
		//console.log(jQuery.inArray(blog_id,selected_blogs));
		//console.log(selected_blogs);
		if(jQuery.inArray(blog_id,selected_blogs) == -1 && blog_id!=""){
			console.log("I hit here");
			console.log(selected_blogs)
				    // the element is not in the array
				selected_blogs[looper] = blog_id;
				
				blogname = $(".blogname-"+blog_id);
				blogname = $(blogname)[0];
				blogname = $(blogname).text();
				$("#selected_blog_list").append('<button class="col-md-9 btn text-left text-white bold-text blogselection mt10 pt10 pb10 blogg_'+blog_id+'" id="blogg_'+blog_id+'">'+blogname+'<i class="fas fa-trash float-right hidden deleteblog" id="'+blog_id+'"></i></button><br/>');
				/*
				$.getScript( app_url+"pagedependencies/blogbrowser.js", function( data, textStatus, jqxhr ) {				
					
				});
				*/
				$(".blog_id_"+blog_id).addClass("text-selected");
				looper++;
				trackscount++;
				
				var blgs = $(".blogselection");
				console.log("total here"+blgs.length);
				trackscount = blgs.length;
				$(".total_selected").text(blgs.length);
				
				var allblogs = [] ;    
				var k = 0; var j=0;
				var all_blogs = "";
				blgs.each(function(i,e)
					      {
					   		// allblogs[i] = $(this).text();
					   		 id = $(this).attr('id');
					   		 if (id.indexOf("blogg")>-1) {
					   		        blog_id = id.split("_");
					   		        blog_id = blog_id[blog_id.length-1];
						   		     if(k< blgs.length-1){
						   	    		all_blogs+=blog_id+",";
						   	    	}else{
						   	    		all_blogs+=blog_id;
						   	    	}
						   		     k++;
					   		 }
				});
				$("#selected_blogs_").val(all_blogs);
				console.log("selected blogs here:"+all_blogs);
				setSelected(all_blogs);
		};


//console.log(selected_blogs);
//console.log(blog_id);

// add an ajax to add blog to tracker

$('#trackscount').html(trackscount);
$('.tracksection').removeClass("hidden");
$('.tracksection').show();
}
else if(trackingblog)
{
// if the blog is being tracked
//$(this).removeClass("text-success");
	$(".curve_"+blog_id).removeClass("border-selected");
	$(".curve_"+blog_id).find(".posttitle a").removeClass("text-selected");
	$(".curve_"+blog_id).find(".trackingtracks").removeClass("makeinvisible");
	$(".blog_id_"+blog_id).attr("data-original-title","Add Blog from Tracker");
	$(".blog_id_"+blog_id).removeClass("text-selected");

	
$(this).parent().parent().removeClass("border-selected");
$(this).parent().parent().find(".posttitle a").removeClass("text-selected");
$(this).parent().parent().find(".trackingtracks").removeClass("makeinvisible");
$(this).attr("data-original-title","Add Blog from Tracker");

//console.log("Removed blog to be tracked");

//console.log("selected_blogs: "+selected_blogs);
removeBlog(this);
//trackscount--;
//console.log(trackscount);
var blgs = $(".blogselection");
//console.log("total here: "+blgs.length);
//trackscount = blgs.length;
$(".total_selected").text(blgs.length);


$('#trackscount').html(trackscount);
$('.tracksection').show();

		var all_blogs = "";
		blgs.each(function(i,e)
			      {
			   		// allblogs[i] = $(this).text();
			   		 id = $(this).attr('id');
			   		 if (id.indexOf("blogg")>-1) {
			   		        blog_id = id.split("_");
			   		        blog_id = blog_id[blog_id.length-1];
				   		     if(k<blgs.length-1){
				   	    		all_blogs+=blog_id+",";
				   	    	}else{
				   	    		all_blogs+=blog_id;
				   	    	}
				   		     k++;
			   		 }
		});
		
		setSelected(all_blogs);
		if(trackscount == 0)
		{
			$('.tracksection').hide();
		}
	
	}
});

// remove a blog from track on blog browser
function removeBlog(element){
	
	blog_id = "";
	classes = $(element).attr('class').split(/\s+/);
	$.each(classes, function(index, item) {
	    if (item.indexOf("blog_id")>-1) {
	        blog_id = item.split("_");
	        blog_id = blog_id[blog_id.length-1];
	    }
	});
	
	if(jQuery.inArray(blog_id,selected_blogs) != -1 && blog_id!=""){
			    // the element is not in the array
		var index = selected_blogs.indexOf(blog_id);
		console.log("index of id: "+index);
		if (index > -1) {
			selected_blogs.splice(index, 1);
			if(trackscount > 0)
			{
			trackscount--;	
			}
			//console.log("I got here")
		}
		console.log("Selected blog after splice: "+selected_blogs);
		$(".total_selected").text(selected_blogs.length);		
		$(".blog_"+blog_id).remove();
		var blgs = $(".blogselection");
		$(".total_selected").text(blgs.length);
		$(".blog_id_"+blog_id).removeClass("text-selected");
					
	}
}



// call to action to start tracking blogs
$('#initiatetrack').on("click",function(e){
	
$('.trackinitiated, .modalbackdrop').removeClass("hidden");

$('.trackinitiated, .modalbackdrop').show();

// scroll to top

window.scrollTo(0, 0);
	
});

$('.closedialog').on("click",function(e){

$('.trackinitiated, .modalbackdrop').hide();	
$('.trackcreationsection2').addClass("hidden");
$('.trackcreationsection1').removeClass('hidden');	
});


// show the create tracker from dialog handler 
$('.createtrackerbtn').on("click", function(){
$('.trackcreationsection2').removeClass('hidden');
$('.trackcreationsection1').addClass('hidden');
});

// cancel tracker creattion 
$('.canceltrackercreation').on("click", function(e){
e.preventDefault();	
$('.trackcreationsection2').addClass("hidden");
$('.trackcreationsection1').removeClass('hidden');	
})

//handles the creation of the tracker
$('.trackercreatebutton').on('click', function(){

// handle the creation of the tracker right here
// store the tracker name, tracker description
trackername  = $('.blogbrowsertrackername').val();
trackerdescription = $('.blogbrowsertrackerdescription').val();

console.log(trackername);
console.log(trackerdescription);
if(trackername === "")
	{
	toastr.error("Enter Tracker Name","Error");
	}
else if(trackerdescription === "")
	{
	toastr.error("Enter Tracker Description","Error");
	}
else
	{
	// get the blog ids and store
	// get the tracker that was selected if any apart from the new tracker
	
	var all_blogs = "";
	var all_trackers ="";
	var blogs = selected_blogs;
    var allblogs = [] ;
    // push into an array
   // var blogs = $(this).parent().parent().find(".token span");
    var blogs = $(".blogselection");
    var allblogs = [] ;    
    // push into an array
    var k = 0; var j=0;
	   	blogs.each(function(i,e)
	      {
	   		// allblogs[i] = $(this).text();
	   		 id = $(this).attr('id');
	   		 if (id.indexOf("blogg")>-1) {
	   		        blog_id = id.split("_");
	   		        blog_id = blog_id[blog_id.length-1];
		   		     if(k<blogs.length-1){
		   	    		all_blogs+=blog_id+",";
		   	    	}else{
		   	    		all_blogs+=blog_id;
		   	    	}
		   		     k++;
	   		 }
	     });
	   	 
	   //	console.log("Allblogs here:"+all_blogs);return false;
   	
   	 //If at least a tracker is selected, update tracker else create tracker
		$.ajax({
			url: app_url+'tracker',
			method: 'POST',
			data: {
				action:"create",
				name:trackername,
				description:trackerdescription,
				blogs:all_blogs,
			},
			error: function(response)
			{						
				console.log(response);		
			},
			success: function(response)
			{   
				console.log(response);
				if(response.indexOf("success")>-1){
					toastr.success('Tracker successfully created!','Success');
					location.href=app_url+"blogbrowser.jsp";
				}else{
					toastr.error(response,'Error');
				}
			}
		});
	}
});

$('#sortbyselect').on("change",function(e){
	//console.log("changed");
	//console.log($('#sortbyselect').val());
	$("#sortby").val($('#sortbyselect').val());
	//$("#sortform").submit();
	$('form#sortform').submit();
});

});


function updateTracker(element,type){
    var all_blogs = "";
	var all_trackers ="";
	var blogs = selected_blogs;
    var allblogs = [] ;

    var blogs = $(".blogselection");

    var allblogs = [] ;    
    var k = 0; var j=0;
	   	blogs.each(function(i,e)
	      {
	   		// allblogs[i] = $(this).text();
	   		 idd = $(this).attr('id');
	   		 if (idd.indexOf("blogg")>-1) {
	   		        blog_id = idd.split("_");
	   		        blog_id = blog_id[blog_id.length-1];
		   		     if(k<blogs.length-1){
		   	    		all_blogs+=blog_id+",";
		   	    	}else{
		   	    		all_blogs+=blog_id;
		   	    	}
		   		     k++;
	   		 }
	     });
	   	 
	  
	   	id = $(element).attr('id');	   		 
		    $.ajax({
				url: app_url+'tracker',
				method: 'POST',
				data: {
					action: type,
					blogs:all_blogs,
					tracker_id:id,
				},
				error: function(response)
				{						
					console.log(response);		
				},
				success: function(response)
				{   
					console.log(response);
					if(response.indexOf("success")>-1){
						toastr.success('Tracker successfully updated!','Success');
						//location.href=app_url+"blogbrowser.jsp";
					}else{
						if(type=="update"){
							toastr.error('Blog already exist in tracker','Error');
						}else{
							//toastr.error('Blog already exist in tracker','Error');
						}
					}
				}
			});
}




function setSelected(all_blogs){
	$.ajax({
		url: app_url+'tracker',
		method: 'POST',
		data: {
			action:"setselected",
			blogs:all_blogs,
		},
		error: function(response)
		{						
			console.log(response);		
		},
		success: function(response)
		{   
			
		}
	});
}

