class CalendarConverter {
  static const int _ethiopianEpoch = 1723856;

  /// Converts a Gregorian [DateTime] to Ethiopian [year, month, day]
  static List<int> toEthiopian(DateTime gDate) {
    int jd = _gregorianToJD(gDate.year, gDate.month, gDate.day);
    List<int> eth = _jdToEthiopian(jd);

    // Correct year if before Ethiopian New Year (Sep 11 or Sep 12)
    DateTime newYear =
        DateTime(gDate.year, 9, _isGregorianLeapYear(gDate.year) ? 12 : 11);

    // The previouos implementation has a bug
    final int calculatedEthYear =
    (gDate.month > 9 || (gDate.month == 9 && gDate.day >= newYear.day))
        ? (gDate.year - 7)
        : (gDate.year - 8);
            
    eth[0] = calculatedEthYear;

    return eth;
  }

  static bool _isGregorianLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  static DateTime toGregorian(int year, int month, int day) {
    int jd = _ethiopianToJD(year, month, day);
    DateTime gDate = _jdToGregorian(jd);

    // Ethiopian year starts in Sep, so Meskerem (month 1) is in Sep of previous Gregorian year
    // If Ethiopian month is 1–4 (roughly Sep–Dec), adjust forward if needed
    if (month <= 4 && gDate.month < 9) {
      gDate = DateTime(gDate.year + 1, gDate.month, gDate.day);
    }

    return gDate;
  }
  // -------------------------------
  // Internal: Julian Day converters
  // -------------------------------

  /// Gregorian to Julian Day
  static int _gregorianToJD(int year, int month, int day) {
    int a = ((14 - month) ~/ 12);
    int y = year + 4800 - a;
    int m = month + 12 * a - 3;
    return day +
        ((153 * m + 2) ~/ 5) +
        365 * y +
        (y ~/ 4) -
        (y ~/ 100) +
        (y ~/ 400) -
        32045;
  }

  /// Julian Day to Gregorian
  static DateTime _jdToGregorian(int jd) {
    int a = jd + 32044;
    int b = ((4 * a + 3) ~/ 146097);
    int c = a - ((b * 146097) ~/ 4);
    int d = ((4 * c + 3) ~/ 1461);
    int e = c - ((1461 * d) ~/ 4);
    int m = ((5 * e + 2) ~/ 153);

    int day = e - ((153 * m + 2) ~/ 5) + 1;
    int month = m + 3 - 12 * (m ~/ 10);
    int year = b * 100 + d - 4800 + (m ~/ 10);

    return DateTime(year, month, day);
  }

  static int _ethiopianToJD(int year, int month, int day) {
    int jd =
        _gregorianToJD(year + 7, 9, 11); // Ethiopian year starts on Sep 11 (GC)
    return jd + 30 * (month - 1) + (day - 1);
  }

  /// Julian Day to Ethiopian
  static List<int> _jdToEthiopian(int jd) {
    int r = (jd - _ethiopianEpoch) % 1461;
    int n = (r % 365) + 365 * (r ~/ 1460);
    int year = 4 * ((jd - _ethiopianEpoch) ~/ 1461) + (r ~/ 365) + 1;
    int month = (n ~/ 30) + 1;
    int day = (n % 30) + 1;
    return [year, month, day];
  }
}
