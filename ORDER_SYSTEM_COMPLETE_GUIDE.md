# 📦 Complete Order System Guide

## System Overview

This is a complete order management system for InstantPick with:
- **User App**: Browse products, place orders, track status
- **Shop Owner App**: Manage orders, accept/complete orders
- **Backend**: Node.js + Express + MongoDB

---

## 🗄️ Database Models

### 1. User Model (`backend/models/User.js`)

```javascript
{
  userId: String (unique, auto-generated),
  name: String (default: "Guest User"),
  phone: String,
  email: String,
  totalOrders: Number,
  totalSpent: Number,
  isActive: Boolean,
  createdAt: Date,
  updatedAt: Date
}
```

**Auto-generation**: `USER{timestamp}{random}` (e.g., `USER7234561234`)

### 2. Shop Model (`backend/models/Shop.js`)

```javascript
{
  _id: ObjectId,
  name: String,
  description: String,
  category: Enum,
  address: String,
  phone: String,
  ownerName: String,
  ownerId: String,
  imageUrl: String,
  isActive: Boolean,
  isApproved: Boolean,
  isOpen: Boolean,
  rating: Number,
  totalOrders: Number,
  totalRevenue: Number
}
```

### 3. Product Model (`backend/models/Product.js`)

```javascript
{
  _id: ObjectId,
  name: String,
  description: String,
  price: Number,
  shopId: String,
  shopName: String,
  category: String,
  imageUrls: [String],
  isAvailable: Boolean,
  stock: Number,
  unit: Enum
}
```

### 4. Order Model (`backend/models/Order.js`)

```javascript
{
  _id: ObjectId,
  userId: String (required),
  shopId: ObjectId (required),
  shopName: String,
  shopAddress: String,
  items: [{
    productId: ObjectId,
    productName: String,
    price: Number,
    quantity: Number,
    productImage: String
  }],
  totalAmount: Number,
  pickupPin: String (4-digit),
  status: Enum ['Pending', 'Accepted', 'Completed', 'Cancelled'],
  notes: String,
  customerName: String,
  expiresAt: Date (24 hours),
  acceptedAt: Date,
  completedAt: Date,
  cancelledAt: Date,
  cancellationReason: String,
  createdAt: Date,
  updatedAt: Date
}
```

**Virtual Fields**:
- `orderNumber`: Formatted order ID (e.g., `ORD12AB34CD`)
- `isExpired`: Boolean
- `timeRemaining`: Human-readable time

---

## 🔌 API Endpoints

### User Management

#### 1. Initialize/Get User
```http
POST /api/users/init
Content-Type: application/json

{
  "userId": "USER123456789" // Optional, omit for new user
}

Response:
{
  "success": true,
  "message": "New user created",
  "data": {
    "userId": "USER123456789",
    "name": "Guest User",
    "totalOrders": 0,
    "totalSpent": 0
  }
}
```

#### 2. Get User Details
```http
GET /api/users/:userId

Response:
{
  "success": true,
  "data": {
    "userId": "USER123456789",
    "name": "John Doe",
    "phone": "1234567890",
    "totalOrders": 5,
    "totalSpent": 2500
  }
}
```

#### 3. Update User Profile
```http
PUT /api/users/:userId
Content-Type: application/json

{
  "name": "John Doe",
  "phone": "1234567890",
  "email": "john@example.com"
}
```

### Order Management

#### 1. Place Order
```http
POST /api/orders
Content-Type: application/json

{
  "userId": "USER123456789",
  "shopId": "507f1f77bcf86cd799439011",
  "items": [
    {
      "productId": "507f1f77bcf86cd799439012",
      "productName": "Product 1",
      "price": 100,
      "quantity": 2,
      "productImage": "https://..."
    }
  ],
  "totalAmount": 200,
  "notes": "Please pack carefully",
  "customerName": "John Doe"
}

Response:
{
  "success": true,
  "message": "Order placed successfully",
  "data": {
    "orderId": "507f1f77bcf86cd799439013",
    "orderNumber": "ORD12AB34CD",
    "pickupPin": "1234",
    "status": "Pending",
    "totalAmount": 200,
    "shopName": "My Shop",
    "createdAt": "2024-01-15T10:30:00.000Z"
  }
}
```

