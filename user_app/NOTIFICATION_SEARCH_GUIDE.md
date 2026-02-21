# Notification & Search Feature Guide

## Overview
User app mein 2 naye features add kiye gaye hain:
1. **Bell Notification System** - Jab shop owner naya product add kare
2. **Working Search Bar** - Product name ya letters se search kare

---

## 1. Bell Notification System

### Kya Hai?
- Home page aur Shops page pe bell icon (🔔) hai
- Jab shop owner naya product add karta hai, user ko notification milti hai
- Unread notifications ka count red badge mein show hota hai

### Features

#### Notification Bell Icon
- **Location**: Home screen aur Shops screen ke top-right corner
- **Red Badge**: Unread notifications ka count show karta hai
- **Click**: Bell icon pe click karne se notifications screen khulti hai

#### Notifications Screen
- **Product Details**: Product name, image, price, shop name
- **Timestamp**: Kitna time pehle notification aayi (IST mein)
- **Unread Indicator**: Naye notifications pe pink dot
- **Actions**:
  - Swipe left to delete
  - Tap to mark as read
  - "Mark all as read" button
  - "Clear all" button

### Files Created

1. **Models**
   - `lib/models/notification_model.dart` - Notification data structure

2. **Services**
   - `lib/services/notification_service.dart` - Notification management

3. **Screens**
   - `lib/screens/home/notifications_screen.dart` - Notifications UI

4. **Utils**
   - `lib/utils/notification_helper.dart` - Testing helper

### How It Works

```dart
// When shop owner adds a product, create notification
await NotificationService().simulateNewProductNotification(
  shopId: 'shop123',
  shopName: 'Fresh Mart',
  productId: 'prod456',
  productName: 'Organic Apples',
  productImage: 'https://...',
  productPrice: 150.00,
);
```

### Testing Notifications

Testing ke liye sample notifications create karne ke liye:

```dart
import 'package:user_app/utils/notification_helper.dart';

// Create 3 sample notifications
await NotificationHelper.createSampleNotifications();
```

Ya individual notification:

```dart
await NotificationHelper.simulateNewProduct(
  shopId: 'shop1',
  shopName: 'Tech Hub',
  productId: 'prod1',
  productName: 'Wireless Mouse',
  productImage: '',
  productPrice: 599.00,
);
```

---

## 2. Working Search Bar

### Kya Hai?
- Home page pe search bar ab fully functional hai
- Product name, shop name, ya description se search kar sakte hain
- Real-time search - type karte hi results filter hote hain

### Features

#### Search Functionality
- **Real-time Search**: Har letter type karne pe results update hote hain
- **Search Fields**: Product name, shop name, description
- **Case Insensitive**: Capital/small letters ka fark nahi padta
- **Clear Button**: Search clear karne ke liye (X icon)

#### Search Behavior
- Type karo: Results automatically filter hote hain
- Empty search: Sab products show hote hain
- No results: "No products found" message with clear button

### Example Searches

| Search Query | Results |
|--------------|---------|
| "apple" | Products with "apple" in name/description |
| "fresh" | Products from "Fresh Mart" shop |
| "tech" | Products from "Tech Hub" or tech-related items |
| "500" | Products with "500" in name/description |

### Code Changes

**Home Screen** (`lib/screens/home/home_screen.dart`):
- Added `_searchQuery` state variable
- Added `_onSearchChanged()` method
- Search filter applied to products list
- Clear button in search field
- Better empty state with search-specific messages

---

## Integration with Backend

### When Shop Owner Adds Product

Backend se notification trigger karne ke liye:

```javascript
// Backend: routes/products.js
router.post('/add', async (req, res) => {
  // ... product creation code ...
  
  // After product is created successfully
  const product = await Product.create(productData);
  
  // Trigger notification to all users
  // (You can implement push notifications here)
  
  res.json({ success: true, product });
});
```

### Future Enhancements

1. **Push Notifications**: Firebase Cloud Messaging (FCM) integration
2. **User Preferences**: Choose which shops to get notifications from
3. **Notification Categories**: Filter by product category
4. **In-app Notification Badge**: Show on app icon

---

## User Flow

### Notification Flow
1. Shop owner adds new product
2. Notification created automatically
3. Bell icon shows red badge with count
4. User clicks bell icon
5. Notifications screen opens
6. User sees new product notification
7. User can tap to view details or swipe to delete

### Search Flow
1. User opens home screen
2. Types in search bar
3. Products filter in real-time
4. User sees matching products
5. User can clear search to see all products

---

## UI/UX Details

### Notification Bell
- **Icon**: `Icons.notifications_outlined`
- **Badge Color**: Red (`AppTheme.errorRed`)
- **Badge Position**: Top-right of bell icon
- **Badge Text**: Count (shows "9+" if more than 9)

### Notification Card
- **Unread**: Pink border, bold text, pink dot
- **Read**: Normal border, regular text, no dot
- **Swipe**: Left swipe to delete
- **Tap**: Mark as read

### Search Bar
- **Icon**: Search icon (left), Clear icon (right)
- **Placeholder**: "Search products or shops..."
- **Style**: Rounded white background on pink header
- **Behavior**: Real-time filtering

---

## Testing Checklist

### Notification Testing
- [ ] Bell icon visible on home screen
- [ ] Bell icon visible on shops screen
- [ ] Badge shows correct unread count
- [ ] Clicking bell opens notifications screen
- [ ] Notifications display correctly
- [ ] Mark as read works
- [ ] Swipe to delete works
- [ ] Clear all works
- [ ] Timestamps show in IST

### Search Testing
- [ ] Search bar visible on home screen
- [ ] Typing filters products in real-time
- [ ] Search is case-insensitive
- [ ] Clear button appears when typing
- [ ] Clear button clears search
- [ ] Empty state shows correct message
- [ ] Search works for product names
- [ ] Search works for shop names
- [ ] Search works for descriptions

---

## Troubleshooting

### Notifications Not Showing
1. Check if notifications are being created
2. Verify SharedPreferences is working
3. Check notification service initialization

### Search Not Working
1. Verify `_searchQuery` state is updating
2. Check if products list is being filtered
3. Ensure `_onSearchChanged` is called

### Badge Count Wrong
1. Call `_loadUnreadNotifications()` after viewing notifications
2. Check if notifications are marked as read correctly

---

## Files Modified

1. ✅ `lib/screens/home/home_screen.dart` - Added bell icon & search
2. ✅ `lib/screens/home/shops_screen.dart` - Added bell icon
3. ✅ `lib/models/notification_model.dart` - New file
4. ✅ `lib/services/notification_service.dart` - New file
5. ✅ `lib/screens/home/notifications_screen.dart` - New file
6. ✅ `lib/utils/notification_helper.dart` - New file

---

## Next Steps

1. **Backend Integration**: Connect with real product creation events
2. **Push Notifications**: Add FCM for background notifications
3. **User Settings**: Let users customize notification preferences
4. **Advanced Search**: Add filters (price range, category, etc.)
5. **Search History**: Save recent searches
