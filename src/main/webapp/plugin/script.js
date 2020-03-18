document.addEventListener("DOMContentLoaded", function(event) {
    safari.extension.dispatchMessage("Hello World!");
});

safari.self.addEventListener("message", handleMessage);


function buildBlogTrackerExtensionView(){
    
    var track_site_url = window.location.href;
    var fileo = safari.extension.baseURI + "file.html";
    
    div = document.createElement('svg');
    div.setAttribute("id", "blogtackers_extension");
    div.setAttribute("class", "blogtackers_extension hidden_blogtrackers_extension");
    div.setAttribute("align", "center");
    
    input = document.createElement('input');
    input.setAttribute("type","hidden");
    input.setAttribute("value",track_site_url);
    input.setAttribute("id","track_site_url");
    input.setAttribute("readonly","");
   

    
    document.body.appendChild(div);
    //
    var iframe = document.createElement('iframe');
    iframe.setAttribute("id", "blogtackers_extension_frame");
    iframe.setAttribute("track_site_url", track_site_url);
    iframe.setAttribute("align", "center");
    iframe.style.display = "";
    iframe.src = fileo;
    
    

    document.getElementById("blogtackers_extension").appendChild(iframe);
    document.getElementById("blogtackers_extension_frame").appendChild(input);
}

//buildBlogTrackerExtensionView();



document.addEventListener("DOMContentLoaded", function(){
  // Handler when the DOM is fully loaded
    buildBlogTrackerExtensionView();
                          
   // buildExtensionTrackerList();
});










function handleMessage(event) {
    
    var element = document.getElementById("blogtackers_extension");
    if(element.classList.contains("hidden_blogtrackers_extension")){
        //buildExtensionTrackerList();
        element.classList.remove("hidden_blogtrackers_extension");
    }else{
        element.classList.add("hidden_blogtrackers_extension");
    }
    
    
}

window.onclick = function(event) {
    
    var element = document.getElementById("blogtackers_extension");
    if(element.classList.contains("hidden_blogtrackers_extension")){
        
    }else{
        element.classList.add("hidden_blogtrackers_extension");
    }
}


