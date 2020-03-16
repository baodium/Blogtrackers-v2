
var session_num = localStorage.getItem('sessionkey');
// const api_url = "http://blogtrackers.host.ualr.edu/Blogtrackers";
//const api_url = "http://localhost:8080/Blogtrackers";
const api_url = "http://144.167.35.50:8080/Blogtrackers";

if(session_num == null){
    $('#bt_sf_form_description').removeClass('bt_sf_hiding');
    $('#bt_sf_home_description').addClass('bt_sf_hiding');
}else{
    getTrackers(session_num);
    $('#bt_sf_form_description').addClass('bt_sf_hiding');
    $('#bt_sf_home_description').removeClass('bt_sf_hiding');
}


function logout(){
    localStorage.removeItem('sessionkey');
    $('#bt_sf_form_description').removeClass('bt_sf_hiding');
    $('#bt_sf_home_description').addClass('bt_sf_hiding');
}


$('#bt_sf_logout_button').click(function(){
    logout();
})

function storeExtensionSessionKey(key){
    localStorage.setItem('sessionkey', key);
    
}

function hasher(input) {
    return CryptoJS.MD5(input);
}

$('#bt_sf_login_button').click(function(){
    var email = $('#email').val();
    var passkey = $('#password').val();
    var password = hasher(passkey);



    
    if(email !== '' && passkey !== ''){
    
        var data = null;
        var xhr = new XMLHttpRequest();

        xhr.withCredentials = false;

        console.log(password);
        
        xhr.open("GET", api_url + "/api/login");
        xhr.setRequestHeader("uid", email);
        xhr.setRequestHeader("hash", password);
        xhr.send(data);
        
        xhr.addEventListener("readystatechange", function () {

            if (this.readyState === 4) {
                let resp_text = this.responseText.substring(this.responseText.indexOf("{"));
                let resp = JSON.parse(resp_text);
                storeExtensionSessionKey(resp.key);
                getTrackers(resp.key);
            } else {
                //console.log('error');
            }
        })
        let message = "Incorrect Login Details. Register <a target='_blank' href='http://blogtrackers.host.ualr.edu/Blogtrackers/register.jsp'> here.</a>";
        errorDisplay(message);
        
        
    }else{
        let message = "Please fill all fields";
        errorDisplay(message);
    }
})


function errorDisplay(message){
    
    $('#bt_extension_alert_message').html(message);
    $('#bt_extension_alert_message_box').removeClass('bt_sf_hiding');
}


function getTrackers(session_num) {
    var data = null;
    var xhr = new XMLHttpRequest();
    xhr.withCredentials = false;
    xhr.addEventListener("readystatechange", function () {
        if (this.readyState === 4 && this.status == 200) {
            // Parse the response JSON and store it in resp
            let resp = JSON.parse(this.responseText);
            // Update list with tracker values
            entryBuilder(session_num, resp.trackers);
        }
    });
    xhr.open("GET", api_url + "/api/list?Key=" + session_num);
    xhr.setRequestHeader("session", session_num);
    xhr.setRequestHeader("Cache-Control", "no-cache");
    xhr.setRequestHeader("Postman-Token", "6ee8527d-910c-4cec-879f-809eda40b8e9");
    xhr.send(data);
}


