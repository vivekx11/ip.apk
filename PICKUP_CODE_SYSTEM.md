# 🏪 Pickup Code System - Workflow Guide

## 📱 System Overview

A streamlined marketplace system where users discover shops, place orders, and use unique pickup codes for in-person collection and payment.

## 🔄 Complete User Journey

### 1️⃣ User App Flow

**Step 1: Shop Discovery**
- User opens app
- Searches for shops in their area
- Views list of available shop owners
- Browses shop profiles and ratings

**Step 2: Product Browsing**
- Selects a shop from the list
- Views all products available from that shop
- Checks product details, prices, and availability
- Adds desired items to order

**Step 3: Order Placement**
- Reviews order summary
- Places order (no payment yet)
- Receives unique 6-digit pickup code
- Gets shop location and pickup instructions

**Step 4: Shop Visit**
- User visits the physical shop
- Shows 6-digit code to shop owner
- Shop owner verifies the code
- User makes payment at the shop
- Collects the prepared order

### 2️⃣ Shop Owner App Flow

**Step 1: Shop Setup**
- Shop owner lists their shop on the platform
- Adds products with photos, descriptions, and prices
- Sets shop location and operating hours
- Makes shop visible to users

**Step 2: Order Management**
- Receives new orders with pickup codes
- Views order details and customer information
- Accepts the order
- Begins preparing/packing the order

**Step 3: Customer Interaction**
- Customer arrives with 6-digit code
- Shop owner verifies the code in the app
- Confirms order details with customer
- Processes payment (cash/card/digital)
- Marks order as completed
- Hands over the prepared order

## 🔢 Pickup Code System

### Code Generation
- **Format**: 6-digit numeric code (e.g., 123456)
- **Uniqueness**: Each order gets a unique code
- **Validity**: Code expires after pickup or 24 hours
- **Security**: Code is tied to specific user and shop

### Code Verification Process
1. Customer shows code to shop owner
2. Shop owner enters code in app
3. System verifies code validity
4. Displays order details for confirmation
5. Shop owner confirms and processes payment
6. Order marked as completed

## 💳 Payment Flow

### Payment Timing
- **No upfront payment**: Users don't pay when placing order
- **Payment at pickup**: All payment happens at the physical shop
- **Flexible methods**: Cash, card, or digital payments accepted

### Payment Security
- Order is confirmed before payment
- Shop owner can verify order contents
- Customer can inspect items before paying
- Dispute resolution through order history

## 🏗️ Technical Implementation

### Database Schema

**Orders Table**
```sql
orders {
  id: UUID
  user_id: UUID
  shop_id: UUID
  pickup_code: STRING(6)
  status: ENUM(placed, accepted, ready, completed, cancelled)
  total_amount: DECIMAL
  created_at: TIMESTAMP
  expires_at: TIMESTAMP
}
```

**Order Items Table**
```sql
order_items {
  id: UUID
  order_id: UUID
  product_id: UUID
  quantity: INTEGER
  price: DECIMAL
}
```

### API Endpoints

**User App APIs**
```
POST /api/orders/place          # Place order, get pickup code
GET  /api/orders/my-orders      # View user's orders
GET  /api/shops/search          # Search shops
GET  /api/shops/{id}/products   # Get shop products
```

**Shop Owner APIs**
```
GET  /api/orders/pending        # Get pending orders
POST /api/orders/accept         # Accept an order
POST /api/orders/verify-code    # Verify pickup code
POST /api/orders/complete       # Mark order as completed
```

## 🎯 Key Benefits

### For Users
- ✅ Browse multiple shops in one app
- ✅ No upfront payment required
- ✅ Simple pickup process with codes
- ✅ Can inspect items before paying
- ✅ Support local businesses

### For Shop Owners
- ✅ Easy order management
- ✅ Guaranteed payment at pickup
- ✅ No payment processing fees
- ✅ Direct customer interaction
- ✅ Simple verification system

### For the System
- ✅ No payment gateway complexity
- ✅ Reduced fraud risk
- ✅ Simple dispute resolution
- ✅ Local business focus
- ✅ Minimal technical overhead

## 🚀 Implementation Priority

### Phase 1: Core Features
1. Shop discovery and listing
2. Product browsing by shop
3. Order placement with pickup codes
4. Basic code verification

### Phase 2: Enhanced Features
1. Order status tracking
2. Shop ratings and reviews
3. Order history and analytics
4. Push notifications

### Phase 3: Advanced Features
1. Multi-shop orders
2. Scheduled pickups
3. Loyalty programs
4. Advanced analytics

This pickup code system creates a simple, secure, and efficient way for users to discover local shops, place orders, and collect them in person while supporting local businesses.