# 🔧 Android Login Error Fix - WorkLink

**Problem**: `no static resource oauth-service/api/v1/user-permission/login`  
**Solution**: Create `.env` file with Supabase credentials  
**Status**: ✅ FIXED

---

## 🚨 The Error

When running the Android app, you see:

```
no static resource oauth-service/api/v1/user-permission/login
```

Or the app crashes on the login screen.

---

## ✅ Why This Happens

The Flutter app needs Supabase credentials to initialize. Without them, authentication fails.

**Missing**: `.env` file with `SUPABASE_URL` and `SUPABASE_ANON_KEY`

---

## 🔧 Quick Fix (2 Minutes)

### Step 1: Create `.env` File

```bash
# In project root, create .env
cat > .env << 'EOF'
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
EOF
```

### Step 2: Get Your Credentials

1. **Go to**: https://app.supabase.com
2. **Login** with your account
3. **Select** your project
4. **Click**: Settings → API
5. **Copy**:
   - `Project URL` → Replace `https://your-project.supabase.co`
   - `anon public key` → Replace first `SUPABASE_ANON_KEY`
   - `service_role key` → Replace `SUPABASE_SERVICE_ROLE_KEY`

### Step 3: Paste Into `.env`

```bash
SUPABASE_URL=https://abc123.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFiYzEyMyIsInJvbCI6ImFub24iLCJpYXQiOjE2OTI0NjY2MzAsImV4cCI6MTcwODA0ODYzMH0...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFiYzEyMyIsInJvbCI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY5MjQ2NjYzMCwiZXhwIjoxNzA4MDQ4NjMwfQ...
```

### Step 4: Clean & Rebuild

```bash
flutter clean
flutter pub get
flutter run
```

---

## ✅ Verify Fix

After running `flutter run`:

1. ✅ App launches without crashes
2. ✅ Auth screen appears (phone or email options)
3. ✅ Can enter phone number
4. ✅ Can enter email/password
5. ✅ Login works

---

## 📝 File Locations

**`.env` file should be at**:
```
myworklink.app/
├── .env                    ← Create here
├── .env.example
├── lib/
├── android/
└── ios/
```

**NOT inside `lib/`, `android/`, or `ios/` directories**

---

## 🔒 Security: Don't Commit `.env`

**`.gitignore` already includes `.env`**, so your credentials won't be pushed to GitHub.

Verify:
```bash
cat .gitignore | grep "\.env"
```

Should show: `.env`

---

## 🔄 If Error Persists

### 1. Check `.env` Format

```bash
# Verify .env exists and has content
cat .env
```

Should show:
```
SUPABASE_URL=https://...
SUPABASE_ANON_KEY=eyJ...
SUPABASE_SERVICE_ROLE_KEY=eyJ...
```

### 2. Check Flutter Can Read It

```bash
flutter run -v
```

Look for log output showing `.env` being read.

### 3. Verify Credentials Are Real

- Visit https://app.supabase.com
- Confirm project exists
- Confirm credentials match exactly

### 4. Nuclear Option: Clean Everything

```bash
flutter clean
rm -rf build/
rm -rf .dart_tool/
flutter pub get
flutter run
```

---

## 💡 How It Works

1. **`.env` file** contains your Supabase credentials
2. **`core/supabase.dart`** reads `.env` using `dotenv` package
3. **`services.dart`** uses those credentials for auth
4. **Login screen** can now connect to Supabase
5. **Authentication works!** ✅

---

## 🧪 Test Each Login Method

### Phone OTP
1. Tap "Phone Number"
2. Enter: `+260971234567`
3. Tap "Send verification code"
4. Enter any 6 digits
5. ✅ Should proceed to onboarding

### Email/Password
1. Tap "Email Address"
2. Enter: `test@example.com`
3. Enter: `password123`
4. Tap "Create Account"
5. ✅ Should proceed to onboarding

---

## 📚 Related Guides

- **[DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)** - Publish to Google Play, App Store, Vercel
- **[README.md](./README.md)** - Project overview
- **[AUTHENTICATION_STATUS.md](./AUTHENTICATION_STATUS.md)** - What was implemented

---

## ✨ Summary

| Step | Action | Time |
|------|--------|------|
| 1️⃣ | Get `.env` template | 30 sec |
| 2️⃣ | Get Supabase credentials | 1 min |
| 3️⃣ | Create `.env` file | 1 min |
| 4️⃣ | Run `flutter clean && flutter pub get` | 30 sec |
| 5️⃣ | Run `flutter run` | 2 min |
| **Total** | **~5 minutes** | ✅ |

---

## 🎯 You're Done!

Your Android app should now:
- ✅ Launch without errors
- ✅ Show auth screen
- ✅ Accept phone/email login
- ✅ Authenticate with Supabase
- ✅ Proceed to app

**Ready to deploy? → Read [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)**
