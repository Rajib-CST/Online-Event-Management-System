package util;

import java.sql.Date;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

public final class BookingRules {
	private static final Set<String> LOCATIONS = new HashSet<>(Arrays.asList("Asansol", "Durgapur", "Bardhaman"));

	private BookingRules() {}

	public static boolean canCancel(Date eventDate) {
		return eventDate != null && !eventDate.toLocalDate().isBefore(LocalDate.now().plusDays(5));
	}

	public static boolean isValidLocation(String location) {
		return location != null && LOCATIONS.contains(location);
	}

	public static boolean isValidDays(int days) {
		return days >= 1 && days <= 7;
	}
}