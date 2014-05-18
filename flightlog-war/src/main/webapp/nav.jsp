<nav class="navbar navbar-default" role="navigation">
	<div class="container">
		<a class="navbar-brand" href="#">flightlog</a>
		<ul class="nav navbar-nav">
			<li <%= request.getServletPath().equals("/dashboard.jsp") ? "class=\"active\"" : "" %>>
				<a href="/">Home</a>
			</li>
			<li <%= request.getServletPath().equals("/addflight.jsp") ? "class=\"active\"" : "" %>>
				<a href="addflight.jsp">Add Flight</a>
			</li>
			<li <%= request.getServletPath().equals("/stats.jsp") ? "class=\"active\"" : "" %>>
				<a href="stats.jsp">Stats</a>
			</li>
			<li <%= request.getServletPath().equals("/csv.jsp") ? "class=\"active\"" : "" %>>
				<a href="csv.jsp">CSV Import/Export</a>
			</li>
		</ul>
	</div>
</nav>
