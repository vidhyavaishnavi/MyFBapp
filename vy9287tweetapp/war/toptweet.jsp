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
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="/css/fbtweetapp.css">
<title></title>
</head>
<body>
 <script type="text/javascript" src="/js/tweet.js"></script>
 <script> callme();</script>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.7.1.min.js"></script>
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
	Query query=new Query("tweetdatastore").addSort("visited_count", SortDirection.DESCENDING);
	PreparedQuery pq = dstore.prepare(query);
//loop through each record in the datastore	
	for (Entity record : pq.asIterable()) {
		if(count<10){
			  //out.println(result.getProperty("first_name")+" "+request.getParameter("name"));
			  String first_name = (String) record.getProperty("first_name");
			  String lastName = (String) record.getProperty("last_name");
			  String picture = (String) record.getProperty("picture");
			  String status = (String) record.getProperty("status");
			  Long id = (Long) record.getKey().getId();
			  String time = (String) record.getProperty("timestamp");
			  Long visited_count = (Long)((record.getProperty("visited_count")));
%>
			  <!-- display results in table format -->
			  <table align="center">
			  <tr><td><div style="height: 50px; width:50px; position: relative"> <%= picture %></div><td>
			  <td> Posted By:<%= first_name+" "+lastName %> </td></tr>
			  <tr><td><br><br><br><br><br>Tweet: <%= status %></td></tr>
			  <tr><td>Posted at: <%=time %></td></tr>
			  <tr><td>Visit Count: <%= visited_count %></td></tr>
			  </table>
			  <br><br>
			<%  Entity entity=dstore.get(KeyFactory.createKey("tweetdatastore", id));
//increment visit counter
			entity.setProperty("visited_count", visited_count+1);
			  dstore.put(entity);
			  count++;
		}
	}
%>