# 🚀 Backend Setup Instructions

## Step 1: Install Dependencies

Open terminal in the `backend` folder and run:

```bash
cd backend
npm install
```

This will install:
- express (web framework)
- mongoose (MongoDB driver)
- cloudinary (image hosting)
- multer (file upload handling)
- cors (cross-origin requests)
- dotenv (environment variables)

## Step 2: Configure Environment Variables

1. Copy `.env.example` to `.env`:
   ```bash
   copy .env.example .env
   ```

2. Edit `.env` file and add your credentials:

```env
# Server Configuration
PORT=3000
NODE_ENV=development

# MongoDB Atlas Connection
# Replace with your actual MongoDB connection string
MONGODB_URI=mongodb+srv://your_username:your_password@cluster0.xxxxx.mongodb.net/marketplace?retryWrites=true&w=majority

# Cloudinary Configuration
# Get these from https://cloudinary.com/console
CLOUDINARY_CLOUD_NAME=your_cloud_name_here
CLOUDINARY_API_KEY=your_api_key_here
CLOUDINARY_API_SECRET=your_api_secret_here

# JWT Secret
JWT_SECRET=your_random_secret_key_here

# CORS Settings
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8080
```

### How to Get MongoDB Connection String:

1. Go to https://www.mongodb.com/cloud/atlas
2. Sign in or create account
3. Create a new cluster (free M0 tier)
4. Click "Connect" → "Connect your application"
5. Copy the connection string
6. Replace `<password>` with your database user password
7. Replace `<dbname>` with `marketplace`

### How to Get Cloudinary Credentials:

1. Go to https://cloudinary.com/users/register/free
2. Sign up for free account
3. Go to Dashboard
4. Copy:
   - Cloud Name
   - API Key
   - API Secret

## Step 3: Start the Server

```bash
npm start
```

Or for development with auto-restart:

```bash
npm run dev
```

You should see:
```
✅ MongoDB connected successfully
🚀 Server running on port 3000
📱 API Base URL: http://localhost:3000/api
🏥 Health Check: http://localhost:3000/api/health
```

## Step 4: Test the API

Open your browser or use Postman to test:

```
http://localhost:3000/api/health
```

You should see:
```json
{
  "status": "OK",
  "message": "Marketplace API is running",
  "timestamp": "2024-02-11T..."
}
```

## Step 5: Test Product Upload (Optional)

Use Postman or similar tool:

**POST** `http://localhost:3000/api/upload/product`

Form-data:
- `image`: (file) select an image
- `name`: Test Product
- `description`: This is a test product
- `price`: 29.99
- `shopId`: 507f1f77bcf86cd799439011 (use a valid shop ID)
- `shopName`: Test Shop
- `category`: General
- `stock`: 10
- `unit`: piece

## API Endpoints

### Products
- `GET /api/products` - Get all products
- `GET /api/products/:id` - Get single product
- `POST /api/products` - Create product (without image)
- `PUT /api/products/:id` - Update product
- `DELETE /api/products/:id` - Delete product

### Upload
- `POST /api/upload/product` - Upload product with image
- `POST /api/upload/product/:id/images` - Add more images
- `DELETE /api/upload/image` - Delete image

### Shops
- `GET /api/shops` - Get all shops
- `POST /api/shops` - Create shop

### Orders
- `GET /api/orders` - Get all orders
- `POST /api/orders` - Create order

## Troubleshooting

### Port already in use
```bash
# Windows
netstat -ano | findstr :3000
taskkill /PID <PID> /F

# Or change PORT in .env file
```

### MongoDB connection failed
- Check your connection string
- Ensure IP address is whitelisted in MongoDB Atlas
- Verify username and password are correct

### Cloudinary upload failed
- Verify credentials in .env
- Check file size (max 10MB)
- Ensure image format is supported (jpg, png, gif, webp)

### CORS errors from Flutter
- Add your Flutter app's origin to ALLOWED_ORIGINS in .env
- For development, you can use `*` but not recommended for production

## Next Steps

1. ✅ Backend is running
2. Update Flutter apps with your backend URL
3. Test uploading products from shop owner app
4. Test viewing products in user app

## Production Deployment

For production, consider:
- Use environment-specific .env files
- Enable HTTPS
- Set up proper authentication
- Add rate limiting
- Use PM2 or similar for process management
- Deploy to Heroku, Railway, or similar platform
