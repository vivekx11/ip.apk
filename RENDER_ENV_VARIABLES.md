# 🔐 Render Environment Variables - Copy Paste Karo

## Ye 8 Variables Add Karo Render Pe

Render dashboard mein "Environment Variables" section mein ek-ek karke add karo:

---

## Variable 1: PORT

**Key:**
```
PORT
```

**Value:**
```
3001
```

---

## Variable 2: NODE_ENV

**Key:**
```
NODE_ENV
```

**Value:**
```
production
```

---

## Variable 3: MONGODB_URI

**Key:**
```
MONGODB_URI
```

**Value:**
```
mongodb+srv://viveksawji06_db_user:vivek%402920@cluster0.ryerrti.mongodb.net/marketplace?retryWrites=true&w=majority
```

---

## Variable 4: CLOUDINARY_CLOUD_NAME

**Key:**
```
CLOUDINARY_CLOUD_NAME
```

**Value:**
```
dlyehrepq
```

---

## Variable 5: CLOUDINARY_API_KEY

**Key:**
```
CLOUDINARY_API_KEY
```

**Value:**
```
313367428372376
```

---

## Variable 6: CLOUDINARY_API_SECRET

**Key:**
```
CLOUDINARY_API_SECRET
```

**Value:**
```
313367428372376i5WiI2XkJ6qOZd4rNwIzsHqxF3E
```

---

## Variable 7: JWT_SECRET

**Key:**
```
JWT_SECRET
```

**Value:**
```
your_jwt_secret_key_here_change_in_production
```

---

## Variable 8: ALLOWED_ORIGINS

**Key:**
```
ALLOWED_ORIGINS
```

**Value:**
```
*
```

---

## 📋 Quick Copy-Paste Format

Agar Render bulk add support kare toh ye format use kar sakte ho:

```
PORT=3001
NODE_ENV=production
MONGODB_URI=mongodb+srv://viveksawji06_db_user:vivek%402920@cluster0.ryerrti.mongodb.net/marketplace?retryWrites=true&w=majority
CLOUDINARY_CLOUD_NAME=dlyehrepq
CLOUDINARY_API_KEY=313367428372376
CLOUDINARY_API_SECRET=313367428372376i5WiI2XkJ6qOZd4rNwIzsHqxF3E
JWT_SECRET=your_jwt_secret_key_here_change_in_production
ALLOWED_ORIGINS=*
```

---

## 🎯 Kaise Add Karein (Step by Step)

### Render Dashboard Mein:

1. **"Environment" tab** pe jao
2. **"Add Environment Variable"** click karo
3. **Key** mein pehla naam daalo (jaise `PORT`)
4. **Value** mein uski value daalo (jaise `3001`)
5. **"Save"** ya **"Add"** click karo
6. **Repeat** karo baaki 7 variables ke liye

---

## ✅ Verification Checklist

Sab variables add karne ke baad check karo:

- [ ] PORT = 3001
- [ ] NODE_ENV = production
- [ ] MONGODB_URI = mongodb+srv://viveksawji06_db_user:vivek%402920@...
- [ ] CLOUDINARY_CLOUD_NAME = dlyehrepq
- [ ] CLOUDINARY_API_KEY = 313367428372376
- [ ] CLOUDINARY_API_SECRET = 313367428372376i5WiI2XkJ6qOZd4rNwIzsHqxF3E
- [ ] JWT_SECRET = your_jwt_secret_key_here_change_in_production
- [ ] ALLOWED_ORIGINS = *

---

## ⚠️ Important Notes

### MongoDB URI:
- Password mein `@` symbol hai toh `%40` use karo (already done ✅)
- Pura connection string copy karo

### Cloudinary:
- Cloud Name, API Key, aur API Secret - teeno chahiye
- Spelling mistakes mat karo

### ALLOWED_ORIGINS:
- `*` means sab origins allowed (development ke liye)
- Production mein specific domain use karo (optional)

---

## 🐛 Common Mistakes

### ❌ Wrong:
```
MONGODB_URI=mongodb+srv://user:vivek@2920@cluster...
```
(Password mein @ directly use kiya)

### ✅ Correct:
```
MONGODB_URI=mongodb+srv://user:vivek%402920@cluster...
```
(@ ko %40 se replace kiya)

---

## 📸 Screenshot Guide

### Render Environment Variables Screen:

```
┌─────────────────────────────────────────┐
│ Environment Variables                   │
├─────────────────────────────────────────┤
│                                         │
│ Key: PORT                               │
│ Value: 3001                             │
│ [Add]                                   │
│                                         │
│ Key: NODE_ENV                           │
│ Value: production                       │
│ [Add]                                   │
│                                         │
│ ... (6 more variables)                  │
│                                         │
└─────────────────────────────────────────┘
```

---

## 🎉 After Adding All Variables

**Click:** "Create Web Service" ya "Deploy"

**Wait:** 2-3 minutes

**Result:** Backend deploy ho jayega! 🚀

---

## 📞 Quick Reference

### Total Variables: 8

1. PORT
2. NODE_ENV
3. MONGODB_URI
4. CLOUDINARY_CLOUD_NAME
5. CLOUDINARY_API_KEY
6. CLOUDINARY_API_SECRET
7. JWT_SECRET
8. ALLOWED_ORIGINS

---

**Ye sab add karo aur deploy karo!** 🎊

Koi confusion ho toh batao! 😊
