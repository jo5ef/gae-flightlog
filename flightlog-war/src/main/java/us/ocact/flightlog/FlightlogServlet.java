package us.ocact.flightlog;

import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class FlightlogServlet extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();

		if (user == null) {
			resp.sendRedirect(req.getRequestURI());
			return;
		}

		try {
			DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Key flightlogKey = KeyFactory.createKey("Flightlog", user.getUserId());
			Entity flight = new Entity("Flight", flightlogKey);
			flight.setProperty("registration", req.getParameter("registration"));
			flight.setProperty("model", req.getParameter("model"));
			flight.setProperty("crew", req.getParameter("crew"));
			flight.setProperty("departure_id", req.getParameter("departure_id"));
			flight.setProperty("departure_time", df.parse(String.format("%s %s:00",
				req.getParameter("date"),
				req.getParameter("departure_time"))));
			flight.setProperty("destination", req.getParameter("destination"));
			flight.setProperty("arrival_time", df.parse(String.format("%s %s:00",
					req.getParameter("date"),
					req.getParameter("arrival_time"))));
			flight.setProperty("landings", Integer.parseInt(req.getParameter("landings")));
			flight.setProperty("pic_time", parseTime(req.getParameter("pic_time")));
			flight.setProperty("dual_time", parseTime(req.getParameter("dual_time")));
			flight.setProperty("remarks", req.getParameter("remarks"));

			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			datastore.put(flight);
			resp.sendRedirect("/");
			
		} catch (ParseException ex) {
			resp.sendError(401, ex.getMessage());
		}
	}
	
	private static int parseTime(String time) {
		String[] parts = time.split(":");
		return Integer.parseInt(parts[0]) * 60 + Integer.parseInt(parts[1]);
	}
}
