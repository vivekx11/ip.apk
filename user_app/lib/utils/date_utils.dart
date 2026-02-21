import 'package:intl/intl.dart';

/// Utility class for date and time formatting
class DateTimeUtils {
  // India Standard Time (IST) is UTC+5:30
  static const int istOffsetHours = 5;
  static const int istOffsetMinutes = 30;

  /// Convert UTC DateTime to IST DateTime
  static DateTime toIST(DateTime utcDate) {
    return utcDate.add(const Duration(hours: istOffsetHours, minutes: istOffsetMinutes));
  }

  /// Format DateTime to IST with 12-hour format
  /// Example: 17/02/2026 at 5:08 PM
  static String formatToIST12Hour(DateTime utcDate) {
    final istDate = toIST(utcDate);
    final day = istDate.day.toString().padLeft(2, '0');
    final month = istDate.month.toString().padLeft(2, '0');
    final year = istDate.year;
    
    int hour = istDate.hour;
    final period = hour >= 12 ? 'PM' : 'AM';
    
    // Convert to 12-hour format
    if (hour == 0) {
      hour = 12;
    } else if (hour > 12) {
      hour = hour - 12;
    }
    
    final minute = istDate.minute.toString().padLeft(2, '0');
    
    return '$day/$month/$year at $hour:$minute $period';
  }

  /// Format DateTime to IST with date only
  /// Example: 17/02/2026
  static String formatDateOnly(DateTime utcDate) {
    final istDate = toIST(utcDate);
    final day = istDate.day.toString().padLeft(2, '0');
    final month = istDate.month.toString().padLeft(2, '0');
    final year = istDate.year;
    
    return '$day/$month/$year';
  }

  /// Format DateTime to IST with time only (12-hour format)
  /// Example: 5:08 PM
  static String formatTimeOnly(DateTime utcDate) {
    final istDate = toIST(utcDate);
    
    int hour = istDate.hour;
    final period = hour >= 12 ? 'PM' : 'AM';
    
    // Convert to 12-hour format
    if (hour == 0) {
      hour = 12;
    } else if (hour > 12) {
      hour = hour - 12;
    }
    
    final minute = istDate.minute.toString().padLeft(2, '0');
    
    return '$hour:$minute $period';
  }

  /// Format DateTime to readable format with day name
  /// Example: Monday, 17 Feb 2026 at 5:08 PM
  static String formatWithDayName(DateTime utcDate) {
    final istDate = toIST(utcDate);
    final formatter = DateFormat('EEEE, dd MMM yyyy');
    final dateStr = formatter.format(istDate);
    final timeStr = formatTimeOnly(utcDate);
    
    return '$dateStr at $timeStr';
  }

  /// Get relative time string (e.g., "2 hours ago", "Just now")
  static String getRelativeTime(DateTime utcDate) {
    final istDate = toIST(utcDate);
    final now = toIST(DateTime.now().toUtc());
    final difference = now.difference(istDate);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else {
      return formatToIST12Hour(utcDate);
    }
  }
}
