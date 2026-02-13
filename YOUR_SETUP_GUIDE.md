# 🎯 Your Personal Setup Guide

## ✅ MongoDB Atlas - Already Configured!

Your MongoDB connection string has been added to `backend/.env`:

```
mongodb+srv://viveksawji06_db_user:<db_password>@cluster0.ryerrti.mongodb.net/marketplace
```

### ⚠️ IMPORTANT: Replace Password

You need to replace `<db_password>` with your actual database password.

**Steps:**

1. Open `backend/.env` file
2. Find the line with `MONGODB_URI`
3. Replace `<db_password>` with your actual password
4. Save the file

**Example:**
```env
# If your password is "MySecurePass123"
MONGODB_URI=mongodb+srv://viveksawji06_db_user:MySecurePass123@cluster0.ryerrti.mongodb.net/marketplace?retryWrites=true&w=majority
```

**⚠️ Security Note:** Never commit your `.env` file to Git! It's already in `.gitignore`.

---

## 🎨 Next Step: Cloudinary Setup

You still need to set up Cloudinary for image storage.

### 1. Sign Up for Cloudinary (Free)

1. Go to: https://cloudinary.com/users/register/free
2. Sign up with your email
3. Verify your email

### 2. Get Your Credentials

After signing in:

1. Go to Dashboard: https://cloudinary.com/console
2. You'll see:
   - **Cloud Name** (e.g., `dxyz123abc`)
   - **API Key** (e.g., `123456789012345`)
   - **API Secret** (e.g., `abcdefghijklmnopqrstuvwxyz`)

### 3. Update backend/.env

Replace these lines in `backend/.env`:

```env
CLOUDINARY_CLOUD_NAME=your_actual_cloud_name
CLOUDINARY_API_KEY=your_actual_api_key
CLOUDINARY_API_SECRET=your_actual_api_secret
```

**Example:**
```env
CLOUDINARY_CLOUD_NAME=dxyz123abc
CLOUDINARY_API_KEY=123456789012345
CLOUDINARY_API_SECRET=abcdefghijklmnopqrstuvwxyz
```

---

## 🚀 Start Your Backend

Once you've updated both MongoDB password and Cloudinary credentials:

### Windows:
```bash
cd backend
npm install
npm start
```

### Or use the helper script:
```bash
start_backend.bat
```

You should see:
```
✅ MongoDB connected successfully
🚀 Server running on port 3001
📱 API Base URL: http://localhost:3001/api
🏥 Health Check: http://localhost:3001/api/health
```

---

## 🧪 Test Your Setup

### 1. Test Backend Health

Open in browser or use curl:
```
http://localhost:3001/api/health
```

Should return:
```json
{
  "status": "OK",
  "message": "Marketplace API is running",
  "timestamp": "2024-02-11T..."
}
```

### 2. Test MongoDB Connection

If the server starts without errors and you see "MongoDB connected successfully", your MongoDB is working!

### 3. Test Cloudinary (After Flutter Setup)

You'll test this when you upload your first product from the shop owner app.

---

## 📱 Update Flutter Apps

### Find Your Computer's IP Address

**Windows:**
```bash
ipconfig
```

Look for "IPv4 Address" under your active network adapter (e.g., `192.168.1.100`)

### Update API URLs in Flutter

You need to update these 3 files:

**1. Shop Owner App - Upload Service**
File: `shop_owner_app/lib/services/cloudinary_upload_service.dart`

Change line 15:
```dart
static const String API_BASE_URL = 'http://YOUR_IP:3001/api';
```

Example:
```dart
static const String API_BASE_URL = 'http://192.168.1.100:3001/api';
```

**2. Shop Owner App - Product Service**
File: `shop_owner_app/lib/services/product_api_service.dart`

Change line 10:
```dart
static const String API_BASE_URL = 'http://YOUR_IP:3001/api';
```

**3. User App - Product Service**
File: `user_app/lib/services/product_api_service.dart`

Change line 13:
```dart
static const String API_BASE_URL = 'http://YOUR_IP:3001/api';
```

### Run Flutter Apps

**Shop Owner App:**
```bash
cd shop_owner_app
flutter clean
flutter pub get
flutter run
```

**User App:**
```bash
cd user_app
flutter clean
flutter pub get
flutter run
```

---

## ✅ Your Complete Checklist

### Backend Setup
- [x] MongoDB Atlas connection string added
- [ ] Replace `<db_password>` with actual password in `backend/.env`
- [ ] Sign up for Cloudinary
- [ ] Add Cloudinary credentials to `backend/.env`
- [ ] Run `npm install` in backend folder
- [ ] Start backend with `npm start`
- [ ] Test health endpoint

### Flutter Setup
- [ ] Find your computer's IP address
- [ ] Update API_BASE_URL in `cloudinary_upload_service.dart`
- [ ] Update API_BASE_URL in `product_api_service.dart` (shop owner)
- [ ] Update API_BASE_URL in `product_api_service.dart` (user app)
- [ ] Run `flutter clean && flutter pub get` in both apps
- [ ] Test shop owner app
- [ ] Test user app

### Testing
- [ ] Backend health check works
- [ ] Upload product from shop owner app
- [ ] Image appears in Cloudinary dashboard
- [ ] Product appears in user app
- [ ] Image loads correctly

---

## 🐛 Common Issues

### "MongoServerError: bad auth"
→ Your password in MONGODB_URI is incorrect. Double-check it.

### "ENOTFOUND cluster0.ryerrti.mongodb.net"
→ Check your internet connection or MongoDB Atlas IP whitelist.

### "Cloudinary configuration error"
→ Verify your Cloudinary credentials are correct in .env

### "Connection refused" from Flutter
→ Make sure:
1. Backend is running
2. API_BASE_URL has your correct IP address
3. Phone and computer are on the same WiFi network

---

## 📞 Quick Reference

### Your MongoDB Details
- **Cluster:** cluster0.ryerrti.mongodb.net
- **Username:** viveksawji06_db_user
- **Database:** marketplace
- **Connection String:** Already in `backend/.env`

### Your Backend
- **Port:** 3001
- **Health Check:** http://localhost:3001/api/health
- **API Base:** http://localhost:3001/api

### Important Files
- **Backend Config:** `backend/.env`
- **Shop Owner Upload:** `shop_owner_app/lib/services/cloudinary_upload_service.dart`
- **Shop Owner API:** `shop_owner_app/lib/services/product_api_service.dart`
- **User App API:** `user_app/lib/services/product_api_service.dart`

---

## 🎉 Next Steps

1. **Right now:** Update your MongoDB password in `backend/.env`
2. **Next:** Sign up for Cloudinary and add credentials
3. **Then:** Start your backend server
4. **Finally:** Update Flutter API URLs and test!

---

## 📚 Need More Help?

- **Complete guide:** [START_HERE_MIGRATION.md](START_HERE_MIGRATION.md)
- **Step-by-step:** [MIGRATION_CHECKLIST.md](MIGRATION_CHECKLIST.md)
- **Backend details:** [BACKEND_SETUP_INSTRUCTIONS.md](BACKEND_SETUP_INSTRUCTIONS.md)
- **Flutter details:** [FLUTTER_SETUP_INSTRUCTIONS.md](FLUTTER_SETUP_INSTRUCTIONS.md)

---

**You're almost there!** Just update the password and Cloudinary credentials, and you're ready to go! 🚀
