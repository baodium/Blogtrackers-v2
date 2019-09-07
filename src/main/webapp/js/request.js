/* ------------------------------------------------------------------------------
 *
 *  # Login form with validation
 *
 *  Specific JS code additions for login_validation.html page
 *
 *  Version: 1.0
 *  Latest update: Aug 5, 2018
 *
 * ---------------------------------------------------------------------------- */

var baseurl = app_url;

$(function() {


	$('#request_form').submit( function(e) {
		e.preventDefault();
		var email = $("input#username").val();
		var password= $("input#password").val();
		if(email=="" || password=="" ){
			return false;
		}
				
		
		var password = $("#password").val(); 
			$.ajax({
				url: baseurl+'request',   
				method: 'POST',
				dataType: 'json',
				data: {
					email: $("input#username").val(),
					password: $("input#password").val(),
					madeRequest: "yes",
				},
				error: function(response)
				{						
					c("error");
				},
				success: function(response)
				{       
					console.log("in console here");
					console.log(response);
				}
			});
		
		return false;
		
	});
	
});
