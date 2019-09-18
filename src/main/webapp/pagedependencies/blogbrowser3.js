// adekunle tweak version of blog browser page
var selected_blogs = new Array();
var looper = 0;
var viewtype = Cookies.get("viewtype");
$(document).ready(function() {
<<<<<<< HEAD
//type of view
// default view is unknown	
//Cookies.set('viewtype',"",{path:'/'})
=======
// type of view
// default view is unknown
// Cookies.set('viewtype',"",{path:'/'})
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7

// show the grid
if(viewtype == null || viewtype === "" || viewtype==="grid")
{
	$('.listlook').addClass("hidden");
	$(".gridlook").removeClass("hidden");	
}

// show the list
if(viewtype === "list" )
{
	$('.listlook').removeClass("hidden");
	$(".gridlook").addClass("hidden");	
}
console.log(viewtype);
<<<<<<< HEAD
//end
=======
// end
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
$('#listtoggle').on("click",() => {
Cookies.set('viewtype',"list",{path:'/'})
viewtype = Cookies.get("viewtype");
$('.listlook').removeClass("hidden");
$(".gridlook").addClass("hidden");

})

$('#gridtoggle').on("click",() => {
Cookies.set('viewtype',"grid",{path:'/'})
viewtype = Cookies.get("viewtype");
$('.listlook').addClass("hidden");
$(".gridlook").removeClass("hidden");
<<<<<<< HEAD
///console.log(viewtype);
})

//console.log(viewtype);
	var loggedinstatus = Cookies.get("loggedinstatus");
	//console.log(typeof(Cookies.get('allfavoritesblogs')));
	Cookies.set('selectedblogs', "", {path : '/'});	
	//console.log(theme);
=======
// /console.log(viewtype);
})

// console.log(viewtype);
	var loggedinstatus = Cookies.get("loggedinstatus");
	// console.log(typeof(Cookies.get('allfavoritesblogs')));
	Cookies.set('selectedblogs', "", {path : '/'});	
	// console.log(theme);
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
	// tracking blogcount
	
	// tracker selected count
	var blgs = $(".blogselection");
	var trackscount = blgs.length;
	var trackerselectedcount = 0;
	
<<<<<<< HEAD
//  show tooltip
=======
// show tooltip
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
  $(function () {
    $('[data-toggle="tooltip"]').tooltip()
  })

<<<<<<< HEAD
 //tracker list handler  
=======
 // tracker list handler
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
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


<<<<<<< HEAD
//tracker list handler
=======
// tracker list handler
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
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
    updateTracker(this,"removeblog");
    trackerselectedcount--;
    console.log("not"+trackerselectedcount);
    // increase count of selected tracker
    $('.selectedtrackercount').html(trackerselectedcount);
  }

});

// end of tracker list handler



<<<<<<< HEAD
//tracker list handler
=======
// tracker list handler
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
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
var blogpostids = [];
var allblogasstring =  "";

// on load handler
$(window).on("load",function(e){
loggedin = Cookies.get('loggedinstatus');
<<<<<<< HEAD
//console.log(loggedin);
=======
// console.log(loggedin);
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
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
<<<<<<< HEAD
//console.log(blogpostids[eachblog]);	
=======
// console.log(blogpostids[eachblog]);
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
}
}


