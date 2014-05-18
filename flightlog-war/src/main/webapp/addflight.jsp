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

	<form class="form-horizontal" role="form" action="/flightlog" method="post">
		<div class="form-group">
			<label for="date" class="col-sm-2 control-label">Date</label>
			<div class="col-sm-10">
				<input type="date" name="date" class="form-control" id="date" value="<%= new SimpleDateFormat("yyyy-MM-dd").format(new Date()) %>"/>
			</div>
		</div>
		<div class="form-group">
			<label for="registration" class="col-sm-2 control-label">Registration</label>
			<div class="col-sm-4">
				<input type="text" name="registration" class="form-control" id="registration"/>
			</div>
			<label for="model" class="col-sm-2 control-label">Model</label>
			<div class="col-sm-4">
				<input type="text" name="model" class="form-control" id="model"/>
			</div>
		</div>
		<div class="form-group">
			<label for="crew" class="col-sm-2 control-label">Crew</label>
			<div class="col-sm-10">
				<input type="text" name="crew" class="form-control" id="crew"/>
			</div>
		</div>
		<div class="form-group">
			<label for="departure_id" class="col-sm-2 control-label">Departure</label>
			<div class="col-sm-4">
				<input type="text" name="departure_id" class="form-control" id="departure_id"/>
			</div>
			<label for="departure_time" class="col-sm-2 control-label">Departure Time</label>
			<div class="col-sm-4">
				<input type="text" name="departure_time" class="form-control" id="departure_time" placeholder="HH:MM"/>
			</div>
		</div>
		<div class="form-group">
			<label for="destination" class="col-sm-2 control-label">Destination</label>
			<div class="col-sm-4">
				<input type="text" name="destination" class="form-control" id="destination"/>
			</div>
			<label for="arrival_time" class="col-sm-2 control-label">Arrival Time</label>
			<div class="col-sm-4">
				<input type="text" name="arrival_time" class="form-control" id="arrival_time" placeholder="HH:MM"/>
			</div>
		</div>
		<div class="form-group">
			<label for="landings" class="col-sm-2 control-label">Landings</label>
			<div class="col-sm-10">
				<input type="number" name="landings" class="form-control" id="landings" value="1"/>
			</div>
		</div>
		<div class="form-group">
			<label for="pic_time" class="col-sm-2 control-label">PIC Time</label>
			<div class="col-sm-4">
				<input type="text" name="pic_time" class="form-control" id="pic_time" placeholder="HH:MM"/>
			</div>
			<label for="dual_time" class="col-sm-2 control-label">Dual Time</label>
			<div class="col-sm-4">
				<input type="text" name="dual_time" class="form-control" id="dual_time" value="00:00" placeholder="HH:MM"/>
			</div>
		</div>
		<div class="form-group">
			<label for="remarks" class="col-sm-2 control-label">Remarks</label>
			<div class="col-sm-10">
				<input type="text" name="remarks" class="form-control" id="remarks"/>
			</div>
		</div>
		<div class="form-group">
			<div class="col-sm-offset-2 col-sm-10">
				<button type="submit" class="btn btn-default">Add flight</button>
			</div>
		</div>
	</form>
	</div>
</body>
</html>