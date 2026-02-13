# 🚀 Create GitHub Repository - Quick Guide

## Step 1: Create Repository on GitHub

1. **Go to**: https://github.com/new

2. **Fill in details**:
   - **Repository name**: `marketplace-system`
   - **Description**: `Complete marketplace system with Flutter apps and Node.js backend`
   - **Visibility**: Choose Public or Private
   - **⚠️ IMPORTANT**: 
     - ❌ DON'T check "Add a README file"
     - ❌ DON'T add .gitignore
     - ❌ DON'T choose a license
     - (We already have these files)

3. **Click**: "Create repository"

## Step 2: Push Your Code

After creating the repository, run:

```bash
git push -u origin main
```

Or run this batch file:
```bash
PUSH_TO_GITHUB.bat
```

## 🎯 Your Repository URL

After creation, your code will be at:
**https://github.com/vivekx11/marketplace-system**

## ✅ What Happens Next

1. Code uploads to GitHub (may take 1-2 minutes)
2. You can view your project online
3. Ready to deploy to Render.com
4. Share with others

## 🌐 Deploy to Production

After pushing to GitHub:

1. Go to https://render.com
2. Sign in with GitHub
3. New Web Service
4. Select `marketplace-system` repo
5. Configure:
   - Root Directory: `backend`
   - Build: `npm install`
   - Start: `npm start`
6. Deploy!

## 📱 Update Apps with Production URL

Once deployed, update both apps:

**User App** - `user_app/lib/core/constants/app_constants.dart`:
```dart
static const String baseUrl = 'https://marketplace-system.onrender.com/api';
```

**Shop Owner App** - `shop_owner_app/lib/services/api_service.dart`:
```dart
static const String baseUrl = 'https://marketplace-system.onrender.com/api';
```

Then rebuild:
```bash
cd user_app && flutter build apk --release
cd shop_owner_app && flutter build apk --release
```

## 🎉 Done!

Your marketplace system will be:
- ✅ On GitHub
- ✅ Deployed to cloud
- ✅ Works on any device worldwide

---

**Need help?** Check GITHUB_SETUP.md for detailed instructions.