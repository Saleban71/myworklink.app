
# WorkLink App - Complete Setup & Deployment Guide

## 📋 Table of Contents
1. [Project Overview](#project-overview)
2. [Local Development Setup](#local-development-setup)
3. [Authentication Configuration](#authentication-configuration)
4. [Android Deployment](#android-deployment)
5. [iOS/App Store Deployment](#iosapp-store-deployment)
6. [Testing Checklist](#testing-checklist)
7. [Troubleshooting](#troubleshooting)

---

## 🎯 Project Overview

**WorkLink** is a Flutter application that connects informal workers with employers in Zambia and the wider African region. The app supports both:
- **Workers**: Can register, build digital work passports, and apply for jobs
- **Employers**: Can post jobs, hire workers, and manage payments

**Current Status**: Phase 1 MVP
- ✅ Dual authentication (phone OTP + email/password)
- ✅ Supabase backend integration
- ✅ Worker and employer profiles
- ✅ Job posting and matching
- ✅ Escrow payments
- 🔄 Ready for deployment

---

## 🚀 Local Development Setup

### Prerequisites
```bash
# Install Flutter (latest stable)
flutter --version  # Should be 3.10.0 or higher

# Install Android SDK
# Android Studio: Settings → Languages & Frameworks → Android SDK
# Required: Android API 21+ (minimum SDK)
# Recommended: API 31+ (target SDK)

# For iOS (macOS only)
xcode-select --install
pod repo update
```

### Step 1: Clone & Setup Project
```bash
# Clone the repository
git clone https://github.com/Saleban71/myworklink.app.git
cd myworklink.app

# Get Flutter dependencies
flutter pub get

# Run code generation (for models, if using build_runner)
flutter pub run build_runner build --delete-conflicting-outputs

# Get platform-specific dependencies
flutter pub get
```

### Step 2: Configure Environment Variables
```bash
# Copy the example file
cp .env.example .env

# Edit .env with your Supabase credentials
nano .env  # or use your preferred editor
```

**Required variables** (from Supabase Dashboard):
```bash
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### Step 3: Get Supabase Credentials

1. Visit [Supabase Dashboard](https://app.supabase.com)
2. Create a new project or use existing one
3. Navigate to **Settings → API**
4. Copy:
   - **Project URL** → `SUPABASE_URL`
   - **anon public key** → `SUPABASE_ANON_KEY`
5. Go to **Authentication → Providers**
   - Enable **Phone**
   - Enable **Email**
6. Go to **Authentication → Email Templates**
   - Configure confirmation email
   - Configure password reset email

### Step 4: Run Locally

```bash
# Run on Android emulator
flutter emulators --launch Pixel_4_API_31
flutter run

# Or run on connected device
flutter devices
flutter run -d <device-id>

# For verbose logging
flutter run -v
```

---

## 🔐 Authentication Configuration

### Phone-Based OTP (Already Working)
- User enters phone number: `+260 97 1234567`
- Receives SMS with 6-digit OTP code
- Enters OTP to verify and login
- No credentials needed

### Email-Based Authentication (Newly Added)
Users can now:
1. **Sign Up** with email + password
2. **Sign In** with email + password
3. **Reset Password** via email link

#### Configure Email Service in Supabase

**Option A: Supabase Email Service (Free tier)**
```
✅ Pros: Built-in, no setup needed
❌ Cons: Limited to 4 emails/hour (free tier)
```

1. Go to **Authentication → Providers → Email**
2. Ensure "Email" is enabled
3. Go to **Email Templates**
4. Customize templates if needed

**Option B: Custom SMTP (Recommended for Production)**
```
✅ Pros: Unlimited emails, better deliverability
❌ Cons: Requires external email service
```

1. Go to **Authentication → Providers → Email**
2. Configure Custom SMTP:
   - **SMTP Host**: `smtp.gmail.com` (or your provider)
   - **SMTP Port**: `587`
   - **SMTP User**: `your-email@gmail.com`
   - **SMTP Password**: Generate app-specific password
   - **Sender Email**: `noreply@worklink.zm`

3. Update `.env`:
   ```bash
   SMTP_HOST=smtp.gmail.com
   SMTP_PORT=587
   SMTP_USER=your-email@gmail.com
   SMTP_PASSWORD=your-16-char-password
   ```

#### Gmail App Password Setup
1. Enable 2-Factor Authentication on Gmail
2. Go to [Google Account Security](https://myaccount.google.com/security)
3. Under "App passwords" → Select "Mail" and "Windows Computer"
4. Copy the 16-character password
5. Use in `.env` as `SMTP_PASSWORD`

### Test Authentication

```bash
# Test phone OTP
# 1. Launch app
# 2. Select "Phone Number"
# 3. Enter: +1234567890 (Supabase test number)
# 4. Enter OTP: any 6 digits (Supabase auto-verifies test numbers)

# Test email
# 1. Launch app
# 2. Select "Email Address"
# 3. Sign Up with: test@example.com / password123
# 4. Check email for verification link
# 5. Or sign in directly without verification (if EMAIL_VERIFICATION_REQUIRED=false)
```

---

## 📱 Android Deployment

### Step 1: Configure Android App Settings

**File**: `android/app/build.gradle`
```gradle
android {
    namespace "com.worklink.app"
    
    defaultConfig {
        applicationId "com.worklink.app"
        minSdkVersion 21
        targetSdkVersion 33
        versionCode 1
        versionName "1.0.0"
    }
}
```

**File**: `android/app/src/main/AndroidManifest.xml`
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.worklink.app">

    <!-- Required permissions -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.RECEIVE_SMS" />

    <application
        android:label="WorkLink"
        android:icon="@mipmap/ic_launcher"
        android:usesCleartextTraffic="false">
        
        <activity
            android:name=".MainActivity"
            android:launchMode="singleTop"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
```

### Step 2: Generate Release Signing Key

```bash
# Generate keystore (one-time)
keytool -genkey -v -keystore ~/worklink.keystore \
    -keyalg RSA -keysize 2048 -validity 10000 \
    -alias worklink_key

# Store the password securely! You'll need it for releases.
```

**File**: `android/key.properties`
```properties
storeFile=/Users/your-username/worklink.keystore
storePassword=your-keystore-password
keyPassword=your-key-password
keyAlias=worklink_key
```

### Step 3: Build APK

```bash
# Development build (for testing on devices)
flutter build apk --debug

# Release build (for Play Store)
flutter build apk --release

# Built APK location:
# build/app/outputs/apk/release/app-release.apk
```

### Step 4: Upload to Google Play Store

1. **Create Developer Account**: [Google Play Console](https://play.google.com/apps/publish)
   - One-time fee: $25
   - Setup merchant account for payments

2. **Create App Listing**:
   - App name: "WorkLink"
   - Description, screenshots, privacy policy
   - Category: "Business" or "Lifestyle"
   - Content rating questionnaire

3. **Upload APK**:
   - Go to **Release → Production**
   - Upload `app-release.apk`
   - Fill release notes
   - Click "Review and Roll Out"

4. **App Review**: Google typically reviews within 2-4 hours

5. **Live**: App appears on Play Store within 2-3 hours of approval

---

## 🍎 iOS/App Store Deployment

### Prerequisites (macOS only)
```bash
xcode-select --install
gem install cocoapods  # Or use Homebrew
```

### Step 1: Configure iOS App Settings

**File**: `ios/Runner/Info.plist`
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>
    <string>WorkLink</string>
    
    <key>CFBundleVersion</key>
    <string>1</string>
    
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>WorkLink uses your location to find nearby jobs</string>
    
    <key>NSPhotoLibraryUsageDescription</key>
    <string>WorkLink needs access to your photo library for profile pictures</string>
    
    <key>NSCameraUsageDescription</key>
    <string>WorkLink needs camera access to take profile photos</string>
    
    <key>NSContactsUsageDescription</key>
    <string>WorkLink needs access to contacts for profile verification</string>
</dict>
</plist>
```

### Step 2: Create iOS App in App Store Connect

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. **My Apps** → **Create New App**
3. Fill in:
   - Platform: iOS
   - App Name: WorkLink
   - Bundle ID: `com.worklink.app`
   - SKU: `worklink_001`
   - User Access: Full Access

### Step 3: Generate Release Build

```bash
# Update iOS dependencies
cd ios
pod update
cd ..

# Build iOS app for release
flutter build ios --release

# Or for App Store (creates .ipa)
flutter build ipa --release
```

### Step 4: Upload to App Store using Xcode

```bash
# Open Xcode project
open ios/Runner.xcworkspace

# In Xcode:
# 1. Select "Runner" → "Signing & Capabilities"
# 2. Select Team (your Apple Developer account)
# 3. Automatic signing enabled
# 4. Product → Archive
# 5. Distribute App → App Store
# 6. Upload to App Store Connect
```

### Step 5: Configure App Store Listing

1. **App Information**:
   - Category: Business
   - Subtitle: "Trusted work. Secure pay."
   - Keywords: work, jobs, Zambia, Africa

2. **Screenshots** (required for each device):
   - iPhone 6.5" (1284×2778)
   - iPad 12.9" (2048×2732)
   - Include 2-5 app feature screenshots

3. **Description** (up to 170 characters):
   ```
   Connect with trusted work opportunities. Build your digital work passport.
   ```

4. **Privacy Policy** (required):
   - Link to: `https://worklink.zm/privacy`

5. **Support URL** (required):
   - Link to: `https://worklink.zm/support`

6. **Version Information**:
   - What's New: "Initial release"

7. **App Review Information**:
   - Demo account email
   - Demo password
   - Notes for reviewers

### Step 6: Submit for Review

1. Go to **Version Release** section
2. Review all information
3. Click **Submit for Review**
4. Apple reviews typically within 24-48 hours

---

## ✅ Testing Checklist

### Authentication Testing

- [ ] **Phone OTP Flow**
  - [ ] Can enter phone number with +260 country code
  - [ ] Receives SMS OTP
  - [ ] Can verify with correct OTP
  - [ ] Fails with incorrect OTP
  - [ ] OTP expires after timeout

- [ ] **Email Sign Up Flow**
  - [ ] Can enter valid email
  - [ ] Password validation (min 6 chars)
  - [ ] Password confirmation matches
  - [ ] Account created successfully
  - [ ] Can sign in immediately (if no verification required)
  - [ ] Receives confirmation email

- [ ] **Email Sign In Flow**
  - [ ] Can sign in with correct credentials
  - [ ] Fails with wrong password
  - [ ] Shows "account not found" for unregistered email
  - [ ] Can click "forgot password"
  - [ ] Receives password reset email

### App Functionality Testing

- [ ] **Worker Profile**
  - [ ] Can complete profile setup
  - [ ] Can add skills
  - [ ] Can set rates
  - [ ] Can see work passport

- [ ] **Employer Profile**
  - [ ] Can complete employer profile
  - [ ] Can post job listings
  - [ ] Can view applications

- [ ] **Jobs**
  - [ ] Can post new job
  - [ ] Can view matching workers
  - [ ] Can invite workers
  - [ ] Can fund escrow

- [ ] **Navigation**
  - [ ] All screens load without crash
  - [ ] Back button works correctly
  - [ ] Authentication persists across app restart

### Performance Testing

- [ ] App starts in under 3 seconds
- [ ] Screens load in under 1 second
- [ ] No memory leaks (check with Android Profiler)
- [ ] Battery usage reasonable
- [ ] Data usage minimal

### Device Testing

```bash
# Test on multiple devices
flutter devices

# Test on Android emulator
flutter emulators --launch Pixel_4_API_31
flutter run

# Test on physical Android device
adb devices
flutter run -d <device-id>

# Test on iOS simulator (macOS)
flutter run -d "iPhone 14 Pro Max"
```

---

## 🔧 Troubleshooting

### Common Issues

#### 1. "SUPABASE_URL not found in .env"
```
Solution:
1. Verify .env file exists in project root
2. Run: cat .env
3. Check SUPABASE_URL has correct value
4. Run: flutter pub get
5. Restart app
```

#### 2. "Supabase connection failed"
```
Solution:
1. Check internet connectivity
2. Verify SUPABASE_URL is correct format: https://...supabase.co
3. Check SUPABASE_ANON_KEY is not expired
4. Go to Supabase dashboard → Project → Settings → API
5. Regenerate keys if needed
```

#### 3. "Email not sending"
```
Solution:
1. Verify email provider is enabled in Supabase
2. Check SMTP credentials if using custom
3. Verify sender email is confirmed
4. Check Supabase logs: Authentication → Auth Logs
5. For Gmail: use app-specific password (not regular password)
```

#### 4. "Phone OTP not received"
```
Solution:
1. Verify phone number format: +260971234567
2. Check SMS credits in Supabase
3. Go to Supabase → Authentication → Providers → Phone
4. Verify SMS provider is configured
5. Test with Supabase test number: +1234567890
```

#### 5. "App crashes on startup"
```
Solution:
1. Check Supabase initialization error
2. Verify all required environment variables
3. Run: flutter clean && flutter pub get
4. Rebuild: flutter run -v (verbose for error details)
5. Check console logs for stack trace
```

#### 6. "Gradle build fails on Android"
```
Solution:
1. Update Gradle: flutter pub get
2. Clean build: flutter clean
3. Update Android SDK: Android Studio → Settings → Android SDK
4. Verify minSdkVersion: 21
5. Run: flutter run -v
```

#### 7. "iOS build fails"
```
Solution (macOS only):
1. Update pods: cd ios && pod update && cd ..
2. Clean: flutter clean
3. Get dependencies: flutter pub get
4. Build: flutter build ios --release -v
5. Check Xcode: open ios/Runner.xcworkspace
```

---

## 📞 Support & Next Steps

### Phase 1 Complete ✅
- Dual authentication (phone + email)
- Worker & employer profiles
- Job posting & matching
- Escrow payments
- In-app chat

### Phase 2 (Planned)
- [ ] Push notifications (Firebase)
- [ ] Social media sharing
- [ ] Advanced job filtering
- [ ] Payment integration (MTN MoMo, Airtel Money)
- [ ] AI profile generation
- [ ] Dark mode
- [ ] Multi-language support

### Resources
- 📖 [Flutter Documentation](https://flutter.dev/docs)
- 🗄️ [Supabase Documentation](https://supabase.com/docs)
- 🔐 [Authentication Best Practices](https://owasp.org/www-project-mobile-top-10/)
- 📱 [Google Play Console](https://play.google.com/apps/publish)
- 🍎 [App Store Connect](https://appstoreconnect.apple.com)

### Questions?
- Email: support@worklink.zm
- GitHub Issues: [WorkLink Issues](https://github.com/Saleban71/myworklink.app/issues)

---

**Last Updated**: July 10, 2026
**Version**: 1.0.0
