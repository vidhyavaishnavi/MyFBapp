package com.gae.tweetapp;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.*;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Query.SortDirection;
import com.google.appengine.api.datastore.Query.Filter;
import com.google.appengine.api.datastore.Query.FilterOperator;
import com.google.appengine.api.datastore.Query.FilterPredicate;


@SuppressWarnings("serial")
public class TweetappServlet extends HttpServlet {
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
		
		DatastoreService dstore=DatastoreServiceFactory.getDatastoreService();
		Entity tweete=new Entity("tweetdatastore");
		tweete.setProperty("tweetmsg",req.getParameter("text_content"));
		tweete.setProperty("user_id", req.getParameter("user_id"));
		tweete.setProperty("first_name", req.getParameter("first_name"));
		tweete.setProperty("last_name", req.getParameter("last_name"));
		tweete.setProperty("picture", req.getParameter("picture"));
		tweete.setProperty("visited_count", 0);
		Cookie user_id = new Cookie("user_id", req.getParameter("user_id"));
		Cookie f_name= new Cookie("first_name",req.getParameter("first_name"));
		Cookie l_name=new Cookie("last_name", req.getParameter("last_name"));
		Cookie pic = new Cookie("picture", req.getParameter("picture"));
		resp.addCookie(user_id);
		resp.addCookie(f_name);
		resp.addCookie(l_name);
		resp.addCookie(pic);
		DateFormat newformat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		Date date = new Date();
        System.out.println(newformat.format(date));
		tweete.setProperty("timestamp", newformat.format(date));
		Key id=dstore.put(tweete);		
		StringBuffer sendstr=new StringBuffer();
		String url = req.getRequestURL().toString();
		String baseURL = url.substring(0, url.length() - req.getRequestURI().length()) + req.getContextPath() + "/";
		sendstr.append(baseURL+"direct_tweet.jsp?id="+id.getId());
		req.setAttribute("status", sendstr);
		req.getRequestDispatcher("tweethome.jsp").forward(req, resp);
	}
}