#### 2. Get Shop Orders
```http
GET /api/orders/shop/:shopId?status=Pending&page=1&limit=20

Response:
{
  "success": true,
  "data": [
    {
      "_id": "507f1f77bcf86cd799439013",
      "orderNumber": "ORD12AB34CD",
      "userId": "USER123456789",
      "customerName": "John Doe",
      "items": [...],
      "totalAmount": 200,
      "pickupPin": "1234",
      "status": "Pending",
      "createdAt": "2024-01-15T10:30:00.000Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 5,
    "pages": 1
  }
}
```

#### 3. Get User Orders
```http
GET /api/orders/user/:userId?page=1&limit=20

Response: Same as shop orders
```

#### 4. Get Order by ID
```http
GET /api/orders/:orderId

Response:
{
  "success": true,
  "data": {
    "_id": "507f1f77bcf86cd799439013",
    "orderNumber": "ORD12AB34CD",
    "userId": "USER123456789",
    "shopId": {...},
    "items": [...],
    "totalAmount": 200,
    "pickupPin": "1234",
    "status": "Pending"
  }
}
```

#### 5. Update Order Status (Shop Owner)
```http
PUT /api/orders/:orderId/status
Content-Type: application/json

{
  "status": "Accepted" // or "Cancelled"
}

Response:
{
  "success": true,
  "message": "Order accepted successfully",
  "data": {
    "orderId": "507f1f77bcf86cd799439013",
    "orderNumber": "ORD12AB34CD",
    "status": "Accepted",
    "pickupPin": "1234"
  }
}
```

#### 6. Verify PIN for Pickup
```http
POST /api/orders/verify-pin
Content-Type: application/json

{
  "orderId": "507f1f77bcf86cd799439013",
  "pickupPin": "1234"
}

Response:
{
  "success": true,
  "message": "Order completed successfully",
  "data": {
    "orderId": "507f1f77bcf86cd799439013",
    "orderNumber": "ORD12AB34CD",
    "status": "Completed",
    "completedAt": "2024-01-15T11:00:00.000Z"
  }
}
```

---

## 📱 Complete Order Flow

### USER SIDE

#### Step 1: App Opens (First Time)
```dart
// User app initialization
Future<void> initializeUser() async {
  // Check if userId exists locally
  String? savedUserId = await storage.read('userId');
  
  // Call backend to get or create user
  final response = await http.post(
    Uri.parse('$API_URL/users/init'),
    body: json.encode({'userId': savedUserId}),
  );
  
  final data = json.decode(response.body);
  String userId = data['data']['userId'];
  
  // Save userId locally
  await storage.write('userId', userId);
}
```

#### Step 2: Browse Products & Add to Cart
```dart
// Add products to cart (local storage)
List<CartItem> cart = [];
cart.add(CartItem(
  productId: product.id,
  productName: product.name,
  price: product.price,
  quantity: 1,
  productImage: product.imageUrl,
));
```

#### Step 3: Place Order
```dart
Future<void> placeOrder() async {
  String userId = await storage.read('userId');
  
  final orderData = {
    'userId': userId,
    'shopId': selectedShop.id,
    'items': cart.map((item) => {
      'productId': item.productId,
      'productName': item.productName,
      'price': item.price,
      'quantity': item.quantity,
      'productImage': item.productImage,
    }).toList(),
    'totalAmount': calculateTotal(),
    'customerName': userName,
    'notes': notesController.text,
  };
  
  final response = await http.post(
    Uri.parse('$API_URL/orders'),
    body: json.encode(orderData),
  );
  
  final data = json.decode(response.body);
  
  // Show success with order details
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Order Placed!'),
      content: Column(
        children: [
          Text('Order Number: ${data['data']['orderNumber']}'),
          Text('Status: ${data['data']['status']}'),
          Text('Total: ₹${data['data']['totalAmount']}'),
        ],
      ),
    ),
  );
  
  // Clear cart
  cart.clear();
}
```

#### Step 4: Check Order Status
```dart
Future<void> checkOrderStatus(String orderId) async {
  final response = await http.get(
    Uri.parse('$API_URL/orders/$orderId'),
  );
  
  final data = json.decode(response.body);
  Order order = Order.fromJson(data['data']);
  
  if (order.status == 'Accepted') {
    // Show PIN dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order Accepted! 🎉'),
        content: Column(
          children: [
            Text('Show this at shop:'),
            SizedBox(height: 20),
            Text(
              'Order: ${order.orderNumber}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'PIN: ${order.pickupPin}',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
```