function entryBuilder(session_num, tracker_list) {
    //let results = document.getElementById("tlist");
    //while (results.childNodes.length > 2) {
      //  results.removeChild(results.lastChild);
    //}
    var list_build = '<div class="blog_list_container">';
    
    if(tracker_list.length > 0){
        
        for (let i = 0; i < tracker_list.length; i++) {
           
               //results.appendChild(checkboxBuiler(session_num, tracker_list[i]));
               list_build +='<div id="bt_extension_'+tracker_list[i].id+'" class="bt_sf_card">';
                 list_build +='<div class="bt_sf_card_container">';
                   list_build +='<label class="bt_extension_checkbox">';
                     list_build +='<input class="bt_sf_input_field" name="bt_tracker_selection"  type="checkbox" value="'+tracker_list[i].id+'">';
                     list_build +='<span>';
                     list_build +=''+tracker_list[i].name+'';
               
                    list_build +='</span>';
                    list_build +='</label>';
               list_build +='<i  class="bt_cursor bt_extension_float_right bt_extension_red"><img src="trash-alt-solid.svg" tracker-id="'+tracker_list[i].id+'" tracker-name="'+tracker_list[i].name+'"  class="bt_extension_float_right bt_icon bt_extension_red bt_delete_icon"></i>';
                 list_build +='</div>';
              list_build +=' </div>';
              
           }
        
    }else{
            
        list_build +='<div align="center" class="bt_sf_card bt_empty_tracker_card">';
           list_build +='<div align="center" class="bt_sf_card_container">';
               list_build +='<span>';
               list_build +='NO TRACKER TO DISPLAY';
              list_build +='</span>';
           list_build +='</div>';
        list_build +=' </div>';
        
    }
    
    
   
    
    
    
    
    list_build +=' </div>';
    $('#extension_tracker_list_display').html(list_build);
    $('#bt_sf_form_description').addClass('bt_sf_hiding');
    $('#bt_sf_home_description').removeClass('bt_sf_hiding');
    
    $('#bt_extension_alert_message').html('');
    $('#bt_extension_alert_message_box').addClass('bt_sf_hiding');
}


$( "body" ).delegate( ".bt_sf_alert_closebtn", "click", function() {
    $('#bt_extension_alert_message_box').addClass('bt_sf_hiding');
})

$( "body" ).delegate( ".bt_extension_checkbox", "click", function() {
                
           var selection = [];
           $.each($("input[name='bt_tracker_selection']:checked"), function(){
               selection.push($(this).val());
           });

           if (selection.length > 0) {
            $('#bt_addtotracker').removeClass('bt_sf_hiding')
           }else{
            $('#bt_addtotracker').addClass('bt_sf_hiding')
           }

    
                     
})

$( "body" ).delegate( ".bt_delete_icon", "click", function() {
                    
                     
        if (!confirm("Delete this Tracker?")) {
              return;
          }
                     
        var sessionkey = localStorage.getItem('sessionkey');
                     
                               ////REMOVE FOR TESTING
//        let trackerName = $(this).attr("tracker-name");
//        let trackerId = $(this).attr("tracker-id");
//
//        let temp = {tracker_name: [trackerName]};
//        var data = JSON.stringify(temp);
//        var xhr = new XMLHttpRequest();
//
//        xhr.withCredentials = false;
//        xhr.addEventListener("readystatechange", function () {
//            if (this.readyState === 4) {
//                resp = this.responseText;
//            }
//        });
//        xhr.open("POST", api_url + "/api/delete?Key=" + sessionkey);
//        xhr.setRequestHeader("session", sessionkey);
//        xhr.setRequestHeader("Content-Type", "application/json");
//        xhr.setRequestHeader("Cache-Control", "no-cache");
//        xhr.setRequestHeader("Postman-Token", "eb827cbc-bb10-4a6b-996b-747b74c4e3bc");
//        xhr.send(data);
//        $('#bt_extension_'+trackerId).remove();

    
})

function createTracker(trackerName, session_num) {
    browser.tabs.query({active: true, currentWindow: true}).then(function() {
       
    })
    .catch(reportError);
    return;
}


$( "body" ).delegate( "#add_tracker_bt_extension1", "click", function() {
                     
     if($('#bt_new_tracker_field').hasClass('bt_sf_hiding') ){
     
        $('#bt_new_tracker_field').toggle();
        $('#bt_new_tracker_field').removeClass('bt_sf_hiding');
        $('#add_tracker_bt_extension1').html('Cancel');
        $('#add_tracker_bt_extension1').addClass('bt_sf_bg_red');
     
     }else{
     
        $('#bt_new_tracker_field').toggle();
        $('#bt_new_tracker_field').addClass('bt_sf_hiding');
        $('#add_tracker_bt_extension1').html('Add Tracker');
        $('#add_tracker_bt_extension1').removeClass('bt_sf_bg_red');
     }
                     
})


