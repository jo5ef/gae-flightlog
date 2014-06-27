package us.ocact.flightlog.dto;

import java.io.Serializable;

import us.ocact.flightlog.Utils;

import com.google.appengine.api.datastore.Entity;

public class TotalsEntry implements Serializable {

	private String name;
	private int flightTime;
	private int picTime;
	private int dualTime;
	private int landings;
	
	public TotalsEntry() {
		this("", 0, 0, 0 ,0);
	}
	
	public TotalsEntry(String name, int flightTime, int picTime, int dualTime, int landings) {
		this.name = name;
		this.flightTime = flightTime;
		this.picTime = picTime;
		this.dualTime = dualTime;
		this.landings = landings;
	}

	public TotalsEntry(Entity e) {
		this.name = (String) e.getProperty("name");
		this.flightTime = Utils.castLongOrInteger(e.getProperty("flighttime"));
		this.picTime = Utils.castLongOrInteger(e.getProperty("pic_time"));
		this.dualTime = Utils.castLongOrInteger(e.getProperty("dual_time"));
		this.landings = Utils.castLongOrInteger(e.getProperty("landings"));
	}
	
	public String getName() {
		return name;
	}
	
	public int getFlightTime() {
		return flightTime;
	}
	
	public int getPicTime() {
		return picTime;
	}
	
	public int getDualTime() {
		return dualTime;
	}
	
	public int getLandings() {
		return landings;
	}
	
	public void add(TotalsEntry e) {
		this.flightTime += e.flightTime;
		this.picTime += e.picTime;
		this.dualTime += e.dualTime;
		this.landings += e.landings;
	}
	
	public void add(FlightlogEntry e) {
		this.flightTime += (int) (e.getArrivalTime().getTime() - e.getDepartureTime().getTime()) / 1000 / 60;
		this.picTime += e.getPicTime();
		this.dualTime += e.getDualTime();
		this.landings += e.getLandings();
	}
	
	public void setEntityProperties(Entity e) {
		e.setProperty("name", name);
		e.setProperty("flighttime", flightTime);
		e.setProperty("pic_time", picTime);
		e.setProperty("dual_time", dualTime);
		e.setProperty("landings", landings);
	}
}
