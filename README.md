# 🥐 Jagdish Foods — Flutter Mobile App

**Vadodara's Taste Since 1945 · Production-Ready D2C E-Commerce App**

---

## 📱 Overview

A complete, production-grade Flutter mobile app for **Jagdish Foods** — an authentic Gujarati snacks brand. This is a full D2C e-commerce experience with 25+ screens, state management, navigation, animations, and payment integration.

---

## 🏗️ Tech Stack

| Layer | Technology |
|---|---|
| **Framework** | Flutter 3.10+ / Dart 3.0+ |
| **State Management** | Provider + ChangeNotifier |
| **Navigation** | GoRouter 13 (declarative, deep-link ready) |
| **Local Storage** | SharedPreferences + FlutterSecureStorage + Hive |
| **Networking** | Dio + Retrofit (REST API) |
| **Animations** | flutter_animate + Lottie |
| **UI** | Material 3 + Custom Design System |
| **Payments** | Razorpay Flutter SDK |
| **Maps** | Google Maps Flutter |
| **Auth** | OTP via SMS (Firebase Auth / custom) |
| **DI** | GetIt + Injectable |

---

## 📂 Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart         # Brand color palette
│   │   └── app_constants.dart      # App-wide constants
│   ├── theme/
│   │   ├── app_theme.dart          # Material 3 theme
│   │   └── app_text_styles.dart    # Typography system
│   └── routes/
│       └── app_router.dart         # GoRouter navigation
│
├── data/
│   ├── models/
│   │   └── models.dart             # ProductModel, CartItem, OrderModel, UserModel...
│   └── repositories/               # API + local data sources
│
├── providers/
│   ├── auth_provider.dart          # Auth state (OTP login/logout)
│   ├── cart_provider.dart          # Cart CRUD + coupon logic
│   └── wishlist_provider.dart      # Wishlist toggle + persistence
│
├── presentation/
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── splash_screen.dart
│   │   │   ├── welcome_screen.dart
│   │   │   ├── phone_auth_screen.dart  (includes OtpScreen)
│   │   │   └── profile_setup_screen.dart
│   │   ├── home/
│   │   │   ├── main_shell.dart         # Bottom nav shell
│   │   │   ├── home_screen.dart        # Full home with all sections
│   │   │   └── search_screen.dart
│   │   ├── product/
│   │   │   ├── product_detail_screen.dart
│   │   │   └── category_screen.dart
│   │   ├── cart/
│   │   │   └── cart_screen.dart
│   │   ├── checkout/
│   │   │   ├── checkout_screen.dart
│   │   │   └── order_success_screen.dart (inside checkout_screen.dart)
│   │   ├── orders/
│   │   │   ├── order_list_screen.dart   (inside order_tracking_screen.dart)
│   │   │   ├── order_detail_screen.dart
│   │   │   └── order_tracking_screen.dart
│   │   ├── profile/
│   │   │   ├── profile_screen.dart
│   │   │   ├── edit_profile_screen.dart
│   │   │   └── address_screen.dart
│   │   ├── wishlist/
│   │   │   └── wishlist_screen.dart    (includes OffersScreen, SearchScreen, CategoryScreen)
│   │   └── offers/
│   │       └── offers_screen.dart
│   │
│   └── widgets/
│       ├── common/
│       │   └── jf_button.dart          # JFButton, NoInternetWidget, JFShimmer
│       ├── product/
│       │   └── product_card.dart
│       └── home/
│           └── banner_card.dart        # BannerCard, CategoryItem, ReorderCard, ComboCard
│
└── main.dart                           # App entry point
```

---

## 🎨 Design System

### Colors
```dart
AppColors.primary      // #0083BC — Trust Blue
AppColors.green        // #52B52A — Freshness
AppColors.yellow       // #F4A300 — Energy / Offers
AppColors.gold         // #D4AF37 — Premium
AppColors.cream        // #FFF5E1 — Warm Background
```

### Typography
- **Headings:** PlayfairDisplay (serif) — traditional brand feel
- **Body/UI:** DM Sans — clean, modern readability

### Radius / Spacing
- Card radius: 14px | Large: 20px | Button: 14px
- Grid: 8pt system
- Padding standard: 16px

---

## 🚀 Getting Started

### Prerequisites
```bash
flutter --version     # 3.10.0+
dart --version        # 3.0.0+
```

### Installation
```bash
# 1. Clone the repository
git clone https://github.com/yourorg/jagdish-foods-app.git
cd jagdish_foods

# 2. Install dependencies
flutter pub get

# 3. Generate code (Hive adapters, Retrofit, etc.)
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Add your assets (fonts + images)
# Place fonts in assets/fonts/
# Place images in assets/images/
# Place Lottie JSON in assets/lottie/

