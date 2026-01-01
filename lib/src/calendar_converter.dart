class CalendarConverter {
  static const int _ethiopianEpoch = 1724221; // Meskerem 1, 1 EC

  /// Converts a Gregorian [DateTime] to Ethiopian [year, month, day]
  static List<int> toEthiopian(DateTime gDate) {
    int jd = _gregorianToJD(gDate.year, gDate.month, gDate.day);
    return _jdToEthiopian(jd);
  }

  static DateTime toGregorian(int year, int month, int day) {
    int jd = _ethiopianToJD(year, month, day);
    return _jdToGregorian(jd);
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

  /// Ethiopian to Julian Day
  static int _ethiopianToJD(int year, int month, int day) {
    int y = year - 1;
    int n = 365 * y + (y + 1) ~/ 4 + 30 * (month - 1) + (day - 1);
    return n + _ethiopianEpoch;
  }

  /// Julian Day to Ethiopian
  static List<int> _jdToEthiopian(int jd) {
    int n = jd - _ethiopianEpoch;
    int year = (4 * n + 1) ~/ 1461;
    int daysInPreviousYears = 365 * year + (year + 1) ~/ 4;
    int remainingDays = n - daysInPreviousYears;

    int month = (remainingDays ~/ 30) + 1;
    int day = (remainingDays % 30) + 1;

    return [year + 1, month, day];
  }
}
