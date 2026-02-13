# Product Upload Error - Debug Guide

## Problem
App shows: "Error: Exception: Something went wrong!" when uploading products.

## Root Cause Analysis

### Backend Status ✅
- Backend is running: https://instantpick-backend.onrender.com
- Health check: Working
- Upload endpoint: Exists and responding

### Possible Issues

1. **Network/Connection Issue**
   - App might not be able to reach the backend
   - Firewall or network restrictions
   - Slow internet causing timeout

2. **Image Processing Issue**
   - Image file too large (>10MB)
   - Unsupported image format
   - File path issue on device

3. **Backend Error**
   - Cloudinary upload failing
   - MongoDB connection issue
   - Missing required fields

## What I Fixed

### 1. Better Error Messages
Updated the app to show specific error messages instead of generic "Something went wrong":
- Network errors: "Cannot connect to server"
- Timeout errors: "Connection timeout"
- Server errors: Shows actual error from backend

### 2. Added Timeout Handling
Added 30-second timeout for uploads to prevent hanging

### 3. Better Logging
Added detailed console logs to track:
- Request details
- Response status
- Error types

## How to Debug

### Step 1: Rebuild the App
```cmd
cd shop_owner_app
flutter clean
flutter pub get
flutter build apk --release
```

### Step 2: Install and Test
1. Install the new APK on your phone
2. Try uploading a product
3. Note the exact error message shown

### Step 3: Check Logs
If using debug mode:
```cmd
flutter run
```
Then check the console output when upload fails.

## Common Error Messages & Solutions

### "Cannot connect to server"
**Cause**: No internet or backend unreachable
**Solution**: 
- Check internet connection
- Verify backend URL is correct
- Try accessing https://instantpick-backend.onrender.com/api/health in browser

### "Upload timeout"
**Cause**: Server taking too long (>30 seconds)
**Solution**:
- Use smaller image (compress before upload)
- Check internet speed
- Backend might be slow (Render free tier can be slow on first request)

### "Image file too large"
**Cause**: Image > 10MB
**Solution**: Compress image before selecting

### "Missing required fields"
**Cause**: Form validation issue
**Solution**: Ensure all fields are filled

### "Server error"
**Cause**: Backend issue (Cloudinary, MongoDB, etc.)
**Solution**: Check backend logs on Render dashboard

## Testing Checklist

- [ ] Internet connection is working
- [ ] Backend health check works in browser
- [ ] Image is < 10MB
- [ ] All form fields are filled
- [ ] Using supported image format (JPG, PNG, GIF, WEBP)
- [ ] App has storage permissions

## Quick Test

Try uploading with these details:
- **Name**: Test Product
- **Description**: Test Description
- **Category**: Test
- **Price**: 100
- **Stock**: 10
- **Image**: Small image (< 1MB)

## Next Steps

1. **Rebuild the app** with the fixes I made
2. **Try uploading** and note the exact error message
3. **Share the error message** with me for further debugging

The improved error handling will now show you the actual problem instead of the generic message!
