# How to Enable Play App Signing

**Date:** December 31, 2025

This is done in **Google Play Console** (not in code). Here's the step-by-step:

---

## Step 1: Go to Play Console

1. Open [Google Play Console](https://play.google.com/console)
2. Select your app (or create a new one)

---

## Step 2: Navigate to App Signing

```
Play Console
└── Your App
    └── Setup (left sidebar)
        └── App signing
```

---

## Step 3: Choose Your Option

You'll see one of two scenarios:

### Scenario A: New App (No uploads yet)

```
┌─────────────────────────────────────────────────────────┐
│  "Use Google Play App Signing"                          │
│                                                          │
│  ○ Let Google manage your app signing key               │  ← Choose this
│  ○ Export and upload a key from Java Keystore           │
│  ○ Export and upload a key from other places            │
└─────────────────────────────────────────────────────────┘
```

**Choose: "Let Google manage your app signing key"**

Then upload your AAB. Done!

### Scenario B: Existing App (Already uploaded with your key)

```
┌─────────────────────────────────────────────────────────┐
│  "Opt in to Play App Signing"                           │
│                                                          │
│  You need to upload your existing app signing key       │
│  so Google can re-sign your app.                        │
└─────────────────────────────────────────────────────────┘
```

You'll need to export your key using PEPK tool (more complex).

---

## Step 4: For New Apps - Just Upload

1. Build your AAB:
   ```bash
   flutter build appbundle --release
   ```

2. Go to **Production** > **Create new release**

3. Upload `app-release.aab`

4. Play Console automatically enables App Signing

---

## What Happens After

| Key | Who Holds It | Purpose |
|-----|--------------|---------|
| **Your Key** (dolfin-ai-keystore.jks) | You | "Upload Key" - proves it's you |
| **Google's Key** | Google | "App Signing Key" - signs final APK |

---

## Benefits You Get

- ✅ Lost your upload key? Google can reset it
- ✅ Key compromise? Google can rotate it
- ✅ Smaller APKs (Google optimizes)
- ✅ Future key upgrades possible
