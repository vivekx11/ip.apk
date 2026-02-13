# 🏗️ System Architecture

## Before (Firebase)

```
┌─────────────────────┐
│  Shop Owner App     │
│  (Flutter)          │
└──────────┬──────────┘
           │
           │ Firebase SDK
           │
           ▼
┌─────────────────────┐
│  Firebase Services  │
├─────────────────────┤
│ • Firestore (DB)    │
│ • Storage (Images)  │
│ • Auth              │
└─────────────────────┘
           ▲
           │ Firebase SDK
           │
┌──────────┴──────────┐
│  User App           │
│  (Flutter)          │
└─────────────────────┘
```

**Issues:**
- ❌ Vendor lock-in
- ❌ Limited customization
- ❌ Expensive at scale
- ❌ Complex pricing
- ❌ Limited control

---

## After (Custom Backend)

```
┌─────────────────────┐
│  Shop Owner App     │
│  (Flutter)          │
└──────────┬──────────┘
           │
           │ HTTP/REST API
           │
           ▼
┌─────────────────────────────────────┐
│  Node.js + Express Backend          │
│  (Your Server)                      │
├─────────────────────────────────────┤
│  Routes:                            │
│  • POST /api/upload/product         │
│  • GET  /api/products               │
│  • PUT  /api/products/:id           │
│  • DELETE /api/products/:id         │
└──────────┬──────────────┬───────────┘
           │              │
           │              │
           ▼              ▼
┌──────────────────┐  ┌──────────────────┐
│  MongoDB Atlas   │  │  Cloudinary      │
│  (Database)      │  │  (Image Storage) │
├──────────────────┤  ├──────────────────┤
│ • Products       │  │ • Product Images │
│ • Shops          │  │ • Optimization   │
│ • Orders         │  │ • Transformations│
│ • Users          │  │ • CDN Delivery   │
└──────────────────┘  └──────────────────┘
           ▲
           │ HTTP/REST API
           │
┌──────────┴──────────┐
│  User App           │
│  (Flutter)          │
└─────────────────────┘
```

**Benefits:**
- ✅ Full control
- ✅ Unlimited customization
- ✅ Predictable costs
- ✅ No vendor lock-in
- ✅ Standard REST API

---

## Data Flow

### Upload Product Flow

```
1. Shop Owner App
   │
   ├─ User selects image
   │  (image_picker)
   │
   ├─ User fills product details
   │  (name, price, description)
   │
   └─ Tap "Upload"
      │
      ▼
2. CloudinaryUploadService
   │
   ├─ Create multipart/form-data request
   │  • image file
   │  • product data (JSON)
   │
   └─ POST to /api/upload/product
      │
      ▼
3. Backend Server
   │
   ├─ Multer receives file
   │
   ├─ Upload to Cloudinary
   │  └─ Get image URL
   │
   ├─ Save to MongoDB
   │  • Product data
   │  • Image URL
   │
   └─ Return response
      │
      ▼
4. Shop Owner App
   │
   └─ Show success message
```

### View Products Flow

```
1. User App
   │
   ├─ Open products screen
   │
   └─ Call ProductApiService
      │
      ▼
2. ProductApiService
   │
   ├─ GET /api/products
   │
   └─ Parse JSON response
      │
      ▼
3. Backend Server
   │
   ├─ Query MongoDB
   │  • Filter by availability
   │  • Sort by date
   │  • Paginate results
   │
   └─ Return products array
      │
      ▼
4. User App
   │
   ├─ Display in ListView
   │
   └─ Load images with CachedNetworkImage
      │
      ▼
5. Cloudinary CDN
   │
   └─ Deliver optimized images
```

---

## Technology Stack

### Backend Layer

```
┌─────────────────────────────────────┐
│  Node.js Runtime                    │
├─────────────────────────────────────┤
│  Express.js Framework               │
├─────────────────────────────────────┤
│  Middleware:                        │
│  • CORS                             │
│  • Body Parser                      │
│  • Multer (file upload)             │
├─────────────────────────────────────┤
│  Libraries:                         │
│  • Mongoose (MongoDB ODM)           │
│  • Cloudinary SDK                   │
│  • dotenv (config)                  │
└─────────────────────────────────────┘
```

