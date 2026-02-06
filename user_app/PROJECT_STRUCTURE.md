# User App (Pink Theme) - Project Structure

## 📱 Features Implemented
- ✅ OTP-based authentication
- ✅ Pink theme with clean UI
- ✅ Home screen with categories and featured content
- ✅ Bottom navigation (Home, Shops, Cart, Orders, Profile)
- ✅ Splash screen with branding
- ✅ Profile management with logout

## 📁 Folder Structure
```
user_app/
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   │   └── app_constants.dart      # API URLs, storage keys
│   │   └── theme/
│   │       └── app_theme.dart          # Pink theme configuration
│   ├── models/
│   │   ├── user_model.dart             # User data model
│   │   ├── shop_model.dart             # Shop data model
│   │   ├── product_model.dart          # Product data model
│   │   ├── cart_item_model.dart        # Cart item model
│   │   └── order_model.dart            # Order data model
│   ├── services/
│   │   ├── api_service.dart            # HTTP client wrapper
│   │   └── auth_service.dart           # Authentication logic
│   ├── screens/
│   │   ├── splash_screen.dart          # App startup screen
│   │   ├── auth/
│   │   │   ├── login_screen.dart       # Phone number input
│   │   │   └── otp_verification_screen.dart # OTP verification
│   │   └── home/
│   │       ├── main_screen.dart        # Bottom navigation wrapper
│   │       ├── home_screen.dart        # Dashboard with categories
│   │       ├── shops_screen.dart       # All shops listing
│   │       ├── cart_screen.dart        # Shopping cart
│   │       ├── orders_screen.dart      # Order history
│   │       └── profile_screen.dart     # User profile & settings
│   └── main.dart                       # App entry point with Provider setup
```

## 🎨 Theme Colors
- **Primary Pink**: #E91E63
- **Light Pink**: #F8BBD9  
- **Soft Pink**: #FCE4EC
- **White**: #FFFFFF
- **Dark Grey**: #424242

## 🔧 Dependencies
- `provider`: State management
- `http`: API calls
- `shared_preferences`: Local storage
- `cached_network_image`: Image caching
- `intl`: Date formatting

## 🚀 Next Steps
- [ ] Complete API integration
- [ ] Add product browsing and cart functionality
- [ ] Implement order placement and tracking
- [ ] Add image handling for products
- [ ] Connect to backend services