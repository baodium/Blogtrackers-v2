$(document).ready(function() {
	
	//console.log(Cookies.get('selectedblogs'));
	// tracking blogcount
	var trackscount = 0;
	// tracker selected count
	var trackerselectedcount = 0;
	
	// store both in session 
	
  $(function () {
    $('[data-toggle="tooltip"]').tooltip()
  })
  
  // check login status 
  var loggedinstatus = Cookies.get("loggedinstatus");
 if(loggedinstatus == "false")
	 {
	 
	 }
  console.log(Cookies.get("allfavoritesblogs"));

//  blog individual
var countblog = 0;
  
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
  if(!selected)
  {
    $(this).find(".checktracker").removeClass("hidden");
    $(this).addClass("trackerindividualactive").removeClass("bold-text");
    // remember to pass session id of blog
    trackerselectedcount++;
    console.log(trackerselectedcount);
    
    $('.selectedtrackercount').html(trackerselectedcount);
  }
  // check if a blog is not selected
  else if(selected)
  {
    $(this).find(".checktracker").addClass("hidden");
    $(this).removeClass("trackerindividualactive").addClass("bold-text");
    // remember to pass session id of blog
    trackerselectedcount--;
    console.log(trackerselectedcount);
    // increase count of selected tracker
    $('.selectedtrackercount').html(trackerselectedcount);
  }

});

// end of tracker list handler

// close the tracks at the footer
$('#closetracks').on("click",function(){
	$(this).parent().toggle();	
	});



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
$(this).parent().remove();
// perform an action that remove the blog from the list
})
// end

  // handler for each favorites
  $('.favoritestoggle').on("click",function(e){
  // check if it has been favorites
  isFavorites = $(this).hasClass('fas');
  var postcount = $("#postcount").html();
  console.log(postcount);
  if(isFavorites) // if it is favorites
  {	  
  blogpostidtoadd = $(this).attr("id").split("_")[1];	 
  console.log(blogpostidtoadd);
  $(this).removeClass("fas fa-heart").addClass("far fa-heart");
  $(this).attr("data-original-title","Add to Favorite");
  $(this).parent().parent().remove();
  $(".tooltip").hide();
  //console.log("Remove from favorites");
  $.ajax({
	  url:app_url+"favorites",
		method:"POST",
		data:{
		action:"removefromfavorites",
		//allblogpost:allblogasstring
		bloposttoadd:blogpostidtoadd
		},
		error:function(response){
			
		},
		success:function(response){
		if(response === "removed")
		{
			//toastr.error('Removed from Favorites','Success');
		toastr.success("Blog Removed from Favorites","Action Succesful");
		if(postcount > 0)
		{
		postcount--;
		$("#postcount").html(postcount);
		}
		}
		}
  });
  
 
  // add an ajax remove blog from favorites
  
  }
  if(!isFavorites) // if it does not have favorites
  {
  $(this).removeClass("far fa-heart").addClass("fas fa-heart");
  $(this).attr("data-original-title","Remove from Favorite");
  console.log("add to favorites");
   // add an ajax to favorite the blod
 
  }

  })
  // end of handler for favorites


 
  //select a blog to track
$(document).on("click",".trackblog",function(e){
// check the status if the blog is tracked
trackingblog = $(this).hasClass("text-success");
if(!trackingblog)
{
// if the blog is being tracked
$(this).addClass("text-success");
$(this).parent().parent().addClass("border-selected");
$(this).parent().parent().find(".posttitle a").addClass("text-selected");
$(this).parent().parent().find(".trackingtracks").addClass("makeinvisible");
$(this).attr("data-original-title","Remove Blog from Tracker");
// adding blog to tracks
console.log("Added blog to be tracked");
// add an ajax to add blog to tracker
trackscount++;
$('#trackscount').html(trackscount);
$('.tracksection').show();
}
else if(trackingblog)
{
// if the blog is being tracked
$(this).removeClass("text-success");
$(this).parent().parent().removeClass("border-selected");
$(this).parent().parent().find(".posttitle a").removeClass("text-selected");
$(this).parent().parent().find(".trackingtracks").removeClass("makeinvisible");
$(this).attr("data-original-title","Add Blog from Tracker");

console.log("Removed blog to be tracked");
// add an ajax to remove blog from tracker
trackscount--;
$('#trackscount').html(trackscount);
$('.tracksection').show();
if(trackscount == 0)
	{
	$('.tracksection').hide();
	}
}
});



//call to action to start tracking blogs
$('#initiatetrack').on("click",function(e){

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
	$('.canceltracker').on("click", function(e){
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
	}
	
	
});


});