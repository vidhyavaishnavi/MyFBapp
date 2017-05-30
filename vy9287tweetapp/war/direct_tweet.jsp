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
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
 <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css">
 <link rel="stylesheet" href="/css/fbtweetapp.css">
</head>
<body>
<div class="vertical-menu">
  <a href="tweethome.jsp">Tweet</a>
  <a href="friendspage.jsp">Friends</a>
  <a  id=toptweet>Top Tweet</a>
  <div id="fb-root"></div>
  <div align="right">
  <div class="fb-login-button" data-max-rows="1"    data-size="large" data-button-type="login_with" data-show-faces="false" data-auto-logout-link="true"  data-use-continue-as="true" scope="public_profile,email" onlogin="checkLoginState();"></div>
  </div>
  </div>
<%
try{
//connect to datastore
	DatastoreService dstore=DatastoreServiceFactory.getDatastoreService();

Entity entitynew=new Entity("tweetdatastore");
Query query=new Query("tweetdatastore");

PreparedQuery pq = dstore.prepare(query);
long visited_count=0;
for (Entity record : pq.asIterable()) {
   	  String first_name = (String) record.getProperty("first_name");
	  String lastName = (String) record.getProperty("last_name");
	  String picture = (String) record.getProperty("picture");
	  String status = (String) record.getProperty("tweetmsg");
	  Long id = (Long) record.getKey().getId();
	  String time = (String) record.getProperty("timestamp");
	  visited_count = (Long)((record.getProperty("visited_count")));
	  Key k= record.getKey();
	  if(id==Long.parseLong(request.getParameter("id"))){
	 
	  Entity entity=dstore.get(KeyFactory.createKey("tweetdatastore", id));
	  s.setProperty("visited_count", visited_count+1);
	
	  dstore.put(entity);
	  out.println("<h1> "+ entity.getProperty("first_name")+" "+entity.getProperty("last_name")+"</h1>");
	  out.println("<table>");
	  out.println("<tr><td><div style="+"height: 50px; width:50px>"+picture+"</div><td>");
	  out.println("<td><div id=name>"+ first_name+" "+lastName +"</div></td>");
	  out.println("<tr><h3><div id=status> "+entity.getProperty("first_name")+" said "+status +"</div></h3></tr>");
	  out.println("<tr><div id=postedate>Posted at:"+ time +"</div></tr>");
	  out.println("</table>");
	  }
	}
}catch(Exception e){
	out.println(e);
}
%>
</body>
<script type="text/javascript">
console.log("validate");
</script>
</html>