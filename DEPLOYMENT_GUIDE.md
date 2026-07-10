# 🚀 WorkLink - Production Deployment Guide

**Status**: ✅ Ready for Production  
**Last Updated**: July 10, 2026  
**Version**: 1.0.0

---

## 📋 Quick Navigation

- [Web Deployment (Vercel)](#web-deployment-vercel)
- [Android Deployment (Google Play)](#android-deployment-google-play)
- [iOS Deployment (App Store)](#ios-deployment-app-store)
- [Post-Deployment Checklist](#post-deployment-checklist)

---

## 🌐 Web Deployment (Vercel)

### What Gets Deployed

Your `index.html` landing page with:
- Hero section
- Features overview
- Download app buttons
- Mobile responsive design

### Step 1: Push to GitHub

```bash
git add .
git commit -m "Ready for production deployment"
git push origin main
```

### Step 2: Connect to Vercel

1. **Go to**: https://vercel.com
2. **Sign in** with GitHub
3. **Click**: "Add New" → "Project"
4. **Select**: `Saleban71/myworklink.app`
5. **Click**: "Import"

### Step 3: Configure Vercel

**Project Settings** (leave defaults):
```
Framework Preset: Other (HTML)
Build Command: (empty)
Output Directory: (empty)
Install Command: (empty)
```

**Click**: "Deploy"

### Step 4: Verify Deployment

Wait 2-3 minutes, then:
- ✅ Visit: `https://myworklink.vercel.app`
- ✅ Check landing page loads
- ✅ Test download buttons
- ✅ Check mobile responsive

### Step 5: Custom Domain (Optional)

1. **Vercel Dashboard** → Your Project
2. **Settings** → **Domains**
3. **Add Domain**: `myworklink.app`
4. **Follow** DNS setup instructions
5. **Wait** 24 hours for propagation

---

## 📱 Android Deployment (Google Play)

### Prerequisites

- ✅ Google Play Developer account ($25 one-time)
- ✅ Merchant account (for payments)
- ✅ App signing certificate

### Step 1: Google Play Developer Account

1. **Go to**: https://play.google.com/apps/publish
2. **Sign in** with Google account
3. **Pay** $25 one-time fee
4. **Complete** merchant account setup

### Step 2: Generate Signing Certificate

**First time only:**

```bash
# Generate keystore
keytool -genkey -v -keystore ~/worklink.keystore \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -alias worklink_key

# When prompted, enter:
# Password: (save securely!)
# Name: Your Name
# Organization: WorkLink
# City: Lusaka
# State: Lusaka
# Country: ZM
```

**Verify creation:**
```bash
ls -la ~/worklink.keystore
```

⚠️ **Save this file securely** - you'll need it for future updates!

### Step 3: Configure Android Build

**Create `android/key.properties`:**

```properties
storeFile=/Users/YOUR_USERNAME/worklink.keystore
storePassword=YOUR_PASSWORD
keyPassword=YOUR_PASSWORD
keyAlias=worklink_key
```

**Update `android/app/build.gradle`:**

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

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
flutter clean
flutter pub get
flutter build apk --release
```

**Output**: `build/app/outputs/apk/release/app-release.apk`

### Step 5: Create Play Store Listing

1. **Google Play Console** → **Create App**
2. **Fill in**:
   - App name: "WorkLink"
   - Default language: English
   - App type: Application
   - Category: Business

3. **Go to**: **Release** → **Production**
4. **Upload** `app-release.apk`
5. **Fill in**: Title, description, screenshots

### Step 6: Add App Content

1. **Content Rating**:
   - App questionnaire
   - Select appropriate rating

2. **Target Audience**:
   - Select: "Adults"
   - Workers and employers 18+

3. **Privacy Policy**:
   - Link to your privacy policy

### Step 7: Review & Submit

1. **Review** all information
2. **Check** pricing (Free)
3. **Submit** for review
4. **Wait** 2-4 hours for approval

### Result

✅ App available on Google Play Store

---

## 🍎 iOS Deployment (App Store)

### Prerequisites

- ✅ Apple Developer account ($99/year)
- ✅ Mac with Xcode
- ✅ App signing certificate

### Step 1: Apple Developer Account

1. **Go to**: https://developer.apple.com
2. **Sign in** with Apple ID
3. **Enroll** in Apple Developer Program
4. **Pay** $99/year

### Step 2: Create App ID

1. **Developer Account** → **Certificates, Identifiers & Profiles**
2. **Identifiers** → **App IDs**
3. **Register New ID**:
   - Name: WorkLink
   - Bundle ID: `com.worklink.app`
   - Capabilities: Push Notifications

### Step 3: Create Signing Certificate

1. **Certificates** → **Create New Certificate**
2. **Select**: "iOS App Development"
3. **Upload** Certificate Signing Request (CSR)
4. **Download** certificate

### Step 4: Configure Xcode Project

```bash
cd ios
xed .
```

**In Xcode**:

1. **Select** "Runner" project
2. **Select** "Runner" target
3. **Signing & Capabilities**:
   - Team: Your Apple Team ID
   - Bundle Identifier: `com.worklink.app`

### Step 5: Build Release IPA

```bash
flutter clean
flutter pub get
flutter build ios --release
```

### Step 6: Create App Store Connect Entry

1. **App Store Connect**: https://appstoreconnect.apple.com
2. **Create New App**:
   - Bundle ID: `com.worklink.app`
   - Name: WorkLink
   - SKU: com.worklink.app

### Step 7: Upload IPA

```bash
flutter build ipa
```

**Upload via**:
- Transporter app, or
- Xcode → Product → Archive → Upload

### Step 8: Complete App Store Listing

1. **App Information**:
   - Description
   - Keywords
   - Support URL

2. **Screenshots** (5-8 screenshots):
   - Auth screen
   - Job listing
   - Chat
   - Payment

3. **App Review Information**:
   - Login credentials (test account)
   - Notes for reviewer

### Step 9: Submit for Review

1. **Review** all information
2. **Check** pricing (Free)
3. **Submit** for App Review
4. **Wait** 24-48 hours for approval

### Result

✅ App available on Apple App Store

---

## 📊 Deployment Timeline

| Platform | Setup | Build | Review | Total |
|----------|-------|-------|--------|-------|
| Web (Vercel) | 5 min | 3 min | 0 min | **8 min** |
| Android | 30 min | 15 min | 2 hours | **2.5 hours** |
| iOS | 30 min | 20 min | 24 hours | **24.5 hours** |

---

## ✅ Post-Deployment Checklist

### Web (Vercel)

- [ ] Landing page loads at `myworklink.vercel.app`
- [ ] All buttons are clickable
- [ ] Mobile responsive
- [ ] Download buttons link to app stores
- [ ] Custom domain working (if added)

### Android (Google Play)

- [ ] App appears on Play Store
- [ ] Download button works
- [ ] App installs and launches
- [ ] Phone auth works
- [ ] Email auth works
- [ ] No crashes on login

### iOS (App Store)

- [ ] App appears on App Store
- [ ] Download button works
- [ ] App installs and launches
- [ ] Phone auth works
- [ ] Email auth works
- [ ] No crashes on login

### Overall

- [ ] Web, Android, iOS all live
- [ ] All auth methods working
- [ ] Download buttons all link to app stores
- [ ] No errors in production
- [ ] Users can login and use app

---

## 🔄 Troubleshooting

### Android Build Fails

```bash
# Clean everything
flutter clean

# Check Java version
java -version  # Should be 11+

# Rebuild
flutter build apk --release -v
```

### iOS Build Fails

```bash
# Clean everything
flutter clean

# Update pods
cd ios
pod repo update
pod install
cd ..

# Rebuild
flutter build ios --release -v
```

### Google Play Upload Fails

- ✅ Check version code is higher than previous
- ✅ Check app is signed correctly
- ✅ Check APK is `release` build

### App Store Upload Fails

- ✅ Check bundle ID matches App ID
- ✅ Check certificate is valid
- ✅ Check provisioning profile is correct

---

## 📞 Support

### Android Issues

→ Google Play Console Help: https://support.google.com/googleplay

### iOS Issues

→ Apple Developer Support: https://developer.apple.com/support

### Vercel Issues

→ Vercel Documentation: https://vercel.com/docs

---

## 🎉 All Set!

Your WorkLink app is now available on:

- 🌐 **Web**: https://myworklink.vercel.app
- 📱 **Android**: Google Play Store
- 🍎 **iOS**: Apple App Store

Users can now download and start using WorkLink! 🚀
