$('.addnewtracker').on("click",function(e){
	    e.preventDefault();
	    $('.newtrackersection').remove();
	    $('.tooltip').hide();
	    var  trackersetupform = "";
	    trackersetupform += '<div class="card noborder curved-card mb30 pt20 pb20"><div class="card-body"><div class="trackerclose"><i class="lnr lnr-cross closetracker text-primary cursor-pointer" data-toggle="tooltip" data-placement="top" title="Cancel New Tracker"></i></div><div class="cursor-pointer mt20"><textarea class="form-control newtrackername text-primary text-center" placeholder="Tracker Name" rows="2"></textarea></div><div class="cursor-pointer mt20"><textarea class="form-control newtrackerdescription text-primary text-center" placeholder="Description" rows="1"></textarea></div>';
	    //trackersetupform += '<div class="form-group mt20 trackerpage"><label class="text-primary">Add Blog</label><input type="text" class="form-control tokenfield-primary" value="" placeholder="Add Blog" /></div><div class="text-center"><i type="submit" class="fas fa-check text-success createtracker mr20 cursor-pointer" data-toggle="tooltip" data-placement="top" title="Create Tracker"></i> <i class="fas fa-trash-alt text-primary canceltracker cursor-pointer" data-toggle="tooltip" data-placement="top" title="Delete Tracker"></i></div></div></div>';
//trackersetupform += '<div class="text-center mt30"><i type="submit" class="text-success createtracker mr20 cursor-pointer" data-toggle="tooltip" data-placement="top" title="Create Tracker"></i> <i class="text-primary canceltracker cursor-pointer" data-toggle="tooltip" data-placement="top" title="Delete Tracker"></i></div></div></div>';

trackersetupform += '<div class="text-center mt30"><i type="submit" class="text-success createtracker cursor-pointer" data-toggle="tooltip" data-placement="top" title="Create Tracker"></i> </div></div></div>';
	  
	    $('.card-columns').prepend(trackersetupform);
	  
	  // load the script for form tag input
	  $.getScript("assets/js/form_tags_input.js", function(data, textStatus, jqxhr) {
		 /*  console.log(data); //data returned
		  console.log(textStatus); //success
		  console.log(jqxhr.status); //200
		  console.log('Load was performed.'); */
		  });
	  
	  // create a tracker script
	  $.getScript("pagedependencies/createtracker.js", function(data, textStatus, jqxhr) {
			
			  });
	  
	  });