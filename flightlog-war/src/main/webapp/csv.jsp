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
	
	<h1>csv import</h1>
	
	<form class="form-horizontal" role="form" action="/csvimport" method="post" enctype="multipart/form-data">
		<div class="form-group">
			<label for="file" class="col-sm-2 control-label">File</label>
			<div class="col-sm-10">
				<input type="file" name="file"/>
			</div>
		</div>
		<div class="form-group">
			<div class="col-sm-offset-2 col-sm-10">
				<button type="submit" class="btn btn-default">Upload</button>
			</div>
		</div>
	</form>
	</div>
</body>
</html>