<<<<<<< HEAD
//console.log(blogpostids);
//console.log("Cookie on window load "+ cookieblogs);
=======
// console.log(blogpostids);
// console.log("Cookie on window load "+ cookieblogs);
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
}
})
// handler for each favorites
$(document).on("click",".favoritestoggle",function(e){
// check if it has been favorites
isFavorites = $(this).hasClass('far');
if(isFavorites) // if it is favorites
{
<<<<<<< HEAD
// grab the individual id	
=======
// grab the individual id
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
blogpostidtoadd = $(this).attr("id").split("_")[1];
// checks if element exist in the array
if(!blogpostids.includes(blogpostidtoadd))
{
<<<<<<< HEAD
//console.log(blogpostids.includes(blogpostidtoadd))
// push the new element in the array
blogpostids.push(blogpostidtoadd);
//join together as string
cookieblogs = Cookies.get('allfavoritesblogs');
//console.log(cookieblogs);
=======
// console.log(blogpostids.includes(blogpostidtoadd))
// push the new element in the array
blogpostids.push(blogpostidtoadd);
// join together as string
cookieblogs = Cookies.get('allfavoritesblogs');
// console.log(cookieblogs);
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
if(cookieblogs === "")
{
	allblogasstring = blogpostids.join(",");	
}
else if(cookieblogs !== "")
{
	allblogasstring = blogpostids.join(",");
}
$.ajax({
	url:app_url+"favorites",
	method:"POST",
	data:{
	action:"addtofavorites",
<<<<<<< HEAD
	//allblogpost:allblogasstring
=======
	// allblogpost:allblogasstring
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
	bloposttoadd:blogpostidtoadd
	},
	error:function(response){
		
	},
	success:function(response){
<<<<<<< HEAD
		//console.log(response)
=======
		// console.log(response)
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
	if(response === "addedtofavorites")
		{
		toastr.success('Added to Favorites','Success');
		}
	if(response === "notloggedin")
		{
<<<<<<< HEAD
		//console.log(response);
		//console.log(loggedinstatus);
		// set a cookie for blog
		Cookies.set('allfavoritesblogs', allblogasstring , {path : '/'});	
		//console.log("Cookies string added after click "+Cookies.get('allfavoritesblogs'));
		
		}
	//console.log(response)	
=======
		// console.log(response);
		// console.log(loggedinstatus);
		// set a cookie for blog
		Cookies.set('allfavoritesblogs', allblogasstring , {path : '/'});	
		// console.log("Cookies string added after click
		// "+Cookies.get('allfavoritesblogs'));
		
		}
	// console.log(response)
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
	}
		
	});
}
$(this).removeClass("far fa-heart").addClass("fas fa-heart");
$(this).attr("data-original-title","Remove from Favorites");

<<<<<<< HEAD
//console.log("You Added to favorites")
=======
// console.log("You Added to favorites")
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
// add an jax to favorites the post

}
else if(!isFavorites) // if it does not have favorites
{
blogpostidtoadd = $(this).attr("id").split("_")[1];
$(this).removeClass("fas fa-heart").addClass("far fa-heart");
$(this).attr("data-original-title","Add to Favorites");
if(blogpostids.includes(blogpostidtoadd))
{
blogpostids.splice(blogpostids.indexOf(blogpostidtoadd),1)
allblogasstring = blogpostids.join(",");
<<<<<<< HEAD
//ajax function to remove from favorites
//console.log(blogpostids.indexOf(blogpostidtoadd))
//console.log("After remove")
//console.log(blogpostids);
//console.log(blogpostids.includes(blogpostidtoadd))


}
//console.log("You removed from favorites")
=======
// ajax function to remove from favorites
// console.log(blogpostids.indexOf(blogpostidtoadd))
// console.log("After remove")
// console.log(blogpostids);
// console.log(blogpostids.includes(blogpostidtoadd))


}
// console.log("You removed from favorites")
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
// add an ajax to unfavorite the post
$.ajax({
	url:app_url+"favorites",
	method:"POST",
	data:{
	action:"removefromfavorites",
<<<<<<< HEAD
	//allblogpost:allblogasstring
=======
	// allblogpost:allblogasstring
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
	bloposttoadd:blogpostidtoadd
	},
	error:function(response){
		
	},
	success:function(response){
	if(response === "removed")
	{
		toastr.success('Removed from Favorites','Success');
	}
	if(response === "notloggedin")
	{
<<<<<<< HEAD
	//console.log(response);
	//console.log(loggedinstatus);
	// set a cookie for blog
	Cookies.set('allfavoritesblogs', allblogasstring , {path : '/'});
	//console.log("Remove after blog deleted "+Cookies.get('allfavoritesblogs'));
	//console.log(blogpostids);
	//console.log(Cookies.get('allfavoritesblogs'));
	}
	//console.log(response);
=======
	// console.log(response);
	// console.log(loggedinstatus);
	// set a cookie for blog
	Cookies.set('allfavoritesblogs', allblogasstring , {path : '/'});
	// console.log("Remove after blog deleted
	// "+Cookies.get('allfavoritesblogs'));
	// console.log(blogpostids);
	// console.log(Cookies.get('allfavoritesblogs'));
	}
	// console.log(response);
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
	}
});
}

});
// end of handler for favorites


