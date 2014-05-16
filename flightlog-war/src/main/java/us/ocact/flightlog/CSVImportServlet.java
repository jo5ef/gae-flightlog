package us.ocact.flightlog;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Locale;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemIterator;
import org.apache.commons.fileupload.FileItemStream;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class CSVImportServlet extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();

		if (user == null) {
			resp.sendRedirect(req.getRequestURI());
			return;
		}
		
		try {
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			Key flightlogKey = KeyFactory.createKey("Flightlog", user.getUserId());
			
			ServletFileUpload upload = new ServletFileUpload();
			FileItemIterator iter = upload.getItemIterator(req);
			
			while(iter.hasNext()) {
				FileItemStream item = iter.next();
				BufferedReader reader = new BufferedReader(new InputStreamReader(item.openStream()));
				String line = null;
				while((line = reader.readLine()) != null) {
					datastore.put(parseLine(flightlogKey, line));
				}
			}
			
			resp.sendRedirect("/");
			
		} catch (ParseException ex) {
			resp.sendError(401, ex.getMessage());
		} catch(FileUploadException ex) {
			resp.sendError(500, ex.getMessage());
		}
	}
	
	private static Entity parseLine(Key flightlogKey, String line) throws ParseException {
		
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH);
		
		String[] parts = line.split(";");
		
		Entity flight = new Entity("Flight", flightlogKey);
		flight.setProperty("registration", trim(parts[0]));
		flight.setProperty("model", trim(parts[1]));
		flight.setProperty("crew", trim(parts[2]));
		flight.setProperty("departure_id", trim(parts[3]));
		flight.setProperty("departure_time", df.parse(trim(parts[4])));
		flight.setProperty("destination", trim(parts[5]));
		flight.setProperty("arrival_time", df.parse(trim(parts[6])));
		flight.setProperty("landings", Integer.parseInt(parts[7]));
		flight.setProperty("pic_time", Integer.parseInt(parts[8]));
		flight.setProperty("dual_time", Integer.parseInt(parts[9]));
		flight.setProperty("price", Float.parseFloat(parts[11]));
		flight.setProperty("remarks", trim(parts[10]));
		
		return flight;
	}
	
	private static String trim(String s) {
		return s.substring(1, s.length() - 1);
	}
}
