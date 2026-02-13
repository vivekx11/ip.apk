# 🎯 Custom Backend Migration - Complete Guide

## 📖 Overview

This guide helps you migrate from Firebase to a custom backend solution using:

- **Backend:** Node.js + Express + MongoDB + Cloudinary
- **Database:** MongoDB Atlas (cloud-hosted, free tier available)
- **Image Storage:** Cloudinary (cloud-hosted, free tier available)
- **Flutter Apps:** Updated to use REST APIs instead of Firebase

---

## 🗂️ Project Structure

```
project/
├── backend/
│   ├── config/
│   │   └── cloudinary.js          # Cloudinary configuration
│   ├── models/
│   │   ├── Product.js              # Product schema
│   │   ├── Shop.js                 # Shop schema
│   │   └── Order.js                # Order schema
│   ├── routes/
│   │   ├── products.js             # Product CRUD endpoints
│   │   ├── upload.js               # Image upload endpoints
│   │   ├── shops.js                # Shop endpoints
│   │   └── orders.js               # Order endpoints
│   ├── .env.example                # Environment variables template
│   ├── .env                        # Your actual config (create this)
│   ├── package.json                # Node.js dependencies
│   └── server.js                   # Main server file
│
├── shop_owner_app/
│   └── lib/
│       ├── services/
│       │   ├── cloudinary_upload_service.dart  # Upload products
│       │   └── product_api_service.dart        # Product API calls
│       └── screens/
│           └── products/
│               └── upload_product_example.dart # Example upload screen
│
├── user_app/
│   └── lib/
│       ├── services/
│       │   └── product_api_service.dart        # Fetch products
│       └── screens/
│           └── products/
│               └── products_list_example.dart  # Example list screen
│
└── Documentation/
    ├── FIREBASE_REMOVAL_GUIDE.md           # How to remove Firebase
    ├── BACKEND_SETUP_INSTRUCTIONS.md       # Backend setup steps
    ├── FLUTTER_SETUP_INSTRUCTIONS.md       # Flutter setup steps
    ├── MIGRATION_CHECKLIST.md              # Step-by-step checklist
    └── CUSTOM_BACKEND_README.md            # This file
```

---

## 🚀 Quick Start (5 Steps)

### Step 1: Get Your Credentials

**MongoDB Atlas:**
1. Sign up at https://www.mongodb.com/cloud/atlas
2. Create free cluster
3. Get connection string

**Cloudinary:**
1. Sign up at https://cloudinary.com
2. Get Cloud Name, API Key, API Secret from dashboard

### Step 2: Setup Backend

```bash
# Run the setup script
setup_backend.bat

# Edit backend/.env with your credentials

# Start the server
start_backend.bat
```

### Step 3: Remove Firebase from Flutter

**Shop Owner App:**
```bash
cd shop_owner_app
flutter clean
flutter pub get
```

**User App:**
```bash
cd user_app
flutter clean
flutter pub get
```

### Step 4: Update API URLs

Find your IP address:
```bash
ipconfig
```

Update these files with your IP:
- `shop_owner_app/lib/services/cloudinary_upload_service.dart`
- `shop_owner_app/lib/services/product_api_service.dart`
- `user_app/lib/services/product_api_service.dart`

Change:
```dart
static const String API_BASE_URL = 'http://YOUR_IP:3000/api';
```

### Step 5: Test Everything

1. Start backend server
2. Run shop owner app - upload a product
3. Run user app - see the product appear

---

## 📚 Detailed Documentation

### For Backend Setup
👉 Read: `BACKEND_SETUP_INSTRUCTIONS.md`

Covers:
- Installing Node.js dependencies
- Configuring MongoDB and Cloudinary
- Starting the server
- Testing API endpoints
- Troubleshooting

### For Firebase Removal
👉 Read: `FIREBASE_REMOVAL_GUIDE.md`

Covers:
- Removing Firebase dependencies
- Deleting Firebase files
- Updating main.dart files
- Running flutter clean

