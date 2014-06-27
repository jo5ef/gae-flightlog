package us.ocact.flightlog.dto;

import java.util.Date;

import us.ocact.flightlog.Utils;

import com.google.appengine.api.datastore.Entity;

public class FlightlogEntry {
	
	private String registration;
	private String model;
	private String crew;
	private String departureId;
	private Date departureTime;
	private String destination;
	private Date arrivalTime;
	private int landings;
	private int picTime;
	private int dualTime;
	private String remarks;
	
	public FlightlogEntry(Entity e) {
		this.registration = (String) e.getProperty("registration");
		this.model = (String) e.getProperty("model");
		this.crew = (String) e.getProperty("crew");
		this.departureId = (String) e.getProperty("departure_id");
		this.departureTime = (Date) e.getProperty("departure_time");
		this.destination = (String) e.getProperty("destination");
		this.arrivalTime = (Date) e.getProperty("arrival_time");
		this.landings = Utils.castLongOrInteger(e.getProperty("landings"));
		this.picTime = Utils.castLongOrInteger(e.getProperty("pic_time"));
		this.dualTime = Utils.castLongOrInteger(e.getProperty("dual_time"));
		this.remarks= (String) e.getProperty("remarks");
	}
	
	public String getRegistration() {
		return registration;
	}
	
	public String getModel() {
		return model;
	}
	
	public String getCrew() {
		return crew;
	}
	
	public String getDepartureId() {
		return departureId;
	}
	
	public Date getDepartureTime() {
		return departureTime;
	}
	
	public String getDestination() {
		return destination;
	}
	
	public Date getArrivalTime() {
		return arrivalTime;
	}
	
	public int getLandings() {
		return landings;
	}
	
	public int getPicTime() {
		return picTime;
	}
	
	public int getDualTime() {
		return dualTime;
	}
	
	public String getRemarks() {
		return remarks;
	}
}