### Database Layer

```
┌─────────────────────────────────────┐
│  MongoDB Atlas (Cloud)              │
├─────────────────────────────────────┤
│  Collections:                       │
│  • products                         │
│    - name, description, price       │
│    - imageUrls[]                    │
│    - shopId, category               │
│    - stock, unit                    │
│    - timestamps                     │
│                                     │
│  • shops                            │
│    - name, address, phone           │
│    - isOpen, rating                 │
│                                     │
│  • orders                           │
│    - products[], total              │
│    - status, pickupCode             │
└─────────────────────────────────────┘
```

### Storage Layer

```
┌─────────────────────────────────────┐
│  Cloudinary (Cloud)                 │
├─────────────────────────────────────┤
│  Features:                          │
│  • Image upload                     │
│  • Automatic optimization           │
│  • Format conversion                │
│  • Responsive images                │
│  • CDN delivery                     │
│  • Transformations                  │
│                                     │
│  Folder Structure:                  │
│  marketplace/                       │
│    └── products/                    │
│        ├── image1.jpg               │
│        ├── image2.jpg               │
│        └── ...                      │
└─────────────────────────────────────┘
```

### Flutter Layer

```
┌─────────────────────────────────────┐
│  Flutter Framework                  │
├─────────────────────────────────────┤
│  State Management:                  │
│  • Provider                         │
│                                     │
│  HTTP Client:                       │
│  • http package                     │
│  • multipart requests               │
│                                     │
│  Image Handling:                    │
│  • image_picker                     │
│  • cached_network_image             │
│                                     │
│  Services:                          │
│  • CloudinaryUploadService          │
│  • ProductApiService                │
│  • NetworkService                   │
└─────────────────────────────────────┘
```

---

## API Request/Response Examples

### Upload Product

**Request:**
```http
POST /api/upload/product HTTP/1.1
Host: localhost:3000
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary

------WebKitFormBoundary
Content-Disposition: form-data; name="image"; filename="product.jpg"
Content-Type: image/jpeg

[binary image data]
------WebKitFormBoundary
Content-Disposition: form-data; name="name"

Wireless Headphones
------WebKitFormBoundary
Content-Disposition: form-data; name="description"

High-quality wireless headphones with noise cancellation
------WebKitFormBoundary
Content-Disposition: form-data; name="price"

79.99
------WebKitFormBoundary
Content-Disposition: form-data; name="shopId"

507f1f77bcf86cd799439011
------WebKitFormBoundary
Content-Disposition: form-data; name="shopName"

Tech Store
------WebKitFormBoundary--
```

**Response:**
```json
{
  "success": true,
  "message": "Product uploaded successfully",
  "data": {
    "product": {
      "id": "65c9f8a7b1234567890abcde",
      "name": "Wireless Headphones",
      "description": "High-quality wireless headphones...",
      "price": 79.99,
      "imageUrl": "https://res.cloudinary.com/your-cloud/image/upload/v1234567890/marketplace/products/abc123.jpg",
      "imageUrls": ["https://res.cloudinary.com/..."],
      "shopId": "507f1f77bcf86cd799439011",
      "shopName": "Tech Store",
      "category": "Electronics",
      "stock": 10,
      "unit": "piece",
      "isAvailable": true,
      "createdAt": "2024-02-11T10:30:00.000Z"
    }
  }
}
```

### Get Products

**Request:**
```http
GET /api/products?isAvailable=true&limit=20 HTTP/1.1
Host: localhost:3000
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "_id": "65c9f8a7b1234567890abcde",
      "name": "Wireless Headphones",
      "description": "High-quality wireless headphones...",
      "price": 79.99,
      "imageUrl": "https://res.cloudinary.com/...",
      "imageUrls": ["https://res.cloudinary.com/..."],
      "shopId": "507f1f77bcf86cd799439011",
      "shopName": "Tech Store",
      "category": "Electronics",
      "stock": 10,
      "unit": "piece",
      "isAvailable": true,
      "createdAt": "2024-02-11T10:30:00.000Z",
      "updatedAt": "2024-02-11T10:30:00.000Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 1,
    "pages": 1
  }
}
```

