//console.log("Window is loading ");

$(window).load(function(){		
})


$(document).ready(function(e)
{
	$("body").removeClass("loaded");

$('a').each(function(index,element){
// check each click	
var eachel =$(this)	
$(eachel).on("click", function(e){
console.log($(this).hasClass("blogger-select"));

if($(this).hasClass("dropdown-toggle") 
 || $(this).hasClass("blogger-select") || 
 $(this).hasClass("blogpost_link") ||
 $(this).hasClass("select-term") || $(this).hasClass("page-link") ||
 $(this).hasClass("carousel-control-prev") || $(this).hasClass("carousel-control-next"))
{
$("body").addClass('loaded');
//console.log($(this).hasClass("blogger_select"));
}
else if($(this).attr("target") === "_blank")
{
console.log("I hit here here2")	
$("body").addClass('loaded');	
}
else
{
console.log("I hit here here3")	
$("body").removeClass("loaded")	
}
});	
})	
	
/*$('a').on("click",function(e){
console.log("here 1")		
if(!$(this).hasClass("dropdown-toggle") && !$(this).hasClass("blogpost_select"))
{
$("body").removeClass('loaded');
console.log($(this).hasClass("blogpost_link"));
}
//else if($(this).hasClass("blogpost_link"))
//	{
//	console.log("blog post link found")
//	$("body").addClass("loaded");
//	}

});*/
	 
$("body").addClass("loaded");
	
	
$(function () {
$('[data-toggle="tooltip"]').tooltip()
  })	
  $(".profiletoggle").click(function(e){
  e.preventDefault();
  $(".modal-notifications").css( { transition: "transform 0.80s",
                  transform:  "translate(0px,0px)"} );

  });
	
	
	
	 $("#profiletoggle").click(function(e){
		  e.preventDefault();
		  $("body").addClass("loaded");
		  $(".modal-notifications").css( { transition: "transform 0.80s",
		                  transform:  "translate(0px,0px)"} );

		  }) ;

  $("#closeicon, .closesection").click(function(e){
  e.preventDefault();
  $(".modal-notifications").css( { transition: "transform 0.80s",
                  transform:  "translate(8000px,0px)"} );

  }) ;
});