### For Flutter Integration
👉 Read: `FLUTTER_SETUP_INSTRUCTIONS.md`

Covers:
- Updating dependencies
- Configuring API URLs
- Using new services
- Testing on devices
- Building release APKs

### For Step-by-Step Migration
👉 Read: `MIGRATION_CHECKLIST.md`

A complete checklist with checkboxes for every step.

---

## 🔌 API Endpoints

### Products

**Get all products:**
```
GET /api/products
Query params: shopId, category, search, isAvailable, page, limit
```

**Get single product:**
```
GET /api/products/:id
```

**Upload product with image:**
```
POST /api/upload/product
Content-Type: multipart/form-data
Body:
  - image: (file)
  - name: string
  - description: string
  - price: number
  - shopId: string
  - shopName: string
  - category: string (optional)
  - stock: number (optional)
  - unit: string (optional)
```

**Update product:**
```
PUT /api/products/:id
Content-Type: application/json
Body: { field: value, ... }
```

**Delete product:**
```
DELETE /api/products/:id
```

**Toggle availability:**
```
PUT /api/products/:id/toggle-availability
```

### Upload

**Add more images to product:**
```
POST /api/upload/product/:id/images
Content-Type: multipart/form-data
Body: images[] (multiple files)
```

**Delete image:**
```
DELETE /api/upload/image
Content-Type: application/json
Body: { imageUrl: string }
```

---

## 💻 Code Examples

### Shop Owner App - Upload Product

```dart
import 'package:shop_owner_app/services/cloudinary_upload_service.dart';

final uploadService = CloudinaryUploadService();

// Pick image
final image = await uploadService.pickImageFromGallery();

if (image != null) {
  // Upload product
  final result = await uploadService.uploadProduct(
    imageFile: image,
    name: 'Product Name',
    description: 'Product description',
    price: 29.99,
    shopId: 'your_shop_id',
    shopName: 'Your Shop',
    category: 'General',
    stock: 10,
    unit: 'piece',
  );
  
  print('Product uploaded: ${result['data']['product']['id']}');
}
```

### User App - Fetch Products

```dart
import 'package:user_app/services/product_api_service.dart';

final productService = ProductApiService();

// Get all products
final result = await productService.getProducts(
  isAvailable: true,
  limit: 20,
);

final products = result['data'];

// Display in ListView
ListView.builder(
  itemCount: products.length,
  itemBuilder: (context, index) {
    final product = products[index];
    return ListTile(
      leading: Image.network(product['imageUrl']),
      title: Text(product['name']),
      subtitle: Text('\$${product['price']}'),
    );
  },
);
```

---

## 🎨 Example Screens

### Shop Owner App

Use the example upload screen:

```dart
import 'package:shop_owner_app/screens/products/upload_product_example.dart';

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => UploadProductExample(
      shopId: 'your_shop_id',
      shopName: 'Your Shop Name',
    ),
  ),
);
```

### User App

Use the example products list:

```dart
import 'package:user_app/screens/products/products_list_example.dart';

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ProductsListExample(),
  ),
);
```

---

## 🔧 Configuration

### Backend (.env file)

```env
PORT=3000
NODE_ENV=development

MONGODB_URI=mongodb+srv://user:pass@cluster.mongodb.net/marketplace
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret

JWT_SECRET=your_secret_key
ALLOWED_ORIGINS=http://localhost:3000
```

### Flutter (API URLs)

**For Emulator:**
```dart
static const String API_BASE_URL = 'http://10.0.2.2:3000/api';
```

**For Physical Device:**
```dart
static const String API_BASE_URL = 'http://192.168.1.100:3000/api';
```

---

## 🐛 Troubleshooting

### Backend Issues

**MongoDB connection failed:**
- Check connection string format
- Verify username and password
- Whitelist IP in MongoDB Atlas

**Cloudinary upload failed:**
- Verify credentials in .env
- Check file size (max 10MB)
- Ensure supported format (jpg, png, gif, webp)

