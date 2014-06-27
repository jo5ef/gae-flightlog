package us.ocact.flightlog;

public class Utils {
	public static int castLongOrInteger(Object o) {
		if(o instanceof Integer) {
			return ((Integer)o).intValue();
		} else {
			return ((Long)o).intValue();
		}
	}
}