# 5. Run
flutter run
```

### Required Assets
Download and place in `assets/fonts/`:
- `PlayfairDisplay-Regular.ttf`
- `PlayfairDisplay-Bold.ttf`
- `PlayfairDisplay-SemiBold.ttf`
- `DMSans-Regular.ttf`
- `DMSans-Medium.ttf`
- `DMSans-SemiBold.ttf`
- `DMSans-Bold.ttf`

Place in `assets/images/`:
- `jagdish_logo.png` ← Your brand logo

---

## 🔧 Configuration

### 1. Razorpay Payment
```dart
// lib/core/constants/app_constants.dart
static const String razorpayKey = 'rzp_live_YOUR_KEY_HERE';
```

### 2. Google Maps
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<meta-data android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_MAPS_KEY"/>
```

```swift
// ios/Runner/AppDelegate.swift
GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_KEY")
```

### 3. Firebase (Optional)
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure
flutterfire configure --project=jagdish-foods-prod
```
Then uncomment Firebase dependencies in `pubspec.yaml`.

### 4. API Base URL
```dart
// lib/core/constants/app_constants.dart
static const String baseUrl = 'https://api.jagdishfoods.com/v1';
```

---

## 📱 Screens Implemented

| # | Screen | Status |
|---|---|---|
| 1 | Splash Screen | ✅ Full |
| 2 | Welcome Screen | ✅ Full |
| 3 | Phone Number Input | ✅ Full |
| 4 | OTP Verification (6-digit) | ✅ Full |
| 5 | Home Screen | ✅ Full |
| 6 | Banner Carousel (auto-scroll) | ✅ Full |
| 7 | Category Grid | ✅ Full |
| 8 | Order Again Rail | ✅ Full |
| 9 | Best Sellers | ✅ Full |
| 10 | Featured Combos | ✅ Full |
| 11 | Search Screen | ✅ Full |
| 12 | Category Listing | ✅ Full |
| 13 | Product Detail | ✅ Full |
| 14 | Cart Screen + Coupon | ✅ Full |
| 15 | Checkout (3-step) | ✅ Full |
| 16 | Order Success + Animation | ✅ Full |
| 17 | Order List | ✅ Full |
| 18 | Order Detail | ✅ Full |
| 19 | Order Tracking (Timeline + Map) | ✅ Full |
| 20 | Profile Screen | ✅ Full |
| 21 | Wishlist | ✅ Full |
| 22 | Offers & Coupons | ✅ Full |
| 23 | Empty Cart | ✅ Full |
| 24 | No Internet Widget | ✅ Component |
| 25 | Skeleton Loader | ✅ Component |

---

## 🔑 Key Features

### Cart System
- Persistent cart via SharedPreferences (survives app restart)
- Real-time price calculation
- Coupon validation with API simulation
- Free delivery progress bar
- Swipe-to-delete cart items

### Auth Flow
- Phone number + OTP (6-digit)
- JWT token stored in FlutterSecureStorage
- Auto-login on app restart

### Navigation
- GoRouter with shell routes (bottom nav persistence)
- Custom slide/fade transitions
- Deep link support (`jagdishfoods://product/123`)

### Animations
- Splash logo spring animation
- Add-to-cart micro-interaction
- Banner auto-scroll with page indicator
- Timeline reveal animations
- Order success pulse animation

---

## 🧪 Testing

```bash
# Unit tests
flutter test test/unit/

# Widget tests
flutter test test/widget/

# Integration tests
flutter test integration_test/
```

---

## 📦 Build

### Android APK
```bash
flutter build apk --release --obfuscate --split-debug-info=build/debug-info
```

### Android App Bundle (Play Store)
```bash
flutter build appbundle --release --obfuscate --split-debug-info=build/debug-info
```

### iOS
```bash
flutter build ipa --release
```

---

## 🔐 Security

- JWT stored in FlutterSecureStorage (Keychain / Keystore)
- Certificate pinning via Dio interceptors
- Obfuscated release builds
- No API keys in source code (use environment variables or secrets)

---

## 📋 Environment Variables

Create a `.env` file (use `flutter_dotenv`):
```env
API_BASE_URL=https://api.jagdishfoods.com/v1
RAZORPAY_KEY=rzp_live_xxx
GOOGLE_MAPS_KEY=AIzaSy...
FIREBASE_PROJECT_ID=jagdish-foods-prod
```

---

## 👨‍💻 Code Style

```bash
# Analyze
flutter analyze

# Format
dart format lib/ --line-length 100
```

---

## 📞 Support

- 🌐 Website: jagdishfoods.com
- 📧 Email: dev@jagdishfoods.com
- 📍 Vadodara, Gujarat, India

---

**Jagdish Foods © 2024 · Vadodara's Taste Since 1945 🥐**
