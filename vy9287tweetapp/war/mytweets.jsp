<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreService"%>
<%@ page
	import="com.google.appengine.api.datastore.DatastoreServiceFactory"%>
<%@ page import="com.google.appengine.api.datastore.Entity"%>
<%@ page import="com.google.appengine.api.datastore.Key"%>
<%@ page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@ page import="com.google.appengine.api.datastore.Query.Filter"%>
<%@ page
	import="com.google.appengine.api.datastore.Query.FilterOperator"%>
<%@ page
	import="com.google.appengine.api.datastore.Query.FilterPredicate"%>
<%@ page import="com.google.appengine.api.datastore.Query"%>
<%@ page import="com.google.appengine.api.datastore.PreparedQuery"%>
<%@ page import="com.google.appengine.api.datastore.Query.SortDirection"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" href="/css/fbtweetapp.css">
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
	//document.getElementById("toptweet").href   ="toptweet.jsp?id="+localStorage.getItem("first_name");
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
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title></title>
</head>
<body>
	<div class="vertical-menu">
		<a href="tweethome.jsp">Tweet</a> <br>
		<a href="friendspage.jsp">Friends</a><br> 
		<a id=toptweet href="toptweet.jsp">Top Tweet</a><br>
		<div id="fb-root"></div>
		<div align="right">
			<div class="fb-login-button" data-max-rows="1" data-size="large"
				data-button-type="login_with" data-show-faces="false"
				data-auto-logout-link="true" data-use-continue-as="true"
				scope="public_profile,email" onlogin="checkLoginState();"></div>
		</div>
	</div><br>


</body>
</html>

<%
int count = 0;
//connect to datastore
	DatastoreService dstore = DatastoreServiceFactory.getDatastoreService();
	Entity entitynew = new Entity("tweetdatastore");
	Query query = new Query("tweetdatastore");
	PreparedQuery pq = dstore.prepare(query);
//loop through each record in the datastore
	for (Entity record : pq.asIterable()) {
		if (record.getProperty("user_id") != null
				&& ((record.getProperty("user_id")).equals(request.getParameter("user_ids")))) {
			String first_name = (String) record.getProperty("first_name");
			count++;
			String lastName = (String) record.getProperty("last_name");
			String user_id = (String) record.getProperty("user_id");
			String picture = (String) record.getProperty("picture");
			String status = (String) record.getProperty("tweetmsg");
			Long id = (Long) record.getKey().getId();
			String time = (String) record.getProperty("timestamp");
			Long visited_count = (Long) ((record.getProperty("visited_count")));
			StringBuffer sendstr=new StringBuffer();
			String url = request.getRequestURL().toString();
			String baseURL = url.substring(0, url.length() - request.getRequestURI().length()) + request.getContextPath() + "/";
			sendstr.append(baseURL+"direct_tweet.jsp?id="+id);
%>
<br>
<table align="center">
	<tr>
		<td><div>
				<%=picture%></div>
		<td>
		<td><%=first_name + " " + lastName%>
		</td>
	</tr>
	<div>
		<tr>
			<td><br>
			<br>Tweet: <%=status%></td>
		</tr>
	<tr>
		<td>Posted at: <%=time%></td>
	</tr>
	<tr>
		<td>Visit Count: <%=visited_count%></td>
	
		<form action="mytweets.jsp" action="GET">
			<input type=hidden name=user_id id=user_id value=<%=user_id%> /> <input
				type=hidden name=u_id id=u_id value=<%=id%> />
			<td><button name="Delete" type="submit" class="button"
					value=Delete />Delete Tweet</button></td>
		</form>
		<div align="center">
			
					<script type="text/javascript">message="<%= sendstr  %>"</script>
					<td><button type="button"
						class="button" 
						onclick=posttweet(message) > Post on Timeline</button></td> 
					<td><button type="button" class="button"
						 name="send_direct_msg"
						onclick=sendasDirectTweet(message) >Send Direct Message</button></td>
		</div>
		
	</tr>

	</div>
</table>
<script type="text/javascript">

function posttweet( message){
	FB.ui({method: 'share',
		href: message,
		//quote: document.getElementById('text_content').value,
		},function(response){
		if (!response || response.error)
		{
			console.log(response.error);
			alert('Posting error occured');
		}
	});
}

function sendasDirectTweet(message){
	FB.ui({method:  'send',
		  link: message,});
	console.log(document.getElementById("status"));
}
</script>
<%
	Entity entity = dstore.get(KeyFactory.createKey("tweetdatastore", id));
			entity.setProperty("visited_count", visited_count + 1);
			dstore.put(entity);
		}
	}
	if (request.getParameter("u_id") != null) {
		Entity s = dstore.get(KeyFactory.createKey("tweetdatastore", Long.parseLong(request.getParameter("u_id"))));
		
		dstore.delete(s.getKey());
	}
%>
