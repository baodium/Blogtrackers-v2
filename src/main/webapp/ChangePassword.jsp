<%@page import="authentication.*"%>
<%
	/* Object email = (null == session.getAttribute("email")) ? "" : session.getAttribute("email"); */
	/* System.out.println("Email is " + email); */
	/* 	if (email != null && email != "") {
			response.sendRedirect("dashboard.jsp");
		} */

 Object email = request.getAttribute("email"); 
	System.out.println("Email is " + email);
%>

<!DOCTYPE html>
<html>

<head>
    <script src="https://apis.google.com/js/platform.js" async defer></script>
    <meta name="google-signin-client_id"
        content="600561618290-lmbuo5mamod25msuth4tutqvkbn91d6v.apps.googleusercontent.com" />

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>CHANGE PASSWORD</title>
    <link rel="shortcut icon" href="images/favicons/favicon-48x48.png">
    <link rel="apple-touch-icon" href="images/favicons/favicon-48x48.png">
    <link rel="apple-touch-icon" sizes="96x96" href="images/favicons/favicon-96x96.png">
    <link rel="apple-touch-icon" sizes="144x144" href="images/favicons/favicon-144x144.png">
    <!-- start of bootsrap -->
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:600,700" rel="stylesheet">
    <link rel="stylesheet" href="assets/bootstrap/css/bootstrap-grid.css" />
    <link rel="stylesheet" href="assets/bootstrap/css/bootstrap.css" />
    <link rel="stylesheet" href="assets/fonts/fontawesome/css/fontawesome-all.css" />
    <link rel="stylesheet" href="assets/fonts/iconic/css/open-iconic.css" />
    <link rel="stylesheet" href="assets/vendors/bootstrap-daterangepicker/daterangepicker.css" />
    <link rel="stylesheet" href="assets/css/table.css" />
    <link rel="stylesheet" href="assets/vendors/DataTables/dataTables.bootstrap4.min.css" />
    <link rel="stylesheet" href="assets/vendors/DataTables/Buttons-1.5.1/css/buttons.dataTables.min.css" />
    <link rel="stylesheet" href="assets/css/daterangepicker.css" />

    <link rel="stylesheet" href="assets/css/style.css" />

    <link rel="stylesheet" href="assets/css/toastr.css">
    <!--end of bootsrap -->
    <script src="assets/js/jquery.min.js"></script>
    <script src="assets/js/popper.min.js"></script>

    <!-- JavaScript to be reviewed thouroughly by me -->
    <script type="text/javascript" src="assets/js/validate.min.js"></script>
    <script type="text/javascript" src="assets/js/uniform.min.js"></script>

    <script type="text/javascript" src="assets/js/toastr.js"></script>

    <!-- Base URL  -->
    <script src="pagedependencies/baseurl.js?v=908">

    </script>
    <script src="js/jscookie.js"></script>
    <script src="https://apis.google.com/js/platform.js"></script>

    <script type="text/javascript" src="js/login_validation.js?v=907"></script>
    <script src="pagedependencies/googletagmanagerscript.js"></script>
    
</head>