#### Step 5: View Order History
```dart
Future<List<Order>> getMyOrders() async {
  String userId = await storage.read('userId');
  
  final response = await http.get(
    Uri.parse('$API_URL/orders/user/$userId'),
  );
  
  final data = json.decode(response.body);
  return (data['data'] as List)
      .map((json) => Order.fromJson(json))
      .toList();
}
```

### SHOP OWNER SIDE

#### Step 1: View Pending Orders
```dart
Future<List<Order>> getPendingOrders() async {
  String shopId = await storage.read('shopId');
  
  final response = await http.get(
    Uri.parse('$API_URL/orders/shop/$shopId?status=Pending'),
  );
  
  final data = json.decode(response.body);
  return (data['data'] as List)
      .map((json) => Order.fromJson(json))
      .toList();
}
```

#### Step 2: Accept Order
```dart
Future<void> acceptOrder(String orderId) async {
  final response = await http.put(
    Uri.parse('$API_URL/orders/$orderId/status'),
    body: json.encode({'status': 'Accepted'}),
  );
  
  if (response.statusCode == 200) {
    showSnackBar('Order accepted successfully');
    refreshOrders();
  }
}
```

#### Step 3: Verify PIN & Complete Order
```dart
Future<void> completeOrder(String orderId, String pin) async {
  final response = await http.post(
    Uri.parse('$API_URL/orders/verify-pin'),
    body: json.encode({
      'orderId': orderId,
      'pickupPin': pin,
    }),
  );
  
  final data = json.decode(response.body);
  
  if (data['success']) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order Completed! ✅'),
        content: Text('Payment received. Order marked as completed.'),
      ),
    );
    refreshOrders();
  } else {
    showSnackBar('Invalid PIN: ${data['message']}');
  }
}
```

---

## 🔄 Order Status Flow

```
Pending → Accepted → Completed
   ↓         ↓
Cancelled  Cancelled
```

### Valid Transitions:
- **Pending** → Accepted, Cancelled
- **Accepted** → Completed, Cancelled
- **Completed** → (Final state)
- **Cancelled** → (Final state)

---

## 🎯 Key Features

### 1. Auto User Creation
- No registration required
- Unique userId generated automatically
- Stored locally on device

### 2. Simple 4-Digit PIN
- Easy to remember
- Easy to communicate
- Secure enough for pickup verification

### 3. Order Tracking
- Real-time status updates
- Order history for both users and shops
- Clear status messages

### 4. Shop Management
- View all orders by status
- Accept/reject orders
- Track revenue and order count

### 5. Security
- PIN verification for pickup
- Status transition validation
- Order expiration (24 hours)

---

## 🚀 Testing the System

### 1. Test User Flow
```bash
# Initialize user
curl -X POST http://localhost:3000/api/users/init \
  -H "Content-Type: application/json"

# Place order
curl -X POST http://localhost:3000/api/orders \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "USER123456789",
    "shopId": "507f1f77bcf86cd799439011",
    "items": [{"productId": "xxx", "productName": "Test", "price": 100, "quantity": 1}],
    "totalAmount": 100,
    "customerName": "Test User"
  }'
```

### 2. Test Shop Owner Flow
```bash
# Get pending orders
curl http://localhost:3000/api/orders/shop/507f1f77bcf86cd799439011?status=Pending

# Accept order
curl -X PUT http://localhost:3000/api/orders/ORDER_ID/status \
  -H "Content-Type: application/json" \
  -d '{"status": "Accepted"}'

# Complete order with PIN
curl -X POST http://localhost:3000/api/orders/verify-pin \
  -H "Content-Type: application/json" \
  -d '{"orderId": "ORDER_ID", "pickupPin": "1234"}'
```

---

## 📝 Next Steps

1. **Deploy Backend**: Push to GitHub and deploy on Render
2. **Update Flutter Apps**: Implement the order flow in both apps
3. **Test End-to-End**: Test complete flow from order to pickup
4. **Add Notifications**: Push notifications for order status changes
5. **Add Analytics**: Track order metrics and shop performance

---

## 🛠️ Troubleshooting

### Common Issues:

1. **Order not found**: Check if orderId is correct
2. **Invalid PIN**: Ensure PIN is exactly 4 digits
3. **Status transition error**: Check current status before updating
4. **Shop not found**: Verify shopId exists in database

---

## 📚 Additional Resources

- MongoDB Documentation: https://docs.mongodb.com/
- Express.js Guide: https://expressjs.com/
- Flutter HTTP Package: https://pub.dev/packages/http
- Mongoose Models: https://mongoosejs.com/docs/models.html

---

**System is ready to use! 🎉**
