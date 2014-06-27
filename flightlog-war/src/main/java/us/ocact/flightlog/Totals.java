package us.ocact.flightlog;

import java.io.Serializable;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import us.ocact.flightlog.dto.FlightlogEntry;
import us.ocact.flightlog.dto.TotalsEntry;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.tools.mapreduce.MapReduceSpecification;
import com.google.appengine.tools.mapreduce.Mapper;
import com.google.appengine.tools.mapreduce.Reducer;
import com.google.appengine.tools.mapreduce.ReducerInput;
import com.google.appengine.tools.mapreduce.inputs.DatastoreInput;
import com.google.appengine.tools.mapreduce.outputs.DatastoreOutput;

public class Totals implements Serializable {

	private static final String KIND = "Total";
	
	private static final String[] CUTOFF_LABELS = new String[] {
		"Total", "Last 90 Days", "Last 6 Months", "Last 12 Months" };
	
	private Date[] calcCutoffDates(Date referenceDate) {
		
		Calendar cal = GregorianCalendar.getInstance();
		
		cal.setTimeInMillis(0);
		Date all = cal.getTime();
		
		cal.setTime(referenceDate);
		cal.add(Calendar.DAY_OF_MONTH, -90);
		Date cutoff90days = cal.getTime();
		
		cal.setTime(referenceDate);
		cal.add(Calendar.MONTH, -6);
		Date cutoff6months = cal.getTime();
		
		cal.setTime(referenceDate);
		cal.add(Calendar.MONTH, -12);
		Date cutoff12months = cal.getTime();
		
		return new Date[] { all, cutoff90days, cutoff6months, cutoff12months };
	}
	
	@SuppressWarnings("unchecked")
	public MapReduceSpecification createRecalcJob(final Key totalsKey) {
		
		final Date[] cutoffDates = calcCutoffDates(new Date());
		
		return new MapReduceSpecification.Builder(
			new DatastoreInput("Flight", 15),
			new Mapper<Entity, String, Serializable>() {
				public void map(final Entity e) {
					
					FlightlogEntry fle = new FlightlogEntry(e);
					
					TotalsEntry data = new TotalsEntry();
					data.add(fle);
					
					for(int i = 0; i < cutoffDates.length; i++) {
						if(fle.getDepartureTime().after(cutoffDates[i])) {
							emit(CUTOFF_LABELS[i], data);
						}
					}
				}
			},
			new Reducer<String, Serializable, Entity>() {
				public void reduce(final String k, final ReducerInput<Serializable> v) {
					
					TotalsEntry total = new TotalsEntry(k, 0, 0, 0, 0);
					
					while(v.hasNext()) {
						total.add((TotalsEntry) v.next());
					}
					
					Entity e = new Entity(KIND, k, totalsKey);
					total.setEntityProperties(e);
					emit(e);
				}
			}, 
			new DatastoreOutput()).build();
	}
	
	public void incrementTotals(Key totalsKey, FlightlogEntry f, DatastoreService datastore) {
		
		try {
			Date[] cutoffDates = calcCutoffDates(new Date());
			for(int i = 0; i < cutoffDates.length; i++) {
				if(f.getDepartureTime().after(cutoffDates[i])) {
					Entity e = datastore.get(KeyFactory.createKey(totalsKey, KIND, CUTOFF_LABELS[i]));
					TotalsEntry t = new TotalsEntry(e);
					t.add(f);
					t.setEntityProperties(e);
					datastore.put(e);
				}
			}
			
			
		} catch(EntityNotFoundException ex) {
		}
	}
}