<body class="bgwhite">
    <%@include file="subpages/loader.jsp"%>
    <%@include file="subpages/googletagmanagernoscript.jsp"%>
    <nav class="navbar navbar-inverse bg-primary d-md-block d-sm-block d-xs-block d-lg-none d-xl-none">
        <div class="container-fluid">

            <div class="navbar-header col-md-12 text-center">
                <a class="navbar-brand text-center logohome" href="<%=request.getContextPath()%>/forgotpassword">
                    <!-- <img src="images/blogtrackers.png" /> -->
                </a>
            </div>
        </div>
    </nav>

    <div class="loginbox">
        <div class="row d-flex align-items-stretch">
            <div class="col-md-7 card m0 p0 borderradiusround nobordertopright noborderbottomright noborder">
                <div class="card-body p40 pt40 pb5 borderradiusround nobordertopright noborderbottomright"
                    style="background-color: #F3F4F5;">
                    <p class="text-primary mb50 mt20" style="font-size: 22px;">
                        <b>CHANGE PASSWORD</b>
                    </p>
                    <form id="" action="<%=request.getContextPath()%>/forgotpassword" class="" method="post">
                        <div class="form-login-error">
                            <p id="error_message-box" style="color:red"></p>
                        </div>
                        <div class="form-group hidden">
                            <div class="form-login-error">
                                <p id="error_message-box" style="color: red"></p>
                            </div>
                            <b>Email</b> <input type="email" class="form-control curved-form-login text-primary"
                                id="email" autocomplete="off" required="required" required
                                aria-describedby="emailHelp" placeholder="Email" name = "email">
                            <!--  <small id="emailHelp" class="form-text text-muted">We'll never share your email with anyone else.</small> -->
                        </div>
                        <br />

                        <div class="form-group">
                            <b>ENTER TEMPORARY PASSWORD</b> <input type="password" value=""
                                class="form-control curved-form-login text-primary" required="required"
                                autocomplete="off" required="required" id="password" name = placeholder="Password">
                            <div class="invalid-feedback">Please enter temporary password sent to email</div>
                            <!-- <input type="password" id="password2" required="required"
                                class="form-control curved-form-login text-primary" placeholder="Re-type Password"> -->
                            <br /> <b>NEW PASSWORD</b> <input type="password"
                                class="form-control curved-form-login text-primary" required="required"
                                autocomplete="off" pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}" title="Must contain at least one number and one uppercase and lowercase letter, and at least 8 or more characters" required id="newpassword" placeholder="Password">
                            <div class="invalid-feedback">Please enter your new
                                password</div>
                            <br /> <b>CONFIRM PASSWORD</b> <input type="password"
                                class="form-control curved-form-login text-primary" required="required"
                                autocomplete="off" required="required" id="confirmpassword" placeholder="Password">
                            <div class="invalid-feedback">Please confirm your new
                                password</div>
                            <!-- <div class="mb0 pb10">
							<label class="text-center text-primary mb0 labelprofile">Old
								Password: &nbsp;</label><input
								class="mt0 mb0 text-primary inputnobg inputprofile passinput"
								type="password" id="password" readonly value="" />
						</div>
						<div class="mb0 pb10">
							<label class="text-center text-primary mb0 labelprofile"
								name="Password">New Password: &nbsp;</label><input
								class="mt0 mb0 text-primary inputnobg inputprofile passinput"
								type="password" id="newpassword" readonly value="" />
						</div>
						<div class="mb0 pb10">
							<label class="text-center text-primary mb0 labelprofile">Confirm
								Password: &nbsp;</label><input
								class="mt0 mb0 text-primary inputnobg inputprofile passinput"
								type="password" id="confirmpassword" readonly value="" />
						</div> -->
                            <!--	<div class="valid-feedback">Looks Good</div> -->
                        </div>
                        <br />
                        <div class="" id="loggin2"></div>
                        <div>
                            <!-- 							<p class="float-left pt10">
								<input id="remember_me" type="checkbox"
									class="remembercheckbox blue" /><span></span>Remember Me
							</p> -->
                            <%-- 							<p class="pt10 text-primary float-right">
								<small class="bold-text"><a
									href="<%=request.getContextPath()%>/forgotpassword.jsp">Forgot
                            your password?</a></small>
                            </p> --%>

                        </div>
                        <div class="clearfloat mb50" >
                            <button type="submit" id="changingpassword" name="changepword" value="yes"
                                class="btn btn-primary loginformbutton mt10 bold-text"
                                style="background: #28a745;">Update Password</button>
                            <!-- &nbsp;&nbsp;or Login with &nbsp;&nbsp;
							<button type="button" class="btn btn-rounded big-btn2 " id="glogin" >
								<i class="fab fa-google icon-small text-primary" ></i>
							</button><span></span> -->

                            <!-- <i class="float-left googleicon pl0 pr10"></i>  -->
                            <!-- 
							<button type="button" id="glogin" class="btn buttonportfolio3 mt10 pt10 pb10 pl40">
							
							
							<b class="float-left bold-text">Sign in with Google </b>
							</button>
							-->
                        </div>
                        <div id="message" class="">
  <h3>Password must contain the following:</h3>
  <p id="letter" class="invalid">A <b>lowercase</b> letter</p>
  <p id="capital" class="invalid">A <b>capital (uppercase)</b> letter</p>
  <p id="number" class="invalid">A <b>number</b></p>
  <p id="length" class="invalid">Minimum <b>8 characters</b></p>
