# 🚀 WorkLink - Complete Deployment Guide

**Status**: ✅ Ready for Production  
**Last Updated**: July 10, 2026  
**Version**: 1.0.0

---

## 📋 Table of Contents

1. [Deployment Overview](#deployment-overview)
2. [Web Deployment (Vercel)](#web-deployment-vercel)
3. [Android Deployment (Google Play)](#android-deployment-google-play)
4. [iOS Deployment (App Store)](#ios-deployment-app-store)
5. [All-In-One Deployment Timeline](#all-in-one-deployment-timeline)
6. [Post-Deployment Checklist](#post-deployment-checklist)

---

## 📊 Deployment Overview

### What Gets Deployed Where?

| Component | Platform | Status | Time |
|-----------|----------|--------|------|
| **Website/Landing Page** | Vercel | ✅ Ready | 5 min |
| **Mobile App (Android)** | Google Play Store | ✅ Ready | 2-4 hours |
| **Mobile App (iOS)** | Apple App Store | ✅ Ready | 24-48 hours |

### Architecture

```
┌─────────────────────────────────────────────────────┐
│         WorkLink Complete Deployment Stack          │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Website: vercel.com/worklink                      │
│  ├─ Landing Page (HTML)                            │
│  ├─ Features Overview                              │
│  └─ Download Links                                 │
│                                                     │
│  Android App: Google Play Store                    │
│  ├─ APK Release                                    │
│  ├─ Store Listing                                  │
│  └─ Automatic Updates                              │
│                                                     │
│  iOS App: Apple App Store                          │
│  ├─ IPA Release                                    │
│  ├─ Store Listing                                  │
│  └─ Automatic Updates                              │
│                                                     │
│  Backend: Supabase                                 │
│  ├─ Authentication                                 │
│  ├─ Database                                       │
│  └─ Storage                                        │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## 🌐 Web Deployment (Vercel)

### Step 1: Connect GitHub to Vercel

1. **Go to Vercel**: https://vercel.com
2. **Sign up/Login** with GitHub account
3. **Import Project**:
   - Click "Add New" → "Project"
   - Select your GitHub account
   - Find `myworklink.app` repository
   - Click "Import"

### Step 2: Configure Vercel Settings

**Project Settings:**
```
Framework Preset: Other
Build Command: (leave blank - serves index.html)
Output Directory: (leave blank)
Install Command: (leave blank)
Environment Variables: None needed
```

### Step 3: Deploy

```bash
# Option A: Deploy via Vercel Dashboard
1. Click "Deploy"
2. Wait for build to complete (~2-3 minutes)
3. Get your URL: myworklink.vercel.app

# Option B: Deploy via CLI (if you prefer)
npm install -g vercel
vercel
# Follow prompts and approve deployment
```

### Step 4: Verify Deployment

- ✅ Visit: https://myworklink.vercel.app
- ✅ Check landing page loads
- ✅ Check "Download App" buttons work
- ✅ Test mobile responsiveness (use browser DevTools)

### Step 5: Custom Domain (Optional)

1. Go to Vercel Dashboard → Project Settings
2. **Domains** section
3. Add custom domain: `worklink.zm` (if you own it)
4. Follow DNS setup instructions
5. Wait 24 hours for DNS propagation

**Result**: Website live on Vercel ✅

---

## 📱 Android Deployment (Google Play)

### Prerequisites

- ✅ Google Play Developer account ($25 one-time)
- ✅ Merchant account (for payments)
- ✅ App signing certificate

### Step 1: Create Google Play Developer Account

1. Go to: https://play.google.com/apps/publish
2. Sign in with Google account
3. Accept Developer Agreement
4. Pay $25 one-time fee
5. Complete merchant account setup

### Step 2: Generate Signing Certificate

**First time only:**

```bash
# Generate keystore file
keytool -genkey -v -keystore ~/worklink.keystore \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -alias worklink_key

# When prompted, enter:
# - Password: (save securely!)
# - First/Last Name: Your Name
# - Organization: WorkLink
# - City: Lusaka
# - State: Lusaka
# - Country: ZM

# Verify keystore was created
ls -la ~/worklink.keystore
```

**Store this securely!** You'll need it for future updates.

### Step 3: Configure Android Build

**File: `android/key.properties`** (create if missing)

```properties
storeFile=/Users/YOUR_USERNAME/worklink.keystore
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=worklink_key
```

**File: `android/app/build.gradle`** (update)

```gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        applicationId "com.worklink.app"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
    
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile file(keystoreProperties['storeFile'])
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### Step 4: Build Release APK

```bash
# Build release APK
flutter build apk --release

# Output location:
# build/app/outputs/apk/release/app-release.apk

# Verify file exists
ls -lh build/app/outputs/apk/release/app-release.apk
```

### Step 5: Create App Listing in Google Play

1. **Go to Play Console**: https://play.google.com/apps/publish
2. **Create App**:
   - Click "Create app"
   - App name: `WorkLink`
   - Choose language: English
   - App type: Free
   - Category: Business
3. **Fill App Details**:
   - Short description (80 chars):
     ```
     Connect with trusted work. Build your digital passport.
     ```
   - Full description (4000 chars):
     ```
     WorkLink connects informal workers with trusted employment 
     opportunities across Zambia and Africa. Build a verifiable 
     digital work passport, earn secure payments through escrow, 
     and grow your career with real opportunities.
     
     Features:
     - Dual authentication (phone OTP & email)
     - Digital work passport
     - AI-powered job matching
     - Secure escrow payments
     - In-app communication
     - Trust ratings & verification
     ```

4. **Content Rating**:
   - Complete questionnaire
   - Submit for rating

5. **Target Audience**:
   - Category: Business/Productivity
   - Content rating: General Audiences

### Step 6: Add Screenshots & Graphics

**Required for each device type:**
- Phone (5.5"): 1080 x 1920 px
- Tablet (7"): 1200 x 1920 px

**Create 2-5 screenshots showing:**
1. Login screen
2. Profile creation
3. Job listing
4. Chat feature
5. Payment confirmation

**Store at:**
- Screenshot files in `screenshots/` directory
- Save as PNG format

### Step 7: Set Privacy Policy & Support

1. **Privacy Policy**:
   ```
   https://worklink.zm/privacy
   (or GitHub page with privacy info)
   ```

2. **Support Email**:
   ```
   support@worklink.zm
   ```

3. **Website**:
   ```
   https://myworklink.vercel.app
   ```

### Step 8: Upload APK to Play Console

1. Go to **Release** → **Production**
2. Click **New Release**
3. Upload APK:
   - Click "Browse files"
   - Select `build/app/outputs/apk/release/app-release.apk`
4. Fill **Release notes**:
   ```
   WorkLink 1.0.0 - Initial Release
   
   Features:
   - Dual authentication (phone & email)
   - Digital work passport
   - Job matching
   - Secure payments
   - In-app messaging
   ```
5. Click **Save**

### Step 9: Submit for Review

1. Click **Review and roll out**
2. Read all requirements checklist
3. Click **Confirm rollout**
4. **Status**: "Pending review"

### Step 10: Wait for Review

- ⏱️ **Review time**: 2-4 hours (usually)
- 📧 You'll receive email when approved
- 🚀 App automatically goes live to Google Play
- 📊 Check stats in Play Console

**Result**: App on Google Play Store ✅

---

## 🍎 iOS Deployment (App Store)

### Prerequisites (macOS Only)

- ✅ Apple Developer account ($99/year)
- ✅ Mac with Xcode installed
- ✅ App Store Connect account

### Step 1: Create Apple Developer Account

1. Go to: https://developer.apple.com
2. Sign in with Apple ID
3. Enroll in **Apple Developer Program** ($99/year)
4. Complete tax info
5. Wait for approval (1-3 business days)

### Step 2: Create App ID

1. Go to: https://appstoreconnect.apple.com
2. **Certificates, Identifiers & Profiles**
3. **Identifiers** → **App IDs**
4. Click **+** to create new App ID
5. Configure:
   ```
   Bundle ID: com.worklink.app
   Description: WorkLink - Trusted Work Marketplace
   ```
6. Select capabilities needed:
   - Push Notifications (check)
   - Game Kit (uncheck)
   - HealthKit (uncheck)
7. Click **Continue** → **Register**

### Step 3: Create Signing Certificate

**In Xcode on your Mac:**

```bash
# Open Xcode
open -a Xcode

# Or via command line
xcode-select --install
```

**Steps:**
1. Xcode → Preferences → Accounts
2. Add your Apple ID
3. Click "Manage Certificates..."
4. Click **+** → "iOS Development"
5. Click **Done**

### Step 4: Create Provisioning Profile

1. **App Store Connect**: https://appstoreconnect.apple.com
2. **Certificates, Identifiers & Profiles**
3. **Profiles** → **+** Create New Profile
4. Select: **App Store**
5. Select App ID: `com.worklink.app`
6. Select certificate (from Step 3)
7. Name: `WorkLink AppStore`
8. Click **Generate**
9. Download & open file (auto-installs to Xcode)

### Step 5: Configure iOS App

**File: `ios/Runner/Info.plist`** (update)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    
    <key>CFBundleDisplayName</key>
    <string>WorkLink</string>
    
    <key>CFBundleExecutable</key>
    <string>$(EXECUTABLE_NAME)</string>
    
    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    
    <key>CFBundleName</key>
    <string>$(PRODUCT_NAME)</string>
    
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    
    <key>CFBundleSignature</key>
    <string>????</string>
    
    <key>CFBundleVersion</key>
    <string>1</string>
    
    <key>LSRequiresIPhoneOS</key>
    <true/>
    
    <key>UILaunchStoryboardName</key>
    <string>LaunchScreen</string>
    
    <key>UIMainStoryboardFile</key>
    <string>Main</string>
    
    <key>UIRequiredDeviceCapabilities</key>
    <array>
        <string>arm64</string>
    </array>
    
    <key>UISupportedInterfaceOrientations</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
    </array>
    
    <key>UIViewControllerBasedStatusBarAppearance</key>
    <false/>
    
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>WorkLink uses your location to find nearby job opportunities</string>
    
    <key>NSCameraUsageDescription</key>
    <string>WorkLink needs camera access for profile photos</string>
    
    <key>NSPhotoLibraryUsageDescription</key>
    <string>WorkLink needs access to your photo library</string>
    
    <key>NSContactsUsageDescription</key>
    <string>WorkLink needs access to contacts for verification</string>
</dict>
</plist>
```

### Step 6: Build iOS App for App Store

```bash
# macOS only
# Build IPA for App Store
flutter build ipa --release

# Output: build/ios/ipa/Runner.ipa

# Verify file exists
ls -lh build/ios/ipa/Runner.ipa
```

### Step 7: Open Xcode Archive

```bash
# Open workspace in Xcode
open ios/Runner.xcworkspace

# Or via command line
xcode-select -p
```

**In Xcode:**

1. Select: **Runner** project (left sidebar)
2. Select: **Product** → **Scheme** → **Runner**
3. Select: **Generic iOS Device** (top dropdown)
4. Menu: **Product** → **Archive**
5. Wait for build to complete
6. Window: "Organizer" opens automatically
7. Select latest build
8. Click: **Distribute App**

### Step 8: Upload to App Store

1. **Distribution Method**: Select "App Store"
2. **Signing**: Select your signing certificate
3. **Review Info**: Provide build info
4. **Upload**: Review and upload to App Store

### Step 9: Create App Store Listing

1. **App Store Connect**: https://appstoreconnect.apple.com
2. **My Apps** → **WorkLink**
3. **App Information**:
   - Category: Business
   - Subcategory: Productivity
   - Age Rating: 4+
4. **Pricing & Availability**:
   - Price: Free
   - Territory: Select all
   - Availability date: Today
5. **Version Release**:
   - Release type: Manual Release

### Step 10: Add App Details

**On app version page:**

1. **General**:
   ```
   Description (4000 char limit):
   WorkLink connects informal workers with trusted employment 
   opportunities across Zambia and Africa. Build your digital 
   work passport, earn secure payments, and grow your career.
   
   Keywords: work, jobs, Zambia, Africa, employment, gig
   
   Support URL: https://myworklink.vercel.app
   Privacy Policy: https://myworklink.vercel.app/privacy
   ```

2. **Screenshots** (required for each device):
   - iPhone 6.5" (1284 x 2778)
   - iPad 12.9" (2048 x 2732)
   - Add 2-5 app screenshots showing key features

3. **Preview** (optional):
   - Add app preview video (15-30 sec)

4. **Build**:
   - Select your build (should auto-appear)

5. **Review Information**:
   - Demo account (optional)
   - App notes for reviewer
   - Any special testing instructions

### Step 11: Submit for Review

1. Click: **Submit for Review**
2. Answer compliance questions
3. Select: **Age Ratings**
4. Confirm: **Submit**

### Step 12: Wait for Review

- ⏱️ **Review time**: 24-48 hours (usually)
- 📧 Email notification when ready
- 🚀 App goes live automatically
- 📊 Check in App Store Connect dashboard

**Result**: App on Apple App Store ✅

---

## 📅 All-In-One Deployment Timeline

### Day 1 - Preparation
- [ ] 09:00 - Create Google Play Developer account ($25)
- [ ] 10:00 - Create Apple Developer account ($99)
- [ ] 11:00 - Generate Android signing certificate
- [ ] 12:00 - Setup iOS certificates in Xcode
- [ ] 13:00 - Configure vercel.json & index.html
- [ ] 14:00 - Test locally: `flutter run`

### Day 2 - Web & Android
- [ ] 09:00 - Deploy to Vercel
  - Expected: 5 minutes live
- [ ] 09:30 - Build Android APK: `flutter build apk --release`
- [ ] 10:00 - Create Google Play listing
- [ ] 11:00 - Upload APK & screenshots
- [ ] 11:30 - Submit for review
  - Expected: Live in 2-4 hours

### Day 3 - iOS
- [ ] 09:00 - Build iOS IPA: `flutter build ipa --release`
- [ ] 10:00 - Archive & upload via Xcode
- [ ] 11:00 - Create App Store listing
- [ ] 12:00 - Add screenshots & description
- [ ] 13:00 - Submit for review
  - Expected: Live in 24-48 hours

### Day 4-5 - Monitoring
- [ ] Day 4 - Check Android app is live
- [ ] Day 5 - Check iOS app is live
- [ ] Monitor app reviews & ratings
- [ ] Monitor downloads & crashes
- [ ] Respond to user feedback

---

## ✅ Post-Deployment Checklist

### Immediately After Launch

- [ ] **Test on Real Devices**
  - [ ] Install from Google Play
  - [ ] Install from App Store
  - [ ] Test login (phone OTP)
  - [ ] Test login (email)
  - [ ] Test profile creation
  - [ ] Test posting job (employer)
  - [ ] Test browsing jobs (worker)

- [ ] **Monitor Performance**
  - [ ] Check crash reports in Play Console
  - [ ] Check crash reports in App Store Connect
  - [ ] Monitor user reviews
  - [ ] Check rating (should aim for 4+ stars)

- [ ] **Verify Functionality**
  - [ ] Supabase connection working
  - [ ] Authentication functional
  - [ ] Payment system working
  - [ ] Chat working
  - [ ] No errors in logs

### Week 1

- [ ] Respond to user reviews
- [ ] Monitor app analytics
- [ ] Track download numbers
- [ ] Fix any critical bugs
- [ ] Prepare 1.0.1 patch if needed

### Month 1

- [ ] Gather user feedback
- [ ] Plan Phase 2 features
- [ ] Optimize performance
- [ ] Plan marketing campaign
- [ ] Update documentation

---

## 🔗 Important Links

### Development
- **GitHub**: https://github.com/Saleban71/myworklink.app
- **Supabase**: https://app.supabase.com
- **Flutter Docs**: https://flutter.dev/docs

### Publishing
- **Google Play Console**: https://play.google.com/apps/publish
- **App Store Connect**: https://appstoreconnect.apple.com
- **Vercel Dashboard**: https://vercel.com/dashboard

### Support
- **Flutter Support**: https://flutter.dev/support
- **Apple Support**: https://developer.apple.com/support
- **Google Play Support**: https://support.google.com/googleplay

---

## ⚠️ Important Notes

### Before Publishing

✅ **Security**
- Never commit `.env` file
- Use secure environment variables
- Enable Supabase RLS (Row Level Security)
- Implement rate limiting on auth

✅ **Testing**
- Test on real devices (not just emulator)
- Test with poor network
- Test without network
- Test with different phone sizes
- Load test with multiple users

✅ **Compliance**
- Have Privacy Policy
- Have Terms of Service
- Comply with app store guidelines
- Implement data deletion option
- Follow GDPR/CCPA rules (if applicable)

### After Publishing

✅ **Monitoring**
- Monitor crash reports daily
- Check user reviews daily
- Monitor server performance
- Track app store metrics

✅ **Maintenance**
- Respond to bugs quickly
- Plan regular updates
- Keep dependencies updated
- Monitor security vulnerabilities

---

## 🆘 Troubleshooting

### Vercel Deployment Issues

**Problem**: Deploy fails with build error
```
Solution:
1. Check index.html is in root directory
2. Verify vercel.json syntax
3. Check GitHub permissions
4. Rebuild: vercel --prod
```

### Android Deployment Issues

**Problem**: "App signing certificate not found"
```
Solution:
1. Verify key.properties exists
2. Check keystore file path is correct
3. Verify passwords match
4. Recreate keystore if needed
```

**Problem**: APK upload fails
```
Solution:
1. Check APK file size < 100MB
2. Verify build.gradle minSdkVersion correct
3. Check version number not used before
4. Try uploading bundle instead of APK
```

### iOS Deployment Issues

**Problem**: "Certificate not valid"
```
Solution:
1. Regenerate certificate in Xcode
2. Download provisioning profile again
3. Restart Xcode
4. Clean build folder: Cmd+Shift+K
```

**Problem**: "App rejected for guideline violation"
```
Solution:
1. Read rejection reason carefully
2. Fix issue in code
3. Increment build number
4. Resubmit with explanation
```

---

## 📊 Expected Timeline

| Step | Platform | Time | Status |
|------|----------|------|--------|
| Vercel Deploy | Web | 5 min | ✅ Same day |
| Google Play Review | Android | 2-4 hours | ✅ Same day |
| App Store Review | iOS | 24-48 hours | ✅ Next day |
| **All Live** | All | 48 hours | ✅ By Day 2 |

---

## 🎉 Congratulations!

You're about to launch WorkLink to the world! 🚀

**Following this guide will get your app live on:**
- ✅ Vercel (Web): myworklink.vercel.app
- ✅ Google Play Store (Android)
- ✅ Apple App Store (iOS)

**Ready? Start with Step 1 of Web Deployment above!**

---

**Need help?** Refer back to:
- `SETUP_GUIDE.md` - Development setup
- `QUICK_START.md` - Quick reference
- `AUTHENTICATION_STATUS.md` - What was fixed

---

**Last Updated**: July 10, 2026  
**Status**: ✅ Ready to Deploy  
**Version**: 1.0.0
