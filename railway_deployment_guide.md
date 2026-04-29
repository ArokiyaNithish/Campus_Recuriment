# 🚀 Railway.app Deployment Guide — Campus Recruitment Portal

## What Was Changed in Your Code

| File | Change |
|---|---|
| `pom.xml` | Replaced `mssql-jdbc` → `mysql-connector-j` |
| `application.properties` | SQL Server → MySQL using Railway env variables |
| `Dockerfile` | Multi-stage build (Maven + JDK inside Docker) |
| `.gitignore` | Added proper ignore rules |

---

## STEP 1 — Push Project to GitHub

Open PowerShell in your project folder (`C:\Users\Arokiya Nithish\OneDrive\Documents\tttt`) and run:

```powershell
git add .
git commit -m "Switch to MySQL for Railway deployment"
git push origin main
```

> If you don't have a GitHub repo yet:
> 1. Go to [github.com](https://github.com) → New Repository → Name it `campus-recruitment-portal`
> 2. Copy the remote URL shown
> 3. Run:
> ```powershell
> git remote add origin https://github.com/YOUR_USERNAME/campus-recruitment-portal.git
> git branch -M main
> git push -u origin main
> ```

---

## STEP 2 — Create Railway Account

1. Go to **[railway.app](https://railway.app)**
2. Click **"Start a New Project"**
3. Click **"Login with GitHub"** → Authorize Railway
4. You get **$5 free credit/month** (enough for this project)

---

## STEP 3 — Add MySQL Database

1. In Railway dashboard → Click **"New Project"**
2. Click **"Add a Service"** → Search **"MySQL"**
3. Click **MySQL** → Railway creates the database automatically ✅
4. Click on the MySQL service → Go to **"Variables"** tab
5. Note down these values (you'll need them):
   ```
   MYSQLHOST     = xxx.railway.internal
   MYSQLPORT     = 3306
   MYSQLDATABASE = railway
   MYSQLUSER     = root
   MYSQLPASSWORD = xxxxxxxxxxxxxxx
   ```

---

## STEP 4 — Deploy Your Spring Boot App

1. In the same Railway project → Click **"Add a Service"**
2. Click **"GitHub Repo"**
3. Select your `campus-recruitment-portal` repository
4. Railway detects your `Dockerfile` automatically → Starts building ✅

---

## STEP 5 — Set Environment Variables

Click on your **Spring Boot service** → Go to **"Variables"** tab → Add these:

| Variable Name | Value |
|---|---|
| `MYSQLHOST` | Copy from MySQL service Variables |
| `MYSQLPORT` | `3306` |
| `MYSQLDATABASE` | `railway` |
| `MYSQLUSER` | Copy from MySQL service Variables |
| `MYSQLPASSWORD` | Copy from MySQL service Variables |
| `GEMINI_API_KEY` | Your Gemini API key |
| `MAIL_USERNAME` | `vtu24347@veltech.edu.in` |
| `MAIL_PASSWORD` | `djnwigqixoqxkjlk` |

> ⚠️ **Important**: Click **"Add Reference Variable"** for MySQL variables to directly link the MySQL service values instead of copy-pasting.

---

## STEP 6 — Get Your Public URL

1. Click on your Spring Boot service
2. Go to **"Settings"** tab
3. Click **"Generate Domain"**
4. You get a URL like: `https://campus-recruitment-portal.up.railway.app` ✅

---

## STEP 7 — Verify Deployment

1. Wait for the build to complete (5-10 minutes first time)
2. Click **"View Logs"** to watch the build progress
3. Once you see `Started PortalApplication`, open your URL
4. Login page should appear ✅

---

## STEP 8 — Import Your SQL Data (Optional)

If you want to import existing data, connect MySQL Workbench to Railway MySQL:

```
Host:     MYSQLHOST value from Railway
Port:     MYSQLPORT value from Railway  
Username: MYSQLUSER value from Railway
Password: MYSQLPASSWORD value from Railway
```

Then run your `CampusRecruitment_SSMS.sql` — **but note**: you need to convert SQL Server syntax to MySQL first (Railway auto-creates tables via Hibernate on first boot, so this is optional).

---

## Troubleshooting

| Problem | Solution |
|---|---|
| Build fails | Check logs → likely missing env variable |
| `Access denied for user` | Re-check MYSQLPASSWORD in Variables tab |
| App starts but 500 error | Check if all env variables are set |
| `Port already in use` | Railway handles port automatically, no action needed |

---

## Auto-Deploy (Bonus)

Every time you `git push` to GitHub, Railway **automatically rebuilds and redeploys** your app. 🎉
