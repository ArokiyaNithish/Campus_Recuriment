@echo off
echo ============================================
echo  Campus Recruit - Backend Startup Script
echo ============================================
echo.

:: 1. Add firewall rule for port 8080
echo [1/3] Adding Windows Firewall rule for port 8080...
netsh advfirewall firewall show rule name="Campus Recruit Backend Port 8080" >nul 2>&1
if %errorlevel% neq 0 (
    netsh advfirewall firewall add rule name="Campus Recruit Backend Port 8080" dir=in action=allow protocol=TCP localport=8080
    echo     Firewall rule added!
) else (
    echo     Firewall rule already exists.
)

:: 2. Show local IP
echo.
echo [2/3] Your PC's IP Address for the APK:
echo.
ipconfig | findstr /i "IPv4"
echo.
echo     Use the IP above in your Android APK settings!
echo.

:: 3. Start Spring Boot
echo [3/3] Starting Campus Recruitment Portal backend...
echo     Backend will be available at: http://[YOUR_IP]:8080
echo     (Press Ctrl+C to stop the server)
echo.
cd /d "%~dp0"
mvnw.cmd spring-boot:run -Dspring-boot.run.arguments="--server.address=0.0.0.0"
