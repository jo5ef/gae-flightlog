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
		List<Entity> flights = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(800));
		
		if(flights.isEmpty()) {
	%>
		<p>Flightlog is empty!</p>
	<%
		} else {
	%>
		<table>
			<thead>
				<tr>
					<th>#</th>
					<th>date</th>
					<th colspan="2">aircraft</th>
					<th>crew</th>
					<th colspan="2">departure</th>
					<th colspan="2">arrival</th>
					<th>landings</th>
					<th>flighttime</th>
					<th>pic time</th>
					<th>dual time</th>
					<th>price</th>
					<th>remarks</th>
				</tr>
			</thead>
			<tbody>
				<%
					SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
					SimpleDateFormat tf = new SimpleDateFormat("HH:mm");
					int count = 1, i = 0;
					int total_flighttime = 0, total_pictime = 0, total_dualtime = 0;
					
					for(Entity flight : flights) {
						int landings = ((Long) flight.getProperty("landings")).intValue();
						Date departure_time = (Date) flight.getProperty("departure_time");
						Date arrival_time = (Date) flight.getProperty("arrival_time");
						
						int flighttime = (int) (arrival_time.getTime() - departure_time.getTime()) / 1000 / 60;
						int pic_time = ((Long) flight.getProperty("pic_time")).intValue();
						int dual_time = ((Long) flight.getProperty("dual_time")).intValue();
				%>
						<%
							if(i++ % 15 == 0) {
						%>
							<tr class="total">
								<td colspan="10"></td>
								<td><%= String.format("%02d:%02d", total_flighttime / 60, total_flighttime % 60) %></td>
								<td><%= String.format("%02d:%02d", total_pictime / 60, total_pictime % 60) %></td>
								<td><%= String.format("%02d:%02d", total_dualtime / 60, total_dualtime % 60) %></td>
								<td colspan="2"></td>
							</tr>
						<%
							}
						%>
					<tr>
						<td>
							<%= count %>
							<%
								if(landings > 1) {
							%>
								- <%= count + landings - 1 %>
							<%
								}
								count += landings;
							%>
						</td>
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
						<td><%= String.format("%.2f", flight.getProperty("price")) %></td>
						<td><%= flight.getProperty("remarks") %></td>
					</tr>
				<%
						total_flighttime += flighttime;
						total_pictime += pic_time;
						total_dualtime += dual_time;
					}
				%>
			<tbody>
		</table>
	<%
		}
	%>
	<br/>
	<br/>
	<br/>
	<br/>
	<br/>
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