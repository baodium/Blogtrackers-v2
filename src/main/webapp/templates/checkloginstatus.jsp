<% Object emailcheck = (null == session.getAttribute("email")) ? "" : session.getAttribute("email"); 
Object passwordupdated = (null == session.getAttribute("passwordupdated")) ? "" : session.getAttribute("passwordupdated");

System.out.println("CHECKING--" + request.getHeader("referer"));
System.out.println("eMAIL_CHECKING--" + emailcheck);
System.out.println("UPDATED_CHECKING--" + passwordupdated);
%> 

<script>
<% if(emailcheck.toString().equalsIgnoreCase(null) || emailcheck.toString().equalsIgnoreCase(""))
	{ %>
	Cookies.set('loggedinstatus', false , {path : '/'});
	<%} else {%>
	Cookies.set('loggedinstatus', true , {path : '/'});	
	<%}%>
	Cookies.set('allfavoritesblogs', "" , {path : '/'});
	//console.log(Cookies.get('loggedinstatus'))
</script>