var baseurl = app_url;
var requests = new Array();
var z=0;

$(document).ready(function() {

    //$('.postimage').on('load', function(img){ // image ready
    var img = $('.post-image');
    for(i=0; i<img.length; i++){
    	var id = img[i].id;
		var url = img[i].value;
		//console.log(id);
		//scrapeImage(id, "https://www.oodaloop.com/");
		getImage(id,url);
		//console.log(url);
				
    }
  
});


function getImage(image_id,url){
	//console.log("hello Here");
	var urll=baseurl+'subpages/imageloader.jsp?url='+url;
		z++;
		requests[z] = $.ajax({ type: "GET",
		url:urll,
		async: true,
		success : function(data)
		{
			//console.log("data:"+data);
			var meta = data.split('meta property="og:image"');//$(data).find("meta");//.attr("content");
			var meta2 = data.split('twitter:image:src');
			//var meta2 = $(data).find("twitter:image:src");//.attr("content");
			
			//console.log(meta2);
			if(meta.length>1){
				var det = meta[1].split(">");
				det = det[0].replace("content=","");
				//det = det.replace('>',"");
				det = det.replace('"',"");
				//console.log(det);
				if(det!="https://s0.wp.com/i/blank.jpg" ){						
					$("."+image_id).html('<img class="card-img-top pt30 pb30" src="'+det+'"  />');
					$("#"+image_id).remove();
					return false;
				}
			}else if(meta2.length>1){
				var det2 = meta2[1].split(">");
				det2 = det2[0].replace("content=","");
				//det2 = det2.replace('>',"");
				det2 = det2.replace('"',"");
				//console.log(det2);
				
				if(det2!="https://s0.wp.com/i/blank.jpg" ){						
					$("."+image_id).html('<img class="card-img-top pt30 pb30" src="'+det2+'"  />');
					$("#"+image_id).remove();
					return false;
				}
			}else{			
				$("#"+image_id).remove();
				return false;
			}
			
			/*
			for(i=0; i<meta.length; i++){
				console.log("Meta here:"+meta[i]);
				/*
				if(meta[i].name=="twitter:image" &&  meta[i].content!="https://s0.wp.com/i/blank.jpg"){
					console.log(meta[i].content);
					$("."+image_id).html('<img class="card-img-top pt30 pb30" src="'+meta[i].content+'"  />');
					$("#"+image_id).remove();
					return false;
				}else{
				
				var html = meta[i].outerHTML;
					var og = html.indexOf('property="og:image"');
					console.log(og);
					if(og>-1){
						var con = html.split("content=");
						var content =  con[1].split('"');	
						console.log(content[1]);
						if(con.length>1 && content[1]!="https://s0.wp.com/i/blank.jpg" ){
							
							
							content =  con[1].split('"');						
							$("."+image_id).html('<img class="card-img-top pt30 pb30" src="'+content[1]+'"  />');
							$("#"+image_id).remove();
							return false;
						}
					}else{
						console.log("got here");
						var nurl = extractRootDomain(url);
						var pre = "";
						if(url.indexOf("https")>-1){
							pre = "https://";
						}else{
							pre = "http://";
						}
						
						if(url.indexOf("www")>-1){
							pre += "www.";
						}else{
							pre += "";
						}
						
						
						nurl = pre+""+nurl;
						console.log(nurl);
						//scrapeImage(image_id, nurl);
					}
				}
				
			}
		*/
		
		}
	});

	return false;
}

function scrapeImage(image_id, url){	
		
	z++;
	var urll=baseurl+'subpages/imageloader.jsp?url='+url;
		requests[z] = $.ajax({ type: "GET",
		url:urll,
		async: true,
		success : function(data)
		{
			
			var meta = $(data).find('meta');//.attr("content");
			for(i=0; i<meta.length; i++){
				if(meta[i].name=="twitter:image" &&  meta[i].content!="https://s0.wp.com/i/blank.jpg"){
					$("#"+image_id).attr('src',meta[i].content);
					return false;
				}else{
				
				var html = meta[i].outerHTML;
					var og = html.indexOf('property="og:image"');
					if(og>-1){
						var con = html.split("content=");
						var content =  con[1].split('"');
						if(con.length>1 && content[1]!="https://s0.wp.com/i/blank.jpg"){
													
							$("."+image_id).html('<img class="card-img-top pt30 pb30" src="'+content[1]+'"  />');
							$("#"+image_id).remove();
							return false;
						}
					}
				}
			}
			//$("#"+image_id).remove();
		}
	});
	
	return false;		
}


function extractHostname(url) {
    var hostname;
    //find & remove protocol (http, ftp, etc.) and get hostname

    if (url.indexOf("://") > -1) {
        hostname = url.split('/')[2];
    }
    else {
        hostname = url.split('/')[0];
    }

    //find & remove port number
    hostname = hostname.split(':')[0];
    //find & remove "?"
    hostname = hostname.split('?')[0];

    return hostname;
}

//To address those who want the "root domain," use this function:
function extractRootDomain(url) {
    var domain = extractHostname(url),
        splitArr = domain.split('.'),
        arrLen = splitArr.length;

    //extracting the root domain here
    //if there is a subdomain 
    if (arrLen > 2) {
        domain = splitArr[arrLen - 2] + '.' + splitArr[arrLen - 1];
        //check to see if it's using a Country Code Top Level Domain (ccTLD) (i.e. ".me.uk")
        if (splitArr[arrLen - 2].length == 2 && splitArr[arrLen - 1].length == 2) {
            //this is using a ccTLD
            domain = splitArr[arrLen - 3] + '.' + domain;
        }
    }
    return domain;
}

