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
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
    <link type="text/css" rel="stylesheet" href="styles.css"/>
    <title>flightlog</title>
</head>
<body>
	<h1>flightlog</h1>
	<%
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		if(user == null) {
			response.sendRedirect(userService.createLoginURL(request.getRequestURI()));
			return;
		}
		
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Key flightlogKey = KeyFactory.createKey("Flightlog", user.getUserId());
		Query query = new Query("Flight", flightlogKey).addSort("departure_time", Query.SortDirection.ASCENDING);
		List<Entity> flights = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(400));
		
		if(flights.isEmpty()) {
	%>
		<p>Flightlog is empty!</p>
	<%
		} else {
	%>
		<table>
			<thead>
				<tr>
					<th>registration</th>
					<th>model</th>
					<th>crew</th>
					<th>departure</th>
					<th>departure time</th>
					<th>destination</th>
					<th>arrival time</th>
					<th>landings</th>
					<th>pic time</th>
					<th>dual time</th>
					<th>price</th>
					<th>remarks</th>
				</tr>
			</thead>
			<tbody>
				<%
					for(Entity flight : flights) {
				%>
					<tr>
						<td><%= flight.getProperty("registration") %></td> 
						<td><%= flight.getProperty("model") %></td>
						<td><%= flight.getProperty("crew") %></td>
						<td><%= flight.getProperty("departure_id") %></td>
						<td><%= flight.getProperty("departure_time") %></td>
						<td><%= flight.getProperty("destination") %></td>
						<td><%= flight.getProperty("arrival_time") %></td>
						<td><%= flight.getProperty("landings") %></td>
						<td><%= flight.getProperty("pic_time") %></td>
						<td><%= flight.getProperty("dual_time") %></td>
						<td><%= flight.getProperty("price") %></td>
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
	<form action="/flightlog" method="post">
		<table>
			<thead>
				<tr>
					<th>registration</th>
					<th>model</th>
					<th>crew</th>
					<th>departure</th>
					<th>departure time</th>
					<th>destination</th>
					<th>arrival time</th>
					<th>landings</th>
					<th>pic_time</th>
					<th>dual_time</th>
					<th>price</th>
					<th>remarks</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td><input type="text" name="registration"/></td>
					<td><input type="text" name="model"/></td>
					<td><input type="text" name="crew"/></td>
					<td><input type="text" name="departure_id"/></td>
					<td><input type="text" name="departure_time"/></td>
					<td><input type="text" name="destination"/></td>
					<td><input type="text" name="arrival_time"/></td>
					<td><input type="number" name="landings"/></td>
					<td><input type="number" name="pic_time"/></td>
					<td><input type="number" name="dual_time"/></td>
					<td><input type="text" name="price"/></td>
					<td><input type="text" name="remarks"/></td>
				</tr>
			<tbody>
		</table>
		<input type="submit" value="add"/>
	</form>
</body>
</html>