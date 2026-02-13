# 📱 Flutter Apps Setup Instructions

## Step 1: Clean and Update Dependencies

### Shop Owner App

```bash
cd shop_owner_app
flutter clean
flutter pub get
```

### User App

```bash
cd user_app
flutter clean
flutter pub get
```

## Step 2: Update API Base URL

You need to update the API URL in both apps to point to your backend server.

### For Testing on Emulator/Simulator

Use `http://localhost:3000/api` or `http://10.0.2.2:3000/api` (Android emulator)

### For Testing on Physical Device

Use your computer's IP address, for example: `http://192.168.1.100:3000/api`

**To find your IP address:**

Windows:
```bash
ipconfig
```
Look for "IPv4 Address" under your active network adapter.

Mac/Linux:
```bash
ifconfig
```

### Update the URLs

**Shop Owner App:**

Edit `shop_owner_app/lib/services/cloudinary_upload_service.dart`:
```dart
static const String API_BASE_URL = 'http://YOUR_IP_ADDRESS:3000/api';
```

Edit `shop_owner_app/lib/services/product_api_service.dart`:
```dart
static const String API_BASE_URL = 'http://YOUR_IP_ADDRESS:3000/api';
```

**User App:**

Edit `user_app/lib/services/product_api_service.dart`:
```dart
static const String API_BASE_URL = 'http://YOUR_IP_ADDRESS:3000/api';
```

## Step 3: Delete Firebase Files (if not already done)

### Shop Owner App

Delete these files:
```
shop_owner_app/lib/firebase_options.dart
shop_owner_app/android/app/google-services.json
shop_owner_app/lib/services/firebase_service.dart
shop_owner_app/lib/services/photo_upload_service.dart (old Firebase version)
```

### User App

Delete these files:
```
user_app/lib/firebase_options.dart
user_app/android/app/google-services.json
user_app/lib/services/firebase_service.dart
```

## Step 4: Update Android Permissions (if needed)

Both apps should already have these permissions, but verify:

**File:** `android/app/src/main/AndroidManifest.xml`

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

## Step 5: Run the Apps

### Shop Owner App

```bash
cd shop_owner_app
flutter run
```

### User App

```bash
cd user_app
flutter run
```

## Step 6: Test the Integration

### Test Shop Owner App (Upload Product)

1. Open the shop owner app
2. Navigate to the upload product screen
3. Tap to select an image
4. Fill in product details:
   - Name: Test Product
   - Description: This is a test product
   - Price: 29.99
   - Category: General
   - Stock: 10
5. Tap "Upload Product"
6. Wait for success message

### Test User App (View Products)

1. Open the user app
2. Navigate to products list
3. You should see the product you just uploaded
4. Image should load from Cloudinary
5. Tap on product to see details

## Using the Example Screens

### Shop Owner App - Upload Product

Add this to your navigation:

```dart
import 'package:shop_owner_app/screens/products/upload_product_example.dart';

// Navigate to upload screen
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

### User App - View Products

Add this to your navigation:

```dart
import 'package:user_app/screens/products/products_list_example.dart';

// Navigate to products list
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ProductsListExample(),
  ),
);
```

## Troubleshooting

### "Failed to connect to backend"

1. Ensure backend server is running
2. Check API_BASE_URL is correct
3. If using physical device, ensure phone and computer are on same WiFi
4. Try pinging your computer from phone's browser: `http://YOUR_IP:3000/api/health`

### "Image picker not working"

Android: Check permissions in AndroidManifest.xml
iOS: Add to Info.plist:
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to your photos to upload product images</string>
<key>NSCameraUsageDescription</key>
<string>We need access to your camera to take product photos</string>
```

### "Image not loading"

1. Check if image was uploaded to Cloudinary (check Cloudinary dashboard)
2. Verify imageUrl in database is correct
3. Check internet connection
4. Try opening image URL directly in browser

### "Unhandled Exception: type 'Null' is not a subtype of type 'String'"

This usually means the API response format is different than expected. Check:
1. Backend is returning correct JSON format
2. Product model matches API response
3. Add null safety checks in your code

## Integration with Existing Screens

### Replace Old Firebase Upload Code

**Before (Firebase):**
```dart
final photoService = PhotoUploadService();
final imageUrl = await photoService.uploadProductImage(
  imageFile: imageFile,
  shopName: shopName,
  productName: productName,
);
```

**After (Cloudinary):**
```dart
final uploadService = CloudinaryUploadService();
final result = await uploadService.uploadProduct(
  imageFile: imageFile,
  name: productName,
  description: description,
  price: price,
  shopId: shopId,
  shopName: shopName,
);
```

### Replace Old Firestore Fetch Code

**Before (Firestore):**
```dart
final snapshot = await FirebaseFirestore.instance
    .collection('products')
    .get();
```

**After (REST API):**
```dart
final productService = ProductApiService();
final result = await productService.getProducts();
final products = result['data'];
```

## Performance Tips

1. Use `cached_network_image` for images (already included)
2. Implement pagination for large product lists
3. Add pull-to-refresh functionality
4. Cache API responses locally with shared_preferences
5. Show loading states and error messages

## Next Steps

1. ✅ Apps are running without Firebase
2. ✅ Products can be uploaded with images
3. ✅ Products are displayed from API
4. Implement authentication if needed
5. Add more features (search, filters, etc.)
6. Test on physical devices
7. Build release APKs

## Building Release APK

```bash
cd shop_owner_app
flutter build apk --release

cd ../user_app
flutter build apk --release
```

APKs will be in:
- `shop_owner_app/build/app/outputs/flutter-apk/app-release.apk`
- `user_app/build/app/outputs/flutter-apk/app-release.apk`
