$(document).ready(function(e)
{
	$(function () {
	    $('[data-toggle="tooltip"]').tooltip()
	  })	
  $(".profiletoggle").click(function(e){
  e.preventDefault();
  $(".modal-notifications").css( { transition: "transform 0.80s",
                  transform:  "translate(0px,0px)"} );

  }) ;
	
	 $("#profiletoggle").click(function(e){
		  e.preventDefault();
		  $(".modal-notifications").css( { transition: "transform 0.80s",
		                  transform:  "translate(0px,0px)"} );

		  }) ;

  $("#closeicon, .closesection").click(function(e){
  e.preventDefault();
  $(".modal-notifications").css( { transition: "transform 0.80s",
                  transform:  "translate(8000px,0px)"} );

  }) ;
});
