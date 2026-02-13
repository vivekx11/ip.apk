# 🇮🇳 Hindi Setup Guide - Image Upload Kaise Kare

## 🎯 Abhi Kya Karna Hai

Image upload karne ke liye **4 simple steps** follow karo:

---

## Step 1: Cloudinary API Key Nikalo (2 minute)

### Kaise karein:

1. **Website kholo:** https://cloudinary.com/console
2. **Login karo** apne account se
3. **Dashboard pe dikhega:**
   ```
   Account Details
   ├── Cloud name: dlyehrepq          ✅ (Already added)
   ├── API Key: 123456789012345       ← YE COPY KARO!
   └── API Secret: 313367...          ✅ (Already added)
   ```
4. **API Key copy karo** (ye ek bada number hoga)

---

## Step 2: backend/.env File Edit Karo (2 minutes)

### File location:
```
backend/.env
```

### 2 cheezein change karo:

#### A) MongoDB Password (Line 7)

**Pehle:**
```env
MONGODB_URI=mongodb+srv://viveksawji06_db_user:<db_password>@cluster0.ryerrti.mongodb.net/marketplace
```

**Baad mein:** (apna password daalo)
```env
MONGODB_URI=mongodb+srv://viveksawji06_db_user:APNA_PASSWORD@cluster0.ryerrti.mongodb.net/marketplace
```

**Example:**
```env
MONGODB_URI=mongodb+srv://viveksawji06_db_user:MyPass123@cluster0.ryerrti.mongodb.net/marketplace
```

#### B) Cloudinary API Key (Line 16)

**Pehle:**
```env
CLOUDINARY_API_KEY=<your_api_key>
```

**Baad mein:** (jo number copy kiya tha wo daalo)
```env
CLOUDINARY_API_KEY=123456789012345
```

### File save karo! 💾

---

## Step 3: Backend Server Start Karo (2 minutes)

### Terminal/Command Prompt kholo:

```bash
# Backend folder mein jao
cd backend

# Dependencies install karo (pehli baar)
npm install

# Server start karo
npm start
```

### Agar sab sahi hai toh dikhega:

```
✅ MongoDB connected successfully
🚀 Server running on port 3001
📱 API Base URL: http://localhost:3001/api
🏥 Health Check: http://localhost:3001/api/health
```

### Test karo:

Browser mein kholo: http://localhost:3001/api/health

Dikhna chahiye:
```json
{"status":"OK","message":"Marketplace API is running"}
```

**✅ Agar ye dikha toh backend ready hai!**

---

## Step 4: Flutter Apps Mein API URL Update Karo (3 minutes)

### A) Apna IP Address Nikalo

**Windows mein:**
```bash
ipconfig
```

**Dhundo:** "IPv4 Address" (Example: 192.168.1.100)

**Yahan likho:** ___________________

### B) 3 Files Edit Karo

Har file mein `API_BASE_URL` change karo:

#### File 1: Shop Owner - Upload Service
**Location:** `shop_owner_app/lib/services/cloudinary_upload_service.dart`

**Line 15 pe change karo:**
```dart
// Pehle:
static const String API_BASE_URL = 'http://localhost:3000/api';

// Baad mein: (apna IP daalo)
static const String API_BASE_URL = 'http://192.168.1.100:3001/api';
```

#### File 2: Shop Owner - Product Service
**Location:** `shop_owner_app/lib/services/product_api_service.dart`

**Line 10 pe change karo:**
```dart
static const String API_BASE_URL = 'http://192.168.1.100:3001/api';
```

#### File 3: User App - Product Service
**Location:** `user_app/lib/services/product_api_service.dart`

**Line 13 pe change karo:**
```dart
static const String API_BASE_URL = 'http://192.168.1.100:3001/api';
```

**⚠️ Dhyan do:** Teeno files mein **apna IP address** use karo!

---

## Step 5: Flutter Apps Run Karo (3 minutes)