</div>

                        <%-- 						<p class="pb40 mt30 text-primary">
							Don't have an account with Blogtrackers? <a
								href="<%=request.getContextPath()%>/register"><b>Register
                            Now</b></a></small>
                        </p> --%>
                    </form>

                </div>

            </div>
            <div
                class="col-md-5 card m0 p0 bg-primary borderradiusround nobordertopleft noborderbottomleft othersection noborder">
                <div
                    class="card-body borderradiusround nobordertopleft noborderbottomleft p10 pt20 pb5 robotcontainer3 text-center">
                    <a class="navbar-brand text-center logohome" href="<%=request.getContextPath()%>/forgotpassword"> </a>
                </div>
            </div>

        </div>
    </div>
    <script>
    $(document).ready(function () {
    	
    	
    	var myInput = document.getElementById("newpassword");
    	var letter = document.getElementById("letter");
    	var capital = document.getElementById("capital");
    	var number = document.getElementById("number");
    	var length = document.getElementById("length");

    	// When the user clicks on the password field, show the message box
    	myInput.onfocus = function() {
    	  document.getElementById("message").style.display = "block";
    	}

    	// When the user clicks outside of the password field, hide the message box
    	myInput.onblur = function() {
    	  document.getElementById("message").style.display = "none";
    	}

    	// When the user starts to type something inside the password field
    	myInput.onkeyup = function() {
    	  // Validate lowercase letters
    	  var lowerCaseLetters = /[a-z]/g;
    	  if(myInput.value.match(lowerCaseLetters)) {  
    	    letter.classList.remove("invalid");
    	    letter.classList.add("valid");
    	  } else {
    	    letter.classList.remove("valid");
    	    letter.classList.add("invalid");
    	  }
    	  
    	  // Validate capital letters
    	  var upperCaseLetters = /[A-Z]/g;
    	  if(myInput.value.match(upperCaseLetters)) {  
    	    capital.classList.remove("invalid");
    	    capital.classList.add("valid");
    	  } else {
    	    capital.classList.remove("valid");
    	    capital.classList.add("invalid");
    	  }

    	  // Validate numbers
    	  var numbers = /[0-9]/g;
    	  if(myInput.value.match(numbers)) {  
    	    number.classList.remove("invalid");
    	    number.classList.add("valid");
    	  } else {
    	    number.classList.remove("valid");
    	    number.classList.add("invalid");
    	  }
    	  
    	  // Validate length
    	  if(myInput.value.length >= 8) {
    	    length.classList.remove("invalid");
    	    length.classList.add("valid");
    	  } else {
    	    length.classList.remove("valid");
    	    length.classList.add("invalid");
    	  }
    	}
    	
    	
    	
    	
    	
        $('#changingpassword').click(function (e) {
            e.preventDefault();
            valueintext = $('#changingpassword').html()
            email = "<%=email%>"
            oldpassword = $('#password').val();
            newpassword = $('#newpassword').val();
            confirmpassword = $('#confirmpassword').val();
            
			length = document.getElementById("length").className;
			letter = document.getElementById("letter").className;
			capital = document.getElementById("capital").className;
			number = document.getElementById("number").className;
            
            /* console.log("vl--"+valueintext);
            console.log("EMAIL--"+email);
            console.log("password--"+oldpassword);
            console.log("newpassword--"+newpassword);
            console.log("confirmpassword--"+confirmpassword);
            
            console.log("lengthclass--"+length); */
            
            
            
            if (valueintext === "Update Password" && letter != "invalid" && number != "invalid" && capital != "invalid" && length != "invalid"){
            	if (oldpassword !== ""
                    && oldpassword !== newpassword
                    && newpassword === confirmpassword) {

                    changedpassword = newpassword;
                }

                if (oldpassword !== newpassword
                    && newpassword !== confirmpassword) {
                    toastr.error(
                            'Your password did not match!',
                            'Invalid');
                    return false;
                } 
                else {
                    // console.log(name);
                    $
                        .ajax({
                            url:  'forgotpassword',
                            method: 'POST',
                            data: {
                                email: email,
                                password: newpassword,
                                oldpassword: oldpassword,
                                action: "update_password",
                            },
                            error: function (
                                response) {
                                console.log("THIS IS RESPONSE FOR ERROR"+response);
                            },
                            success: function (response) {
                                console.log("RESPONSE FOR SUCCESS--"+response);
                                var statuss = response;// .responseText;
                                // console.log(login_status);
                                //alert(statuss)
                                if (statuss === "success") {
                                    toastr.success(
                                            'Profile successfully updated!',
                                            'Success');
                                    /* toastr.options.onclick = function() { console.log('clicked'); } */
                                    var successUrl = "login.jsp"; // might be a good idea to return this URL in the successful AJAX call
    								window.location.href = successUrl;
                                    <% 
                                    Object passwordupdated = (null == session.getAttribute("passwordupdated")) ? "" : session.getAttribute("passwordupdated");
                                    if(!passwordupdated.equals("")){  
                                    	session.setAttribute("email", email);
                                    }
                                    
                                    %>
                                    return false;
                        		} else {
                                    toastr.error('Temporary password is not valid! Please check email for new one', 'Invalid');
                                    return false;
                                }

                            }
                        });

                }
            }else {
            	$("#error_message-box").html('Password does not meet the requirement');
               /*  toastr.error('Password does not meet the requirement', 'Invalid'); */
                return false;
            }
            /* 
            valueintext = $('#editaccount').html()
										fullname = $('#fullname');
										email = $('#email');
										phone = $('#phone');
            if (valueintext === "Edit Account") {
                $('#editaccount').html(
                    "Update Account");

                fullname.removeAttr("readonly")
                    .focus();
                email.removeAttr("readonly");
                phone.removeAttr("readonly");
                $('.profileinput').css("border",
                    "1px solid #dedede");

            } else if (valueintext === "Update Account") {
                $('#editaccount').html(
                    "Edit Account");
                fullname.attr("readonly", true);
                email.attr("readonly", true);
                phone.attr("readonly", true);
                $('.profileinput').css("border",
                    "none");
                $('.passwordsection').hide();

                oldpassword = $('#password').val();
                newpassword = $('#newpassword')
                    .val();
                confirmpassword = $(
                    '#confirmpassword').val()

                // storevalue of data
                fullnameval = $('#fullname').val();
                emailval = $('#email').val();
                phoneval = $('#phone').val();

                file = $("#customFileLang").val();
                console.log(file);

                if (oldpassword !== ""
                    && oldpassword !== newpassword
                    && newpassword === confirmpassword) {

                    changedpassword = newpassword;
                }

                if (oldpassword !== newpassword
                    && newpassword !== confirmpassword) {
                    toastr
                        .error(
                            'Your password did not match!',
                            'Invalid');
                    return false;
                } else {
                    // console.log(name);
                    $
                        .ajax({
                            url: baseurl
                                + 'register',
                            method: 'POST',
                            data: {
                                name: fullnameval,
                                email: emailval,
                                phone: phoneval,
                                password: newpassword,
                                oldpassword: oldpassword,
                                action: "update_profile",
                            },
                            error: function (
                                response) {
                                console
                                    .log(response);
                            },
                            success: function (
                                response) {
                                console
                                    .log(response);
                                var statuss = response;// .responseText;
                                // console.log(login_status);
                                if (statuss === "success") {
                                    toastr
                                        .success(
                                            'Profile successfully updated!',
                                            'Success');

                                    $('.myname').html(fullnameval);
                                    $('.myemail').html(emailval);
                                    if (file != "") {
                                        $("#image-form").submit();
                                    }
                                    return false;
                                } else {
                                    toastr.error('Old password is not valid!', 'Invalid');
                                    return false;
                                }

                            }
                        });

                }

            } */

        })

    });

    //startApp();
</script>
</body>

</html>