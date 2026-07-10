# 🚀 WorkLink - Trusted Work Marketplace for Africa

**Status**: ✅ Phase 1 MVP - Ready for Deployment  
**Platform**: Flutter (iOS + Android) + Web (Next.js/HTML)  
**Backend**: Supabase  
**Date**: July 10, 2026

---

## 📱 What is WorkLink?

WorkLink connects informal workers across Zambia and Africa with verified employment opportunities. Workers build **digital work passports** with secure payment protection while employers access pre-vetted talent.

### ✨ Key Features

- ✅ **Dual Authentication**: Phone OTP + Email/Password
- ✅ **Digital Work Passport**: Verifiable work history
- ✅ **Escrow Payments**: Secure, protected transactions
- ✅ **AI-Powered Matching**: Smart worker-employer connections
- ✅ **In-App Chat**: Real-time job communication
- ✅ **Trust Scores**: Ratings & reputation system

---

## 🎯 Quick Start (5 Minutes)

### Prerequisites
- ✅ Flutter 3.3.0+
- ✅ Android SDK 21+ (or iOS 12.0+)
- ✅ Supabase account (free tier available)

### Step 1: Clone & Setup
```bash
git clone https://github.com/Saleban71/myworklink.app.git
cd myworklink.app
flutter pub get
```

### Step 2: Configure Environment
```bash
# Copy template
cp .env.example .env

# Edit with your Supabase credentials
nano .env
```

**Required in `.env`:**
```
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### Step 3: Run Locally
```bash
# Start Android emulator
flutter emulators --launch Pixel_4_API_31

# Run app
flutter run
```

### Step 4: Test Login
- **Phone**: +260971234567 → Any 6-digit OTP
- **Email**: test@example.com / password123

---

## 📂 Project Structure

```
myworklink.app/
├── lib/
│   ├── core/
│   │   ├── supabase.dart              (Supabase initialization)
│   │   ├── theme.dart                 (UI design system)
│   ├── screens/
│   │   ├── auth_selection_screen.dart (Choose auth method)
│   │   ├── phone_auth_screen.dart     (Phone OTP)
│   │   ├── email_auth_screen.dart     (Email/password)
│   │   ├── home_router.dart           (Main navigation)
│   │   ├── worker_screens.dart        (Worker UI)
│   │   ├── employer_screens.dart      (Employer UI)
│   ├── services/
│   │   └── services.dart              (Supabase API layer)
│   ├── models/
│   │   └── models.dart                (Data models)
│   └── main.dart                      (App entry point)
├── index.html                         (Web landing page)
├── .env.example                       (Configuration template)
├── ANDROID_LOGIN_ERROR_FIX.md         (⭐ Android .env fix guide)
├── DEPLOYMENT_GUIDE.md                (✅ Production deployment)
└── pubspec.yaml                       (Dependencies)
```

---

## 🔐 Authentication Methods

### Phone Number (OTP)
```dart
final auth = AuthService();
await auth.sendOtp('+260971234567');
await auth.verifyOtp('+260971234567', '123456');
```

### Email & Password
```dart
// Sign Up
await auth.signUpWithEmail('user@example.com', 'password123');

// Sign In
await auth.signInWithEmail('user@example.com', 'password123');

// Password Reset
await auth.sendPasswordResetEmail('user@example.com');
```

✅ **All implemented in `services.dart`**

---

## 🚀 Deployment

### 📋 Choose Your Path

| Platform | Guide | Time | Status |
|----------|-------|------|--------|
| **Android** | [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md#android-deployment) | 2-4 hours | ✅ Ready |
| **iOS** | [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md#ios-deployment) | 24-48 hours | ✅ Ready |
| **Web** | [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md#web-deployment) | 5 minutes | ✅ Ready |

### ⚠️ Android Login Error?

If you see: `no static resource oauth-service/api/v1/user-permission/login`

**Fix**: Follow [ANDROID_LOGIN_ERROR_FIX.md](./ANDROID_LOGIN_ERROR_FIX.md)

**TL;DR**:
```bash
# 1. Create .env with Supabase credentials
# 2. Run: flutter clean && flutter pub get
# 3. Run: flutter run
```

---

## 🛠️ Development Commands

```bash
# Get latest dependencies
flutter pub get

# Run with logging
flutter run -v

# Build APK
flutter build apk

# Build iOS
flutter build ios

# Format code
dart format lib/

# Analyze for errors
dart analyze
```

---

## 📊 Tech Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Frontend** | Flutter | Cross-platform mobile app |
| **Web** | HTML/CSS/JS | Landing page |
| **Backend** | Supabase | Auth, database, storage |
| **Auth** | Supabase Auth | Phone OTP + Email/Password |
| **Database** | PostgreSQL | Worker/job/payment data |
| **Storage** | Supabase Storage | Profile images, documents |
| **Hosting** | Vercel + Play Store + App Store | Web + Mobile distribution |

---

## ✅ Ready to Deploy?

Follow these steps **in order**:

1. ✅ Local testing complete
2. ✅ All auth methods working
3. ✅ `.env` file configured with REAL credentials
4. ✅ Read [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)
5. ✅ Follow platform-specific deployment steps
6. ✅ Test on production

---

## 📚 Documentation

- **[DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)** - Complete deployment instructions for all platforms
- **[ANDROID_LOGIN_ERROR_FIX.md](./ANDROID_LOGIN_ERROR_FIX.md)** - Fix Android `.env` authentication issues
- **[.env.example](./.env.example)** - Configuration template
- **[AUTHENTICATION_STATUS.md](./AUTHENTICATION_STATUS.md)** - What was fixed

---

## 🔗 Important Links

| Link | Purpose |
|------|---------|
| [Supabase Dashboard](https://app.supabase.com) | Get API credentials |
| [Google Play Console](https://play.google.com/apps/publish) | Publish Android app |
| [Apple App Store Connect](https://appstoreconnect.apple.com) | Publish iOS app |
| [Vercel Dashboard](https://vercel.com) | Deploy web version |

---

## ❌ What NOT to Do

- ❌ Don't commit `.env` to GitHub (it has secrets)
- ❌ Don't hardcode Supabase URL in code
- ❌ Don't use placeholder credentials in production
- ❌ Don't share private keys publicly
- ❌ Don't deploy without `.env` file

---

## ✨ Status Checklist

- [x] Phone OTP authentication
- [x] Email/password authentication
- [x] Worker profiles
- [x] Employer profiles
- [x] Job posting
- [x] Escrow payments
- [x] In-app chat
- [x] Trust scores
- [x] `.env` configuration
- [x] Android ready
- [x] iOS ready
- [x] Web ready
- [x] Deployment guides

---

## 🆘 Getting Help

### Android Login Error?
→ Read [ANDROID_LOGIN_ERROR_FIX.md](./ANDROID_LOGIN_ERROR_FIX.md)

### Deployment Issues?
→ Read [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)

### General Questions?
→ Check [AUTHENTICATION_STATUS.md](./AUTHENTICATION_STATUS.md)

---

## 📄 License

WorkLink © 2026. All rights reserved.

Built with ❤️ for African workers | Empowering opportunity across the continent

---

## 🎯 Next Steps

1. ✅ Configure `.env` with real Supabase credentials
2. ✅ Test locally on Android/iOS
3. ✅ Follow DEPLOYMENT_GUIDE.md
4. ✅ Deploy to production
5. ✅ Monitor app performance

**Ready to go live? Let's build WorkLink! 🚀**
