package us.ocact.flightlog;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.Serializable;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.google.appengine.tools.mapreduce.DatastoreMutationPool.Params;
import com.google.appengine.tools.mapreduce.MapReduceJob;
import com.google.appengine.tools.mapreduce.MapReduceSettings;
import com.google.appengine.tools.mapreduce.MapReduceSpecification;
import com.google.appengine.tools.mapreduce.Mapper;
import com.google.appengine.tools.mapreduce.Marshallers;
import com.google.appengine.tools.mapreduce.Reducer;
import com.google.appengine.tools.mapreduce.ReducerInput;
import com.google.appengine.tools.mapreduce.inputs.DatastoreInput;
import com.google.appengine.tools.mapreduce.outputs.DatastoreOutput;

public class SumsServlet extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();

		if (user == null) {
			resp.sendRedirect(req.getRequestURI());
			return;
		}
		
		final Key totalsKey = KeyFactory.createKey("Totals", user.getUserId());
		
		Date referenceDate = new Date();
		Calendar cal = GregorianCalendar.getInstance();
		
		cal.setTime(referenceDate);
		cal.add(Calendar.DAY_OF_MONTH, -90);
		final Date cutoff90days = cal.getTime();
		
		cal.setTime(referenceDate);
		cal.add(Calendar.MONTH, -6);
		final Date cutoff6months = cal.getTime();
		
		cal.setTime(referenceDate);
		cal.add(Calendar.MONTH, -12);
		final Date cutoff12months = cal.getTime();
		
		
		
		MapReduceSpecification spec = new MapReduceSpecification.Builder(
				new DatastoreInput("Flight", 15),
				new Mapper<Entity, String, Serializable>() {
					public void map(Entity e) {
						
						Date departure_time = (Date) e.getProperty("departure_time");
						Date arrival_time = (Date) e.getProperty("arrival_time");
						
						int[] data = new int[] {
							(int) (arrival_time.getTime() - departure_time.getTime()) / 1000 / 60,
							((Long) e.getProperty("pic_time")).intValue(),
							((Long) e.getProperty("dual_time")).intValue(),
							((Long) e.getProperty("landings")).intValue()
						};
						
						emit("Total", data);
						
						if(departure_time.after(cutoff90days)) {
							emit("Last 90 Days", data);
						}
						if(departure_time.after(cutoff6months)) {
							emit("Last 6 Months", data);
						}
						if(departure_time.after(cutoff12months)) {
							emit("Last 12 Months", data);
						}
					}
				},
				new Reducer<String, Serializable, Entity>() {
					public void reduce(String k, ReducerInput<Serializable> v) {
						
						int flighttime = 0, pic_time = 0, dual_time = 0, landings = 0;
						
						while(v.hasNext()) {
							int[] data = (int[]) v.next();
							flighttime += data[0];
							pic_time += data[1];
							dual_time += data[2];
							landings += data[3];
						}
						
						Entity e = new Entity("Total", k, totalsKey);
						e.setProperty("name", k);
						e.setProperty("flighttime", flighttime);
						e.setProperty("pic_time", pic_time);
						e.setProperty("dual_time", dual_time);
						e.setProperty("landings", landings);
						emit(e);
					}
				}, 
				new DatastoreOutput()).build();
		
		MapReduceSettings settings = new MapReduceSettings.Builder().build();
		//settings.setBucketName("jo5ef-flightlog.appspot.com");
		//settings.setWorkerQueueName("mapreduce-workers");
		
		resp.sendRedirect("/_ah/pipeline/status.html?root=" + MapReduceJob.start(spec, settings));
	}

}
