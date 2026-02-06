# 🚀 Production Deployment Guide

## Problem: App needs to work on all devices without hardcoding IP

## Solution: Deploy Backend to Cloud

### Option 1: Render.com (Recommended - Easiest)

#### Step 1: Create Account
1. Go to https://render.com
2. Sign up with GitHub

#### Step 2: Deploy Backend
1. Push your code to GitHub
2. On Render dashboard, click "New +" → "Web Service"
3. Connect your GitHub repository
4. Configure:
   - **Name**: marketplace-backend
   - **Environment**: Node
   - **Build Command**: `npm install`
   - **Start Command**: `npm start`
   - **Plan**: Free

#### Step 3: Add Environment Variables
In Render dashboard, add:
```
MONGODB_URI=your_mongodb_connection_string
PORT=3001
NODE_ENV=production
```

#### Step 4: Get Your API URL
After deployment, Render gives you a URL like:
```
https://marketplace-backend.onrender.com
```

#### Step 5: Update Apps
Update API URLs in both apps to:
```dart
static const String baseUrl = 'https://marketplace-backend.onrender.com/api';
```

### Option 2: Railway.app (Fast & Easy)

#### Step 1: Install Railway CLI
```bash
npm install -g @railway/cli
```

#### Step 2: Deploy
```bash
cd backend
railway login
railway init
railway up
```

#### Step 3: Get URL
```bash
railway domain
```

### Option 3: Quick Local Network Solution (For Testing)

If you want to test locally on your network:

#### Step 1: Get Your IP
```bash
ipconfig  # Windows
# Note your IPv4 address (e.g., 192.168.1.100)
```

#### Step 2: Use ngrok (Temporary Public URL)
```bash
# Install ngrok from https://ngrok.com
ngrok http 3001
```

This gives you a public URL like: `https://abc123.ngrok.io`

#### Step 3: Update Apps
```dart
static const String baseUrl = 'https://abc123.ngrok.io/api';
```

### Option 4: MongoDB Atlas + Render (Complete Production Setup)

#### Step 1: MongoDB Atlas (Free Database)
1. Go to https://www.mongodb.com/cloud/atlas
2. Create free cluster
3. Get connection string:
   ```
   mongodb+srv://username:password@cluster.mongodb.net/marketplace
   ```

#### Step 2: Deploy to Render
Follow Option 1 steps above

#### Step 3: Update Apps with Production URL
```dart
// user_app/lib/core/constants/app_constants.dart
static const String baseUrl = 'https://your-app.onrender.com/api';

// shop_owner_app/lib/services/api_service.dart
static const String baseUrl = 'https://your-app.onrender.com/api';
```

## 🎯 Recommended Approach

**For Production (Best):**
1. MongoDB Atlas (Free database)
2. Render.com (Free backend hosting)
3. Update apps with production URL
4. Rebuild apps

**For Quick Testing:**
1. Use ngrok for temporary public URL
2. Update apps
3. Rebuild apps

## 📝 After Deployment Checklist

- [ ] Backend deployed to cloud
- [ ] MongoDB Atlas configured
- [ ] Environment variables set
- [ ] API URL updated in both apps
- [ ] Apps rebuilt with new URL
- [ ] Tested on physical devices
- [ ] Works on any network

## 🔥 Quick Deploy Script

I'll create a script to help you deploy quickly...