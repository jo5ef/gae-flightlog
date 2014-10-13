<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
<!DOCTYPE html>
<html lang="en">
<head>
	<%@include file="head.html" %>
	<title>flightlog</title>
</head>
<body>
	<div class="container">
	<%
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		if(user == null) {
			response.sendRedirect(userService.createLoginURL(request.getRequestURI()));
			return;
		}
		
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	%>
	
	<%@include file="nav.jsp" %>
	
	
	<div class="row">
		<div class="col-md-6">
			<h4>flight time</h4>
			[<a href="/sums">recalc</a>]
			<%
				Key totalsKey = KeyFactory.createKey("Totals", user.getUserId());
				
				Query query = new Query("Total", totalsKey);
				List<Entity> totals = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(10));
				
				if(!totals.isEmpty()) {
			%>
				<table class="table">
					<thead>
						<tr>
							<th></td>
							<th>flight time</td>
							<th>pic time</td>
							<th>dual time</td>
							<th>landings</td>
						</tr>
					</thead>
					<tbody>
						<%
							for(Entity total : totals) {
								int flighttime = ((Long) total.getProperty("flighttime")).intValue();
								int pic_time = ((Long) total.getProperty("pic_time")).intValue();
								int dual_time = ((Long) total.getProperty("dual_time")).intValue();
						%> 
							<tr>
								<td><%= total.getProperty("name") %></td>
								<td><%= String.format("%02d:%02d", flighttime / 60, flighttime % 60) %></td>
								<td><%= String.format("%02d:%02d", pic_time / 60, pic_time % 60) %></td>
								<td><%= String.format("%02d:%02d", dual_time / 60, dual_time % 60) %></td>
								<td><%= total.getProperty("landings") %></td>
							</tr>
						<%
							}
						%>
					</tbody>
				</table>
			<%
				} else {
			%>
				<p>No totals calculated yet!</p>
			<% } %>
		</div>
		<!--<div class="col-md-6">
			<h4>expirations</h4>
			<table class="table">
				<thead>
					<tr>
						<th></td>
						<th>expires</td>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>90 Day Rule</td>
						<td>2014-07-21</td>
					</tr>
					<tr>
						<td>OE-DGE</td>
						<td>2014-06-21</td>
					</tr>
					<tr>
						<td>OE-AON</td>
						<td>2014-08-01</td>
					</tr>
				</tbody>
			</table>
		</div>-->
	</div>
	
	<h4>most recent flights</h4>
	<%
		Key flightlogKey = KeyFactory.createKey("Flightlog", user.getUserId());
		Query flightQuery = new Query("Flight", flightlogKey).addSort("departure_time", Query.SortDirection.DESCENDING);
		List<Entity> flights = datastore.prepare(flightQuery).asList(FetchOptions.Builder.withLimit(100));
		
		if(flights.isEmpty()) {
	%>
		<p>Flightlog is empty!</p>
	<%
		} else {
	%>
		<table class="table table-condensed">
			<thead>
				<tr>
					<th>date</th>
					<th colspan="2">aircraft</th>
					<th>crew</th>
					<th colspan="2">departure</th>
					<th colspan="2">arrival</th>
					<th>landings</th>
					<th>flighttime</th>
					<th>pic time</th>
					<th>dual time</th>
					<th>remarks</th>
				</tr>
			</thead>
			<tbody>
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
					<tr>
						<td><%= df.format(departure_time) %></td>
						<td><%= flight.getProperty("registration") %></td>
						<td><%= flight.getProperty("model") %></td>
						<td><%= flight.getProperty("crew") %></td>
						<td><%= flight.getProperty("departure_id") %></td>
						<td><%= tf.format(departure_time) %></td>
						<td><%= flight.getProperty("destination") %></td>
						<td><%= tf.format(arrival_time) %></td>
						<td><%= landings %></td>
						<td><%= String.format("%02d:%02d", flighttime / 60, flighttime % 60) %></td>
						<td><%= String.format("%02d:%02d", pic_time / 60, pic_time % 60) %></td>
						<td><%= String.format("%02d:%02d", dual_time / 60, dual_time % 60) %></td>
						<td><%= flight.getProperty("remarks") %></td>
					</tr>
				<%
					}
				%>
			<tbody>
		</table>
	<%
		}
	%>
	</div>
</body>
</html>
