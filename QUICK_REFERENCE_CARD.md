# 🎴 Quick Reference Card

## 🚀 Quick Commands

### Backend
```bash
# Setup
cd backend
npm install
copy .env.example .env
# Edit .env with credentials
npm start

# Health check
http://localhost:3000/api/health
```

### Flutter
```bash
# Shop Owner App
cd shop_owner_app
flutter clean && flutter pub get
flutter run

# User App
cd user_app
flutter clean && flutter pub get
flutter run
```

---

## 🔑 Required Credentials

### MongoDB Atlas
```
URL: https://www.mongodb.com/cloud/atlas
Format: mongodb+srv://user:pass@cluster.mongodb.net/marketplace
```

### Cloudinary
```
URL: https://cloudinary.com/console
Need: Cloud Name, API Key, API Secret
```

---

## 📝 Files to Edit

### Backend
```
backend/.env
├── MONGODB_URI=your_connection_string
├── CLOUDINARY_CLOUD_NAME=your_cloud_name
├── CLOUDINARY_API_KEY=your_api_key
└── CLOUDINARY_API_SECRET=your_api_secret
```

### Flutter (Find your IP: ipconfig)
```
shop_owner_app/lib/services/cloudinary_upload_service.dart
shop_owner_app/lib/services/product_api_service.dart
user_app/lib/services/product_api_service.dart

Change: API_BASE_URL = 'http://YOUR_IP:3000/api'
```

---

## 🔌 API Endpoints

```
GET    /api/health                          Health check
GET    /api/products                        Get all products
GET    /api/products/:id                    Get one product
POST   /api/upload/product                  Upload with image
PUT    /api/products/:id                    Update product
DELETE /api/products/:id                    Delete product
```

---

## 📱 Flutter Code Snippets

### Upload Product
```dart
final service = CloudinaryUploadService();
final image = await service.pickImageFromGallery();
final result = await service.uploadProduct(
  imageFile: image!,
  name: 'Name',
  description: 'Desc',
  price: 29.99,
  shopId: 'id',
  shopName: 'Shop',
);
```

### Get Products
```dart
final service = ProductApiService();
final result = await service.getProducts();
final products = result['data'];
```

---

## 🐛 Troubleshooting

| Problem | Solution |
|---------|----------|
| Backend won't start | Check .env credentials |
| Can't connect from Flutter | Update API_BASE_URL with your IP |
| Images won't upload | Verify Cloudinary credentials |
| Port 3000 in use | Change PORT in .env or kill process |
| Firebase errors | Run flutter clean && pub get |

---

## ✅ Testing Checklist

- [ ] Backend starts: `npm start`
- [ ] Health check works: http://localhost:3000/api/health
- [ ] Shop owner app compiles
- [ ] User app compiles
- [ ] Can upload product
- [ ] Product appears in user app
- [ ] Images load correctly

---

## 📚 Documentation

| File | Purpose |
|------|---------|
| START_HERE_MIGRATION.md | Quick start |
| MIGRATION_CHECKLIST.md | Step-by-step |
| BACKEND_SETUP_INSTRUCTIONS.md | Backend details |
| FLUTTER_SETUP_INSTRUCTIONS.md | Flutter details |
| CUSTOM_BACKEND_README.md | Complete overview |

---

## 🎯 Success Criteria

✅ Backend running
✅ No Firebase errors
✅ Products upload
✅ Products display
✅ Images load

---

**Print this card for quick reference!**
