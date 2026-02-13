# ✅ Your Credentials Checklist

## What You Have vs What You Need

### MongoDB Atlas

| Item | Status | Value |
|------|--------|-------|
| Cluster | ✅ | cluster0.ryerrti.mongodb.net |
| Username | ✅ | viveksawji06_db_user |
| Database | ✅ | marketplace |
| Connection String | ✅ | Added to backend/.env |
| **Password** | ⚠️ **NEEDED** | You need to add this |

**Action:** Replace `<db_password>` in `backend/.env` line 7

---

### Cloudinary

| Item | Status | Value |
|------|--------|-------|
| Cloud Name | ✅ | dlyehrepq |
| API Secret | ✅ | 313367428372376i5WiI2XkJ6qOZd4rNwIzsHqxF3E |
| **API Key** | ⚠️ **NEEDED** | Get from dashboard |

**Action:** 
1. Go to https://cloudinary.com/console
2. Copy the API Key (a long number)
3. Replace `<your_api_key>` in `backend/.env` line 16

---

## Quick Edit Guide

### File: backend/.env

**Line 7 - MongoDB Password:**
```env
# BEFORE:
MONGODB_URI=mongodb+srv://viveksawji06_db_user:<db_password>@cluster0.ryerrti.mongodb.net/marketplace?retryWrites=true&w=majority

# AFTER (example with password "MyPass123"):
MONGODB_URI=mongodb+srv://viveksawji06_db_user:MyPass123@cluster0.ryerrti.mongodb.net/marketplace?retryWrites=true&w=majority
```

**Line 16 - Cloudinary API Key:**
```env
# BEFORE:
CLOUDINARY_API_KEY=<your_api_key>

# AFTER (example with key "123456789012345"):
CLOUDINARY_API_KEY=123456789012345
```

---

## How to Get Cloudinary API Key

1. **Go to:** https://cloudinary.com/console
2. **Log in** with your account
3. **Look at the dashboard** - you'll see:
   ```
   Account Details
   ├── Cloud name: dlyehrepq
   ├── API Key: [COPY THIS NUMBER] ← This is what you need!
   └── API Secret: 313367428372376i5WiI2XkJ6qOZd4rNwIzsHqxF3E
   ```
4. **Copy the API Key** (it's a number like 123456789012345)
5. **Paste it** in `backend/.env`

---

## Verification

After adding both values, your `backend/.env` should look like:

```env
# Server Configuration
PORT=3001
NODE_ENV=development

# Database Configuration
MONGODB_URI=mongodb+srv://viveksawji06_db_user:YOUR_ACTUAL_PASSWORD@cluster0.ryerrti.mongodb.net/marketplace?retryWrites=true&w=majority

# JWT Configuration
JWT_SECRET=your_jwt_secret_key_here
JWT_EXPIRE=7d

# Cloudinary Configuration
CLOUDINARY_CLOUD_NAME=dlyehrepq
CLOUDINARY_API_KEY=YOUR_ACTUAL_API_KEY_NUMBER
CLOUDINARY_API_SECRET=313367428372376i5WiI2XkJ6qOZd4rNwIzsHqxF3E
```

---

## Test Your Configuration

### 1. Start Backend
```bash
cd backend
npm install
npm start
```

### 2. Check for Success Messages

**MongoDB Success:**
```
✅ MongoDB connected successfully
```

**Server Success:**
```
🚀 Server running on port 3001
```

**If you see both:** You're good to go! ✅

**If you see errors:**
- "bad auth" → MongoDB password is wrong
- "Cloudinary error" → API Key is wrong

---

## Next Steps After Configuration

Once both values are added and backend starts successfully:

1. ✅ Find your IP: `ipconfig`
2. ✅ Update Flutter API URLs (3 files)
3. ✅ Run Flutter apps
4. ✅ Test upload and display

**Full guide:** [FINAL_SETUP_STEPS.md](FINAL_SETUP_STEPS.md)

---

## Quick Reference

| What | Where | Action |
|------|-------|--------|
| MongoDB Password | backend/.env line 7 | Replace `<db_password>` |
| Cloudinary API Key | backend/.env line 16 | Replace `<your_api_key>` |
| Get API Key | https://cloudinary.com/console | Copy from dashboard |
| Test Backend | http://localhost:3001/api/health | Should return OK |

---

**You're 2 edits away from success!** 🚀

1. Edit `backend/.env` (2 values)
2. Run `npm start`
3. Done!