### Shop Owner App:

```bash
cd shop_owner_app
flutter clean
flutter pub get
flutter run
```

### User App:

```bash
cd user_app
flutter clean
flutter pub get
flutter run
```

---

## 🎉 Ab Image Upload Karo!

### Shop Owner App Mein:

1. ✅ App kholo
2. ✅ Upload product screen pe jao
3. ✅ Image select karo (gallery ya camera se)
4. ✅ Product details bharo:
   - Name: Test Product
   - Description: Ye test hai
   - Price: 99
   - Category: General
   - Stock: 10
5. ✅ "Upload" button dabao
6. ✅ Wait karo...
7. ✅ **Success message dikhega!** 🎊

### Verify Karo:

1. **Cloudinary mein dekho:**
   - Jao: https://cloudinary.com/console/media_library
   - Folder: marketplace/products
   - **Tumhari image dikhi!** ✅

2. **User App mein dekho:**
   - User app kholo
   - Products list pe jao
   - **Tumhara product dikha!** ✅
   - **Image load ho rahi hai!** ✅

---

## ✅ Checklist - Kya Kya Karna Hai

- [ ] Cloudinary dashboard se API Key copy kiya
- [ ] `backend/.env` mein MongoDB password add kiya
- [ ] `backend/.env` mein Cloudinary API Key add kiya
- [ ] Backend folder mein `npm install` run kiya
- [ ] Backend start kiya (`npm start`)
- [ ] Backend health check test kiya
- [ ] `ipconfig` se IP address nikala
- [ ] Shop owner app ki 2 files mein API URL update kiya
- [ ] User app ki 1 file mein API URL update kiya
- [ ] Shop owner app mein `flutter clean && flutter pub get` run kiya
- [ ] User app mein `flutter clean && flutter pub get` run kiya
- [ ] Shop owner app run kiya
- [ ] User app run kiya
- [ ] Product upload test kiya
- [ ] Cloudinary mein image check kiya
- [ ] User app mein product dikha

---

## 🐛 Problems Aur Solutions

### Problem 1: "MongoServerError: bad auth"
**Matlab:** MongoDB password galat hai

**Solution:** `backend/.env` mein password check karo

---

### Problem 2: "Cloudinary configuration error"
**Matlab:** Cloudinary API Key galat hai

**Solution:** Dashboard se dobara copy karo aur paste karo

---

### Problem 3: "Connection refused" Flutter se
**Matlab:** Backend se connect nahi ho raha

**Solution:**
1. Backend chal raha hai? (`npm start`)
2. API_BASE_URL mein sahi IP hai?
3. Phone aur computer same WiFi pe hain?

---

### Problem 4: Image upload nahi ho rahi
**Matlab:** Kuch configuration galat hai

**Solution:**
1. Backend terminal check karo - koi error?
2. Cloudinary credentials sahi hain?
3. Image size 10MB se kam hai?

---

## 📞 Quick Reference

### Backend Start Karne Ke Liye:
```bash
cd backend
npm start
```

### Flutter App Run Karne Ke Liye:
```bash
cd shop_owner_app
flutter run
```

### IP Address Nikalne Ke Liye:
```bash
ipconfig
```

### Backend Test Karne Ke Liye:
```
http://localhost:3001/api/health
```

---

## 🎯 Summary

**Total Time:** 15-20 minutes

**Steps:**
1. Cloudinary API Key nikalo (2 min)
2. `.env` file edit karo (2 min)
3. Backend start karo (2 min)
4. IP address nikalo (1 min)
5. Flutter files update karo (3 min)
6. Apps run karo (3 min)
7. Test karo (5 min)

**Result:** ✅ Image upload ho jayegi!

---

## 🚀 Shuru Karo!

**Pehla step:** Cloudinary dashboard kholo aur API Key copy karo!

**Link:** https://cloudinary.com/console

**Good luck!** 🎊