<<<<<<< HEAD
//select a blog to track
=======
// select a blog to track
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
$(document).on("click",".trackblog",function(e){
// check the status if the blog is tracked
var blog_id = "";
classes = $(this).attr('class').split(/\s+/);
$.each(classes, function(index, item) {
	    if (item.indexOf("blog_id")>-1) {
	        blog_id = item.split("_");
	        blog_id = blog_id[blog_id.length-1];
	    }
	});
var trackingblog = false;
var allsel = $("#selected_blogs_").val();
var selected_blogs = allsel.split(",");
isblogselected = $(".blog_id_"+blog_id).hasClass("text-selected");
<<<<<<< HEAD
//console.log("blog is selected " + isblogselected);
=======
// console.log("blog is selected " + isblogselected);
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
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

<<<<<<< HEAD
/*if(jQuery.inArray(blog_id,selected_blogs) == -1 && blog_id!=""){
	trackingblog=false;
}else{
	trackingblog=true;
}*/

//trackingblog = $(this).hasClass("text-success");
if(!trackingblog)
{
// if the blog is being tracked
//$(this).addClass("text-success");
// remember check what is selected selected	
=======
/*
 * if(jQuery.inArray(blog_id,selected_blogs) == -1 && blog_id!=""){
 * trackingblog=false; }else{ trackingblog=true; }
 */

// trackingblog = $(this).hasClass("text-success");
if(!trackingblog)
{
// if the blog is being tracked
// $(this).addClass("text-success");
// remember check what is selected selected
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
	
$(".curve_"+blog_id+" td").addClass("border-selected");
$(".curve_"+blog_id+" td .myposttitle a").addClass("text-selected");
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
// adding blog to tracks



<<<<<<< HEAD
      //console.log("Added blog to be tracked");
		
       //console.log("Let's see: "+jQuery.inArray(blog_id,selected_blogs));
=======
      // console.log("Added blog to be tracked");
		
       // console.log("Let's see: "+jQuery.inArray(blog_id,selected_blogs));
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
      // console.log("Changed Array: "+selected_blogs);
		if((jQuery.inArray(blog_id,selected_blogs) >= -1) && blog_id!=""){
				    // the element is not in the array
				selected_blogs[looper] = blog_id;
				
				blogname = $(".blogname-"+blog_id);
				blogname = $(blogname)[0];
				blogname = $(blogname).text();
<<<<<<< HEAD
				// fix break number one; 
				$("#selected_blog_list").append('<button class="col-md-9 btn text-left text-white bold-text blogselection mt10 pt10 pb10 blogg_'+blog_id+'" id="blogg_'+blog_id+'">'+blogname+'<i class="fas fa-trash float-right hidden deleteblog" id="'+blog_id+'"></i></button>');
				/*
				$.getScript( app_url+"pagedependencies/blogbrowser.js", function( data, textStatus, jqxhr ) {				
					
				});
				*/
=======
				// fix break number one;
				$("#selected_blog_list").append('<button class="col-md-9 btn text-left text-white bold-text blogselection mt10 pt10 pb10 blogg_'+blog_id+'" id="blogg_'+blog_id+'">'+blogname+'<i class="fas fa-trash float-right hidden deleteblog" id="'+blog_id+'"></i></button>');
				/*
				 * $.getScript( app_url+"pagedependencies/blogbrowser.js",
				 * function( data, textStatus, jqxhr ) {
				 * 
				 * });
				 */
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
				$(".blog_id_"+blog_id).addClass("text-selected");
				looper++;
				trackscount++;
				
				var blgs = $(".blogselection");
<<<<<<< HEAD
				//console.log("total here"+blgs.length);
=======
				// console.log("total here"+blgs.length);
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
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
				// create a cookie that is accessible anywhere on the site
				// set a cookie for the selected blog to make it easier
				Cookies.set('selectedblogs', all_blogs, {path : '/'});
				// retrieve the value of the theme cookie
<<<<<<< HEAD
				//console.log(Cookies.get('selectedblogs'));
				//var alltheselectedblogcookie =  Cookies.get('selectedblogs');
				$("#selected_blogs_").val(all_blogs);
				//console.log("selected blogs here:"+all_blogs);
=======
				// console.log(Cookies.get('selectedblogs'));
				// var alltheselectedblogcookie = Cookies.get('selectedblogs');
				$("#selected_blogs_").val(all_blogs);
				// console.log("selected blogs here:"+all_blogs);
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
				setSelected(all_blogs);
		};


<<<<<<< HEAD
//console.log(selected_blogs);
//console.log(blog_id);
=======
// console.log(selected_blogs);
// console.log(blog_id);
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7

// add an ajax to add blog to tracker

$('#trackscount').html(trackscount);
$('.tracksection').removeClass("hidden");
$('.tracksection').show();
}
else if(trackingblog)
{
// if the blog is being tracked
<<<<<<< HEAD
//$(this).removeClass("text-success");
=======
// $(this).removeClass("text-success");
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
	$(".curve_"+blog_id+" td").removeClass("border-selected");
	$(".curve_"+blog_id+" td .myposttitle a").removeClass("text-selected");
	
	$(".curve_"+blog_id).removeClass("border-selected");
	$(".curve_"+blog_id).find(".posttitle a").removeClass("text-selected");
	$(".curve_"+blog_id).find(".trackingtracks").removeClass("makeinvisible");
	$(".blog_id_"+blog_id).attr("data-original-title","Add Blog from Tracker");
	$(".blog_id_"+blog_id).removeClass("text-selected");
	
$(this).parent().parent().removeClass("border-selected");
$(this).parent().parent().find(".posttitle a").removeClass("text-selected");
$(this).parent().parent().find(".trackingtracks").removeClass("makeinvisible");
$(this).attr("data-original-title","Add Blog from Tracker");

console.log("Removed blog to be tracked");
removeBlog(this,blog_id,selected_blogs);
<<<<<<< HEAD
//trackscount--;

var blgs = $(".blogselection");
//console.log("total here"+blgs.length);
//trackscount = blgs.length;
=======
// trackscount--;

var blgs = $(".blogselection");
// console.log("total here"+blgs.length);
// trackscount = blgs.length;
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
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


function removeBlog(element,blog_id,selected_blogs){
	blog_id = "";
	classes = $(element).attr('class').split(/\s+/);
	$.each(classes, function(index, item) {
	    if (item.indexOf("blog_id")>-1) {
	        blog_id = item.split("_");
	        blog_id = blog_id[blog_id.length-1];
	    }
	});

	console.log("Selected blog in deselecting blog: "+selected_blogs);
	if(jQuery.inArray(blog_id,selected_blogs) != -1 && blog_id!=""){
			    // the element is not in the array
		var index = selected_blogs.indexOf(blog_id);
		if (index > -1) {
			selected_blogs.splice(index, 1);
			Cookies.set('selectedblogs', selected_blogs, {path : '/'});
			// clear the cookie
<<<<<<< HEAD
			//Cookies.clear('selectedblogs');
=======
			// Cookies.clear('selectedblogs');
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
			console.log(Cookies.get('selectedblogs'));
			if(trackscount > 0)
			{
			trackscount--;	
			}
		}
		$(".total_selected").text(selected_blogs.length);		
			$(".blogg_"+blog_id).remove();
<<<<<<< HEAD
		//trackscount--;
=======
		// trackscount--;
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
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


<<<<<<< HEAD
// show the create tracker from dialog handler 
$('.createtrackerbtn').on("click", function(){
	//console.log(typeof loggedinstatus)
=======
// show the create tracker from dialog handler
$('.createtrackerbtn').on("click", function(){
	// console.log(typeof loggedinstatus)
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
	if(loggedinstatus === "true")
	{
	$('.trackcreationsection2').removeClass('hidden');
	$('.trackcreationsection1').addClass('hidden');
	}
	else if(loggedinstatus === "false")
	{
	toastr.error('You must be logged in to create a tracker','Error');
	}

});

<<<<<<< HEAD
// cancel tracker creattion 
=======
// cancel tracker creattion
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
$('.canceltrackercreation').on("click", function(e){
e.preventDefault();	
$('.trackcreationsection2').addClass("hidden");
$('.trackcreationsection1').removeClass('hidden');	
})

<<<<<<< HEAD
//handles the creation of the tracker
=======
// handles the creation of the tracker
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
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
	   	 
<<<<<<< HEAD
	   //	console.log("Allblogs here:"+all_blogs);return false;
	   	$('.trackercreatebutton').val("creating tracker");
	   	$('.trackercreatebutton').attr("disabled",true);
   	 //If at least a tracker is selected, update tracker else create tracker
=======
	   // console.log("Allblogs here:"+all_blogs);return false;
	   	$('.trackercreatebutton').val("creating tracker");
	   	$('.trackercreatebutton').attr("disabled",true);
   	 // If at least a tracker is selected, update tracker else create tracker
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
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
<<<<<<< HEAD
				//if(response.indexOf("success")>-1){
=======
				// if(response.indexOf("success")>-1){
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
				if(response!="error creating tracker" && response!="tracker already exist"){
					toastr.success('Tracker successfully created and Updated!','Success');
					$('.trackcreationsection2').addClass("hidden");
					$('.trackcreationsection1').removeClass('hidden');
					$('.trackinitiated, .modalbackdrop').hide();
					console.log(app_url)
					$.ajax({
					url:app_url+"subpages/gettrackerlist.jsp",
					method:"POST",
					error:function(response)
					{
					console.log(response);	
					},
					success: function(response)
					{
						console.log(response);		
					$('.trackerlist').html(response);
					}
					});
<<<<<<< HEAD
					//location.href=app_url+"blogbrowser.jsp";
=======
					// location.href=app_url+"blogbrowser.jsp";
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
				}else{
					toastr.error(response,'Error');
					$('.trackercreatebutton').val("Create");
				   	$('.trackercreatebutton').attr("disabled",false);
				}
			}
		});
	}
});

$('#sortbyselect').on("change",function(e){
<<<<<<< HEAD
	//console.log("changed");
	//console.log($('#sortbyselect').val());
	$("#sortby").val($('#sortbyselect').val());
	//$("#sortform").submit();
=======
	// console.log("changed");
	// console.log($('#sortbyselect').val());
	$("#sortby").val($('#sortbyselect').val());
	// $("#sortform").submit();
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
	$('form#sortform').submit();
});


<<<<<<< HEAD
//onload function to select again tracked blog

$(window).on("load",function(){
	//console.log(Cookies.get('selectedblogs'));	
=======
// onload function to select again tracked blog

$(window).on("load",function(){
	// console.log(Cookies.get('selectedblogs'));
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
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
						Cookies.set('selectedblogs', "", {path : '/'});
						toastr.success('Tracker successfully updated!','Success');

						$("#added-info").removeClass("no-display");

<<<<<<< HEAD
						//setTimeout(function(){location.href = "edittracker.jsp?tid="+id ;},2000);

						//location.href=app_url+"blogbrowser.jsp";
=======
						// setTimeout(function(){location.href =
						// "edittracker.jsp?tid="+id ;},2000);

						// location.href=app_url+"blogbrowser.jsp";
>>>>>>> 3688e1076356d7a3f4bcbfa338de1444845d71d7
					}else{
						if(type=="update"){
							Cookies.clear('selectedblogs', "", {path : '/'});
							toastr.error('Blog already exist in tracker','Error');
						}else{
							toastr.error('Blog already exist in tracker','Error');
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




