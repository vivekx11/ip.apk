# Shop Owner App - Lib Directory Structure

## Overview
Yeh document shop_owner_app ke `lib` folder ki complete file structure ko describe karta hai.

---

## Root Files
- `main.dart` - Application ka entry point

---

## Directory Structure

### 📁 core/
Application ke core components aur configurations

#### constants/
- `app_constants.dart` - Application-wide constants aur configuration values

#### theme/
- `app_theme.dart` - Application ki theme aur styling definitions

---

### 📁 models/
Data models aur entities
- `order_model.dart` - Order data model
- `shop_owner_model.dart` - Shop owner data model

---

### 📁 providers/
State management providers (Provider pattern)
- `auth_provider.dart` - Authentication state management
- `order_provider.dart` - Order state management
- `product_provider.dart` - Product state management
- `shop_provider.dart` - Shop state management
- `user_provider.dart` - User state management

---

### 📁 screens/
UI screens aur pages

#### auth/
Authentication related screens
- `google_login_screen.dart` - Google sign-in screen
- `login_screen.dart` - Main login screen
- `otp_verification_screen.dart` - OTP verification screen
- `phone_login_screen.dart` - Phone number login screen
- `profile_setup_screen.dart` - User profile setup screen
- `username_setup_screen.dart` - Username setup screen

#### home/
Main application screens
- `dashboard_screen.dart` - Dashboard screen
- `main_screen.dart` - Main navigation screen
- `optimized_dashboard_screen.dart` - Optimized dashboard implementation
- `orders_screen.dart` - Orders listing screen
- `products_screen.dart` - Products listing screen
- `profile_screen.dart` - User profile screen

#### location/
Location related screens
- `shop_location_setup_screen.dart` - Shop location setup aur map integration

#### orders/
Order management screens
- `order_details_screen.dart` - Order details view
- `order_management_screen.dart` - Order management interface
- `pickup_code_verification_screen.dart` - Pickup code verification
- `qr_scanner_screen.dart` - QR code scanner

#### products/
Product management screens
- `add_product_screen.dart` - Add new product
- `edit_product_screen.dart` - Edit existing product
- `product_details_screen.dart` - Product details view
- `upload_product_example.dart` - Product upload example/demo

#### shop/
Shop management screens
- `shop_registration_screen.dart` - Shop registration aur setup

#### Root screen files
- `splash_screen.dart` - Application splash screen

---

### 📁 services/
Business logic aur API services

#### Authentication Services
- `auth_service.dart` - Main authentication service
- `google_auth_service.dart` - Google authentication integration
- `local_auth_service.dart` - Local authentication (biometric, etc.)
- `simple_auth_service.dart` - Simplified authentication service

#### API Services
- `api_service.dart` - Generic API service
- `product_api_service.dart` - Product-specific API calls
- `shop_api_service.dart` - Shop-specific API calls
- `order_service.dart` - Order management service
- `dashboard_service.dart` - Dashboard data service

#### Upload Services
- `cloudinary_upload_service.dart` - Cloudinary image upload
- `image_upload_service.dart` - Generic image upload service
- `photo_upload_service.dart` - Photo upload service
- `firebase_service.dart` - Firebase integration

#### Other Services
- `network_service.dart` - Network connectivity management
- `shop_sync_service.dart` - Shop data synchronization

---

### 📁 utils/
Utility functions aur helpers
- `date_utils.dart` - Date formatting aur manipulation utilities

---

### 📁 widgets/
Reusable UI components
- `offline_banner.dart` - Offline mode banner widget
- `offline_screen.dart` - Offline mode full screen

---

## File Count Summary
- **Total Directories:** 11
- **Total Files:** 56
  - Core: 2 files
  - Models: 2 files
  - Providers: 5 files
  - Screens: 26 files
  - Services: 16 files
  - Utils: 1 file
  - Widgets: 2 files
  - Root: 1 file (main.dart)

---

## Architecture Pattern
Application **Provider pattern** use kar raha hai state management ke liye, aur **service layer** architecture follow kar raha hai business logic ke liye.

---

*Last Updated: February 23, 2026*
