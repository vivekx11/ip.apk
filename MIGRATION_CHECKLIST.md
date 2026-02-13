# ✅ Firebase to Custom Backend Migration Checklist

## Prerequisites Setup

### MongoDB Atlas
- [ ] Created MongoDB Atlas account at https://www.mongodb.com/cloud/atlas
- [ ] Created a free M0 cluster
- [ ] Created database user with password
- [ ] Whitelisted IP address (0.0.0.0/0 for development)
- [ ] Copied connection string

### Cloudinary
- [ ] Created Cloudinary account at https://cloudinary.com
- [ ] Noted Cloud Name from dashboard
- [ ] Noted API Key from dashboard
- [ ] Noted API Secret from dashboard

### Node.js
- [ ] Installed Node.js (v16 or higher)
- [ ] Verified with `node --version` and `npm --version`

---

## Backend Setup

- [ ] Navigated to `backend` folder
- [ ] Ran `npm install` to install dependencies
- [ ] Copied `.env.example` to `.env`
- [ ] Updated `.env` with MongoDB connection string
- [ ] Updated `.env` with Cloudinary credentials
- [ ] Started server with `npm start`
- [ ] Verified server is running at http://localhost:3000/api/health
- [ ] Tested health endpoint returns `{"status": "OK"}`

---

## Flutter Apps - Remove Firebase

### Shop Owner App

- [ ] Opened `shop_owner_app/pubspec.yaml`
- [ ] Removed Firebase dependencies:
  - [ ] `firebase_core`
  - [ ] `firebase_storage`
  - [ ] `firebase_auth`
  - [ ] `cloud_firestore`
- [ ] Added `http_parser: ^4.0.2` dependency
- [ ] Deleted `lib/firebase_options.dart`
- [ ] Deleted `android/app/google-services.json`
- [ ] Deleted `lib/services/firebase_service.dart`
- [ ] Deleted `lib/services/photo_upload_service.dart` (old Firebase version)
- [ ] Updated `lib/main.dart` to remove Firebase initialization
- [ ] Ran `flutter clean`
- [ ] Ran `flutter pub get`
- [ ] Verified no Firebase import errors

### User App

- [ ] Opened `user_app/pubspec.yaml`
- [ ] Removed Firebase dependencies:
  - [ ] `firebase_core`
  - [ ] `firebase_auth`
  - [ ] `cloud_firestore`
- [ ] Deleted `lib/firebase_options.dart`
- [ ] Deleted `android/app/google-services.json`
- [ ] Deleted `lib/services/firebase_service.dart`
- [ ] Updated `lib/main.dart` to remove Firebase initialization
- [ ] Ran `flutter clean`
- [ ] Ran `flutter pub get`
- [ ] Verified no Firebase import errors

---

## Flutter Apps - Add New Services

### Shop Owner App

- [ ] Created `lib/services/cloudinary_upload_service.dart`
- [ ] Created `lib/services/product_api_service.dart`
- [ ] Updated API_BASE_URL in both services with correct backend URL
- [ ] Created example screen `lib/screens/products/upload_product_example.dart`
- [ ] Tested app compiles without errors

### User App

- [ ] Created `lib/services/product_api_service.dart`
- [ ] Updated API_BASE_URL with correct backend URL
- [ ] Created example screen `lib/screens/products/products_list_example.dart`
- [ ] Tested app compiles without errors

---

## Update API URLs

### Find Your IP Address

Windows:
```bash
ipconfig
```
Look for IPv4 Address (e.g., 192.168.1.100)

### Update URLs in Code

- [ ] Shop Owner App - `cloudinary_upload_service.dart`: Updated API_BASE_URL
- [ ] Shop Owner App - `product_api_service.dart`: Updated API_BASE_URL
- [ ] User App - `product_api_service.dart`: Updated API_BASE_URL

**Format:** `http://YOUR_IP:3000/api` (replace YOUR_IP with actual IP)

---

## Testing

### Backend Testing

- [ ] Server starts without errors
- [ ] Health endpoint responds: http://localhost:3000/api/health
- [ ] MongoDB connection successful (check console logs)
- [ ] Cloudinary configuration loaded (check console logs)

### Shop Owner App Testing

- [ ] App launches without Firebase errors
- [ ] Can navigate to upload product screen
- [ ] Can select image from gallery
- [ ] Can take photo with camera
- [ ] Can fill in product details
- [ ] Upload button works
- [ ] Product uploads successfully
- [ ] Success message appears
- [ ] Image appears in Cloudinary dashboard

