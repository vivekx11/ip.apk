# 🔧 Windows Build Troubleshooting Guide

## Common Issue: File Locking During Build

### Problem
```
java.io.IOException: Unable to delete directory
Failed to delete some children. This might happen because a process has files open
```

### Root Causes
1. **Antivirus software** scanning build files
2. **File Explorer** open in build directory
3. **IDE/Editor** holding file locks
4. **Previous build processes** still running

## 🚀 Solutions (Try in Order)

### Solution 1: Use Clean Build Scripts
Run one of these scripts from the `user_app` directory:

**Option A: Batch Script**
```cmd
clean_build.bat
```

**Option B: PowerShell Script**
```powershell
powershell -ExecutionPolicy Bypass -File clean_build.ps1
```

### Solution 2: Manual Steps
1. **Close all applications** that might be using the project
2. **Close File Explorer** if open in project directory
3. **Stop Flutter processes**:
   ```cmd
   taskkill /f /im dart.exe
   taskkill /f /im flutter.exe
   taskkill /f /im java.exe
   ```
4. **Delete build directories manually**:
   ```cmd
   rmdir /s /q build
   rmdir /s /q .dart_tool
   rmdir /s /q android\.gradle
   ```
5. **Run build**:
   ```cmd
   flutter clean
   flutter pub get
   flutter build apk --release
   ```

### Solution 3: Antivirus Exclusion
Add these folders to your antivirus exclusions:
- `C:\Users\[YourName]\OneDrive\Desktop\instantpick\user_app`
- `C:\src\flutter` (Flutter SDK)
- `%LOCALAPPDATA%\Pub\Cache` (Dart packages)

### Solution 4: Alternative Build Location
Move the project to a simpler path:
```cmd
# Move from OneDrive to local drive
C:\dev\user_app
```

### Solution 5: Use Different Terminal
Try building from:
- **Command Prompt** (Run as Administrator)
- **PowerShell** (Run as Administrator)
- **Git Bash**
- **VS Code Terminal**

## 🎯 Quick Fix Commands

### Force Clean Everything
```cmd
taskkill /f /im dart.exe /im flutter.exe /im java.exe
rmdir /s /q build .dart_tool android\.gradle
flutter clean
flutter pub get
flutter build apk --release
```

### Check Build Success
After successful build, you should see:
```
✓ Built build/app/outputs/flutter-apk/app-release.apk (XX.XMB)
```

## 🔍 Verification Steps

1. **Check APK exists**:
   ```cmd
   dir build\app\outputs\flutter-apk\app-release.apk
   ```

2. **Check APK size** (should be 15-30 MB):
   ```cmd
   powershell "Get-Item build\app\outputs\flutter-apk\app-release.apk | Select-Object Name, @{Name='Size(MB)';Expression={[math]::Round($_.Length/1MB,2)}}"
   ```

3. **Test APK installation** on Android device

## 🚨 If All Else Fails

### Last Resort Options
1. **Restart computer** to clear all file locks
2. **Disable antivirus temporarily** during build
3. **Use Flutter in Docker** container
4. **Build on different machine**

### Alternative: Debug Build
If release build keeps failing, try debug build:
```cmd
flutter build apk --debug
```

## 📱 Expected Results

### Successful Build Output
```
Font asset "MaterialIcons-Regular.otf" was tree-shaken...
Running Gradle task 'assembleRelease'...
✓ Built build/app/outputs/flutter-apk/app-release.apk (XX.XMB)
```

### APK Details
- **Size**: ~15-30 MB
- **Location**: `build/app/outputs/flutter-apk/app-release.apk`
- **Ready for**: Android 5.0+ devices

## 💡 Prevention Tips

1. **Close unnecessary applications** before building
2. **Exclude project folder** from antivirus real-time scanning
3. **Use local drive** instead of OneDrive/cloud storage
4. **Keep Flutter SDK updated**
5. **Regular cleanup** of build artifacts

The build should work with these solutions! 🎉