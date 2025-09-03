@echo off
echo ================================================================
echo COMPLETE FRESH DEPLOYMENT - REMOVE OLD CONTAINERS
echo ================================================================
echo This will:
echo 1. Stop and remove ALL old containers (quizpro-*)
echo 2. Clean Docker completely
echo 3. Deploy your latest updated code
echo 4. Use correct container names (quiz-*)
echo 5. Bind to correct ports (3000 for frontend)
echo ================================================================
echo.

echo ⚠️  WARNING: This will completely clean your VM and redeploy
echo    - All old containers will be removed
echo    - All Docker images will be removed
echo    - Fresh deployment from GitHub
echo.

pause

echo Starting fresh deployment...
powershell.exe -ExecutionPolicy Bypass -File "fresh-deploy.ps1"

echo.
echo ================================================================
echo ✅ FRESH DEPLOYMENT COMPLETED!
echo ================================================================
echo.
echo 🔄 IMPORTANT: Clear your browser cache to see the new version
echo    - Press Ctrl+Shift+Delete in your browser
echo    - Or open http://34.0.14.17:3000 in incognito mode
echo.
pause
