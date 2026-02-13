# 🚀 Run These Commands (Copy & Paste)

## Prerequisites

Before running these commands, make sure you've:
1. ✅ Updated MongoDB password in `backend/.env`
2. ✅ Added Cloudinary credentials to `backend/.env`
3. ✅ Updated API URLs in Flutter service files

---

## 1️⃣ Backend Setup

Open Command Prompt or PowerShell in your project root:

```bash
# Navigate to backend folder
cd backend

# Install dependencies (first time only)
npm install

# Start the server
npm start
```

**Keep this terminal open!** The server needs to keep running.

**Expected output:**
```
✅ MongoDB connected successfully
🚀 Server running on port 3001
📱 API Base URL: http://localhost:3001/api
🏥 Health Check: http://localhost:3001/api/health
```

---

## 2️⃣ Test Backend (New Terminal)

Open a new terminal and test:

```bash
# Test health endpoint
curl http://localhost:3001/api/health
```

Or open in browser:
```
http://localhost:3001/api/health
```

Should return:
```json
{"status":"OK","message":"Marketplace API is running","timestamp":"..."}
```

---

## 3️⃣ Shop Owner App Setup

Open a new terminal:

```bash
# Navigate to shop owner app
cd shop_owner_app

# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Run the app
flutter run
```

**Select your device when prompted.**

---

## 4️⃣ User App Setup

Open another new terminal:

```bash
# Navigate to user app
cd user_app

# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Run the app
flutter run
```

**Select your device when prompted.**

---

## 🎯 Quick Test Commands

### Test Backend Health
```bash
curl http://localhost:3001/api/health
```

### Test Get Products
```bash
curl http://localhost:3001/api/products
```

### Check Backend Logs
Just look at the terminal where you ran `npm start`

---

## 🔄 Restart Commands

### Restart Backend
```bash
# In backend terminal, press Ctrl+C to stop
# Then run:
npm start
```

### Restart Flutter App
```bash
# In Flutter terminal, press 'r' for hot reload
# Or press 'R' for hot restart
# Or press 'q' to quit and run 'flutter run' again
```

---

## 🧹 Clean Everything (If Issues)

### Clean Backend
```bash
cd backend
rmdir /s /q node_modules
npm install
```

### Clean Flutter Apps
```bash
# Shop Owner App
cd shop_owner_app
flutter clean
flutter pub get

# User App
cd user_app
flutter clean
flutter pub get
```

---

## 📱 Build Release APK (When Ready)

### Shop Owner App
```bash
cd shop_owner_app
flutter build apk --release
```

APK location: `shop_owner_app/build/app/outputs/flutter-apk/app-release.apk`

### User App
```bash
cd user_app
flutter build apk --release
```

APK location: `user_app/build/app/outputs/flutter-apk/app-release.apk`

---

## 🐛 Troubleshooting Commands

### Check Node.js Version
```bash
node --version
npm --version
```

Should be v16 or higher.

### Check Flutter Version
```bash
flutter --version
flutter doctor
```

### Check if Port 3001 is in Use
```bash
netstat -ano | findstr :3001
```

If something is using it, kill the process or change PORT in .env

### Find Your IP Address
```bash
ipconfig
```

Look for "IPv4 Address"

---

## 📊 Useful Commands

### View Backend Logs
```bash
# Backend terminal shows all logs automatically
# Just keep it open and watch
```

### View Flutter Logs
```bash
# Flutter terminal shows all logs automatically
# Or run with verbose:
flutter run -v
```

### Check MongoDB Connection
```bash
# If backend starts successfully, MongoDB is connected
# Check the terminal output for:
# ✅ MongoDB connected successfully
```

### Check Cloudinary
```bash
# Upload a product from shop owner app
# Then check: https://cloudinary.com/console/media_library
```

---

## 🎯 Complete Workflow

**Terminal 1 (Backend):**
```bash
cd backend
npm start
# Keep running
```

**Terminal 2 (Shop Owner App):**
```bash
cd shop_owner_app
flutter run
# Keep running
```

**Terminal 3 (User App):**
```bash
cd user_app
flutter run
# Keep running
```

**Browser:**
```
http://localhost:3001/api/health
```

---

## ✅ Success Indicators

You'll know everything is working when:

1. ✅ Backend terminal shows "MongoDB connected successfully"
2. ✅ Health endpoint returns `{"status":"OK"}`
3. ✅ Shop owner app launches without errors
4. ✅ User app launches without errors
5. ✅ You can upload a product
6. ✅ Product appears in user app
7. ✅ Images load correctly

---

## 🎉 You're Ready!

Just copy and paste these commands in order, and you'll be up and running!

**Need help?** See [YOUR_SETUP_GUIDE.md](YOUR_SETUP_GUIDE.md)
