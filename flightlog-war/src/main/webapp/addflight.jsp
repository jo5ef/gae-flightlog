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
	%>
	
	<%@include file="nav.jsp" %>

	<h1>add a flight</h1>
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