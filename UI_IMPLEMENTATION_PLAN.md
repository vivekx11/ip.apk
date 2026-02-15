# 🎨 UI Implementation Plan - Order System

## ✅ Completed

### Backend
- ✅ User model with auto-generation
- ✅ Order model with 4-digit PIN
- ✅ Complete API endpoints
- ✅ Status flow: Pending → Accepted → Completed

### User App
- ✅ Order service (order_service.dart)
- ✅ Updated Order model with PIN support
- ✅ Cart provider (existing)

## 🚧 To Implement

### USER APP

#### 1. User Initialization Service
**File**: `user_app/lib/services/user_service.dart`
- Auto-create user on first launch
- Store userId locally
- Get/update user profile

#### 2. Update Order Provider
**File**: `user_app/lib/providers/order_provider.dart`
- Use new OrderService instead of Firebase
- Implement place order
- Implement get user orders
- Implement get order by ID

#### 3. Place Order Screen (Updated)
**File**: `user_app/lib/screens/orders/place_order_screen.dart`
- Customer name input
- Notes input
- Place order button
- Show success dialog with order number + PIN

#### 4. Order Success Screen (NEW)
**File**: `user_app/lib/screens/orders/order_success_screen.dart`
- Show order number
- Show 4-digit PIN (large, prominent)
- Show order details
- "View Order" button
- "Back to Home" button

#### 5. Order History Screen (NEW)
**File**: `user_app/lib/screens/orders/order_history_screen.dart`
- List all user orders
- Filter by status (All, Pending, Accepted, Completed)
- Pull to refresh
- Tap to view details

#### 6. Order Details Screen (NEW)
**File**: `user_app/lib/screens/orders/order_details_screen.dart`
- Order number
- Status badge
- 4-digit PIN (if Accepted)
- Items list
- Total amount
- Shop details
- Timestamps
- Status-specific messages

#### 7. Update Main Screen
**File**: `user_app/lib/screens/home/main_screen.dart`
- Add "Orders" tab
- Initialize user on app start

---

### SHOP OWNER APP

#### 1. Order Service (NEW)
**File**: `shop_owner_app/lib/services/order_service.dart`
- Get shop orders by status
- Accept order
- Verify PIN and complete order
- Get order by ID

#### 2. Update Order Provider
**File**: `shop_owner_app/lib/providers/order_provider.dart`
- Use new OrderService
- Implement status updates
- Implement PIN verification

#### 3. Order Management Screen (Updated)
**File**: `shop_owner_app/lib/screens/orders/order_management_screen.dart`
- 3 tabs: Pending, Accepted, Completed
- Show order cards with PIN
- Accept/Reject buttons for Pending
- "Verify PIN" button for Accepted
- Auto-refresh

#### 4. PIN Verification Screen (NEW)
**File**: `shop_owner_app/lib/screens/orders/pin_verification_screen.dart`
- Order ID input
- 4-digit PIN input
- Verify button
- Show success/error
- Mark order as Completed

#### 5. Order Details Screen (NEW)
**File**: `shop_owner_app/lib/screens/orders/order_details_screen.dart`
- Order number
- Customer name
- Items list
- Total amount
- 4-digit PIN (prominent)
- Status
- Action buttons based on status

---

## 🎨 UI Design Guidelines

### Colors (Already defined in AppTheme)
- Primary: `AppTheme.primaryPink` (User) / `AppTheme.primaryIndigo` (Shop Owner)
- Success: `AppTheme.successGreen`
- Warning: `AppTheme.warningOrange`
- Error: `Colors.red`

### Status Colors
- **Pending**: Orange (`AppTheme.warningOrange`)
- **Accepted**: Green (`AppTheme.successGreen`)
- **Completed**: Blue (`AppTheme.primaryIndigo`)
- **Cancelled**: Red (`Colors.red`)

### PIN Display
```dart
Container(
  padding: EdgeInsets.all(24),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [AppTheme.primaryPink, AppTheme.primaryPink.withOpacity(0.8)],
    ),
    borderRadius: BorderRadius.circular(16),
  ),
  child: Column(
    children: [
      Text('Pickup PIN', style: TextStyle(color: Colors.white, fontSize: 16)),
      SizedBox(height: 12),
      Text(
        '1234', // 4-digit PIN
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 8,
        ),
      ),
    ],
  ),
)
```

### Order Card
```dart
Card(
  elevation: 4,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        // Order number + Status badge
        // PIN display (if Accepted)
        // Items summary
        // Total amount
        // Action buttons
      ],
    ),
  ),
)
```

---

## 📱 User Flow

### USER APP FLOW:
```
1. App Opens
   ↓
2. Auto-create/Get User (userId stored locally)
   ↓
3. Browse Products → Add to Cart
   ↓
4. Cart Screen → "Proceed to Checkout"
   ↓
5. Place Order Screen
   - Enter name
   - Add notes (optional)
   - Confirm order
   ↓
6. Order Success Screen
   - Show order number
   - Show 4-digit PIN
   - "Order placed! Wait for shop to accept"
   ↓
7. Order History Screen
   - View all orders
   - Tap to see details
   ↓
8. Order Details Screen
   - If Pending: "Waiting for shop to accept"
   - If Accepted: "Order accepted! Show this PIN at shop"
     → Display PIN prominently
   - If Completed: "Order completed! Thank you"
```

### SHOP OWNER APP FLOW:
```
1. Order Management Screen
   ↓
2. Pending Tab
   - New orders appear
   - Click "Accept" → Status: Accepted
   ↓
3. Accepted Tab
   - Orders waiting for pickup
   - Customer arrives with order number + PIN
   ↓
4. PIN Verification Screen
   - Enter order ID
   - Enter 4-digit PIN
   - Click "Verify"
   ↓
5. If PIN correct:
   - Order marked as Completed
   - Revenue updated
   - Moves to Completed tab
```

---

## 🔧 Implementation Priority

### Phase 1: Core Functionality (Do First)
1. ✅ User service (auto-create user)
2. ✅ Update order provider (both apps)
3. ✅ Place order screen (user app)
4. ✅ Order success screen (user app)
5. ✅ Order management screen (shop owner app)
6. ✅ PIN verification screen (shop owner app)

### Phase 2: Enhanced Features
7. Order history screen (user app)
8. Order details screen (both apps)
9. Pull to refresh
10. Auto-refresh for shop owner

### Phase 3: Polish
11. Loading states
12. Error handling
13. Empty states
14. Animations
15. Notifications (future)

---

## 🧪 Testing Checklist

### User App
- [ ] User auto-creation works
- [ ] Can place order
- [ ] Order success shows PIN
- [ ] Can view order history
- [ ] Order details show correct status
- [ ] PIN visible when Accepted

### Shop Owner App
- [ ] Can see pending orders
- [ ] Can accept orders
- [ ] PIN verification works
- [ ] Correct PIN → Order completed
- [ ] Wrong PIN → Error message
- [ ] Order history shows all orders

---

## 📝 Next Steps

1. Implement User Service
2. Update Order Providers
3. Create Place Order Screen
4. Create Order Success Screen
5. Update Order Management Screen
6. Create PIN Verification Screen
7. Test end-to-end flow
8. Deploy and test on real devices

---

**Ready to implement! Let's build the UI step by step.** 🚀