### User App Testing

- [ ] App launches without Firebase errors
- [ ] Can navigate to products list
- [ ] Products load from API
- [ ] Images display correctly from Cloudinary
- [ ] Can tap on product to see details
- [ ] Pull to refresh works
- [ ] Empty state shows when no products

### Integration Testing

- [ ] Upload product in shop owner app
- [ ] Product appears in user app within seconds
- [ ] Image loads correctly in user app
- [ ] Product details match what was uploaded
- [ ] Multiple products can be uploaded
- [ ] Products from different shops display correctly

---

## Physical Device Testing

- [ ] Computer and phone on same WiFi network
- [ ] Updated API URLs with computer's IP address
- [ ] Can access backend from phone browser: http://YOUR_IP:3000/api/health
- [ ] Shop owner app can upload products
- [ ] User app can view products
- [ ] Images load on mobile data (if Cloudinary is configured)

---

## Code Migration (Optional)

If you have existing screens using Firebase:

### Replace Firebase Upload Code

- [ ] Found all uses of `PhotoUploadService`
- [ ] Replaced with `CloudinaryUploadService`
- [ ] Updated method calls to match new API
- [ ] Tested each screen after migration

### Replace Firestore Queries

- [ ] Found all uses of `FirebaseFirestore.instance`
- [ ] Replaced with `ProductApiService` calls
- [ ] Updated data parsing to match API response
- [ ] Tested each screen after migration

---

## Cleanup

- [ ] Removed all unused Firebase imports
- [ ] Removed Firebase configuration files
- [ ] Removed Firebase service files
- [ ] Verified no Firebase code remains
- [ ] Ran `flutter analyze` to check for issues
- [ ] Fixed any warnings or errors

---

## Documentation

- [ ] Read `FIREBASE_REMOVAL_GUIDE.md`
- [ ] Read `BACKEND_SETUP_INSTRUCTIONS.md`
- [ ] Read `FLUTTER_SETUP_INSTRUCTIONS.md`
- [ ] Bookmarked API endpoints documentation
- [ ] Noted Cloudinary dashboard URL
- [ ] Noted MongoDB Atlas dashboard URL

---

## Production Preparation (Future)

- [ ] Set up production MongoDB cluster
- [ ] Configure production Cloudinary account
- [ ] Set up backend hosting (Heroku, Railway, etc.)
- [ ] Update Flutter apps with production API URL
- [ ] Enable HTTPS for backend
- [ ] Add authentication/authorization
- [ ] Add rate limiting
- [ ] Set up monitoring and logging
- [ ] Create backup strategy
- [ ] Test on multiple devices
- [ ] Build release APKs

---

## Troubleshooting Reference

### Common Issues

**Backend won't start:**
- Check MongoDB connection string in .env
- Verify Cloudinary credentials
- Ensure port 3000 is not in use

**Flutter can't connect:**
- Verify backend is running
- Check API_BASE_URL is correct
- Ensure phone and computer on same network
- Try accessing health endpoint from phone browser

**Images won't upload:**
- Check Cloudinary credentials
- Verify file size < 10MB
- Check image format (jpg, png, gif, webp)
- Check internet connection

**Images won't display:**
- Verify image uploaded to Cloudinary (check dashboard)
- Check imageUrl in API response
- Ensure cached_network_image is working
- Try opening image URL in browser

---

## Success Criteria

✅ Migration is complete when:

1. Backend server runs without errors
2. Shop owner app can upload products with images
3. Images are stored in Cloudinary
4. Product data is stored in MongoDB
5. User app can fetch and display products
6. Images load correctly from Cloudinary
7. No Firebase dependencies remain
8. Apps work on physical devices
9. All tests pass

---

## Need Help?

- Check `BUILD_TROUBLESHOOTING.md` for build issues
- Check `BACKEND_SETUP_INSTRUCTIONS.md` for backend issues
- Check `FLUTTER_SETUP_INSTRUCTIONS.md` for Flutter issues
- Review API documentation in backend code
- Check Cloudinary documentation: https://cloudinary.com/documentation
- Check MongoDB documentation: https://docs.mongodb.com/

---

**Migration Date:** _______________

**Completed By:** _______________

**Notes:**
_______________________________________
_______________________________________
_______________________________________
