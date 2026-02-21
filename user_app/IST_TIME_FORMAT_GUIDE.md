# IST Time Format Implementation Guide

## Overview
This app now displays all dates and times in **India Standard Time (IST)** with **12-hour format** instead of 24-hour format.

## What Changed

### Before
- Times were displayed in UTC timezone
- 24-hour format (e.g., "17/02/2026 at 5:08 AM" showing wrong time)
- No timezone conversion

### After
- All times converted to IST (UTC+5:30)
- 12-hour format with AM/PM (e.g., "17/02/2026 at 5:08 PM")
- Consistent formatting across the entire app

## Implementation

### DateTimeUtils Class
Location: `lib/utils/date_utils.dart`

This utility class provides all date/time formatting functions:

#### Available Methods

1. **formatToIST12Hour(DateTime utcDate)**
   - Converts UTC to IST and formats with 12-hour clock
   - Example: `17/02/2026 at 5:08 PM`
   - Use for: Order dates, timestamps

2. **formatDateOnly(DateTime utcDate)**
   - Shows only the date in IST
   - Example: `17/02/2026`
   - Use for: Date-only displays

3. **formatTimeOnly(DateTime utcDate)**
   - Shows only the time in 12-hour format
   - Example: `5:08 PM`
   - Use for: Time-only displays

4. **formatWithDayName(DateTime utcDate)**
   - Shows date with day name
   - Example: `Monday, 17 Feb 2026 at 5:08 PM`
   - Use for: Detailed date displays

5. **getRelativeTime(DateTime utcDate)**
   - Shows relative time (e.g., "2 hours ago", "Just now")
   - Falls back to full date after 7 days
   - Use for: Order history, activity feeds

## Where It's Used

### Order Details Screen
- Order Date: Full IST timestamp with 12-hour format
- Accepted At: Full IST timestamp with 12-hour format
- Completed At: Full IST timestamp with 12-hour format

### Order History Screen
- Order creation time: Relative time format
- Shows "Just now", "2 hours ago", "3 days ago", etc.

## How to Use in New Screens

```dart
import '../../utils/date_utils.dart';

// For full date and time
String formattedDateTime = DateTimeUtils.formatToIST12Hour(order.createdAt);

// For relative time
String relativeTime = DateTimeUtils.getRelativeTime(order.createdAt);

// For date only
String dateOnly = DateTimeUtils.formatDateOnly(order.createdAt);

// For time only
String timeOnly = DateTimeUtils.formatTimeOnly(order.createdAt);
```

## Important Notes

1. **Backend Compatibility**: Backend should store dates in UTC format
2. **Timezone Conversion**: All conversions happen on the frontend
3. **Consistency**: Always use DateTimeUtils for date formatting
4. **12-Hour Format**: All times show AM/PM indicator
5. **IST Offset**: UTC+5:30 (5 hours 30 minutes ahead of UTC)

## Testing

To verify IST conversion is working:
1. Create an order
2. Check the displayed time matches your local IST time
3. Verify AM/PM indicator is correct
4. Confirm 12-hour format (1-12, not 0-23)

## Example Conversions

| UTC Time | IST Time (12-hour) |
|----------|-------------------|
| 00:00 AM | 5:30 AM |
| 12:00 PM | 5:30 PM |
| 23:30 PM | 5:00 AM (next day) |
| 05:08 AM | 10:38 AM |
| 17:08 PM | 10:38 PM |

## Future Enhancements

If you need to support multiple timezones in the future:
1. Store user's timezone preference
2. Modify `DateTimeUtils.toIST()` to accept timezone parameter
3. Update all formatting methods to use user's timezone