**Port already in use:**
```bash
netstat -ano | findstr :3000
taskkill /PID <PID> /F
```

### Flutter Issues

**Can't connect to backend:**
- Ensure backend is running
- Check API_BASE_URL is correct
- Phone and computer on same WiFi
- Test: http://YOUR_IP:3000/api/health in phone browser

**Image picker not working:**
- Check AndroidManifest.xml permissions
- Add iOS Info.plist permissions

**Images not loading:**
- Verify upload to Cloudinary (check dashboard)
- Check imageUrl in API response
- Test URL directly in browser

---

## ✅ Testing Checklist

- [ ] Backend server starts successfully
- [ ] Health endpoint responds: http://localhost:3000/api/health
- [ ] MongoDB connection successful
- [ ] Cloudinary credentials valid
- [ ] Shop owner app compiles without errors
- [ ] User app compiles without errors
- [ ] Can upload product with image
- [ ] Image appears in Cloudinary dashboard
- [ ] Product appears in MongoDB
- [ ] User app fetches products
- [ ] Images display correctly
- [ ] Works on physical device

---

## 📦 Dependencies

### Backend (Node.js)

```json
{
  "express": "^4.18.2",
  "mongoose": "^7.5.0",
  "cloudinary": "^1.41.0",
  "multer": "^1.4.5-lts.1",
  "multer-storage-cloudinary": "^4.0.0",
  "cors": "^2.8.5",
  "dotenv": "^16.3.1"
}
```

### Flutter (Both Apps)

```yaml
dependencies:
  http: ^1.1.0
  http_parser: ^4.0.2  # Shop owner app only
  image_picker: ^1.0.4  # Shop owner app only
  cached_network_image: ^3.3.0
  provider: ^6.1.1
```

---

## 🚀 Production Deployment

### Backend Hosting Options

1. **Heroku** (easiest)
   - Free tier available
   - Automatic deployments from Git
   - Built-in environment variables

2. **Railway** (modern)
   - Free tier available
   - Simple deployment
   - Good for Node.js

3. **DigitalOcean** (flexible)
   - $5/month droplet
   - Full control
   - Requires more setup

### Flutter Release Builds

```bash
# Shop Owner App
cd shop_owner_app
flutter build apk --release

# User App
cd user_app
flutter build apk --release
```

---

## 📊 Comparison: Firebase vs Custom Backend

| Feature | Firebase | Custom Backend |
|---------|----------|----------------|
| Cost | Free tier limited | Free tier generous |
| Control | Limited | Full control |
| Customization | Limited | Unlimited |
| Learning curve | Easy | Moderate |
| Scalability | Automatic | Manual |
| Vendor lock-in | Yes | No |
| Image storage | Firebase Storage | Cloudinary |
| Database | Firestore | MongoDB |
| API | SDK | REST API |

---

## 🎓 Learning Resources

### MongoDB
- Official Docs: https://docs.mongodb.com/
- MongoDB University: https://university.mongodb.com/

### Cloudinary
- Documentation: https://cloudinary.com/documentation
- Image Transformations: https://cloudinary.com/documentation/image_transformations

### Node.js & Express
- Express Guide: https://expressjs.com/en/guide/routing.html
- Node.js Docs: https://nodejs.org/en/docs/

### Flutter HTTP
- http package: https://pub.dev/packages/http
- Networking: https://docs.flutter.dev/cookbook/networking

---

## 🤝 Support

If you encounter issues:

1. Check the troubleshooting sections in documentation
2. Verify all configuration files are correct
3. Check console logs for error messages
4. Test API endpoints with Postman
5. Ensure all dependencies are installed

---

## 📝 License

This project is provided as-is for educational purposes.

---

## 🎉 Success!

Once everything is working:

✅ You have a fully functional custom backend
✅ No Firebase dependencies
✅ Full control over your data
✅ Scalable architecture
✅ Cost-effective solution
✅ Production-ready foundation

**Happy coding!** 🚀
