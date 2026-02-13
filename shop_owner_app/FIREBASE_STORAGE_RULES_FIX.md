# Firebase Storage Rules Fix

## Problem
Images are not uploading because Firebase Storage has restrictive security rules by default.

## Solution

### Step 1: Open Firebase Console
1. Go to https://console.firebase.google.com
2. Select your project: **local-marketplace-demo**
3. Click on **Storage** in the left menu
4. Click on the **Rules** tab

### Step 2: Update Storage Rules

Replace the existing rules with these:

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Allow anyone to read product images
    match /products/{allPaths=**} {
      allow read: if true;
      allow write: if true; // For testing - make this more restrictive in production
    }
    
    // Default: deny all other access
    match /{allPaths=**} {
      allow read, write: if false;
    }
  }
}
```

### Step 3: For Production (More Secure)

Once testing is complete, use these more secure rules:

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Product images - anyone can read, only authenticated users can write
    match /products/{shopName}/{productName}/{imageId} {
      allow read: if true;
      allow write: if request.auth != null 
                   && request.resource.size < 5 * 1024 * 1024  // Max 5MB
                   && request.resource.contentType.matches('image/.*');
      allow delete: if request.auth != null;
    }
    
    // Default: deny all other access
    match /{allPaths=**} {
      allow read, write: if false;
    }
  }
}
```

### Step 4: Publish Rules
1. Click **Publish** button
2. Wait for confirmation message

### Step 5: Test Upload
1. Restart your app
2. Try uploading an image again
3. You should now see the actual error message if it still fails

## Common Issues

### Issue 1: "Permission Denied"
- **Cause**: Storage rules are too restrictive
- **Fix**: Use the testing rules above (allow write: if true)

### Issue 2: "Storage bucket not configured"
- **Cause**: Storage not enabled in Firebase
- **Fix**: Go to Storage in Firebase Console and click "Get Started"

### Issue 3: "Network error"
- **Cause**: No internet connection or Firebase not initialized
- **Fix**: Check internet connection and ensure Firebase.initializeApp() is called

## Verify Upload

After uploading, check Firebase Console:
1. Go to Storage
2. Click on **Files** tab
3. You should see: `products/[shop-name]/[product-name]/[timestamp]_image.jpg`

## Debug Logs

The app now prints detailed logs:
- `📤 Uploading to: [path]` - Shows upload path
- `✅ Image uploaded successfully: [url]` - Success with download URL
- `❌ Error uploading image: [error]` - Shows actual error

Check your IDE console/logcat for these messages.
