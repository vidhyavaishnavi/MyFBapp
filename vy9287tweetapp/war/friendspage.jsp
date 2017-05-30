<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="com.google.appengine.api.datastore.Query.Filter" %>
<%@ page import="com.google.appengine.api.datastore.Query.FilterOperator" %>
<%@ page import="com.google.appengine.api.datastore.Query.FilterPredicate" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.PreparedQuery" %>
<%@ page import="com.google.appengine.api.datastore.Query.SortDirection" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" href="/css/fbtweetapp.css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title></title>
</head>
<body>
<div class="vertical-menu">
  <a href="tweethome.jsp">Tweet</a><br>
  <a href="friendspage.jsp">Friends</a><br>
  <a  id=toptweet href="toptweet.jsp">Top Tweet</a><br>
  <div id="fb-root"></div>
  <div align="right">
  <div class="fb-login-button" data-max-rows="1"    data-size="large" data-button-type="login_with" data-show-faces="false" data-auto-logout-link="true"  data-use-continue-as="true" scope="public_profile,email" onlogin="checkLoginState();"></div>
  </div><br>
</div>

</body>
</html>

<%
	int count=0;
//connect to datastore
	DatastoreService dstore=DatastoreServiceFactory.getDatastoreService();
	Entity entitynew=new Entity("tweetdatastore");
	Query query=new Query("tweetdatastore");
	PreparedQuery pq = dstore.prepare(query);
//loop through reach record in the datastore to retrieve the values	
	for (Entity record : pq.asIterable()) {
			  
			  String first_name = (String) record.getProperty("first_name");
			  String lastName = (String) record.getProperty("last_name");
			  String picture = (String) record.getProperty("picture");
			  String status = (String) record.getProperty("tweetmsg");
			  Long id = (Long) record.getKey().getId();
			  String time = (String) record.getProperty("timestamp");
			  Long visited_count = (Long)((record.getProperty("visited_count"))); %>
<!-- display them in table format -->
			  <br><table >
			  <tbody align="center">
			  <tr><div><%=picture %></div></tr>
			  <tr><br><br><br>User: <%= first_name %> <%= lastName %> </tr>
			  <br><tr>Tweet: <%= status %> </tr>
			  <br><tr>Posted at: <%= time %> </tr>
			 <br> <tr>Visit Count: <%= visited_count %></tr><br><br>
			 </tbody>
			  </table>
			  <% Entity entity=dstore.get(KeyFactory.createKey("tweetdatastore", id));
//increment the visit counter
			  entity.setProperty("visited_count", visited_count+1);
			  dstore.put(entity);
			  }
%>