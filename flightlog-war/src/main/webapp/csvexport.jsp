<%@ page contentType="text/plain;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	UserService userService = UserServiceFactory.getUserService();
	User user = userService.getCurrentUser();
	if(user == null) {
		response.sendRedirect(userService.createLoginURL(request.getRequestURI()));
		return;
	}
	
	DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	Key flightlogKey = KeyFactory.createKey("Flightlog", user.getUserId());
	Query flightQuery = new Query("Flight", flightlogKey).addSort("departure_time", Query.SortDirection.DESCENDING);
	List<Entity> flights = datastore.prepare(flightQuery).asList(FetchOptions.Builder.withLimit(10000));
%>
date;aircraft;crew;departure;arrival;landings;flighttime;pic time;dual time;remarks
<%
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat tf = new SimpleDateFormat("HH:mm");
	
	for(Entity flight : flights) {
		int landings = ((Long) flight.getProperty("landings")).intValue();
		Date departure_time = (Date) flight.getProperty("departure_time");
		Date arrival_time = (Date) flight.getProperty("arrival_time");
		
		int flighttime = (int) (arrival_time.getTime() - departure_time.getTime()) / 1000 / 60;
		int pic_time = ((Long) flight.getProperty("pic_time")).intValue();
		int dual_time = ((Long) flight.getProperty("dual_time")).intValue();
%>
<%= df.format(departure_time) %>;<%= flight.getProperty("registration") %>;<%= flight.getProperty("model") %>;<%= flight.getProperty("crew") %>;<%= flight.getProperty("departure_id") %>;<%= tf.format(departure_time) %>;<%= flight.getProperty("destination") %>;<%= tf.format(arrival_time) %>;<%= landings %>;<%= String.format("%02d:%02d", flighttime / 60, flighttime % 60) %>;<%= String.format("%02d:%02d", pic_time / 60, pic_time % 60) %>;<%= String.format("%02d:%02d", dual_time / 60, dual_time % 60) %>;<%= flight.getProperty("remarks")
%>
<%
	}
%>