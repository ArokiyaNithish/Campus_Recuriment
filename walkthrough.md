# 📱 Campus Recruit — Android APK Build & Setup Guide

## Generated App Icon
![Campus Recruit Icon](C:\Users\Arokiya Nithish\.gemini\antigravity\brain\421d944f-ee9e-4be1-83af-bd3964550edd\ic_launcher_1777257018412.png)

---

## ✅ What Was Created

```
android-apk/
├── app/
│   ├── src/main/
│   │   ├── java/com/campus/recruitment/
│   │   │   ├── MainActivity.java       ← WebView app with error screen + settings
│   │   │   └── SplashActivity.java     ← Animated splash screen
│   │   ├── res/
│   │   │   ├── layout/
│   │   │   │   ├── activity_main.xml        ← Main UI with WebView
│   │   │   │   ├── activity_splash.xml      ← Splash screen
│   │   │   │   └── dialog_server_settings.xml ← IP settings dialog
│   │   │   ├── values/
│   │   │   │   ├── strings.xml
│   │   │   │   └── styles.xml
│   │   │   ├── xml/
│   │   │   │   └── network_security_config.xml ← Allows HTTP to local network
│   │   │   └── drawable/
│   │   │       └── ic_launcher.png           ← App icon
│   │   └── AndroidManifest.xml
│   ├── build.gradle
│   └── proguard-rules.pro
├── build.gradle
├── settings.gradle
├── local.properties
└── gradle/wrapper/gradle-wrapper.properties

START_BACKEND.bat   ← One-click backend starter (Run as Administrator!)
```

---

## 🖥️ STEP 1: Start the Backend

> [!IMPORTANT]
> **Right-click** `START_BACKEND.bat` → **"Run as administrator"**
> This opens port 8080 in Windows Firewall and starts Spring Boot.

Your PC's current IP is: **`10.11.236.138`**

If your IP changes (WiFi reconnect), just run the `.bat` again and note the new IP.

---

## 📱 STEP 2: Build the APK

### Option A — Android Studio (Recommended)

1. **Download Android Studio** from: https://developer.android.com/studio
   *(If you already have it, skip this)*

2. Open Android Studio → **"Open"** → select the folder:
   ```
   C:\Users\Arokiya Nithish\OneDrive\Documents\tttt\android-apk\
   ```

3. Wait for Gradle sync to complete (first time ~5 min, downloads dependencies)

4. Go to menu: **Build → Build Bundle(s) / APK(s) → Build APK(s)**

5. APK will be generated at:
   ```
   android-apk\app\build\outputs\apk\debug\app-debug.apk
   ```

6. Click **"locate"** in the notification that appears at the bottom

### Option B — No Android Studio (Command Line)

Open PowerShell in the `android-apk` folder and run:
```powershell
cd "C:\Users\Arokiya Nithish\OneDrive\Documents\tttt\android-apk"
.\gradlew assembleDebug
```
APK will be at `app\build\outputs\apk\debug\app-debug.apk`

> [!NOTE]
> Requires Java JDK installed. Run `java -version` to check.

---

## 📲 STEP 3: Install APK on Your Phone

### Method 1: USB Cable
1. Connect phone via USB
2. Enable **File Transfer / MTP** mode on phone
3. Copy `app-debug.apk` to phone storage
4. Open it from phone's file manager
5. Allow "Install from unknown sources" if prompted

### Method 2: WiFi Transfer (Easier)
1. Upload `app-debug.apk` to Google Drive / WhatsApp to yourself
2. Download and install on phone
3. Allow "Install from unknown sources"

---

## ⚙️ STEP 4: Configure the APK

When the app opens:
1. If it shows **"Connection Failed"** → tap **"Change Server IP"**
2. Enter your PC's IP: **`10.11.236.138`**
3. Tap **"Connect"**

> [!TIP]
> Your phone and PC must be on the **same WiFi network**.
> If they are not, use USB Tethering (see below).

---

## 🔌 USB Tethering Setup (Alternative to WiFi)

If your phone and PC are NOT on the same WiFi:

1. On phone: Settings → **Hotspot & Tethering → USB Tethering** → ON
2. Connect phone to PC via USB
3. On PC, run `ipconfig` to find the new **USB adapter IP** (usually `192.168.x.x`)
4. In the APK, enter that new IP in settings

---

## 🎯 Features of the APK

| Feature | Status |
|---------|--------|
| 🎓 Splash screen with animation | ✅ |
| 🌐 Full WebView (all pages) | ✅ |
| 📁 File upload (resume, photo) | ✅ |
| 🍪 Session / login cookies | ✅ |
| 🔄 Pull-to-refresh | ✅ |
| 🔌 Error screen with retry | ✅ |
| ⚙️ IP settings (configurable) | ✅ |
| 🔙 Back button navigation | ✅ |
| 🌓 Dark splash + blue theme | ✅ |

---

## 🔧 Troubleshooting

| Problem | Solution |
|---------|----------|
| "Connection Failed" | Make sure Spring Boot is running + same WiFi |
| Firewall blocking | Run `START_BACKEND.bat` as Administrator |
| IP changed | Tap ⚙️ in app → update IP |
| File upload not working | Grant storage permissions in phone settings |
| White blank screen | Pull down to refresh |