---

## Security Considerations

### Current Implementation (Development)

```
┌─────────────────────────────────────┐
│  Security Features                  │
├─────────────────────────────────────┤
│  ✅ CORS enabled                    │
│  ✅ File type validation            │
│  ✅ File size limits (10MB)         │
│  ✅ Environment variables           │
│  ✅ Input validation                │
└─────────────────────────────────────┘
```

### Production Recommendations

```
┌─────────────────────────────────────┐
│  Additional Security                │
├─────────────────────────────────────┤
│  🔒 HTTPS/SSL                       │
│  🔒 JWT Authentication              │
│  🔒 Rate limiting                   │
│  🔒 Request validation              │
│  🔒 SQL injection prevention        │
│  🔒 XSS protection                  │
│  🔒 API key rotation                │
│  🔒 Logging & monitoring            │
└─────────────────────────────────────┘
```

---

## Scalability Path

### Phase 1: Current (MVP)
- Single server
- MongoDB Atlas free tier
- Cloudinary free tier
- Direct HTTP requests

### Phase 2: Growth
- Load balancer
- Multiple server instances
- Redis caching
- CDN for static assets

### Phase 3: Scale
- Microservices architecture
- Message queues
- Database sharding
- Auto-scaling

---

## Cost Comparison

### Firebase (Estimated)

```
Free Tier:
- Firestore: 1GB storage, 50K reads/day
- Storage: 5GB, 1GB/day downloads
- Auth: Unlimited

Paid (Blaze):
- $0.18/GB storage
- $0.06/100K reads
- $0.026/GB downloads
```

### Custom Backend (Estimated)

```
MongoDB Atlas:
- Free: 512MB storage
- Paid: $9/month (2GB)

Cloudinary:
- Free: 25GB storage, 25GB bandwidth
- Paid: $89/month (100GB)

Server:
- Heroku: Free tier available
- Railway: $5/month
- DigitalOcean: $5/month
```

**Winner:** Custom backend is more cost-effective at scale!

---

## Deployment Architecture

```
┌─────────────────────────────────────────────────┐
│  Production Environment                         │
├─────────────────────────────────────────────────┤
│                                                 │
│  ┌──────────────┐         ┌──────────────┐    │
│  │   Flutter    │         │   Flutter    │    │
│  │  Shop Owner  │         │   User App   │    │
│  │     App      │         │              │    │
│  └──────┬───────┘         └──────┬───────┘    │
│         │                        │             │
│         └────────────┬───────────┘             │
│                      │                         │
│                      ▼                         │
│         ┌────────────────────────┐             │
│         │   Load Balancer        │             │
│         │   (nginx/CloudFlare)   │             │
│         └────────────┬───────────┘             │
│                      │                         │
│         ┌────────────┴───────────┐             │
│         │                        │             │
│         ▼                        ▼             │
│  ┌─────────────┐         ┌─────────────┐      │
│  │  Server 1   │         │  Server 2   │      │
│  │  (Node.js)  │         │  (Node.js)  │      │
│  └──────┬──────┘         └──────┬──────┘      │
│         │                       │              │
│         └───────────┬───────────┘              │
│                     │                          │
│         ┌───────────┴───────────┐              │
│         │                       │              │
│         ▼                       ▼              │
│  ┌─────────────┐         ┌─────────────┐      │
│  │  MongoDB    │         │ Cloudinary  │      │
│  │   Atlas     │         │     CDN     │      │
│  └─────────────┘         └─────────────┘      │
│                                                 │
└─────────────────────────────────────────────────┘
```

---

This architecture provides a solid foundation for your marketplace application with room to grow!