$( "body" ).delegate( "#add_tracker_bt_extension", "click", function() {
               
    var new_tracker = $('#bt_new_tracker_field').val();
                     
                     
    
    if(new_tracker !== ''){
       var sessionkey = localStorage.getItem('sessionkey');
       let temp = {tracker_name: [trackerName]};
       var data = JSON.stringify(temp);
       var xhr = new XMLHttpRequest();

       xhr.withCredentials = false;
       xhr.addEventListener("readystatechange", function () {
           if (this.readyState === 4) {
               let tracker = {};
               let regexp = /=([0-9]*)/;
               let match = regexp.exec(this.responseText);
               tracker.id = match[1];
               tracker.name = trackerName;
               //let trackers = document.getElementById("tlist");
               //trackers.appendChild(checkboxBuiler(sessionkey, tracker));
                
            list_build ='<div id="bt_extension_'+tracker_list[i].id+'" class="bt_sf_card">';
                   list_build +='<div class="bt_sf_card_container">';
                     list_build +='<label class="bt_extension_checkbox">';
                       list_build +='<input class="bt_sf_input_field" name="bt_tracker_selection"  type="checkbox" value="'+tracker.id+'">';
                       list_build +='<span>';
                       list_build +=''+new_tracker+'';
                 
                      list_build +='</span>';
                      list_build +='</label>';
                 list_build +='<i  class="bt_cursor bt_extension_float_right bt_extension_red"><img src="trash-alt-solid.svg" tracker-id="'+tracker.id+'" tracker-name="'+new_tracker+'"  class="bt_extension_float_right bt_icon bt_extension_red bt_delete_icon"></i>';
                   list_build +='</div>';
                list_build +=' </div>';
            
            $('.bt_empty_tracker_card').empty();
            $('#extension_tracker_list_display').append(list_build);
           }
       });
       xhr.open("POST", api_url + "/api/create?Key=" + sessionkey);
       xhr.setRequestHeader("session", sessionkey);
       xhr.setRequestHeader("Content-Type", "application/json");
       xhr.setRequestHeader("Cache-Control", "no-cache");
       xhr.setRequestHeader("Postman-Token", "eb827cbc-bb10-4a6b-996b-747b74c4e3bc");
       xhr.send(data);
                        
                     }else{
                        alert('empty field');
                     }
               
})


$( "body" ).delegate( "#bt_addtotracker", "click", function() {

          
        var sessionkey = localStorage.getItem('sessionkey');
        var urlll = window.location.href;
                     
       var ti = safari.application.activeBrowserWindow.activeTab.url;
                console.log(ti);
        ////REMOVE FOR TESTING
         var selection = [];
        $.each($("input[name='bt_tracker_selection']:checked"), function(){
            selection.push($(this).val());
        });

        if (selection.length < 1) {
            alert("Please select tracker(s).")
            return;
        }
                                                             
      var urll = $('#track_site_url').val();
//
                    
       
        // Promise querying current tabs and sending request
//        let temp = {id: selection, site: url};
//        var data = JSON.stringify(temp);
//        var xhr = new XMLHttpRequest();
//
//        xhr.withCredentials = false;
//        xhr.addEventListener("readystatechange", function () {
//            if (this.readyState === 4) {
//                resp = this.responseText;
//            }
//        });
//        xhr.open("POST",  api_url + "/api/add?Key=" + sessionkey);
//        xhr.setRequestHeader("session", sessionkey);
//        xhr.setRequestHeader("Content-Type", "application/json");
//        xhr.setRequestHeader("Cache-Control", "no-cache");
//        xhr.setRequestHeader("Postman-Token", "eb827cbc-bb10-4a6b-996b-747b74c4e3bc");
//        xhr.send(data);
//        alert("Site successfully added to tracker(s).");
//        window.close();
                                                                
                

})


