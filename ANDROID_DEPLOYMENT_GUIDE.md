# 📱 WorkLink – Android Release Deployment Guide

**App Name**: WorkLink  
**Bundle ID**: `com.worklink.app`  
**Version**: 1.0.0  
**Target**: Google Play Store  
**Last Updated**: July 2026

---

## 📋 Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [Create Google Play Developer Account](#2-create-google-play-developer-account)
3. [Set Up Merchant Account (for Payments)](#3-set-up-merchant-account)
4. [Generate Android Signing Key](#4-generate-android-signing-key)
5. [Configure Android Build Files](#5-configure-android-build-files)
6. [Set Up Firebase (Push Notifications)](#6-set-up-firebase)
7. [Build Release APK / AAB](#7-build-release-apk--aab)
8. [Create Play Store App Listing](#8-create-play-store-app-listing)
9. [Upload and Submit for Review](#9-upload-and-submit-for-review)
10. [Post-Launch Checklist](#10-post-launch-checklist)
11. [Troubleshooting](#11-troubleshooting)

---

## 1. Prerequisites

Before starting, make sure you have:

| Requirement | Version | Check |
|-------------|---------|-------|
| Flutter SDK | ≥ 3.3.0 | `flutter --version` |
| Java JDK | ≥ 11 | `java -version` |
| Android Studio | Latest | [Download](https://developer.android.com/studio) |
| Android SDK | API 34 | Via Android Studio |
| Git | Any | `git --version` |

Install Android SDK command-line tools:
```bash
# In Android Studio → SDK Manager → SDK Tools
# ✅ Android SDK Build-Tools
# ✅ Android SDK Platform-Tools
# ✅ Android Emulator
```

Verify Flutter is ready:
```bash
flutter doctor
```

All items should show ✅ (except iOS tools if you're on Linux/Windows).

---

## 2. Create Google Play Developer Account

### Step 1: Register at Google Play Console

1. Go to: https://play.google.com/apps/publish
2. Sign in with your Google account
3. Click **"Get started"**
4. Accept the **Developer Distribution Agreement**
5. Pay the **$25 one-time registration fee**
6. Complete your developer profile:
   - Developer name: `WorkLink`
   - Email address: your business email
   - Website: `https://worklink.app` (or your domain)
   - Phone number: your contact number

### Step 2: Verify Your Identity

Google may require identity verification (for new accounts):

1. Upload a government-issued ID
2. Wait up to 48 hours for verification
3. You'll receive an email confirmation

> ⚠️ **Note**: Identity verification is required before you can publish apps.

---

## 3. Set Up Merchant Account

WorkLink uses escrow payments, so you need a merchant account.

### Step 1: Link Google Payments

1. In **Google Play Console** → **Setup** → **Payments profile**
2. Click **"Create payments profile"**
3. Fill in:
   - Business name: WorkLink
   - Business type: Individual / Company
   - Country: Zambia (ZM)
   - Currency: ZMW or USD

### Step 2: Add Banking Details

1. **Payments profile** → **Bank accounts**
2. Add your bank account for receiving payments
3. Verify with micro-deposit (1-3 business days)

> 💡 Alternatively, if using Supabase for escrow logic, you don't need in-app billing set up immediately. You can add it later once the app is live.

---

## 4. Generate Android Signing Key

> ⚠️ **CRITICAL**: Your signing key is permanent. If you lose it, you cannot update your app. Store it securely and back it up!

### Step 1: Generate the Keystore

Run this command in your terminal (replace the fields with your own values):

```bash
keytool -genkey -v \
    -keystore ~/worklink.keystore \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -alias worklink_key
```

You will be prompted for:

```
Enter keystore password: [choose a strong password]
Re-enter new password: [repeat password]
What is your first and last name? [Your Name]
What is the name of your organizational unit? [Engineering]
What is the name of your organization? [WorkLink]
What is the name of your City or Locality? [Lusaka]
What is the name of your State or Province? [Lusaka Province]
What is the two-letter country code? [ZM]
Is CN=Your Name, OU=Engineering, O=WorkLink, L=Lusaka, ST=Lusaka Province, C=ZM correct? [yes]
Enter key password for worklink_key: [same or different password]
```

### Step 2: Verify the Keystore Was Created

```bash
ls -la ~/worklink.keystore
# Should show the file with a non-zero size

keytool -list -v -keystore ~/worklink.keystore -alias worklink_key
# Should show certificate details
```

### Step 3: Back Up Your Keystore

```bash
# Copy to a secure location (USB drive, encrypted cloud storage, etc.)
cp ~/worklink.keystore /path/to/secure/backup/worklink.keystore
```

> 🔒 **Security checklist**:
> - Store in 2+ separate locations (e.g., USB drive + encrypted cloud)
> - Write down your passwords and store securely offline
> - Never commit `worklink.keystore` or `key.properties` to Git

---

## 5. Configure Android Build Files

### Step 1: Create `android/key.properties`

Copy the example file and fill in your values:

```bash
cp android/key.properties.example android/key.properties
```

Edit `android/key.properties`:

```properties
storeFile=/Users/YOUR_USERNAME/worklink.keystore
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=worklink_key
```

> On **Windows**, use forward slashes or double backslashes:
> ```properties
> storeFile=C:/Users/YOUR_USERNAME/worklink.keystore
> ```

### Step 2: Verify `android/app/build.gradle`

The file is already configured in this repository with:

- ✅ `applicationId "com.worklink.app"`
- ✅ `minSdkVersion 21` (Android 5.0+)
- ✅ `targetSdkVersion 34` (Android 14)
- ✅ Release signing config from `key.properties`
- ✅ ProGuard/R8 minification enabled for release

### Step 3: Verify `AndroidManifest.xml`

The manifest at `android/app/src/main/AndroidManifest.xml` already includes:

- ✅ `INTERNET` – for Supabase API calls
- ✅ `ACCESS_FINE_LOCATION` / `ACCESS_COARSE_LOCATION` – for job proximity
- ✅ `RECEIVE_SMS` / `READ_SMS` – for OTP phone auth
- ✅ `CAMERA` / `READ_MEDIA_IMAGES` – for profile photos
- ✅ `POST_NOTIFICATIONS` – for job/chat push notifications
- ✅ Deep link scheme `com.worklink.app` for Supabase OAuth callback

### Step 4: Set Up `local.properties`

Flutter auto-generates this file. If missing, create it:

```bash
# In the android/ directory, create local.properties
echo "sdk.dir=/path/to/android/sdk" > android/local.properties
echo "flutter.sdk=/path/to/flutter" >> android/local.properties
```

Or let Flutter create it automatically:
```bash
flutter build apk --debug  # This auto-generates local.properties
```

---

## 6. Set Up Firebase

WorkLink uses Firebase for push notifications. You need a `google-services.json` file.

### Step 1: Create Firebase Project

1. Go to: https://console.firebase.google.com
2. Click **"Create a project"**
3. Project name: `worklink-app`
4. Enable Google Analytics: Yes (recommended)
5. Click **"Create project"**

### Step 2: Add Android App to Firebase

1. In Firebase console → **Project Overview** → **Add app** → Android icon
2. Fill in:
   - Android package name: `com.worklink.app`
   - App nickname: `WorkLink Android`
   - Debug signing certificate SHA-1: (optional for now)
3. Click **"Register app"**

### Step 3: Download `google-services.json`

1. Click **"Download google-services.json"**
2. Save it to: `android/app/google-services.json`

> ⚠️ `google-services.json` is in `.gitignore` — do NOT commit it.

### Step 4: Get Your Release SHA-1 (for phone auth)

```bash
keytool -list -v \
    -keystore ~/worklink.keystore \
    -alias worklink_key | grep SHA1
```

Add this SHA-1 fingerprint in:
- Firebase Console → Project Settings → Your Android app → Add fingerprint

---

## 7. Build Release APK / AAB

### Option A: Release APK (for direct testing)

```bash
# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Build release APK
flutter build apk --release
```

**Output**: `build/app/outputs/apk/release/app-release.apk`

### Option B: App Bundle / AAB (recommended for Play Store)

Google Play recommends AAB over APK for better app delivery.

```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

**Output**: `build/app/outputs/bundle/release/app-release.aab`

### Verify the Build

```bash
# Check APK size
ls -lh build/app/outputs/apk/release/app-release.apk

# Or for AAB
ls -lh build/app/outputs/bundle/release/app-release.aab
```

The release APK/AAB should be **signed** with your keystore. Verify:

```bash
# For APK
apksigner verify --verbose build/app/outputs/apk/release/app-release.apk

# Or use jarsigner
jarsigner -verify -verbose -certs build/app/outputs/apk/release/app-release.apk
```

---

## 8. Create Play Store App Listing

### Step 1: Create New App

1. Go to: https://play.google.com/apps/publish
2. Click **"Create app"**
3. Fill in:
   - **App name**: WorkLink
   - **Default language**: English (United Kingdom)
   - **App or game**: App
   - **Free or paid**: Free
4. Accept policies, click **"Create app"**

### Step 2: Set Up Store Listing

Go to **Store presence** → **Main store listing**:

**Short description** (80 chars max):
```
Find trusted work. Hire reliable workers. WorkLink connects Zambia.
```

**Full description** (4000 chars max):
```
WorkLink is Zambia's trusted work marketplace for the informal workforce.

🔨 FOR WORKERS:
• Find day work, casual jobs, and gigs near you
• Build your professional profile and reviews
• Get paid securely through escrow
• Chat directly with employers
• Receive instant job alerts

💼 FOR EMPLOYERS:
• Post jobs and find verified workers fast
• Review worker profiles and ratings
• Pay securely — funds released only on completion
• Manage multiple job postings
• Direct chat with candidates

🔒 SECURE & TRUSTED:
• Phone OTP + email authentication
• Escrow payment protection
• Worker verification system
• 5-star review system

📍 LOCATION-AWARE:
• Find jobs in your area
• Browse workers near your job site

Built for Zambia's workforce — WorkLink makes work, work.
```

### Step 3: Add App Icon and Screenshots

**App icon** (required):
- Size: 512 × 512 px PNG
- No rounded corners (Google Play adds them)
- No alpha/transparency

**Feature graphic** (required):
- Size: 1024 × 500 px JPG or PNG

**Screenshots** (minimum 2, up to 8):
- Phone screenshots: 16:9 or 9:16 ratio
- Minimum 320px on shortest side, maximum 3840px on longest side
- Recommended screens to capture:
  1. Auth selection screen (welcome)
  2. Phone OTP / email login screen
  3. Job listing / home feed
  4. Worker profile
  5. Chat screen
  6. Payment / escrow screen

### Step 4: Set Category and Tags

- **App category**: Business
- **Tags**: jobs, work, employment, hiring, freelance, Zambia

---

## 9. Upload and Submit for Review

### Step 1: Create a Production Release

1. In Play Console → **Release** → **Production**
2. Click **"Create new release"**

### Step 2: Upload AAB/APK

1. Click **"Upload"**
2. Select your `app-release.aab` (or `.apk`)
3. Wait for processing (1-2 minutes)

### Step 3: Add Release Notes

```
Version 1.0.0 - Initial release

• Phone OTP authentication
• Email/password authentication  
• Worker and employer profiles
• Job listings and applications
• Secure chat messaging
• Escrow payment protection
• Location-based job search
```

### Step 4: Complete All Required Sections

Before you can submit, complete these in Play Console:

| Section | What to Fill In |
|---------|----------------|
| **App content** → Privacy policy | Link to your privacy policy URL |
| **App content** → App access | Note that login is required; provide test credentials |
| **App content** → Ads | Declare if app contains ads (No for WorkLink) |
| **App content** → Content rating | Complete the content rating questionnaire |
| **App content** → Target audience | Adults 18+ (workers and employers) |
| **App content** → Data safety | Declare what data you collect |
| **Store listing** → Contact details | Support email, website |
| **Pricing & distribution** | Free, all countries or Zambia only |

### Step 5: Data Safety Declaration

In **App content** → **Data safety**, declare:

| Data Type | Collected | Shared | Purpose |
|-----------|-----------|--------|---------|
| Name | ✅ Yes | ❌ No | User profile |
| Phone number | ✅ Yes | ❌ No | Authentication |
| Email address | ✅ Yes | ❌ No | Authentication |
| Location (precise) | ✅ Yes | ❌ No | Job proximity |
| Photos | ✅ Yes | ❌ No | Profile pictures |
| Messages | ✅ Yes | ❌ No | In-app chat |
| Financial info | ✅ Yes | ❌ No | Escrow payments |

### Step 6: Submit for Review

1. Review all sections — all should show ✅ green
2. Click **"Review release"**
3. Click **"Start rollout to Production"**
4. Confirm with **"Rollout"**

**Review timeline**:
- Initial review: 1–7 business days (usually 2–3 days)
- Updates: A few hours to 1 day
- You'll receive an email when approved or if changes are needed

---

## 10. Post-Launch Checklist

After the app is approved and live:

### Functional Testing on Real Device

- [ ] Download from Play Store on Android device
- [ ] App launches without crashes
- [ ] Phone OTP login works end-to-end
- [ ] Email/password login works
- [ ] Job listing loads correctly
- [ ] Location permissions requested and working
- [ ] Can send/receive chat messages
- [ ] Profile photos upload correctly
- [ ] Push notifications arrive
- [ ] Escrow payment flow works

### Play Console Monitoring

- [ ] Monitor **Android Vitals** for crashes
- [ ] Check **User reviews** section
- [ ] Set up **Firebase Crashlytics** alerts
- [ ] Review **Ratings and reviews** daily for first week

### Security Check

- [ ] `key.properties` is NOT in Git (check with `git status`)
- [ ] `.env` is NOT in Git
- [ ] `google-services.json` is NOT in Git
- [ ] `*.keystore` files are NOT in Git

```bash
# Verify no secrets were accidentally committed
git log --all --full-history -- android/key.properties
git log --all --full-history -- "*.keystore"
git log --all --full-history -- .env
```

---

## 11. Troubleshooting

### Build Fails: `Keystore not found`

```
Error: Keystore file not found at /Users/username/worklink.keystore
```

**Fix**: Check that `android/key.properties` has the correct absolute path to your keystore file.

```bash
# Verify the path
ls -la $(grep storeFile android/key.properties | cut -d= -f2)
```

### Build Fails: `flutter.sdk not set`

```
Error: flutter.sdk not set in local.properties
```

**Fix**: Let Flutter regenerate `local.properties`:

```bash
flutter clean
flutter pub get
flutter build apk --debug  # This creates local.properties
flutter build apk --release
```

### Build Fails: `Gradle build failed`

```bash
# Clean everything
flutter clean
cd android && ./gradlew clean
cd ..

# Check Java version (must be 11+)
java -version

# Rebuild with verbose output
flutter build apk --release -v
```

### Build Fails: `Google Services file missing`

```
File google-services.json is missing.
```

**Fix**: Download `google-services.json` from your Firebase project and place it at `android/app/google-services.json`.

If you don't need Firebase yet:
1. Remove the Firebase plugins from `android/app/build.gradle`:
   ```gradle
   // Remove these lines temporarily:
   // apply plugin: 'com.google.gms.google-services'
   ```
2. Remove Firebase dependencies from `build.gradle`

### Play Store Upload: `Version code already exists`

**Fix**: Increment the version code in `pubspec.yaml`:

```yaml
version: 1.0.1+2  # format: versionName+versionCode
```

Then rebuild:

```bash
flutter build appbundle --release
```

### App Rejected: Policy Violation

Common reasons and fixes:

| Rejection reason | Fix |
|-----------------|-----|
| Missing privacy policy | Add a privacy policy URL to your app listing |
| Misleading permissions | Explain each permission in the app listing |
| Test credentials missing | Add login details in "App access" section |
| Screenshots don't match app | Take fresh screenshots of the actual app |

---

## 📁 File Structure Reference

After completing this guide, your Android configuration should look like this:

```
myworklink.app/
├── android/
│   ├── build.gradle              ✅ Root build file
│   ├── settings.gradle           ✅ Project settings
│   ├── gradle.properties         ✅ Gradle JVM config
│   ├── key.properties            ⚠️  Your signing keys (gitignored!)
│   ├── key.properties.example    ✅ Template (committed)
│   └── app/
│       ├── build.gradle          ✅ App build + signing config
│       ├── proguard-rules.pro    ✅ ProGuard rules
│       ├── google-services.json  ⚠️  Firebase config (gitignored!)
│       └── src/main/
│           ├── AndroidManifest.xml  ✅ Permissions & config
│           ├── kotlin/com/worklink/app/
│           │   └── MainActivity.kt  ✅ Flutter entry point
│           └── res/
│               ├── drawable/        ✅ Launch screen
│               └── values/          ✅ Strings, styles
├── pubspec.yaml                  ✅ Version: 1.0.0+1
└── .gitignore                    ✅ Excludes keys & secrets
```

---

## 🔗 Quick Reference Links

| Resource | URL |
|----------|-----|
| Google Play Console | https://play.google.com/apps/publish |
| Play Store Policies | https://play.google.com/about/developer-content-policy |
| Firebase Console | https://console.firebase.google.com |
| Supabase Dashboard | https://app.supabase.com |
| Flutter Build Docs | https://docs.flutter.dev/deployment/android |
| Play Console Help | https://support.google.com/googleplay/android-developer |

---

## ✅ Complete Submission Checklist

### Before Building
- [ ] `android/key.properties` created with your keystore details
- [ ] `android/app/google-services.json` downloaded from Firebase
- [ ] `pubspec.yaml` version set to `1.0.0+1`
- [ ] `.env` file configured with Supabase credentials (for local testing)

### Building
- [ ] `flutter clean` run
- [ ] `flutter pub get` run  
- [ ] `flutter build appbundle --release` succeeded
- [ ] AAB file exists at `build/app/outputs/bundle/release/app-release.aab`
- [ ] AAB is signed (verified with `apksigner`)

### Play Store Listing
- [ ] App name: "WorkLink"
- [ ] Short description written (≤ 80 chars)
- [ ] Full description written (≤ 4000 chars)
- [ ] 512×512 app icon uploaded
- [ ] 1024×500 feature graphic uploaded
- [ ] At least 2 phone screenshots uploaded
- [ ] Category: Business
- [ ] Privacy policy URL added
- [ ] Content rating questionnaire completed
- [ ] Data safety form completed
- [ ] Target audience set (Adults 18+)
- [ ] Test credentials added in "App access"

### Release
- [ ] AAB uploaded to Production track
- [ ] Release notes added (v1.0.0 – Initial release)
- [ ] All required sections show green ✅
- [ ] Submitted for review

---

*Need help? Check [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md) for a broader deployment overview, or [ANDROID_LOGIN_ERROR_FIX.md](./ANDROID_LOGIN_ERROR_FIX.md) for authentication troubleshooting.*
