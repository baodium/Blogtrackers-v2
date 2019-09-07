$(document).ready(function(){
	
	 var newtrackersection = '<div class="card noborder curved-card mb30 pt60 pb60 newtrackersection"><div class="card-body"><div class="cursor-pointer"><h4 class="text-primary text-center"><i class="addnewtracker" data-toggle="tooltip" data-placement="top" title="Add New Tracker"></i></h4></div></div></div>';
	  
	 
	// close tracker creation
	$('.closetracker, .canceltracker').click(function(){
		
	$('.token-input').attr("placeholder","Add blog");	
	// delete the element	
	$(this).parent().parent().parent().remove();
	// hide the tooltip
	$(".tooltip").hide();
	// show the notification
	 $.getScript("assets/js/toastr.js", function(data, textStatus, jqxhr) {
		 loadCSS("assets/css/toastr.css");
		 toastr.error("Tracker Creation Canceled","Action Succesful");
	  });
	 
	  $('.card-columns').prepend(newtrackersection);
	    $.getScript("pagedependencies/addnewtracker.js", function(data, textStatus, jqxhr) {	
		  });
	});	
	
//	show the tooltip
	 $(function () {
		    $('[data-toggle="tooltip"]').tooltip()
		  });
	 
	 // create tracker
	 $('.createtracker').on("click",function(){
	 // grab the tracker name
	 var createtrackeraction = $(this);	 
	 trackername = $(this).parent().parent().find(".newtrackername").val();
	 trackerdescription = $(this).parent().parent().find(".newtrackerdescription").val();
     var blogs = $(this).parent().parent().find(".token span");
     var allblogs = [] ;
     // push into an array
    	 blogs.each(function(i,e)
       {
    		 allblogs[i] = $(this).text();
    	    	//console.log(e); 
      });
	
   // making sure the tracker name, description and list of blogger are set
     if(trackername === "")
   {
    // show error notifications	
    $.getScript("assets/js/toastr.js", function(data, textStatus, jqxhr) {
		 loadCSS("assets/css/toastr.css");
		 toastr.error("Enter Tracker Name","Error");
	  });
  
   }
//     making sure tracker description is set
   else if(trackerdescription === "")
   {
	   // show error notifications	
	    $.getScript("assets/js/toastr.js", function(data, textStatus, jqxhr) {
			 loadCSS("assets/css/toastr.css");
			 toastr.error("Enter Tracker Description","Error");
		  });
    }
//   else if(allblogs.length == 0)
//	   {
//	   $.getScript("assets/js/toastr.js", function(data, textStatus, jqxhr) {
//			 loadCSS("assets/css/toastr.css");
//			 toastr.error("Add blogs to track","Error");
//		  });
//	   }
   else
	   {
		
	
	   
	   
	 
	    
	   
	   // create an ajax to create a tracker
	    
	    
	    $.ajax({
	        url: app_url+'tracker',
			method:'POST',
			async: true,
			data:{
				name:trackername,
				description:trackerdescription,
				action:"create"
			},
	        success: function(response)
	        {	
	        console.log(response);
	        if(response!="error creating tracker" && response!="tracker already exist"){
	        	var prev= parseInt($("#tracker-total").html());
    			prev++;
    			$("#tracker-total").html(prev);
    			   $(".tooltip").hide();
    			    // variable needed are trackername, trackerdescription and (allblogs) which contains arrays of blogs
    			   
    			   trackernamehtmlupdate = '<div class="text-center mt10 stylebutton6 text-primary m20 mt0 mb0 cursor-pointer"><a href="'+app_url+'edittracker.jsp?tid='+response+'"><h1 class="text-primary text-center pt10 p20 pb10 cursor-pointer bold-text activelink"	data-toggle="tooltip" data-placement="top" title="Proceed to tracker details">'+trackername+'</h1></a></div>';
    			   var today = new Date();
    			   var dd = today.getDate();
    			   var mm = today.getMonth()+1; //January is 0!
    			   var yyyy = today.getFullYear();

    			   if(dd<10) {
    			       dd = '0'+dd
    			   } 

    			   if(mm<10) {
    			       mm = '0'+mm
    			   } 
    			   mydate = mm + '-' + dd + '-' + yyyy;
    			   
    			   // current date
    			   currentdate = mydate;
    			  
    			   // current time
    			   currenttime = today.getHours() + ":" + today.getMinutes(); 
    			   // joined blog
    			   allblogcombined = allblogs.join(", ");
    			   timesectionhtmlupdate = '<p class="card-text text-center postdate text-primary">'+currentdate+" , "+currenttime+'</p>';	 
    			   //bloglisthtmlupdate = '<div class="text-center"><button class="btn btn-default stylebutton5 text-primary p30 pt5 pb5" style="width:100%;">'+allblogcombined+'</button></div>';
    			   trackerdescriptionhtmlupdate = ' <p class="mt20 text-primary text-center">'+trackerdescription+'</p>';
    			   blogcounthtmlupdate = '<div class="text-center mt20"><!--<button class="btn btn-default stylebutton6 text-primary p30 pt5 pb5 text-left" style="width:100%;">--><h1 class="text-success mb0">0</h1><h5 class="text-primary">Blogs</h5><!--</button>--></div>';
    			   postcounthtmlupdate = '<div class="text-center mt10"><!--<button class="btn btn-default stylebutton6 text-primary p30 pt5 pb5 text-left" style="width:100%;">--><h1 class="text-success mb0">0</h1><h5 class="text-primary">Posts</h5><!--</button>--></div>';
    			   commentcounthtmlupdate = '<!--<div class="text-center mt10"><button class="btn btn-default stylebutton6 text-primary p30 pt5 pb5 text-left" style="width:100%;"><h1 class="text-success mb0">0</h1><h5 class="text-primary">Comments</h5></button></div>-->';
    			   buttonhtmlupdate = '<div class="pt30 pb20 text-center"><a href="'+app_url+'dashboard.jsp?tid='+response+'"><i class="text-primary icontrackersize cursor-pointer proceedtoanalytics" data-toggle="tooltip" data-placement="top" title="Proceed to Analytics"></i></a><i class=" text-primary icontrackersize cursor-pointer refreshdeactivated" data-toggle="tooltip" data-placement="top" data-action="reload" title="Refresh Tracker"></i><i class=" text-primary icontrackersize cursor-pointer deletetracker" data-toggle="tooltip" data-placement="top" id="'+response+'" title="Delete Tracker"></i><input type="hidden" name="tid" value="'+response+'" class="tid" /></div>';
    			   createtrackeraction.parent().parent().parent().prepend(trackernamehtmlupdate);
    			   createtrackeraction.parent().parent().html(
    					  // bloglisthtmlupdate + trackerdescriptionhtmlupdate + blogcounthtmlupdate + postcounthtmlupdate + commentcounthtmlupdate + buttonhtmlupdate
    					   trackerdescriptionhtmlupdate + blogcounthtmlupdate + postcounthtmlupdate + commentcounthtmlupdate + buttonhtmlupdate
    					      
    			   );
    			   
    			  
    			   
    			   // get script to refresh tracker
    			   $.getScript("pagedependencies/refreshtracker.js", function(data, textStatus, jqxhr) {
    				  
    				  });
    			   
    			   // get script for tooltip
    			   $.getScript("pagedependencies/tooltip.js", function(data, textStatus, jqxhr) {
     				  
 				  });
    			   // get script to delete tracker
    			   $.getScript("pagedependencies/deletetracker.js", function(data, textStatus, jqxhr) {
    				  
    				  });
    			   
    			   // section that shows add new tracker icon after success success after succes
    			   $('.card-columns').prepend(newtrackersection);
    			    $.getScript("pagedependencies/addnewtracker.js", function(data, textStatus, jqxhr) {
    					
    				  });
    			    
    			    $.getScript("assets/js/toastr.js", function(data, textStatus, jqxhr) {
	        			 loadCSS("assets/css/toastr.css");
	        			 toastr.success("Tracker created","Success");
	        			 
	        			 setTimeout(function(){
	     					location.href = "trackerlist.jsp";	
	     				}, 2000);
	        			 
	        		  });
    			    
	        }else{
       		 $.getScript("assets/js/toastr.js", function(data, textStatus, jqxhr) {
    			 loadCSS("assets/css/toastr.css");
    			 toastr.error(response,"Error");
    		  });
	        }
	        	
	        	
	        }
			
	    });
	    
	
	   } // end of else 
	 
	 
	 
		 
	 });
	
	 
	 loadCSS = function(href) {

		  var cssLink = $("<link>");
		  $("head").append(cssLink); //IE hack: append before setting href

		  cssLink.attr({
		    rel:  "stylesheet",
		    type: "text/css",
		    href: href
		  });

		};
});