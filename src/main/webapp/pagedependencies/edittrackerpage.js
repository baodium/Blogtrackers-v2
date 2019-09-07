$(document).ready(function(){

var numberofblogs = $('.edittrackerblogindividual').length;
//console.log(numberofblogs);
$('#totalblogcount').html(numberofblogs);
	// count the number of selected blogs on load
countselectedfromdefault =  $('.edittrackerblogindividual').children(".checkblogleft").children(".checkblog").length;
// initialize the count of the selected blog
var blogselectedcount = countselectedfromdefault;
$('#selectedblogcount').html(blogselectedcount);
$(window).on("load",function(){

// check for checked blog

checkedblog = $('.edittrackerblogindividual').children(".checkblogleft").children(".checkuncheckblog"); 
 
if(checkedblog.hasClass('checkblog'))
{
// select active blog in tracker	
$('.edittrackerblogindividual').children(".checkblogleft").has('.checkblog').parent().addClass("btnselected text-success");	

// activate the status of tracking by default 
$('.edittrackerblogindividual').children(".checkblogleft").has('.checkblog').parent().children('.iconsetblogs').children('.trackblogindividual').addClass('trackblogblue').removeClass('trackbloggrey').attr("data-original-title","Untrack Blog");
}

})
	
// mouse on each blog show the additional option of the blog
//$('.edittrackerblogindividual').on("mouseover",function(e){
//$(this).addClass("btnselected").removeClass("btndefaultlook");
////add the other blog options
//
//
////check the status of all checkmarks tooltip
//checkstatusofblog = $(this).children(".checkblogleft").children(".checkuncheckblog").hasClass("checkblog");
//
////console.log(checkstatusofblog)
//if(checkstatusofblog)
//{
//// show other option icons if checked	
//$(this).children(".iconsetblogs").children(".setoficons").removeClass("makeinvisible");	
//$(this).children(".checkblogleft").children(".checkuncheckblog").attr("data-original-title","Deselect Blog");	
//}
//else if(!checkstatusofblog)
//{
//$(this).children(".checkblogleft").children(".checkuncheckblog").attr("data-original-title","Select Blog");	
//$(this).children(".iconsetblogs").children(".setoficons").addClass("makeinvisible");	
//}
//
//// check track status 
// checktrackstatusofblog = $(this).children(".iconsetblogs").children(".trackblogindividual").hasClass("trackblogblue");
// if( checktrackstatusofblog)
//{
//$(this).children('.iconsetblogs').children('.trackblogindividual').attr("data-original-title","Untrack Blog");
//	 
// }
//
//});
	

//$('.edittrackerblogindividual').on("mouseout",function(e){
//
//
//
//// check if blog has been selected
//selected = $(this).children('.checkblogleft').children('.checkuncheckblog').hasClass('checkblog');
////console.log(selected);
//if(selected)
//{
//// do nothing
//$(this).children(".iconsetblogs").children(".setoficons").addClass("makeinvisible");
//}
//else if(!selected)
//{
//// hides the other blog options
//$(this).children(".iconsetblogs").children(".setoficons").addClass("makeinvisible");	
//$(this).removeClass("btnselected").addClass("btndefaultlook");
//}
//
//
//});


// select a blog with check mark track
$('.checkuncheckblog').on("click",function(e){
//check the status of the checkmark	
checked = $(this).hasClass('checkblog');	
//console.log(checked);

// unselect a blog action
if(checked)
{
	
$(this).parent().parent().removeClass("btnselected text-success").addClass('btndefaultlook');	
// toast notification you already selected this blog
$(this).removeClass("checkblog");
$(this).addClass("uncheckblog");
toastr.error("Blog Deselected","Removed");
// check if selectedcount is not zero
if(blogselectedcount > 0)
{
	$('.checkuncheckallblog').addClass('uncheckallblog').removeClass('checkallblog');
	blogselectedcount--;
	$('#selectedblogcount').html(blogselectedcount);
}

}
// select a blog action
else if(!checked)
{
$(this).parent().parent().addClass("btnselected text-success");	
// if not check initially	
$(this).parent().parent().children(".checkblogleft").children(".checkuncheckblog").attr("data-original-title","Deselect Blog");
$(this).addClass("checkblog");
$(this).removeClass("uncheckblog");	
toastr.success("Blog Selected","Selected");
blogselectedcount++;
$('#selectedblogcount').html(blogselectedcount);
}
	
})


// track blogindividual action 
$('.trackblogindividual').on("click",function(e){
parentelement = $(this).parent().parent();
checkifnottrackingblog = $(this).hasClass('trackbloggrey');

// track blog action 
if(checkifnottrackingblog)
{
	// put all blog of code in ajax call success
	$(this).removeClass('trackbloggrey');
	
	// increase selected count
	// add blog of code in success
	ischeckedalready = parentelement.children('.checkblogleft').children('.checkuncheckblog').hasClass('checkblog');
	if(!ischeckedalready)
		{
		blogselectedcount++;
		$('#selectedblogcount').html(blogselectedcount);
		}
	$(this).addClass('trackblogblue').attr("data-original-title","Untrack Blog");	
	parentelement.addClass('btnsuccess text-success').children(".checkblogleft").children(".checkuncheckblog").addClass('checkblog').removeClass('uncheckblog');
	toastr.success("Blog added to tracker","Success");
	// perform an ajax action to start blog track immediately
}
// untrack blog action 
else if(!checkifnottrackingblog)
	{
	// put all blog of code in ajax call success
	$(this).addClass('trackbloggrey');
	$(this).removeClass('trackblogblue');
	parentelement.removeClass('btnsuccess text-success');
	parentelement.children(".checkblogleft").children(".checkuncheckblog").removeClass('checkblog').addClass('uncheckblog');
	
	toastr.error("Blog removed from tracker","Removed");
	if(blogselectedcount >= 0)
	{
		blogselectedcount--;
		$('#selectedblogcount').html(blogselectedcount);
	}
	// ajax to remove blog from being tracked
	}

})

// refresh blog individual action 
$('.refreshblog').on('click', function(){
eachblogrefresh = $(this);
// should kick in the automated crawler or something 	
	toastr.success("Blog Refreshing","Success");	
});

/*//delete blog from tracker 
$('.deleteblog').on('click', function(){
	var confirmdeleteofblog = confirm("Are you sure you want to delete");
	if(confirmdeleteofblog )
		{
		eachblogdelete = $(this);
		eachblogdelete.parent().parent().parent().remove();
		// should kick in the automated crawler or something 	
			toastr.error("Blog Deleted from Tracker","Success");
			$('.tooltip').hide();
			
			numberofblogs = $('.edittrackerblogindividual').length;
			$('#totalblogcount').html(numberofblogs);
			
			countselectedfromdefault =  $('.edittrackerblogindividual').children(".checkblogleft").children(".checkblog").length;
//			console.log(countselectedfromdefault);
			blogselectedcount = countselectedfromdefault;
			$('#selectedblogcount').html(blogselectedcount);
		}
	
		
	});*/

//delete blog from tracker 
$('.deleteblog').on('click', function(){
	var confirmdeleteofblog = confirm("Are you sure you want to delete this blog");
	if(confirmdeleteofblog )
		{
		eachblogdelete = $(this);
		var id = $(this).attr("id");
		id = id.split("_");
		allid = id[0];
		console.log(allid);
		console.log($("#teeid").val());
		toastr.success("Deleting blog...","Success");
		$.ajax({
			url: app_url+'tracker',
			method: 'POST',
			data: {
				action:"removeblog",
				blog_ids:allid,
				tracker_id:$("#teeid").val()
			},
			error: function(response)
			{						
				console.log(response);		
			},
			success: function(response)
			{   
				console.log(response);
				if(response.indexOf("success")>-1){					
						eachblogdelete.parent().parent().remove();
					// should kick in the automated crawler or something 	
						toastr.success("Blog Deleted from Tracker","Success");
						$('.tooltip').hide();
						
						numberofblogs = $('.edittrackerblogindividual').length;
						//$('#totalblogcount').html(numberofblogs);
						var initc = $(".stattext").html();
						initc = parseInt(initc)-1;
						$(".stattext").html(initc);
						
						countselectedfromdefault =  $('.edittrackerblogindividual').children(".checkblogleft").children(".checkblog").length;
//						console.log(countselectedfromdefault);
						blogselectedcount = countselectedfromdefault;
						$('#selectedblogcount').html(blogselectedcount);
						setTimeout(function(){location.reload();},2000);
					
				}else{
					toastr.error('Blogs could not be removed!','Error');
				}
			}
		});
		
			
		}
	
		
	});
	

// checkallblog or uncheckallblog action
$(".checkuncheckallblog").on("click", function(e){
ischecked = $(this).hasClass("uncheckallblog");

// triggers the selection of all blog 
if(ischecked)
{
	$(this).addClass("checkallblog").removeClass("uncheckallblog");
	$('.edittrackerblogindividual').children('.checkblogleft').children('.checkuncheckblog').addClass("checkblog").removeClass("uncheckblog");
	$('.edittrackerblogindividual').removeClass("btndefaultlook").addClass("btnselected");
	countselectedfromdefault =  $('.edittrackerblogindividual').children(".checkblogleft").children(".checkblog").length;
	blogselectedcount = countselectedfromdefault;
	$('#selectedblogcount').html(blogselectedcount);
//	console.log(ischecked);	
}

// triggers unselection of all blogs
else if(!ischecked)
{
	$(this).removeClass("checkallblog").addClass("uncheckallblog");
	$('.edittrackerblogindividual').children('.checkblogleft').children('.checkuncheckblog').removeClass("checkblog").addClass("uncheckblog");
	$('.edittrackerblogindividual').each(function(el,i){
	untracked = $(this).children('.iconsetblogs').children(".trackblogindividual").hasClass("trackbloggrey");
	if(untracked)
		{
		$(this).children('.iconsetblogs').children(".trackblogindividual").has('.trackbloggrey').parent().parent().children('.checkblogleft').children('.checkuncheckblog').removeClass("checkblog").addClass("uncheckblog");
		$(this).addClass('btndefaultlook').removeClass('btnselected text-success');
		}
	else if(!untracked)
		{
//		$(this).children('.iconsetblogs').children(".trackblogindividual").has('.trackbloggrey').parent().parent().children('.checkblogleft').children('.checkuncheckblog').removeClass("uncheckblog").addClass("checkblog");
//		$(this).addClass('btndefaultlook').removeClass('btnselected text-success');
		}
	})
	
}

});


// track all selected blog action
$('.trackallblog').on("click", function(){
	$('.edittrackerblogindividual').each(function(el,i){
		selectedblogelement = $('.edittrackerblogindividual').children('.checkblogleft').children('.checkblog');
		selected  = $(this).children('.checkblogleft').children('.checkuncheckblog').hasClass('checkblog'); 
		if(selected)
		{
			selectedblogelement.parent().parent().children('.iconsetblogs').children(".trackblogindividual").addClass("trackblogblue").removeClass("trackbloggrey");
				
		}
	});
	
	
	selected2  = $('.edittrackerblogindividual').children('.checkblogleft').children('.checkuncheckblog').hasClass('checkblog'); 
	if(selected2)
	{
		// grab the IDS and ajax request
		toastr.success("Tracking Selected Blogs","Success");
	}
});

$('.disabletrackallblog').on("click", function(){
	$('.edittrackerblogindividual').each(function(el,i){
		
		selectedblogelement = $(this).children('.checkblogleft').children('.checkblog');
		selected  = $(this).children('.checkblogleft').children('.checkuncheckblog').hasClass('checkblog'); 
//		console.log(selectedblogelement);
		if(selected)
			{
			selectedblogelement.parent().parent().children('.iconsetblogs').children(".trackblogindividual").addClass("trackbloggrey").removeClass("trackblogblue");
		// perform an ajax to remove blog from tracker	
			}
	});
	
	selected2  = $('.edittrackerblogindividual').children('.checkblogleft').children('.checkuncheckblog').hasClass('checkblog'); 
	if(selected2)
	{
		// grab the IDS OF BLOGS AND REFRESH
		toastr.error("Untracking Selected Blogs","Error");
	}
	
});

$('.refreshallblogfromtracker').on("click", function(){

	selectedblogelement = $('.edittrackerblogindividual').children('.checkblogleft').children('.checkblog');
//	selectedblogelement.parent().parent().children('.iconsetblogs').children(".trackblogindividual").addClass("trackbloggrey").removeClass("trackblogblue");
	selected  = $('.edittrackerblogindividual').children('.checkblogleft').children('.checkuncheckblog').hasClass('checkblog'); 
//	console.log(selected)
	if(selected)
	{
		// grab the IDS OF BLOGS AND REFRESH
		toastr.success("Refreshing All Selected Blogs","Success");
	}
	
	
});

// delete all blog from tracker action
$('.deleteallblogfromtracker').on("click", function(){

	selectedblogelement = $('.edittrackerblogindividual').children('.checkblogleft').children('.checkblog');
	selected  = $('.edittrackerblogindividual').children('.checkblogleft').children('.checkuncheckblog').hasClass('checkblog'); 
	if(selected)
		{
		
		console.log(selectedblogelement);
		var allid = "";
		$(selectedblogelement).each(function(){
			id = $(this).attr('id');
			allid+=id+",";
			console.log(id);
			console.log(this);
			
		});
		// put this block of code in the ajax success request	
		
		//grab all id of blog and perform an ajax request
		$.ajax({
			url: app_url+'tracker',
			method: 'POST',
			data: {
				action:"removeblog",
				blog_ids:allid,
				tracker_id:$("#teeid").val()
			},
			error: function(response)
			{						
				console.log(response);		
			},
			success: function(response)
			{   
				console.log(response);
				if(response.indexOf("success")>-1){					
					selectedblogelement.parent().parent().remove();
					toastr.success("Deleted Selected Blog(s) from tracker","Success");
					numberofblogs = $('.edittrackerblogindividual').length;
					$('#totalblogcount, #selectedblogcount').html(numberofblogs);
					
				}else{
					toastr.error('Blogs could not be removed!','Error');
				}
			}
		});
		
		
		
		}
	else if(!selected)
		{
		toastr.error("Select a Blog to delete","Error");
		}
		
	
});

function replaceElementTag(targetSelector, newTagString) {
	$(targetSelector).each(function(){
		var newElem = $(newTagString, {html: $(this).html()});
		$.each(this.attributes, function() {
			newElem.attr(this.name, this.value);
		});
		$(this).replaceWith(newElem);
	});
}


// end of code section 

$('.trackeredit').on("click", function(){
     
	// start editing section
	startedit = $(this).hasClass('startediting');
	doneedit = $(this).hasClass('doneediting');
	// change the tag 
	if(startedit)
	{
		$(".edittrackertitle").replaceWith($('<input class="edittrackertitle form-control text-primary pt0 pb0 pl0" style="font-size:53px;" value="' + $(".edittrackertitle").html() + '" />'));
		$(".edittrackerdesc").replaceWith($('<textarea class="edittrackerdesc form-control text-primary pl0 pt0 pb0" style="font-size:18px;" >' + $(".edittrackerdesc").html().trim() + '</textarea>'));	
		$(this).removeClass('startediting').addClass('doneediting');
		 $(this).children("i").attr("data-original-title","Done Editing ").addClass("editdone").removeClass("edittracker");
	}
	if(doneedit)
	{
		console.log("doneediting clicked");
		trackertitle = $(".edittrackertitle").val();
		trackerdesc = $(".edittrackerdesc").val();
		$(".edittrackertitle").replaceWith($('<h1 class="text-primary edittrackertitle mb0">' + $(".edittrackertitle").val() + '</h1>'));
		$(".edittrackerdesc").replaceWith($('<p class="edittrackerdesc text-primary" >' + $(".edittrackerdesc").val() + '</p>'));	
		$(this).addClass('startediting').removeClass('doneediting');
		$(this).children("i").attr("data-original-title","Edit Tracker").addClass("edittracker").removeClass("editdone");
		//console.log($("#teeid").val()); return false;
		// add ajax to finish edit
		$.ajax({
			url: app_url+'tracker',
			method: 'POST',
			data: {
				action:"updatedetail",
				name:trackertitle,
				description:trackerdesc,
				tracker_id:$("#teeid").val(),
			},
			error: function(response)
			{						
				console.log(response);		
			},
			success: function(response)
			{   
				console.log(response);
				if(response.indexOf("success")>-1){
					toastr.success("Tracker Updated Successfully","Success");					
				}else{
					toastr.error('Tracker could not be updated!','Error');
				}
			}
		});

	}
	
	 
});

// delete tracker
$('.trackerdelete').click(function(e){
//
var confirmdeletetracker = confirm("Are you sure you want delete tracker?");

if(confirmdeletetracker)
{
	toastr.error("Deleting Tracker","Wait");
	
	$.ajax({
		url: app_url+'tracker',
		method: 'POST',
		data: {
			action:"delete",
			tracker_id:$("#teeid").val(),
		},
		error: function(response)
		{						
			console.log(response);		
		},
		success: function(response)
		{   
			console.log(response);
			if(response.indexOf("success")>-1){
				toastr.success('Tracker successfully deleted!','Success');
				//location.href=app_url+"trackerlist.jsp";
				
				console.log("tracker deleted")	
				// add an ajax to deleted tracker 
				// on success go back to tracker list
				setTimeout(function(){
					location.href = "trackerlist.jsp";	
				}, 2000);
				
			}else{
				toastr.error('Tracker could not be deleted!','Error');
			}
		}
	});
	


}


});


// refresh tracker
//delete tracker
$('.trackerrefresh').click(function(e){
//

toastr.success("Refreshing Tracker","Success");	

console.log("tracker deleted")	

// add an ajax to deleted tracker 
// on success give a notification



});




	
});
