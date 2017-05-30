<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<head>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css">
  <link rel="stylesheet" href="/css/fbtweetapp.css">
</head>
<body>
 <script type="text/javascript">
 var first_name;
 var last_name;
 var picture;

 function callme(){
 window.fbAsyncInit = function() {
     FB.init({
       appId      : '700283830178680',
       cookie     : true,
       xfbml      : true,
       version    : 'v2.9'
     });
     FB.AppEvents.logPageView(); 
     loadsdk();
     checkLoginState();
 };
 }


 function onLogin(response) {
 	  if (response.status == 'connected') {
 	    FB.api('/me?fields=first_name', function(data) {
 	      var welcomeBlock = document.getElementById('fb-welcome');
 	      welcomeBlock.innerHTML = 'Hello, ' + data.first_name + '!';
 	      
 	    });
 	  }
 };

 	
 function loadsdk(){
 (function(d, s, id){
     var js, fjs = d.getElementsByTagName(s)[0];
     if (d.getElementById(id)) {return;}
     js = d.createElement(s); js.id = id;
     js.src = "//connect.facebook.net/en_US/sdk.js";
     fjs.parentNode.insertBefore(js, fjs);
     }(document, 'script', 'facebook-jssdk'));
 };



 function checkLoginState() {
   FB.getLoginStatus(function(response) {
     statusChangeCallback(response);
   });
 };

 var user_id;

 function statusChangeCallback(response) {
     console.log('statusChangeCallback');
     console.log(response);
     if (response.status === 'connected') {
       user_id = response.authResponse.userID;
       console.log(user_id);
       extractInfo();
       console.log("Already LoggedIn");
     } else {
       console.log("Please login");
       FB.login();
     }
   };

 (function(d, s, id) {
   var js, fjs = d.getElementsByTagName(s)[0];
   if (d.getElementById(id)) return;
   js = d.createElement(s); js.id = id;
   js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.9&appId=700283830178680";
   fjs.parentNode.insertBefore(js, fjs);
 }(document, 'script', 'facebook-jssdk'));

 function shareTweet(){
 	checkLoginState();
 	FB.ui({method: 'share',
 		href: document.getElementById("status").value,
 		quote: document.getElementById('text_content').value,
 		},function(response){
 		if (!response || response.error)
 		{
 			console.log(response.error);
 			alert('Posting error occured');
 		}
 	});
 	
 };


 function extractInfo(){
 	FB.api('/me', 
 			'GET',
 			{"fields":"id,first_name,last_name"},
 			function(response){
 				first_name = response.first_name;
 				console.log(response);
 				 document.cookie="user_id="+response.id;
 				last_name = response.last_name;
 				document.cookie="first_name="+first_name;
 				localStorage.setItem('first_name',first_name);
 				document.cookie="last_name="+last_name;
 				localStorage.setItem('last_name',last_name);
 				console.log(document.cookie);
 			});
 	 FB.api(
 			  '/me/picture',
 			  'GET',
 			  {"height":"100"},
 			  function(response) {
 			      // Insert your code here
 				  picture = "<img src='" + response.data.url + "'>";
 				  document.cookie="picture="+picture;
 				localStorage.setItem('picture',picture);
 			  }
 			);
 	 document.getElementById("user_ids").value    = getCookie('user_id');
 	document.getElementById("user_id").value    = getCookie('user_id');
 	document.getElementById("first_name").value = getCookie('first_name');
 	document.getElementById("last_name").value  = getCookie('last_name');
 	document.getElementById("picture").value    = getCookie('picture');
 	console.log(document.getElementById("first_name").value);
 	console.log(document.getElementById("last_name").value);
 	console.log(document.getElementById("picture").value);
 };


 function getCookie(cname) {
 	var re = new RegExp(cname + "=([^;]+)");
 	var value = re.exec(document.cookie);
 	return (value != null) ? unescape(value[1]) : null;
 }


 function sendDirectMsg(){
 	checkLoginState();
 	FB.ui({method:  'send',
 		  link: document.getElementById("status").value,});
 	console.log(document.getElementById("status"));
 };



 </script>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.7.1.min.js"></script>
<div class="vertical-menu">
  <a href="tweethome">Tweet</a><br>
  <a href="friendspage.jsp">Friends</a><br>
  <a  id=toptweet href=toptweet.jsp>Top Tweet</a><br>
  <div id="fb-root"></div>
  <div align="right">
  <div class="fb-login-button" data-max-rows="1"    data-size="large" data-button-type="login_with" data-show-faces="false" data-auto-logout-link="true"  data-use-continue-as="true" scope="public_profile,email" onlogin="checkLoginState();"></div>
  </div>
</div>
<script type="text/javascript">callme()</script>
<%
if(null != request.getParameter("status")){
	request.setAttribute("status",request.getAttribute("status"));
}
%>

<input type=hidden id=status value="${status}">
<br><div align="center">
<table>
<tr>
<form id="storegae" action="Tweetapp" method="get" name="storegae"  >
<td><textarea id="text_content" name="text_content" class="textarea"></textarea></td>
<input type=hidden id=user_id name= user_id />
<input type=hidden id=first_name name=first_name  />
<input type=hidden id=last_name name=last_name  />
<input type=hidden id=picture name=picture  />
<script>

console.log(document.getElementById("first_name")+" "+document.getElementById("last_name")+" "+document.getElementById("picture"));
</script>
<td><input type="submit" id=submit name=save class="button" value="Save to Datastore"/></td><td>
<form action="mytweets.jsp" method="GET">
<input type=hidden id=user_ids name=user_ids  />
<input type="submit"  class="button" value="My Tweets" name="view_tweet" />
</form>
</td>
</tr>
</table>
</div>

<script>

document.getElementById("user_ids").value       = getCookie('user_id');
document.getElementById("user_id").value       = getCookie('user_id');
document.getElementById("first_name").value = getCookie('first_name');
document.getElementById("first_names").value = getCookie('first_name');
document.getElementById("last_name").value  = getCookie('last_name');
document.getElementById("picture").value    = getCookie('picture');
document.getElementById("toptweet").href="toptweet.jsp?name="+getCookie("first_name");

</script>
</body>
</html>

